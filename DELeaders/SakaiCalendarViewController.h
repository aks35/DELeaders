//
//  SakaiCalendarViewController.h
//  DELeaders
//
//  Created by guest user on 3/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SakaiViewControllerHelper.h"
@class SVWebViewController;
@class MBProgressHUD;

#define calendarUrlKey @"sakaiCalendarUrl"

@interface SakaiCalendarViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) SVWebViewController *svWebController;
@property (strong, nonatomic) UIWebView *svWebViewMain;
@property (strong, nonatomic) UIWebView *svWebViewLoad;
@property (strong, nonatomic) UIWebView *svWebViewTemp;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (nonatomic) bool needToFillOutForm;

- (void)goToWorkspacePage;
- (void)goToCalendarPage;
- (void)goToPageTemplate:(NSString *)index;
- (void)registerSVWebController:(SVWebViewController *)webController;
- (void)reset;
- (BOOL)sakaiWebViewDidFinishLoad:(UIWebView *)webView;

@end
