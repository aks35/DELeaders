//
//  ViewController.h
//  DELeaders
//
//  Created by guest user on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinksViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UITextField *netIdField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateNumLabel;


- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)checkForNetIdAndPassword;
- (void)alertMessage:(NSString *)title text:(NSString *)text;
- (void)updateDateLabels;

@property (weak, nonatomic) UIView *activeField;
@property (weak, nonatomic) NSString *netId;
@property (weak, nonatomic) NSString *password;

@end
