//
//  SakaiValidationViewController.h
//  DELeaders
//
//  Created by anshim on 4/25/13.
//
//

#import <UIKit/UIKit.h>

@interface SakaiValidationViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic) BOOL doneValidating;
@property (nonatomic) BOOL isValid;
@property (nonatomic) BOOL formFilledOut;

-(void)validateNetIdAndPassword:(NSString *)netID password:(NSString *)password;
-(void)reset;

@end
