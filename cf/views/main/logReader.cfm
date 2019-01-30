<cfdirectory action="list" directory="#rc.logDir#" name="qryLogs" sort="dateLastModified desc" />
<cfoutput>
	<style>
		ul {
			margin: 0;
			padding: 0;
		}
		li {
			list-style: none;
			float: left;
			padding: 5px;
		}
		.record-set {
			width: 1024px;
		}
		.record, .header {
			border: 1px solid ##c0c0c0;
		}
		.header li {
			background-color: ##e4e4e4;
		}
		.col1 {
			width: 400px;
		}
		.col2, .col3 {
			width: 100px;
			text-align: right;
		}
		.col3 {
			width: 200px;
		}
		.clear {
			clear: both;
		}
		.delete-file {
			background-image: url("/cf/assets/images/delete.png");
			width: 20px;
			height: 20px;
			margin-right: 5px;
			display: block;
			float: left;
			cursor: pointer;
		}
	</style>
	<cfif structKeyExists(rc, "fileDeleted") and rc.fileDeleted><h3>File: #rc.deleteFile# deleted successfully</h3></cfif>
	<ul class="record-set">
		<li>
			<ul class="header">
				<li class="col1">Name</li>
				<li class="col2">Size</li>
				<li class="col3">Date</li>
			</ul>
			<div class="clear"/>
		</li>
		<cfloop query="qryLogs">
			<li>
				<ul class="record">
					<li class="col1"><span class="delete-file"></span><a href="#rc.logPath##qryLogs.name#" target="_blank">#qryLogs.name#</a></li>
					<li class="col2">#qryLogs.size#</li>
					<li class="col3">#qryLogs.dateLastModified#</li>
				</ul>
				<div class="clear"/>
			</li>
		</cfloop>
	</ul>
	<script>
		jQuery(function(){
			jQuery(".record-set").on("click", ".delete-file", function(){
				if( confirm("Are you sure?") ){
					window.location.href = '#buildURL("main.logReader")#&deleteFile=' + jQuery(this).siblings("a").html();
				}
			});
		});
	</script>
</cfoutput>