component entityname="shipment" persistent="true" table="shipment" output="false" {
	property name="nShipmentID" fieldtype="ID" generator="identity";
	property name="sFedExShippingOption" fieldtype="column" ormtype="string" length="2000";
	property name="sUSPSShippingOption" fieldtype="column" ormtype="string" length="2000";
	property name="sDHLShippingOption" fieldtype="column" ormtype="string" length="2000";
	property name="nUserID" fieldtype="column" ormtype="int";
	property name="nWeight" fieldtype="column" ormtype="int";
	property name="nHeight" fieldtype="column" ormtype="int";
	property name="nWidth" fieldtype="column" ormtype="int";
	property name="nDepth" fieldtype="column" ormtype="int";
	property name="sUnit" fieldtype="column" ormtype="string" length="30";
	property name="nCost" fieldtype="column" ormtype="float";
	property name="sFrom" fieldtype="column" ormtype="string" length="2000";
	property name="sDescription" fieldtype="column" ormtype="string" length="2000";
	property name="sPaymentCardID" fieldtype="column" ormtype="string" length="255";
	property name="dtCreated" fieldtype="column" ormtype="String" length="19";
	property name="dtUpdated" fieldtype="column" ormtype="String" length="19";
	property name="dtEstimatedShipment" fieldtype="column" ormtype="String" length="19";
	property name="dtActualShipment" fieldtype="column" ormtype="String" length="19";
	property name="dtReceived" fieldtype="column" ormtype="String" length="19";
	property name="dtBilled" fieldtype="column" ormtype="String" length="19";
	property name="dtPaid" fieldtype="column" ormtype="String" length="19";
	property name="sTrackingNumber" fieldtype="column" ormtype="string" length="1000";
	property name="sKey" fieldtype="column" ormtype="string" length="2000";
	
	/**
	* @output false
	*/
	public Numeric function getNShipmentID(){
		if( not structKeyExists(variables, "nShipmentID") ){
			variables.nShipmentID = 0;
		}
		return variables.nShipmentID;
	}
}