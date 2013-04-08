//
//  photoDetailViewController.h
//  S3Uploader
//
//  Created by Matthew on 3/16/13.
//  Copyright (c) 2013 dukecs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photoDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *imageLabel;
- (IBAction)shareImage:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationItem *titleBar;

@property (weak, nonatomic) NSString *imageName;

@end
