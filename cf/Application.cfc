component extends="framework" {

	this.name="shipville";
	this.sessionmanagement = true;
	this.sessiontimeout = createTimeSpan(0,1,0,0);
	this.dsn = "svcf";
	this.mappings["/shipville"] = expandPath('/cf/');
	this.ormenabled = true;
	this.ormsettings = {
		datasource = this.dsn,
		dbcreate = "update",
		dialect = 'MySQL',	
		logSQL = true,
		skipCFCWithError = false,
		useDBForMapping = true,
		cfcLocation = ['model/beans']
	};

	variables.framework = {
		usingSubsystems = false,
		generateSES = false,
		defaultSubsystem = 'home',
		defaultSection = 'main',
		defaultItem = 'default',
		suppressImplicitService = true
	};

	/**
	* establishes the main variables for the application
	*/
	public void function setupApplication(){
		// load some services
		
		application.services = {
			"tools" = new shipville.model.services.tools(),
			"authorizenet" = new shipville.model.services.authorizenet(),
			"user" = new shipville.model.services.user(),
			"shipment" = new shipville.model.services.shipment(),
			"fedex" = new shipville.model.services.fedex()
		};
		application.shipperAddress = "430 N. Killingsworth St.";
		application.shipperAddress2 = "";
		application.shipperCity = "Portland";
		application.shipperState = "OR";
		application.shipperZip = "97217";
		application.shipperCountry = "US";

		application.stMembershipMap = {
			"sName" = {
				"Standard" = 1, "Premium" = 2, "Premium with Mailbox" = 3
			},
			"nID" = {
				1 = "Standard", 2 = "Premium", 3 = "Premium with Mailbox"
			}
		};
	}

	/** 
	* establishes the main request procedures
	*/
	public void function setupRequest(rc){
		// if we are resetting the appspace
		if( structKeyExists(rc, "reload") and rc.reload ){
			setupApplication();
		}
		controller( 'security.checkAuthorization' );
		// set up date timestamp
		rc.dtNow = dateFormat(now(), "yyyy-mm-dd") & " " & timeFormat(now(), "hh:mm:ss");
	}

	/**
	* runs before anything in any of the controllers
	*/
	public void function before(rc){
		lstPages = "manage.admin,user.add,main.logReader,admin.main,user.logout";
		// default everything as a dialog unless its in the list
		if( !listFindNoCase(lstPages, this.getFullyQualifiedAction()) ){
			rc.bIsDialog = true;
		} else {
			rc.bIsDialog = false;
		}
	}

	/**
	* allows for manipulation of view
	*/
	public void function setupView(){
	
	}

	/**
	* establishes the default session variables
	*/
	public void function setupSession(){
		session.nUserID = 0;
		session.bIsAdmin = 0;
	}

	/** 
	* handles errors
	*/
	public void function onError(exception, event){
		writeDump(arguments.exception);
	}

}