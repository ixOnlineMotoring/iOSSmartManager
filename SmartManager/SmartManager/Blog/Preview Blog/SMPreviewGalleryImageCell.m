//
//  SMPreviewGalleryImageCell.m
//  SmartManager
//
//  Created by Liji Stephen on 29/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMPreviewGalleryImageCell.h"

@implementation SMPreviewGalleryImageCell

- (void)awakeFromNib
{
    // Initialization code
    
     self.layer.affineTransform=CGAffineTransformMakeRotation(M_PI_2);
    //self.backgroundColor = [UIColor greenColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
