//
//  SMMyLeadsCustomCell.m
//  SmartManager
//
//  Created by Liji Stephen on 29/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMMyLeadsCustomCell.h"

@implementation SMMyLeadsCustomCell

- (void)awakeFromNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblID.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
        self.lblName.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
        self.lblEmailID.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
        self.lblPhoneNum.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
        self.lblTime.font = [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
        self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
        
    }
    else
    {
        self.lblID.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        self.lblName.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        self.lblEmailID.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        self.lblPhoneNum.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        self.lblTime.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];

    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
