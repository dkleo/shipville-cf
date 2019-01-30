var stMembership = { 1: "basic", 2: "silver", 3: "gold" };
// on load
$(function(){
	// #### Shipping Instructions ####
	$("#pagebody").on("click", "#shippingInstructions", function(){
		loadModal("manage.shippingInstructions");
	});
	// #### MEMBERSHIP ####
	$("#pagebody").on("click", "#basic-membership,#silver-membership,#gold-membership", function(){
		// remove active class from the current active button
		$("#membership button").removeClass("active").removeClass("deactive");
		// make this selected
		$(this).addClass("active");
		// make all others deactive
		$("#membership button").not(".active").addClass("deactive");
		// set the membership value
		$("#nMembership").val($(this).data("id"));
		// save
		$.post("/cf/index.cfm?action=manage.saveProfile",
			getFormFields(["membership"]),
			function(bSaved){
				if(bSaved){
					alert("Membership saved");
					window.location.href = window.location.href;
				} else {
					alert("Error saving membership. Please try again.");
				}
			},"json"
		);
	});
	// load the bind for pane links
	/*$("#pagebody").on("click", "#manage li", function(){
		// make sure that some data hasn't changed
		if( $("#bPaneDataChanged").val() == 0 ){
			// load this pane
			loadStep($(this).data("pane"));
			// clear active
			$("#manage .active").removeClass("active");
			$(this).addClass("active");
		} else {
			alert("Data has been modified would you like to cancel these changes??");
		}
	});*/

	// bind canceling in dialog
	$("#modal").on("click", "#cancel", function(){
		// clear the contents
		$("#modal .wrapper").html("");
		// hide validation from current form
		$("#tiptip_holder").hide();
		$.modal.close();
	});

	// ### PROFILE ###
	// bind saving
	$("#pagebody").on("click", "#profile .save", function(){
		// validate fields
		if( !validateForm($("#profile")) ){
			return false;
		}
		$.post("/cf/index.cfm?action=manage.saveProfile",
			getFormFields(["profile"]),
			function(bSaved){
				if(bSaved){
					alert("Profile saved");
				} else {
					alert("Error saving profile. Please try again.");
				}
			},"json"
		);
	});

	// ### CREDIT CARDS ###

	// bind the add new credit card
	$("#pagebody").on("click", "#creditcards .add", function(){
		loadModal("manage.addCreditCard");
	});

	// bind saving a credit card
	$("#modal").on("click", "#creditcards #save", function(){
		// handle validation
		if( !validateForm($("#creditcards")) ){
			return false;
		}
		$.post("/cf/index.cfm?action=manage.saveCreditCard",
			getFormFields("creditcards"),
			function(stResults){
				if( stResults.bSuccessful ){
					// add the card into the table
					sHTML = '<tr><td>Card ends with <span class="card-number">' + $("#sCardNumber").val().replace(/.(?=.{4})/g, 'X') + '</td><td><button type="button" data-spaymentcardid="' + stResults.sPaymentCardID + '" type="button"><img src="/cf/assets/images/delete.png"></button></td></tr>';
					$("#cards tbody").append(sHTML);
					// close the dialog
					$.modal.close();
					window.location.href = window.location.href;
				} else {
					notValid($("#sCardNumber"));
				}
			},"json"
		);
	});

	// bind deleting a credit card
	$("#pagebody").on("click", "#creditcards .delete", function(){
		var oParent = $(this).closest("tr");
		// get card number
		sCardNumber = $(this).closest("tr").find(".card-number").html();
		if( confirm( "Are you sure you would like to delete the card with numbers ending" + sCardNumber) ){
			// remove the card from the row
			oParent.remove();
			// send delete command
			$.post("/cf/index.cfm?action=manage.deleteCreditCard",
				{
					"sPaymentCardID": $(this).data("spaymentcardid")
				}, function(stResults){
					// should check that it is actually deleted
					window.location.href = window.location.href;
				}, "json"
			);
		}
	});

	// ### SHIPMENTS ###
	// bind the add new shipment
	$("#pagebody").on("click", "#shipments .add", function(){
		loadModal("manage.addEditShipment", {}, 800, 550);
	});

	// bind edit shipment
	$("#pagebody").on("click", "#shipments .edit", function(){
		loadModal("manage.addEditShipment", { nShipmentID: $(this).data("nshipmentid")}, 800, 550);
	});

	// bind deleting a shipment
	$("#pagebody").on("click", "[#shipments .delete", function(){
		var oParent = $(this).closest("tr");
		// get card number
		nShipmentID = $(this).data("nshipmentid");
		if( confirm( "Are you sure you would like to delete the shipment") ){
			// remove the shipment from the row
			oParent.remove();
			// send delete command
			$.post("/cf/index.cfm?action=manage.deleteShipment",
				{
					"nShipmentID": nShipmentID
				}, function(stResults){
					// reload the pane
					loadPane("manage.shipments", "shipments", {}, true );
				}, "json"
			);
		}
	});

	// bind saving a shipment
	$("#modal").on("click", "#shipment #save", function(){
		// handle validation
		if( !validateForm($("#shipment")) ){
			return false;
		}
		$.post("/cf/index.cfm?action=manage.saveShipment",
			getFormFields("shipment"),
			function(bResults){
				if( bResults ){
					// close the dialog
					$.modal.close();
					// reload the pane
					window.location.href = window.location.href;
				} else {
					notValid($("#sForm"));
				}
			},"json"
		);
	});

	// handle binding of change on shipment
	$("body").on("change", "#sFedExShipping", function(){
		$("#sFedExShippingOption").val($("#sFedExShipping").val());
	});

});