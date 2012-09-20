//Application Window Component Constructor
function ApplicationWindow() {
	//load component dependencies
	var FirstView = require('ui/common/FirstView');
	
	var pushnotifications = require('com.arellomobie.push');
	Ti.API.info("module is => " + pushnotifications);
	
	pushnotifications.pushNotificationsRegister("GOOGLE_PROJECT_ID", "PUSHWOOSH_APP_ID", {
		//NOTE: all the functions fire on the background thread, do not use any UI or Alerts here
		success:function(e)
		{
			Ti.API.info('JS registration success event: ' + e.registrationId);
		},
		error:function(e)
		{
			Ti.API.error("Error during registration: "+e.error);
		},
		callback:function(e) // called when a push notification is received
		{
			Ti.API.info('JS message event: ' + JSON.stringify(e.data));
		}
	});

	//create component instance
	var self = Ti.UI.createWindow({
		backgroundColor:'#ffffff',
		navBarHidden:true,
		exitOnClose:true
	});
		
	//construct UI
	var firstView = new FirstView();
	self.add(firstView);
	
	return self;
}

//make constructor function the public component interface
module.exports = ApplicationWindow;
