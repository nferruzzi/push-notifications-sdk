//
//  HtmlWebViewControllerDelegate.h
//  PushNotificationManager
//
//  Created by Konstantin Kabanov on 12/6/12.
//
//

#import <Foundation/Foundation.h>

@class HtmlWebViewController;

@protocol HtmlWebViewControllerDelegate <NSObject>

- (void) htmlWebViewControllerDidClose: (HtmlWebViewController *) viewController;

@end