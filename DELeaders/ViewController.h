//
//  ViewController.h
//  DELeaders
//
//  Created by guest user on 2/5/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)openDEL:(id)sender;
- (IBAction)openNSE:(id)sender;
- (IBAction)openWP:(id)sender;
- (IBAction)openSakai:(id)sender;
- (IBAction)openLibrary:(id)sender;
- (IBAction)openACES:(id)sender;
- (IBAction)openExecEd:(id)sender;
- (IBAction)openCal:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *sakaiCal;

@end
