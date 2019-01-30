<form id="confirm">
<fieldset>
	<article>
		<h4>current membership info [<a data-pane="membership" class="change-data">change</a>]</h4>
		<ul>
			<li><label class="confirm" data-field="nMembership"></label><div class="confirm">&nbsp;</div></li>
		</ul>
	</article>

	<article role="profile">
		<h4>current profile info [<a data-pane="profile" class="change-data">change</a>]</h4>
		<ul>
			<li><label>First Name: </label><div class="confirm" data-field="sFirstName">&nbsp;</div></li>
			<li><label>Last Name: </label><div class="confirm" data-field="sLastName">&nbsp;</div></li>
			<li><label>Email (username): </label><div class="confirm" data-field="sEmail">&nbsp;</div></li>
			<li><label>Phone: </label><div class="confirm" data-field="sPhone">&nbsp;</div></li>
			<li><label>Address: </label><div class="confirm" data-field="sAddress">&nbsp;</div></li>
			<li><label>Address2: </label><div class="confirm" data-field="sAddress2">&nbsp;</div></li>
			<li><label>City: </label><div class="confirm" data-field="sCity">&nbsp;</div></li>
			<li><label>State/Province/Region: </label><div class="confirm" data-field="sState">&nbsp;</div></li>
			<li><label>Zip Code/Postal Code: </label><div class="confirm" data-field="sZipCode">&nbsp;</div></li>
			<li><label>Country: </label><div class="confirm" data-field="sCountry">&nbsp;</div></li>
		</ul>
	</article>

	<article>
		<h4>current financial info [<a data-pane="financial" class="change-data">change</a>]</h4>
		<ul>
			<li><label>Name on Card: </label><div class="confirm" data-field="sNameOnCard">&nbsp;</div></li>
			<li><label>Card Number: </label><div class="confirm" data-field="sCardNumber">&nbsp;</div></li>
			<li><label>Expiration Month: </label><div class="confirm" data-field="sExpirationMonth">&nbsp;</div></li>
			<li><label>Expiration Year: </label><div class="confirm" data-field="sExpirationYear">&nbsp;</div></li>
			<li><label>CCV: </label><div class="confirm" data-field="sCCV">&nbsp;</div></li>
		</ul>
	</article>
	
	<div id="terms"><cfoutput>#view("user/terms")#</cfoutput></div>
	<label for ="agree">I agree to the above Terms and Conditions</label><input type="checkbox" id="agree"/>
	<button type="button" class="next-step">Complete</button>
	<input type="hidden" id="userCreated" value="0"/>
</fieldset>
</form>