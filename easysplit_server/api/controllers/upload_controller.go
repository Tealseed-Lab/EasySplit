package controllers

import (
	"bytes"
	"easysplit_server/api/services"

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
	ImageResizer  *services.ImageResizer
}

func NewUploadController(s3Service *services.S3Service, openAIService *services.OpenAIService, visionService *services.VisionService, imageResizer *services.ImageResizer) *UploadController {
	return &UploadController{
		S3Service:     s3Service,
		OpenAIService: openAIService,
		VisionService: visionService,
		ImageResizer:  imageResizer,
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

	startTime := time.Now()

	file, _, err := c.Request.FormFile("receipt_image")
	if err != nil {
		uc.handleError(c, sessionID, http.StatusBadRequest, "FILE_UPLOAD_ERROR", "Failed to get file from request", err)
		return
	}
	defer file.Close()

	fileReadStartTime := time.Now()
	var buf bytes.Buffer
	_, err = io.Copy(&buf, file)
	if err != nil {
		uc.handleError(c, sessionID, http.StatusInternalServerError, "FILE_READ_ERROR", "Failed to read file into buffer", err)
		return
	}

	fileReadTime := time.Now()
	imageBytes := buf.Bytes()
	imageSize := len(imageBytes)
	threshold1 := 500000  // 500 KB, if below no resize
	threshold2 := 2000000 // 2 MB, if below resize for detection, if above resize for upload

	var reader io.Reader
	var format string

	// Start Vision API detection in a goroutine
	visionDetectionChan := make(chan string)
	if imageSize <= threshold1 {
		// Directly use the image for detection and upload
		go uc.detectTextFromImage(imageBytes, visionDetectionChan, sessionID)
		reader = bytes.NewReader(imageBytes)
	} else if imageSize <= threshold2 {
		// Use the original size for detection, but resize for upload
		go uc.detectTextFromImage(imageBytes, visionDetectionChan, sessionID)

		// Resize the image for uploading
		resizedImageBytes, _, err := uc.ImageResizer.DecodeAndResizeImage(imageBytes, 1080)
		if err != nil {
			uc.handleError(c, sessionID, http.StatusInternalServerError, "IMAGE_RESIZE_ERROR", "Failed to decode and resize image", err)
			return
		}
		reader = bytes.NewReader(resizedImageBytes)
	} else {
		// Resize first, then do image detection and upload
		resizedImageBytes, _, err := uc.ImageResizer.DecodeAndResizeImage(imageBytes, 1080)
		if err != nil {
			uc.handleError(c, sessionID, http.StatusInternalServerError, "IMAGE_RESIZE_ERROR", "Failed to decode and resize image", err)
			return
		}

		go uc.detectTextFromImage(resizedImageBytes, visionDetectionChan, sessionID)

		reader = bytes.NewReader(resizedImageBytes)
	}

	s3UploadStartTime := time.Now()
	location, err := uc.S3Service.UploadImage(reader, "uploads/", format)
	if err != nil {
		uc.handleError(c, sessionID, http.StatusInternalServerError, "S3_UPLOAD_ERROR", "Failed to upload image to S3", err)
		return
	}
	s3UploadEndTime := time.Now()

	detectedTexts := <-visionDetectionChan
	visionDetectionTime := time.Now()

	if detectedTexts == "" {
		logger.Log.WithFields(logrus.Fields{
			"session_id": sessionID,
		}).Info("No text detected in image")
		c.JSON(http.StatusOK, gin.H{"data": gin.H{}, "message": "No text detected", "no_text_detected": true})
		return
	}

	// Build and call OpenAI API
	messages := services.BuildOpenAIMessages(detectedTexts)
	startOpenAITime := time.Now()

	response, err := uc.OpenAIService.CallOpenAIAPI(sessionID, messages)
	openAICallDuration := time.Since(startOpenAITime)

	if err != nil {
		uc.handleError(c, sessionID, http.StatusInternalServerError, "OPENAI_API_ERROR", "OpenAI API call failed", err)
		return
	}

	startParseTime := time.Now()
	var parsedResponse map[string]interface{}
	err = services.ParseOpenAIResponse(response, &parsedResponse, location)
	parseResponseDuration := time.Since(startParseTime)

	if err != nil {
		uc.handleError(c, sessionID, http.StatusInternalServerError, "PARSE_RESPONSE_ERROR", "Failed to parse OpenAI response", err)
		return
	}

	totalTime := time.Since(startTime)

	timings := map[string]float64{
		"file_read_time":        fileReadTime.Sub(fileReadStartTime).Seconds(),
		"s3_upload_time":        s3UploadEndTime.Sub(s3UploadStartTime).Seconds(),
		"vision_detection_time": visionDetectionTime.Sub(fileReadTime).Seconds(),
		"openai_call_duration":  openAICallDuration.Seconds(),
		"parse_response_time":   parseResponseDuration.Seconds(),
		"total_time":            totalTime.Seconds(),
	}

	logger.Log.WithFields(logrus.Fields{
		"session_id": sessionID,
		"file_size":  imageSize,
		"timings":    timings,
	}).Info("Image processed successfully")

	c.JSON(http.StatusOK, gin.H{"data": parsedResponse, "message": "Image processed successfully", "location": location})
}

// Detect text from the image using Google Vision API
func (uc *UploadController) detectTextFromImage(imageBytes []byte, ch chan<- string, sessionID string) {
	detectedTexts, err := uc.VisionService.DetectTextFromImage(imageBytes)
	if err != nil {
		logger.Log.WithFields(logrus.Fields{
			"error":      err.Error(),
			"session_id": sessionID,
		}).Error("Failed to detect text from image")
		ch <- ""
		return
	}
	ch <- detectedTexts
}
