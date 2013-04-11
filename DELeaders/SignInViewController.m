//
//  SignInViewController.m
//  DELeaders
//
//  Created by anshim on 4/6/13.
//
//

#import "Utility.h"
#import "SignInViewController.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

@synthesize scrollView;
@synthesize enterButton;
@synthesize skipButton;
@synthesize netIdField;
@synthesize passwordField;

@synthesize activeField;
@synthesize netId;
@synthesize password;
@synthesize topImage;
@synthesize bottomImage;
@synthesize promptLabel;
@synthesize netIdLabel;
@synthesize passwordLabel;

Utility *util;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self checkForNetIdAndPassword];
    
    util = [[Utility alloc]init];
    [util registerOrientationHandler:self];
    

    NSLog(@"WORKING");

//    [topImage setFrame:CGRectMake(0, 0, 320, 80)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEnterButton:nil];
    [self setSkipButton:nil];
    [self setNetIdField:nil];
    [self setPasswordField:nil];
    [self setScrollView:nil];
    [self setTopImage:nil];
    [self setBottomImage:nil];
    [self setPromptLabel:nil];
    [self setNetIdLabel:nil];
    [self setPasswordLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self registerForKeyboardNotifications];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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

- (void)changeToPortraitLayout {
    [topImage setFrame:CGRectMake(0, 0, 320, 80)];
    [topImage setImage:[UIImage imageNamed:@"top.png"]];
    [bottomImage setHidden:NO];
    if ([util isFourInchScreen]) {
        [scrollView setFrame:CGRectMake(0, 80, 320, 344)];
        [promptLabel setFrame:CGRectMake(0, 44, 320, 48)];
        [netIdLabel setFrame:CGRectMake(67, 105, 53, 21)];
        [passwordLabel setFrame:CGRectMake(67, 148, 81, 21)];
        [netIdField setFrame:CGRectMake(156, 100, 97, 31)];
        [passwordField setFrame:CGRectMake(156, 148, 97, 31)];
        [enterButton setFrame:CGRectMake(73, 207, 75, 37)];
        [skipButton setFrame:CGRectMake(167, 207, 75, 37)];
    } else {
        [scrollView setFrame:CGRectMake(0, 80, 320, 250)];
        [promptLabel setFrame:CGRectMake(0, 14, 320, 48)];
        [netIdLabel setFrame:CGRectMake(67, 80, 53, 21)];
        [passwordLabel setFrame:CGRectMake(67, 128, 81, 21)];
        [netIdField setFrame:CGRectMake(156, 70, 97, 31)];
        [passwordField setFrame:CGRectMake(156, 119, 97, 31)];
        [enterButton setFrame:CGRectMake(73, 175, 75, 37)];
        [skipButton setFrame:CGRectMake(167, 175, 75, 37)];
    }

}

- (void)changeToLandscapeLayout {
    if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 568, 30)];
        [scrollView setFrame:CGRectMake(124, 38, 320, 218)];
    } else {
        [topImage setFrame:CGRectMake(0, 0, 480, 30)];
        [scrollView setFrame:CGRectMake(80, 38, 320, 250)];

    }
    [topImage setImage:[UIImage imageNamed:@"top_small.png"]];
    [bottomImage setHidden:YES];
    [promptLabel setFrame:CGRectMake(0, 0, 320, 48)];
    [netIdLabel setFrame:CGRectMake(67, 60, 53, 21)];
    [passwordLabel setFrame:CGRectMake(67, 103, 81, 21)];
    [netIdField setFrame:CGRectMake(156, 55, 97, 31)];
    [passwordField setFrame:CGRectMake(156, 103, 97, 31)];
    [enterButton setFrame:CGRectMake(73, 162, 75, 37)];
    [skipButton setFrame:CGRectMake(167, 162, 75, 37)];
}

- (void)orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    [self.view setNeedsDisplay];
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            [self changeToPortraitLayout];
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self changeToLandscapeLayout];
            break;
        case UIDeviceOrientationLandscapeRight:
            [self changeToLandscapeLayout];
            break;
        default:
            break;
    };
}

@end
