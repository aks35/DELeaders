/*
 Main page for the ImageApp.  It gets loaded up upon clicking on the Images icon from the main links page.  All the code necessary to run the main gallery view, all the links to other parts of the app, and the interfacing code between the S3 server and the app are located here.
 */

//
//  _LR4NFPD9GViewController.h
//  S3Uploader
//
//  Created by Matthew on 2/10/13.
//  Copyright (c) 2013 dukecs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)Upload:(id)sender;
-(void) loadItemsIntoListOfItemsAndImagesIntoCompressedImages;


@end
