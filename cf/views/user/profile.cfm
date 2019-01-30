<form id="profile">
<fieldset>
		<ul>
			<li><label for="sFirstName">First Name(*)</label><input type="text" name="sFirstName" id="sFirstName" value=""/><div id="cool-tip" class="required" title="Please enter a valid first name"></div></li>
			<li><label for="sLastName">Last Name(*)</label><input type="text" name="sLastName" id="sLastName" value=""/><div class="required" title="Please enter a valid last name"></div></li>
			<li><label for="sEmail">Email(*)</label><input type="text" name="sEmail" id="sEmail" value=""/><div class="required" title="Please enter a valid e-mail"></div><div class="required invalid-email" title="That e-mail is already in use in the system. Please login or try another e-mail"></div></li>
			<li><label for="sPhone">Phone(*)</label><input type="text" name="sPhone" id="sPhone" value=""/><div class="required" title="Plese provide a valid phone number"></div></li>
			<li><label for="sPassword">Password(*)</label><input type="password" name="sPassword" id="sPassword" value=""/><div class="required" title="Please enter a valid password"></div></li>
			<li><label for="sConfirm">Confirm(*)</label><input type="password" id="sConfirm" value=""/><div class="required" title="Passwords do not match"></div></li>
			<li><label for="sAddress">Address(*)</label><input type="text" name="sAddress" id="sAddress" value="" class="long"/><div class="required" title="Please enter a valid Address"></div></li>
			<li><label for="sAddress2">Address2</label><input type="text" name="sAddress2" id="sAddress2" value="" class="long"/></li>
			<li><label for="sCity">City(*)</label><input type="text" name="sCity" id="sCity" value=""/><div class="required" title="Please enter a valid city"></div></li>
			<li><label for="sState">State/Province/Region(*)</label><input type="text" name="sState" id="sState" value="" class="short" maxlength="40"/><div class="required" title="Please enter a valid state/province/region"></div>(e.g. Oregon = OR)</li>
			<li><label for="sZipCode">Zip Code/Postal Code(*)</label><input type="text" name="sZipCode" id="sZipCode" value=""/><div class="required" title="Please enter a valid zip code/postal code"></div></li>
			<li><label for="sCountry">Country(*)</label><select size="1" name="sCountry" id="sCountry"><cfoutput>#view("user/country")#</cfoutput></select><div class="required" title="Please enter a valid country"></div></li>
		</ul>
		<button type="button" class="next-step">Next Step: Credit Card</button>
		<!--- // hidden id --->
		<input type="hidden" name="nID" value=""/>
</fieldset>
</form>
<script>
	$(function(){
		// load the validation for this form
		loadValidation("profile");
		setTimeout( function(){ $("#sFirstName").focus(); }, 100);
	});
</script>