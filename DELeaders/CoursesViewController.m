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
@synthesize detailsView;
@synthesize scheduleView;

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
    [util loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/sample-page/draft-syllabi/" :detailsView];
    [util loadWebView:@"https://sites.nicholas.duke.edu/delmeminfo/sample-page/semester-schedule/" :scheduleView];
}

- (void)viewDidUnload
{
    [self setDetailsView:nil];
    [self setScheduleView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
