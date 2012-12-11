//
//  HtmlWebViewController.h
//  Pushwoosh SDK
//  (c) Pushwoosh 2012
//

#import <UIKit/UIKit.h>
#import "PushNotificationManager.h"
#import "HtmlWebViewControllerDelegate.h"

@interface HtmlWebViewController : UIViewController <UIWebViewDelegate> {
	UIWebView *webview;
	UIActivityIndicatorView *activityIndicator;
	
	NSString *urlToLoad;
}

- (id)initWithURLString:(NSString *)url;	//this method is to use it as a standalone webview

@property (nonatomic, unsafe_unretained) id <HtmlWebViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIWebView *webview;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) PWSupportedOrientations supportedOrientations;

@end
