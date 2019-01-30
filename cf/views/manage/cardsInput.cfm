
<!--- // loop through credit cards --->
<cfloop from="1" to="#arrayLen(rc.arCreditCards)#" index="local.itm">
	<cfoutput><input type="radio" name="sPaymentCardID" id="#rc.arCreditCards[local.itm].sPaymentCardID#" class="inline" value="#rc.arCreditCards[local.itm].sPaymentCardID#"<cfif compareNoCase(rc.sPaymentCardID, rc.arCreditCards[local.itm].sPaymentCardID) eq 0> checked="checked"</cfif>/><div>Card ending with #rc.arCreditCards[local.itm].cardNumber#</div></cfoutput>
</cfloop>
