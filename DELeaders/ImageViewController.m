//
//  _LR4NFPD9GViewController.m
//  S3Uploader
//
//  Created by Matthew on 2/10/13.
//  Copyright (c) 2013 dukecs. All rights reserved.
//

#import "ImageViewController.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "s3ImageCell.h"
#import "photoDetailViewController.h"
#import "AmazonClientManager.h"
#import "MBProgressHUD.h"
#import "Constants.h"


@implementation ImageViewController
AmazonS3Client *s3;
NSMutableArray *compressedImageNames;
NSMutableArray *compressedImages;
NSData *imageData;
NSData *compressedImageData;
S3Bucket *uncompressedImagesBucket;
S3Bucket *compressedImagesBucket;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.collectionView.backgroundColor = [UIColor blackColor]; //set background color to black
    [self.collectionView registerClass:[s3ImageCell class] forCellWithReuseIdentifier:@"simpleCellID"];
    s3 = [AmazonClientManager s3];
    NSArray *listOfBuckets = s3.listBuckets;
    
    
    //If the bucket does not exist, then create it.
    for(S3Bucket *bucket in listOfBuckets){
        if([[bucket name]isEqual:ORIGINAL_IMAGE_BUCKET_NAME]){
            uncompressedImagesBucket=bucket;
        }
    }
    // create the bucket if it does not yet exist
    if(uncompressedImagesBucket==nil){
        [s3 createBucket:[[S3CreateBucketRequest alloc] initWithName:ORIGINAL_IMAGE_BUCKET_NAME]];
    }
    
    
    //check for and if needed create the compressedBucket

    for(S3Bucket *bucket in listOfBuckets){
        if([[bucket name]isEqual:COMPRESSED_IMAGE_BUCKET_NAME]){
            compressedImagesBucket=bucket;
        }
    }
    // create the bucket if it does not yet exist
    if(compressedImagesBucket==nil){
        [s3 createBucket:[[S3CreateBucketRequest alloc] initWithName:COMPRESSED_IMAGE_BUCKET_NAME]];
    }
    
    self.loadItemsIntoListOfItemsAndImagesIntoCompressedImages;

    
        
}

-(void)loadItemsIntoListOfItemsAndImagesIntoCompressedImages{
    compressedImageNames = [[NSMutableArray alloc] init];
    NSArray * objectList = [s3 listObjectsInBucket:compressedImagesBucket.name];
    for(S3ObjectSummary* object in objectList){
        [compressedImageNames addObject:object.description];
    }
    
    
    compressedImages = [[NSMutableArray alloc] init];
    for (NSString* imageName in compressedImageNames) {
        S3GetObjectRequest* gor = [[S3GetObjectRequest alloc] initWithKey:imageName withBucket:COMPRESSED_IMAGE_BUCKET_NAME];
        S3GetObjectResponse* gore = [s3 getObject:gor];
        gore.contentType=@"image/jpeg";
        
        UIImage *compressedThumbnail = [[UIImage alloc] initWithData:gore.body];
        [compressedImages addObject:compressedThumbnail];
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *myImage = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    imageData = [NSData dataWithData:UIImageJPEGRepresentation(myImage, 1.0)];
    
    
    
    CGFloat scaleToWidth = COMPRESSED_IMAGE_WIDTH;
    CGFloat scaleFactor = scaleToWidth/myImage.size.width;
    CGFloat scaledWidth = myImage.size.width*scaleFactor;
    CGFloat scaledHeight = myImage.size.height*scaleFactor;
    
    CGSize newSize = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(newSize);
    [myImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    compressedImageData = [NSData dataWithData:UIImageJPEGRepresentation(newImage, 1.0)];
    
    //show an alert window to input the image name
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Name Your Image" message:@"" delegate:self cancelButtonTitle:@"Upload" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag=1;
    [alert show];


    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //if we are returning from the alertview for giving an uploaded image a name
    if(alertView.tag==1){
        //upload the original image
        NSString* keyName = [[alertView textFieldAtIndex:0] text];
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:keyName inBucket:ORIGINAL_IMAGE_BUCKET_NAME];
        por.contentType = @"image/jpeg";
        por.data = imageData;
        [s3 putObject:por];
        
        //upload the compressed image
        NSString* compressedKeyName = [keyName stringByAppendingString:COMPRESSED_SUFFIX ];
        S3PutObjectRequest *porCompressed = [[S3PutObjectRequest alloc] initWithKey:compressedKeyName inBucket:COMPRESSED_IMAGE_BUCKET_NAME];
        porCompressed.contentType = @"image/jpeg";
        porCompressed.data = compressedImageData;
        [s3 putObject:porCompressed];
        
        

        //reload compressedImages
        self.loadItemsIntoListOfItemsAndImagesIntoCompressedImages;
        [self.collectionView reloadData];
    }
    //if we are returning from the alertview for selecting Camera upload vs. image picker upload
    if(alertView.tag==2){
        NSLog(@"clicked button: %d", buttonIndex);
        //upload from camera
        if(buttonIndex==1){
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentModalViewController:imagePicker animated:YES];
        }
        //upload from gallery
        else if(buttonIndex==2){
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            [self presentModalViewController:imagePicker animated:YES];
        }

    }
    
    
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    hud.labelText = @"Loading Image";
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString* imageName = [compressedImageNames objectAtIndex:indexPath.row];
        
        
        [self performSegueWithIdentifier:@"ShowPhoto"
                                  sender:imageName];
        [self.collectionView
         deselectItemAtIndexPath:indexPath animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });


    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        photoDetailViewController *PhotoViewController = segue.destinationViewController;
        PhotoViewController.imageNameWithCompressedSuffix = sender;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    return [compressedImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString* MyCellID = @"simpleCellID";
    UIImage *compressedThumbnail = [compressedImages objectAtIndex:indexPath.row];
    s3ImageCell* newCell = [collectionView dequeueReusableCellWithReuseIdentifier:MyCellID
                                                                           forIndexPath:indexPath];

    newCell.imageView.image = compressedThumbnail;
    return newCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    UIImage *compressedThumbnail = [compressedImages objectAtIndex:indexPath.row];


    CGFloat scaleToWidth = COMPRESSED_IMAGE_DISPLAY_WIDTH;
    CGFloat scaleFactor = scaleToWidth/compressedThumbnail.size.width;
    CGFloat scaledWidth = compressedThumbnail.size.width*scaleFactor;
    CGFloat scaledHeight = compressedThumbnail.size.height*scaleFactor;
    
    
    
    CGSize retval = compressedThumbnail.size.width > 0 ? CGSizeMake(scaledWidth,scaledHeight) : CGSizeMake(scaledWidth, scaledHeight);
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (IBAction)Upload:(id)sender {
    //show an alertview Window to choose whether to select from the phone's gallery or from camera
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Upload From:" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    alert.tag=2;
    [alert addButtonWithTitle:@"Camera"];
    [alert addButtonWithTitle:@"Gallery"];
    [alert show];
    
    

}

     - (void)viewDidUnload {
         [super viewDidUnload];
     }
@end
