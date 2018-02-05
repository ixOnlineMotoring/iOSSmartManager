//
//  SMExistingVehicleTableViewCell.m
//  SmartManager
//
//  Created by Priya on 31/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMExistingVehicleTableViewCell.h"
#import "SMConstants.h"


@implementation SMExistingVehicleTableViewCell

- (void)awakeFromNib {
    [self.lblTitle setFont:[UIFont fontWithName:FONT_NAME_BOLD size:15]];
    [self.lblDescription setFont:[UIFont fontWithName:FONT_NAME size:15]];
    [self.txtDescription setFont:[UIFont fontWithName:FONT_NAME size:15]];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
