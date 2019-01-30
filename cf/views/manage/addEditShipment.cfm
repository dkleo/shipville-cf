<cfoutput><form id="shipment">
	<fieldset>
		<div class="shipment-status">Status: #application.services.shipment.getStatus(rc.oShipment)#</div>
		#view("manage/estimate_form")#
		<!--- // include actual shipment costs --->
		<cfif rc.oShipment.getDTReceived() gt 0><table>
			<tr>
				<td class="col1">
					<h4>Shipping Costs/Tracking</h4>
					<ul class="narrow-form">	
						<li><label for="nCost">Shipping Cost $</label> #rc.oShipment.getNCost()#</li>
						<li><label for="sTrackingNumber">Tracking Number</label> #rc.oShipment.getSTrackingNumber()#</li>
					</ul>
				</td>
				<td class="col2">
					<h4>Shipping Dates</h4>
					<ul class="narrow-form">	
						<li><label for="nCost">Date Recieved</label> #dateFormat(rc.oShipment.getDTReceived(), 'mm/dd/yyyy')#</li>
						<li><label for="nCost">Date Shipped</label> #dateFormat(rc.oShipment.getDTActualShipment(), 'mm/dd/yyyy')#</li>
					</ul>
				</td>
			</tr>
		</table></cfif>
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
		$.get("/cf/index.cfm?action=manage.cardsInput",
			{
				sPaymentCardID: "#rc.oShipment.getSPaymentCardID()#"
			}, function(sResults){
				$("##cardListing").html(sResults);
			}
		);
	});
</script></cfoutput>