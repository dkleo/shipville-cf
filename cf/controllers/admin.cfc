component {
public shipville.controllers.admin function init ( required fw ){
	variables.fw = fw;
	variables.oUserGateway = new model.gateway.user();
	variables.oShipmentGateway = new model.gateway.shipment();
	return this;
}

public void function before(rc){
	// this should be in the controller at application level but integration with php prevents this
	if( rc.stUser.bIsAdmin eq 0  ){
		// send them to login
		variables.fw.setView("security.login");
		// abort the controller
		variables.fw.abortController();
	}
	param name="rc.nShipmentID" default="0";
	rc.oShipment = oShipmentGateway.get(rc.nShipmentID);
}

public void function after(rc){
	
}

// ### CREDIT CARDS ###
public void function getCardInfo(rc){
	// retrieve the credit card data for this user
	rc.stCardInfo = application.services.authorizenet.getCardInfo(rc.sPaymentID, rc.sPaymentCardID);
}


// ### SHIPMENTS ###
public void function shipments(rc){
 	param name="rc.sStatus" default="pending";
 	switch(rc.sStatus){
 		case "Pending":
 		// retrieve pending shipments
		rc.arShipments = variables.oShipmentGateway.getPending();
		break;
		case "Received":
		// retrieve pending shipments
		rc.arShipments = variables.oShipmentGateway.getReceived();
		break;
		case "Shipped":
		// retrieve pending shipments
		rc.arShipments = variables.oShipmentGateway.getShipped();
		break;
 	}
	
}

public void function addEditShipment(rc){
	param name="rc.nShipmentID" default="0";
	rc.oShipment = variables.oShipmentGateway.get(rc.nShipmentID);
	// get the data for this user
	rc.oUser = variables.oUserGateway.get(rc.oShipment.getNUserID());
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
	param name="rc.dtEstimatedShipment" default="";
	arNotifications = [];
	bDoSave = true;
	try{
		// update date format for dates
		if( len(rc.dtReceived) gt 0 ){
			rc.dtReceived = application.services.tools.dbDayBegin(rc.dtReceived);
		}
		if( len(rc.dtEstimatedShipment) gt 0 ){
			rc.dtEstimatedShipment = application.services.tools.dbDayBegin(rc.dtEstimatedShipment);
		}
		if( len(rc.dtActualShipment) gt 0 ){
			rc.dtActualShipment = application.services.tools.dbDayBegin(rc.dtActualShipment);
		}
		if( len(rc.nCost) eq 0 ){ // remove the cost if it wasnt' entered
			structDelete(rc, "nCost");
			//listDeleteAt(rc.fieldNames, listFind(rc.fieldNames, "nCost"));
		}
		// determine which notifications are needed
		if( len(rc.oShipment.getDTReceived()) eq 0 and len(rc.dtReceived) gt 0 ){
			arrayAppend(arNotifications, "Received");
		}
		if( len(rc.oShipment.getNCost()) eq 0 and structKeyExists(rc, "nCost") and len(rc.nCost) gt 0 ){
			// also handle the charging of this users credit card
			if( not application.services.authorizenet.doShipmentTransaction(variables.oUserGateway.get(rc.oShipment.getNUserID()), rc.oShipment, rc.nCost) ){
				throw("Error charging credit card for order #rc.oShipment.getNShipmentID()#");
			} else {
				arrayAppend(arNotifications, "Charged");
			}
		}
		// add in processing dates
		rc.dtUpdated = rc.dtNow;
		// append the field names so they are picked up
		rc.fieldNames = listAppend(rc.fieldNames, "dtUpdated");
		
		// get form structure
		rc.stForm = application.services.tools.buildFormStructure(rc);
		// save the object
		rc.oShipment = oShipmentGateway.save(rc.oShipment, rc.stForm);

		// send notifications
		for(itm=1; itm lte arrayLen(arNotifications); itm++ ){
			application.services.shipment.sendShipmentNotification(arNotifications[itm], rc.oShipment);
		}
		rc.bShipmentSaved = true;

	} catch ( any e ){
		application.services.tools.log(e.message, e);
		rc.bShipmentSaved = false;
	}
}

// get the estimates from shipping companies
public void function getEstimate(rc){
	try{
		// call services
		rc.stResults = application.services.shipment.estimate(rc.oUser, rc.nWidth, rc.nHeight, rc.nDepth, rc.nWeight);

	} catch ( any e ){
		application.services.tools.log(e.message, e);
	}
}

public void function estimator(rc){
	// buold a blank shipment object
	rc.oShipment = oShipmentGateway.get();
	rc.oUser = oUserGateway.get();
}

}