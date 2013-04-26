//
//  SignInViewController.m
//  DELeaders
//
//  Created by anshim on 4/6/13.
//
//

#import "Utility.h"
#import "SignInViewController.h"
#import "SVWebViewController.h"
#import "SakaiValidationViewController.h"
#import "MBProgressHUD.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

@synthesize scrollView;
@synthesize enterButton;
@synthesize clearButton;
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
SakaiValidationViewController *validationController;
bool credentialsExist;

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
    validationController = [[SakaiValidationViewController alloc]init];
    [util registerOrientationHandler:self];
    credentialsExist = NO;
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        [self changeToPortraitLayout];
    } else if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        [self changeToLandscapeLayout];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEnterButton:nil];
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
    [self clearNetIdAndPassword];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self unregisterForKeyboardNotifications];
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([validationController doneValidating]) {
        return [validationController isValid];
    }
    return credentialsExist;
}

- (IBAction)pressEnterButton:(id)sender {
    if ([[netIdField text] length] == 0) {
        if ([[passwordField text] length] == 0) {
            [self alertMessage:@"Invalid" text:@"Please enter netID and password"];
        } else {
            [self alertMessage:@"Invalid" text:@"Please enter netID"];
        }
    } else if ([[passwordField text] length] == 0) {
        [self alertMessage:@"Invalid" text:@"Please enter password"];
    } else {
        if (![validationController doneValidating] && !credentialsExist) {
            [validationController validateNetIdAndPassword:[netIdField text] password:[passwordField text]];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Validating credentials";
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                while (![validationController doneValidating]) {}
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    MBProgressHUD *hudComp = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:hudComp];
                    if ([validationController isValid]) {
                        hudComp.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                        hudComp.labelText = @"Validated";
                        netId = netIdField.text;
                        password = passwordField.text;
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:netId forKey:@"netId"];
                        [defaults setObject:password forKey:@"password"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIntoSakai"];
                        [enterButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                    } else {
                        hudComp.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Xmark.png"]];
                        hudComp.labelText = @"Invalid credentials";
                        [validationController reset];
                    }
                    hudComp.mode = MBProgressHUDModeCustomView;
                    hudComp.delegate = self;
                    [hudComp show:YES];
                    [hudComp hide:YES afterDelay:1];
                });
            });
        }
    }
}

- (IBAction)pressClearButton:(id)sender {
    [self clearNetIdAndPassword];
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
    
    CGRect aRect = scrollView.frame;
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
    NSLog(@"%@", textField.text);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
}

- (void)checkForNetIdAndPassword {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    netId = [defaults objectForKey:@"netId"];
    password = [defaults objectForKey:@"password"];
    NSLog(@"NetId: %@", netId);
    NSLog(@"Password: %@", password);
    if (netId && password) {
        [netIdField setText:netId];
        [passwordField setText:password];
        credentialsExist = YES;
        [enterButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)clearNetIdAndPassword {
    [netIdField setText:@""];
    [passwordField setText:@""];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"netId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
}

- (void)changeToPortraitLayout {
    [topImage setImage:[UIImage imageNamed:@"top.png"]];
    [bottomImage setHidden:NO];
    if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 320, 80)];
        [scrollView setFrame:CGRectMake(0, 80, 320, 344)];
        [promptLabel setFrame:CGRectMake(0, 44, 320, 48)];
        [netIdLabel setFrame:CGRectMake(67, 105, 53, 21)];
        [passwordLabel setFrame:CGRectMake(67, 148, 81, 21)];
        [netIdField setFrame:CGRectMake(156, 100, 97, 31)];
        [passwordField setFrame:CGRectMake(156, 148, 97, 31)];
        [enterButton setFrame:CGRectMake(73, 207, 75, 37)];
        [clearButton setFrame:CGRectMake(167, 207, 75, 37)];
    } else if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 768, 192)];
        [scrollView setFrame:CGRectMake(0, 192, 768, 576)];
        [promptLabel setFrame:CGRectMake(261, 116, 245, 48)];
        [netIdLabel setFrame:CGRectMake(293, 189, 53, 21)];
        [passwordLabel setFrame:CGRectMake(265, 235, 81, 21)];
        [netIdField setFrame:CGRectMake(371, 184, 97, 31)];
        [passwordField setFrame:CGRectMake(371, 230, 97, 31)];
        [enterButton setFrame:CGRectMake(293, 303, 75, 37)];
        [clearButton setFrame:CGRectMake(393, 303, 75, 37)];
    } else {
        [topImage setFrame:CGRectMake(0, 0, 320, 80)];
        [scrollView setFrame:CGRectMake(0, 80, 320, 250)];
        [promptLabel setFrame:CGRectMake(0, 14, 320, 48)];
        [netIdLabel setFrame:CGRectMake(67, 80, 53, 21)];
        [passwordLabel setFrame:CGRectMake(67, 128, 81, 21)];
        [netIdField setFrame:CGRectMake(156, 70, 97, 31)];
        [passwordField setFrame:CGRectMake(156, 119, 97, 31)];
        [enterButton setFrame:CGRectMake(73, 175, 75, 37)];
        [clearButton setFrame:CGRectMake(167, 175, 75, 37)];
    }
}

- (void)changeToLandscapeLayout {
    if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 1024, 55)];
        [scrollView setFrame:CGRectMake(128, 100, 768, 576)];
        [promptLabel setFrame:CGRectMake(261, 116, 245, 48)];
        [netIdLabel setFrame:CGRectMake(293, 189, 53, 21)];
        [passwordLabel setFrame:CGRectMake(265, 235, 81, 21)];
        [netIdField setFrame:CGRectMake(371, 184, 97, 31)];
        [passwordField setFrame:CGRectMake(371, 230, 97, 31)];
        [enterButton setFrame:CGRectMake(293, 303, 75, 37)];
        [clearButton setFrame:CGRectMake(393, 303, 75, 37)];
    } else {
        if ([util isFourInchScreen]) {
            [topImage setFrame:CGRectMake(0, 0, 568, 30)];
            [scrollView setFrame:CGRectMake(124, 38, 320, 218)];
        } else {
            [topImage setFrame:CGRectMake(0, 0, 480, 30)];
            [scrollView setFrame:CGRectMake(80, 38, 320, 250)];
        }
        [promptLabel setFrame:CGRectMake(0, 0, 320, 48)];
        [netIdLabel setFrame:CGRectMake(67, 60, 53, 21)];
        [passwordLabel setFrame:CGRectMake(67, 103, 81, 21)];
        [netIdField setFrame:CGRectMake(156, 55, 97, 31)];
        [passwordField setFrame:CGRectMake(156, 103, 97, 31)];
        [enterButton setFrame:CGRectMake(73, 162, 75, 37)];
        [clearButton setFrame:CGRectMake(167, 162, 75, 37)];
    }
    [topImage setImage:[UIImage imageNamed:@"top_small.png"]];
    [bottomImage setHidden:YES];

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
