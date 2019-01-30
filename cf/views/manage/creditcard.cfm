<cfoutput>
	<div id="creditcards">
		<button type="button" class="add">Add New</button>
		<table id="cards">
			<thead>
				<th>Card Number</th>
				<th>Actions</th>
			</thead>
			<tbody>
				<cfloop from="1" to="#arrayLen(rc.arCreditCards)#" index="local.itm">
					<tr>
						<td>Card ends with <span class="card-number">#rc.arCreditCards[local.itm].cardNumber#</span></td>
						<td><button type="button" class="delete" data-sPaymentCardID="#rc.arCreditCards[local.itm].sPaymentCardID#"><img src="/cf/assets/images/delete.png"></button></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</div>
</cfoutput>