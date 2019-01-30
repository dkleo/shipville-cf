<cfoutput>
	<div id="shipments">
		<select id="sStatus">
			<option value="pending"<cfif compareNoCase(rc.sStatus, "pending") eq 0> selected="selected"</cfif>>Pending</option>
			<option value="received"<cfif compareNoCase(rc.sStatus, "received") eq 0> selected="selected"</cfif>>Received</option>
			<option value="shipped"<cfif compareNoCase(rc.sStatus, "shipped") eq 0> selected="selected"</cfif>>Shipped</option>
		</select>
		<table>
			<thead>
				<th>Status</th>
				<th>ID</th>
				<th>From</th>
				<th>Shipping</th>
				<th>Cost</th>
				<th>Created</th>
				<th>Received On</th>
				<th>Shipped On</th>
				<th></th>
			</thead>
			<tbody>
				<cfif not arrayLen(rc.arShipments)>
					<tr>
						<td colspan="9"><p>No shipments match this status (#rc.sStatus#)</p></td>
					</tr>
				</cfif>
				<cfloop from="1" to="#arrayLen(rc.arShipments)#" index="local.itm">
					<tr>
						<td>#application.services.shipment.getStatus(rc.arShipments[local.itm])#</td>
						<td>#rc.arShipments[local.itm].getsKey()#</td>
						<td>#rc.arShipments[local.itm].getSFrom()#</td>
						<td><cfif len(rc.arShipments[local.itm].getSFedExShippingOption())>#application.services.shipment.fixShippingLabels(rc.arShipments[local.itm].getSFedExShippingOption())#</cfif></td>
						<td><cfif not isNull(rc.arShipments[local.itm].getNCost())>$#rc.arShipments[local.itm].getNCost()#</cfif></td>
						<td>#dateFormat(rc.arShipments[local.itm].getDTCreated(), 'yyyy/dd/mm')#</td>
						<td>#dateFormat(rc.arShipments[local.itm].getDTReceived(), 'yyyy/dd/mm')#</td>
						<td>#dateFormat(rc.arShipments[local.itm].getDTActualShipment(), 'yyyy/dd/mm')#</td>
						<td class="actions"><button type="button" class="edit" data-nShipmentID="#rc.arShipments[local.itm].getNShipmentID()#"><img src="/cf/assets/images/edit.png"/></button><button type="button" class="delete" data-nShipmentID="#rc.arShipments[local.itm].getNShipmentID()#"><img src="/cf/assets/images/delete.png"/></button></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</div>
</cfoutput>