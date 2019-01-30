<cfif rc.bUserVerified>
<h2>Verified!</h2>
<div>Thank you for verifying your account. You can now login: <cfoutput><a href="http://www.shipville.com/members/?action=manage.home">Go Login</a></cfoutput>
<cfswitch expression="#rc.oUser.getNMembership()#">
	<cfcase value="2">
		<h4>Notice: Your credit card on file will be charged $9.99 for your monthly membership</h4>
	</cfcase>
	<cfcase value="3">
		<h4>Notice: Your credit card on file will be charged $19.99 for your monthly membership.</h4>
	</cfcase>
</cfswitch>
<cfoutput><br/><br/>#view("user/shippingInstructions")#</cfoutput>
</div>
<cfelse>
<h2>Error verifying account</h2>
<div>There was an error verifying your account. <cfoutput>#rc.sMessage#</cfoutput>. Please contact support: <a href="mailto:support@shipville.com">E-mail</a></div>
</cfif>
