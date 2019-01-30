component {

public shipville.controllers.user function init ( required fw ){
	variables.fw = fw;
	variables.oGateway = new model.gateway.user();
	return this;
}

public void function before(rc){
	rc.oUser = variables.oGateway.get();
}

public void function deleteAuthorizeProfiles(rc){
	param name="rc.lstUserID" default="#arrayToList(application.services.authorizenet.getProfiles())#";
	application.services.authorizenet.deleteProfiles(rc.lstUserID);
}

public void function checkEmail(rc){
	// check to see if this e-mail address has been used already
	rc.arUser = oGateway.getByEmail(rc.sEmail);
}

public void function saveFinancial(rc){
	// call the api to get the profile data
	rc.stAccountData = application.services.authorizenet.createProfile(rc.sFirstName, rc.sLastName, rc.sEmail, rc.sAddress, rc.sCity, rc.sState, rc.sZipCode, rc.sCountry, rc.sPhone, rc.sCardNumber, rc.sExpirationYear & "-" & rc.sExpirationMonth, rc.sCCV);
}

public void function save(rc){
	try{ // if this is an add
		rc.stResponse = { "bUserSaved" = true, "sMessage" = "User created successfully" };
		if( not isNumeric(rc.nID) or not rc.nID > 0 ){
			// make sure that the e-mail address for this user doesn't exist alreday
			if( arrayLen(oGateway.getByEmail(rc.sEmail)) gt 0 ){
				throw("Error creating user. User with this e-mail address already exists");
			}
			// add in dates and verification code
			rc.dtAccountCreated = rc.dtNow;
			rc.dtAccountUpdated = rc.dtNow;
			rc.sVerificationCode = createUUID();
			rc.dtVerificationSent = rc.dtNow;
			rc.sMailbox = randRange(1000, 9999);
			// build the new mailbox number
			while( arrayLen(oGateway.getByMailbox(rc.sMailbox)) neq 0 ){
				rc.sMailbox = randRange(1000, 9999);
			}
			// append the field names so they are picked up
			rc.fieldNames = listAppend(rc.fieldNames, "dtAccountCreated,dtAccountUpdated,sVerificationCode,dtVerificationSent,sMailbox");
			// get new user object
			oUser = variables.oGateway.get();
		} else {
			// get the user
			oUser = variables.oGateway.get(rc.nID);
			// add in the updated account date
			rc.dtAccountUpdated = rc.dtNow;
			lstFieldNames = listAppend(rc.fieldNames, "dtAccountUpdated");
		}
		// buld the form struct
		rc.stForm = application.services.tools.buildFormStructure(rc);
		// save this user
		rc.oUser = variables.oGateway.save(oUser, rc.stForm);
		
		// send out verification e-mail
		if( len(rc.oUser.getDTVerified()) eq 0){
		 	application.services.user.sendEmailVerification(rc.oUser);
		}

	} catch ( any e ){
		application.services.tools.log(e.message, e);
		rc.stResponse = { "bUserSaved" = false, "sMessage" = "Error creating user. Please contact support." };
	}
}

public void function reset(rc){
	// clear their session and cookies so they can login
	var temp = variables.fw.redirect("manage.home");
	//variables.fw.setupSession();

	//variables.fw.setView("main.default");
}

public void function verify(rc){
	param name="rc.nUserID" default="0";
	param name="rc.sVerificationCode" default="";
	rc.sMessage = "";
	rc.oUser = variables.oGateway.get();
	try{
		// get the user
		arUser = variables.oGateway.getByVerificationCode(rc.sVerificationCode);
		// set verified
		rc.bUserVerified = true;
		// TODO: should be moved to service
		if( arrayLen(arUser) gt 0 ){
			rc.oUser = arUser[1];
			// charge the user for their monthly fee
			if( application.services.authorizenet.doMembershipTransaction(rc.oUser) ){
				// save the user
				variables.oGateway.save(rc.oUser, { "dtVerified" = rc.dtNow });
				// clear their session and cookies so they can login
				structClear(session);
				variables.fw.setupSession();
			} else {
				throw "Could not process monthly credit card charge";
			}
		} else {
			throw "User verification did not match";
		}
	} catch ( any e ){
		application.services.tools.log(e.message, e);
		rc.sMessage = e.message;
		rc.bUserVerified = false;
	}
}

public void function testVerified(rc){
	param name="rc.oUser" default="#variables.oGateway.get(20)#";
	param name="rc.bUserVerified" default="true";
	variables.fw.setView("user.verify");
}

public void function sendPasswordReset(rc){
	param name="rc.sEmail" default="";
	var arUser = [];
	rc.bEmailSent = false;
	if( len(rc.sEmail) gt 0){
		arUser = oGateway.getByEmail(rc.sEmail);
		if( arrayLen(arUser) ){
			application.services.user.sendPasswordReset(arUser[1]);
			rc.bEmailSent = true;
		}
		
	}
}

public void function password(rc){
	param name="rc.sVerificationCode" default="0";
	var arUser = [];
	if( rc.sVerificationCode neq 0 ){
		arUser = oGateway.getByVerificationCode(rc.sVerificationCode);
		if( arrayLen(arUser) gt 0 ){
			rc.oUser = arUser[1];
		}
	}
}

}