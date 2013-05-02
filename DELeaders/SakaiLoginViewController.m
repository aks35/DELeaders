//
//  SakaiLoginViewController.m
//  DELeaders
//
//  Created by anshim on 5/2/13.
//
//

#import "SakaiLoginViewController.h"
#import "Utility.h"
#import "SakaiViewControllerHelper.h"
#import "MBProgressHUD.h"
#import "SVWebViewController.h"

@interface SakaiLoginViewController ()

@end

@implementation SakaiLoginViewController

@synthesize isNotLoggedIn;
@synthesize currentUrl;


SakaiViewControllerHelper *helperController;
Utility *util;
NSString *sakaiUrl;
bool loggedIntoSakai, loginLinkClicked, signinFormFilled, needToGoCalendar;
bool atWorkspace, atCalendar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)goToPageTemplate:(NSString *)index webView:(UIWebView *)webView {
    // Template method to click links
    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){if(links[i].innerHTML.indexOf('%@')!==-1){str=links[i].href;break;}}str;";
    javascript = [NSString stringWithFormat:javascript, index];
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"JAVASCRIPT: %@", javascript);
    NSLog(@"RESULT BUZZ: %@", result);
    [util loadWebView:result webView:webView];
    if ([index isEqualToString:@"Calendar"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result forKey:calendarUrlKey];
        NSLog(@"Calendar URL: %@", result);
    }
}

- (void)goToWorkspacePage:(UIWebView *)webView {
    [self goToPageTemplate:@"Workspace" webView:webView];
    atWorkspace = YES;
}

- (void)goToCalendarPage:(UIWebView *)webView {
    [self goToPageTemplate:@"Calendar" webView:webView];
    atCalendar = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([helperController isLoggedIn:webView]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIntoSakai"];
        if (needToGoCalendar) {
            NSLog(@"NEED TO GO INTO CALENDAR");
            if (atCalendar) {
                currentUrl = [util getCurrentURL:webView];
                isNotLoggedIn = NO;
            } else if (atWorkspace && !atCalendar) {
                [self goToCalendarPage:webView];
            } else if (!atWorkspace) {
                NSLog(@"URL: %@", [util getCurrentURL:webView]);
                [self goToWorkspacePage:webView];
            }
        } else {
            currentUrl = [util getCurrentURL:webView];
            isNotLoggedIn = NO;
        }
    } else if (signinFormFilled) {
        if ([util nsStringContains:[util getCurrentURL:webView]  sub:@"Redirect"]) {
            // Need this to catch the redirect
            NSLog(@"At REDIRECT");
        }
    } else if (loginLinkClicked && !signinFormFilled) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *netID = [defaults objectForKey:@"netId"];
        NSString *password = [defaults objectForKey:@"password"];
        sakaiUrl = [helperController fillSakaiSubViewForm:webView netID:netID password:password];
        signinFormFilled = YES;
    } else if (!loginLinkClicked) {
        NSLog(@"HERE I AM");
        NSString *href = [helperController clickLoginLink:webView];
        if (![href isEqualToString:helperController.NO_LINK_TAG]) {
            loginLinkClicked = YES;
            [util loadWebView:href webView:webView];
        }
    }
    
}

- (void)reset {
    self.svWebController = nil;
    self.svWebViewLoad = nil;
    self.svWebViewMain = nil;
    self.svWebViewTemp = nil;
    loggedIntoSakai = NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loggedIntoSakai"];
}

- (void)setUtility:(Utility *)utility {
    util = utility;
}

- (void)initLogin:(bool)goToCalendar {
    isNotLoggedIn = YES;
    needToGoCalendar = goToCalendar;
    NSLog(@"INITING LOGIN");
    helperController = [[SakaiViewControllerHelper alloc]init];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [webView setDelegate:self];
    [self.view addSubview:webView];
    [util loadWebView:@"https://sakai.duke.edu/portal/pda/?force.login=yes" webView:webView];
}

@end
