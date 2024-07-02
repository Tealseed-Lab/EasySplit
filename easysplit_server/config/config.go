package config

import (
	"easysplit_server/logger"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	ServerPort         string
	OpenAIAPIKey       string
	AWSAccessKeyID     string
	AWSSecretAccessKey string
	S3BucketName       string
	AWSRegion          string
	// Add other configuration fields as needed
}

var AppConfig Config

func LoadConfig() {

	// Load .env file only if it exists, for local development
	if _, err := os.Stat(".env"); err == nil {
		err := godotenv.Load()
		if err != nil {
			logger.Log.Warn("Warning: Error loading .env file")
		}
	} else {
		logger.Log.Warn("Warning: .env file not found, skipping")
	}

	AppConfig = Config{
		ServerPort:         getEnv("PORT", "8080"),
		OpenAIAPIKey:       getEnv("OPENAI_API_KEY", ""),
		AWSAccessKeyID:     getEnv("AWS_ACCESS_KEY_ID", ""),
		AWSSecretAccessKey: getEnv("AWS_SECRET_ACCESS_KEY", ""),
		S3BucketName:       getEnv("S3_BUCKET_NAME", ""),
		AWSRegion:          getEnv("AWS_REGION", ""),
	}
}

// Helper function to read an environment variable or return a default value
func getEnv(key, defaultValue string) string {
	value, exists := os.LookupEnv(key)
	if !exists {
		return defaultValue
	}
	return value
}
