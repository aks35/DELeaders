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
#import "MBProgressHUD.h"

MBProgressHUD *hud;

@implementation ContactsViewController
@synthesize facultyView;
@synthesize studentsView;
@synthesize othersView;
@synthesize studentsLoadView;

Utility *util;
SakaiViewControllerHelper *helperController;
bool atLoginPage;
bool clickedLoginLink, filledOutSakaiForm;
bool loggedIn, atStudentDirectory, loadedStudentsDirectory;

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

- (void)setSelfAsWebViewsDelegate {
    [facultyView setDelegate:self];
    [studentsView setDelegate:self];
    [othersView setDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    util = [[Utility alloc]init];
    helperController = [[SakaiViewControllerHelper alloc]init];
    [self setSelfAsWebViewsDelegate];
    [util loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/faculty/" webView:facultyView];
    [util loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/students" webView:studentsView];
    [util loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/other-important-nicholas-school-contacts/" webView:othersView];
    hud = [[MBProgressHUD alloc]init];
    [hud hide:YES];
    [studentsView setHidden:YES];
}

- (void)viewDidUnload
{
    [self setFacultyView:nil];
    [self setStudentsView:nil];
    [self setOthersView:nil];
    [self setStudentsLoadView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)goToPageTempalte:(NSString *)index {
    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){if(links[i].innerHTML.indexOf('%@')!==-1){str=links[i].href;break;}}str;";
    //    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){str += links[i].href;}str;";
    javascript = [NSString stringWithFormat:javascript, index];
    NSString *result = [studentsView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"JAVASCRIPT: %@", javascript);
    NSLog(@"RESULT BUZZ: %@", result);
    [util loadWebView:result webView:studentsView];
}

- (bool)loggedIntoWordpress {
    NSString *javascript = @"document.getElementById('wpadminbar')==null;";
    NSString *result = [studentsView stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"===== RESULTS: %@",result);
    if ([result isEqualToString:@"true"]) {
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView == studentsView) {
        if (atStudentDirectory) {
            NSLog(@"Hello world");
            [MBProgressHUD hideHUDForView:studentsLoadView animated:YES];
            [studentsLoadView setHidden:YES];
            [studentsView setHidden:NO];
        }
        else if (clickedLoginLink && atLoginPage) {
            [helperController fillSakaiSubViewForm:studentsView];
            if ([self loggedIntoWordpress]){
                loggedIn = YES;
                NSLog(@"FINISHED LOGGING IN");
                [util loadWebView:@"http://sites.nicholas.duke.edu/delmeminfo/contact-information/students/student-directory/" webView:studentsView];
                atStudentDirectory = YES;
            }
        }
        else if (clickedLoginLink && !atLoginPage) {
            atLoginPage = YES;
            [self goToPageTempalte:@"Click Here"];
        }
        else if (!clickedLoginLink && !atLoginPage) {
            hud = [MBProgressHUD showHUDAddedTo:studentsLoadView animated:YES];
            hud.labelText = @"Logging into Wordpress";
            NSLog(@"In STUDENTS VIEW");
            clickedLoginLink = YES;
            [self goToPageTempalte:@"login"];
        } else {
            NSLog(@"UNCAUGHT CASE");
        }
    }
}

@end
