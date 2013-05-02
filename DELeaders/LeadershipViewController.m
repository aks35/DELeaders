//
//  LeadershipViewController.m
//  DELeaders
//
//  Created by anshim on 4/25/13.
//
//

#import "LeadershipViewController.h"
#import "Utility.h"

@interface LeadershipViewController ()

@end

@implementation LeadershipViewController

@synthesize topImage;
@synthesize bottomImage;
@synthesize firstButton;
@synthesize secondButton;

Utility *util;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    util = [[Utility alloc]init];
    [util registerOrientationHandler:self];
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        [self changeToPortraitLayout];
    } else if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        [self changeToLandscapeLayout];
    }
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Button actions
- (IBAction)openFirstYear:(id)sender {
    NSString *url = @"http://sites.nicholas.duke.edu/delmeminfo/leadership/1st-year-leadership-readings-and-schedule/";
    if ([util loggedIntoWordpress]) {
        [util openWebBrowser:url navController:self.navigationController];
    } else {
        [util loginToWordpress:self url:url];
    }
}

- (IBAction)openSecondYear:(id)sender {
    NSString *url = @"http://sites.nicholas.duke.edu/delmeminfo/leadership/2nd-year-readings/";
    if ([util loggedIntoWordpress]) {
        [util openWebBrowser:url navController:self.navigationController];
    } else {
        [util loginToWordpress:self url:url];
    }
}

- (void)changeToPortraitLayout {
    [topImage setImage:[UIImage imageNamed:@"top.png"]];
    [bottomImage setHidden:NO];
    if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 768, 192)];
        [firstButton setFrame:CGRectMake(154, 360, 460, 80)];
        [secondButton setFrame:CGRectMake(154, 480, 460, 80)];
    } else {
        [topImage setFrame:CGRectMake(0, 0, 320, 80)];
        if ([util isFourInchScreen]) {
            [firstButton setFrame:CGRectMake(30, 179, 260, 60)];
            [secondButton setFrame:CGRectMake(30, 266, 260, 60)];
        } else {
            [firstButton setFrame:CGRectMake(30, 139, 260, 60)];
            [secondButton setFrame:CGRectMake(30, 218, 260, 60)];
        }
    }
}

- (void)changeToLandscapeLayout {
    [topImage setImage:[UIImage imageNamed:@"top_small.png"]];
    [bottomImage setHidden:YES];
    if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 1024, 55)];
        [firstButton setFrame:CGRectMake(282, 274, 460, 80)];
        [secondButton setFrame:CGRectMake(282, 394, 460, 80)];
    } else if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 568, 30)];
        [firstButton setFrame:CGRectMake(154, 77, 260, 60)];
        [secondButton setFrame:CGRectMake(154, 164, 260, 60)];
    } else {
        [topImage setFrame:CGRectMake(0, 0, 480, 30)];
        [firstButton setFrame:CGRectMake(110, 81, 260, 60)];
        [secondButton setFrame:CGRectMake(110, 160, 260, 60)];
    }
}

- (void)orientationChanged:(NSNotification *)note
{
    // Orientation event handler
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
