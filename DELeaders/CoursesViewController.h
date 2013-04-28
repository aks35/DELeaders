//
//  CoursesViewController.h
//  DELeaders
//
//  Created by guest user on 3/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoursesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;
@property (weak, nonatomic) IBOutlet UIButton *scheduleButton;
@property (weak, nonatomic) IBOutlet UIButton *mpInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *independentStudyButton;
@property (weak, nonatomic) IBOutlet UIButton *professionalDevelopmentButton;
- (IBAction)schedulePressed:(id)sender;
- (IBAction)mpInfoPressed:(id)sender;
- (IBAction)independentStudyPressed:(id)sender;
- (IBAction)professionalDevelopmentPressed:(id)sender;
@end
