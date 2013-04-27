//
//  SocialViewController.m
//  DELeaders
//
//  Created by anshim on 3/24/13.
//
//

#import "SocialViewController.h"
#import "Utility.h"

@interface SocialViewController ()

@end

@implementation SocialViewController

@synthesize myWebView;
@synthesize myURL;

@synthesize facebookButton;
@synthesize twitterButton;
@synthesize linkedInButton;
@synthesize topImage;
@synthesize bottomImage;

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
    [myWebView setDelegate:self];
    util = [[Utility alloc]init];
    [util registerOrientationHandler:self];
    [util loadWebView:myURL webView:myWebView];
    myWebView.scalesPageToFit = YES;
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        [self changeToPortraitLayout];
    } else if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        [self changeToLandscapeLayout];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyWebView:nil];
    [self setFacebookButton:nil];
    [self setTwitterButton:nil];
    [self setLinkedInButton:nil];
    [self setTopImage:nil];
    [self setBottomImage:nil];
    [super viewDidUnload];
}

- (void)changeToPortraitLayout {
    [topImage setImage:[UIImage imageNamed:@"top.png"]];
    [bottomImage setHidden:NO];
    if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 768, 192)];
        [facebookButton setFrame:CGRectMake(154, 320, 460, 80)];
        [twitterButton setFrame:CGRectMake(154, 420, 460, 80)];
        [linkedInButton setFrame:CGRectMake(154, 520, 460, 80)];
    } else {
        [topImage setFrame:CGRectMake(0, 0, 320, 80)];
        if ([util isFourInchScreen]) {
            [facebookButton setFrame:CGRectMake(30, 142, 260, 60)];
            [twitterButton setFrame:CGRectMake(30, 222, 260, 60)];
            [linkedInButton setFrame:CGRectMake(30, 302, 260, 60)];
        } else {
            [facebookButton setFrame:CGRectMake(30, 104, 260, 56)];
            [twitterButton setFrame:CGRectMake(30, 178, 260, 56)];
            [linkedInButton setFrame:CGRectMake(30, 252, 260, 56)];
        }
    }

}

- (void)changeToLandscapeLayout {
    if ([util isPad]) {
        [topImage setFrame:CGRectMake(0, 0, 1024, 55)];
        [facebookButton setFrame:CGRectMake(282, 190, 460, 80)];
        [twitterButton setFrame:CGRectMake(282, 290, 460, 80)];
        [linkedInButton setFrame:CGRectMake(282, 390, 460, 80)];
    } else if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 568, 30)];
        [facebookButton setFrame:CGRectMake(163, 44, 242, 60)];
        [twitterButton setFrame:CGRectMake(163, 115, 242, 60)];
        [linkedInButton setFrame:CGRectMake(163, 186, 242, 60)];
    } else {
        [topImage setFrame:CGRectMake(0, 0, 480, 30)];
        [facebookButton setFrame:CGRectMake(119, 46, 242, 56)];
        [twitterButton setFrame:CGRectMake(119, 120, 242, 56)];
        [linkedInButton setFrame:CGRectMake(119, 192, 242, 56)];
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


- (IBAction)facebookPressed:(id)sender {
    [util openWebBrowser:@"https://www.facebook.com/DukeEnvironmentalLeadership" navController:self.navigationController];
}

- (IBAction)twitterPressed:(id)sender {
    [util openWebBrowser:@"https://twitter.com/DEL_Duke" navController:self.navigationController];
}

- (IBAction)linkedInPressed:(id)sender {
    [util openWebBrowser:@"http://www.linkedin.com/groups/Duke-Environmental-Leadership-Master-Environmental-1124597?home=&gid=1124597&trk=anet_ug_hm" navController:self.navigationController];
}

@end
