<form id="password">
	<fieldset class="forgot-password">
		<div class="password-fail message"></div>
		<h3>Forgot Password</h3>
		<p>Please enter your e-mail address and we will send you a link to reset your password</p>
		<ul>
			<li><label for="sEmail">Email(*)</label><input type="text" name="sEmail" id="sEmail" value=""/><div class="required" title="Please enter a valid e-mail"></div><div class="required invalid-email" title="That e-mail is already in use in the system. Please login or try another e-mail"></div></li>
			<li><button type="button">Reset Password</button></li>
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
