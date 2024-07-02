package middlewares

import (
	"time"

	"easysplit_server/logger"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

// LoggingMiddleware logs the details of each request
func LoggingMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		startTime := time.Now()

		// Process request
		c.Next()

		// Log request details
		requestID := c.Writer.Header().Get("X-Request-ID")
		sessionID := c.Request.Header.Get("Session-ID")
		logger.Log.WithFields(logrus.Fields{
			"method":     c.Request.Method,
			"endpoint":   c.Request.RequestURI,
			"status":     c.Writer.Status(),
			"client_ip":  c.ClientIP(),
			"latency":    time.Since(startTime),
			"request_id": requestID,
			"session_id": sessionID,
		}).Info("request details")
	}
}
