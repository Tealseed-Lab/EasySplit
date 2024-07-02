package services

import (
	"context"
	"easysplit_server/logger"
	"fmt"
	"os"
	"sync"

	vision "cloud.google.com/go/vision/v2/apiv1"
	visionpb "cloud.google.com/go/vision/v2/apiv1/visionpb"
	"google.golang.org/api/option"
)

type VisionService struct {
	Client *vision.ImageAnnotatorClient
}

var (
	client     *vision.ImageAnnotatorClient
	clientOnce sync.Once
)

func NewVisionService() *VisionService {
	client, err := getClient()
	if err != nil {
		logger.Log.Error("Failed to create VisionService")
		panic(fmt.Sprintf("Failed to create VisionService: %v", err))
	}
	logger.Log.Info("Successfully created VisionService")
	return &VisionService{Client: client}
}

func getClient() (*vision.ImageAnnotatorClient, error) {
	var err error
	clientOnce.Do(func() {
		credentialsJSON := os.Getenv("GCP_CREDENTIALS")
		if credentialsJSON == "" {
			logger.Log.Error("GCP_CREDENTIALS environment variable not set")
			err = fmt.Errorf("GCP_CREDENTIALS environment variable not set")
			return
		}
		client, err = vision.NewImageAnnotatorClient(context.Background(), option.WithCredentialsJSON([]byte(credentialsJSON)))
	})
	if err != nil {
		logger.Log.WithField("error", err.Error()).Error("Failed to create Vision API client")
		return nil, fmt.Errorf("failed to create Vision API client: %v", err)
	}
	logger.Log.Info("Successfully created Vision API client")
	return client, nil
}

func (vs *VisionService) DetectTextFromImageURL(imageURL string) (string, error) {
	image := &visionpb.Image{
		Source: &visionpb.ImageSource{
			ImageUri: imageURL,
		},
	}

	request := &visionpb.AnnotateImageRequest{
		Image: image,
		Features: []*visionpb.Feature{
			{
				Type: visionpb.Feature_TEXT_DETECTION,
			},
		},
	}

	batchRequest := &visionpb.BatchAnnotateImagesRequest{
		Requests: []*visionpb.AnnotateImageRequest{request},
	}

	response, err := vs.Client.BatchAnnotateImages(context.Background(), batchRequest)
	if err != nil {
		logger.Log.WithField("error", err.Error()).Error("Google Cloud Vision failed to detect texts")
		return "", fmt.Errorf("failed to detect texts: %v", err)
	}

	var texts []string
	for _, annotation := range response.Responses[0].TextAnnotations {
		texts = append(texts, annotation.Description)
	}

	if len(texts) == 0 {
		logger.Log.Info("No texts detected from the image")
		return "", nil
	}

	logger.Log.Info("Google cloud vision successfully detected texts:", texts)
	return texts[0], nil
}
