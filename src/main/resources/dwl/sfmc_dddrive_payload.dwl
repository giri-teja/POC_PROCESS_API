%dw 2.0
output application/json
---
payload  ++ (if((payload.info.deferred == 'MAKE' and payload.info.status == 'SUBMITTED_TO_STORE_FUTURE'))
				{
					"quotedDeliveryTime"  : payload.info.thirdPartyQuotedDeliveryTime,
					"deliveryTrackingURL" : payload.info.thirdPartyDeliveryTrackingURL,
					"thirdPartyDeliveryId" : payload.info.thirdPartyDeliveryId
				}
			else
				{
					"quotedDeliveryTime"  : (vars.createdeliveryResponse.quoted_delivery_time as DateTime  >> payload.info.created as DateTime {format : "yyyy-MM-dd'T'HH:mm:ssxx"}  as DateTime {format : "xx"})as String {format : "yyyy-MM-dd'T'HH:mm:ssxx"} ,
					"deliveryTrackingURL" : vars.createdeliveryResponse.delivery_tracking_url as String,
					"thirdPartyDeliveryId" : vars.createdeliveryResponse.id
				}
		)