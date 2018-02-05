//
//  SMReviewsTitleViewCell.m
//  Smart Manager
//
//  Created by Sandeep on 24/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMReviewsTitleViewCell.h"

@implementation SMReviewsTitleViewCell

- (void)awakeFromNib {
    // Initialization code
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
