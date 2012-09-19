var PushWoosh = {
	getToken : function() {
		return Ti.Network.remoteDeviceUUID;
	},
	
	register : function(lambda, lambdaerror) {
		var method = 'POST';
		var token = PushWoosh.getToken();
		var url = PushWoosh.baseurl + 'registerDevice';
		
		var dt = new Date();
		var timezoneOffset = dt.getTimezoneOffset() * 60;	//in seconds
		
		var params = {
				request : {
					application : PushWoosh.appCode,
					push_token : token,
					language : Titanium.Platform.locale,
					hwid : Titanium.Platform.id,
					timezone : timezoneOffset,
					device_type : 1
				}
			};

		payload = (params) ? JSON.stringify(params) : '';
		Ti.API.info('sending registration with params ' + payload);
		PushWoosh.helper(url, method, payload, function(data, status) {
			Ti.API.log('completed registration: ' + JSON.stringify(status));
			if(status == 200) {
				lambda({
					action : "subscribed",
					success : true
				});
			} else {
				Ti.API.log('error registration: ' + JSON.stringify(status));
			}
		}, function(xhr, error) {
			Ti.API.log('xhr error registration: ' + JSON.stringify(error));
		});
	},
	
	unregister : function(lambda) {
		var method = 'POST';
		var token = PushWoosh.getToken();
		var url = PushWoosh.baseurl + 'unregisterDevice';
		
		var params = {
				request : {
					application : PushWoosh.appCode,
					hwid : Titanium.Platform.id
				}
			};

		payload = (params) ? JSON.stringify(params) : '';
		Ti.API.info('sending registration with params ' + payload);
		PushWoosh.helper(url, method, payload, function(data, status) {
			if(status == 200) {
				lambda({
					status : status
				});
			} else {
				lambda({
					status : status
				});
			}
		}, function(xhr, error) {
			lambda({
				success : false,
				xhr : xhr.status,
				error : error
			});
		});
	},
	
	helper : function(url, method, params, lambda, lambdaerror) {
		var xhr = Ti.Network.createHTTPClient();
		xhr.setTimeout(60000);
		xhr.onerror = function(e) {
			lambdaerror(this, e);
		};
		xhr.onload = function() {
			var results = this.responseText;
			lambda(results, this.status);
		};
		// open the client
		xhr.open(method, url);
		xhr.setRequestHeader('Content-Type', 'application/json; charset=utf-8');
		// send the data
		xhr.send(params);
	}
};

PushWoosh.baseurl = 'https://cp.pushwoosh.com/json/1.3/';
