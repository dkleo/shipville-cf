component {
	
	/*
	Author: 	
		Ethan Kurtz
	Name:
		$get
	Summary:
		Gets the shipment object
	Returns:
		Shipment oShipment
	Arguments:
		Numeric nID
	History:
		2013-04-01 - EK - Created
	*/
	public model.beans.shipment function get( Numeric nID=0 ){
		var oShipment = "";
		var arShipment = [];
		if( arguments.nID == 0 ){
			oShipment = entityNew("shipment");
		} else {
			arshipment = entityLoad("shipment", arguments.nID);
			if( arrayLen(arShipment) ){
				oShipment = arShipment[1];
			}
		}
		return oShipment;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$save
	Summary:
		Saves the shipment entity
	Returns:
		Shipment oShipment
	Arguments:
		Shipment oShipment
		Struct stForm
	History:
		2013-04-01 - EK - Created
	*/
	public model.beans.shipment function save( Required model.beans.shipment oShipment, Required struct stForm ){
		try{
			var sField = "";
			var lstExcludedFields = "nShipmentID";
			// get local variable for arguments
			request.oBean = arguments.oShipment;
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
			application.services.tools.log("Error in saving shipment bean", e);
		}
		return request.oBean;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$delete
	Summary:
		Delete the shipment entity
	Returns:
		Shipment oShipment
	Arguments:
		Shipment oShipment
	History:
		2013-01-04 - EK - Created
	*/
	public void function delete( Required model.beans.shipment oShipment ){
		try{
			entityDelete(arguments.oShipment);
			ormFlush();
		} catch (any e){
			application.services.tools.log("Error in deleting shipment bean", e);
		}
	}


	/*
	Author: 	
		Ethan Kurtz
	Name:
		$getByUser
	Summary:
		Returns all of the shipments for a user
	Returns:
		Array arShipments
	Arguments:
		Numeric nUserID
	History:
		2013-04-19 - EK - Created
	*/
	public Array function getByUser( Required Numeric nUserID ){
		var arShipments = ormExecuteQuery( "from shipment where nUserID = :nUserID", { "nUserID" = arguments.nUserID });
		return arShipments;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$getPending
	Summary:
		Returns all pending shipments
	Returns:
		Array arShipments
	Arguments:
		String dStart
		String dEnd
	History:
		2013-05-12 - EK - Created
	*/
	public Array function getPending( String dtStart = dateAdd("d", -90, now()), String dtEnd = dateAdd("d", 1, now()) ){
		var arShipments = [];
		try{
			arShipments = ormExecuteQuery( "from shipment where (dtReceived is null or dtReceived = '') and dtCreated > :dtStart and dtCreated < :dtEnd", { "dtStart" = application.services.tools.dbDayBegin(arguments.dtStart), "dtEnd" = application.services.tools.dbDayEnd(arguments.dtEnd) });
		} catch (any e){
			application.services.tools.log("Error getting pending shipments", e);
		}
		return arShipments;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$getReceived
	Summary:
		Returns all received shipments
	Returns:
		Array arShipments
	Arguments:
		String dStart
		String dEnd
	History:
		2013-05-20 - EK - Created
	*/
	public Array function getReceived( String dtStart = dateAdd("d", -90, now()), String dtEnd = dateAdd("d", 1, now()) ){
		var arShipments = [];
		try{
			arShipments = ormExecuteQuery( "from shipment where dtReceived is not null and dtReceived > :dtStart and dtReceived < :dtEnd and (dtActualShipment is null or dtActualShipment = '')", { "dtStart" = application.services.tools.dbDayBegin(arguments.dtStart), "dtEnd" = application.services.tools.dbDayEnd(arguments.dtEnd) });
		} catch (any e){
			application.services.tools.log("Error getting pending shipments", e);
		}
		return arShipments;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$getShipped
	Summary:
		Returns all shipped shipments
	Returns:
		Array arShipments
	Arguments:
		String dStart
		String dEnd
	History:
		2013-05-12 - EK - Created
	*/
	public Array function getShipped( String dtStart = dateAdd("d", -90, now()), String dtEnd = dateAdd("d", 1, now()) ){
		var arShipments = [];
		try{
			arShipments = ormExecuteQuery( "from shipment where dtActualShipment is not null and dtActualShipment > :dtStart and dtActualShipment < :dtEnd", { "dtStart" = application.services.tools.dbDayBegin(arguments.dtStart), "dtEnd" = application.services.tools.dbDayEnd(arguments.dtEnd) });
		} catch (any e){
			application.services.tools.log("Error getting pending shipments", e);
		}
		return arShipments;
	}
}