component {
	
	public void function log( Required String sMessage, stCFCatch = {} ){
		var sLogFile = "#expandPath('/shipville/data/logs/')##dateFormat(now(), 'yyyymmdd')#.errors.log";
		var dTimeStamp = dateFormat(now(), "yyyy-mm-dd") & " " & timeFormat(now(), "hh:mm:ss");
		var sLogEntry = "";
		savecontent variable="sLogEntry" { writeOutput("
-----------------
Entry Date/Time: #dTimeStamp#
        Comment: #arguments.sMessage#
		");}
		if(structKeyExists(arguments.stCFCatch, "stackTrace")){
			savecontent variable="sLogEntry" { writeOutput("#sLogEntry#
	Stack Trace: 
    #stCFCatch.stackTrace#
			");}
		}
		if( not fileExists(sLogFile)){
			fileWrite(sLogFile, sLogEntry);
		} else {
			// open an instance of the log file
			oLogFile = fileOpen(sLogFile, "append");
			// append the new message
			fileWriteLine(oLogFile, sLogEntry);
			// close the file
			fileClose(oLogFile);
		}
	}

	// extracts the form fields and builds simple structure
	public Struct function buildFormStructure( Required Struct stRC ){
		var stForm = {};
		var itm = 1;
		var sKey = "";
		if( structKeyExists(arguments.stRC, "fieldNames") ){
			for(itm; itm lte listLen(arguments.stRC.fieldNames); itm++ ){
				sKey = listGetAt(arguments.stRC.fieldNames, itm);
				if( structKeyExists(arguments.stRC, sKey) ){
					// this data may come in as urlEncoded
					stForm[sKey] = urlDecode(arguments.stRC[sKey]);
				}
			}
		}
		return stForm;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$dbDateFormat
	Summary:
		Returns a date formatted for db searching
	Returns:
		String dtFormatted
	Arguments:
		String dtDate
		String dtTime
	History:
		2013-05-12 - EK - Created
	*/
	public String function dbDateFormat( String dtDate = now()){
		return dateFormat(arguments.dtDate, "yyyy-mm-dd") & " " & timeFormat(arguments.dtDate, "HH:mm:ss");
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$dbDayBegin
	Summary:
		Returns the date/time for the beginning of a day
	Returns:
		String dtFormatted
	Arguments:
		String dtDate
	History:
		2013-05-12 - EK - Created
	*/
	public String function dbDayBegin( String dtDate = now() ){
		return dbDateFormat(createDateTime(year(arguments.dtDate), month(arguments.dtDate), day(arguments.dtDate), "00", "00", "00" ));
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$dbDayEnd
	Summary:
		Returns the date/time for the end of a day
	Returns:
		String dtFormatted
	Arguments:
		String dtDate
	History:
		2013-05-12 - EK - Created
	*/
	public String function dbDayEnd( String dtDate = now() ){
		return dbDateFormat(createDateTime(year(arguments.dtDate), month(arguments.dtDate), day(arguments.dtDate), "23", "59", "59" ));
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$sentenceCase
	Summary:
		Returns a string with the first letter captialized and the rest lower case
	Returns:
		String sFixed
	Arguments:
		String sIn
	History:
		2013-07-15 - EK - Created
	*/
	public String function sentenceCase( Required String sIn ){
		if( len(arguments.sIn) gt 1 ){
			arguments.sIn = uCase(left(arguments.sIn, 1)) & lCase(right(arguments.sIn, len(arguments.sIn)-1));
		}
		return arguments.sIn;
	}

	/*
	Author: 	
		Ethan Kurtz
	Name:
		$setCookie
	Summary:
		Sets a cookie
	Returns:
		Void
	Arguments:
		String name
		String value
		Any expires
		String domain
		String httpOnly
		String path
		Boolean secure
	History:
		2013-07-15 - EK - Created
	*/

	public Void function setCookie( Required String name, String value, Any expires, String domain = "shipville.com", String httpOnly = "no", String path = "/", Boolean secure){
		var args = {};
		var arg = "";
		for( arg in arguments ){
			if( not isNull(arguments[arg]) ){
				args[arg] = arguments[arg];
			}
		}
		include "setCookie.cfm";
	}


	/*
	Author: 	
		Ethan Kurtz
	Name:
		$arrayOfStructsSort
	Summary:
		Sorts an array of structs by the value in one of the keys
	Returns:
		Array
	Arguments:
		Array aOfS
		String key
	History:
		2013-07-15 - EK - Created
	*/

	public Array function arrayOfStructsSort(Required Array aOfS, Required String key){
        //by default we'll use an ascending sort
        var sortOrder = "asc";        
        //by default, we'll use a textnocase sort
        var sortType = "textnocase";
        //by default, use ascii character 30 as the delim
        var delim = ".";
        //make an array to hold the sort stuff
        var sortArray = arraynew(1);
        //make an array to return
        var returnArray = arraynew(1);
        //grab the number of elements in the array (used in the loops)
        var count = arrayLen(aOfS);
        //make a variable to use in the loop
        var ii = 1;
        //if there is a 3rd argument, set the sortOrder
        if(arraylen(arguments) GT 2)
            sortOrder = arguments[3];
        //if there is a 4th argument, set the sortType
        if(arraylen(arguments) GT 3)
            sortType = arguments[4];
        //if there is a 5th argument, set the delim
        if(arraylen(arguments) GT 4)
            delim = arguments[5];
        //loop over the array of structs, building the sortArray
        for(ii = 1; ii lte count; ii = ii + 1)
            sortArray[ii] = aOfS[ii][key] & delim & ii;
        //now sort the array
        arraySort(sortArray,sortType,sortOrder);
        //now build the return array
        for(ii = 1; ii lte count; ii = ii + 1)
            returnArray[ii] = aOfS[listLast(sortArray[ii],delim)];
        //return the array
        return returnArray;
	}
}