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

@synthesize svWebController, svWebViewMain, svWebViewLoad, svWebViewFinal;

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

- (IBAction)facultyPressed:(id)sender {
    [util openWebBrowser:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/faculty/" viewController:self.navigationController];
}

- (IBAction)studentsPressed:(id)sender {
    if (visitedStudentsPage) {
        [util openWebBrowser:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/students/student-directory/"  viewController:self.navigationController];
    } else {
        [util openWebBrowserContacts:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/students/student-directory/" viewController:self.navigationController];
    }
}

- (IBAction)othersPressed:(id)sender {
    [util openWebBrowser:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/other-important-nicholas-school-contacts/" viewController:self.navigationController];
}

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
    NSString *result = [svWebViewMain stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"JAVASCRIPT: %@", javascript);
    NSLog(@"RESULT BUZZ: %@", result);
    [util loadWebView:result webView:svWebViewMain];
}

- (bool)loggedIntoWordpress {
    NSString *javascript = @"document.getElementById('wpadminbar')==null;";
    NSString *result = [svWebViewMain stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"===== RESULTS: %@",result);
    if ([result isEqualToString:@"true"]) {
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
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


- (BOOL)autoLoginToWordpress:(UIWebView *)webView {
    if (webView == svWebViewMain) {
        if (visitedStudentsPage) {
            [svWebViewLoad setHidden:YES];
            [svWebViewMain setHidden:NO];
            NSLog(@"Page already visited");
            return NO;
        }
        else if (atStudentDirectory) {
            NSLog(@"Hello world");
            [MBProgressHUD hideHUDForView:svWebViewLoad animated:YES];
            [svWebController.navigationItem setHidesBackButton:NO animated:YES];
            [svWebViewLoad setHidden:YES];
            [svWebViewMain setHidden:NO];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIntoWordPress"];
            visitedStudentsPage = YES;
            return NO;
        }
        else if (clickedLoginLink && atLoginPage) {
            [helperController fillSakaiSubViewForm:svWebViewMain];
            if ([self loggedIntoWordpress]){
                loggedIn = YES;
                NSLog(@"FINISHED LOGGING IN");
                [util loadWebView:@"http://sites.nicholas.duke.edu/delmeminfo/contact-information/students/student-directory/" webView:svWebViewMain];
                atStudentDirectory = YES;
            }
        }
        else if (clickedLoginLink && !atLoginPage) {
            atLoginPage = YES;
            [self goToPageTemplate:@"Click Here"];
        }
        else if (!clickedLoginLink && !atLoginPage) {
            hud = [MBProgressHUD showHUDAddedTo:svWebViewLoad animated:YES];
            hud.labelText = @"Logging into Wordpress";
            [svWebController.navigationItem setHidesBackButton:YES animated:YES];
            NSLog(@"In STUDENTS VIEW");
            clickedLoginLink = YES;
            [self goToPageTemplate:@"login"];
        } else {
            NSLog(@"UNCAUGHT CASE");
        }
    }
    return YES;
}

- (BOOL)contactsWebViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"IN ContaCts WEB VIEW DID FINISH LOAD");
    if ([util userLoggedIn]) {
        return [self autoLoginToWordpress:webView];
    } else {
        return NO;
    }
}


- (void)registerSVWebController:(SVWebViewController *)webController {
    svWebController = webController;
    svWebViewMain = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
    svWebViewLoad = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
    svWebViewFinal = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
    
    [svWebViewMain setHidden:YES];
    
    [svWebViewMain setDelegate:svWebController];
    svWebViewMain.scalesPageToFit = YES;
    
    [webController.view addSubview:svWebViewMain];
    [webController.view addSubview:svWebViewLoad];
    [webController setMainView:svWebViewMain];
    
    util = [[Utility alloc]init];
    
    [util loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/students/student-directory/" webView:svWebViewMain];
    helperController = [[SakaiViewControllerHelper alloc]init];
}


@end
