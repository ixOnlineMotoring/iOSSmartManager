//
//  SMLoadSpecialTableViewCell.m
//  SmartManager
//
//  Created by Ketan Nandha on 25/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMLoadSpecialTableViewCell.h"

@implementation SMLoadSpecialTableViewCell

- (void)awakeFromNib {
    // Initialization code
    UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? [self.lblSelectType setFont:[UIFont fontWithName:FONT_NAME size:15]] : [self.lblSelectType setFont:[UIFont fontWithName:FONT_NAME size:20]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
