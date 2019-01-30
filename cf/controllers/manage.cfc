component {
public shipville.controllers.manage function init ( required fw ){
	variables.fw = fw;
	variables.oGateway = new model.gateway.user();
	variables.oShipmentGateway = new model.gateway.shipment();
	return this;
}

public void function before(rc){
	// this should be in the controller at application level but integration with php prevents this
	if( rc.bIsDialog and rc.stUser.nUserID eq 0 ){
		// send them to login
		variables.fw.setView("security.login");
		// abort the controller
		variables.fw.abortController();
	} else if ( rc.stUser.nUserID neq 0 ){
		rc.oUser = variables.oGateway.get(rc.stUser.nUserID);
	} else {
		rc.oUser = variables.oGateway.get();
	}
	param name="rc.nShipmentID" default="0";
	rc.oShipment = oShipmentGateway.get(rc.nShipmentID);
}

public void function after(rc){
	
}

// ### CREDIT CARDS ###
public void function creditCard(rc){
	// retrieve the credit card data for this user
	rc.arCreditCards = application.services.authorizenet.getPaymentInfo(rc.oUser.getSPaymentID());
}

public void function saveCreditCard(rc){
	// call the api to add a new credit card
	rc.stResults = application.services.authorizenet.addCard(rc.oUser, rc.sCardNumber, rc.sExpirationYear & "-" & rc.sExpirationMonth, rc.sCCV);
}

public void function deleteCreditCard(rc){
	rc.stResults = application.services.authorizenet.deleteCard(rc.oUser.getSPaymentID(), rc.sPaymentCardID);
}

// ### SHIPMENTS ###
public void function shipments(rc){
	// retrieve the credit card data for this user
	rc.arShipments = oShipmentGateway.getByUser(rc.oUser.getNUserID());
}

public void function addEditShipment(rc){
	param name="rc.nShipmentID" default="0";
	rc.oShipment = oShipmentGateway.get(rc.nShipmentID);
}

public void function cardsInput(rc){
	param name="rc.sPaymentCardID" default="";
	// get credit cards
	rc.arCreditCards = application.services.authorizenet.getPaymentInfo(rc.oUser.getSPaymentID());
}

public void function deleteShipment(rc){
	// delete the shipment
	oShipmentGateway.delete(rc.oShipment);
	rc.bIsDeleted = true;
}

public void function saveShipment(rc){
	try{
		// is this an edit
		if( isNumeric(rc.nShipmentID) and rc.nShipmentID > 0 ){
			// add in processing dates
			rc.dtUpdated = rc.dtNow;
			// append the field names so they are picked up
			rc.fieldNames = listAppend(rc.fieldNames, "dtUpdated");
		} else {
			rc.dtCreated = rc.dtNow;
			rc.nUserID = rc.oUser.getNUserID();
			rc.sKey = createUUID();
			// append the field names so they are picked up
			rc.fieldNames = listAppend(rc.fieldNames, "dtCreated,nUserID,sKey");
		}
		// get form structure
		rc.stForm = application.services.tools.buildFormStructure(rc);
		// save the object
		rc.oShipment = oShipmentGateway.save(rc.oShipment, rc.stForm);
		rc.bShipmentSaved = true;

	} catch ( any e ){
		application.services.tools.log(e.message, e);
		rc.bShipmentSaved = false;
	}
}

// ### USER ###
public void function saveProfile(rc){
	try{
		var nOldMembership = rc.oUser.getNMembership();
		var nNewMembership = rc.oUser.getNMembership();
		// see if we are doing a membership change
		if( structKeyExists(rc, "nMembership") ){
			// track the new membership
			nNewMembership = rc.nMembership;
		}
		// add in the updated account date
		rc.dtAccountUpdated = rc.dtNow;
		lstFieldNames = listAppend(rc.fieldNames, "dtAccountUpdated");
		// buld the form struct
		rc.stForm = application.services.tools.buildFormStructure(rc);
		// save this user
		rc.oUser = variables.oGateway.save(rc.oUser, rc.stForm);
		rc.bUserSaved = true;
		// send out notification that the user has changed their membership
		application.services.user.sendMembershipChange(rc.oUser, nOldMembership, nNewMembership);
	} catch ( any e ){
		application.services.tools.log(e.message, e);
		rc.bUserSaved = false;
	}
}

// get the estimates from shipping companies
public void function getEstimate(rc){
	rc.stEstimates = {};
	try{
		// call services
		rc.stEstimates = application.services.shipment.buildSimpleEstimates(application.services.shipment.estimate(rc.oUser, rc.nWidth, rc.nHeight, rc.nDepth, rc.nWeight, rc.sUnit), rc.oUser);
	} catch ( any e ){
		application.services.tools.log(e.message, e);
	}
}

public void function estimator(rc){
	// buold a blank shipment object
	rc.oShipment = oShipmentGateway.get();
}

public void function shippingInstructions(rc){
	variables.fw.setView("user.shippingInstructions");
}

}