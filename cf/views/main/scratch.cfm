<cfscript>
	arTest = [ { "foo" = 12 }, { "foo" = 24 } ];
	writeDump(application.services.tools.arrayOfStructsSort(arTest, "foo", "desc"));
</cfscript>