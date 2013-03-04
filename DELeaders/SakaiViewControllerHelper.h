//
//  SakaiViewControllerHelper.h
//  DELeaders
//
//  Created by guest user on 3/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SakaiViewControllerHelper : UIViewController

- (void)initSakaiSubView:(NSString *)urlString:(UIWebView *)webView;
- (void)fillSakaiSubViewForm:(UIWebView *)webView;
- (NSString *)clickLoginLink:(UIWebView *)webView:(UIWebView *)tempWebView;
- (BOOL)loggedIntoSakai;

@property (weak, nonatomic) NSString *netId;
@property (weak, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *const NO_LINK_TAG;


@end
