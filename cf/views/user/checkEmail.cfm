<cfparam name="bEmailValid" default="true">
<cfscript>
	if( arrayLen(rc.arUser) gt 0 ){
		bEmailValid = false;
	}
</cfscript>
<cfoutput>#serializeJSON(bEmailValid)#</cfoutput>