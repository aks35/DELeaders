//
//  SakaiViewController.m
//  DELeaders
//
//  Created by guest user on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SakaiViewController.h"
#import "Utility.h"
#import "SakaiViewControllerHelper.h"
#import "MBProgressHUD.h"

MBProgressHUD *hud;

@implementation SakaiViewController

@synthesize sakaiWebView;
@synthesize sakaiWebViewTemp;
@synthesize sakaiWebViewLoad;

SakaiViewControllerHelper *helperController;
Utility *util;
bool loggedIntoSakai;

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
    util = [[Utility alloc]init];
    [util loadWebView:@"https://sakai.duke.edu/portal/pda/?force.login=yes" webView:sakaiWebView];
    sakaiWebViewLoad.opaque = NO;
    sakaiWebViewLoad.backgroundColor = [UIColor clearColor];
    hud = [[MBProgressHUD alloc]init];
    [hud hide:YES];
    [sakaiWebViewTemp setHidden:YES];
    [sakaiWebViewLoad setHidden:YES];
    [sakaiWebView setHidden:YES];
    helperController = [[SakaiViewControllerHelper alloc]init];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (loggedIntoSakai) {
        if ([hud.labelText length] != 0) {
            [sakaiWebViewTemp setHidden:NO];
            [MBProgressHUD hideHUDForView:sakaiWebViewLoad animated:YES];
        }
        [sakaiWebView setHidden:NO];
    } else if ([webView isEqual:sakaiWebViewTemp]) {
        [helperController fillSakaiSubViewForm:webView];
        loggedIntoSakai = YES;
    } else if (!loggedIntoSakai) {
        [sakaiWebViewLoad setHidden:NO];
        hud = [MBProgressHUD showHUDAddedTo:sakaiWebViewLoad animated:YES];
        hud.labelText = @"Logging into Sakai";
        NSLog(@"Page not visited");
        if ([webView isEqual:sakaiWebView]) {
            NSString *href = [helperController clickLoginLink:sakaiWebView tempWebView:sakaiWebViewTemp];
            if (![href isEqualToString:helperController.NO_LINK_TAG]) {
                [helperController initSakaiSubView:href webView:sakaiWebViewTemp];
                [self.view bringSubviewToFront:sakaiWebViewTemp];
            }
        }  
    } 
}

- (void)viewDidUnload
{
    [self setSakaiWebView:nil];
    [self setSakaiWebViewTemp:nil];
    [self setSakaiWebViewLoad:nil];
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
    [sakaiWebView setDelegate:self];
    [sakaiWebViewTemp setDelegate:self];
}

@end
