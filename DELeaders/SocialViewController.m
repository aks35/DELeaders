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
@synthesize myTitle;

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
    self.navigationItem.title = myTitle;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *identifier = segue.identifier;
    NSLog(@"Identifier: %@", identifier);
    if([identifier hasPrefix:@"soc-"]){
        SocialViewController *controller = (SocialViewController *)segue.destinationViewController;
        if ([identifier isEqualToString:@"soc-FacebookSegue"]) {
            controller.myURL = @"https://www.facebook.com/DukeEnvironmentalLeadership";
            controller.myTitle = @"Facebook";
        } else if ([identifier isEqualToString:@"soc-TwitterSegue"]) {
            controller.myURL = @"https://twitter.com/DEL_Duke";
            controller.myTitle = @"Twitter";
        } else if ([identifier isEqualToString:@"soc-LinkedinSegue"]) {
            controller.myURL = @"http://www.linkedin.com/groups/Duke-Environmental-Leadership-Master-Environmental-1124597?home=&gid=1124597&trk=anet_ug_hm";
            controller.myTitle = @"Linkedin";
        }
    }
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
    [topImage setFrame:CGRectMake(0, 0, 320, 80)];
    [topImage setImage:[UIImage imageNamed:@"top.png"]];
    [bottomImage setHidden:NO];
    
    [facebookButton setFrame:CGRectMake(39, 120, 242, 60)];
    [twitterButton setFrame:CGRectMake(39, 223, 242, 60)];
    [linkedInButton setFrame:CGRectMake(39, 326, 242, 60)];
}

- (void)changeToLandscapeLayout {
    if ([util isFourInchScreen]) {
        [topImage setFrame:CGRectMake(0, 0, 568, 30)];
    } else {
        [topImage setFrame:CGRectMake(0, 0, 480, 30)];
    }
    [topImage setImage:[UIImage imageNamed:@"top_small.png"]];
    [bottomImage setHidden:YES];
    
    [facebookButton setFrame:CGRectMake(163, 44, 242, 60)];
    [twitterButton setFrame:CGRectMake(163, 115, 242, 60)];
    [linkedInButton setFrame:CGRectMake(163, 186, 242, 60)];
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
