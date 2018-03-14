//
//  SMSMRealTimeOnlineViewCell.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 21/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMSMRealTimeOnlineViewCell.h"

@implementation SMSMRealTimeOnlineViewCell

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
