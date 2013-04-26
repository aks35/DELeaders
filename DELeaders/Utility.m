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
#import "LogoutViewController.h"
#import "MBProgressHUD.h"

@implementation Utility

SakaiViewController *sakai;
SakaiCalendarViewController *sakaiCal;
ContactsViewController *contacts;

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
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) return YES; /* Device is iPad */
    return NO;
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
    NSLog(@"URL: %@", url);
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
    sakai = [[SakaiViewController alloc]init];
    [webViewController registerSakaiHandler:sakai];
    NSLog(@"Registered sakai controller");
    [nav pushViewController:webViewController animated:YES];
    return webViewController;
}

- (SVWebViewController *)validateThroughSakai:(NSString *)url viewController:(UINavigationController *)nav {
    SVWebViewController *webViewController = [[SVWebViewController alloc] init];
    sakai = [[SakaiViewController alloc]init];
    [webViewController registerSakaiHandler:sakai];
    NSLog(@"Registered sakai controller");
    [nav pushViewController:webViewController animated:YES];
    return webViewController;
}

- (SVWebViewController *)openWebBrowserSakaiCal:(NSString *)url viewController:(UINavigationController *)nav needToFillOutForm:(bool)fillBool {
    SVWebViewController *webViewController = [[SVWebViewController alloc] init];
    sakaiCal = [[SakaiCalendarViewController alloc]init];
    sakaiCal.needToFillOutForm = fillBool;
    if (fillBool) {
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
    contacts = [[ContactsViewController alloc]init];
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
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loggedIntoSakai"];
            [sakai reset];
            [sakaiCal reset];
            [contacts reset];
            [linksController.navigationController popToRootViewControllerAnimated:YES];
        });
    });
}

@end
