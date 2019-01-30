<cfoutput><form id="shipment">
	<fieldset>
		<div class="shipment-status">Status: #application.services.shipment.getStatus(rc.oShipment)#</div>
		#view("manage/estimate_form")#
		<!--- // include actual shipment costs --->
		<table>
			<tr>
				<td class="col1">
					<h4>Shipping Costs/Tracking</h4>
					<ul class="narrow-form">	
						<li><label for="nCost">Shipping Cost $</label><input type="text" name="nCost" id="nCost" value="#rc.oShipment.getNCost()#" class="short"/></li>
						<li><label for="sTrackingNumber">Tracking Number</label><input type="text" name="sTrackingNumber" id="sTrackingNumber" value="#rc.oShipment.getSTrackingNumber()#" class="medium"/></li>
					</ul>
				</td>
				<td class="col2">
					<h4>Shipping Dates</h4>
					<ul class="narrow-form">	
						<li><label for="nCost">Date Recieved</label><input type="text" name="dtReceived" id="dtReceived" value="#dateFormat(rc.oShipment.getDTReceived(), 'mm/dd/yyyy')#" class="short"/></li>
						<li><label for="nCost">Date Shipped</label><input type="text" name="dtActualShipment" id="dtActualShipment" value="#dateFormat(rc.oShipment.getDTActualShipment(), 'mm/dd/yyyy')#" class="short"/></li>
					</ul>
				</td>
			</tr>
		</table>
		<div class="clear-float">
			<cfif isNull(rc.oShipment.getNCost())><button id="save" type="button">Save</button></cfif><button id="cancel" type="button">Cancel</button>
			<input type="hidden" name="nShipmentID" id="nShipmentID" value="#rc.oShipment.getNShipmentID()#"/>
		</div>
	</fieldset>
</form>
<script>
	$(function(){
		// load the validation for this form
		loadValidation();
		setTimeout( function(){ $("##sFrom").focus(); }, 100);
		// load the credit card info
		$.get("/cf/index.cfm?action=admin.getCardInfo",
			{
				sPaymentCardID: "#rc.oShipment.getSPaymentCardID()#",
				sPaymentID: "#rc.oUser.getSPaymentID()#"
			}, function(sResults){
				if( typeof sResults.cardNumber == "string" ){
					sHTML = "Card ending in" + sResults.cardNumber;
				} else {
					sHTML = "Error retrieving credit card";
				}
				$("##cardListing").html(sHTML);
			}, "json"
		);
	});
</script></cfoutput>