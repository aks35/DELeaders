//
//  ViewController.h
//  DELeaders
//
//  Created by guest user on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinksViewController : UIViewController <UIScrollViewDelegate>

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *delButton;
@property (weak, nonatomic) IBOutlet UIButton *nsoeButton;
@property (weak, nonatomic) IBOutlet UIButton *wpButton;
@property (weak, nonatomic) IBOutlet UIButton *calButton;
@property (weak, nonatomic) IBOutlet UIButton *coursesButton;
@property (weak, nonatomic) IBOutlet UIButton *sakaiButton;
@property (weak, nonatomic) IBOutlet UIButton *socialButton;
@property (weak, nonatomic) IBOutlet UIButton *imagesButton;
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet UIButton *contactsButton;
@property (weak, nonatomic) IBOutlet UIButton *acesButton;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *delLabel;
@property (weak, nonatomic) IBOutlet UILabel *nsoeLabel;
@property (weak, nonatomic) IBOutlet UILabel *wpLabel;
@property (weak, nonatomic) IBOutlet UILabel *calLabel;
@property (weak, nonatomic) IBOutlet UILabel *coursesLabel;
@property (weak, nonatomic) IBOutlet UILabel *sakaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialLabel;
@property (weak, nonatomic) IBOutlet UILabel *imagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *libraryLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactsLabel;
@property (weak, nonatomic) IBOutlet UILabel *acesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;

- (IBAction)calPressed:(id)sender;
- (IBAction)sakaiPressed:(id)sender;
- (IBAction)delPressed:(id)sender;
- (IBAction)nsoePressed:(id)sender;
- (IBAction)wpPressed:(id)sender;
- (IBAction)libraryPressed:(id)sender;
- (IBAction)acesPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateNumLabel;

- (void)alertMessage:(NSString *)title text:(NSString *)text;
- (void)updateDateLabels;


@end
