//
//  SMAuditHistoryListCell.m
//  SmartManager
//
//  Created by Liji Stephen on 09/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMAuditHistoryListCell.h"

@implementation SMAuditHistoryListCell

- (void)awakeFromNib
{
    // Initialization code
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblAuditDate.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
        [self.lblVehicleNum setFont:[UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone]];
    }
    else
    {
        self.lblAuditDate.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        [self.lblVehicleNum setFont:[UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad]];
    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
