//
//  PushNotificationsAppAppDelegate.h
//  PushNotificationsApp
//

#import <UIKit/UIKit.h>
#import "PushNotificationManager.h"

@interface PushNotificationsAppAppDelegate : NSObject <UIApplicationDelegate, PushNotificationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	PushNotificationManager *pushManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) PushNotificationManager *pushManager;

@end

