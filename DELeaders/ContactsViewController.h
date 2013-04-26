//
//  ContactsViewController.h
//  DELeaders
//
//  Created by guest user on 3/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVWebViewController;
@class MBProgressHUD;

@interface ContactsViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;
@property (weak, nonatomic) IBOutlet UIButton *facultyButton;
@property (weak, nonatomic) IBOutlet UIButton *studentsButton;
@property (weak, nonatomic) IBOutlet UIButton *othersButton;
@property (strong, nonatomic) SVWebViewController *svWebController;
@property (strong, nonatomic) UIWebView *svWebViewMain;
@property (strong, nonatomic) UIWebView *svWebViewLoad;
@property (strong, nonatomic) MBProgressHUD *hud;

- (IBAction)facultyPressed:(id)sender;
- (IBAction)studentsPressed:(id)sender;
- (IBAction)othersPressed:(id)sender;
- (void)goToPageTemplate:(NSString *)index;
- (void)registerSVWebController:(SVWebViewController *)webController;
- (void)reset;
- (BOOL)loggedIntoWordpress;
- (BOOL)contactsWebViewDidFinishLoad:(UIWebView *)webView;



@end
