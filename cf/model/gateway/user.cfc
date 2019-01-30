component {
	
	/*
	Author: 	
		Ethan Kurtz
	Name:
		$get
	Summary:
		Gets the user object
	Returns:
		User oUser
	Arguments:
		Numeric nID
	History:
		2013-04-01 - EK - Created
	*/
	public model.beans.user function get( Numeric nID=0 ){
		var oUser = "";
		var arUser = [];
		if( arguments.nID == 0 ){
			oUser = entityNew("user");
		} else {
			aruser = entityLoad("user", arguments.nID);
			if( arrayLen(arUser) ){
				oUser = arUser[1];
			}
		}
		return oUser;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$save
	Summary:
		Saves the user entity
	Returns:
		User oUser
	Arguments:
		User oUser
		Struct stForm
	History:
		2013-04-01 - EK - Created
	*/
	public model.beans.user function save( Required model.beans.user oUser, Required struct stForm ){
		try{
			var sField = "";
			var lstExcludedFields = "nID";
			// get local variable for arguments
			request.oBean = arguments.oUser;
			// loop through the fields
			for( sField in arguments.stForm ){
				// make sure we aren't exlcuding this field
				if( not listFindNoCase(lstExcludedFields, sField) ){
					// handle different fields
					switch(sField){


						default:
							// include the logic which will operate dynamically on the form field
							include "set.cfm";
					}
				}
			}
			entitySave(request.oBean);
			ormFlush();
		} catch (any e){
			application.services.tools.log("Error in saving acount bean", e);
		}
		return request.oBean;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$delete
	Summary:
		Delete the user entity
	Returns:
		User oUser
	Arguments:
		User oUser
	History:
		2013-01-04 - EK - Created
	*/
	public void function delete( Required model.beans.user oUser ){
		try{
			entityDelete(arguments.oUser);
			ormFlush();
		} catch (any e){
			application.services.tools.log("Error in deleting user bean", e);
		}
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$getByEmail
	Summary:
		Retrieves an user by e-mail
	Returns:
		Array arUser
	Arguments:
		String sEmail
	History:
		2013-01-04 - EK - Created
	*/
	public Array function getByEmail( Required String sEmail ){
		var arUser = ormExecuteQuery( "from user where sEmail = :sEmail", { "sEmail" = arguments.sEmail });
		return arUser;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$getByUsernamePassword
	Summary:
		Determines if the user should be authenticated
	Returns:
		Array arUser
	Arguments:
		String sEmail
		String sPassword
	History:
		2013-04-07 - EK - Created
	*/
	public Array function getByUsernamePassword( Required String sEmail, Required String sPassword ){
		var arUser = ormExecuteQuery( "from user where sEmail = :sEmail and sPassword = :sPassword", { "sEmail" = arguments.sEmail, "sPassword" = arguments.sPassword });
		return arUser;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$setTempValues
	Summary:
		Temporarily sets values for the user object
	Returns:
		User oUser
	Arguments:
		User oUser
		Struct stForm
	History:
		2013-07-21 - EK - Created
	*/
	public model.beans.user function setTempValues( Required model.beans.user oUser, Required struct stForm ){
		try{
			var sField = "";
			var lstExcludedFields = "nID";
			// get local variable for arguments
			request.oBean = arguments.oUser;
			// loop through the fields
			for( sField in arguments.stForm ){
				// make sure we aren't exlcuding this field
				if( not listFindNoCase(lstExcludedFields, sField) ){
					// handle different fields
					switch(sField){
						default:
							// include the logic which will operate dynamically on the form field
							include "set.cfm";
					}
				}
			}
		} catch (any e){
			application.services.tools.log("Error in saving acount bean", e);
		}
		return request.oBean;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$getByVerificationCode
	Summary:
		Finds the user by given verification code
	Returns:
		Array arUser
	Arguments:
		String sVerificationCode
	History:
		2013-07-21 - EK - Created
	*/
	public Array function getByVerificationCode( Required String sVerificationCode ){
		var arUser = ormExecuteQuery( "from user where sVerificationCode = :sVerificationCode", { "sVerificationCode" = arguments.sVerificationCode });
		return arUser;
	}

		/*
	Author: 	
		Ethan Kurtz
	Name:
		$getByMailbox
	Summary:
		Finds a user by mailbox number
	Returns:
		Array arUser
	Arguments:
		String sMailbox
	History:
		2013-09-04 - EK - Created
	*/
	public Array function getByMailbox( Required String sMailbox ){
		var arUser = ormExecuteQuery( "from user where sMailbox = :sMailbox", { "sMailbox" = arguments.sMailbox });
		return arUser;
	}


}