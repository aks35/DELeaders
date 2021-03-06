//
//  SVWebViewController.h
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <MessageUI/MessageUI.h>

#import "SVModalWebViewController.h"
@class SakaiViewController;
@class SakaiCalendarViewController;
@class ContactsViewController;

@interface SVWebViewController : UIViewController <UIWebViewDelegate>

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

- (void)addSakaiSubView:(UIWebView *)webView;
- (void)setMainView:(UIWebView *)mainView;
- (void)disableBackButton;
- (void)enableBackButton;
- (void)disableTitleControl;
- (void)enableTitleControl;


@property (nonatomic, readwrite) SVWebViewControllerAvailableActions availableActions;

@end
