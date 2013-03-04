//
//  ContactsViewController.m
//  DELeaders
//
//  Created by guest user on 3/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ContactsViewController.h"

@implementation ContactsViewController
@synthesize facultyView;
@synthesize studentsView;
@synthesize othersView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/faculty/" :facultyView];
    
    [self loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/students" :studentsView];
    
    [self loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/other-important-nicholas-school-contacts/" :othersView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView == studentsView) {
        
    }
}

- (void)viewDidUnload
{
    [self setFacultyView:nil];
    [self setStudentsView:nil];
    [self setOthersView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadWebView:(NSString *)fullURL:(UIWebView *)webView {
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

@end
