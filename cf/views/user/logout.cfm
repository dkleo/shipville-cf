<cftry>
	<cfscript>
		structClear(rc.stuser);
		rc.STUSER.NUSERID = 0;
		redirect(action = 'manage.home');
		//loggedOut = createObject("component","cf.controllers.user").reset(rc);
	</cfscript>
	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>
</cftry>
done