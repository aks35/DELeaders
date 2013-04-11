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

@implementation ContactsViewController

@synthesize facultyView;
@synthesize studentsView;
@synthesize othersView;
@synthesize studentsLoadView;
@synthesize topImage;
@synthesize bottomImage;
@synthesize facultyButton;
@synthesize studentsButton;
@synthesize othersButton;

MBProgressHUD *hud;
Utility *util;
SakaiViewControllerHelper *helperController;
bool atLoginPage, clickedLoginLink, loggedIn, atStudentDirectory, visitedStudentsPage;

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
    [util registerOrientationHandler:self];
    [util loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/faculty/" webView:facultyView];
    facultyView.scalesPageToFit = YES;
    [util loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/students/student-directory/" webView:studentsView];
    studentsView.scalesPageToFit = YES;
    [util loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/other-important-nicholas-school-contacts/" webView:othersView];
    othersView.scalesPageToFit = YES;
    hud = [[MBProgressHUD alloc]init];
    [hud hide:YES];
    [studentsView setHidden:YES];
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        [self changeToPortraitLayout];
    } else if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        [self changeToLandscapeLayout];
    }
}

- (void)viewDidUnload
{
    [self setFacultyView:nil];
    [self setStudentsView:nil];
    [self setOthersView:nil];
    [self setStudentsLoadView:nil];
    [self setTopImage:nil];
    [self setBottomImage:nil];
    [self setFacultyButton:nil];
    [self setStudentsButton:nil];
    [self setOthersButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)goToPageTemplate:(NSString *)index {
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
        if (visitedStudentsPage) {
            [studentsLoadView setHidden:YES];
            [studentsView setHidden:NO];
            NSLog(@"Page already visited");
        }
        else if (atStudentDirectory) {
            NSLog(@"Hello world");
            [MBProgressHUD hideHUDForView:studentsLoadView animated:YES];
            [studentsLoadView setHidden:YES];
            [studentsView setHidden:NO];
            visitedStudentsPage = YES;
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
            [self goToPageTemplate:@"Click Here"];
        }
        else if (!clickedLoginLink && !atLoginPage) {
            hud = [MBProgressHUD showHUDAddedTo:studentsLoadView animated:YES];
            hud.labelText = @"Logging into Wordpress";
            NSLog(@"In STUDENTS VIEW");
            clickedLoginLink = YES;
            [self goToPageTemplate:@"login"];
        } else {
            NSLog(@"UNCAUGHT CASE");
        }
    }
}

- (void)changeToPortraitLayout {
    [topImage setFrame:CGRectMake(0, 0, 320, 80)];
    [topImage setImage:[UIImage imageNamed:@"top.png"]];
    [bottomImage setHidden:NO];
    if ([util isFourInchScreen]) {
        [facultyButton setFrame:CGRectMake(30, 126, 260, 60)];
        [studentsButton setFrame:CGRectMake(30, 216, 260, 60)];
        [othersButton setFrame:CGRectMake(30, 306, 260, 60)];
    } else {
        [facultyButton setFrame:CGRectMake(30, 104, 260, 60)];
        [studentsButton setFrame:CGRectMake(30, 178, 260, 60)];
        [othersButton setFrame:CGRectMake(30, 252, 260, 60)];
    }
    
}

- (void)changeToLandscapeLayout {
    [topImage setImage:[UIImage imageNamed:@"top_small.png"]];
    [bottomImage setHidden:YES];
    if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 568, 30)];
        [facultyButton setFrame:CGRectMake(154, 45, 260, 60)];
        [studentsButton setFrame:CGRectMake(154, 115, 260, 60)];
        [othersButton setFrame:CGRectMake(154, 185, 260, 60)];

    } else {
        [topImage setFrame:CGRectMake(0, 0, 480, 30)];
        [facultyButton setFrame:CGRectMake(110, 40, 260, 60)];
        [studentsButton setFrame:CGRectMake(110, 119, 260, 60)];
        [othersButton setFrame:CGRectMake(110, 198, 260, 60)];
    }
}

- (void)orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    [self.view setNeedsDisplay];
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            [self changeToPortraitLayout];
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self changeToLandscapeLayout];
            break;
        case UIDeviceOrientationLandscapeRight:
            [self changeToLandscapeLayout];
            break;
        default:
            break;
    };
}


@end
