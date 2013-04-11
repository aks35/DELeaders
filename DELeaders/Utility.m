//
//  Utility.m
//  DELeaders
//
//  Created by guest user on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"

@implementation Utility

- (void)loadWebView:(NSString *)fullURL webView:(UIWebView *)webView {
    NSLog(@"Loading web view: %@",fullURL);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (void)logCurrentURL:(UIWebView *)webView {
    NSString *javascript = @"document.documentURI";
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"Current URI: %@", result);
}

- (BOOL)isFourInchScreen {
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    return iOSDeviceScreenSize.height == 568 || iOSDeviceScreenSize.width == 568;
}

- (BOOL)isPad {
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    return iOSDeviceScreenSize.height == 960 || iOSDeviceScreenSize.width == 960;
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


@end
