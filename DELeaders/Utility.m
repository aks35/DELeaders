//
//  Utility.m
//  DELeaders
//
//  Created by guest user on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"
#import "SVWebViewController.h"
#import "SakaiViewController.h"
#import "SakaiCalendarViewController.h"
#import "ContactsViewController.h"

@implementation Utility

- (void)loadWebView:(NSString *)fullURL webView:(UIWebView *)webView {
    NSLog(@"Loading web view: %@",fullURL);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (NSString *)getCurrentURL:(UIWebView *)webView {
    NSString *javascript = @"document.documentURI";
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"Current URI: %@", result);
    return result;
}

- (BOOL)isFourInchScreen {
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    return iOSDeviceScreenSize.height == 568 || iOSDeviceScreenSize.width == 568;
}

- (BOOL)isPad {
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    return iOSDeviceScreenSize.height == 1024 || iOSDeviceScreenSize.width == 1024 ;
}

- (void)registerOrientationHandler:(UIViewController *)controller {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:controller selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
}

- (BOOL)userLoggedIn {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *netId = [defaults objectForKey:@"netId"];
    NSString *password = [defaults objectForKey:@"password"];
    if (netId && password) {
        return YES;
    }
    return NO;
}

- (SVWebViewController *)openWebBrowser:(NSString *)url viewController:(UINavigationController *)nav {
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:url];
    [nav pushViewController:webViewController animated:YES];
    return webViewController;
}

- (SVWebViewController *)replaceWebBrowser:(NSString *)url viewController:(UINavigationController *)nav {
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:url];
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:webViewController animated:YES];
    return webViewController;
}

- (SVWebViewController *)openWebBrowserSakai:(NSString *)url viewController:(UINavigationController *)nav {
    SVWebViewController *webViewController = [[SVWebViewController alloc] init];
    SakaiViewController *sakai = [[SakaiViewController alloc]init];
    [webViewController registerSakaiHandler:sakai];
    NSLog(@"Registered sakai controller");
    [nav pushViewController:webViewController animated:YES];
    return webViewController;
}

- (SVWebViewController *)openWebBrowserSakaiCal:(NSString *)url viewController:(UINavigationController *)nav needToFillOutForm:(bool)fillBool {
    SVWebViewController *webViewController = [[SVWebViewController alloc] init];
    SakaiCalendarViewController *sakaiCal = [[SakaiCalendarViewController alloc]init];
    sakaiCal.needToFillOutForm = fillBool;
    if (fillBool ) {
        NSLog(@"NEED TO FILLE OUT FORM");
    } else {
        NSLog(@"DO NOT NEED TO FILL OUT FORM");
    }
    [webViewController registerSakaiCalHandler:sakaiCal];
    NSLog(@"Registered sakai calendar controller");
    [nav pushViewController:webViewController animated:YES];
    return webViewController;
}


- (SVWebViewController *)openWebBrowserContacts:(NSString *)url viewController:(UINavigationController *)nav {
    SVWebViewController *webViewController = [[SVWebViewController alloc] init];
    ContactsViewController *contacts = [[ContactsViewController alloc]init];
    [webViewController registerContactsHandler:contacts];
    NSLog(@"Registered contacts controller");
    [nav pushViewController:webViewController animated:YES];
    return webViewController;
}

- (void)changeCurrentView:(UIViewController *)view url:(NSString *)url {
    view =[[SVWebViewController alloc] initWithAddress:url];
}

- (BOOL)nsStringContains:(NSString *)main sub:(NSString *)sub {
    if ([main rangeOfString:sub].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)getTitleForWebView:(UIWebView *)webView {
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"TITLE: %@", title);
    return title;
}



@end
