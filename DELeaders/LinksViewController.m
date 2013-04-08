//
//  ViewController.m
//  DELeaders
//
//  Created by guest user on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "LinksViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "GeneralWebViewController.h"

@implementation LinksViewController

@synthesize delButton;
@synthesize nsoeButton;
@synthesize wpButton;
@synthesize calButton;
@synthesize coursesButton;
@synthesize sakaiButton;
@synthesize socialButton;
@synthesize imagesButton;
@synthesize libraryButton;
@synthesize contactsButton;
@synthesize acesButton;

@synthesize delLabel;
@synthesize nsoeLabel;
@synthesize wpLabel;
@synthesize calLabel;
@synthesize coursesLabel;
@synthesize sakaiLabel;
@synthesize socialLabel;
@synthesize imagesLabel;
@synthesize libraryLabel;
@synthesize contactsLabel;
@synthesize acesLabel;

@synthesize scrollView_iPad;
@synthesize linksView;
@synthesize dayLabel;
@synthesize dateNumLabel;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.    
    [self updateDateLabels];
    [scrollView_iPad setScrollEnabled:YES];
//    scrollView_iPad.backgroundColor = [UIColor cyanColor];
    
//    scrollView_iPad.backgroundColor = [UIColor cyanColor];
    // Detect orientations
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
}

- (void)viewDidUnload
{
    [self setDayLabel:nil];
    [self setDateNumLabel:nil];
    [self setLinksView:nil];
    [self setScrollView_iPad:nil];
    [self setDelButton:nil];
    [self setDelLabel:nil];
    [self setNsoeButton:nil];
    [self setWpButton:nil];
    [self setCalButton:nil];
    [self setCoursesButton:nil];
    [self setSakaiButton:nil];
    [self setSocialButton:nil];
    [self setImagesButton:nil];
    [self setLibraryButton:nil];
    [self setContactsButton:nil];
    [self setAcesButton:nil];
    [self setNsoeLabel:nil];
    [self setWpLabel:nil];
    [self setCalLabel:nil];
    [self setCoursesLabel:nil];
    [self setSakaiLabel:nil];
    [self setSocialLabel:nil];
    [self setImagesLabel:nil];
    [self setLibraryLabel:nil];
    [self setContactsLabel:nil];
    [self setAcesLabel:nil];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *identifier = segue.identifier;
    if([identifier hasPrefix:@"gen-"]){
        GeneralWebViewController *controller = (GeneralWebViewController *)segue.destinationViewController;
        if ([identifier isEqualToString:@"gen-DELSegue"]) {
            controller.myURL = @"http://www.nicholas.duke.edu/del/";
            controller.myTitle = @"DEL";
        } else if ([identifier isEqualToString:@"gen-NSOESegue"]) {
            controller.myURL = @"http://www.nicholas.duke.edu/";
            controller.myTitle = @"NSOE";
        } else if ([identifier isEqualToString:@"gen-WPSegue"]) {
            controller.myURL = @"https://sites.nicholas.duke.edu/delmeminfo/";
            controller.myTitle = @"Wordpress";
        } else if ([identifier isEqualToString:@"gen-LibrarySegue"]) {
            controller.myURL = @"https://library.duke.edu/";
            controller.myTitle = @"Duke Library";
        } else if ([identifier isEqualToString:@"gen-ACESSegue"]) {
            controller.myURL = @"https://aces.duke.edu/";
            controller.myTitle = @"Duke";
        }
    }
}

- (void)updateDateLabels {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEEE"];
    NSString *dayString = [formatter stringFromDate:now];
    NSLog(@"Current DAY: %@", dayString);
    dayLabel.text = dayString;
    [formatter setDateFormat:@"d"];
    NSString *dateString = [formatter stringFromDate:now];
    NSLog(@"Current DATE: %@", dateString);
    dateNumLabel.text = dateString;
    dateNumLabel.font = [UIFont fontWithName:dateNumLabel.font.fontName size:dateNumLabel.frame.size.height];
    
    
}

-(void)alertMessage:(NSString *)title text:(NSString *)text {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];
}

- (void)changeLayout:(UIDeviceOrientation *)orientation {
    [delButton setCenter:CGPointMake(63, 127)];
    [nsoeButton setCenter:CGPointMake(151, 127)];
    [wpButton setCenter:CGPointMake(239, 127)];
    [calButton setCenter:CGPointMake(327, 127)];
    [coursesButton setCenter:CGPointMake(415, 127)];
    [sakaiLabel setCenter:CGPointMake(503, 127)];
    
    [delLabel setCenter:CGPointMake(63, 162)];
    [nsoeLabel setCenter:CGPointMake(151, 162)];
    
    
}

- (void)orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            [scrollView_iPad setContentSize:CGSizeMake(0, 0)];

            break;
        case UIDeviceOrientationPortraitUpsideDown:
            [scrollView_iPad setContentSize:CGSizeMake(0, 0)];

            break;
        case UIDeviceOrientationLandscapeLeft:
            [scrollView_iPad setContentSize:CGSizeMake(1248, 1248)];
            scrollView_iPad.frame = CGRectMake(0, 196, 960, 768);
            
            break;
        case UIDeviceOrientationLandscapeRight:
            [scrollView_iPad setContentSize:CGSizeMake(1248, 1248)];
            scrollView_iPad.frame = CGRectMake(0, 196, 960, 768);
            break;
        default:
            break;
    };
}

@end
