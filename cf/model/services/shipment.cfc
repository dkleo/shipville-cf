component {
	
	/*
	Author: 	
		Ethan Kurtz
	Name:
		$estimate
	Summary:
		Calls the native API's to retrieve shipment options
	Returns:
		Struct stResults
	Arguments:
		User oUser
		Numeric nWidth
		Numeric nHeight
		Numeric nDepth
		Numeric nWeight
		String sUnit
	History:
		2013-07-15 - EK - Created
	*/
	public Struct function estimate( Required shipville.model.beans.user oUser, Required Numeric nWidth, Required Numeric nHeight, Required Numeric nDepth, Required Numeric nWeight, String sUnit = "imperical" ){
		var itm = 1;
		var stResults = {
			arFedEx = [],
			arUSPS = [],
			arDHL = []
		};
		var stFedex = {};
		var stUSPS = {};
		var stDHL = {};
		var pkgSizeUnits = "cm";
		var pkgWeightUnits = "kg";
		if( arguments.sUnit eq "imperical"){
			pkgSizeUnits = "in";
			pkgWeightUnits = "lb";
		}
		try{
			// retrieve fedEx data
			stFedEx = application.services.fedEx.getRates(
				shipToContact = arguments.oUser.getSFirstName() & " " & arguments.oUser.getSLastName(),
				shipToAddress1 = arguments.oUser.getSAddress(),
				shipToAddress2 = arguments.oUser.getSAddress2(),
				shipToCity = arguments.oUser.getSCity(),
				shipToState = arguments.oUser.getSState(),
				shipToZip = arguments.oUser.getSZipCode(),
				shipToCountry = arguments.oUser.getSCountry(),
				pkgWeight = arguments.nWeight,
				pkgLength = arguments.nDepth,
				pkgWidth = arguments.nWidth,
				pkgHeight = arguments.nHeight,
				pkgSizeUnits = pkgSizeUnits,
				pkgWeightUnits = pkgWeightUnits,
				returnRawResponse = true
			);
			// if there were rates supplied -- set them in the return struct
			if( structKeyExists(stFedEx, "rates") ){
				// sort on the total
				stResults.arFedEx = application.services.tools.arrayOfStructsSort(stFedEx.rates, "total");
			}
		} catch ( any e ){
			if( structKeyExists(stFedEx, "rawResponse") ){
				msg = "#e.message# - Error with raw response: #stFedEx.rawResponse#";
			} else {
				msg = e.message;
			}
			application.services.tools.log(msg, e);
		}
		return stResults;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$buildSimpleEstimates
	Summary:
		Works on the data sent back from API's to make them more useable
	Returns:
		Struct stEstimates
	Arguments:
		Struct stEstimates
		User oUser
	History:
		2013-07-15 - EK - Created
	*/
	public struct function buildSimpleEstimates( Required struct stEstimates, Required model.beans.user oUser ){
		var itm = 1;
		// currently only working on fedex
		for( itm; itm lte arrayLen(arguments.stEstimates.arFedEx); itm++ ){
			// add in label
			arguments.stEstimates.arFedEx[itm].sShipmentTypeLabel = fixShippingLabels(arguments.stEstimates.arFedEx[itm].type);
			// fix time stamp
			arguments.stEstimates.arFedEx[itm].deliveryTimeStamp = dateFormat(replaceNoCase(arguments.stEstimates.arFedEx[itm].deliveryTimeStamp, "T", " "), "dddd, mmmm dd, YYYY") & " " & timeFormat(replaceNoCase(arguments.stEstimates.arFedEx[itm].deliveryTimeStamp, "T", " "), "HH:mm");
			// add discounts premium
			if( arguments.oUser.getNMembership() eq 1 ){
				arguments.stEstimates.arFedEx[itm].total = arguments.stEstimates.arFedEx[itm].total + (arguments.stEstimates.arFedEx[itm].total*0.2); 
			} else if( listFind("0,2,3", arguments.oUser.getNMembership()) ) { // premium with mailbox or public (e.g. no account)
				arguments.stEstimates.arFedEx[itm].total = arguments.stEstimates.arFedEx[itm].total + (arguments.stEstimates.arFedEx[itm].total*0.1);// added by EK 9/23 to calculate for other membership types
			}
			// apply dollar format
			arguments.stEstimates.arFedEx[itm].total = dollarFormat(arguments.stEstimates.arFedEx[itm].total);
		}
		return arguments.stEstimates;
	}

	// returns the status
	public String function getStatus( Required shipville.model.beans.shipment oShipment ){
		var sStatus = "pending";
		if( len(arguments.oShipment.getDTActualShipment()) neq 0 ){
			sStatus = "shipped";
		} else if( len(arguments.oShipment.getDTReceived()) neq 0 ){
			sStatus = "received";
		}
		return sStatus;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$fixShippingLabels
	Summary:
		Returns the shipping label from a named shipment
	Returns:
		String sShipmentLabel
	Arguments:
		String sShipmentType
		String sDelim
	History:
		2013-07-15 - EK - Created
	*/
	public String function fixShippingLabels( Required String sShipmentType, String sDelim = "_" ){
		var sShipmentLabel = "";
		var itm = 1;
		var arShipmentType = listToArray(arguments.sShipmentType, arguments.sDelim);
		for( itm; itm lte arrayLen(arShipmentType); itm++ ){
			if( itm neq 1 ){
				sShipmentLabel = sShipmentLabel & " " & application.services.tools.sentenceCase(arShipmentType[itm]);
			} else {
				sShipmentLabel = application.services.tools.sentenceCase(arShipmentType[itm]);
			}

		}
		return sShipmentLabel;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$sendShipmentNotification
	Summary:
		Sends out a notification for various actions on a shipment
	Returns:
		Void
	Arguments:
		String sNotification
		Shipment oShipment
	History:
		2013-07-21 - EK - Created
	*/
	public Void function sendShipmentNotification( Required String sNotification, Required model.beans.shipment oShipment ){
		// access the user
		oUserGateway = new model.gateway.user();
		oUser = oUserGateway.get(arguments.oShipment.getNUserID());
		try{
			var oMail = new mail();
			oMail.setTo(oUser.getSEmail());
			oMail.setFrom("support@shipville.com");
			switch(arguments.sNotification){
				case "Received":
					oMail.setSubject("Your package has been received and will be shipped shortly");
					oMail.setBody("We have received your package and are processing it. We will ship it out as soon as we can.");
					application.services.tools.log("Message sent for received package");		
				break;

				case "Charged":
					oMail.setSubject("Your package has been shipped!");
					oMail.setBody("Your package has been shipped. Please login to view the status of your shipment");
					application.services.tools.log("Message sent for charged shipment");
				break;
			}
			oMail.setType("plain");
			oMail.send();
		} catch ( any e ){
			application.services.tools.log(e.message, e);
		}
	}


}