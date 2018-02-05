//
//  SMAvailabilityViewCell.m
//  Smart Manager
//
//  Created by Sandeep on 04/01/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMAvailabilityViewCell.h"

@implementation SMAvailabilityViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
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
