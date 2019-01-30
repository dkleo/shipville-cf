component {
	public shipville.controllers.security function init ( required fw ){
		variables.fw = fw;
		variables.oGateway = new shipville.model.gateway.user();
		variables.oService = new shipville.model.services.user();
		// protected views
		variables.lstProtectedActions = "user.manage";
		return this;
	}
	
	public void function checkAuthorization(rc){
		// set the session scope into rc
		rc.stUser = session;
		//rc.stUser = { "nUserID" = 5, "sEmail" = "dilemo@gmail.com" };
		// if the user is required to authenticate
		//if( listFindNoCase(variables.lstProtectedActions, variables.fw.getFullyQualifiedAction()) gt 0 and session.nUserID eq 0 ){
		//	variables.fw.setView("security.login");
		//}
	}

	public void function authenticate(rc){
		var arUser = [];
		rc.stResponse = { "bLoggedIn" = false, "sMessage" = "Login failed - please provide a valid username/password combination" };
		try{
			if( structKeyExists(rc, "sEmail") and len(rc.sEmail) gt 0 and structKeyExists(rc, "sPassword") and len(rc.sPassword) > 0 ){
				arUser = variables.oGateway.getByUsernamePassword(rc.sEmail, rc.sPassword);
				// valid user but they aren't verified yet
				if( arrayLen(arUser) and not len(arUser[1].getDTVerified()) gt 1 ){
					rc.stResponse.sMessage = "Your account has not been verified please check for your e-mail verification";

				} else if( arrayLen(arUser) and len(arUser[1].getDTVerified()) gt 1) { // valid uer
					setupSession(arUser);
					rc.stResponse = { "bLoggedIn" = true, "sMessage" = "Login successful" };
				}
			}
		} catch (any e){
			application.services.tools.log("Error authenticating", e);
		}
	}

	public void function setupSession(arUser){
		try{
			session.nUserID = arUser[1].getNUserID();
			session.sEmail = arUSer[1].getSEmail();
			session.bIsAdmin = isNull(arUser[1].getBIsAdmin()) ? 0 : arUser[1].getBIsAdmin();
			session.sFirstName = arUser[1].getSFirstName();
			session.sLastName = arUser[1].getSLastName();
		} catch (any e){
			application.services.tools.log("Error setting up session", e);
		}
	}
}