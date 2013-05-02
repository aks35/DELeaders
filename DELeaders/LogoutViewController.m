//
//  LogoutViewController.m
//  DELeaders
//
//  Created by anshim on 4/26/13.
//
//

#import "LogoutViewController.h"
#import "Utility.h"

@interface LogoutViewController ()

@end

@implementation LogoutViewController

@synthesize sakaiLoggedOut;
Utility *util;
bool loggingOutSakai, inWordpress, loggingOutWordpress;

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

- (NSString *)getWordpressLogoutLink:(UIWebView *)webView {
    // Find logout link for Wordpress through Javascript
    NSString *javascript = @"var l = document.getElementById('wp-admin-bar-logout');var a = l.getElementsByTagName('a')[0];var link = a.href;link;";
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"Current URI: %@", result);
    return result;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Handle web navigation for logging out
    NSLog(@"Web view did finish load");
    if (loggingOutWordpress) {
        NSLog(@"Logging out wordpress");
        self.wordpressLoggedOut = YES;
    }
    else if (inWordpress) {
        NSLog(@"In wordpress");
        NSString *logoutLink = [self getWordpressLogoutLink:webView];
        loggingOutWordpress = YES;
        [util loadWebView:logoutLink webView:webView];
    }
    else if (loggingOutSakai) {
        NSLog(@"Logging out sakai");
        self.sakaiLoggedOut = YES;
        inWordpress = YES;
        [util loadWebView:@"http://sites.nicholas.duke.edu/delmeminfo/" webView:webView];
    }
}

- (void)setUtility:(Utility *)utility {
    util = utility;
    self.sakaiLoggedOut = NO;
    loggingOutSakai = NO;
    inWordpress = NO;
    loggingOutWordpress = NO;
}

- (void)initLogout {
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [webView setDelegate:self];
    [self.view addSubview:webView];
    loggingOutSakai = YES;
    [util loadWebView:@"https://sakai.duke.edu/portal/pda/?force.logout=yes" webView:webView];
}

@end
