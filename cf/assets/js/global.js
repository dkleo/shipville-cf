$(function(){
	// prevent ajax from caching
	$.ajaxSetup({ cache: false });
	// define login functionality
	$("#pagebody").on("click", ".login button", function(){
		login();
	});
	$("#pagebody").on("keypress", "#sPassword", function(event){
		if( event.which == 13 ){
			login();
		}
	});
	// define global block ui css
	$.blockUI.defaults.overlayCSS.backgroundColor = "#c0c0c0";

	// bind estimating
	$("body").on("click", ".calculate", function(){
		var sForm = "estimator";
		var sFormAction = "manage.getEstimate";
		// check to see if this in the shipment form
		if( $(this).parents("#shipment").length > 0 ){
			sForm = "shipment";
		}
		// set the form action
		if( $(this).parents(".non-authenticated").length > 0 ){
			sFormAction = "main.estimator&doEstimate=true";
		}
		oForm = $("#" + sForm);
		// make sure there are values
		if( validateForm(oForm) ){
			// set loading
			block($("#shippingEstimates"));
			// hide the "click for more options" text
			$(".shipment-choices").hide();
			// make calls with data
			$.post("/cf/index.cfm?action=" + sFormAction,
					getFormFields(sForm), function(stResults){
					// make sure there is a fedex component
					if( stResults.ARFEDEX && stResults.ARFEDEX.length > 0 ){
						// hide the helper
						$("#sFedExShipping").children().remove();
						// loop through the rates
						for( itm=0; itm < stResults.ARFEDEX.length; itm++ ){
							// create a new list of options
							$("#sFedExShipping").append('<option value="' + stResults.ARFEDEX[itm].TYPE + '">' + stResults.ARFEDEX[itm].SSHIPMENTTYPELABEL + " " + stResults.ARFEDEX[itm].TOTAL + " " + stResults.ARFEDEX[itm].DELIVERYTIMESTAMP + '</option>');
						}
						// unhide the "click for more options" text
						$(".shipment-choices").show();
					} else {
						alert("There was an error retrieving shipping estimates please try again");
					}
					// unblock the ui
					unBlock($("#shippingEstimates"));
				}, "json"
			);
			
		}
	});

	// bind change for unit in estimator
	$("body").on("change", "#sUnit", function(){
		switch($(this).val()){
			case "imperical":
				$(".unit.size").html("in");
				break;
			case "metric":
				$(".unit.size").html("cm");
				break;
		}
	});

	// bind forgot password
	$("#pagebody").on("click", ".forgot-password button", function(){
		if( validateForm($("#password")) ){
			$.post("/cf/index.cfm?action=user.sendPasswordReset",
				{
					"sEmail": $("#sEmail").val()
				}, function(bSent){
					if(bSent){
						alert("An email has been sent which will allow you to reset your password");
					} else {
						alert("Something has happened, please try again");
					}
				}, "json"
			);
		}

	});

	// bind password reset
	$("#pagebody").on("click", ".password button", function(){
		// validate the form
		if( validateForm($("#password")) ) {
			$.post("/cf/index.cfm?action=user.save",
				{
					"sPassword": $("#sPassword").val(),
					"nID": $("#nID").val()
				}, function(stResults){
					// if it was successful
					if(stResults.bUserSaved){
						alert("You're password has been reset. Please login.");
						window.location.href = "/members/?action=manage.home";
					} else {
						alert("Something has happened and your password was NOT reset. Please try again");
					}
				}, "json"
			);
		} else {
			return false;
		}
	});

});

// login
function login(){
	// clear message
	$(".login-fail").html("");
	// submit to authentication
	$.post("/cf/index.cfm?action=security.authenticate",
		{
			"sEmail": $("#sEmail").val(),
			"sPassword": $("#sPassword").val()
		}, function(stResults){
			if( stResults.bLoggedIn ){
				// refresh screen
				window.location.href = window.location.href;
			} else {
				$(".login-fail").html(stResults.sMessage);
				return false;
			}
		}, "json"
	);
}

// load pane
function loadPane(sAction, sTarget, stData, bForce){
	var bCallServer = false;
	// hide validation from current form
	$("#tiptip_holder").hide();
	// default action data
	if( typeof stData != "object" ){
		stData = {};
	}
	if( typeof bForce != "boolean" ){
		bForce = false;
	}
	if( bForce || $("#panes [role='" + sTarget + "']").html().length == 0 ){
		bCallServer = true;
	}
	// check to see if the content exists yet
	if( bCallServer ){
		$.ajax({
			url: "/cf/index.cfm?action=" + sAction,
			data: stData,
			success: function(sResults){
				// set the results and show the pane
				$("#panes [role='" + sTarget + "']").html(sResults);
			},
			type: "get",
			async: false
		});
	}
	// hide all of the other panes
	$(".pane").hide();
	// show this pane 
	$("#panes [role='" + sTarget + "']").show();
}

// load HTML into modal and load modal
function loadModal(sAction, stData, nWidth, nHeight){
	if( typeof stData != "object" ){
		stData = {}
	}
	if( typeof nWidth != "number" ){
		nWidth = 600;
	}
	if( typeof nHeight != "number" ){
		nHeight = 500;
	}
	// block the modal
	//block($("#modal"));
	// open the modal
	$("#modal").modal({
		opacity: 80,
		overlayCss: {backgroundColor:"#fff"},
		//position: [""],
		autoPosition: true
	});
	// get the content for the modal
	$.ajax({
		url: "/cf/index.cfm?action=" + sAction,
		data: stData,
		success:function(sResults){
			// set content
			$("#modal .wrapper").html(sResults);
		},
		async: false,
		method: "post"
	});
	// resize dialog
	$("#simplemodal-container").css({ width: nWidth + "px", height: nHeight + "px"} );
	// unblock
	//unBlock($("#modal"));
}

// tabs function
(function($){

	$.fn.daTabs = function(){
		// return each tab
		return this.each(function(){
			// each instance of the tab
			$this = $(this);
			// the container with the content
			$content = $this.next("#tab-content");
			// hide all but the first one
			$content.find("article").each(function(index){
				if( index != 0 ){
					$(this).hide();
				}
			});
			// bind the onclick
			$this.on("click", "li", function(){
				// remove the selected class
				$this.find(".selected").removeClass("selected");
				// add it to this li
				$(this).addClass("selected");
				// hide all children
				$content.find("article").hide();
				// show the one clicked
				$content.find("#" + $(this).data("content")).show();
			});
		});
	}

})( jQuery );

// retrieves the form fields from the form
function getFormFields(arForms, arExcludeFields){
	var stFormFields = {};
	var itm = 0;
	// serialize the form
	var arFormFieldPart = [];
	var arFormFields = [];
	var stFormFields = {};
	if( typeof arExcludeFields != "object" ){
		arExcludeFields = [];
	}
	if( typeof arForms == "string" ){
		arFormFields = $("#" + arForms).serializeArray();
	} else if( typeof arForms == "object" ){
		for( itm=0; itm < arForms.length; itm++ ){
			arFormFieldPart = $("#" + arForms[itm]).serializeArray();
			arFormFields = arFormFields.concat(arFormFieldPart);
		}
	} else {
		arFormFields = $("#panes").serializeArray();
	}
	// build name value pairs for these fields
	for(itm=0; itm < arFormFields.length; itm++ ){
		// if this field is not present in the excluded fields array
		if( $.inArray(arFormFields[itm].name, arExcludeFields) < 0 ){
			stFormFields[arFormFields[itm].name] = arFormFields[itm].value;
		}
	}
	return stFormFields;
}

// handles assigning validation to fields
function loadValidation(){
	$(".required").tipTip({
		defaultPosition: "right",
		activation: "click"
	});
}

// form validation
function validateForm(oForm){
	bIsValid = true;
	// hide validation from current form
	$("#tiptip_holder").hide();
	// loop through all of the required fields for this "form"
	$(oForm).find(".required").each(function(){
		if( $(this).prev("input,select").length > 0 ){
			// get the previous field and make sure it has length
			if( $(this).prev("input,select").val().length == 0 ){
				// make field invalid
				notValid($(this).prev("input,select"));
				// make form invalid
				bIsValid = false;
				// break out
				return false;
			}
		}
	});
	return bIsValid;
}

// handles the non-field validation work
function notValid(sNode){
	// turn on the tip
	$(sNode).next(".required").trigger("click");
	// highlight field
	$(sNode).focus();
}

// block ui
function block(oNode){
	$(oNode).block({
		message: "<img src='/cf/assets/images/ajax-loader.gif'/>",
		css: {
			"background-color": "#fff",
			"opacity": "50%"
		}
	});
}

function unBlock(oNode){
	$(oNode).unblock();
}

function getURLParameter(oParam) {
    return decodeURI(
        (RegExp(oParam + '=' + '(.+?)(&|$)').exec(location.search)||[,null])[1]
    );
}
