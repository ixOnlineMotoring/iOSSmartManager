//
//  SMExteriorReconditioningViewCell.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 11/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMExteriorReconditioningViewCell.h"

@implementation SMExteriorReconditioningViewCell

- (void)awakeFromNib
{
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
    }

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  
    // Configure the view for the selected state
}

@end
