

/**
 
 PhotoDetailViewController - This controller controls the photo detail view within the Image mini-application.  One gets to this view by clicking into the image app, then clicking on one of the photos within the main gallery view.  
 
 Created by Matthew on 3/16/13.
 Copyright (c) 2013 dukecs. All rights reserved.
 */

#import <UIKit/UIKit.h>

@interface photoDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *imageLabel;
- (IBAction)shareImage:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationItem *titleBar;

@property (weak, nonatomic) NSString *imageNameWithCompressedSuffix;

@end
