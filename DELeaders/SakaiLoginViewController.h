//
//  SakaiLoginViewController.h
//  DELeaders
//
//  Created by anshim on 5/2/13.
//
//

#import <UIKit/UIKit.h>
@class SVWebViewController;
@class MBProgressHUD;
@class Utility;

#define calendarUrlKey @"sakaiCalendarUrl"

@interface SakaiLoginViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic) BOOL isNotLoggedIn;
@property (nonatomic) NSString *currentUrl;

- (void)setUtility:(Utility *)utility;
- (void)initLogin:(bool)goToCalendar;
- (void)reset;

@end
