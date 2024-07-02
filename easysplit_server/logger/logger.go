package logger

import (
	"io"
	"os"
	"path/filepath"
	"time"

	"github.com/sirupsen/logrus"
)

var Log *logrus.Logger

func InitLogger() {
	Log = logrus.New()

	logDir := "logs"
	// Check if the log directory exists, if not create it with 0755 permissions
	if _, err := os.Stat(logDir); os.IsNotExist(err) {
		if err := os.MkdirAll(logDir, 0755); err != nil {
			panic(err)
		}
	}

	// Generate a timestamped log file name
	timestamp := time.Now().Format("20060102150405")
	logFilePath := filepath.Join(logDir, "logs_"+timestamp+".log")
	// Open the log file with 0666 permissions (read and write for everyone)
	file, err := os.OpenFile(logFilePath, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		// If there is an error opening the file, log to stdout
		Log.SetOutput(os.Stdout)
	} else {
		// Log to both the file and the console
		Log.SetOutput(io.MultiWriter(file, os.Stdout))
	}

	// Set log level based on environment
	if os.Getenv("GIN_MODE") == "release" {
		Log.SetLevel(logrus.InfoLevel)
	} else {
		Log.SetLevel(logrus.DebugLevel)
	}

	// Set log format to JSON with a specific timestamp format
	Log.SetFormatter(&logrus.JSONFormatter{
		TimestampFormat: "2006-01-02 15:04:05",
	})
}
