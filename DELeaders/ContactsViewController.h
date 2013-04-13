//
//  ContactsViewController.h
//  DELeaders
//
//  Created by guest user on 3/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *facultyView;
@property (weak, nonatomic) IBOutlet UIWebView *studentsView;
@property (weak, nonatomic) IBOutlet UIWebView *othersView;
@property (weak, nonatomic) IBOutlet UIWebView *studentsLoadView;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;
@property (weak, nonatomic) IBOutlet UIButton *facultyButton;
@property (weak, nonatomic) IBOutlet UIButton *studentsButton;
@property (weak, nonatomic) IBOutlet UIButton *othersButton;

- (IBAction)facultyPressed:(id)sender;
- (IBAction)studentsPressed:(id)sender;
- (IBAction)othersPressed:(id)sender;

- (void)setSelfAsWebViewsDelegate;
- (void)goToPageTemplate:(NSString *)index;
- (bool)loggedIntoWordpress;
@end
