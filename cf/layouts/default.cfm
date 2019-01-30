<cfparam name="rc.bShowDebug" default="false">
<cfif not rc.bIsDialog>
	<!--- <link href="/cf/assets/css/layout.css" rel="stylesheet"/>
	<link href="/cf/assets/packages/tipTipv13/tipTip.css" rel="stylesheet"/>
	<!--- <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></script> --->
	<!--- <script src="/cf/assets/packages/tipTipv13/jquery.tipTip.minified.js"></script> --->
	<script src="/cf/assets/packages/tipTipv13/jquery.tipTip.js"></script>
	<script src="/cf/assets/js/jquery.json-2.3.min.js"></script>
	<script src="/cf/assets/js/global.js"></script>
	<script src='/cf/assets/packages/modal/js/jquery.simplemodal.js'></script>
	<script src='/cf/assets/packages/blockui/jquery.blockUI-2.57.0.js'></script>
	<script src='/cf/assets/packages/modal/js/basic.js'></script> --->
	<cfoutput><div id="pagebody">#body#</pagebody></cfoutput>
<cfelse>
	<cfoutput>#body#</cfoutput>
</cfif>