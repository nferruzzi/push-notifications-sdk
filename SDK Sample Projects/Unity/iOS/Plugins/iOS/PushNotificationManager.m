//
//  PushNotificationManager.m
//  Pushwoosh SDK
//  (c) Pushwoosh 2012
//

#import "PushNotificationManager.h"

#import "HtmlWebViewController.h"
#import "PWRequestManager.h"
#import "PWRegisterDeviceRequest.h"
#import "PWSetTagsRequest.h"
#import "PWPushStatRequest.h"
#import "PWGetNearestZoneRequest.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>

#define kServicePushNotificationUrl @"https://cp.pushwoosh.com/json/1.3/registerDevice"
#define kServiceSetTagsUrl @"https://cp.pushwoosh.com/json/1.3/setTags"
#define kServiceHtmlContentFormatUrl @"https://cp.pushwoosh.com/content/%@"

@implementation PushNotificationManager

@synthesize appCode, appName, navController, pushNotifications, delegate;
@synthesize supportedOrientations;

- (NSString *) stringFromMD5: (NSString *)val{
    
    if(val == nil || [val length] == 0)
        return nil;
    
    const char *value = [val UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString autorelease];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

- (NSString *) uniqueDeviceIdentifier{
    NSString *macaddress = [self macaddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *uniqueIdentifier = [self stringFromMD5:stringToHash];
    
    return uniqueIdentifier;
}

- (NSString *) uniqueGlobalDeviceIdentifier{
    NSString *macaddress = [self macaddress];
    NSString *uniqueIdentifier = [self stringFromMD5:macaddress];
    
    return uniqueIdentifier;
}

- (id) initWithApplicationCode:(NSString *)_appCode appName:(NSString *)_appName{
	if(self = [super init]) {
		self.supportedOrientations = PWOrientationPortrait | PWOrientationPortraitUpsideDown | PWOrientationLandscapeLeft | PWOrientationLandscapeRight;
		self.appCode = _appCode;
		self.appName = _appName;
		self.navController = [UIApplication sharedApplication].keyWindow.rootViewController;
		internalIndex = 0;
		pushNotifications = [[NSMutableDictionary alloc] init];
		
		[[NSUserDefaults standardUserDefaults] setObject:_appCode forKey:@"Pushwoosh_APPID"];
		if(_appName) {
			[[NSUserDefaults standardUserDefaults] setObject:_appName forKey:@"Pushwoosh_APPNAME"];
		}
	}
	
	return self;
}

- (id) initWithApplicationCode:(NSString *)_appCode navController:(UIViewController *) _navController appName:(NSString *)_appName{
	if (self = [super init]) {
		self.supportedOrientations = PWOrientationPortrait | PWOrientationPortraitUpsideDown | PWOrientationLandscapeLeft | PWOrientationLandscapeRight;
		self.appCode = _appCode;
		self.navController = _navController;
		self.appName = _appName;
		internalIndex = 0;
		pushNotifications = [[NSMutableDictionary alloc] init];
		
		[[NSUserDefaults standardUserDefaults] setObject:_appCode forKey:@"Pushwoosh_APPID"];
		if(_appName) {
			[[NSUserDefaults standardUserDefaults] setObject:_appName forKey:@"Pushwoosh_APPNAME"];
		}
	}
	
	return self;
}

+ (void)initializeWithAppCode:(NSString *)appCode appName:(NSString *)appName {
	[[NSUserDefaults standardUserDefaults] setObject:appCode forKey:@"Pushwoosh_APPID"];
	
	if(appName) {
		[[NSUserDefaults standardUserDefaults] setObject:appName forKey:@"Pushwoosh_APPNAME"];
	}
}

+ (PushNotificationManager *)pushManager {
	static PushNotificationManager * instance = nil;
	
	if(instance == nil) {
		NSString * appid = [[NSUserDefaults standardUserDefaults] objectForKey:@"Pushwoosh_APPID"];
		
		if(!appid) {
			appid = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Pushwoosh_APPID"];

			if(!appid) {
				return nil;
			}
		}
		
		NSString * appname = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
		if(!appname) {
			appname = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
			
			if(!appname) {
				appname = @"";
			}
		}
		
		instance = [[PushNotificationManager alloc] initWithApplicationCode:appid appName:appname ];
	}
	
	return instance;
}

- (void) closeAction {
	[navController dismissModalViewControllerAnimated:YES];
}

- (void) showPushPage:(NSString *)pageId {
	NSString *url = [NSString stringWithFormat:kServiceHtmlContentFormatUrl, pageId];
	HtmlWebViewController *vc = [[HtmlWebViewController alloc] initWithURLString:url];
	vc.supportedOrientations = supportedOrientations;
	
	// Create the navigation controller and present it modally.
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
	vc.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(closeAction)] autorelease];
    
	[navController presentModalViewController:navigationController animated:YES];
	
	[navigationController release];
	[vc release];
}

- (void) sendDevTokenToServer:(NSString *)deviceID {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	NSString * appLocale = @"en";
	NSLocale * locale = (NSLocale *)CFLocaleCopyCurrent();
	NSString * localeId = [locale localeIdentifier];
	
	if([localeId length] > 2)
		localeId = [localeId stringByReplacingCharactersInRange:NSMakeRange(2, [localeId length]-2) withString:@""];
	
	[locale release]; locale = nil;
	
	appLocale = localeId;
	
	NSArray * languagesArr = (NSArray *) CFLocaleCopyPreferredLanguages();	
	if([languagesArr count] > 0)
	{
		NSString * value = [languagesArr objectAtIndex:0];
		
		if([value length] > 2)
			value = [value stringByReplacingCharactersInRange:NSMakeRange(2, [value length]-2) withString:@""];
		
		appLocale = [[value copy] autorelease];
	}
	
	[languagesArr release]; languagesArr = nil;
	
	PWRegisterDeviceRequest *request = [[PWRegisterDeviceRequest alloc] init];
	request.appId = appCode;
	request.hwid = [self uniqueGlobalDeviceIdentifier];
	request.pushToken = deviceID;
	request.language = appLocale;
	request.timeZone = [NSString stringWithFormat:@"%d", [[NSTimeZone localTimeZone] secondsFromGMT]];
	
	if ([[PWRequestManager sharedManager] sendRequest:request]) {
		NSLog(@"Registered for push notifications: %@", deviceID);
	} else {
		NSLog(@"Registered for push notifications failed");
	}
	
	[request release]; request = nil;
	[pool release]; pool = nil;
}

- (void) handlePushRegistration:(NSData *)devToken {
	NSMutableString *deviceID = [NSMutableString stringWithString:[devToken description]];
	
	//Remove <, >, and spaces
	[deviceID replaceOccurrencesOfString:@"<" withString:@"" options:1 range:NSMakeRange(0, [deviceID length])];
	[deviceID replaceOccurrencesOfString:@">" withString:@"" options:1 range:NSMakeRange(0, [deviceID length])];
	[deviceID replaceOccurrencesOfString:@" " withString:@"" options:1 range:NSMakeRange(0, [deviceID length])];
	
	[[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:@"PWPushUserId"];
	
	[self performSelectorInBackground:@selector(sendDevTokenToServer:) withObject:deviceID];
}

- (NSString *) getPushToken {
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"PWPushUserId"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex != 1) {
		if(!alertView.tag)
			return;
		
		[pushNotifications removeObjectForKey:[NSNumber numberWithInt:alertView.tag]];
		return;
	}
	
	NSDictionary *lastPushDict = [pushNotifications objectForKey:[NSNumber numberWithInt:alertView.tag]];
	NSString *htmlPageId = [lastPushDict objectForKey:@"h"];
	if(htmlPageId) {
		[self showPushPage:htmlPageId];
	}
    
	NSString *linkUrl = [lastPushDict objectForKey:@"l"];	
	if(linkUrl) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkUrl]];
	}
	
	if([delegate respondsToSelector:@selector(onPushAccepted: withNotification:)] ) {
		[delegate onPushAccepted:self withNotification:lastPushDict];
	}
	
	[pushNotifications removeObjectForKey:[NSNumber numberWithInt:alertView.tag]];
}

- (BOOL) handlePushReceived:(NSDictionary *)userInfo {
	//set the application badges icon to 0
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
	BOOL isPushOnStart = NO;
	NSDictionary *pushDict = [userInfo objectForKey:@"aps"];
	if(!pushDict) {
		//try as launchOptions dictionary
		userInfo = [userInfo objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		pushDict = [userInfo objectForKey:@"aps"];
		isPushOnStart = YES;
	}
	
	if (!pushDict)
		return NO;
	
	//check if the app is really running
	if([[UIApplication sharedApplication] respondsToSelector:@selector(applicationState)] && [[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
		isPushOnStart = YES;
	}
	
	[self performSelectorInBackground:@selector(sendStatsBackground) withObject:nil];
	
	if([delegate respondsToSelector:@selector(onPushReceived: withNotification: onStart:)] ) {
		[delegate onPushReceived:self withNotification:userInfo onStart:isPushOnStart];
		return YES;
	}

	NSString *alertMsg = [pushDict objectForKey:@"alert"];
//	NSString *badge = [pushDict objectForKey:@"badge"];
//	NSString *sound = [pushDict objectForKey:@"sound"];
	NSString *htmlPageId = [userInfo objectForKey:@"h"];
//	NSString *customData = [userInfo objectForKey:@"u"];
	NSString *linkUrl = [userInfo objectForKey:@"l"];
	
	//the app is running, display alert only
	if(!isPushOnStart) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.appName message:alertMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		alert.tag = ++internalIndex;
		[pushNotifications setObject:userInfo forKey:[NSNumber numberWithInt:internalIndex]];
		[alert show];
		[alert release];
		return YES;
	}
	
	if(htmlPageId) {
		[self showPushPage:htmlPageId];
	}
    
	if(linkUrl) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkUrl]];
	}
	
	if([delegate respondsToSelector:@selector(onPushAccepted: withNotification:)] ) {
		[delegate onPushAccepted:self withNotification:userInfo];
	}
	return YES;
}

- (NSDictionary *) getApnPayload:(NSDictionary *)pushNotification {
	return [pushNotification objectForKey:@"aps"];
}

- (NSString *) getCustomPushData:(NSDictionary *)pushNotification {
	return [pushNotification objectForKey:@"u"];
}

- (void) sendStatsBackground {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	PWPushStatRequest *request = [[PWPushStatRequest alloc] init];
	request.appId = appCode;
	request.hwid = [self uniqueGlobalDeviceIdentifier];
	
	if ([[PWRequestManager sharedManager] sendRequest:request]) {
		NSLog(@"sendStats completed");
	} else {
		NSLog(@"sendStats failed");
	}
	
	[request release]; request = nil;
	
	[pool release]; pool = nil;
}

- (void) sendTagsBackground: (NSDictionary *) tags {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    PWSetTagsRequest *request = [[PWSetTagsRequest alloc] init];
	request.appId = appCode;
	request.hwid = [self uniqueGlobalDeviceIdentifier];
    request.tags = tags;
	
	if ([[PWRequestManager sharedManager] sendRequest:request]) {
		NSLog(@"setTags completed");
	} else {
		NSLog(@"setTags failed");
	}
	
	[request release]; request = nil;

	
	[pool release]; pool = nil;
}

- (void) sendLocation: (CLLocation *) location {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"Sending location: %@", location);
	
    PWGetNearestZoneRequest *request = [[PWGetNearestZoneRequest alloc] init];
	request.appId = appCode;
	request.hwid = [self uniqueGlobalDeviceIdentifier];
    request.coordinate = location.coordinate;
	
	if ([[PWRequestManager sharedManager] sendRequest:request]) {
		NSLog(@"getNearestZone completed");
	} else {
		NSLog(@"getNearestZone failed");
	}
	
	[request release]; request = nil;
	
	NSLog(@"Locaiton sent");
	
	[pool release]; pool = nil;
}

- (void) setTags: (NSDictionary *) tags {
	[self performSelectorInBackground:@selector(sendTagsBackground:) withObject:tags];
}

- (void) dealloc {
	self.delegate = nil;
	self.appCode = nil;
	self.navController = nil;
	self.pushNotifications = nil;
	
	[super dealloc];
}

@end

#import <objc/runtime.h>

@implementation UIApplication(Pushwoosh)

BOOL dynamicDidFinishLaunching(id self, SEL _cmd, id application, id launchOptions) {
	BOOL result = YES;
	
	if ([self respondsToSelector:@selector(application:pw_didFinishLaunchingWithOptions:)]) {
		result = (BOOL) [self application:application pw_didFinishLaunchingWithOptions:launchOptions];
	} else {
		[self applicationDidFinishLaunching:application];
		result = YES;
	}
	
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	
	if(![PushNotificationManager pushManager].delegate) {
		[PushNotificationManager pushManager].delegate = (NSObject<PushNotificationDelegate> *)self;
	}
	
	[[PushNotificationManager pushManager] handlePushReceived:launchOptions];
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
	return result;
}

void dynamicDidRegisterForRemoteNotificationsWithDeviceToken(id self, SEL _cmd, id application, id devToken) {
	if ([self respondsToSelector:@selector(application:pw_didRegisterForRemoteNotificationsWithDeviceToken:)]) {
		[self application:application pw_didRegisterForRemoteNotificationsWithDeviceToken:devToken];
	}
	
	[[PushNotificationManager pushManager] handlePushRegistration:devToken];
}

void dynamicDidFailToRegisterForRemoteNotificationsWithError(id self, SEL _cmd, id application, id error) {
	if ([self respondsToSelector:@selector(application:pw_didFailToRegisterForRemoteNotificationsWithError:)]) {
		[self application:application pw_didFailToRegisterForRemoteNotificationsWithError:error];
	}

	NSLog(@"Error registering for push notifications. Error: %@", error);
}

void dynamicDidReceiveRemoteNotification(id self, SEL _cmd, id application, id userInfo) {
	if ([self respondsToSelector:@selector(application:pw_didReceiveRemoteNotification:)]) {
		[self application:application pw_didReceiveRemoteNotification:userInfo];
	}

	[[PushNotificationManager pushManager] handlePushReceived:userInfo];
}


- (void) pw_setDelegate:(id<UIApplicationDelegate>)delegate {
	Method method = nil;
	method = class_getInstanceMethod([delegate class], @selector(application:didFinishLaunchingWithOptions:));
	
	if (method) {
		class_addMethod([delegate class], @selector(application:pw_didFinishLaunchingWithOptions:), (IMP)dynamicDidFinishLaunching, "v@:::");
		method_exchangeImplementations(class_getInstanceMethod([delegate class], @selector(application:didFinishLaunchingWithOptions:)), class_getInstanceMethod([delegate class], @selector(application:pw_didFinishLaunchingWithOptions:)));
	} else {
		class_addMethod([delegate class], @selector(application:didFinishLaunchingWithOptions:), (IMP)dynamicDidFinishLaunching, "v@:::");
	}
	
	method = class_getInstanceMethod([delegate class], @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:));
	if(method) {
		class_addMethod([delegate class], @selector(application:pw_didRegisterForRemoteNotificationsWithDeviceToken:), (IMP)dynamicDidRegisterForRemoteNotificationsWithDeviceToken, "v@:::");
		method_exchangeImplementations(class_getInstanceMethod([delegate class], @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)), class_getInstanceMethod([delegate class], @selector(application:pw_didRegisterForRemoteNotificationsWithDeviceToken:)));
	}
	else {
		class_addMethod([delegate class], @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:), (IMP)dynamicDidRegisterForRemoteNotificationsWithDeviceToken, "v@:::");
	}
	
	method = class_getInstanceMethod([delegate class], @selector(application:didFailToRegisterForRemoteNotificationsWithError:));
	if(method) {
		class_addMethod([delegate class], @selector(application:pw_didFailToRegisterForRemoteNotificationsWithError:), (IMP)dynamicDidRegisterForRemoteNotificationsWithDeviceToken, "v@:::");
		method_exchangeImplementations(class_getInstanceMethod([delegate class], @selector(application:didFailToRegisterForRemoteNotificationsWithError:)), class_getInstanceMethod([delegate class], @selector(application:pw_didFailToRegisterForRemoteNotificationsWithError:)));
	}
	else {
		class_addMethod([delegate class], @selector(application:didFailToRegisterForRemoteNotificationsWithError:), (IMP)dynamicDidFailToRegisterForRemoteNotificationsWithError, "v@:::");
	}
	
	method = class_getInstanceMethod([delegate class], @selector(application:didReceiveRemoteNotification:));
	if(method) {
		class_addMethod([delegate class], @selector(application:pw_didReceiveRemoteNotification:), (IMP)dynamicDidReceiveRemoteNotification, "v@:::");
		method_exchangeImplementations(class_getInstanceMethod([delegate class], @selector(application:didReceiveRemoteNotification:)), class_getInstanceMethod([delegate class], @selector(application:pw_didReceiveRemoteNotification:)));
	}
	else {
		class_addMethod([delegate class], @selector(application:didReceiveRemoteNotification:), (IMP)dynamicDidReceiveRemoteNotification, "v@:::");
	}
	
	[self pw_setDelegate:delegate];
}

+ (void) initialize {
	method_exchangeImplementations(class_getInstanceMethod(self, @selector(setDelegate:)), class_getInstanceMethod(self, @selector(pw_setDelegate:)));
	
	UIApplication *app = [UIApplication sharedApplication];
	NSLog(@"Initializing application: %@, %@", app, app.delegate);
}

@end
