//
//  SMCustomSavedVINTableViewCell.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 19/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomSavedVINTableViewCell.h"

@implementation SMCustomSavedVINTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    
    // labelsCollection is an IBOutletCollection of my UILabel sublasses
    self.lblName.preferredMaxLayoutWidth = self.lblName.bounds.size.width;
    self.lblTime.preferredMaxLayoutWidth = self.lblTime.bounds.size.width;
    
    // self.lblMessageTime.preferredMaxLayoutWidth =   self.lblMessageTime.bounds.size.width;
    
    
}
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
