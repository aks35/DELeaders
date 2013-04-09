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
@synthesize topImage;
@synthesize bottomImage;
@synthesize scrollView_iPad;
@synthesize linksView;
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

- (void)handleCurrentOrientation {
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        [topImage setFrame:CGRectMake(0, 0, 568, 30)];
        [topImage setImage:[UIImage imageNamed:@"top_small.png"]];
        [bottomImage setHidden:YES];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.    
    [self updateDateLabels];
    [scrollView_iPad setScrollEnabled:YES];
    
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
    
    util = [[Utility alloc]init];
    [util registerOrientationHandler:self];
   
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
    [self setTopImage:nil];
    [self setBottomImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

- (void)changeToPortraitLayout {
    [topImage setFrame:CGRectMake(0, 0, 320, 80)];
    [topImage setImage:[UIImage imageNamed:@"top.png"]];
    [bottomImage setHidden:NO];
    if ([util isFourInchScreen]) {
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
    } else {
        CGFloat xStart = 49;
        CGFloat yStart = 113;
        for (int i = 0; i < [buttonList count]; ++i) {
            [buttonList[i] setCenter:CGPointMake(xStart+((i%4)*74), yStart+((i/4)*81))];
        }
        [dayLabel setCenter:CGPointMake(271, 96)];
        [dateNumLabel setCenter:CGPointMake(271, 120)];
        yStart = 148;
        for (int i = 0; i < [labelList count]; ++i) {
            [labelList[i] setCenter:CGPointMake(xStart+((i%4)*74), yStart+((i/4)*82))];
        }
    }
}

- (void)changeToLandscapeLayout {
    if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 568, 30)];
    } else {
        [topImage setFrame:CGRectMake(0, 0, 480, 30)];
    }
    [topImage setImage:[UIImage imageNamed:@"top_small.png"]];
    [bottomImage setHidden:YES];
    
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
}

- (void)orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    [self.view setNeedsDisplay];
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            [self changeToPortraitLayout];
            NSLog(@"Orientation changed!!");

            [scrollView_iPad setContentSize:CGSizeMake(0, 0)];
            break;

        case UIDeviceOrientationLandscapeLeft:
            [self changeToLandscapeLayout];
            [scrollView_iPad setContentSize:CGSizeMake(1248, 1248)];
            scrollView_iPad.frame = CGRectMake(0, 196, 960, 768);
            break;
            
        case UIDeviceOrientationLandscapeRight:
            [self changeToLandscapeLayout];
            [scrollView_iPad setContentSize:CGSizeMake(1248, 1248)];
            scrollView_iPad.frame = CGRectMake(0, 196, 960, 768);
            break;
        default:
            break;
    };
}

@end
