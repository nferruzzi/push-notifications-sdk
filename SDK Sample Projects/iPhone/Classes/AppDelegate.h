//
//  AppDelegate.h
//  GeoTagsSampleApp
//
//  Created by Vladislav Zozulyak on 31.07.12.
//  Copyright (c) 2012 exeshneg@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushNotificationManager.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, PushNotificationDelegate>

@property (nonatomic, retain) PushNotificationManager *pushManager;
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) UINavigationController *navController;
@property (strong, nonatomic) ViewController *viewController;


+ (AppDelegate *) sharedDelegate;

@end
