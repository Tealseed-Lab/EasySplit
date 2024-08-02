package services

import (
	"bytes"
	"fmt"
	"image"
	"io"
	"os"

	"easysplit_server/logger"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
	"github.com/chai2010/webp"
	"github.com/google/uuid"
)

type S3Service struct {
	BucketName string
	Region     string
	AccessKey  string
	SecretKey  string
	Uploader   *s3manager.Uploader
}

func NewS3Service() *S3Service {
	bucketName := os.Getenv("S3_BUCKET_NAME")
	region := os.Getenv("AWS_REGION")
	accessKey := os.Getenv("AWS_ACCESS_KEY_ID")
	secretKey := os.Getenv("AWS_SECRET_ACCESS_KEY")

	if bucketName == "" || region == "" || accessKey == "" || secretKey == "" {
		logger.Log.Error("AWS configuration environment variables are not set")
		panic("AWS configuration environment variables are not set")
	}

	sess, err := session.NewSession(&aws.Config{
		Region:      aws.String(region),
		Credentials: credentials.NewStaticCredentials(accessKey, secretKey, ""),
	})
	if err != nil {
		logger.Log.WithField("error", err.Error()).Error("Failed to create AWS session")
		panic(fmt.Sprintf("Failed to create AWS session: %v", err))
	}

	uploader := s3manager.NewUploader(sess)
	return &S3Service{
		BucketName: bucketName,
		Region:     region,
		AccessKey:  accessKey,
		SecretKey:  secretKey,
		Uploader:   uploader,
	}
}

func DecodeImage(r io.Reader) (image.Image, string, error) {
	return image.Decode(r)
}

func ImageToWebpReader(img image.Image, format string) (io.Reader, string, error) {
	var buf bytes.Buffer
	options := &webp.Options{Lossless: true, Quality: 80}
	err := webp.Encode(&buf, img, options)
	suffix := ".webp"

	if err != nil {
		return nil, suffix, err
	}
	return &buf, suffix, nil
}

func (s *S3Service) UploadImage(img image.Image, path string, format string) (string, error) {
	imgReader, suffix, err := ImageToWebpReader(img, format)
	if err != nil {
		logger.Log.WithField("error", err.Error()).Error("Failed to convert image to WebP")
		return "", fmt.Errorf("failed to convert image to WebP: %v", err)
	}

	contentType := "image/webp"
	dest := path + uuid.New().String() + suffix

	output, err := s.Uploader.Upload(&s3manager.UploadInput{
		Bucket:      aws.String(s.BucketName),
		Key:         aws.String(dest),
		Body:        imgReader,
		ACL:         aws.String("public-read"),
		ContentType: aws.String(contentType),
	})
	if err != nil {
		logger.Log.WithField("error", err.Error()).Error("Failed to upload image to S3")
		return "", fmt.Errorf("failed to upload image to S3: %v", err)
	}

	logger.Log.WithField("location", output.Location).Info("Successfully uploaded image to S3")
	return output.Location, nil
}
