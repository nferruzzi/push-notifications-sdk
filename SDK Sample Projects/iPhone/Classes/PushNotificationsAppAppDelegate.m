//
//  PushNotificationsAppAppDelegate.m
//  PushNotificationsApp
//

#import "PushNotificationsAppAppDelegate.h"
#import "RootViewController.h"

@implementation PushNotificationsAppAppDelegate

@synthesize window;
@synthesize navigationController, pushManager;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Override point for customization after application launch.
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // Set the navigation controller as the window's root view controller and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

	//Enter your app code here
	pushManager = [[PushNotificationManager alloc] initWithApplicationCode:@"PUSHWOOSH_APP_CODE" appName:@"YOU_APP_NAME"];
	pushManager.delegate = self;
	pushManager.supportedOrientations = PWOrientationPortrait | PWOrientationLandscapeLeft | PWOrientationLandscapeRight;
	[pushManager handlePushReceived:launchOptions];
	
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

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
	[pushManager handlePushRegistration:devToken];
	
	//you might want to send it to your backend if you use remote integration
	NSString *token = [pushManager getPushToken];
	NSLog(@"Push token: %@", token);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
	NSLog(@"Error registering for push notifications. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[pushManager handlePushReceived:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	self.pushManager = nil;
	
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

