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
#import "SVWebViewController.h"

@implementation SakaiViewController

@synthesize svWebController, svWebViewMain, svWebViewLoad, svWebViewTemp;

SakaiViewControllerHelper *helperController;
Utility *util;
NSString *sakaiUrl;
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
}

- (BOOL)autoLoginToSakai:(UIWebView *)webView {
    if (loggedIntoSakai) {
        if ([util nsStringContains:[util getCurrentURL:svWebViewTemp]  sub:@"Redirect"]) {
            NSLog(@"CHECKPOINT 2");
            return YES;
        } else {
            [MBProgressHUD hideHUDForView:svWebViewLoad animated:YES];
            [svWebController enableBackButton];
            [svWebController enableTitleControl];
            [svWebViewLoad removeFromSuperview];
            [svWebViewMain removeFromSuperview];
            [svWebViewTemp setHidden:NO];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIntoSakai"];
            return NO;
        }
    } else if ([webView isEqual:svWebViewTemp]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *netID = [defaults objectForKey:@"netId"];
        NSString *password = [defaults objectForKey:@"password"];
        sakaiUrl = [helperController fillSakaiSubViewForm:webView netID:netID password:password];
        [svWebController enableTitleControl];
        loggedIntoSakai = YES;
    } else if (!loggedIntoSakai) {
        [svWebViewLoad setHidden:NO];
        _hud = [MBProgressHUD showHUDAddedTo:svWebViewLoad animated:YES];
        [_hud setLabelText:@"Logging into Sakai"];
        [svWebController disableBackButton];
        NSLog(@"Page not visited");
        NSLog(@"Web view description: %@", webView.description);
        if ([webView isEqual:svWebViewMain]) {
            NSString *href = [helperController clickLoginLink:svWebViewMain tempWebView:svWebViewTemp];
            if (![href isEqualToString:helperController.NO_LINK_TAG]) {
                [util loadWebView:href webView:svWebViewTemp];
                [self.view bringSubviewToFront:svWebViewTemp];
            }
        }
    }
    return YES;
}

- (BOOL)sakaiWebViewDidFinishLoad:(UIWebView *)webView {
    if ([util userLoggedIn]) {
        return [self autoLoginToSakai:webView];
    } else {
        [svWebViewTemp removeFromSuperview];
        [svWebViewLoad removeFromSuperview];
        [svWebViewMain setHidden:NO];
        return NO;
    }
}

- (void)reset {
    self.svWebController = nil;
    self.svWebViewLoad = nil;
    self.svWebViewMain = nil;
    self.svWebViewTemp = nil;
    loggedIntoSakai = NO;
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

- (void)registerSVWebController:(SVWebViewController *)webController {
    svWebController = webController;
    [svWebController setTitle:@"Sakai"];
    [svWebController disableTitleControl];
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        svWebViewLoad = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
    } else if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        svWebViewLoad = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.height, svWebController.view.frame.size.width)];

    }
    svWebViewMain = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
    svWebViewTemp = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];

    
    [svWebViewMain setHidden:YES];
    [svWebViewLoad setHidden:YES];
    [svWebViewTemp setHidden:YES];
    
    [svWebViewMain setDelegate:svWebController];
    [svWebViewTemp setDelegate:svWebController];

    [webController.view addSubview:svWebViewMain];
    [webController.view addSubview:svWebViewTemp];
    [webController.view addSubview:svWebViewLoad];
    
    svWebViewTemp.scalesPageToFit = YES;
    svWebViewTemp.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [webController setMainView:svWebViewTemp];
    
    util = [[Utility alloc]init];

    [util loadWebView:@"https://sakai.duke.edu/portal/pda/?force.login=yes" webView:svWebViewMain];
    helperController = [[SakaiViewControllerHelper alloc]init];
}

@end
