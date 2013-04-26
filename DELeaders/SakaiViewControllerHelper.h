//
//  SakaiViewControllerHelper.h
//  DELeaders
//
//  Created by guest user on 3/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SakaiViewControllerHelper : UIViewController

- (NSString *)fillSakaiSubViewForm:(UIWebView *)webView netID:(NSString *)netID password:(NSString *)password;
- (NSString *)clickLoginLink:(UIWebView *)webView tempWebView:(UIWebView *)tempWebView;
- (void)printCurrentURL:(UIWebView *)webView;
- (BOOL)inWorkspace;
- (bool)isLoggedIn:(UIWebView *)webView;

@property (nonatomic) BOOL inWorkspace;
@property (strong, nonatomic) NSString *const NO_LINK_TAG;


@end
