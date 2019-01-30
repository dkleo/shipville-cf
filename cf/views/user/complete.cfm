<div id="accountStatus"></div>
<script>
	// check to see if the user was created successfully
	$(function(){
		if( $("#userCreated").val() == 1 ){
			$("#accountStatus").html("<h2>Account Created!</h2><div>Welcome to Shipville. A verification e-mail has been generated and should arrive in your inbox shortly</div>");
		} else {
			$("#accountStatus").html("<h2>Error creating account</h2><div>There was an error creating your account. Please contact support to finish the setup process</div>");
		}
	});
</script>