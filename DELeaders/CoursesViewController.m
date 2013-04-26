//
//  CoursesViewController.m
//  DELeaders
//
//  Created by guest user on 3/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CoursesViewController.h"
#import "Utility.h"

@implementation CoursesViewController

@synthesize topImage, bottomImage;
@synthesize scheduleButton, mpInfoButton, independentStudyButton, professionalDevelopmentButton;

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
    [self setScheduleButton:nil];
    [self setMpInfoButton:nil];
    [self setIndependentStudyButton:nil];
    [self setProfessionalDevelopmentButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)schedulePressed:(id)sender {
    [util openWebBrowser:@"https://sites.nicholas.duke.edu/delmeminfo/sample-page/semester-schedule/" viewController:self.navigationController];
}

- (IBAction)mpInfoPressed:(id)sender {
    [util openWebBrowser:@"http://sites.nicholas.duke.edu/delmeminfo/masters-project/" viewController:self.navigationController];
}

- (IBAction)independentStudyPressed:(id)sender {
    [util openWebBrowser:@"http://sites.nicholas.duke.edu/delmeminfo/sample-page/independent-study/" viewController:self.navigationController];
}

- (IBAction)professionalDevelopmentPressed:(id)sender {
    [util openWebBrowser:@"http://sites.nicholas.duke.edu/delmeminfo/student-resources/professional-development-fund/" viewController:self.navigationController];
}

- (void)changeToPortraitLayout {
    [topImage setImage:[UIImage imageNamed:@"top.png"]];
    [bottomImage setHidden:NO];
    if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 320, 80)];
        [scheduleButton setFrame:CGRectMake(30, 114, 260, 60)];
        [mpInfoButton setFrame:CGRectMake(30, 186, 260, 60)];
        [independentStudyButton setFrame:CGRectMake(30, 258, 260, 60)];
        [professionalDevelopmentButton setFrame:CGRectMake(30, 330, 260, 60)];
    } else if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 768, 192)];
        [scheduleButton setFrame:CGRectMake(154, 290, 460, 80)];
        [mpInfoButton setFrame:CGRectMake(154, 390, 460, 80)];
        [independentStudyButton setFrame:CGRectMake(154, 490, 460, 80)];
        [professionalDevelopmentButton setFrame:CGRectMake(154, 590, 460, 80)];
    } else {
        [topImage setFrame:CGRectMake(0, 0, 320, 80)];
        [scheduleButton setFrame:CGRectMake(30, 93, 260, 50)];
        [mpInfoButton setFrame:CGRectMake(30, 153, 260, 50)];
        [independentStudyButton setFrame:CGRectMake(30, 213, 260, 50)];
        [professionalDevelopmentButton setFrame:CGRectMake(30, 273, 260, 50)];
    }
}

- (void)changeToLandscapeLayout {
    if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 568, 30)];
        [scheduleButton setFrame:CGRectMake(154, 40, 260, 50)];
        [mpInfoButton setFrame:CGRectMake(154, 95, 260, 50)];
        [independentStudyButton setFrame:CGRectMake(154, 150, 260, 50)];
        [professionalDevelopmentButton setFrame:CGRectMake(154, 205, 260, 50)];
    } else if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 1024, 55)];
        [scheduleButton setFrame:CGRectMake(282, 184, 460, 80)];
        [mpInfoButton setFrame:CGRectMake(282, 284, 460, 80)];
        [independentStudyButton setFrame:CGRectMake(282, 384, 460, 80)];
        [professionalDevelopmentButton setFrame:CGRectMake(282, 484, 460, 80)];
    } else {
        [topImage setFrame:CGRectMake(0, 0, 480, 30)];
        [scheduleButton setFrame:CGRectMake(110, 42, 260, 45)];
        [mpInfoButton setFrame:CGRectMake(110, 97, 260, 45)];
        [independentStudyButton setFrame:CGRectMake(110, 152, 260, 45)];
        [professionalDevelopmentButton setFrame:CGRectMake(110, 207, 260, 45)];
    }
    [topImage setImage:[UIImage imageNamed:@"top_small.png"]];
    [bottomImage setHidden:YES];
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


@end
