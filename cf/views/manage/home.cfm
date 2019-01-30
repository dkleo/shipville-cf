<!--- // holds the ID for the user --->
<input type="hidden" id="nUserID" value="#rc.nUserID#"/>
<h3>Welcome to Shipville</h3>
<br/><br/>
<cfoutput>#view("user/shippingInstructions")#</cfoutput>