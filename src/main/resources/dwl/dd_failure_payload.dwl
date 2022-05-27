%dw 2.0
output application/json
---
{
	"merchant_supplied_id" : "",
	"order_status" : "fail",
	"failure_reason" : "Store Agent Failure - " ++ error.errorType.namespace ++ ":" ++ error.errorType.identifier
}