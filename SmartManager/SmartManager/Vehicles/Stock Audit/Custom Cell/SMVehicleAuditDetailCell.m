//
//  SMVehicleAuditDetailCell.m
//  SmartManager
//
//  Created by Liji Stephen on 06/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMVehicleAuditDetailCell.h"
#import "SMConstants.h"


@implementation SMVehicleAuditDetailCell

- (void)awakeFromNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblVinNum.font = [UIFont fontWithName:FONT_NAME size:14.0];
        self.lblVehicleDetails.font = [UIFont fontWithName:FONT_NAME size:14.0];
        self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME size:14.0];
        self.lblStockNum.font = [UIFont fontWithName:FONT_NAME size:14.0];
        self.lblStockType.font = [UIFont fontWithName:FONT_NAME size:12.0];
        
        
    }
    else
    {
        self.lblVinNum.font = [UIFont fontWithName:FONT_NAME size:20.0];
        self.lblVehicleDetails.font = [UIFont fontWithName:FONT_NAME size:20.0];
        self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME size:20.0];
        self.lblStockNum.font = [UIFont fontWithName:FONT_NAME size:20.0];
        self.lblTime.font = [UIFont fontWithName:FONT_NAME size:14.0];
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
