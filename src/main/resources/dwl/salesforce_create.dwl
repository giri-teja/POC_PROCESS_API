%dw 2.0
output application/json
input payload application/json
fun sourceguestresolver(payload) = (if(payload.info.channel == p('channel.mobile')) p('source.mobile') else (if(payload.info.channel == p('channel.oms')) p('source.oms') else p('source.web')))
fun customerguestresolver(payload) = (if(payload.info.channel == p('channel.mobile')) p('source.mobile') else (if(payload.info.channel == p('channel.oms')) p('source.oms') else p('source.web')))
fun sourceregisteredresolver(payload) = (if(payload.info.channel == p('channel.mobile')) p('customer.mobile') else (if(payload.info.channel == p('channel.oms')) p('customer.oms') else p('customer.web')))
---
{
  "subscriptions": flatten ([
    if(payload.contactInfo.emailOptIn == true) ({
      "name": p('emailOptIn.subscription'),
      "isSubscribed": true,
      "source": if(vars.cid == "" or vars.cid == null) sourceguestresolver(payload) else sourceregisteredresolver(payload)
    }) else [],
    if(payload.contactInfo.smsOptIn == true) ({
      "name": p('smsOptIn.subscription'),
      "isSubscribed": true,
      "source": if(vars.cid == "" or vars.cid == null) sourceguestresolver(payload) else sourceregisteredresolver(payload)
    }) else [] 
  ]),
  "customerSource":  if(vars.cid == "" or vars.cid == null) customerguestresolver(payload) else "",
  "phone": payload.contactInfo.phoneNumber default "",
  "lastName": payload.contactInfo.lastName default "",
  "gender": null,
  "firstName": payload.contactInfo.firstName default "",
  "email": payload.contactInfo.emailId default "",
  "birthdate": "",
  "orderData": {
  	 "orderChannel"  : payload.info.channel default "",
  	 "orderDateTime" : payload.info.created as String default ""
  }
  }