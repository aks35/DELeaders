//
//  ViewController.m
//  DELeaders
//
//  Created by guest user on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LinksViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "GeneralWebViewController.h"

@implementation LinksViewController

@synthesize scrollView;
@synthesize enterButton;
@synthesize netIdField;
@synthesize passwordField;
@synthesize skipButton;
@synthesize activeField;
@synthesize dayLabel;
@synthesize dateNumLabel;

@synthesize netId;
@synthesize password;

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
    [self checkForNetIdAndPassword];
    [self updateDateLabels];
}

- (void)viewDidUnload
{
    [self setNetIdField:nil];
    [self setPasswordField:nil];
    [self setEnterButton:nil];
    [self setScrollView:nil];
    [self setSkipButton:nil];
    [self setDayLabel:nil];
    [self setDateNumLabel:nil];
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *identifier = segue.identifier;
    if([identifier hasPrefix:@"gen-"]){
        GeneralWebViewController *controller = (GeneralWebViewController *)segue.destinationViewController;
        if ([identifier isEqualToString:@"gen-DELSegue"]) {
            controller.myURL = @"http://www.nicholas.duke.edu/del/";
            controller.myTitle = @"DEL";
        } else if ([identifier isEqualToString:@"gen-NSOESegue"]) {
            controller.myURL = @"http://www.nicholas.duke.edu/";
            controller.myTitle = @"NSOE";
        } else if ([identifier isEqualToString:@"gen-WPSegue"]) {
            controller.myURL = @"https://sites.nicholas.duke.edu/delmeminfo/";
            controller.myTitle = @"Wordpress";
        } else if ([identifier isEqualToString:@"gen-LibrarySegue"]) {
            controller.myURL = @"https://library.duke.edu/";
            controller.myTitle = @"Duke Library";
        } else if ([identifier isEqualToString:@"gen-ACESSegue"]) {
            controller.myURL = @"https://aces.duke.edu/";
            controller.myTitle = @"Duke";
        }
    }
}


-(void)alertMessage:(NSString *)title text:(NSString *)text {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:netId forKey:@"netId"];
    [defaults setObject:password forKey:@"password"];
    NSLog(@"netId: %@",netId);
    NSLog(@"password: %@", password);

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

- (void)checkForNetIdAndPassword {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"WORKING");
    netId = [defaults objectForKey:@"netId"];
    password = [defaults objectForKey:@"password"];
    if (netId && password) {
        [skipButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        [netIdField setText:netId];
        [passwordField setText:password];
    }
}

- (void)updateDateLabels {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEEE"];
    NSString *dayString = [formatter stringFromDate:now];
    NSLog(@"Current DAY: %@", dayString);
    dayLabel.text = dayString;
    [formatter setDateFormat:@"d"];
    NSString *dateString = [formatter stringFromDate:now];
    NSLog(@"Current DATE: %@", dateString);
    dateNumLabel.text = dateString;
    dateNumLabel.font = [UIFont fontWithName:dateNumLabel.font.fontName size:dateNumLabel.frame.size.height];
    
    
}

@end
