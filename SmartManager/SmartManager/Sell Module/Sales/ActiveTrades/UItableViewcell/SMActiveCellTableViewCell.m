//
//  SMActiveCellTableViewCell.m
//  Smart Manager
//
//  Created by Jignesh on 03/11/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMActiveCellTableViewCell.h"

@implementation SMActiveCellTableViewCell

- (void)awakeFromNib {
    // Initialization code

    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
        self.lblUserInfo.font = [UIFont fontWithName:FONT_NAME_BOLD size:9.0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
