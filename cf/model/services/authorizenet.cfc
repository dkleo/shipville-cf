component {
// set params for login
variables.sLogin = "6euu3yDQ5UJ";
variables.sID = "399920";
variables.sTransactionKey = "28Kas4NE83U3rfmx";
variables.sMerchantNode = '<merchantAuthentication><name>#variables.sLogin#</name><transactionKey>#variables.sTransactionKey#</transactionKey></merchantAuthentication>';


// Makes the actual call to the API	
public Struct function doCall( Required string sXML ){
	var sXMLRemoteCall = "";
	var sXMLResult = "";
	var stResult = { sResultStatus = "", sResultMessageCode = "", sResultMessage = "", sXMLResult = "" };
	var sResultCode = "success";
	var sResultMessageCode = "";
	var oHttpResult = "";
	var oHttpService = new http();
	// make sure that the xml document passed in can be deserialized correctly
	try{
		if( !isXML(arguments.sXML) ){
			throw( message="sXML argument is not an XML document");
		}
		oHttpService.setMethod("post");
		oHttpService.setCharset("utf-8");
		//oHttpService.setURL("https://apitest.authorize.net/xml/v1/request.api");
		oHttpService.setURL("https://api.authorize.net/xml/v1/request.api");
		oHttpService.addParam(type="header", name="accept-encoding", value="no-compression");
		oHttpService.addParam(type="xml",  value=arguments.sXML);
		// make the call
		oHttpResult = oHttpService.send().getPrefix();
		// make sure the call was successful
		sXMLResult = oHttpResult.fileContent;
		// make sure that the results are XML
		if( isXML(sXMLResult) ){
			// setup the result structure
			stResult = {
				// check to see if the messages report "ok"
				sResultStatus = xmlSearch(sXMLResult, "//#buildNode('messages')#/#buildNode('resultCode')#")[1].xmlText,
				// get the message
				sResultMessageCode = xmlSearch(sXMLResult, "//#buildNode('messages')#/#buildNode('message')#/#buildNode('code')#")[1].xmlText,
				// get the message code
				sResultMessage = xmlSearch(sXMLResult, "//#buildNode('messages')#/#buildNode('message')#/#buildNode('text')#")[1].xmlText,
				// set the actual results
				sXMLResult = sXMLResult
			};
		} else {
			throw( message="results from API call are not XML" );
	}
	} catch (any e){
		application.services.tools.log( e.message, e);
	}
	return stResult;
}

public Struct function createProfile( Required string sFirstName, Required string sLastName, Required string sEmail, Required string sAddress, Required string sCity, Required string sState, Required string sZipCode, Required string sCountry, Required string sPhone, Required string sCardNumber, Required string sExpiration, Required string sCCV, boolean bValidateOnly=false ){
	var sXML = "";
	var bMode = "liveMode";
	var stCallResult = {};
	var stAccountData = { "sPaymentID" = "", "sPaymentCardID" = "" };
	if( arguments.bValidateOnly ){
		bMode = "testMode";
	}
	try {
		savecontent variable="sXML" {
			writeOutput('<?xml version="1.0" encoding="utf-8"?>
			<createCustomerProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
				#variables.sMerchantNode#
				<profile>
					<merchantCustomerId>#variables.sID#</merchantCustomerId>
					<description>Profile</description>
					<email>#arguments.sEmail#</email>
					<paymentProfiles>
						<customerType>individual</customerType>
						<billTo>
							<firstName>#arguments.sFirstName#</firstName>
							<lastName>#arguments.sLastName#</lastName>
							<address>#arguments.sAddress#</address>
							<city>#arguments.sCity#</city>
							<state>#arguments.sState#</state>
							<zip>#arguments.sZipCode#</zip>
							<country>#arguments.sCountry#</country>
							<phoneNumber>#arguments.sPhone#</phoneNumber>
						</billTo>
						<payment>
							<creditCard>
								<cardNumber>#arguments.sCardNumber#</cardNumber>
								<expirationDate>#arguments.sExpiration#</expirationDate>
								<cardCode>#arguments.sCCV#</cardCode>
							</creditCard>
						</payment>
					</paymentProfiles>
				</profile>
				<validationMode>#bMode#</validationMode>
			</createCustomerProfileRequest>');	
		}
		// send call and return results
		stCallResult = doCall(sXML);
		if( compareNoCase(stCallResult.sResultStatus, "error") neq 0  ){
			// get the profile id
			stAccountData.sPaymentID = xmlSearch(stCallResult.sXMLResult, "//#buildNode('customerProfileId')#")[1].xmlText;
			// get the payment id
			stAccountData.sPaymentCardID = xmlSearch(stCallResult.sXMLResult, "//#buildNode('customerPaymentProfileIdList')#")[1].numericString.xmlText;
		} else {
			// log this error
			throw( message="Error validating CC number: #arguments.sCardNumber# with expiration: #arguments.sExpiration# for user: #arguments.sEmail#. Server Response -- #stCallResult.sXMLResult#");
		}
	} catch (any e){
		application.services.tools.log( e.message, e);
	}
	return stAccountData;
}

// get the list of profile IDs registered
public Array function getPaymentInfo( Required String sPaymentID ){
	try {
		var itm = 1;
		var x = 1;
		var sXML = "";
		var stCallResult = {};
		var arPaymentXML = [];
		var arCardXML = [];
		var arPaymentInfo = [];
		var stCardData = {};
		// build content for call
		savecontent variable="sXML" {
			writeOutput('<?xml version="1.0" encoding="utf-8"?>
				<getCustomerProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
				 #variables.sMerchantNode#
				 <customerProfileId>#arguments.sPaymentID#</customerProfileId>
				</getCustomerProfileRequest>');	
		}
		// send call and return results
		stCallResult = doCall(sXML);
		if( compareNoCase(stCallResult.sResultStatus, "error") neq 0  ){
			// loop through payment profiles
			arXML = xmlSearch(stCallResult.sXMLResult, "//#buildNode('paymentProfiles')#");
			// loop through the array and get the card data
			for(itm=1; itm lte arrayLen(arXML); itm++ ){
				// reset data structure for a new card
				stCardData = { "sPaymentCardID" = xmlSearch(arXML[itm], ".//#buildNode('customerPaymentProfileId')#")[1].xmlText };
				// find the payment for this
				arCardXML = xmlSearch(arXML[itm], ".//#buildNode('payment')#//#buildNode('creditCard')#");
				// loop through card info
				for( x=1; x lte arrayLen(arCardXML[1].xmlChildren); x++ ){
					structInsert(stCardData, arCardXML[1].xmlChildren[x].xmlName, arCardXML[1].xmlChildren[x].xmlText);
				}
				// append this structure to the credit cards found by the api call
				arrayAppend(arPaymentInfo, stCardData);
			}
		}
	} catch (any e){
		application.services.tools.log( e.message, e);
	}
	return arPaymentInfo;
}

// get the card data for a particular user
public Struct function getCardInfo( Required String sPaymentID, Required String sPaymentCardID ){
	try {
		var itm = 1;
		var x = 1;
		var sXML = "";
		var stCallResult = {};
		var arPaymentXML = [];
		var arCardXML = [];
		var arPaymentInfo = [];
		var stCardData = {};
		// build content for call
		savecontent variable="sXML" {
			writeOutput('<?xml version="1.0" encoding="utf-8"?>
				<getCustomerPaymentProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
				 #variables.sMerchantNode#
				 <customerProfileId>#arguments.sPaymentID#</customerProfileId>
				 <customerPaymentProfileId>#arguments.sPaymentCardID#</customerPaymentProfileId>
				</getCustomerPaymentProfileRequest>');	
		}
		// send call and return results
		stCallResult = doCall(sXML);
		if( compareNoCase(stCallResult.sResultStatus, "error") neq 0  ){
			// loop through payment profiles
			arXML = xmlSearch(stCallResult.sXMLResult, "//#buildNode('paymentProfile')#");
			
			// reset data structure for a new card
			stCardData = { "sPaymentCardID" = xmlSearch(arXML[itm], ".//#buildNode('customerPaymentProfileId')#")[1].xmlText };
			// find the payment for this
			arCardXML = xmlSearch(arXML[itm], ".//#buildNode('payment')#//#buildNode('creditCard')#");
			// loop through card info
			for( x=1; x lte arrayLen(arCardXML[1].xmlChildren); x++ ){
				structInsert(stCardData, arCardXML[1].xmlChildren[x].xmlName, arCardXML[1].xmlChildren[x].xmlText);
			}
		}
	} catch (any e){
		application.services.tools.log( e.message, e);
	}
	return stCardData;
}

// add credit card for payment id
public Struct function addCard( Required Any oUser, Required String sCardNumber, Required String sExpiration, Required String sCCV ){
	try {
		var sXML = "";
		var stCallResult = {};
		var arXML = [];
		var stCardData = { "bSuccessful" = true, "sMessage" = "Added Card", "sPaymentCardID" = "" };
		// build content for call
		savecontent variable="sXML" {
			writeOutput('<?xml version="1.0" encoding="utf-8"?>
				<createCustomerPaymentProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
				#variables.sMerchantNode#
				<customerProfileId>#arguments.oUser.getSPaymentID()#</customerProfileId>
				<paymentProfile>
					<billTo>
						<firstName>#arguments.oUser.getSFirstName()#</firstName>
						<lastName>#arguments.oUser.getSLastName()#</lastName>
						<address>#arguments.oUser.getSAddress()#</address>
						<city>#arguments.oUser.getSCity()#</city>
						<state>#arguments.oUser.getSState()#</state>
						<zip>#arguments.oUser.getSZipCode()#</zip>
						<country>#arguments.oUser.getSCountry()#</country>
						<phoneNumber>#arguments.oUser.getSPhone()#</phoneNumber>
					</billTo>
					<payment>
						<creditCard>
							<cardNumber>#arguments.sCardNumber#</cardNumber>
							<expirationDate>#arguments.sExpiration#</expirationDate>
							<cardCode>#arguments.sCCV#</cardCode>
						</creditCard>
					</payment>
				</paymentProfile>
				<validationMode>liveMode</validationMode>
				</createCustomerPaymentProfileRequest>');	
		}
		// send call and return results
		stCallResult = doCall(sXML);
		if( compareNoCase(stCallResult.sResultStatus, "error") neq 0  ){
			// make sure we got a payment id
			arXML = xmlSearch(stCallResult.sXMLResult, "//#buildNode('customerPaymentProfileId')#");
			// just make sure that its ok (should be if we get here)
			if( arrayLen(arXML) gt 0 ){
				stCardData["sPaymentCardID"] = arXML[1].xmlText;
			} else {
				throw("Error creating card");
			}
		} else {
			throw("Error adding card card: #stCallResult.sResultMessage#");
		}	
	} catch (any e){
		// log error
		application.services.tools.log( e.message, e);
		// return error
		stCardData = { "bSuccessful" = false, "sMessage" = e.message };
	}
	return stCardData;
}

// charge for shipping
public Boolean function doShipmentTransaction( Required model.beans.user oUser, Required model.beans.shipment oShipment, Required Numeric nCost, String sDescription="Shipville Shipment" ){
	try {
		var sXML = "";
		var stCallResult = {};
		var arXML = [];
		var bTransactionComplete = true;
		// build content for call
		savecontent variable="sXML" {
			writeOutput('<?xml version="1.0" encoding="utf-8"?><createCustomerProfileTransactionRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
				 #variables.sMerchantNode#
				 <transaction>
					 <profileTransAuthOnly>
						 <amount>#arguments.nCost#</amount>
						 <!-- // <tax>
							 <amount>1.00</amount>
							 <name>WA state sales tax</name>
							 <description>Washington state sales tax</description>
						 </tax> -->
						 <!-- // <shipping>
							 <amount>2.00</amount>
							 <name>ground based shipping</name>
							 <description>Ground based 5 to 10 day shipping</description>
						 </shipping> -->
						 <lineItems>
							 <itemId>shipvilleID_#arguments.oShipment.getNShipmentID()#</itemId>
							 <name>#arguments.oShipment.getSFrom()#</name>
							 <!-- // <description>#arguments.oShipment.getSDescription()#</description> -->
							 <quantity>1</quantity>
							 <unitPrice>#arguments.nCost#</unitPrice>
							 <taxable>false</taxable>
						 </lineItems>
						 <customerProfileId>#arguments.oUser.getSPaymentID()#</customerProfileId>
						 <customerPaymentProfileId>#arguments.oShipment.getSPaymentCardID()#</customerPaymentProfileId>
						 <!-- // <customerShippingAddressId>30000</customerShippingAddressId> -->
						 <order>
							 <invoiceNumber>shipvilleID_#arguments.oShipment.getNShipmentID()#</invoiceNumber>
							 <description>#arguments.sDescription#</description>
							 <!-- // <purchaseOrderNumber>PONUM000001</purchaseOrderNumber> -->
						 </order>
						 <taxExempt>true</taxExempt>
						 <recurringBilling>false</recurringBilling>
						 <!-- // <cardCode>000</cardCode>
						 <splitTenderId>123456</splitTenderId> -->
					 </profileTransAuthOnly>
				 </transaction>
				</createCustomerProfileTransactionRequest>');	
		}
		// send call and return results
		stCallResult = doCall(sXML);
		if( compareNoCase(stCallResult.sResultStatus, "error") neq 0  ){
			// make sure we got a result code of "ok"
			arXML = xmlSearch(stCallResult.sXMLResult, "//#buildNode('resultCode')#");
			// just make sure that its ok (should be if we get here)
			if( arrayLen(arXML) gt 0 and compareNoCase(arXML[1].xmlText, "Ok") neq 0){
				bTransactionComplete = false;
			}
		} else {
			throw("Error processing transaction: #stCallResult.sResultMessage#");
		}	
	} catch (any e){
		// log error
		application.services.tools.log( e.message, e);
		// return error
		bTransactionComplete = false;
	}
	return bTransactionComplete;
}

// add charge for membership
public Boolean function doMembershipTransaction( Required model.beans.user oUser ){
	try {
		var sXML = "";
		var stCallResult = {};
		var arXML = [];
		var bTransactionComplete = true;
		var arMembershipCharges = [ 0, 9.99, 19.99 ];
		// build content for call
		if( arMembershipCharges[arguments.oUser.getNMembership()] gt 0 ){
			savecontent variable="sXML" {
				writeOutput('<?xml version="1.0" encoding="utf-8"?><createCustomerProfileTransactionRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
					 #variables.sMerchantNode#
					 <transaction>
						 <profileTransAuthOnly>
							 <amount>#arMembershipCharges[arguments.oUser.getNMembership()]#</amount>
							 <!-- // <tax>
								 <amount>1.00</amount>
								 <name>WA state sales tax</name>
								 <description>Washington state sales tax</description>
							 </tax> -->
							 <!-- // <shipping>
								 <amount>2.00</amount>
								 <name>ground based shipping</name>
								 <description>Ground based 5 to 10 day shipping</description>
							 </shipping> -->
							 <lineItems>
								 <itemId>shipvilleUserID_#arguments.oUser.getNUserID()#</itemId>
								 <name>Shipville monthly membership</name>
								 <description>Monthly charges for access to shipville.com services</description>
								 <quantity>1</quantity>
								 <unitPrice>#arMembershipCharges[arguments.oUser.getNMembership()]#</unitPrice>
								 <taxable>false</taxable>
							 </lineItems>
							 <customerProfileId>#arguments.oUser.getSPaymentID()#</customerProfileId>
							 <customerPaymentProfileId>#arguments.oUser.getSPaymentCardID()#</customerPaymentProfileId>
							 <!-- // <customerShippingAddressId>30000</customerShippingAddressId> -->
							 <order>
								 <invoiceNumber>shipvilleUserID_#arguments.oUser.getNUserID()#</invoiceNumber>
								 <description>Shipville monthly membership</description>
								 <!-- // <purchaseOrderNumber>PONUM000001</purchaseOrderNumber> -->
							 </order>
							 <taxExempt>true</taxExempt>
							 <recurringBilling>false</recurringBilling>
							 <!-- // <cardCode>000</cardCode>
							 <splitTenderId>123456</splitTenderId> -->
						 </profileTransAuthOnly>
					 </transaction>
					</createCustomerProfileTransactionRequest>');	
			}
			// send call and return results
			stCallResult = doCall(sXML);
			if( compareNoCase(stCallResult.sResultStatus, "error") neq 0  ){
				// make sure we got a result code of "ok"
				arXML = xmlSearch(stCallResult.sXMLResult, "//#buildNode('resultCode')#");
				// just make sure that its ok (should be if we get here)
				if( arrayLen(arXML) gt 0 and compareNoCase(arXML[1].xmlText, "Ok") neq 0){
					bTransactionComplete = false;
				}
			} else {
				throw("Error processing transaction: #stCallResult.sResultMessage#");
			}
		}
	} catch (any e){
		// log error
		application.services.tools.log( e.message, e);
		// return error
		bTransactionComplete = false;
	}
	return bTransactionComplete;
}

// delete credit card for payment id
public Struct function deleteCard( Required String sPaymentID, Required String sPaymentCardID ){
	try {
		var sXML = "";
		var stCallResult = {};
		var arXML = [];
		var stCardData = { "bSuccesful" = true, "sMessage" = "Deleted Card" };
		// build content for call
		savecontent variable="sXML" {
			writeOutput('<?xml version="1.0" encoding="utf-8"?>
				<deleteCustomerPaymentProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
				 #variables.sMerchantNode#
				 <customerProfileId>#arguments.sPaymentID#</customerProfileId>
				 <customerPaymentProfileId>#arguments.sPaymentCardID#</customerPaymentProfileId>
				</deleteCustomerPaymentProfileRequest>');	
		}
		// send call and return results
		stCallResult = doCall(sXML);
		if( compareNoCase(stCallResult.sResultStatus, "error") neq 0  ){
			// make sure we got an "ok" message
			arXML = xmlSearch(stCallResult.sXMLResult, "//#buildNode('resultCode')#");
			// just make sure that its ok (should be if we get here)
			if( compareNoCase(arXML[1].xmlText, "Ok") neq 0 ){
				throw("Error deleting card");
			}
		} else {
			throw("Error deleting card card: #stCallResult.sResultMessage#");
		}	
	} catch (any e){
		// log error
		application.services.tools.log( e.message, e);
		// return error
		stCardData = { "bSuccessful" = false, "sMessage" = e.message };
	}
	return stCardData;
}

// get the list of profile IDs registered
public Array function getProfiles(){
	try {
		var itm = 1;
		var sXML = "";
		var stCallResult = {};
		var arXML = [];
		var arProfileIDs = [];
		// build content for call
		savecontent variable="sXML" {
			writeOutput('<?xml version="1.0" encoding="utf-8"?>
			<getCustomerProfileIdsRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
				#variables.sMerchantNode#
			</getCustomerProfileIdsRequest>');	
		}
		// send call and return results
		stCallResult = doCall(sXML);
		if( compareNoCase(stCallResult.sResultStatus, "error") neq 0  ){
			arXML = xmlSearch(stCallResult.sXMLResult, "//#buildNode('ids')#")[1].xmlChildren;
			for(itm; itm lte arrayLen(arXML); itm++ ){
				arrayAppend(arProfileIDs, arXML[itm].xmlText);
			}
		}
	} catch (any e){
		application.services.tools.log( e.message, e);
	}
	return arProfileIDs;
}

// delete a profile
public Void function deleteProfiles( Required String lstProfileIDs ){
	var itm = 1;
	// loop through the list of IDs and delete the profiles
	for( itm; itm lte listLen(arguments.lstProfileIDs); itm++ ){
		// build content for call
		savecontent variable="sXML" {
			writeOutput('<?xml version="1.0" encoding="utf-8"?>
			<deleteCustomerProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">
				#variables.sMerchantNode#
				<customerProfileId>#listGetAt(arguments.lstProfileIDS, itm)#</customerProfileId>
			</deleteCustomerProfileRequest>');	
		}
		// send call and return results
		stCallResult = doCall(sXML);
	}
}

// handle CF 10 bug
private String function buildNode( Required String sNode ){
	// if this is CF 10 add in the nasty search criteria
	if( listFirst(server.coldFusion.productVersion) eq 10 ){
		return "*[local-name()='#arguments.sNode#' and namespace-uri()='AnetApi/xml/v1/schema/AnetApiSchema.xsd']";
	} else {
		return ":" & arguments.sNode;
	}
}

}
