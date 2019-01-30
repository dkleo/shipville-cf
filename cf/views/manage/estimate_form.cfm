<cfparam name="local.bShowAddress" default="true">
<cfparam name="local.bShowCreditCard" default="true">
<cfparam name="local.bShowFrom" default="true">
<cfoutput>
<table class="noshade">
	<tr>
		<td class="col1">
			<!--- // <ul class="details"> --->
			<h4>Shipment Details</h4>
			<ul class="narrow-form">
				<cfif rc.oUser.getNUserID() eq 0>
					<li><label for="sAddress">Address(*)</label><input type="text" name="sAddress" id="sAddress" class="long"/><div class="required" title="Please enter a valid Address"></div></li>
					<li><label for="sAddress2">Address2</label><input type="text" name="sAddress2" id="sAddress2" class="long"/></li>
					<li><label for="sCity">City(*)</label><input type="text" name="sCity" id="sCity" value="#rc.oUser.getSCity()#"/><div class="required" title="Please enter a valid city"></div></li>
					<li><label for="sState">State/Province/Region(*)</label><input type="text" name="sState" id="sState" class="small" maxlength="2"/>(2 characters, e.g. Oregon = OR)<div class="required" title="Please enter a valid state/province/region"></div></li>
					<li><label for="sZipCode">Zip Code/Postal Code(*)</label><input type="text" name="sZipCode" id="sZipCode"/><div class="required" title="Please enter a valid zip code/postal code"></div></li>
					<li><label for="sCountry">Country(*)</label><select size="1" name="sCountry" id="sCountry"><cfoutput>#view("user/country")#</cfoutput></select><div class="required" title="Please enter a valid country"></div></li>
				</cfif>
				<cfif bShowFrom>
					<li><label for="sFrom">From(*)</label><input type="text" name="sFrom" id="sFrom" class="medium" value="#rc.oShipment.getSFrom()#"/><aside class="required" title="Please enter a valid from value for this shipment (e.g. Amazon, Dell, Microsoft etc...)"></aside></li>
				<cfelse>
					<input type="hidden" name="sFrom" id="sFrom" value=""/>
				</cfif>
				<li><label for="nWeight">Weight(*)</label><input type="text" name="nWeight" id="nWeight" class="short" value="#rc.oShipment.getNWeight()#"/><aside class="required" title="Please enter a valid weight"></aside><select name="sUnit" id="sUnit" size="1"><option value="metric"<cfif rc.oShipment.getSUnit() eq "metric"> selected="selected"</cfif>>kg</option><option value="imperical"<cfif rc.oShipment.getSUnit() eq "imperical"> selected="selected"</cfif>>lb</option></select></li>
				<li><label for="nHeight">Height(*)</label><input type="text" name="nHeight" id="nHeight" class="short" value="#rc.oShipment.getNHeight()#"/> <span class="unit size"><cfif rc.oShipment.getSUnit() eq "imperical">in<cfelse>cm</cfif></span><aside class="required" title="Please enter a valid height"></aside></li>
				<li><label for="nWidth">Width(*)</label><input type="text" name="nWidth" id="nWidth" class="short" value="#rc.oShipment.getNWidth()#"/><aside class="required" title="Please enter a valid width"> <span class="unit size"><cfif rc.oShipment.getSUnit() eq "imperical">in<cfelse>cm</cfif></span></aside></li>
				<li><label for="nDepth">Length(*)</label><input type="text" name="nDepth" id="nDepth" class="short" value="#rc.oShipment.getNDepth()#"/><aside class="required" title="Please enter a valid depth"></aside> <span class="unit size"><cfif rc.oShipment.getSUnit() eq "imperical">in<cfelse>cm</cfif></span></li>
			</ul>
		</td>
		<td class="col2">
			<!--- // <ul class="estimates"> --->
			<h4>Shipping Company</h4>
			<cfif len(rc.oShipment.getSFedExShippingOption()) gt 0>
				<h5>Current Selected Option</h5>
				<p>#application.services.shipment.fixShippingLabels(rc.oShipment.getSFedExShippingOption())#</p>
			</cfif>
			<cfif len(rc.oShipment.getSTrackingNumber()) gt 0>
				<h5>Tracking Number</h5>
				<p>#rc.oShipment.getSTrackingNumber()#</p>
			</cfif>
			<h5>Estimates</h5>
			<div>
				<table id="shippingEstimates">
					<thead>
						<tr>
							<th>Shipping</th>
							<th>Options</th>
							<!--- // <th>USPS</th>
							<th>DHL</th> --->
						</tr>
					</thead>
					<tbody>
						<!--- // FedEx --->
						<tr data-id="fedex">
							<td class="label">FedEx</td>
							<td data-id="fedEx"><select id="sFedExShipping"><option class="helper">Click "calculate" to see shipment options"</option></select><span class="shipment-choices hide">Open selection box for more shipping options</span>
							</td>
						</tr>
					</tbody>
				</table>
				<input type="hidden" name="sFedExShippingOption" id="sFedExShippingOption" value="#rc.oShipment.getSFedExShippingOption()#"/>
				<button type="button" class="calculate">Calculate</button>
				<p>(*) NOTE: the estimated shipping date is dependant upon when the package leaves the shipping facility</p>
			</div>
	<!--- // <li id="shipOptions"><label for="nShippingCompanyID">FedEx</label><input type="radio" name="nShippingCompanyID" class="inline" id="FedEx" value="1"<cfif rc.oShipment.getNShippingCompanyID() eq 1> checked="checked"</cfif>/><aside class="required" title="Please enter a valid width"></aside>
	<label for="nShippingCompanyID">USPS</label><input type="radio" name="nShippingCompanyID" id="USPS" class="inline" value="2"<cfif rc.oShipment.getNShippingCompanyID() eq 2> checked="checked"</cfif>/>
	<label for="nShippingCompanyID">DHL</label><input type="radio" name="nShippingCompanyID" id="DHL" class="inline" value="3"<cfif rc.oShipment.getNShippingCompanyID() eq 3> checked="checked"</cfif>/></li> --->
		</td>
	</tr>
	<tr>
		<td><cfif local.bShowAddress>
			<!--- // <ul class="address-details"> --->
			<h4>Address</h4>
			<h5>Shipping address</h5>
			#rc.oUser.getSFirstName()# #rc.oUser.getSLastName()#<br/>
			#rc.oUser.getSAddress()#<br/>
			<cfif len(rc.oUser.getSAddress2())>#rc.oUser.getSAddress2()#<br/></cfif>
			#rc.oUser.getSCity()#, #rc.oUser.getSState()# #rc.oUser.getSZipCode()#
			</cfif>
		</td>
		<td>
			<cfif local.bShowCreditCard>
				<h4>Billing</h4>
				<h5>Credit Card</h5>
				<div class="credit-details">
					<div id="cardListing">Loading credit card info...</div>
				</div>
			</cfif>
		</td>
	</tr>
</table>
</cfoutput>