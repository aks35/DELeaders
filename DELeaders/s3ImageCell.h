/**
 s3ImageCell, a subclass of UICollectionViewCell, this class provides some simple modifications to the base UICollecvtionViewCell to allow for a photo to take up the space of the cell, to be displayed in the Image App's gallery view.
 
 */



//
//  s3ImageCell.h
//  S3Uploader
//
//  Created by Matthew on 3/6/13.
//  Copyright (c) 2013 dukecs. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * const PhotoCellIdentifier = @"simpleCellID";

@interface s3ImageCell : UICollectionViewCell
@property (nonatomic, strong, readonly) IBOutlet UIImageView *imageView;

@end
