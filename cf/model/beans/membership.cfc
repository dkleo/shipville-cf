
component entityname="membership" persistent="true" table="membership" output="false" {
	property name="nMembershipID" fieldtype="ID" generator="identity";
	property name="nUserID" fieldtype="column" ormtype="int";
	property name="nType" fieldtype="column" ormtype="int";
	property name="dtCreated" fieldtype="column" ormtype="String" length="19";
	property name="dtModifie" fieldtype="column" ormtype="String" length="19";
	property name="bActive" fieldtype="column" ormtype="string" length="1";
	/**
	* @output false
	*/
	public Numeric function getNMembershipID(){
		if( not structKeyExists(variables, "nMembershipID") ){
			variables.nMembershipID = 0;
		}
		return variables.nMembershipID;
	}
}