package services

import (
	"fmt"
	"io"
	"os"
	"time"

	"easysplit_server/logger"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
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

func (s *S3Service) UploadImage(img io.Reader, path string, format string) (string, error) {
	startTime := time.Now()

	contentType := "image/jpeg"
	dest := path + uuid.New().String() + ".jpeg"

	output, err := s.Uploader.Upload(&s3manager.UploadInput{
		Bucket:             aws.String(s.BucketName),
		Key:                aws.String(dest),
		Body:               img,
		ACL:                aws.String("public-read"),
		ContentType:        aws.String(contentType),
		ContentDisposition: aws.String("inline"),
	})
	if err != nil {
		logger.Log.WithField("error", err.Error()).Error("Failed to upload image to S3")
		return "", fmt.Errorf("failed to upload image to S3: %v", err)
	}

	uploadDuration := time.Since(startTime).Seconds()
	logger.Log.WithFields(map[string]interface{}{
		"location":      output.Location,
		"uploadTimeSec": uploadDuration,
	}).Info("Successfully uploaded image to S3")

	return output.Location, nil
}
