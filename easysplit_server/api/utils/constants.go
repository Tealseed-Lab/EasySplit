package utils

import (
	"github.com/sashabaranov/go-openai"
	"github.com/sashabaranov/go-openai/jsonschema"
)

const (
	OpenAIModelType                        = openai.GPT4o20240806
	OpenAIModelTemperature                 = 0.1
	OpenAIModelTopP                        = 1
	OpenAIModelMaxTokens                   = 2000
	OpenAIChatUserRole                     = "user"
	OpenAIChatSystemRole                   = "system"
	OpenAIChatReceiptText                  = `Make a list of every item in order, with its price (you can omit the items that are free). The receipt may use different terms, such as "Service Fee"/"Svg Chg"/"服务费"/"Tips" for "Service Charge", "Tax"/"税" for "GST", "折扣" for "Discount", "小计" for "Subtotal", "合计" for "Total", please recognize them. Discount should be less than or equal to 0. If there are multiple service charges or discounts, sum them up.`
	OpenAIChatReceiptTextWithDetectedWords = "You could find the items names and prices here: " + OpenAIChatReceiptText
	OpenAIChatSystemContent                = `You will be provided with a receipt photo. The rightmost column should be the prices that matter, there may be other prices on the left indicating what is included. Provide output in JSON format, please don't miss any item!`
)

var (
	OpenAIReceiptJSONSchema = jsonschema.Definition{
		Type: "object",
		Properties: map[string]jsonschema.Definition{
			"items": {
				Type: "array",
				Items: &jsonschema.Definition{
					Type: "object",
					Properties: map[string]jsonschema.Definition{
						"key":  {Type: "integer"},
						"name": {Type: "string"},
						"price": {
							Type: "number",
						},
					},
					Required:             []string{"key", "name", "price"},
					AdditionalProperties: false,
				},
			},
			"additional_charges": {
				Type: "array",
				Items: &jsonschema.Definition{
					Type: "object",
					Properties: map[string]jsonschema.Definition{
						"key": {Type: "integer"},
						"name": {
							Type: "string",
							Enum: []string{"GST", "Service Charge"},
						},
						"amount": {
							Type: "number",
						},
					},
					Required:             []string{"key", "name", "amount"},
					AdditionalProperties: false,
				},
			},
			"additional_discounts": {
				Type: "array",
				Items: &jsonschema.Definition{
					Type: "object",
					Properties: map[string]jsonschema.Definition{
						"key": {Type: "integer"},
						"name": {
							Type: "string",
							Enum: []string{"Discount"},
						},
						"amount": {
							Type: "number",
						},
					},
					Required:             []string{"key", "name", "amount"},
					AdditionalProperties: false,
				},
			},

			"total":      {Type: "number"},
			"language":   {Type: "string"},
			"restaurant": {Type: "string"},
		},
		Required:             []string{"items", "additional_charges", "additional_discounts", "total", "language", "restaurant"},
		AdditionalProperties: false,
	}
)
