//
//  SakaiCalendarViewController.h
//  DELeaders
//
//  Created by guest user on 3/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SakaiViewControllerHelper.h"

@interface SakaiCalendarViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *sakaiCalView;
@property (weak, nonatomic) IBOutlet UIWebView *sakaiCalViewTemp;
@property (weak, nonatomic) IBOutlet UIWebView *sakaiCalViewLoad;

@property (strong, nonatomic) SakaiViewControllerHelper *helperController;
- (void)setSelfAsWebViewsDelegate;

@end
