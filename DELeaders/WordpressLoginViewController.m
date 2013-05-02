//
//  WordpressLoginViewController.m
//  DELeaders
//
//  Created by anshim on 4/26/13.
//
//

#import "WordpressLoginViewController.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "SakaiCalendarViewController.h"

@interface WordpressLoginViewController ()

@end

@implementation WordpressLoginViewController

@synthesize isNotLoggedIn;

MBProgressHUD *hud;
Utility *util;
SakaiViewControllerHelper *helperController;
UIWebView *mainWebView, *tempWebView;
bool atLoginPage, clickedLoginLink, atRedirect, loggedIn;

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

- (void)goToPageTemplate:(NSString *)index webView:(UIWebView *)webView{
    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){if(links[i].innerHTML.indexOf('%@')!==-1){str=links[i].href;break;}}str;";
    javascript = [NSString stringWithFormat:javascript, index];
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"JAVASCRIPT: %@", javascript);
    NSLog(@"RESULT BUZZ: %@", result);
    [util loadWebView:result webView:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Handle site navigation for auto-login
    if (loggedIn) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIntoWordPress"];
        isNotLoggedIn = NO;
    }
    else if (atRedirect) {
        loggedIn = YES;
    }
    else if (clickedLoginLink && atLoginPage) {
        if ([util loggedIntoSakai]) {
            loggedIn = YES;
        } else {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *netID = [defaults objectForKey:@"netId"];
            NSString *password = [defaults objectForKey:@"password"];
            [helperController fillSakaiSubViewForm:webView netID:netID password:password];
        }
        atRedirect = YES;
    }
    else if (clickedLoginLink && !atLoginPage) {
        atLoginPage = YES;
        [self goToPageTemplate:@"Click Here" webView:webView];
    }
    else if (!clickedLoginLink && !atLoginPage) {
        NSLog(@"In STUDENTS VIEW");
        clickedLoginLink = YES;
        [self goToPageTemplate:@"login" webView:webView];
    } else {
        NSLog(@"UNCAUGHT CASE");
    }
}

- (void)reset {
    self.svWebController = nil;
    self.svWebViewLoad = nil;
    self.svWebViewMain = nil;
    atLoginPage = NO;
    clickedLoginLink = NO;
    atRedirect = NO;
    loggedIn = NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loggedIntoWordPress"];
}

- (void)setUtility:(Utility *)utility {
    util = utility;
}

- (void)initLogin {
    isNotLoggedIn = YES;
    helperController = [[SakaiViewControllerHelper alloc]init];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [webView setDelegate:self];
    [self.view addSubview:webView];
    [util loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/" webView:webView];
}



@end
