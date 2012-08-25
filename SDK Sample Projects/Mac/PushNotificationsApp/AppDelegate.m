//
//  AppDelegate.m
//  PushNotificationsApp
//

#import "AppDelegate.h"

#define kPushWooshAppKey @"PUSHWOOSH_APP_ID"
#define kApplicationName @"APP_NAME"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[PushNotificationManager initializeAppCode:kPushWooshAppKey appName:kApplicationName];
}

#pragma mark -
#pragma mark PushNotificationDelegate

- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification {
	NSLog(@"Push accepted");
}

#pragma mark -

- (void)dealloc
{
    [super dealloc];
}

@end
