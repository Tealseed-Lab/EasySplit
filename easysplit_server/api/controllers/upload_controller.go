package controllers

import (
	"bytes"
	"easysplit_server/api/services"
	"image"
	"image/jpeg"
	"image/png"
	"io"
	"net/http"
	"time"

	"easysplit_server/logger"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type UploadController struct {
	S3Service     *services.S3Service
	OpenAIService *services.OpenAIService
	VisionService *services.VisionService
}

func NewUploadController(s3Service *services.S3Service, openAIService *services.OpenAIService, visionService *services.VisionService) *UploadController {
	return &UploadController{
		S3Service:     s3Service,
		OpenAIService: openAIService,
		VisionService: visionService,
	}
}

func (uc *UploadController) handleError(c *gin.Context, sessionID string, statusCode int, errorCode, errorMessage string, err error) {
	logger.Log.WithFields(logrus.Fields{
		"error":      err.Error(),
		"session_id": sessionID,
	}).Error(errorMessage)
	c.JSON(statusCode, gin.H{
		"error":        errorMessage,
		"error_code":   errorCode,
		"error_detail": err.Error(),
	})
}

func (uc *UploadController) UploadAndProcessHandler(c *gin.Context) {
	sessionID := c.Request.Header.Get("Session-ID")

	file, header, err := c.Request.FormFile("receipt_image")
	if err != nil {
		uc.handleError(c, sessionID, http.StatusBadRequest, "FILE_UPLOAD_ERROR", "Failed to get file from request", err)
		return
	}
	defer file.Close()

	logger.Log.WithFields(logrus.Fields{
		"filename":   header.Filename,
		"size":       header.Size,
		"session_id": sessionID,
	}).Info("Uploaded file")

	var buf bytes.Buffer
	n, err := io.Copy(&buf, file)
	if err != nil {
		uc.handleError(c, sessionID, http.StatusInternalServerError, "FILE_READ_ERROR", "Failed to read file into buffer", err)
		return
	}

	logger.Log.WithFields(logrus.Fields{
		"bytes_read":     n,
		"buffer_length":  buf.Len(),
		"buffer_preview": buf.Bytes()[:10],
		"session_id":     sessionID,
	}).Info("Buffer details")

	reader := bytes.NewReader(buf.Bytes())

	var img image.Image
	var format string

	img, format, err = image.Decode(reader)
	if err != nil {
		reader.Seek(0, io.SeekStart)
		img, err = jpeg.Decode(reader)
		if err == nil {
			format = "jpeg"
		} else {
			reader.Seek(0, io.SeekStart)
			img, err = png.Decode(reader)
			format = "png"
			if err != nil {
				uc.handleError(c, sessionID, http.StatusBadRequest, "IMAGE_DECODE_ERROR", "Failed to decode image", err)
				return
			}
		}
	}

	path := "uploads/"
	size := uint(1290)

	location, err := uc.S3Service.UploadImage(img, path, size, format)
	if err != nil {
		uc.handleError(c, sessionID, http.StatusInternalServerError, "S3_UPLOAD_ERROR", "Failed to upload image to S3", err)
		return
	}

	detectedTexts, err := uc.VisionService.DetectTextFromImageURL(location)
	if err != nil {
		logger.Log.WithFields(logrus.Fields{
			"error":      err.Error(),
			"session_id": sessionID,
		}).Error("Failed to detect text from image")
	}

	if detectedTexts == "" {
		logger.Log.WithFields(logrus.Fields{
			"session_id": sessionID,
		}).Info("No text detected in image")
		c.JSON(http.StatusOK, gin.H{"data": gin.H{}, "message": "No text detected", "location": location, "no_text_detected": true})
		return
	}

	logger.Log.WithFields(logrus.Fields{
		"detected_text": detectedTexts,
		"session_id":    sessionID,
	}).Info("Detected text from image")

	messages := services.BuildOpenAIMessages(location, detectedTexts)
	startTime := time.Now()

	response, err := uc.OpenAIService.CallOpenAIAPI(sessionID, messages)
	duration := time.Since(startTime)

	if err != nil {
		uc.handleError(c, sessionID, http.StatusInternalServerError, "OPENAI_API_ERROR", "OpenAI API call failed", err)
		return
	}

	logger.Log.WithFields(logrus.Fields{
		"session_id": sessionID,
		"time_taken": duration.Seconds(),
	}).Info("OpenAI API call succeeded")

	var parsedResponse map[string]interface{}
	err = services.ParseOpenAIResponse(response, &parsedResponse)
	if err != nil {
		uc.handleError(c, sessionID, http.StatusInternalServerError, "PARSE_RESPONSE_ERROR", "Failed to parse OpenAI response", err)
		return
	}

	logger.Log.WithFields(logrus.Fields{
		"session_id": sessionID,
	}).Info("Image processed successfully")

	c.JSON(http.StatusOK, gin.H{"data": parsedResponse, "message": "Image processed successfully", "location": location})
}
