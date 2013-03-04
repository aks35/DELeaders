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

@implementation SakaiCalendarViewController

@synthesize sakaiCalView;
@synthesize sakaiCalViewTemp;
@synthesize sakaiCalViewLoad;
@synthesize helperController;

Utility *util;
bool goingIntoCalView = NO;


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
    [self setSelfAsWebViewsDelegate];
    helperController = [[SakaiViewControllerHelper alloc]init];
    util = [[Utility alloc]init];
    [util loadWebView:@"https://sakai.duke.edu/portal/pda/~aks35@duke.edu/tool/b35dc602-2461-4429-8cbf-863b48798f02/calendar":sakaiCalView];    
    [sakaiCalViewLoad setHidden:YES];
    [sakaiCalViewTemp setHidden:YES];
    [sakaiCalView setHidden:YES];
    
    hud = [[MBProgressHUD alloc]init];
    [hud hide:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    NSLog(@"HELLO WORL");
    //    NSLog([webView isEqual:sakaiWebViewTemp] ? @"Yes Temp WEB" : @"No temp WEB");
    //    NSLog([webView isEqual:sakaiCalViewTemp] ? @"Yes temp CAL" : @"No temp CAL");
    NSLog([helperController loggedIntoSakai] ? @"VISITED" : @"NOTE VISITED");
    if ([webView isEqual:sakaiCalViewTemp]) {
        NSLog(@"WOKRING HERE TOO");
        if ([helperController loggedIntoSakai]) {
            [util loadWebView:@"https://sakai.duke.edu/portal/pda/~aks35@duke.edu/tool/b35dc602-2461-4429-8cbf-863b48798f02/calendar":sakaiCalView];
        } else {
            NSString *href = [helperController clickLoginLink:sakaiCalViewTemp :sakaiCalViewTemp];
            if (![href isEqualToString:helperController.NO_LINK_TAG]) {
                [helperController initSakaiSubView:href :sakaiCalViewTemp];
                [helperController fillSakaiSubViewForm:sakaiCalViewTemp];
            }
        }
    } else if (![helperController loggedIntoSakai]) {
        NSLog(@"Page not visited");
        if ([webView isEqual:sakaiCalView]) {
            [sakaiCalViewLoad setHidden:NO];
            hud = [MBProgressHUD showHUDAddedTo:sakaiCalViewLoad animated:YES];
            hud.labelText = @"Logging into Sakai";
            NSLog(@"CALENDAR VIEW");
            NSLog(@"STARTING Cal view change");
            NSString *linkExists = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('loginLink')[0]==null;"];
            NSLog(@"%@", linkExists);
            if ([linkExists isEqualToString:@"false"]) {
                [helperController initSakaiSubView:@"https://sakai.duke.edu/portal/pda/?force.login=yes":sakaiCalViewTemp];
                [self.view addSubview:sakaiCalViewTemp]; 
                NSLog(@"WORKING");
            }
            NSLog(@"END cal view change");
        } 
    } else if ([helperController loggedIntoSakai]) {
        if (!goingIntoCalView) {
            goingIntoCalView = YES;
        } else {
            if ([hud.labelText length] != 0) {
                [MBProgressHUD hideHUDForView:sakaiCalViewLoad animated:YES];
            }
            [sakaiCalViewLoad setHidden:YES];
            NSLog(@"ONE DAY");            
        }
        [sakaiCalView setHidden:NO];
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
