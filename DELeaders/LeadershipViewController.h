//
//  LeadershipViewController.h
//  DELeaders
//
//  Created by anshim on 4/25/13.
//
//

#import <UIKit/UIKit.h>

@interface LeadershipViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImage;
- (IBAction)openFirstYear:(id)sender;
- (IBAction)openSecondYear:(id)sender;
@end
