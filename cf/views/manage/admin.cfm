<div class="user-form" id="edit">
	<!--- <ul id="manage" class="nav">
		<li data-pane="manageHome" class="active">Home<span></span></li>
		<li data-pane="membership">Membership<span></span></li>
		<li data-pane="profile">Profile<span></span></li>
		<li data-pane="creditcards">Credit Card<span></span></li>
		<li data-pane="shipments">Shipments<span></span></li>
		<li data-pane="estimator">Estimator<span></span></li>
		<li>Logout<span></span></li>
	</ul> --->
	<div id="panes">
		<!-- // manage -->
		<div role="manageHome" class="pane"></div>
		<!-- // membership -->
		<div role="membership" class="pane"></div>
		<!-- // profile data -->
		<div role="profile" class="pane"></div>
		<!-- // creditcards -->
		<div role="creditcard" class="pane"></div>
		<!-- // confirm -->
		<div role="shipments" class="pane"></div>
		<!-- // complete -->
		<div role="estimator" class="pane"></div>
	</div>
</div>
<!--- // modal --->
<div id="modal">
	<div class="wrapper"></div>
</div>
<script src="/cf/assets/js/manage.js"></script>
<input type="hidden" id="bPaneDataChanged" value="0"/>