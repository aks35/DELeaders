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
@synthesize helperController;


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
    Utility *util = [[Utility alloc]init];
    [util loadWebView:@"https://sakai.duke.edu/portal/pda/?force.login=yes":sakaiWebView];
    [sakaiWebViewTemp setHidden:YES];
    [sakaiWebViewLoad setHidden:YES];
    [sakaiWebView setHidden:YES];
    sakaiWebViewLoad.opaque = NO;
    sakaiWebViewLoad.backgroundColor = [UIColor clearColor];
    hud = [[MBProgressHUD alloc]init];
    [hud hide:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
//    if (webView.backgroundColor == ([UIColor greenColor])) {
//        [self.view setHidden:YES];
//    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"HELLO WORL");
//    NSLog([webView isEqual:sakaiWebViewTemp] ? @"Yes Temp WEB" : @"No temp WEB");
//    NSLog([webView isEqual:sakaiCalViewTemp] ? @"Yes temp CAL" : @"No temp CAL");
    NSLog(@"ENtering FINISH LOAD WEB");
    NSLog([helperController loggedIntoSakai] ? @"VISITED" : @"NOTE VISITED");
    NSLog([hud isHidden] ? @"IS HIDDEN": @"NOT HIDDEN");
    if ([helperController loggedIntoSakai]) {
        if ([hud.labelText length] != 0) {
            [MBProgressHUD hideHUDForView:sakaiWebViewLoad animated:YES];
            [sakaiWebViewTemp setHidden:NO];
        }
        [sakaiWebView setHidden:NO];
    } else if ([webView isEqual:sakaiWebViewTemp]) {
        NSLog(@"TEMP WEB");
        [helperController fillSakaiSubViewForm:webView];
       
    } else if (![helperController loggedIntoSakai]) {
        [sakaiWebViewLoad setHidden:NO];
//        [sakaiWebView setHidden:YES];
//        [sakaiWebViewTemp setHidden:YES];
        hud = [MBProgressHUD showHUDAddedTo:sakaiWebViewLoad animated:YES];
        hud.labelText = @"Logging into Sakai";
        NSLog(@"Page not visited");
        if ([webView isEqual:sakaiWebView]) {
            NSLog(@"WEB VIEW");
            NSString *href = [helperController clickLoginLink:sakaiWebView :sakaiWebViewTemp];
            if (![href isEqualToString:helperController.NO_LINK_TAG]) {
                [helperController initSakaiSubView:href :sakaiWebViewTemp];
//                [self.view addSubview:sakaiWebViewTemp]; 
//                [sakaiWebViewTemp setHidden:NO];

            }
        }  
    } else {
        NSString *href = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.documentURI;"]];
        NSLog(@"NOTHING FINISHED: %@", href);
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
