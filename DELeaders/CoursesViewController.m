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
@synthesize detailsButton, scheduleButton;

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
    [self setDetailsButton:nil];
    [self setScheduleButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)detailsPressed:(id)sender {
    [util openWebBrowser:@"https://sites.nicholas.duke.edu/delmeminfo/sample-page/draft-syllabi/" viewController:self.navigationController];
}

- (IBAction)schedulePressed:(id)sender {
    [util openWebBrowser:@"https://sites.nicholas.duke.edu/delmeminfo/sample-page/semester-schedule/" viewController:self.navigationController];
}

- (void)changeToPortraitLayout {
    [topImage setImage:[UIImage imageNamed:@"top.png"]];
    [bottomImage setHidden:NO];
    if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 320, 80)];
        [detailsButton setFrame:CGRectMake(30, 179, 260, 60)];
        [scheduleButton setFrame:CGRectMake(30, 266, 260, 60)];
    } else if ([util isPad]) {

    } else {
        [topImage setFrame:CGRectMake(0, 0, 320, 80)];
        [detailsButton setFrame:CGRectMake(30, 139, 260, 60)];
        [scheduleButton setFrame:CGRectMake(30, 218, 260, 60)];
    }
}

- (void)changeToLandscapeLayout {
    if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 568, 30)];
        [detailsButton setFrame:CGRectMake(154, 77, 260, 60)];
        [scheduleButton setFrame:CGRectMake(154, 164, 260, 60)];

    } else if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 1024, 55)];

    } else {
        [topImage setFrame:CGRectMake(0, 0, 480, 30)];
        [detailsButton setFrame:CGRectMake(110, 81, 260, 60)];
        [scheduleButton setFrame:CGRectMake(110, 160, 260, 60)];
    }
    [topImage setImage:[UIImage imageNamed:@"top_small.png"]];
    [bottomImage setHidden:YES];
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
