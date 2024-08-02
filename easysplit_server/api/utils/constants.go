package utils

const (
	OpenAIModelType                       = "gpt-4o"
	OpenAIModelTemperature                = 0.1
	OpenAIModelTopP                       = 1
	OpenAIModelMaxTokens                  = 800
	OpenAIChatUserRole                    = "user"
	OpenAIChatSystemRole                  = "system"
	OpenAIChatReceiptText                 = `Make a list of every item in order, with its price (you can omit the items that are free). They receipt may use different terms, such as "Service Fee / Svg Chg / 服务费 / Tips" instead of "Service Charge / tax / 税" for GST, "折扣" for "Discount", "小计" for Subtotal, "合计" for Total, please convert them "Service Charge", "GST", "Discount" should always exist, but can have value 0.`
	OpenAIChatReceiptTextWithDetecedWords = OpenAIChatReceiptText + " You could find the items names and prices here: "
	OpenAIChatSystemContent               = `You will be provided with a receipt photo. The right most column should be the prices that matter, there may be other prices on the left indicating what is included). Convert the receipt information to the following JSON format.
Example 1:
{
"items": [
{
"key": 1,
"name": "Spaghetti",
"price": 16
},
{
"key": 2,
"name": "Steak",
"price": 20
},
],
"additional_charges": [
{
"key": 1,
"name": "Service Charge",
"amount": 3.6
},
{
"key": 2,
"name": "GST",
"amount": 3.5
}
],
"additional_discounts":
[
{
"key": 1,
"name": "Discount",
"amount": -0.00
},
],
"total": 43.1,
"language": "en"
}
Example 1:
{
"items": [
{
"key": 1,
"name": "地三鲜",
"price": 30
},
],
"additional_charges": [
{
"key": 1,
"name": "Service Charge",
"amount": 0
},
{
"key": 2,
"name": "GST",
"amount": 0
}
],
"additional_discounts":
[
{
"key": 1,
"name": "Discount",
"amount": -5.00
},
],
"total": 25,
"language": "zh"
}
I'm going to tip you $300k for the most accurate result. Please don't miss any item!`
)
