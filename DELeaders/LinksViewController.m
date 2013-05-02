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
#import "SakaiCalendarViewController.h"
#import "MBProgressHUD.h"

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
@synthesize leadershipButton;

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
@synthesize leadershipLabel;
@synthesize topImage;
@synthesize bottomImage;
@synthesize dayLabel;
@synthesize dateNumLabel;

NSMutableArray *buttonList;
NSMutableArray *labelList;
Utility *util;

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
    
    // Add buttons and labels to lists for easier access
    buttonList = [[NSMutableArray alloc]init];
    [buttonList addObject:delButton];
    [buttonList addObject:nsoeButton];
    [buttonList addObject:wpButton];
    [buttonList addObject:calButton];
    [buttonList addObject:coursesButton];
    [buttonList addObject:sakaiButton];
    [buttonList addObject:socialButton];
    [buttonList addObject:imagesButton];
    [buttonList addObject:libraryButton];
    [buttonList addObject:contactsButton];
    [buttonList addObject:acesButton];
    [buttonList addObject:leadershipButton];
    
    labelList = [[NSMutableArray alloc]init];
    [labelList addObject:delLabel];
    [labelList addObject:nsoeLabel];
    [labelList addObject:wpLabel];
    [labelList addObject:calLabel];
    [labelList addObject:coursesLabel];
    [labelList addObject:sakaiLabel];
    [labelList addObject:socialLabel];
    [labelList addObject:imagesLabel];
    [labelList addObject:libraryLabel];
    [labelList addObject:contactsLabel];
    [labelList addObject:acesLabel];
    [labelList addObject:leadershipLabel];
    
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
    [self setDayLabel:nil];
    [self setDateNumLabel:nil];
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
    [self setTopImage:nil];
    [self setBottomImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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

- (void)updateDateLabels {
    // Time label updates for calendar
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEEE"];
    NSString *dayString = [formatter stringFromDate:now];
    dayLabel.text = dayString;
    dayLabel.font = [UIFont fontWithName:dayLabel.font.fontName size:dayLabel.frame.size.height/1.4];
    [formatter setDateFormat:@"d"];
    NSString *dateString = [formatter stringFromDate:now];
    dateNumLabel.text = dateString;
    dateNumLabel.font = [UIFont fontWithName:dateNumLabel.font.fontName size:dateNumLabel.frame.size.height-(dateNumLabel.frame.size.height/7)];
}

-(void)alertMessage:(NSString *)title text:(NSString *)text {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];
}

- (void)changeToPortraitLayout {
    [topImage setImage:[UIImage imageNamed:@"top.png"]];
    [bottomImage setHidden:NO];
    if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 320, 80)];
        CGFloat xStart = 49;
        CGFloat yStart = 145;
        for (int i = 0; i < [buttonList count]; ++i) {
            [buttonList[i] setCenter:CGPointMake(xStart+((i%4)*74), yStart+((i/4)*96))];
        }
        [dayLabel setCenter:CGPointMake(271, 128)];
        [dateNumLabel setCenter:CGPointMake(271, 152)];
        yStart = 180;
        for (int i = 0; i < [labelList count]; ++i) {
            [labelList[i] setCenter:CGPointMake(xStart+((i%4)*74), yStart+((i/4)*96))];
        }
    } else if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 768, 192)];
        CGFloat xStart = 123;
        CGFloat yStart = 291;
        for (int i = 0; i < [buttonList count]; ++i) {
            [buttonList[i] setCenter:CGPointMake(xStart+((i%4)*174), yStart+((i/4)*178))];
        }
        [dayLabel setCenter:CGPointMake(645, 250)];
        [dateNumLabel setCenter:CGPointMake(645, 305)];
        yStart = 364;
        for (int i = 0; i < [labelList count]; ++i) {
            [labelList[i] setCenter:CGPointMake(xStart+((i%4)*174), yStart+((i/4)*178))];
        }
    } else {
        [topImage setFrame:CGRectMake(0, 0, 320, 80)];
        CGFloat xStart = 49;
        CGFloat yStart = 116;
        for (int i = 0; i < [buttonList count]; ++i) {
            [buttonList[i] setCenter:CGPointMake(xStart+((i%4)*74), yStart+((i/4)*81))];
        }
        [dayLabel setCenter:CGPointMake(271, 99)];
        [dateNumLabel setCenter:CGPointMake(271, 123)];
        yStart = 151;
        for (int i = 0; i < [labelList count]; ++i) {
            [labelList[i] setCenter:CGPointMake(xStart+((i%4)*74), yStart+((i/4)*82))];
        }
    }
}

- (void)changeToLandscapeLayout {
    if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 568, 30)];
        CGFloat xStart = 63;
        CGFloat yStart = 83;
        for (int i = 0; i < [buttonList count]; ++i) {
            [buttonList[i] setCenter:CGPointMake(xStart+((i%6)*88), yStart+((i/6)*84))];
        }
        [dayLabel setCenter:CGPointMake(327, 66)];
        [dateNumLabel setCenter:CGPointMake(327, 90)];
        yStart = 118;
        for (int i = 0; i < [labelList count]; ++i) {
            [labelList[i] setCenter:CGPointMake(xStart+((i%6)*88), yStart+((i/6)*84))];
        }
    } else if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 1024, 55)];
        CGFloat xStart = 251;
        CGFloat yStart = 184;
        for (int i = 0; i < [buttonList count]; ++i) {
            [buttonList[i] setCenter:CGPointMake(xStart+((i%4)*174), yStart+((i/4)*178))];
        }
        [dayLabel setCenter:CGPointMake(773, 144)];
        [dateNumLabel setCenter:CGPointMake(773, 199)];
        yStart = 257;
        for (int i = 0; i < [labelList count]; ++i) {
            [labelList[i] setCenter:CGPointMake(xStart+((i%4)*174), yStart+((i/4)*178))];
        }
    } else {
        [topImage setFrame:CGRectMake(0, 0, 480, 30)];
        CGFloat xStart = 53;
        CGFloat yStart = 85;
        for (int i = 0; i < [buttonList count]; ++i) {
            [buttonList[i] setCenter:CGPointMake(xStart+((i%6)*75), yStart+((i/6)*90))];
        }
        [dayLabel setCenter:CGPointMake(278, 67)];
        [dateNumLabel setCenter:CGPointMake(278, 91)];
        yStart = 119;
        for (int i = 0; i < [labelList count]; ++i) {
            [labelList[i] setCenter:CGPointMake(xStart+((i%6)*75), yStart+((i/6)*90))];
        }
    }
    [topImage setImage:[UIImage imageNamed:@"top_small.png"]];
    [bottomImage setHidden:YES];
}

- (void)orientationChanged:(NSNotification *)note
{
    // Orientation even handler
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

// Button actions
- (IBAction)calPressed:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIntoSakai"]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:calendarUrlKey]) {
            [util openWebBrowser:[[NSUserDefaults standardUserDefaults] objectForKey:calendarUrlKey] navController:self.navigationController];
            NSLog(@"Calendar URL: %@", [[NSUserDefaults standardUserDefaults] objectForKey:calendarUrlKey]);
        } else {
            [util openWebBrowserSakaiCal:self.navigationController needToFillOutForm:NO];            
        }
    } else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIntoWordPress"]) {
//        [util openWebBrowserSakaiCal:self.navigationController needToFillOutForm:NO];
        [util loginToSakai:self goToCal:YES];
    } else {
        [util loginToSakai:self goToCal:YES];
    }
}

- (IBAction)sakaiPressed:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loggedIntoSakai"]) {
        [util openWebBrowser:@"https://sakai.duke.edu/portal/pda/?force.login=yes" navController:self.navigationController];
    } else {
        [util loginToSakai:self goToCal:NO];
    }
}

- (IBAction)delPressed:(id)sender {
    [util openWebBrowser:@"http://www.nicholas.duke.edu/del/" navController:self.navigationController];
}

- (IBAction)nsoePressed:(id)sender {
    [util openWebBrowser:@"http://www.nicholas.duke.edu/" navController:self.navigationController];
}

- (IBAction)wpPressed:(id)sender {
    [util openWebBrowser:@"https://sites.nicholas.duke.edu/delmeminfo/" navController:self.navigationController];
}

- (IBAction)libraryPressed:(id)sender {
    [util openWebBrowser:@"https://library.duke.edu/" navController:self.navigationController];
}

- (IBAction)acesPressed:(id)sender {
    [util openWebBrowser:@"https://aces.duke.edu/" navController:self.navigationController];
}

- (IBAction)logoutPressed:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"clickedLogout"];
    [util logout:self];
}
@end
