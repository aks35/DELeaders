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
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;
@property (weak, nonatomic) IBOutlet UIButton *scheduleButton;
- (IBAction)detailsPressed:(id)sender;
- (IBAction)schedulePressed:(id)sender;
@end
