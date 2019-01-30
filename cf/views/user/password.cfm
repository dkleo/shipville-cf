<cfif rc.oUser.getNUserID() gt 0>
	<form id="password">
		<fieldset class="password">
			<div class="password-fail message"></div>
			<h3>Password Reset</h3>
			<ul>
				<li><label for="sPassword">Password(*)</label><input type="password" name="sPassword" id="sPassword" value=""/><div class="required" title="Please enter a valid password"></div></li>
				<li><label for="sConfirm">Confirm(*)</label><input type="password" id="sConfirm" value=""/><div class="required" title="Passwords do not match"></div></li>
				<li><button type="button">Reset</button></li>
			</ul>
			<cfoutput><input type="hidden" id="nID" value="#rc.oUser.getNUserID()#"/></cfoutput>
		</fieldset>
	</form>
	<script>
		$(function(){
			// load the validation for this form
			loadValidation("password");
			setTimeout( function(){ $("#sPassword").focus(); }, 100);
		});
	</script>
<cfelse>
	<h3>Sorry there was an error with your request, please try again</h3>
</cfif>