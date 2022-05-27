%dw 2.0
output application/json
---
{
	"merchant_supplied_id" : payload.info.code default "",
	"order_status" : "success",
	"prep_time": (payload.info.promised as DateTime{format:"yyyy-MM-dd'T'HH:mm:ssZ"} >> "UTC") as String {format:"yyyy-MM-dd'T'HH:mm:ss.SSSX"} default ""
}