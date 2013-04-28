//
//  Utility.h
//  DELeaders
//
//  Created by guest user on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVWebViewController.h"
#import "LinksViewController.h"
#import "WordpressLoginViewController.h"

@interface Utility : NSObject
- (void)changeCurrentView:(UIViewController *)view url:(NSString *)url;
- (void)logout:(LinksViewController *)linksController;
- (void)registerOrientationHandler:(UIViewController *)controller;
- (void)loadWebView:(NSString *)fullURL webView:(UIWebView *)webView;
- (BOOL)isFourInchScreen;
- (BOOL)isPad;
- (BOOL)userLoggedIn;
- (BOOL)loggedIntoWordpress;
- (BOOL)loggedIntoSakai;
- (BOOL)netIdAndPasswordExist;
- (BOOL)clickedLogout;
- (BOOL)nsStringContains:(NSString *)main sub:(NSString *)sub;
- (BOOL)webViewContainsHtml:(UIWebView *)webView string:(NSString *)string;
- (NSString *)getTitleForWebView:(UIWebView *)webView;
- (NSString *)getCurrentURL:(UIWebView *)webView;
- (SVWebViewController *)openWebBrowser:(NSString *)url navController:(UINavigationController *)nav;
- (SVWebViewController *)replaceWebBrowser:(NSString *)url navController:(UINavigationController *)nav;
- (SVWebViewController *)openWebBrowserSakai:(UINavigationController *)nav;
- (SVWebViewController *)validateThroughSakai:(UINavigationController *)nav;
- (SVWebViewController *)openWebBrowserSakaiCal:(UINavigationController *)nav needToFillOutForm:(bool)fillBool;
- (WordpressLoginViewController *)loginToWordpress:(UIViewController *)viewController url:(NSString *)url;
@end
