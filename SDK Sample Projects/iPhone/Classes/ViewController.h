//
//  ViewController.h
//  PushNotificationsApp
//
//  (c) Pushwoosh 2012
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<UITextFieldDelegate, CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	NSOperationQueue *operationQueue;
}

@property (nonatomic, retain) IBOutlet UITextField *deviceIdField;
@property (nonatomic, retain) IBOutlet UITextField *userIdField;

- (IBAction) submitAction:(id)sender;

@end
