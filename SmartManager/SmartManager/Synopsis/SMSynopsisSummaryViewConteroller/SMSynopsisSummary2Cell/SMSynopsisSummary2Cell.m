//
//  SMSynopsisSummaryCell.m
//  Smart Manager
//
//  Created by Sandeep on 21/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMSynopsisSummary2Cell.h"

@implementation SMSynopsisSummary2Cell

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
