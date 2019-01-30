// on load
$(function(){

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

	// ### SHIPMENTS ###
	// bind search filter
	$("#pagebody").on("change", "#sStatus", function(){
		window.location.href = window.location.href.split("&")[0] + "&sStatus=" + $("#sStatus").val();
	});

	// bind edit shipment
	$("#pagebody").on("click", "#shipments .edit", function(){
		loadModal("admin.addEditShipment", { nShipmentID: $(this).data("nshipmentid")}, 850, 600);
	});

	// bind deleting a shipment
	$("#pagebody").on("click", "#shipments .delete", function(){
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
					// reload the page
					window.location.href = window.location.href;
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
		// do confirmation if they have provided a cost
		if( $("#nCost").val().length > 0 ){
			if( $("#dtActualShipment").val().length == 0 ){
				alert("Please provide a valid shipment date");
				return false;
			}
			if( $("#sTrackingNumber").val().length == 0 ){
				alert("Please provide a valid tracking number");
				return false;
			}
			if( !confirm("A charge of $" + $("#nCost").val() + " will be applied to this account. Are you sure you want continue") ){
				return false;
			}
		}
		$.post("/cf/index.cfm?action=admin.saveShipment",
			getFormFields("shipment"),
			function(bResults){
				if( bResults ){
					// close the dialog
					$.modal.close();
					// reload the page
					window.location.href = window.location.href;
				} else {
					alert("There was an error saving shipment. Please try again.");
				}
			},"json"
		);
	});

	// bind estimating
	$("body").on("click", ".calculate", function(){
		var oForm = $("#estimator .details");
		// check to see if this in the shipment form
		if( $(this).parents("#shipment").length > 0 ){
			oForm = $("#shipment .details");
		}
		// make sure there are values
		if( validateForm(oForm) ){
			// set loading
			block($(".estimates table"));
			// clear the contents

			// make calls with data
			$.post("/cf/index.cfm?action=manage.getEstimate",
				{
					nWidth: $("#nWidth").val(),
					nHeight: $("#nHeight").val(),
					nDepth: $("#nDepth").val(),
					nWeight: $("#nWeight").val()
				}, function(stResults){
					// loop through the choices
					for( sChoice in stResults ){
						// loop through the service providers
						for( sProvider in stResults[sChoice] ){
							$("[data-id='" + sChoice + "'] [data-id='" + sProvider + "'] span").html(stResults[sChoice][sProvider]);
						}
					}
					// unblock the ui
					unBlock($(".estimates table"));
				}, "json"
			);
			
		}
	});

});