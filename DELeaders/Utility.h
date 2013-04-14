//
//  Utility.h
//  DELeaders
//
//  Created by guest user on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVWebViewController.h"

@interface Utility : NSObject
- (void)loadWebView:(NSString *)fullURL webView:(UIWebView *)webView;
- (NSString *)getCurrentURL:(UIWebView *)webView;
- (BOOL)isFourInchScreen;
- (BOOL)isPad;
- (void)registerOrientationHandler:(UIViewController *)controller;
- (BOOL)userLoggedIn;

- (SVWebViewController *)openWebBrowser:(NSString *)url viewController:(UINavigationController *)nav;
- (SVWebViewController *)replaceWebBrowser:(NSString *)url viewController:(UINavigationController *)nav;
- (SVWebViewController *)openWebBrowserSakai:(NSString *)url viewController:(UINavigationController *)nav;
- (SVWebViewController *)openWebBrowserSakaiCal:(NSString *)url viewController:(UINavigationController *)nav needToFillOutForm:(bool)fillBool;
- (SVWebViewController *)openWebBrowserContacts:(NSString *)url viewController:(UINavigationController *)nav;


- (void)changeCurrentView:(UIViewController *)view url:(NSString *)url;
- (BOOL)nsStringContains:(NSString *)main sub:(NSString *)sub;
- (NSString *)getTitleForWebView:(UIWebView *)webView;

@end
