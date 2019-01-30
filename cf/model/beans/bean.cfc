
component entityname="game" persistent="false" table="game" output="false" {
	property name="nGameID" fieldtype="ID" generator="identity";
	property name="nWeekID" fieldtype="column" ormtype="int";
	property name="nHomeTeamID" fieldtype="column" ormtype="int";
	property name="nAwayTeamID" fieldtype="column" ormtype="int";
	property name="sSpreadOriginal" fieldtype="column" ormtype="string" length="5";
	property name="sSpread" fieldtype="column" ormtype="string" length="5";
	property name="sSpreadFavor" fieldtype="column" ormtype="string" length="10";
	property name="nHomeScore" fieldtype="column" ormtype="int";
	property name="nAwayScore" fieldtype="column" ormtype="int";
	property name="sTiebreak" fieldtype="column" ormtype="string" length="2" dbDefault="0";
	property name="sGameDateTime" fieldtype="column" ormtype="String" length="19";
	property name="nWinner" fieldtype="column" ormtype="string" length="1";
	/**
	* @output false
	*/
	public Numeric function getNGameID(){
		if( not structKeyExists(variables, "nGameID") ){
			variables.nGameID = 0;
		}
		return variables.nGameID;
	}
}