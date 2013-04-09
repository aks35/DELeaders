//
//  Utility.h
//  DELeaders
//
//  Created by guest user on 3/2/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
- (void)loadWebView:(NSString *)fullURL webView:(UIWebView *)webView;
- (void)logCurrentURL:(UIWebView *)webView;
- (BOOL)isFourInchScreen;
- (BOOL)isPad;
- (void)registerOrientationHandler:(UIViewController *)controller;
@end
