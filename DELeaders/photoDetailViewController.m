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
#import "Constants.h"

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

    
    //first look for regular uncompressedImage
    NSString* imageNameWithoutCompressedSuffix = [self.imageNameWithCompressedSuffix substringToIndex:[self.imageNameWithCompressedSuffix length]- COMPRESSED_SUFFIX.length];
    S3GetObjectRequest* gor = [[S3GetObjectRequest alloc] initWithKey:imageNameWithoutCompressedSuffix withBucket:ORIGINAL_IMAGE_BUCKET_NAME];
    S3GetObjectResponse* gore = [s3 getObject:gor];
    gore.contentType=@"image/jpeg";
    self.titleBar.title=imageNameWithoutCompressedSuffix;
    myImage= [[UIImage alloc] initWithData:gore.body];
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


- (void)viewDidUnload {
    [self setTitleBar:nil];
    [super viewDidUnload];
}
@end
