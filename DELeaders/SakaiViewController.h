//
//  SakaiViewController.h
//  DELeaders
//
//  Created by guest user on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SakaiViewControllerHelper.h"

extern NSString* const sakaiTempWebViewTag;
extern NSString* const sakaiTempCalViewTag;

@interface SakaiViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *sakaiWebView;
@property (weak, nonatomic) IBOutlet UIWebView *sakaiWebViewTemp;
@property (weak, nonatomic) IBOutlet UIWebView *sakaiWebViewLoad;

- (void)setSelfAsWebViewsDelegate;

@end
