//
//  ContactsViewController.m
//  DELeaders
//
//  Created by guest user on 3/1/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ContactsViewController.h"
#import "Utility.h"
#import "SakaiViewControllerHelper.h"

@implementation ContactsViewController
@synthesize facultyView;
@synthesize studentsView;
@synthesize othersView;

Utility *util;
SakaiViewControllerHelper *helperController;
bool atLoginPage; 
bool clickedLoginLink;
bool loggedIn, atStudentDirectory;

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
    util = [[Utility alloc]init];
    helperController = [[SakaiViewControllerHelper alloc]init];
    [self setSelfAsWebViewsDelegate];
    atLoginPage = NO;
    clickedLoginLink = NO;
    loggedIn = NO;
    atStudentDirectory = NO;
    [self loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/faculty/" :facultyView];
    [self loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/students" :studentsView];
    [self loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/other-important-nicholas-school-contacts/" :othersView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView == studentsView) {
        if (atStudentDirectory) {
            NSLog(@"Hello world");
        }
        else if (loggedIn) {
            NSLog(@"LOGGED IN CASE");
            [util loadWebView:@"http://sites.nicholas.duke.edu/delmeminfo/contact-information/students/student-directory/" :studentsView];
            atStudentDirectory = YES;
        }
        else if (clickedLoginLink && atLoginPage) {
            [helperController fillSakaiSubViewForm:studentsView];
            loggedIn = YES;
        }
        else if (clickedLoginLink && !atLoginPage) {
            atLoginPage = YES;
            [self goToPageTempalte:@"Click Here"];
        }
        else if (!clickedLoginLink && !atLoginPage) {
            NSLog(@"In STUDENTS VIEW");
            clickedLoginLink = YES;
            [self goToPageTempalte:@"login"];
        } else {
            NSLog(@"UNCAUGHT CASE");
        }
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

- (void)setSelfAsWebViewsDelegate {
    [facultyView setDelegate:self];
    [studentsView setDelegate:self];
    [othersView setDelegate:self];
}

- (void)goToPageTempalte:(NSString *)index {
    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){if(links[i].innerHTML.indexOf('%@')!==-1){str=links[i].href;break;}}str;";
    //    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){str += links[i].href;}str;";
    javascript = [NSString stringWithFormat:javascript, index];
    NSString *result = [studentsView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"JAVASCRIPT: %@", javascript);
    NSLog(@"RESULT BUZZ: %@", result);
    [util loadWebView:result :studentsView];
}

@end
