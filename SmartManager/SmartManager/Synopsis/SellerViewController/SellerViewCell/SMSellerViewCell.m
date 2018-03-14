//
//  SMSellerViewCell.m
//  Smart Manager
//
//  Created by Sandeep on 06/01/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMSellerViewCell.h"

@implementation SMSellerViewCell

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
