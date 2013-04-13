//
//  GeneralWebViewController.m
//  DELeaders
//
//  Created by anshim on 3/24/13.
//
//

#import "GeneralWebViewController.h"
#import "Utility.h"
#import "MBProgressHUD.h"

@interface GeneralWebViewController ()

@end

@implementation GeneralWebViewController

@synthesize myWebView;
@synthesize myURL;
@synthesize myTitle;
@synthesize homeButton;

Utility *util;
MBProgressHUD *hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [myWebView setDelegate:self];
    util = [[Utility alloc]init];
    [util loadWebView:myURL webView:myWebView];
    myWebView.scalesPageToFit = YES;
    self.navigationItem.title = myTitle;
    hud = [[MBProgressHUD alloc]init];
    [hud hide:YES];
    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateBackButton {
    if ([myWebView canGoBack]) {
        if (!self.navigationItem.leftBarButtonItem) {
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backWasClicked:)];
            [self.navigationItem setLeftBarButtonItem:backItem animated:YES];
        }
    } else {
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    hud = [MBProgressHUD showHUDAddedTo:webView animated:YES];
    [self updateBackButton];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:webView animated:NO];
}

- (void)viewDidUnload {
    [self setMyWebView:nil];
    [self setHomeButton:nil];
    [super viewDidUnload];
}

- (IBAction)homePressed:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)backWasClicked:(id)sender {
    if ([myWebView canGoBack]) {
        [myWebView goBack];
    }
}

@end
