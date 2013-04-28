/**
 s3ImageCell, a subclass of UICollectionViewCell, this class provides some simple modifications to the base UICollecvtionViewCell to allow for a photo to take up the space of the cell, to be displayed in the Image App's gallery view.
 
 */


//
//  s3ImageCell.m
//  S3Uploader
//
//  Created by Matthew on 3/6/13.
//  Copyright (c) 2013 dukecs. All rights reserved.
//

#import "s3ImageCell.h"
#import <QuartzCore/QuartzCore.h>
@interface s3ImageCell ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end
@implementation s3ImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.imageView];
    }
    
    
    
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image=nil;
    
}
@end
