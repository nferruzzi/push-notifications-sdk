//
//  AppDelegate.h
//  PushNotificationsApp
//

#import <Cocoa/Cocoa.h>
#import "PushNotificationManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, PushNotificationDelegate> {
	PushNotificationManager *_pushManager;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) PushNotificationManager *pushManager;

@end
