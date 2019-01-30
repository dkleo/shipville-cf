<!--- <div class="tabs">
	<ul>
		<li class="selected" data-content="basic"><a>Basic</a></li>
		<li data-content="silver"><a>Silver</a></li>
		<li data-content="gold"><a>Gold</a></li>
	</ul>
</div>
<div id="tab-content"> --->
	<form id="membership">
	<fieldset>
		<!--- <article id="basic">
			<div class="memberwrap">This is free</div>
			<button type="button" id="basic-membership" class="next-step">Go Basic</button>
		</article>
		<article id="silver">
			<div class="memberwrap">This cost some money</div>
			<button type="button" id="silver-membership" class="next-step">Go Silver</button>
		</article>
		<article id="gold">
			<div class="memberwrap">This cost some more money</div>
			<button type="button" id="gold-membership" class="next-step">Go Gold</button>
		</article> --->
		<table>
			<thead>
				<th></th>
				<th>Standard</th>
				<th>Premium</th>
				<th>Premium + Mail</th>
			</thead>
			<tbody>
				<tr>
					<td colspan="4" class="subheader">Membership Fee</td>
				</tr>
				<tr>
					<td>One-time Setup Fee</td>
					<td class="data first">FREE</td>
					<td class="data">FREE</td>
					<td class="data">FREE</td>
				</tr>
				<tr>
					<td>Monthly<!---/Annual Fee---></td>
					<td class="data first">FREE</td>
					<td class="data">$9.99<!---  -or- $95<br>(save $24.88/year)---></td>
					<td class="data">$19.99<!---  -or- $195<br> (save $44.88/year)---></td>
				</tr>
				<tr>
					<td colspan="4" class="subheader">Features and Rates</td>
				</tr>
				<tr>
					<td>Shipping Rates</td>
					<td class="data first">Good</td>
					<td class="data">Excellent</td>
					<td class="data">Excellent</td>
				</tr>
				<tr>
					<td>Concierge Service Rate</td>
					<td class="data first">5%-10%</td>
					<td class="data">3%-6%</td>
					<td class="data">3%-6%</td>
				</tr>
				<tr>
					<td>Receive Merchandise / Parcels</td>
					<td class="data first">Y</td>
					<td class="data">Y</td>
					<td class="data">Y</td>
				</tr>
				<tr>
					<td>Merchandise / Parcel<br>Consolidation</td>
					<td class="data first">Y</td>
					<td class="data">Y</td>
					<td class="data">Y</td>
				</tr>
				<tr>
					<td>Receive Mail (letters, magazines, catalogs)</td>
					<td class="data first">N</td>
					<td class="data">N</td>
					<td class="data">Y</td>
				</tr>


				<tr>
					<td colspan="4" class="subheader">Additional Features</td>
				</tr>
				<tr>
					<td>Commercial Invoice Preparation</td>
					<td class="data first">Free</td>
					<td class="data">Free</td>
					<td class="data">Free</td>
				</tr>
				<tr>
					<td>Merchandise Repackaging &<br>Consolidation</td>
					<td class="data first">Free</td>
					<td class="data">Free</td>
					<td class="data">Free</td>
				</tr>
				<tr>
					<td>Additional Names</td>
					<td class="data first">Free</td>
					<td class="data">Free</td>
					<td class="data">$20/year per add name</td>
				</tr>
				<tr>
					<td>Insurance (up to $100 declared value)</td>
					<td class="data first">Free</td>
					<td class="data">Free</td>
					<td class="data">Free</td>
				</tr>
				<tr>
					<td>Additional Insurance (per each $100)</td>
					<td class="data first">$2</td>
					<td class="data">$2</td>
					<td class="data">$2</td>
				</tr>
				<tr>
					<td>Free Merchandise Storage</td>
					<td class="data first">5 days</td>
					<td class="data">30 days</td>
					<td class="data">30 days</td>
				</tr>
				<tr>
					<td>Daily Storage Fee</td>
					<td class="data first">$1/box after 5 days</td>
					<td class="data">$1/box after 30 days</td>
					<td class="data">$1/box after 30 days</td>
				</tr>
				<tr>
					<td>Courier Fuel Surcharge</td>
					<td class="data first">0%</td>
					<td class="data">0%</td>
					<td class="data">0%</td>
				</tr>
				<tr>
					<td>100% Shipment Track</td>
					<td class="data first">Y</td>
					<td class="data">Y</td>
					<td class="data">Y</td>
				</tr>
				<tr>
					<td>Online Account Management</td>
					<td class="data first">Y</td>
					<td class="data">Y</td>
					<td class="data">Y</td>
				</tr>
				<tr>
					<td>Flexible Shipping Options</td>
					<td class="data first">Y</td>
					<td class="data">Y</td>
					<td class="data">Y</td>
				</tr>
				<tr>
					<td>Additional Names on Account</td>
					<td class="data first">Y</td>
					<td class="data">Y</td>
					<td class="data">Y</td>
				</tr>
				<tr>
					<td>Form 1583 and Photo ID Required</td>
					<td class="data first">N</td>
					<td class="data">N</td>
					<td class="data">Y</td>
				</tr>
				<tr>
					<td>Scan Merchant Invoice</td>
					<td class="data first">$1</td>
					<td class="data">$1</td>
					<td class="data">$1</td>
				</tr>
				<tr>
					<td>Discard Merchant Invoice</td>
					<td class="data first">$2</td>
					<td class="data">$2</td>
					<td class="data">$2</td>
				</tr>
				<tr>
					<td></td>
					<td class="data first"><button type="button" data-id="1" id="basic-membership">Go Standard</button></td>
					<td class="data"><button type="button" data-id="2" id="silver-membership">Go Premium</button></td>
					<td class="data"><button type="button" data-id="3" id="gold-membership">Go Premium+Mail</button></td>
				</tr>
			</tbody>
		</table>
		<div class="hide"><button type="button" class="next-step"/></div>
		<input type="hidden" name="nMembership" id="nMembership" value="1">
	</fieldset>
	</form>
</div>

<!--- <script>
	// bind the tabs
	$(".tabs").daTabs();
	// determine which tab should be selected
</script> --->