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

MBProgressHUD *hud;
NSString *calendarURL;

@implementation SakaiCalendarViewController

@synthesize sakaiCalView;
@synthesize sakaiCalViewTemp;
@synthesize sakaiCalViewLoad;
@synthesize helperController;

Utility *util;
bool goingIntoCalView = NO;
bool inCalendar = NO;
bool loggedInApriori = YES;
bool calendarRendered = NO;

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
    [sakaiCalViewLoad setHidden:YES];
    [sakaiCalViewTemp setHidden:YES];
    if (calendarRendered) {
        [sakaiCalView setHidden:NO];
        [util loadWebView:calendarURL:sakaiCalView];
    } else {
        [sakaiCalView setHidden:YES];
        [util loadWebView:@"https://sakai.duke.edu/portal/pda":sakaiCalView];            
    }
    util = [[Utility alloc]init];
    hud = [[MBProgressHUD alloc]init];
    [hud hide:YES];
    [self setSelfAsWebViewsDelegate];
    helperController = [[SakaiViewControllerHelper alloc]init];
}

- (void)goToPageTemplate:(NSString *)index {
    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){if(links[i].innerHTML.indexOf('%@')!==-1){str=links[i].href;break;}}str;";
//    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){str += links[i].href;}str;";
    javascript = [NSString stringWithFormat:javascript, index];
    NSString *result = [sakaiCalView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"JAVASCRIPT: %@", javascript);
    NSLog(@"RESULT BUZZ: %@", result);
    [util loadWebView:result :sakaiCalView];
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

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (calendarRendered) {

    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (calendarRendered && !loggedInApriori) {
        [sakaiCalView setHidden:NO];
        [self.view bringSubviewToFront:sakaiCalView];
    } else if ([webView isEqual:sakaiCalViewTemp]) {
        if ([helperController loggedIntoSakai]) {
            [util loadWebView:@"https://sakai.duke.edu/portal/pda":sakaiCalView];
        } else {
            NSString *href = [helperController clickLoginLink:sakaiCalViewTemp :sakaiCalViewTemp];
            if (![href isEqualToString:helperController.NO_LINK_TAG]) {
                [helperController initSakaiSubView:href :sakaiCalViewTemp];
                loggedInApriori = NO;
                [helperController fillSakaiSubViewForm:sakaiCalViewTemp];
            }
        }
    } else if (![helperController loggedIntoSakai]) {
        if ([webView isEqual:sakaiCalView]) {
            [sakaiCalViewLoad setHidden:NO];
            hud = [MBProgressHUD showHUDAddedTo:sakaiCalViewLoad animated:YES];
            hud.labelText = @"Logging into Sakai";
            NSString *linkExists = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('loginLink')[0]==null;"];
            NSLog(@"%@", linkExists);
            if ([linkExists isEqualToString:@"false"]) {
                [helperController initSakaiSubView:@"https://sakai.duke.edu/portal/pda/?force.login=yes":sakaiCalViewTemp];
                [self.view addSubview:sakaiCalViewTemp]; 
            }
        } 
    } else if ([helperController loggedIntoSakai]) {
        if (loggedInApriori) {
            NSLog(@"Logged in before, reloading");
            loggedInApriori = NO;
            goingIntoCalView = YES;
            [self goToWorkspacePage];
        } else if (!goingIntoCalView) {
            goingIntoCalView = YES;
        } 
        else if (helperController.inWorkspace) {
            [self goToCalendarPage];
            helperController.inWorkspace = NO;
            NSLog(@"GOING TO CALENDAR");
        } else {
            if ([hud.labelText length] != 0 && !inCalendar) {
                [MBProgressHUD hideHUDForView:sakaiCalViewLoad animated:YES];
                [self goToWorkspacePage];
                NSLog(@"GOING INTO WORKSPACE");
            } else {
                [sakaiCalViewLoad setHidden:YES];
                NSLog(@"ONE DAY");           
                [sakaiCalView setHidden:NO];
                [self.view bringSubviewToFront:sakaiCalView];
            }
        }
    } else {
        NSString *href = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.documentURI;"]];
        NSLog(@"NOTHING FINISHED: %@", href);
    }
}

- (void)viewDidUnload
{
    [self setSakaiCalView:nil];
    [self setSakaiCalViewTemp:nil];
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

- (void)setSelfAsWebViewsDelegate {
    [sakaiCalView setDelegate:self];
    [sakaiCalView setDelegate:self];
}

@end
