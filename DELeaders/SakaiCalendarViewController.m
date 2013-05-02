//
//  SakaiCalendarViewController.m
//  DELeaders
//
//  Created by guest user on 3/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SakaiCalendarViewController.h"
#import "Utility.h"
#import "SakaiViewControllerHelper.h"
#import "MBProgressHUD.h"

@implementation SakaiCalendarViewController

@synthesize svWebController, svWebViewMain, svWebViewLoad, svWebViewTemp;
@synthesize needToFillOutForm;

//MBProgressHUD *webHud;
SakaiViewControllerHelper *helperController;
Utility *util;
bool calendarDone, atLogin, inCalendar, calendarRendered, atRedirect, loggedIntoSakai, loginFormSubmitted, inWorkspace;
bool loggedInApriori = YES;


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

- (IBAction)homePressed:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)goToPageTemplate:(NSString *)index {
    // Template method to click links
    NSString *javascript = @"var str;var links = document.getElementsByTagName('a');for(var i=0; i<links.length; ++i){if(links[i].innerHTML.indexOf('%@')!==-1){str=links[i].href;break;}}str;";
    javascript = [NSString stringWithFormat:javascript, index];
    NSString *result = [svWebViewMain stringByEvaluatingJavaScriptFromString:javascript];
    NSLog(@"JAVASCRIPT: %@", javascript);
    NSLog(@"RESULT BUZZ: %@", result);
    [util loadWebView:result webView:svWebViewMain];
    if ([index isEqualToString:@"Calendar"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:result forKey:calendarUrlKey];
        NSLog(@"Calendar URL: %@", result);
        calendarRendered = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)goToWorkspacePage {
    helperController.inWorkspace = YES;
    [self goToPageTemplate:@"Workspace"];
}

- (void)goToCalendarPage {
    inCalendar = YES;
    [self goToPageTemplate:@"Calendar"];
}

- (void)backWasClicked {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (BOOL)autoLoginToSakai:(UIWebView *)webView {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIntoSakai"]) {
        if (!inCalendar) {
            if ([helperController inWorkspace]) {
                [self goToCalendarPage];
            } else {
                [self goToWorkspacePage];
            }            
        }
    }
    else if (calendarDone) {
        return NO;
    }
    else if (calendarRendered && !loggedInApriori) {
        [MBProgressHUD hideHUDForView:svWebViewLoad animated:YES];
        [svWebController enableBackButton];
        [svWebViewLoad setHidden:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loggedIntoSakai"];
        calendarDone = YES;
        [svWebViewLoad removeFromSuperview];
        [svWebViewTemp removeFromSuperview];
        [svWebViewMain setHidden:NO];
        [svWebController enableTitleControl];
        return NO;
    }
    else if (loggedIntoSakai) {
        if (loggedInApriori) {
            loggedInApriori = NO;
            [self goToWorkspacePage];
        }
        else if (helperController.inWorkspace) {
            [self goToCalendarPage];
            helperController.inWorkspace = NO;
            if (needToFillOutForm) {
                [svWebViewMain setHidden:NO];                
            }
        } else {
            [self goToWorkspacePage];
            if ([_hud.labelText length] != 0 && !inCalendar) {
            } else {
                [self.view bringSubviewToFront:svWebViewMain];
            }
        }
    }
    else if (atRedirect) {
        loggedIntoSakai = YES;
        if (!needToFillOutForm) {
            [self goToWorkspacePage];
        }
    }
    else if (loginFormSubmitted) {
        if (needToFillOutForm) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *netID = [defaults objectForKey:@"netId"];
            NSString *password = [defaults objectForKey:@"password"];
            [helperController fillSakaiSubViewForm:svWebViewMain netID:netID password:password];
        } 
        atRedirect = YES;
    }
    else if (atLogin) {
        NSString *href = [helperController clickLoginLink:svWebViewMain tempWebView:svWebViewMain];
        NSLog(@"HREF %@",href);
        if (![href isEqualToString:helperController.NO_LINK_TAG]) {
            [util loadWebView:href webView:svWebViewMain];
            loginFormSubmitted = YES;
            loggedInApriori = NO;
        }
    }
    else if (!loggedIntoSakai) {
        [svWebViewLoad setHidden:NO];
        _hud = [MBProgressHUD showHUDAddedTo:svWebViewLoad animated:YES];
        _hud.labelText = @"Logging into Sakai";
        [svWebController disableBackButton];
        NSString *linkExists = [svWebViewMain stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('loginLink')[0]==null;"];
        
        NSLog(@"%@", linkExists);
        if ([linkExists isEqualToString:@"false"]) {
            [util loadWebView:@"https://sakai.duke.edu/portal/pda/?force.login=yes" webView:svWebViewMain];
            atLogin = YES;
        }
    }
    else {
        NSString *href = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.documentURI;"]];
        NSLog(@"NOTHING FINISHED: %@", href);
    }
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)sakaiWebViewDidFinishLoad:(UIWebView *)webView {
    // Auto login logic
    if ([util userLoggedIn]) {
        return [self autoLoginToSakai:webView];
    } else {
        [svWebViewLoad removeFromSuperview];
        [svWebViewTemp removeFromSuperview];
        [svWebViewMain setHidden:NO];
        return NO;
    }
}

- (void)registerSVWebController:(SVWebViewController *)webController {
    // Register SV controller for necessary communication
    svWebController = webController;
    [svWebController setTitle:@"Calendar"];
    [svWebController disableTitleControl];
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        svWebViewLoad = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
    } else if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        svWebViewLoad = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.height, svWebController.view.frame.size.width)];
    }
    svWebViewMain = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
    svWebViewTemp = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, svWebController.view.frame.size.width, svWebController.view.frame.size.height)];
    
    [svWebViewMain setHidden:YES];
    [svWebViewLoad setHidden:YES];
    [svWebViewTemp setHidden:YES];
    
    [svWebViewMain setDelegate:svWebController];
    [svWebViewTemp setDelegate:svWebController];

    [webController.view addSubview:svWebViewMain];
    [webController.view addSubview:svWebViewTemp];
    [webController.view addSubview:svWebViewLoad];
    
    svWebViewMain.scalesPageToFit = YES;
    svWebViewMain.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [webController setMainView:svWebViewMain];
    
    util = [[Utility alloc]init];
    [util loadWebView:@"https://sakai.duke.edu/portal/pda" webView:svWebViewMain];
    helperController = [[SakaiViewControllerHelper alloc]init];
}

- (void)reset {
//    self.needToFillOutForm = YES;
    self.svWebController = nil;
    self.svWebViewMain = nil;
    self.svWebViewTemp = nil;
    self.svWebViewLoad = nil;
    
    calendarDone = NO;
    atLogin = NO;
    inCalendar = NO;
    calendarRendered = NO;
    atRedirect = NO;
    loggedIntoSakai = NO;
    loginFormSubmitted = NO;
    inWorkspace = NO;
    loggedInApriori = YES;
}

@end
