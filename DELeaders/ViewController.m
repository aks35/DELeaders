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

@synthesize scrollView;
@synthesize enterButton;
@synthesize netIdField;
@synthesize passwordField;
@synthesize continueButton;
@synthesize sakaiCal;
@synthesize activeField;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSString *website = @"https://sakai.duke.edu/portal/tool/b35dc602-2461-4429-8cbf-863b48798f02?panel=Main";
    NSURL *url = [NSURL URLWithString:website];
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
    [sakaiCal loadRequest:requestUrl];
    
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
    
}

- (void)viewDidUnload
{
    [self setSakaiCal:nil];
    [self setNetIdField:nil];
    [self setPasswordField:nil];
    [self setContinueButton:nil];
    [self setEnterButton:nil];
    [self setScrollView:nil];
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

- (IBAction)openSakai:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://sakai.duke.edu/" ]];
}

- (IBAction)openLibrary:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://library.duke.edu/" ]];
}

- (IBAction)openACES:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://aces.duke.edu/" ]];
}

- (IBAction)openExecEd:(id)sender {
    // Put link for Exec Ed here
}

- (IBAction)openCal:(id)sender {
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
    [self testAlert:netIdField.text];
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
        NSLog(@"MOVING");
    }
    NSLog(@"origin y: %f", origin.y-scrollView.contentOffset.y);
    NSLog(@"origin x: %f", origin.x);
    NSLog(@"COmpleted keboardWasShown");
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
    NSLog(@"Active field set");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
}

@end
