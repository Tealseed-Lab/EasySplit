package main

import (
	"context"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"easysplit_server/api"
	"easysplit_server/config"
	"easysplit_server/logger"

	"github.com/gin-gonic/gin"
)

func main() {
	// Initialize logger
	logger.InitLogger()

	// Load configuration
	config.LoadConfig()

	// Set Gin to release mode
	gin.SetMode(gin.ReleaseMode)

	// Set up the router with routes and middleware
	router := api.SetupRouter()

	// Start the server using Gin's Run method
	go func() {
		logger.Log.Info("Starting the server on port:" + config.AppConfig.ServerPort)
		if err := router.Run(":" + config.AppConfig.ServerPort); err != nil {
			logger.Log.Fatalf("Failed to start server: %v", err)
		}
	}()

	// Graceful shutdown
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	logger.Log.Info("Shutting down server.")

	// Create a context with a timeout
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// Retrieve the underlying http.Server from Gin
	server := &http.Server{
		Addr:    ":" + config.AppConfig.ServerPort,
		Handler: router,
	}

	// Shutdown the server with the created context
	if err := server.Shutdown(ctx); err != nil {
		logger.Log.Error("Server forced to shutdown:", err)
	}

	logger.Log.Info("Server exiting")
}
