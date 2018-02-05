//
//  SMSalesTableViewCell.m
//  Smart Manager
//
//  Created by Jignesh on 28/10/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMSalesTableViewCell.h"

@implementation SMSalesTableViewCell

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
