component {
	
	public Void function sendEmailVerification( Required model.beans.user oUser ){
		try{
			var oMail = new mail();
			oMail.setTo(arguments.oUser.getSEmail());
			oMail.setFrom("support@shipville.com");
			oMail.setSubject("Thank you for setting up a Shipville account");
			oMail.setType("plain");
			oMail.setBody("Please click this link to verify: http://www.shipville.com/members/?action=user.verify&sVerificationCode=" & arguments.oUser.getSVerificationCode() & "&nUserID=" & arguments.oUser.getNUSerID() & "
Please note that your username will be your e-mail address: #arguments.oUser.getSEmail()#.");
			oMail.send();
		} catch ( any e ){
			application.services.tools.log(e.message, e);
		}
	
	}

	public Void function sendMembershipChange( Required model.beans.user oUser, Required Numeric nOldMembership, Required Numeric nNewMembership ){
		try{
			var oMail = new mail();
			oMail.setTo("kalpakis82@gmail.com");
			oMail.setFrom("support@shipville.com");
			oMail.setSubject("User changed membership");
			oMail.setType("plain");
			oMail.setBody("The user with e-mail address: " & arguments.oUser.getSEmail() & " has changed their membership from: " & application.stMembershipMap.nID[arguments.nOldMembership] & " to: " & application.stMembershipMap.nID[arguments.nNewMembership]);
			oMail.send();
		} catch ( any e ){
			application.services.tools.log(e.message, e);
		}
	}

	public Void function sendPasswordReset( Required model.beans.user oUser ){
		try{
			var oMail = new mail();
			oMail.setTo(arguments.oUser.getSEmail());
			oMail.setFrom("support@shipville.com");
			oMail.setSubject("Password reset");
			oMail.setType("plain");
			oMail.setBody("You have asked to have your password reset.
Click (or copy and paste into your web browser) the following link to create a new password.

http://www.shipville.com/members/?action=user.password&sVerificationCode=" & arguments.oUser.getSVerificationCode());
			oMail.send();
		} catch ( any e ){
			application.services.tools.log(e.message, e);
		}
	}
}