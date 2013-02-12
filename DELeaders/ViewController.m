//
//  ViewController.m
//  DELeaders
//
//  Created by guest user on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize sakaiCal;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSString *website = @"https://sakai.duke.edu/portal/tool/b35dc602-2461-4429-8cbf-863b48798f02?panel=Main";
    NSURL *url = [NSURL URLWithString:website];
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
    [sakaiCal loadRequest:requestUrl];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setSakaiCal:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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

- (IBAction)openDEL:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.nicholas.duke.edu/del/" ]];
}

- (IBAction)openNSE:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.nicholas.duke.edu/" ]];
}

- (IBAction)openWP:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://sites.nicholas.duke.edu/delmeminfo/" ]];
}

- (IBAction)openSakai:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://sakai.duke.edu/" ]];
}

- (IBAction)openLibrary:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://library.duke.edu/" ]];
}

- (IBAction)openACES:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://aces.duke.edu/" ]];
}

- (IBAction)openExecEd:(id)sender {
    // Put link for Exec Ed here
}

- (IBAction)openCal:(id)sender {
}
@end
