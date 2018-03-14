//
//  SMLoadVehicleTableViewCell.m
//  SmartManager
//
//  Created by Priya on 15/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMLoadVehicleTableViewCell.h"

@implementation SMLoadVehicleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.lblMakeName setFont:[UIFont fontWithName:FONT_NAME size:15]];
    }
    else
    {
        [self.lblMakeName setFont:[UIFont fontWithName:FONT_NAME size:20]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
