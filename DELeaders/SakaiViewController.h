//
//  SakaiViewController.h
//  DELeaders
//
//  Created by guest user on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SakaiCalendarViewController;
@class SVWebViewController;
@class MBProgressHUD;

extern NSString* const sakaiTempWebViewTag;
extern NSString* const sakaiTempCalViewTag;

@interface SakaiViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) SVWebViewController *svWebController;
@property (strong, nonatomic) UIWebView *svWebViewMain;
@property (strong, nonatomic) UIWebView *svWebViewLoad;
@property (strong, nonatomic) UIWebView *svWebViewTemp;
@property (strong, nonatomic) MBProgressHUD *hud;

- (BOOL)sakaiWebViewDidFinishLoad:(UIWebView *)webView;
- (void)registerSVWebController:(SVWebViewController *)webController;
- (void)reset;

@end
