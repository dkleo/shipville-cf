var sNextStep = "membership";
var arSteps = [ "membership", "profile", "financial", "confirm", "complete"];
var stMembership = { 1: "basic", 2: "silver", 3: "gold" };
var stFormFields = {};
var bUserSaved = false;
var sStep = "";
var bEmailIsValid = true;
// on load
$(function(){
	// handle membership
	$("#pagebody").on("click", "#basic-membership,#silver-membership,#gold-membership", function(){
		// remove active class from the current active button
		$("#membership button").removeClass("active").removeClass("deactive");
		// make this selected
		$(this).addClass("active");
		// make all others deactive
		$("#membership button").not(".active").addClass("deactive");
		// set the membership value
		$("#nMembership").val($(this).data("id"));
		// trigger the next step to load profile data
		$("#membership .next-step").trigger("click");
	});
	// at load time load the first step
	loadStep(sNextStep);

	// handle "next" clicking within the app
	$("#pagebody").on("click", ".next-step", function(){
		// figure out which step is being worked with
		sStep = $(this).closest("form").prop("id");
		// handle validation
		if( !validateForm($("#" + sStep)) ){
			return false;
		}
		// do some different work for each of the steps
		switch(sStep){
			// check to see if the e-mail address is used already
			case "profile":
				// make sure that the passwords match
				if( $("#sPassword").val() != $("#sConfirm").val() ){
					notValid($("#sConfirm"));
					return false;
				}
				// make sure that this e-mail address is valid
				$.ajax({
					type: "post",
					url: "/cf/index.cfm?action=user.checkEmail",
					data: { sEmail: $("#sEmail").val() },
					success: function(bResults){
						bEmailIsValid = bResults;
					},
					error: function(){
						bEmailIsValid = false;
					},
					dataType: "json",
					async: false

				});
				if( !bEmailIsValid ){
					$(".invalid-email").trigger("click");
					return false;
				}
				break;
			// send financial information
			case "financial":
				bDoExit = false;
				// make sure that the data for payment isn't already set
				if( $("#sPaymentID").val().length == 0 && $("#sPaymentCardID").val().length == 0 ){
					// process the credit card info
					$.ajax({
						type: "post",
						url: "/cf/index.cfm?action=user.saveFinancial",
						data: getFormFields(["financial","profile"]),
						success: function(stResults){
							// this should be a structure with the data from authorize.net
							if( typeof stResults == "object" && 
								( ( typeof stResults.sPaymentID == "string" && stResults.sPaymentID.length > 0 ) || typeof stResults.sPaymentID == "number" ) ){
								// set the results into the form
								$("#sPaymentID").val(stResults.sPaymentID);
								$("#sPaymentCardID").val(stResults.sPaymentCardID);
							} else {
								alert("Error authorizing credit information. Please enter a new credit card number.");
								bDoExit = true;
							}
						},
						error: function(){
							alert("Error connecting to save credit information. Please try again.");
							bDoExit = true;
						},
						dataType: "json",
						async: false
					});
					// if we had an error - exit out
					if( bDoExit ){
						// mark the credit card information as in valid
						notValid($("#sCardNumber"));
						return false;
					}
				}
				break;
			// if we are on the confirm page - submit form
			case "confirm":
				var bUserSaved = true;
				if( !$("#agree").is(":checked") ){
					alert("You must agree to the terms and conditions.");
					return false;
				}
				// send data
				$.ajax({
					type: "post",
					url: "/cf/index.cfm?action=user.save",
					data: getFormFields(["membership", "profile", "financial"], ["sExpirationYear","sExpirationMonth","sCCV","sCardNumber","sNameOnCard"]),
					success: function(stResponse){
						bUserSaved = stResponse.bUserSaved;
					},
					error: function(){
						bUserSaved = false;
					},
					async: false,
					dataType: "json"
				});
				// if we aren't saved successfully then return
				if( !bUserSaved ){
					alert("Error saving your account. Please try again.");
				} else {
					// mark the account as created
					$("#userCreated").val(1);
				}
				break;
		}
		// load the next pane
		loadStep(sStep, 1);
		// set complete status
		$("#membership-status [data-pane='" + arSteps[$.inArray(sStep, arSteps)] + "']").addClass("completed");
	});

	// load the bind for completed tabs
	$("#pagebody").on("click", "li.completed,button.completed,.change-data", function(){
		// load this pane
		loadStep($(this).data("pane"));
	});

	// clear the financial fields
	$("#pagebody").on("click", "#clearFinancial", function(){
		$("#sCardNumber").val("");
		$("#sExpirationMonth").val("");
		$("#sExpirationYear").val("");
		$("#sCCV").val("");
		$("#sNameOnCard").val("");
	});

});

// handles loading the next step
function loadStep(sStep, nAdd){
	if( typeof nAdd != "number" ){
		nAdd = 0;
	}
	// get the index for this step
	var nStepIndex = $.inArray(sStep, arSteps);
	// load the actual pane
	loadPane("user." + arSteps[nStepIndex + nAdd], arSteps[nStepIndex + nAdd]);
	// set the active state for this pane
	$("#membership-status .active").removeClass("active");
	$("#membership-status [data-pane='" + arSteps[nStepIndex + nAdd] + "']").addClass("active");

	// handle setting the confirm fields
	if( arSteps[nStepIndex + nAdd] == "confirm"){
		// set the current values in confirm
		setConfirmValues();
	}
	// move them to the top
	$("html, body").animate({ scrollTop: 0 }, "slow");
}

// sets the confirm values
function setConfirmValues(){
	var sFormField = "";
	// get the current form values
	var stFormFields = getFormFields(["membership","profile","financial"]);
	var sValue = "";
	// loop and set values
	for(sFormField in stFormFields){
		// handle different fields
		switch(sFormField){
			// handle membership	
			case "nMembership":
				sValue = stMembership[stFormFields[sFormField]];
				break;
			// handle ccnumber
			case "sCardNumber":
				sValue = "xxxx" + stFormFields[sFormField].substr(stFormFields[sFormField].length - 4);
				break;
			// handle CCV
			case "sCCV":
				sValue = "xxx";
				break;
			default:
				sValue = stFormFields[sFormField].replace(/\+/g, " ");
				break;
		}
		// set value
		$(".confirm[data-field='" + sFormField + "']").html(sValue);
	}
}