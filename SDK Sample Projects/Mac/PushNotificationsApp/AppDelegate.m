//
//  AppDelegate.m
//  PushNotificationsApp
//

#import "AppDelegate.h"

#define kPushWooshAppKey @"PUSHWOOSH_APP_ID"
#define kApplicationName @"APP_NAME"

@implementation AppDelegate

@synthesize window = _window;
@synthesize pushManager = _pushManager;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[[NSApplication sharedApplication] registerForRemoteNotificationTypes:NSRemoteNotificationTypeBadge];
	
	_pushManager = [[PushNotificationManager alloc] initWithApplicationCode:kPushWooshAppKey appName:kApplicationName];
	_pushManager.delegate = self;
	[_pushManager handlePushReceived:[aNotification userInfo]];
}

#pragma mark -
#pragma mark PushNotificationDelegate

- (void) onPushAccepted:(PushNotificationManager *)manager {
	
}

- (void)application:(NSApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
	[_pushManager handlePushRegistration:devToken];
}

- (void)application:(NSApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
	NSLog(@"Error registering for push notifications. Error: %@", err);
}

- (void)application:(NSApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[_pushManager handlePushReceived:userInfo];
}

#pragma mark -

- (void)dealloc
{
	[_pushManager release];
    [super dealloc];
}

@end
