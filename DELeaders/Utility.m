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
#import "WordpressLoginViewController.h"
#import "LogoutViewController.h"
#import "MBProgressHUD.h"
#import "LinksViewController.h"

@implementation Utility

SakaiViewController *sakai;
SakaiCalendarViewController *sakaiCal;
WordpressLoginViewController *wordpress;

- (void)changeCurrentView:(UIViewController *)view url:(NSString *)url {
    view =[[SVWebViewController alloc] initWithAddress:url];
}

- (void)logout:(LinksViewController *)linksController {
    LogoutViewController *logoutController = [[LogoutViewController alloc]init];
    [logoutController setUtility:self];
    [logoutController initLogout];
    NSLog(@"Logged Out");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:linksController.view animated:YES];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.labelText = @"Logging out";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        while (![logoutController sakaiLoggedOut] || ![logoutController wordpressLoggedOut]) {}
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:linksController.view animated:YES];
            MBProgressHUD *hudComp = [[MBProgressHUD alloc] initWithView:linksController.navigationController.view];
            [hudComp setRemoveFromSuperViewOnHide:YES];
            [linksController.navigationController.view addSubview:hudComp];
            hudComp.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hudComp.labelText = @"Successful logout";
            hudComp.mode = MBProgressHUDModeCustomView;
            hudComp.delegate = linksController;
            [hudComp show:YES];
            [hudComp hide:YES afterDelay:1];
            [sakai reset];
            [sakaiCal reset];
            [wordpress reset];
            [linksController.navigationController popToRootViewControllerAnimated:YES];
        });
    });
}

- (void)registerOrientationHandler:(UIViewController *)controller {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:controller selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
}

- (void)loadWebView:(NSString *)fullURL webView:(UIWebView *)webView {
    NSLog(@"Loading web view: %@",fullURL);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (BOOL)isFourInchScreen {
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    return iOSDeviceScreenSize.height == 568 || iOSDeviceScreenSize.width == 568;
}

- (BOOL)isPad {
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) return YES; /* Device is iPad */
    return NO;
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

- (BOOL)loggedIntoWordpress {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIntoWordPress"];
}

- (BOOL)loggedIntoSakai {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIntoSakai"];
}

- (BOOL)netIdAndPasswordExist {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *netId = [defaults objectForKey:@"netId"];
    NSString *password = [defaults objectForKey:@"password"];
    NSLog(@"NetId: %@", netId);
    NSLog(@"Password: %@", password);
    if (netId && password) {
        return YES;
    }
    return NO;
}

- (BOOL)nsStringContains:(NSString *)main sub:(NSString *)sub {
    if ([main rangeOfString:sub].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)webViewContainsHtml:(UIWebView *)webView string:(NSString *)string {
    NSString *javascript = @"var str='false';var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){if(links[i].innerHTML.indexOf('%@')!==-1){str=true;}}str;";
    javascript = [NSString stringWithFormat: javascript, string];
    NSLog(@"Javscfipt: %@", javascript);
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"RESULT FROM JS: %@ ---", result);
    if ([result isEqualToString:@"true"]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)getTitleForWebView:(UIWebView *)webView {
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"TITLE: %@", title);
    return title;
}

- (NSString *)getCurrentURL:(UIWebView *)webView {
    NSString *javascript = @"document.documentURI";
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"Current URI: %@", result);
    return result;
}

- (SVWebViewController *)openWebBrowser:(NSString *)url navController:(UINavigationController *)nav {
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:url];
    NSLog(@"URL: %@", url);
    [nav pushViewController:webViewController animated:YES];
    return webViewController;
}

- (SVWebViewController *)replaceWebBrowser:(NSString *)url navController:(UINavigationController *)nav {
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:url];
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:webViewController animated:YES];
    return webViewController;
}

- (SVWebViewController *)openWebBrowserSakai:(UINavigationController *)nav {
    SVWebViewController *webViewController = [[SVWebViewController alloc] init];
    sakai = [[SakaiViewController alloc]init];
    [webViewController registerSakaiHandler:sakai];
    NSLog(@"Registered sakai controller");
    [nav pushViewController:webViewController animated:YES];
    return webViewController;
}

- (SVWebViewController *)validateThroughSakai:(UINavigationController *)nav {
    SVWebViewController *webViewController = [[SVWebViewController alloc] init];
    sakai = [[SakaiViewController alloc]init];
    [webViewController registerSakaiHandler:sakai];
    NSLog(@"Registered sakai controller");
    [nav pushViewController:webViewController animated:YES];
    return webViewController;
}

- (SVWebViewController *)openWebBrowserSakaiCal:(UINavigationController *)nav needToFillOutForm:(bool)fillBool {
    SVWebViewController *webViewController = [[SVWebViewController alloc] init];
    sakaiCal = [[SakaiCalendarViewController alloc]init];
    sakaiCal.needToFillOutForm = fillBool;
    if (fillBool) {
        NSLog(@"NEED TO FILL OUT FORM");
    } else {
        NSLog(@"DO NOT NEED TO FILL OUT FORM");
    }
    [webViewController registerSakaiCalHandler:sakaiCal];
    NSLog(@"Registered sakai calendar controller");
    [nav pushViewController:webViewController animated:YES];
    return webViewController;
}

- (WordpressLoginViewController *)loginToWordpress:(UIViewController *)viewController url:(NSString *)url {
    wordpress = [[WordpressLoginViewController alloc]init];
    [wordpress setUtility:self];
    [wordpress initLogin];
//    [viewController.navigationController pushViewController:wordpress animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    [hud setRemoveFromSuperViewOnHide:YES];
    hud.labelText = @"Logging into Wordpress";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        while ([wordpress isNotLoggedIn]) {}
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            MBProgressHUD *hudComp = [[MBProgressHUD alloc] initWithView:viewController.navigationController.view];
            [hudComp setRemoveFromSuperViewOnHide:YES];
            [viewController.navigationController.view addSubview:hudComp];
            hudComp.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            hudComp.labelText = @"Successful login";
            hudComp.mode = MBProgressHUDModeCustomView;
            hudComp.delegate = viewController;
            [hudComp show:YES];
            [hudComp hide:YES afterDelay:1];
            SVWebViewController *webController = [[SVWebViewController alloc]init];
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, webController.view.frame.size.width, webController.view.frame.size.height)];
            [webView setDelegate:webController];
            webView.scalesPageToFit = YES;
            webView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [webController.view addSubview:webView];
            [self loadWebView:url webView:webView];
            [viewController.navigationController pushViewController:webController animated:YES];
        });
    });
    return wordpress;
}

@end
