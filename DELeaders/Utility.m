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

@end
