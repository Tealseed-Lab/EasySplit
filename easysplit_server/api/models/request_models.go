package models

type OpenAIRequest struct {
	Prompt string `json:"prompt" binding:"required"`
}
