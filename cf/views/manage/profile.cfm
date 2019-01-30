<cfoutput>
<form id="profile"><fieldset>
		<ul>
			<li><label for="sFirstName">First Name(*)</label><input type="text" name="sFirstName" id="sFirstName" value="#rc.oUser.getSFirstName()#"/><div class="required" title="Please enter a valid first name"></div></li>
			<li><label for="sLastName">Last Name(*)</label><input type="text" name="sLastName" id="sLastName" value="#rc.oUser.getSLastName()#"/><div class="required" title="Please enter a valid last name"></div></li>
			<!--- // <li><label for="sEmail">Email(*)</label><input type="text" name="sEmail" id="sEmail" value="#rc.oUser.getSEmail()#"/><div class="required" title="Please enter a valid e-mail"></div><div class="required invalid-email" title="That e-mail is already in use in the system. Please login or try another e-mail"></div></li> --->

			<li><label for="sPhone">Phone</label><input type="text" name="sPhone" id="sPhone" value="#rc.oUser.getSPhone()#"/></li>
			<!--- // <li><label for="sPassword">Password(*)</label><input type="password" name="sPassword" id="sPassword" value="#rc.oUser.getSPassword()#"/><div class="required" title="Please enter a valid password"></div></li>
			<li><label for="sConfirm">Confirm(*)</label><input type="password" id="sConfirm" value="#rc.oUser.getSPassword()#"/><div class="required" title="Passwords do not match"></div></li> --->
			<li><label for="sAddress">Address(*)</label><input type="text" name="sAddress" id="sAddress" value="#rc.oUser.getSAddress()#" class="long"/><div class="required" title="Please enter a valid Address"></div></li>
			<li><label for="sAddress2">Address2</label><input type="text" name="sAddress2" id="sAddress2" value="#rc.oUser.getSAddress2()#" class="long"/></li>
			<li><label for="sCity">City(*)</label><input type="text" name="sCity" id="sCity" value="#rc.oUser.getSCity()#"/><div class="required" title="Please enter a valid city"></div></li>
			<li><label for="sState">State/Province/Region(*)</label><input type="text" name="sState" id="sState" value="#rc.oUser.getSState()#" class="short" maxLength="2"/><div class="required" title="Please enter a valid state/province/region"></div>(2 characters e.g. Oregon = OR)</li>
			<li><label for="sZipCode">Zip Code/Postal Code(*)</label><input type="text" name="sZipCode" id="sZipCode" value="#rc.oUser.getSZipCode()#"/><div class="required" title="Please enter a valid zip code/postal code"></div></li>
			<li><label for="sCountry">Country(*)</label><select size="1" name="sCountry" id="sCountry">#view("user/country")#</select><div class="required" title="Please enter a valid country"></div></li>
		</ul>
		<button type="button" class="save">Save</button>
		<!--- // hidden id --->
		<input type="hidden" name="nID" value=""/>
</fieldset></form></cfoutput>
<script>
	$(function(){
		// load the validation for this form
		loadValidation($("#profile"));
		setTimeout( function(){ $("#sFirstName").focus(); }, 100);
	});
</script>