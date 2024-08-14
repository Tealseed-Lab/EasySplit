package services

import (
	"context"
	"easysplit_server/api/utils"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"os"
	"time"

	"easysplit_server/logger"

	"github.com/cenkalti/backoff/v4"
	"github.com/sashabaranov/go-openai"
	"github.com/sirupsen/logrus"
)

type OpenAIService struct {
	Client *openai.Client
}

func NewOpenAIService() *OpenAIService {
	apiKey := os.Getenv("OPENAI_API_KEY")
	if apiKey == "" {
		panic("OPENAI_API_KEY environment variable is not set")
	}

	httpClient := &http.Client{
		Timeout: 30 * time.Second, // Set a timeout for the HTTP client
		Transport: &http.Transport{
			MaxIdleConns:        100,
			MaxIdleConnsPerHost: 10,
			IdleConnTimeout:     90 * time.Second,
		},
	}

	config := openai.DefaultConfig(apiKey)
	config.HTTPClient = httpClient

	client := openai.NewClientWithConfig(config)
	return &OpenAIService{Client: client}
}

type ChatMessagePart struct {
	Type     string  `json:"type,omitempty"`
	Text     string  `json:"text,omitempty"`
	ImageURL *string `json:"image_url,omitempty"`
}

type ChatCompletionMessage struct {
	Role         string            `json:"role"`
	Content      string            `json:"content,omitempty"`
	MultiContent []ChatMessagePart `json:"multi_content,omitempty"`
}

func BuildOpenAIMessages(detectedText string) []openai.ChatCompletionMessage {
	userContent := []openai.ChatMessagePart{
		{
			Type: openai.ChatMessagePartTypeText,
			Text: utils.OpenAIChatReceiptTextWithDetectedWords + detectedText,
		},
	}

	return []openai.ChatCompletionMessage{
		{
			Role:    utils.OpenAIChatSystemRole,
			Content: utils.OpenAIChatSystemContent,
		},
		{
			Role:         utils.OpenAIChatUserRole,
			MultiContent: userContent,
		},
	}
}

func (s *OpenAIService) CallOpenAIAPI(sessionID string, messages []openai.ChatCompletionMessage) (string, error) {
	var response string
	var attempt int

	operation := func() error {
		attempt++
		startTime := time.Now() // Capture the start time

		logger.Log.WithFields(logrus.Fields{
			"attempt":    attempt,
			"session_id": sessionID,
		}).Info("Calling OpenAI API")

		req := openai.ChatCompletionRequest{
			Model:    utils.OpenAIModelType,
			Messages: messages,
			ResponseFormat: &openai.ChatCompletionResponseFormat{
				Type: openai.ChatCompletionResponseFormatTypeJSONObject,
			},
			TopP:        utils.OpenAIModelTopP,
			Temperature: utils.OpenAIModelTemperature,
			MaxTokens:   utils.OpenAIModelMaxTokens,
		}

		resp, err := s.Client.CreateChatCompletion(context.Background(), req)
		duration := time.Since(startTime)

		if err != nil {
			logger.Log.WithFields(logrus.Fields{
				"attempt":    attempt,
				"session_id": sessionID,
				"duration":   duration.Seconds(),
				"error":      err.Error(),
			}).Error("Error calling OpenAI API")
			return fmt.Errorf("error calling OpenAI API: %v", err)
		}
		if len(resp.Choices) > 0 {
			response = resp.Choices[0].Message.Content

			// Log the number of responses, attempt number, and token usage
			logger.Log.WithFields(logrus.Fields{
				"num_responses": len(resp.Choices),
				"attempt":       attempt,
				"session_id":    sessionID,
				"input_tokens":  resp.Usage.PromptTokens,
				"output_tokens": resp.Usage.CompletionTokens,
				"total_tokens":  resp.Usage.TotalTokens,
				"duration":      duration.Seconds(),
			}).Info("Successfully received response from OpenAI API")
			return nil
		}

		logger.Log.WithFields(logrus.Fields{
			"attempt":    attempt,
			"session_id": sessionID,
			"duration":   duration.Seconds(), // Log the duration in seconds
		}).Error("No choices returned from OpenAI API")
		return fmt.Errorf("no choices returned from OpenAI")
	}

	backoffPolicy := backoff.WithMaxRetries(backoff.NewExponentialBackOff(), 1)
	err := backoff.Retry(operation, backoffPolicy)
	if err != nil {
		logger.Log.WithFields(logrus.Fields{
			"attempts":   attempt,
			"session_id": sessionID,
			"error":      err.Error(),
		}).Error("Final error after multiple attempts")
		return "", err
	}

	return response, nil
}

func ParseOpenAIResponse(response string, parsedResponse *map[string]interface{}, location string) error {
	// Check if response is a valid JSON string
	if !json.Valid([]byte(response)) {
		return errors.New("response is not a valid JSON string")
	}

	// Unmarshal the response
	if err := json.Unmarshal([]byte(response), parsedResponse); err != nil {
		//log the response
		logger.Log.WithFields(logrus.Fields{
			"response": response,
		}).Error("Failed to parse OpenAI response")
	}

	// Correct the `additional_charges` and `additional_discounts`
	correctResponse(parsedResponse, location)

	return nil
}

func correctResponse(parsedResponse *map[string]interface{}, location string) {
	// Add the location to the response
	(*parsedResponse)["location"] = location

	// Ensure `additional_charges` contains only "Service Charge" and "GST"
	chargesMap := map[string]float64{"Service Charge": 0, "GST": 0}
	if additionalCharges, exists := (*parsedResponse)["additional_charges"].([]interface{}); exists {
		for _, charge := range additionalCharges {
			if chargeMap, ok := charge.(map[string]interface{}); ok {
				name, nameOk := chargeMap["name"].(string)
				amount, amountOk := chargeMap["amount"].(float64)
				if nameOk && amountOk {
					if name == "Service Charge" || name == "GST" {
						chargesMap[name] = amount
					}
				}
			}
		}
	}
	// Rebuild the `additional_charges` array
	newAdditionalCharges := []map[string]interface{}{
		{"key": 1, "name": "Service Charge", "amount": chargesMap["Service Charge"]},
		{"key": 2, "name": "GST", "amount": chargesMap["GST"]},
	}
	(*parsedResponse)["additional_charges"] = newAdditionalCharges

	// Ensure `additional_discounts` contains only "Discount"
	var discountAmount float64
	if additionalDiscounts, exists := (*parsedResponse)["additional_discounts"].([]interface{}); exists {
		for _, discount := range additionalDiscounts {
			if discountMap, ok := discount.(map[string]interface{}); ok {
				name, nameOk := discountMap["name"].(string)
				amount, amountOk := discountMap["amount"].(float64)
				if nameOk && amountOk {
					if name == "Discount" {
						discountAmount = amount
					}
				}
			}
		}
	}
	// Rebuild the `additional_discounts` array
	newAdditionalDiscounts := []map[string]interface{}{
		{"key": 1, "name": "Discount", "amount": discountAmount},
	}
	(*parsedResponse)["additional_discounts"] = newAdditionalDiscounts

	// Check if the additional charges and discounts are already included in item prices
	var total float64
	if items, exists := (*parsedResponse)["items"].([]interface{}); exists {
		for _, item := range items {
			if itemMap, ok := item.(map[string]interface{}); ok {
				if price, priceOk := itemMap["price"].(float64); priceOk {
					total += price
				}
			}
		}
	}
	if total == (*parsedResponse)["total"].(float64) {
		(*parsedResponse)["additional_charges"] = []map[string]interface{}{
			{"key": 1, "name": "Service Charge", "amount": 0},
			{"key": 2, "name": "GST", "amount": 0},
		}
		(*parsedResponse)["additional_discounts"] = []map[string]interface{}{
			{"key": 1, "name": "Discount", "amount": 0},
		}
	} else if additionalDiscounts, exists := (*parsedResponse)["additional_discounts"].([]map[string]interface{}); exists && len(additionalDiscounts) > 0 {
		if total+additionalDiscounts[0]["amount"].(float64) == (*parsedResponse)["total"].(float64) {
			(*parsedResponse)["additional_charges"] = []map[string]interface{}{
				{"key": 1, "name": "Service Charge", "amount": 0},
				{"key": 2, "name": "GST", "amount": 0},
			}
		}
	} else if additionalCharges, exists := (*parsedResponse)["additional_charges"].([]map[string]interface{}); exists && len(additionalCharges) > 0 {
		if total+additionalCharges[0]["amount"].(float64) == (*parsedResponse)["total"].(float64) {
			(*parsedResponse)["additional_discounts"] = []map[string]interface{}{
				{"key": 1, "name": "Discount", "amount": 0},
			}
		}
	}

	// Log the corrected response
	logger.Log.WithFields(logrus.Fields{
		"corrected_response": *parsedResponse,
	}).Info("Corrected OpenAI response")
}
