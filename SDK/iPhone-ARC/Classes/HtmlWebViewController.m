//
//  HtmlWebViewController.m
//  Pushwoosh SDK
//  (c) Pushwoosh 2012
//

#import "HtmlWebViewController.h"

@implementation HtmlWebViewController

@synthesize webview, activityIndicator;
@synthesize supportedOrientations;
@synthesize delegate;

- (id)initWithURLString:(NSString *)url {
	if(self = [super init]) {
		urlToLoad = url;
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = @"";
	
	webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	webview.delegate = self;
	webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:webview];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activityIndicator startAnimating];
	activityIndicator.frame = CGRectMake(self.view.frame.size.width / 2.0 - activityIndicator.frame.size.width / 2.0, self.view.frame.size.height / 2.0 - activityIndicator.frame.size.height / 2.0, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
	
	activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	[self.view addSubview:activityIndicator];
	
	UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.frame = CGRectMake(self.view.frame.size.width - 59.0f, 18.0f, 44.0f, 44.0f);
	closeButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
	[closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
	closeButton.titleLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:35.0f];
	[closeButton setTitle:@"❎" forState:UIControlStateNormal];
	[self.view addSubview:closeButton];
	
//	[webview setBackgroundColor:[UIColor clearColor]];
	webview.opaque = YES;
	webview.scalesPageToFit = NO;
	
	[webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlToLoad]]];
}

- (void)dealloc {
	webview.delegate = nil;
}

- (void) closeButtonAction {
	if ([self.delegate respondsToSelector:@selector(htmlWebViewControllerDidClose:)])
		[self.delegate htmlWebViewControllerDidClose:self];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if ((toInterfaceOrientation == UIInterfaceOrientationPortrait && (supportedOrientations & PWOrientationPortrait)) ||
		(toInterfaceOrientation == UIInterfaceOrientationPortrait && (supportedOrientations & PWOrientationPortraitUpsideDown)) ||
		(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft && (supportedOrientations & PWOrientationLandscapeLeft)) || 
		(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight && (supportedOrientations & PWOrientationLandscapeRight))) {
		return YES;
	}
	return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	activityIndicator.hidden = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	activityIndicator.hidden = YES;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	if ([error code] != -999) {
		activityIndicator.hidden = YES;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
	
	return YES;
}

@end
