<div class="user-form" id="edit">
	<ul id="manage" class="nav">
		<li data-pane="adminHome" class="active">Home<span></span></li>
		<li data-pane="users">Users<span></span></li>
		<li data-pane="shipments">Shipments<span></span></li>
		<li data-pane="estimator">Estimator<span></span></li>
		<li>Logout<span></span></li>
	</ul>
	<div id="panes">
		<!-- // manage -->
		<div role="adminHome" class="pane"></div>
		<!-- // users data -->
		<div role="users" class="pane"></div>
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
<script src="/cf/assets/js/admin.js"></script>
<input type="hidden" id="bPaneDataChanged" value="0"/>