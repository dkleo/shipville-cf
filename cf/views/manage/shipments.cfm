<cfoutput>
	<h4><a href="javascript:;" id="shippingInstructions">Instructions for shipping packages to Shipville</a></h4>
	<div id="shipments">
		<button type="button" class="add">Add New</button>
		<table>
			<thead>
				<th>Status</th>
				<th>From</th>
				<th>Dimensions</th>
				<th>Weight</th>
				<th>Shipping</th>
				<th>Cost</th>
				<th>Created</th>
				<th>Received On</th>
				<th></th>
			</thead>
			<tbody>
				<cfif not arrayLen(rc.arShipments)>
					<tr>
						<td colspan="9"><p>No shipments added yet</p></td>
					</tr>
				</cfif>
				<cfloop from="1" to="#arrayLen(rc.arShipments)#" index="local.itm">
					<tr>
						<td><cfif isNull(rc.arShipments[local.itm].getDTActualShipment())>Pending<cfelse>Shipped</cfif></td>
						<td>#rc.arShipments[local.itm].getSFrom()#</td>
						<td>#rc.arShipments[local.itm].getNHeight()# x #rc.arShipments[local.itm].getNWidth()# x #rc.arShipments[local.itm].getNDepth()#</td>
						<td>#rc.arShipments[local.itm].getNWeight()#<cfif rc.arShipments[local.itm].getSUnit() eq "metric">kg<cfelse>lbs</cfif></td>
						<td><cfif len(rc.arShipments[local.itm].getSFedExShippingOption())>#application.services.shipment.fixShippingLabels(rc.arShipments[local.itm].getSFedExShippingOption())#</cfif></td>
						<td>#rc.arShipments[local.itm].getNCost()#</td>
						<td>#dateFormat(rc.arShipments[local.itm].getDTCreated(), 'yyyy/dd/mm')#</td>
						<td>#dateFormat(rc.arShipments[local.itm].getDTReceived(), 'yyyy/dd/mm')#</td>
						<td class="actions"><button type="button" class="edit" data-nShipmentID="#rc.arShipments[local.itm].getNShipmentID()#"><img src="/cf/assets/images/edit.png"/></button><button type="button" class="delete" data-nShipmentID="#rc.arShipments[local.itm].getNShipmentID()#"><img src="/cf/assets/images/delete.png"/></button></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</div>
</cfoutput>