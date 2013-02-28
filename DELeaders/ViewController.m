//
//  ViewController.m
//  DELeaders
//
//  Created by guest user on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController

@synthesize calendarView;
@synthesize sakaiView;
@synthesize scrollView;
@synthesize enterButton;
@synthesize netIdField;
@synthesize passwordField;
@synthesize continueButton;
@synthesize activeField;

@synthesize netId;
@synthesize password;
@synthesize pageVisited;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:scrollView];
    [scrollView addSubview:enterButton];
    [scrollView addSubview:continueButton];
    [scrollView addSubview:netIdField];
    [scrollView addSubview:passwordField];
    
    NSString *fullURL = @"https://sakai.duke.edu/portal/pda/~aks35@duke.edu/tool/b35dc602-2461-4429-8cbf-863b48798f02/calenda";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [calendarView loadRequest:requestObj];
    NSString *myParameter = @"WORKING!!";
   
    [self loadWebView:@"https://sakai.duke.edu/portal/pda/~aks35@duke.edu/tool/b35dc602-2461-4429-8cbf-863b48798f02/calenda" :calendarView];
    [self loadWebView:@"https://sakai.duke.edu/portal/pda/?force.login=yes" :sakaiView];
    pageVisited = NO;
    [sakaiView setDelegate:self];
    
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView == sakaiView && !pageVisited) {
        NSString *linkExists = [sakaiView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('loginLink1')==null"]]; 
        if ([linkExists isEqualToString:@"false"]) {
            NSString *href = [sakaiView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('loginLink1').href;"]];
//            NSLog(@"FINISHED: %@", href);
            [self initSakaiSubView:href];            
        }
    } else if (webView.backgroundColor == ([UIColor greenColor])) {
        [self fillSakaiSubViewForm:webView];
    }
        
}

- (void)loadWebView:(NSString *)fullURL:(UIWebView *)webView {
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (void)viewDidUnload
{
    [self setNetIdField:nil];
    [self setPasswordField:nil];
    [self setContinueButton:nil];
    [self setEnterButton:nil];
    [self setScrollView:nil];
    [self setCalendarView:nil];
    [self setSakaiView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self registerForKeyboardNotifications];

}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)openDEL:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.nicholas.duke.edu/del/" ]];
}

- (IBAction)openNSE:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.nicholas.duke.edu/" ]];
}

- (IBAction)openWP:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://sites.nicholas.duke.edu/delmeminfo/" ]];
}


- (IBAction)openLibrary:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://library.duke.edu/" ]];
}

- (IBAction)openACES:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://aces.duke.edu/" ]];
}

- (IBAction)openExecEd:(id)sender {
    // Put link for Exec Ed here
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.nicholas.duke.edu/del/executiveed" ]];
}

-(void)testAlert:(NSString *)text {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ALERT" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];    
}

-(void)dismissKeyboard {
    [netIdField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (IBAction)pressEnterButton:(id)sender {
//    [self testAlert:netIdField.text];
    netId = netIdField.text;
    password = passwordField.text;
    NSLog(@"netId: %@",netId);
    NSLog(@"password: %@", password);

}

- (IBAction)openFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/" ]];
}

- (IBAction)openTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/" ]];
}

- (IBAction)openLinkedIn:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.linkedin.com/" ]];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint origin = activeField.frame.origin;
    origin.y -= scrollView.contentOffset.y;
    if (!CGRectContainsPoint(aRect, origin)) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-aRect.size.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
//    NSLog(@"origin y: %f", origin.y-scrollView.contentOffset.y);
//    NSLog(@"origin x: %f", origin.x);
//    NSLog(@"COmpleted keboardWasShown");
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
//    NSLog(@"Active field set");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
}


- (void) initSakaiSubView:(NSString *)urlString
{
    CGRect webFrame = CGRectMake(0.0, 0.0, 320.0, 460.0);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:webFrame];
    [webView setBackgroundColor:[UIColor greenColor]];
    if (webView.backgroundColor == ([UIColor greenColor])) {
        NSLog(@"IS ITS LKJASDLKAS ");
    }
    [webView setDelegate:self];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    [self.view addSubview:webView]; 
} 

- (void)fillSakaiSubViewForm:(UIWebView *)webView {
//    NSString* javaScriptString = @"document.getElementById('j_username').value='aks35'; alert(document.getElementById('j_username').value);";
    NSString* javaScriptString = @"document.getElementById('j_username').value='aks35';document.getElementById('j_password').value='6EF81ba8c2';var d = document.getElementById('portlet-content'); var k = d.getElementsByTagName('form')[0]; k.submit();";
    
    NSLog(@"SAKAI SUB VIEW: %@", netId);
    NSLog(@"SAKAI SUB VIEW: %@", password);
    
    //    javaScriptString = [NSString stringWithFormat: javaScriptString, netId, password];
    
    NSLog(@"JS STRING: %@", javaScriptString);
    
    NSString *result = [webView stringByEvaluatingJavaScriptFromString: javaScriptString];
    NSLog(@"RESULT: %@", result);
    pageVisited = YES;
}

@end 
