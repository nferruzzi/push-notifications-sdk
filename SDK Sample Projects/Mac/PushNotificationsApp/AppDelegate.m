//
//  AppDelegate.m
//  PushNotificationsApp
//

#import "AppDelegate.h"
#import "PushNotificationManager.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
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
