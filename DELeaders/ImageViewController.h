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
