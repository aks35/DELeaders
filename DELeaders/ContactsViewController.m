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

Utility *util;

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
    // Initialize Utility
    util = [[Utility alloc]init];
    // Register for orientation handler
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
    // Orientation handler method
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

@end
