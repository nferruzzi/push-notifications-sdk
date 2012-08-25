//
//  AppDelegate.h
//  PushNotificationsApp
//

#import <Cocoa/Cocoa.h>
#import "PushNotificationManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, PushNotificationDelegate> {
}

@property (assign) IBOutlet NSWindow *window;

@end
