//
//  SakaiViewControllerHelper.m
//  DELeaders
//
//  Created by guest user on 3/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SakaiViewControllerHelper.h"

@implementation SakaiViewControllerHelper

@synthesize netId;
@synthesize password;
@synthesize NO_LINK_TAG;

NSString *const NO_LINK_TAG = @"THERE WAS NO LINK RETURNED";

bool pageVisited;


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
    if (!pageVisited) { // Init bool if not YES
        pageVisited = NO;
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

- (NSString *)clickLoginLink:(UIWebView *)webView:(UIWebView *)tempWebView {
    NSString *linkExists = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('loginLink1')==null"]]; 
    if ([linkExists isEqualToString:@"false"]) {
        NSString *href = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('loginLink1').href;"]];
        NSLog(@"FINISHED: %@", href);
        return href;
//        [self initSakaiSubView:href:tempWebView];
    }
    return NO_LINK_TAG;
}

- (void)initSakaiSubView:(NSString *)urlString:(UIWebView *)webView
{
    //    
    //    CGRect webFrame = CGRectMake(0.0, 0.0, 320.0, 460.0);
    //    UIWebView *newWebView = [[UIWebView alloc] initWithFrame:webFrame];
    //    [webView setBackgroundColor:[UIColor greenColor]];
    //    if ([webView isEqual:sakaiTempWebView]) {
    //        [newWebView se
    //    } else {
    //        
    //    }
    //    webView = newWebView;
    //    [webView setDelegate:self];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
} 

- (void)fillSakaiSubViewForm:(UIWebView *)webView {
    NSString* javaScriptString = @"document.getElementById('j_username')==null;";
    NSString *result = [webView stringByEvaluatingJavaScriptFromString: javaScriptString];
    if ([result isEqualToString:@"true"]) {
        //        [self.view setHidden:NO];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        netId = [defaults objectForKey:@"netId"];
        password = [defaults objectForKey:@"password"];
        javaScriptString = @"document.getElementById('j_username').value='%@';document.getElementById('j_password').value='%@';var d = document.getElementById('portlet-content'); var k = d.getElementsByTagName('form')[0]; k.submit();";
        
        NSLog(@"SAKAI SUB VIEW: %@", netId);
        NSLog(@"SAKAI SUB VIEW: %@", password);
        
        javaScriptString = [NSString stringWithFormat: javaScriptString, netId, password];
        
        NSString *result = [webView stringByEvaluatingJavaScriptFromString: javaScriptString];
        NSLog(@"RESULT: %@", result);
        pageVisited = YES;
        NSLog(pageVisited ? @"VISITED" : @"NOTE VISITED");
    }    
}

- (BOOL)loggedIntoSakai {
    if (pageVisited) {
        return YES;
    }
    return NO;
}

@end
