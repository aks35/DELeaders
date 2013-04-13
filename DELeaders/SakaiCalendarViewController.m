//
//  SakaiCalendarViewController.m
//  DELeaders
//
//  Created by guest user on 3/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SakaiCalendarViewController.h"
#import "Utility.h"
#import "SakaiViewControllerHelper.h"
#import "MBProgressHUD.h"

@implementation SakaiCalendarViewController

@synthesize svWebController, svWebViewMain, svWebViewLoad, svWebViewTemp, svWebViewFinal;
@synthesize needToFillOutForm;

//MBProgressHUD *webHud;
SakaiViewControllerHelper *helperController;
Utility *util;
bool calendarDone;
bool atLogin, inCalendar, calendarRendered, atRedirect, loggedIntoSakai, loginFormSubmitted, inWorkspace;
bool loggedInApriori = YES;


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

- (IBAction)homePressed:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)goToPageTemplate:(NSString *)index {
    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){if(links[i].innerHTML.indexOf('%@')!==-1){str=links[i].href;break;}}str;";
    javascript = [NSString stringWithFormat:javascript, index];
    NSString *result = [svWebViewMain stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"JAVASCRIPT: %@", javascript);
    NSLog(@"RESULT BUZZ: %@", result);
    [util loadWebView:result webView:svWebViewMain];
    if ([index isEqualToString:@"Calendar"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result forKey:calendarUrlKey];
        NSLog(@"Calendar URL: %@", result);
        calendarRendered = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)goToWorkspacePage {
    helperController.inWorkspace = YES;
    [self goToPageTemplate:@"Workspace"];
}

- (void)goToCalendarPage {
    inCalendar = YES;
    [self goToPageTemplate:@"Calendar"];
}

- (void)backWasClicked {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (BOOL)autoLoginToSakai:(UIWebView *)webView {
    if (calendarDone) {
        return NO;
    }
    else if (calendarRendered && !loggedInApriori) {
        [MBProgressHUD hideHUDForView:svWebViewLoad animated:YES];
        [svWebController.navigationItem setHidesBackButton:NO animated:YES];
        [svWebViewLoad setHidden:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIntoSakai"];
        calendarDone = YES;
        [svWebViewLoad removeFromSuperview];
        [svWebViewTemp removeFromSuperview];
        [svWebViewMain setHidden:NO];

//        [util replaceWebBrowser:[[NSUserDefaults standardUserDefaults] objectForKey:calendarUrlKey] viewController:self.navigationController];
        return NO;
    }
    else if (loggedIntoSakai) {
        if (loggedInApriori) {
            loggedInApriori = NO;
            [self goToWorkspacePage];
        }
        else if (helperController.inWorkspace) {
            [self goToCalendarPage];
            helperController.inWorkspace = NO;
            [svWebViewMain setHidden:NO];
        } else {
            [self goToWorkspacePage];
            if ([_hud.labelText length] != 0 && !inCalendar) {
            } else {
                [self.view bringSubviewToFront:svWebViewMain];
            }
        }
    }
    else if (atRedirect) {
        loggedIntoSakai = YES;
        if (!needToFillOutForm) {
            [self goToWorkspacePage];
        }
    }
    else if (loginFormSubmitted) {
        if (needToFillOutForm) {
            [helperController fillSakaiSubViewForm:svWebViewMain];
        } 
        atRedirect = YES;
    }
    else if (atLogin) {
        NSString *href = [helperController clickLoginLink:svWebViewMain tempWebView:svWebViewMain];
        NSLog(@"HREF %@",href);
        if (![href isEqualToString:helperController.NO_LINK_TAG]) {
            [util loadWebView:href webView:svWebViewMain];
            loginFormSubmitted = YES;
            loggedInApriori = NO;
        }
    }
    else if (!loggedIntoSakai) {
        [svWebViewLoad setHidden:NO];
        _hud = [MBProgressHUD showHUDAddedTo:svWebViewLoad animated:YES];
        _hud.labelText = @"Logging into Sakai";
        [svWebController.navigationItem setHidesBackButton:YES animated:YES];
        NSString *linkExists = [svWebViewMain stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('loginLink')[0]==null;"];
        
        NSLog(@"%@", linkExists);
        if ([linkExists isEqualToString:@"false"]) {
            [util loadWebView:@"https://sakai.duke.edu/portal/pda/?force.login=yes" webView:svWebViewMain];
            atLogin = YES;
        }
    }
    else {
        NSString *href = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.documentURI;"]];
        NSLog(@"NOTHING FINISHED: %@", href);
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([util userLoggedIn]) {
        [self autoLoginToSakai:webView];
    } else {
        [svWebViewMain setHidden:NO];
    }
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

- (BOOL)sakaiWebViewDidFinishLoad:(UIWebView *)webView {
    if ([util userLoggedIn]) {
        return [self autoLoginToSakai:webView];
    } else {
        return NO;
    }
}

- (void)registerSVWebController:(SVWebViewController *)webController {
    svWebController = webController;
    svWebViewMain = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
    svWebViewLoad = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
    svWebViewTemp = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
    svWebViewFinal = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
    
    [svWebViewMain setHidden:YES];
    [svWebViewLoad setHidden:YES];
    [svWebViewTemp setHidden:YES];
    
    [svWebViewMain setDelegate:svWebController];
    [svWebViewTemp setDelegate:svWebController];
    
    [webController.view addSubview:svWebViewMain];
    [webController.view addSubview:svWebViewTemp];
    [webController.view addSubview:svWebViewLoad];

    [webController setMainView:svWebViewMain];
    
    util = [[Utility alloc]init];
    NSLog(@"--------------------");
    NSLog(@"LOADING SAKAI VIEW");
    NSLog(@"--------------------");
    [util loadWebView:@"https://sakai.duke.edu/portal/pda" webView:svWebViewMain];
    helperController = [[SakaiViewControllerHelper alloc]init];
}

@end
