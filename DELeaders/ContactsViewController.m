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
#import "WordpressLoginViewController.h"

@implementation ContactsViewController

@synthesize topImage;
@synthesize bottomImage;
@synthesize facultyButton;
@synthesize studentsButton;
@synthesize othersButton;

//@synthesize svWebController, svWebViewMain, svWebViewLoad;

//MBProgressHUD *hud;
Utility *util;
//SakaiViewControllerHelper *helperController;
//bool atLoginPage, clickedLoginLink, loggedIn, atStudentDirectory, visitedStudentsPage;

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
    [util openWebBrowser:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/faculty/" navController:self.navigationController];
}

- (IBAction)studentsPressed:(id)sender {
    NSString *wordpressUrl = @"http://sites.nicholas.duke.edu/delmeminfo/contact-information/students/student-directory/";
    if ([util loggedIntoWordpress]) {
        [util openWebBrowser:wordpressUrl navController:self.navigationController];
    } else {
        [util loginToWordpress:self url:wordpressUrl];
    }
}

- (IBAction)othersPressed:(id)sender {
    [util openWebBrowser:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/other-important-nicholas-school-contacts/" navController:self.navigationController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    util = [[Utility alloc]init];
    [util registerOrientationHandler:self];
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        [self changeToPortraitLayout];
    } else if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        [self changeToLandscapeLayout];
    }
}

- (void)viewDidUnload
{
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

//- (void)goToPageTemplate:(NSString *)index {
//    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){if(links[i].innerHTML.indexOf('%@')!==-1){str=links[i].href;break;}}str;";
//    //    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){str += links[i].href;}str;";
//    javascript = [NSString stringWithFormat:javascript, index];
//    NSString *result = [svWebViewMain stringByEvaluatingJavaScriptFromString:javascript];
//    NSLog(@"JAVASCRIPT: %@", javascript);
//    NSLog(@"RESULT BUZZ: %@", result);
//    [util loadWebView:result webView:svWebViewMain];
//}

//- (BOOL)loggedIntoWordpress {
//    NSString *javascript = @"document.getElementById('wpadminbar')==null;";
//    NSString *result = [svWebViewMain stringByEvaluatingJavaScriptFromString:javascript];
//    NSLog(@"===== RESULTS: %@",result);
//    if ([result isEqualToString:@"true"]) {
//        return NO;
//    }
//    return YES;
//}

- (void)changeToPortraitLayout {
    [topImage setImage:[UIImage imageNamed:@"top.png"]];
    [bottomImage setHidden:NO];
    if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 768, 192)];
        [facultyButton setFrame:CGRectMake(154, 325, 460, 80)];
        [studentsButton setFrame:CGRectMake(154, 425, 460, 80)];
        [othersButton setFrame:CGRectMake(154, 525, 460, 80)];
    } else {
        [topImage setFrame:CGRectMake(0, 0, 320, 80)];
        if ([util isFourInchScreen]) {
            [facultyButton setFrame:CGRectMake(30, 142, 260, 60)];
            [studentsButton setFrame:CGRectMake(30, 222, 260, 60)];
            [othersButton setFrame:CGRectMake(30, 302, 260, 60)];
        } else {
            [facultyButton setFrame:CGRectMake(30, 104, 260, 60)];
            [studentsButton setFrame:CGRectMake(30, 178, 260, 60)];
            [othersButton setFrame:CGRectMake(30, 252, 260, 60)];
        }
    }
}

- (void)changeToLandscapeLayout {
    [topImage setImage:[UIImage imageNamed:@"top_small.png"]];
    [bottomImage setHidden:YES];
    if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 1024, 55)];
        [facultyButton setFrame:CGRectMake(282, 190, 460, 80)];
        [studentsButton setFrame:CGRectMake(282, 290, 460, 80)];
        [othersButton setFrame:CGRectMake(282, 390, 460, 80)];
    } else if ([util isFourInchScreen]) {
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
    if ([util isPad]) {
        switch(device.orientation)
        {
            case UIDeviceOrientationPortrait:
                [self changeToPortraitLayout];
                break;
                
            case UIDeviceOrientationPortraitUpsideDown:
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
    } else {
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
}

//
//- (BOOL)autoLoginToWordpress:(UIWebView *)webView {
//    if (webView == svWebViewMain) {
//        if (visitedStudentsPage) {
//            [svWebViewLoad setHidden:YES];
//            [svWebViewMain setHidden:NO];
//            return NO;
//        }
//        else if (atStudentDirectory) {
//            [MBProgressHUD hideHUDForView:svWebViewLoad animated:YES];
//            [svWebController enableBackButton];
//            [svWebController enableTitleControl];
//            [svWebController setTitle:[util getTitleForWebView:svWebViewMain]];
//            [svWebViewLoad setHidden:YES];
//            [svWebViewMain setHidden:NO];
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIntoWordPress"];
//            visitedStudentsPage = YES;
//            return NO;
//        }
//        else if (clickedLoginLink && atLoginPage) {
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            NSString *netID = [defaults objectForKey:@"netId"];
//            NSString *password = [defaults objectForKey:@"password"];
//            [helperController fillSakaiSubViewForm:svWebViewMain netID:netID password:password];
//            if ([self loggedIntoWordpress]){
//                loggedIn = YES;
//                NSLog(@"FINISHED LOGGING IN");
//                [util loadWebView:@"http://sites.nicholas.duke.edu/delmeminfo/contact-information/students/student-directory/" webView:svWebViewMain];
//                atStudentDirectory = YES;
//            }
//        }
//        else if (clickedLoginLink && !atLoginPage) {
//            atLoginPage = YES;
//            [self goToPageTemplate:@"Click Here"];
//        }
//        else if (!clickedLoginLink && !atLoginPage) {
//            hud = [MBProgressHUD showHUDAddedTo:svWebViewLoad animated:YES];
//            hud.labelText = @"Logging into Wordpress";
//            [svWebController disableBackButton];
//            NSLog(@"In STUDENTS VIEW");
//            clickedLoginLink = YES;
//            [self goToPageTemplate:@"login"];
//        } else {
//            NSLog(@"UNCAUGHT CASE");
//        }
//    }
//    return YES;
//}
//
//- (BOOL)contactsWebViewDidFinishLoad:(UIWebView *)webView {
//    if ([util userLoggedIn]) {
//        return [self autoLoginToWordpress:webView];
//    } else {
//        [svWebViewLoad removeFromSuperview];
//        [svWebViewMain setHidden:NO];
//        return NO;
//    }
//}
//
//- (void)registerSVWebController:(SVWebViewController *)webController {
//    svWebController = webController;
//    [svWebController setTitle:@"Contacts"];
//    [svWebController disableTitleControl];
//    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
//        svWebViewLoad = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
//    } else if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
//        svWebViewLoad = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.height, svWebController.view.frame.size.width)];
//    }
//    svWebViewMain = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
//    
//    [svWebViewMain setHidden:YES];
//    [svWebViewMain setDelegate:svWebController];
//    svWebViewMain.scalesPageToFit = YES;
//    svWebViewMain.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    [webController.view addSubview:svWebViewMain];
//    [webController.view addSubview:svWebViewLoad];
//    [webController setMainView:svWebViewMain];
//    
//    util = [[Utility alloc]init];
//    
//    [util loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/contact-information/students/student-directory/" webView:svWebViewMain];
//    helperController = [[SakaiViewControllerHelper alloc]init];
//}
//
//- (void)reset {
//    self.svWebController = nil;
//    self.svWebViewLoad = nil;
//    self.svWebViewMain = nil;
//    atLoginPage = NO;
//    clickedLoginLink = NO;
//    loggedIn = NO;
//    atStudentDirectory = NO;
//    visitedStudentsPage = NO;
//}

@end
