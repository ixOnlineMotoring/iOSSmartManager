//
//  SMSynopsisAppraisalNormalCell.m
//  Smart Manager
//
//  Created by Prateek Jain on 29/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSynopsisAppraisalNormalCell.h"

@implementation SMSynopsisAppraisalNormalCell

- (void)awakeFromNib {
    // Initialization code
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
    }

    self.viewButton.layer.cornerRadius = 8.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
