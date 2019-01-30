<form id="financial">
<fieldset>
	<ul>
		<li><label for="sCardNumber">Card Number(*)</label><input type="text" name="sCardNumber" id="sCardNumber" value=""/><div class="required" title="Please enter a valid credit card number"></div></li>
		<li><label for="sExpirationMonth">Expiration Month/Year(*)</label><input type="text" name="sExpirationMonth" id="sExpirationMonth" value="" class="date-month" maxlength="2"/><input type="text" name="sExpirationYear" id="sExpirationYear" value="" class="date-year" maxlength="4"/><div class="required" title="Please enter a valid expiration"></div></li>
		<li><label for="sCCV" class="clear-float">CCV(*)</label><input type="text" name="sCCV" id="sCCV" class="ccv" value="" maxlength="3"/><div class="required" title="Please enter a valid CCV"></div></li>
		<li><label for="sNameOnCard" class="clear-float">Name on Card(*)</label><input type="text" name="sNameOnCard" id="sNameOnCard" value=""/><div class="required" title="Please enter a valid name on card"></div></li>
	</ul>
	<input type="hidden" name="sPaymentID" id="sPaymentID" value=""/>
	<input type="hidden" name="sPaymentCardID" id="sPaymentCardID" value=""/>
	<button type="button" id="clearFinancial">Clear</button><button type="button" class="next-step">Next Step: Confirm</button>
</fieldset>
</form>
<script>
	$(function(){
		// load the validation for this form
		loadValidation();
		setTimeout( function(){ $("#sCardNumber").focus(); }, 100);
	});
</script>