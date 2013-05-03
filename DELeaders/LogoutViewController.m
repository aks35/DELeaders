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
bool loggingOutSakai, inWordpress, pressedLogoutButton;

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

- (void)clickLogoutButtonSakai:(UIWebView *)webView {
    NSString* javaScriptString = @"document.getElementsByTagName('form')[0].submit();";
    NSLog(@"%@", javaScriptString);
    [webView stringByEvaluatingJavaScriptFromString: javaScriptString];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Handle web navigation for logging out
    NSLog(@"Web view did finish load");
    if (inWordpress) {
        NSLog(@"Logging out wordpress");
        self.wordpressLoggedOut = YES;
    }
    else if (loggingOutSakai && !inWordpress) {
        NSLog(@"In wordpress");
        NSString *logoutLink = [self getWordpressLogoutLink:webView];
        inWordpress = YES;
        [util loadWebView:logoutLink webView:webView];
    }
    else if (pressedLogoutButton && !loggingOutSakai) {
        self.sakaiLoggedOut = YES;
        loggingOutSakai = YES;
        [util loadWebView:@"http://sites.nicholas.duke.edu/delmeminfo/" webView:webView];
    } else if (!pressedLogoutButton) {
        NSLog(@"Logging out sakai");
        [self clickLogoutButtonSakai:webView];
        pressedLogoutButton = YES;
    }
}

- (void)setUtility:(Utility *)utility {
    util = utility;
    self.sakaiLoggedOut = NO;
    loggingOutSakai = NO;
    inWordpress = NO;
    pressedLogoutButton = NO;
}

- (void)initLogout {
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [webView setDelegate:self];
    [self.view addSubview:webView];
    [util loadWebView:@"https://sakai.duke.edu/portal/pda/?force.logout=yes" webView:webView];
}

@end
