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
@synthesize inWorkspace;
@synthesize NO_LINK_TAG;

NSString *const NO_LINK_TAG = @"THERE WAS NO LINK RETURNED";


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

- (NSString *)clickLoginLink:(UIWebView *)webView tempWebView:(UIWebView *)tempWebView {
    NSString *linkExists = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('loginLink1')==null"]]; 
    if ([linkExists isEqualToString:@"false"]) {
        NSString *href = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('loginLink1').href;"]];
        NSLog(@"FINISHED: %@", href);
        return href;
    }
    return NO_LINK_TAG;
}

- (void)fillSakaiSubViewForm:(UIWebView *)webView {
    NSString* javaScriptString = @"document.getElementById('j_username')==null;";
    NSString *result = [webView stringByEvaluatingJavaScriptFromString: javaScriptString];
    if ([result isEqualToString:@"true"]) {
        //        [self.view setHidden:NO];
        NSLog(@"COULD NOT Fill Sakai form");
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        netId = [defaults objectForKey:@"netId"];
        password = [defaults objectForKey:@"password"];
        javaScriptString = @"document.getElementById('j_username').value='%@';document.getElementById('j_password').value='%@';var d = document.getElementById('portlet-content'); var k = d.getElementsByTagName('form')[0]; k.submit();";
        javaScriptString = [NSString stringWithFormat: javaScriptString, netId, password];
        NSLog(@"%@", javaScriptString);
        [webView stringByEvaluatingJavaScriptFromString: javaScriptString];
        NSLog(@"Finished filling out form");
    }    
}

- (void)printCurrentURL:(UIWebView *)webView {
    NSString *javascript = @"document.documentURI";
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"Current URI: %@", result);
}


@end
