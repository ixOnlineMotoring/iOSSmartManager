//
//  SMLeadPoolViewCell.m
//  Smart Manager
//
//  Created by Sandeep on 23/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMLeadPoolViewCell.h"

@implementation SMLeadPoolViewCell
@synthesize leadToolTitleLabel;
@synthesize activeCountLabel;
@synthesize closedCountLabel;


- (void)awakeFromNib
{
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
