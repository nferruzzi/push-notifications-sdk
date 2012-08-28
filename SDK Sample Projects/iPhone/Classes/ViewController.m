//
//  ViewController.m
//  PushNotificationsApp
//
//  (c) Pushwoosh 2012


#import "ViewController.h"
#import "PushNotificationManager.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize deviceIdField, userIdField;

- (void) initializeLocationManager {
	if (locationManager) {
		[locationManager stopUpdatingLocation];
		[locationManager release]; locationManager = nil;
	}
	
	if (operationQueue) {
		[operationQueue release]; operationQueue = nil;
	}
	
	operationQueue = [[NSOperationQueue alloc] init];
	operationQueue.maxConcurrentOperationCount = 1;
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDelegate:self];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
}

- (void) startTracking {
	NSLog(@"Start tracking");
	[locationManager startUpdatingLocation];
}

- (void) stopTracking {
	NSLog(@"Stop tracking");
	[locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:[PushNotificationManager pushManager] selector:@selector(sendLocation:) object:newLocation];
	[operationQueue addOperation:operation];
	
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	if (textField == deviceIdField) {
		[userIdField becomeFirstResponder];
	} else if (textField == userIdField) {
		[self submitAction:userIdField];
	}
	
	return YES;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	[self initializeLocationManager];
	[self startTracking];
}

- (void) submitAction:(id)sender {
	NSLog(@"Submitting");
	[deviceIdField resignFirstResponder];
	[userIdField resignFirstResponder];
	
	NSDictionary *tags = [NSDictionary dictionaryWithObjectsAndKeys:
						  [deviceIdField text], @"deviceId", 
						  [NSNumber numberWithInt:[userIdField.text intValue]], @"testInt", 
						  nil];
	
	[[PushNotificationManager pushManager] setTags:tags];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}


- (void) dealloc {
	self.deviceIdField = nil;
	self.userIdField = nil;
	[super dealloc];
}
@end
