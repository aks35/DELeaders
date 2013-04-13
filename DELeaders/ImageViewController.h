//
//  _LR4NFPD9GViewController.h
//  S3Uploader
//
//  Created by Matthew on 2/10/13.
//  Copyright (c) 2013 dukecs. All rights reserved.
//

#import <UIKit/UIKit.h>
//Constants

@interface ImageViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)Upload:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewForLoadingCircle;


@property (strong, nonatomic) IBOutlet UIView *viewForLoadingCircle2;
-(void) loadItemsIntoListOfItemsAndImagesIntoCompressedImages;


@end
