//
//  SMListingModuleCell.m
//  SmartManager
//
//  Created by Liji Stephen on 04/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMListingModuleCell.h"

@implementation SMListingModuleCell

- (void)awakeFromNib
{
    // Initialization code
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.lblModuleName setFont:[UIFont fontWithName:FONT_NAME size:15.0]];
    }
    else
    {
        [self.lblModuleName setFont:[UIFont fontWithName:FONT_NAME size:23.0]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
