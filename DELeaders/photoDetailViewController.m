

/**
 
 PhotoDetailViewController - This controller controls the photo detail view within the Image mini-application.  One gets to this view by clicking into the image app, then clicking on one of the photos within the main gallery view.
 
 Created by Matthew on 3/16/13.
 Copyright (c) 2013 dukecs. All rights reserved.
 */

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


//Called upon the page loading
- (void)viewDidLoad
{
    [super viewDidLoad];
    s3 = [AmazonClientManager s3];    

    NSMutableArray *listOfItemsInUncompressedBucket = [[NSMutableArray alloc] init];
    for(S3ObjectSummary* object in [s3 listObjectsInBucket:ORIGINAL_IMAGE_BUCKET_NAME]){
        [listOfItemsInUncompressedBucket addObject:object.description];
    }
    
    
    
    //first look for regular uncompressedImage
    NSString* imageNameWithoutCompressedSuffix = [self.imageNameWithCompressedSuffix substringToIndex:[self.imageNameWithCompressedSuffix length]- COMPRESSED_SUFFIX.length];
    if([listOfItemsInUncompressedBucket containsObject:(imageNameWithoutCompressedSuffix)]){
        S3GetObjectRequest* gor = [[S3GetObjectRequest alloc] initWithKey:imageNameWithoutCompressedSuffix withBucket:ORIGINAL_IMAGE_BUCKET_NAME];
        S3GetObjectResponse* gore = [s3 getObject:gor];
        gore.contentType=@"image/jpeg";
        self.titleBar.title=imageNameWithoutCompressedSuffix;
        myImage= [[UIImage alloc] initWithData:gore.body];
        self.imageView.image=myImage;
    }
    //just use the compressed image
    else{
        S3GetObjectRequest* gor = [[S3GetObjectRequest alloc] initWithKey:_imageNameWithCompressedSuffix withBucket:COMPRESSED_IMAGE_BUCKET_NAME];
        S3GetObjectResponse* gore = [s3 getObject:gor];
        gore.contentType=@"image/jpeg";
        self.titleBar.title=imageNameWithoutCompressedSuffix;
        myImage= [[UIImage alloc] initWithData:gore.body];
        self.imageView.image=myImage;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//called when the "share" button is clicked.  This will utilize Apple's UIActivityViewController interface to automatically determine what apps are installed that can benefit from sharing a photo
- (IBAction)shareImage:(id)sender {
    NSArray *activityItems;
    activityItems = @[myImage];
    
    //invoke apple's UIActivityViewController which figures out what type of item it is being given, and automatically generates other iOS applications to share with, in this case, sharing images with mail, camera roll, messenger, etc.
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
