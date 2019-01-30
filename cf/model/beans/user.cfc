
component entityname="user" persistent="true" table="user" output="false" {
	property name="nUserID" fieldtype="ID" generator="identity";
	property name="sFirstName" fieldtype="column" ormtype="string" length="255";
	property name="sLastName" fieldtype="column" ormtype="string" length="255";
	property name="sEmail" fieldtype="column" ormtype="string" length="255";
	property name="sPhone" fieldtype="column" ormtype="string" length="255";
	property name="sPassword" fieldtype="column" ormtype="string" length="255";
	property name="sAddress" fieldtype="column" ormtype="string" length="1000";
	property name="sAddress2" fieldtype="column" ormtype="string" length="1000";
	property name="sCity" fieldtype="column" ormtype="string" length="255";
	property name="sState" fieldtype="column" ormtype="string" length="255";
	property name="sCountry" fieldtype="column" ormtype="string" length="255";
	property name="sZipCode" fieldtype="column" ormtype="string" length="10";
	property name="sMailbox" fieldtype="column" ormtype="string" length="255";
	property name="nMembership" fieldtype="column" ormtype="int" dbdefault="0";
	property name="sPaymentID" fieldtype="column" ormtype="string" length="255";
	property name="sPaymentCardID" fieldtype="column" ormtype="string" length="255";
	property name="sVerificationCode" fieldtype="column" ormtype="string" length="255";
	property name="dtAccountCreated" fieldtype="column" ormtype="String" length="19";
	property name="dtAccountUpdated" fieldtype="column" ormtype="String" length="19";
	property name="dtVerificationSent" fieldtype="column" ormtype="String" length="19";
	property name="dtVerified" fieldtype="column" ormtype="String" length="19";
	property name="dtLastLogin" fieldtype="column" ormtype="String" length="19";
	property name="bIsAdmin" fieldtype="column" ormtype="int" dbdefault="0";
	
	/**
	* @output false
	*/
	public Numeric function getNUserID(){
		if( not structKeyExists(variables, "nUserID") ){
			variables.nUserID = 0;
		}
		return variables.nUserID;
	}
}