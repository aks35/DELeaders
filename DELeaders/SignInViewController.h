//
//  SignInViewController.h
//  DELeaders
//
//  Created by anshim on 4/6/13.
//
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UILabel *netIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *netIdField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)pressEnterButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;

@property (weak, nonatomic) UIView *activeField;
@property (weak, nonatomic) NSString *netId;
@property (weak, nonatomic) NSString *password;

- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)checkForNetIdAndPassword;
- (void)alertMessage:(NSString *)title text:(NSString *)text;


@end
