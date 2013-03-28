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
    [util loadWebView:myURL webView:myWebView];
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
            controller.myURL = @"http://www.linkedin.com/groups/Duke-Environmental-Leadership-Master-Environmental-1124597?gid=1124597&trk=hb_side_g";
            controller.myTitle = @"Linkedin";
        }
    }
}

- (IBAction)openFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/" ]];
}

- (IBAction)openTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/" ]];
}

- (IBAction)openLinkedIn:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.linkedin.com/" ]];
}   

- (void)viewDidUnload {
    [self setMyWebView:nil];
    [super viewDidUnload];
}
@end
