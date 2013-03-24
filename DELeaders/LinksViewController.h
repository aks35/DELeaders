//
//  ViewController.h
//  DELeaders
//
//  Created by guest user on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinksViewController : UIViewController
- (IBAction)openDEL:(id)sender;
- (IBAction)openNSOE:(id)sender;
- (IBAction)openWP:(id)sender;
- (IBAction)openLibrary:(id)sender;
- (IBAction)openACES:(id)sender;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UITextField *netIdField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;


- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)checkForNetIdAndPassword;
- (void)alertMessage:(NSString *)title text:(NSString *)text;

@property (weak, nonatomic) UIView *activeField;
@property (weak, nonatomic) NSString *netId;
@property (weak, nonatomic) NSString *password;

@end
