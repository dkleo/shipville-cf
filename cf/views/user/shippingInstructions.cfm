<cfoutput>
<div class="shipping-instructions">
<h4>Your mailbox number is: #rc.oUser.getSMailbox()#</h4>
<h4>Shipping Instructions</h4>
<p>Please see below for the proper method of entering your Shipville address into the Ship To details of a merchants checkout when making purchases:</p>
<p>US Address</p>
<table>
	<tr>
		<td>First Name:</td> <td>Your First Name</td>
	</tr>
	<tr>
		<td>Last Name:</td><td>Your Last Name</td>
	</tr>
	<tr>
		<td>Address 1:</td><td>1001 SW 5th Ave ##1100</td>
	</tr>
	<tr>
		<td>Address 2:</td><td>Shipville + Your mailbox number</td>
	</tr>
	<tr>
		<td>City:</td><td>Portland</td>
	</tr>
	<tr>
		<td>State:</td><td>OR</td>
	</tr>
	<tr>
		<td>Zip:</td><td>97204</td>
	</tr>
	<tr>
		<td>Country:</td><td>USA</td>
	</tr>
</table>
</div>
</cfoutput>