//
//  AppDelegate.h
//  DELeaders
//
//  Created by guest user on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) NSString *netID;
@property (weak, nonatomic) NSString *password;

- (void)loadWebView:(NSString *)fullURL webView:(UIWebView *)webView;
- (void)initializeStoryBoardBasedOnScreenSize;

@end
