//
//  SakaiValidationViewController.m
//  DELeaders
//
//  Created by anshim on 4/25/13.
//
//

#import "SakaiValidationViewController.h"
#import "Utility.h"
#import "SakaiViewControllerHelper.h"

@interface SakaiValidationViewController ()

@end

@implementation SakaiValidationViewController

Utility *util;
SakaiViewControllerHelper *helperController;
UIWebView *mainWebView;
NSString *sakaiUrl, *currentNetID, *currentPassword;
bool loginLinkClicked;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Navigate Sakai to validate whether or not login was successful
    if ([self formFilledOut]) {
        if ([util nsStringContains:[util getCurrentURL:webView]  sub:@"Redirect"]) {
            NSLog(@"CHECKPOINT 2");
        } else {
            self.isValid = [helperController isLoggedIn:webView];
            self.doneValidating = YES;
        }
    } else if (loginLinkClicked && ![self formFilledOut]) {
        sakaiUrl = [helperController fillSakaiSubViewForm:webView netID:currentNetID password:currentPassword];
        if ([sakaiUrl length] > 0) {
            self.formFilledOut = YES;            
        }
    } else if (!loginLinkClicked) {
        NSLog(@"Page not visited");
        NSLog(@"Web view description: %@", webView.description);
        if ([webView isEqual:mainWebView]) {
            NSString *href = [helperController clickLoginLink:mainWebView];
            if (![href isEqualToString:helperController.NO_LINK_TAG]) {
                loginLinkClicked = YES;
                [util loadWebView:href webView:webView];
            }
        }
    }
}

- (void)validateNetIdAndPassword:(NSString *)netID password:(NSString *)password {
    util = [[Utility alloc]init];
    NSLog(@"VALIDATING %@ - %@", netID, password);
    currentNetID = netID;
    currentPassword = password;
    helperController = [[SakaiViewControllerHelper alloc]init];
    mainWebView = [self allocWebViewAndSetDelegate];
    [util loadWebView:@"https://sakai.duke.edu/portal/pda/?force.login=yes" webView:mainWebView];
}

- (UIWebView *)allocWebViewAndSetDelegate {
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [webView setDelegate:self];
    [[self view]addSubview:webView];
    return webView;
}

- (void)reset {
    // Reset state
    self.doneValidating = NO;
    self.isValid = NO;
    self.formFilledOut = NO;
    loginLinkClicked = NO;
}

@end
