//
//  photoDetailViewController.m
//  S3Uploader
//
//  Created by Matthew on 3/16/13.
//  Copyright (c) 2013 dukecs. All rights reserved.
//

#import "photoDetailViewController.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "AmazonClientManager.h"


@interface photoDetailViewController ()
@property (weak) IBOutlet UIImageView *imageView;

@end

@implementation photoDetailViewController
AmazonS3Client *s3;
UIImage *myImage;
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
    s3 = [AmazonClientManager s3];    

    
    
    S3GetObjectRequest* gor = [[S3GetObjectRequest alloc] initWithKey:self.imageName withBucket:@"delpictures"];
    S3GetObjectResponse* gore = [s3 getObject:gor];
    gore.contentType=@"image/jpeg";
    
    myImage= [[UIImage alloc] initWithData:gore.body];
    self.imageLabel.text=self.imageName;
    self.imageView.image=myImage;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)done:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)saveImageToPhone:(id)sender {
    UIImageWriteToSavedPhotosAlbum(myImage, nil, nil, nil);
}

- (IBAction)shareImage:(id)sender {
    NSArray *activityItems;
    
    activityItems = @[myImage];
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems
     applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
}

@end
