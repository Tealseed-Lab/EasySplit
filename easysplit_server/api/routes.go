package api

import (
	"easysplit_server/api/controllers"
	"easysplit_server/api/middlewares"
	"easysplit_server/api/services"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	router := gin.Default()
	router.MaxMultipartMemory = 32 << 20 // 32 MB

	// Apply the request ID middleware
	router.Use(middlewares.RequestIDMiddleware())

	// Apply logging middleware
	router.Use(middlewares.LoggingMiddleware())

	// Apply CORS middleware
	router.Use(cors.New(cors.Config{
		AllowAllOrigins:  true,
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization", "X-Request-ID", "Session-ID"},
		ExposeHeaders:    []string{"Content-Length", "X-Request-ID"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))

	// Initialize services
	s3Service := services.NewS3Service()
	openAIService := services.NewOpenAIService()
	visionService := services.NewVisionService()

	uploadController := controllers.NewUploadController(s3Service, openAIService, visionService)

	// Define routes
	routes_v1 := router.Group("/api/v1")
	{
		routes_v1.POST("/receipts/process", uploadController.UploadAndProcessHandler)
	}

	return router
}
