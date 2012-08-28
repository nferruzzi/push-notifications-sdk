//
//  AppDelegate.m
//  GeoTagsSampleApp
//
//  Created by Vladislav Zozulyak on 31.07.12.
//  Copyright (c) 2012 exeshneg@gmail.com. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PushNotificationManager.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
	
	navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
	[navController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
	self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];

	//You can set custom delegate or custom orientations for Rich Pushes
//	PushNotificationManager * pushManager = [PushNotificationManager pushManager];
//	pushManager.delegate = self;
//	pushManager.supportedOrientations = PWOrientationPortrait | PWOrientationLandscapeLeft | PWOrientationLandscapeRight;
	
    return YES;
}

- (void) onPushAccepted:(PushNotificationManager *)manager withNotification:(NSDictionary *)pushNotification {
	//it has push information
	NSString *pushExtraData = [manager getCustomPushData:pushNotification];
	if(pushExtraData) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Push Extra Data" message:pushExtraData delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		[alert show];
		[alert release];
	}
}

/*
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
	NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
	NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	NSLog(@"didReceiveRemoteNotification");
}
 */

- (void)dealloc
{
	self.navController = nil;
	[_window release];
	[_viewController release];
    [super dealloc];
}

+ (AppDelegate *) sharedDelegate {
	return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

@end
