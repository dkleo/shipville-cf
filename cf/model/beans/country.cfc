
component entityname="country" persistent="true" table="country" output="false" {
	property name="nID" fieldtype="ID" generator="identity";
	property name="nCountryID" fieldtype="column" ormtype="int";
	property name="sName" fieldtype="column" ormtype="string" length="255";
	
	/**
	* @output false
	*/
	public Numeric function getNID(){
		if( not structKeyExists(variables, "nID") ){
			variables.nID = 0;
		}
		return variables.nID;
	}
}