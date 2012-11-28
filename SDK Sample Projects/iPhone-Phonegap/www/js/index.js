function initPushwoosh() {
	var pushNotification = window.plugins.pushNotification;
	pushNotification.onDeviceReady();
	
	pushNotification.registerDevice({alert:true, badge:true, sound:true, pw_appid:"PUSHWOOSH_APP_ID", appname:"Pushwoosh"},
									function(status) {
									var deviceToken = status['deviceToken'];
									console.warn('registerDevice: ' + deviceToken);
									},
									function(status) {
									console.warn('failed to register : ' + JSON.stringify(status));
									navigator.notification.alert(JSON.stringify(['failed to register ', status]));
									});
	
	pushNotification.setApplicationIconBadgeNumber(0);
	
	document.addEventListener('push-notification', function(event) {
							  var notification = event.notification;
							  navigator.notification.alert(notification.aps.alert);
							  pushNotification.setApplicationIconBadgeNumber(0);
							  });
}

var app = {
    initialize: function() {
        this.bind();
    },
    bind: function() {
        document.addEventListener('deviceready', this.deviceready, false);
    },

    deviceready: function() {
        // note that this is an event handler so the scope is that of the event
        // so we need to call app.report(), and not this.report()
        initPushwoosh();

        app.report('deviceready');
		
		var pushNotification = window.plugins.pushNotification;
		pushNotification.setTags({deviceName:"hello", deviceId:10},
										function(status) {
											console.warn('setTags success');
										},
										function(status) {
											console.warn('setTags failed');
										});

		
		function geolocationSuccess(position) {
			pushNotification.sendLocation({lat:position.coords.latitude, lon:position.coords.longitude},
									 function(status) {
										  console.warn('sendLocation success');
									 },
									 function(status) {
										  console.warn('sendLocation failed');
									 });

		};
		
		// onError Callback receives a PositionError object
		//
		function geolocationError(error) {
			alert('code: '    + error.code    + '\n' +
				  'message: ' + error.message + '\n');
		}
		
		function getCurrentPosition() {
			navigator.geolocation.getCurrentPosition(geolocationSuccess, geolocationError);
		}
		
		//greedy method to get user position every 3 second. works well for demo.
		setInterval(getCurrentPosition, 3000);
		
		//this method just gives the position once
//		navigator.geolocation.getCurrentPosition(geolocationSuccess, geolocationError);
		
		//this method should track the user position as per Phonegap docs.
//		navigator.geolocation.watchPosition(geolocationSuccess, geolocationError, { maximumAge: 3000, enableHighAccuracy: true });
    },
    report: function(id) {
        console.log("report:" + id);
        // hide the .pending <p> and show the .complete <p>
        document.querySelector('#' + id + ' .pending').className += ' hide';
        var completeElem = document.querySelector('#' + id + ' .complete');
        completeElem.className = completeElem.className.split('hide').join('');
    }
};
