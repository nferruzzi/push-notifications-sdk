//
//  PushNotificationManager.h
//  PushNotificationManager
//

#import <Foundation/Foundation.h>

@class PushNotificationManager;

@protocol PushNotificationDelegate

@optional
//handle push notification, display alert, if this method is implemented onPushAccepted will not be called, internal message boxes will not be displayed
- (void) onPushReceived:(PushNotificationManager *)pushManager onStart:(BOOL)onStart;

//user pressed OK on the push notification
- (void) onPushAccepted:(PushNotificationManager *)pushManager;
@end

@interface PushNotificationManager : NSObject {
	NSString *appCode;
	NSString *appName;
	
	NSDictionary *lastPushDict;
	NSObject<PushNotificationDelegate> *delegate;
}

@property (nonatomic, copy) NSString *appCode;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, retain) NSDictionary *lastPushDict;
@property (nonatomic, assign) NSObject<PushNotificationDelegate> *delegate;

- (id) initWithApplicationCode:(NSString *)appCode appName:(NSString *)appName;

//sends the token to server
- (void) handlePushRegistration:(NSData *)devToken;
- (NSString *) getPushToken;

//if the push is received when the app is running
- (BOOL) handlePushReceived:(NSDictionary *) userInfo;

//gets apn payload
- (NSDictionary *) getApnPayload;

//get custom data from the push payload
- (NSString *) getCustomPushData;

@end
