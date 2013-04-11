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

@synthesize sakaiCalView;
@synthesize sakaiCalViewTemp;
@synthesize sakaiCalViewLoad;

MBProgressHUD *hud;
NSString *calendarURL;
SakaiViewControllerHelper *helperController;
Utility *util;
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

- (void)setSelfAsWebViewsDelegate {
    [sakaiCalView setDelegate:self];
//    [sakaiCalViewTemp setDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    util = [[Utility alloc]init];
    hud = [[MBProgressHUD alloc]init];
    [hud hide:YES];
    helperController = [[SakaiViewControllerHelper alloc]init];
    [self setSelfAsWebViewsDelegate];
    [sakaiCalView setHidden:YES];
    [sakaiCalViewLoad setHidden:YES];
    [sakaiCalViewTemp setHidden:YES];
    if (calendarRendered) {
        [sakaiCalView setHidden:NO];
        [util loadWebView:calendarURL webView:sakaiCalView];
    } else {
        [util loadWebView:@"https://sakai.duke.edu/portal/pda" webView:sakaiCalView];
    }
}

- (void)goToPageTemplate:(NSString *)index {
    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){if(links[i].innerHTML.indexOf('%@')!==-1){str=links[i].href;break;}}str;";
    javascript = [NSString stringWithFormat:javascript, index];
    NSString *result = [sakaiCalView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"JAVASCRIPT: %@", javascript);
    NSLog(@"RESULT BUZZ: %@", result);
    [util loadWebView:result webView:sakaiCalView];
    if ([index isEqualToString:@"Calendar"]) {
        calendarURL = result;
        calendarRendered = YES;
    }
}

- (void)goToWorkspacePage {
    [self goToPageTemplate:@"Workspace"];
    helperController.inWorkspace = YES;
}

- (void)goToCalendarPage {
    [self goToPageTemplate:@"Calendar"];
    inCalendar = YES;
}

- (void)autoLoginToSakai:(UIWebView *)webView {
    if (calendarRendered && !loggedInApriori) {
        [MBProgressHUD hideHUDForView:sakaiCalViewLoad animated:YES];
        [sakaiCalViewLoad setHidden:YES];
        [sakaiCalView setHidden:NO];
        [self.view bringSubviewToFront:sakaiCalView];
    }
    else if (loggedIntoSakai) {
        if (loggedInApriori) {
            loggedInApriori = NO;
            [self goToWorkspacePage];
        }
        else if (helperController.inWorkspace) {
            [self goToCalendarPage];
            helperController.inWorkspace = NO;
            [sakaiCalView setHidden:NO];
        } else {
            [self goToWorkspacePage];
            if ([hud.labelText length] != 0 && !inCalendar) {
            } else {
                [self.view bringSubviewToFront:sakaiCalView];
            }
        }
    }
    else if (atRedirect) {
        loggedIntoSakai = YES;
    }
    else if (loginFormSubmitted) {
        [helperController fillSakaiSubViewForm:sakaiCalView];
        atRedirect = YES;
    }
    else if (atLogin) {
        NSString *href = [helperController clickLoginLink:sakaiCalView tempWebView:sakaiCalView];
        NSLog(@"HREF %@",href);
        if (![href isEqualToString:helperController.NO_LINK_TAG]) {
            [util loadWebView:href webView:sakaiCalView];
            loginFormSubmitted = YES;
            loggedInApriori = NO;
        }
    }
    else if (!loggedIntoSakai) {
        [sakaiCalViewLoad setHidden:NO];
        hud = [MBProgressHUD showHUDAddedTo:sakaiCalViewLoad animated:YES];
        hud.labelText = @"Logging into Sakai";
        NSString *linkExists = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('loginLink')[0]==null;"];
        NSLog(@"%@", linkExists);
        if ([linkExists isEqualToString:@"false"]) {
            [util loadWebView:@"https://sakai.duke.edu/portal/pda/?force.login=yes" webView:sakaiCalView];
            atLogin = YES;
        }
    }
    else {
        NSString *href = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.documentURI;"]];
        NSLog(@"NOTHING FINISHED: %@", href);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([util userLoggedIn]) {
        [self autoLoginToSakai:webView];
    } else {
        [sakaiCalView setHidden:NO];
    }
}

- (void)viewDidUnload
{
    [self setSakaiCalView:nil];
//    [self setSakaiCalViewTemp:nil];
    [self setSakaiCalViewLoad:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
