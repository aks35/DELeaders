//
//  ContactsViewController.h
//  DELeaders
//
//  Created by guest user on 3/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *facultyView;
@property (weak, nonatomic) IBOutlet UIWebView *studentsView;
@property (weak, nonatomic) IBOutlet UIWebView *othersView;

- (void)loadWebView:(NSString *)fullURL:(UIWebView *)webView;
- (void)setSelfAsWebViewsDelegate;
- (void)goToPageTempalte:(NSString *)index;

@end
