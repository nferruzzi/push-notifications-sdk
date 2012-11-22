//
//  PushNotificationManager.h
//  Pushwoosh SDK
//  (c) Pushwoosh 2012
//

#import <Foundation/Foundation.h>

@class PushNotificationManager;

@protocol PushNotificationDelegate

@optional
//succesfully registered for push notifications
- (void) onDidRegisterForRemoteNotificationsWithDeviceToken:(NSString *)token;

//failed to register for push notifications
- (void) onDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

//handle push notification, display alert, if this method is implemented onPushAccepted will not be called, internal message boxes will not be displayed
- (void) onPushReceived:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification onStart:(BOOL)onStart;

//user pressed OK on the push notification
- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification;

//user pressed OK on the push notification
- (void) onPushAccepted:(PushNotificationManager *)pushManager withNotification:(NSDictionary *)pushNotification onStart:(BOOL)onStart;
@end

@interface PushNotificationManager : NSObject {
	NSString *appCode;
	NSString *appName;

	NSInteger internalIndex;
	NSMutableDictionary *pushNotifications;
	NSObject<PushNotificationDelegate> *delegate;
}

@property (nonatomic, copy) NSString *appCode;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, retain) NSDictionary *pushNotifications;
@property (nonatomic, assign) NSObject<PushNotificationDelegate> *delegate;

+ (void)initializeWithAppCode:(NSString *)appCode appName:(NSString *)appName;

+ (PushNotificationManager *)pushManager;

- (id) initWithApplicationCode:(NSString *)appCode appName:(NSString *)appName;

//send tags to server
- (void) setTags: (NSDictionary *) tags;

//sends the token to server
- (void) handlePushRegistration:(NSData *)devToken;
- (NSString *) getPushToken;

//if the push is received when the app is running
- (BOOL) handlePushReceived:(NSDictionary *) userInfo;

//gets apn payload
- (NSDictionary *) getApnPayload:(NSDictionary *)pushNotification;

//get custom data from the push payload
- (NSString *) getCustomPushData:(NSDictionary *)pushNotification;

@end

@interface NSApplication(SupressWarnings)
- (void)application:(NSApplication *)application pw_didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken;
- (void)application:(NSApplication *)application pw_didFailToRegisterForRemoteNotificationsWithError:(NSError *)err;
- (void)application:(NSApplication *)application pw_didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)pw_applicationDidFinishLaunching:(NSNotification *)aNotification;
@end