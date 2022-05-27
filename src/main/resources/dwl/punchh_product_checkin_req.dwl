%dw 2.0
output application/json skipNullOn = "everywhere"
---
{
	receipt_amount: payload.info.subtotal,
	cc_last4: payload.payment.cardNumber[0][(-4) to (-1)],
	revenue_code: if (payload.info.occasion == Mule::p('occasiontype.carryout')) Mule::p('occasiontype.takeaway') else payload.info.occasion,
	revenue_id: payload.info.channel,
	store_number: payload.store.number,
	menu_items: flatten ((payload.entries filter($.menuItemType == Mule::p('itemtype.prodcut')) map(entry, indexOfEntry ) ->{
	    item_name: entry.productName,
		item_qty: entry.quantity,
		item_amount: entry.totalUnitPrice * entry.quantity,
		menu_item_type: entry.menuItemType,
		menu_family: if (entry.menuFamily != null) (entry.menuFamily joinBy "_") else "",
		menu_item_id: entry.productCode,
		menu_major_group: "",
		serial_number: (entry.entryNumber + 1) as String
	}) ++
	((payload.entries map (entry, indexOfEntry)->
    (
        entry.appliedPunchhPromotions map (promotion,indexOfPromotion)->{
        item_name: promotion.name,
		item_qty: 1,
		item_amount: promotion.discountAmount,
		menu_item_id: entry.productCode default "",
		menu_item_type: Mule::p('itemtype.discount'),
		menu_family: "",
		menu_major_group: "",
		serial_number: (entry.entryNumber+1) ++ "." ++ (indexOfPromotion +1)
        }
    )) default []) ++
	
	(payload.entries map (entry, indexOfEntry) ->
    using (punchhPromoCount = sizeOf(entry.appliedPunchhPromotions default []))
	
	(entry.appliedProductPromotions map ( promotion , indexOfPromotion ) ->{ 
		item_name: promotion.promoName,
		item_qty: 1,
		item_amount: promotion.discountAmount,
		menu_item_id: entry.productCode default "",
		menu_item_type: Mule::p('itemtype.discount'),
		menu_family: "",
		menu_major_group: "",
        serial_number: (entry.entryNumber + 1) ++ "." ++ (punchhPromoCount + indexOfPromotion + 1)
	}) default[]) ++
	
((payload.payment filter($.paymentMethod == Mule::p('paymentmethod')) map( payment , indexOfPayment ) -> {
		item_qty: 1,
		item_name: payment.paymentMethod,
		item_amount: payment.amount,
		menu_item_id: "A" ++ (payment.subscriptionId) default "",
		menu_item_type: Mule::p('itemtype.discount'),
		menu_family: "",
		menu_major_group: ""
	})) default[]),
	subtotal_amount: payload.info.subtotal,
	payable: payload.info.total,
	receipt_datetime: payload.info.submission,
	transaction_no: payload.info.cartId,
	external_uid: payload.info.code
}