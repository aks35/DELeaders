//
//  ViewController.h
//  DELeaders
//
//  Created by guest user on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)openDEL:(id)sender;
- (IBAction)openNSE:(id)sender;
- (IBAction)openWP:(id)sender;
- (IBAction)openLibrary:(id)sender;
- (IBAction)openACES:(id)sender;
- (IBAction)openExecEd:(id)sender;
- (IBAction)pressEnterButton:(id)sender;
- (IBAction)openFacebook:(id)sender;
- (IBAction)openTwitter:(id)sender;
- (IBAction)openLinkedIn:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UITextField *netIdField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIWebView *calendarView;
@property (weak, nonatomic) IBOutlet UIWebView *sakaiView;

- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (void)loadWebView:(NSString *)fullURL:(UIWebView *)webView;
- (void)initSakaiSubView:(NSString *)urlString;
- (void)fillSakaiSubViewForm:(UIWebView *)webView;

@property (weak, nonatomic) UIView *activeField;
@property (weak, nonatomic) NSString *netId;
@property (weak, nonatomic) NSString *password;
@property BOOL *pageVisited;

@end
