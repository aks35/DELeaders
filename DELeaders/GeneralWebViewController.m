//
//  GeneralWebViewController.m
//  DELeaders
//
//  Created by anshim on 3/24/13.
//
//

#import "GeneralWebViewController.h"
#import "Utility.h"

@interface GeneralWebViewController ()

@end

@implementation GeneralWebViewController

@synthesize myWebView;
@synthesize myURL;
@synthesize myTitle;

Utility *util;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyWebView:nil];
    [super viewDidUnload];
}
@end
