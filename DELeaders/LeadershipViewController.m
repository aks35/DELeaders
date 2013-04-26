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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openFirstYear:(id)sender {
    [util openWebBrowser:@"http://sites.nicholas.duke.edu/delmeminfo/leadership/1st-year-leadership-readings-and-schedule/" viewController:self.navigationController];
}

- (IBAction)openSecondYear:(id)sender {
    [util openWebBrowser:@"http://sites.nicholas.duke.edu/delmeminfo/leadership/2nd-year-readings/" viewController:self.navigationController];
}
@end
