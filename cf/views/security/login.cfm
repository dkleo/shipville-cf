<fieldset class="login">
	<div class="login-fail message"></div>
	<ul>
		<li><label for="sEmail">Email:</label><input type="text" id="sEmail"/></li>
		<li><label for="sPassword">Password:</label><input type="password" id="sPassword"/></li>
		<li><button type="button">Login</button> <br/><a href="/members/?action=user.forgotPassword">Forgot Password?</a></li>
	</ul>
	<!--- // track the real action --->
	<cfoutput><input type="hidden" id="sAction" value="#request.action#"/></cfoutput>
</fieldset>