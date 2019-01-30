component {
	public shipville.controllers.main function init ( required fw ){
		variables.fw = fw;
		return this;
	}

	public void function logReader(rc){
		rc.logPath = '/cf/data/logs/';
		rc.logDir = expandPath(rc.logPath);
	}

	public void function estimator(rc){
		param name="rc.doEstimate" default="false";
		oUserGateway = new model.gateway.user();
		oShipmentGateway = new model.gateway.shipment();
		rc.oUser = oUserGateway.get();
		rc.oShipment = oShipmentGateway.get();
		rc.stResults = {};
		// if we are actually doing an estimate
		if( rc.doEstimate ){
			try{
				// buld the form struct
				rc.stForm = application.services.tools.buildFormStructure(rc);
				// set temp values for user
				rc.oUser = oUserGateway.setTempValues(rc.oUser, rc.stForm);
				// call services
				rc.stEstimates = application.services.shipment.buildSimpleEstimates(application.services.shipment.estimate(rc.oUser, rc.nWidth, rc.nHeight, rc.nDepth, rc.nWeight), rc.oUser);
				// change view to get results back to form
				variables.fw.setView('manage.getEstimate');
			} catch ( any e ){
				application.services.tools.log(e.message, e);
			}
		}
	}

}