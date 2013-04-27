//
//  WordpressLoginViewController.h
//  DELeaders
//
//  Created by anshim on 4/26/13.
//
//

#import <UIKit/UIKit.h>
@class SVWebViewController;
@class Utility;


@interface WordpressLoginViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) SVWebViewController *svWebController;
@property (strong, nonatomic) UIWebView *svWebViewMain;
@property (strong, nonatomic) UIWebView *svWebViewLoad;
@property (nonatomic) BOOL isNotLoggedIn;

- (void)reset;
- (void)setUtility:(Utility *)utility;
- (void)initLogin;

@end
