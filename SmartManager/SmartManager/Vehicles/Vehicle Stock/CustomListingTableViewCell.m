//
//  CustomListingTableViewCell.m
//  viewAdjust
//
//  Created by Ankit Shrivastava on 09/12/15.
//  Copyright (c) 2015 Ankit Shrivastava. All rights reserved.
//

#import "CustomListingTableViewCell.h"

@implementation CustomListingTableViewCell
/*
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];

    // labelsCollection is an IBOutletCollection of my UILabel sublasses
//            self.lblDetailFirst.preferredMaxLayoutWidth =   self.lblDetailFirst.bounds.size.width;
//            self.lblDetailSecond.preferredMaxLayoutWidth =   self.lblDetailSecond.bounds.size.width;
//            self.lblDetailThird.preferredMaxLayoutWidth =   self.lblDetailThird.bounds.size.width;
//            self.lblDetailFourth.preferredMaxLayoutWidth =   self.lblDetailFourth.bounds.size.width;
   
  

    }
*/
- (void)awakeFromNib {
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
