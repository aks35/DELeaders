//
//  ViewController.h
//  DELeaders
//
//  Created by guest user on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)openDEL:(id)sender;
- (IBAction)openNSE:(id)sender;
- (IBAction)openWP:(id)sender;
- (IBAction)openSakai:(id)sender;
- (IBAction)openLibrary:(id)sender;
- (IBAction)openACES:(id)sender;
- (IBAction)openExecEd:(id)sender;
- (IBAction)openCal:(id)sender;
- (IBAction)pressEnterButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UITextField *netIdField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIWebView *sakaiCal;

- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;


@property (weak, nonatomic) UIView *activeField;

@end
