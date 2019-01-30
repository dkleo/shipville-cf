<cfif structKeyExists(request.oBean, "set#sField#")>
	<!--- // invokes the dynamic "set" method on the given bean --->
	<cfinvoke component="#request.oBean#" method="set#sField#">
		<cfinvokeargument name="#sField#" value="#arguments.stForm[sField]#"/>
	</cfinvoke>
</cfif>