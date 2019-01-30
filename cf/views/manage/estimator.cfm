<form id="estimator"><fieldset>
<cfoutput>#view("manage/estimate_form", { bShowAddress = false, bShowCreditCard = false, bShowFrom = false })#</cfoutput>
</fieldset></form>
<script>
	$(function(){
		// load the validation for this form
		loadValidation();
		setTimeout( function(){ $("#nWeight").focus(); }, 100);
	});
</script>