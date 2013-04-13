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
@property (weak, nonatomic) IBOutlet UIWebView *sakaiCalView;
@property (weak, nonatomic) IBOutlet UIWebView *sakaiCalViewTemp;
@property (weak, nonatomic) IBOutlet UIWebView *sakaiCalViewLoad;
@property (weak, nonatomic) NSString *calendarURL;

- (IBAction)homePressed:(id)sender;

- (void)setSelfAsWebViewsDelegate;
- (void)goToWorkspacePage;
- (void)goToCalendarPage;
- (void)goToPageTemplate:(NSString *)index;

- (BOOL)sakaiWebViewDidFinishLoad:(UIWebView *)webView;
- (void)registerSVWebController:(SVWebViewController *)webController;

@property (strong, nonatomic) SVWebViewController *svWebController;
@property (strong, nonatomic) UIWebView *svWebViewMain;
@property (strong, nonatomic) UIWebView *svWebViewLoad;
@property (strong, nonatomic) UIWebView *svWebViewTemp;
@property (strong, nonatomic) UIWebView *svWebViewFinal;
@property (strong, nonatomic) MBProgressHUD *hud;


@end
