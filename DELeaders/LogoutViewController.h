//
//  LogoutViewController.h
//  DELeaders
//
//  Created by anshim on 4/26/13.
//
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface LogoutViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic) BOOL sakaiLoggedOut;
@property (nonatomic) BOOL wordpressLoggedOut;
- (void)setUtility:(Utility *)util;
- (void)initLogout;
@end
