//
//  SMDLVehicleClassCell.m
//  SmartManager
//
//  Created by Liji Stephen on 16/07/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMDLVehicleClassCell.h"

@implementation SMDLVehicleClassCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.lblVehicleClassName.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblRestrictionsValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblRestrictions.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblIssuedDateValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblIssued.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];

    self.viewContainingVehicleClass.layer.borderWidth = 1.0;
    self.viewContainingVehicleClass.layer.borderColor = [[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    
    self.lblIssuedDateValue.textColor = [UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0];
    
    self.lblRestrictionsValue.textColor = [UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
