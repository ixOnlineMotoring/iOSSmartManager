//
//  SMAppNotificationCell.m
//  Smart Manager
//
//  Created by Ketan Nandha on 02/02/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import "SMAppNotificationCell.h"

@implementation SMAppNotificationCell

- (void)awakeFromNib
{
    [super awakeFromNib];
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
