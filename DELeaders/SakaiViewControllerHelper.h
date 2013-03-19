//
//  SakaiViewControllerHelper.h
//  DELeaders
//
//  Created by guest user on 3/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SakaiViewControllerHelper : UIViewController

- (void)initSakaiSubView:(NSString *)urlString webView:(UIWebView *)webView;
- (void)fillSakaiSubViewForm:(UIWebView *)webView;
- (NSString *)clickLoginLink:(UIWebView *)webView tempWebView:(UIWebView *)tempWebView;
- (void)printCurrentURL:(UIWebView *)webView;
- (BOOL)inWorkspace;

@property (weak, nonatomic) NSString *netId;
@property (weak, nonatomic) NSString *password;
@property (nonatomic) BOOL inWorkspace;
@property (strong, nonatomic) NSString *const NO_LINK_TAG;


@end
