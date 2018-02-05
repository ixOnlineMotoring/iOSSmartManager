//
//  SMStockListCell.m
//  SmartManager
//
//  Created by Liji Stephen on 29/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMStockListCell.h"
#import "SMConstants.h"

@implementation SMStockListCell

- (void)awakeFromNib
{
    // Initialization code
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        self.lbVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        self.lbVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    }
    else
    {
        self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        self.lbVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        self.lbVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];

    
    }
    
    /*self.lblVehicleName.numberOfLines = 0;
    [self.lblVehicleName sizeToFit];
    self.lbVehicleDetails1.numberOfLines = 0;
    [self.lbVehicleDetails1 sizeToFit];*/
    
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
