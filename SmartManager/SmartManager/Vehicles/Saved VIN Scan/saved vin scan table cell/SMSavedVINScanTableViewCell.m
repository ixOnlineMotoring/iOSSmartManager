//
//  SMSavedVINScanTableViewCell.m
//  SmartManager
//
//  Created by Priya on 28/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMSavedVINScanTableViewCell.h"

@implementation SMSavedVINScanTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.lblMakeInfo setFont:[UIFont fontWithName:FONT_NAME size:14]];
        [self.lblDate setFont:[UIFont fontWithName:FONT_NAME_BOLD size:13]];
        [self.lblMakeName setFont:[UIFont fontWithName:FONT_NAME_BOLD size:13]];
    }
    else
    {
        [self.lblMakeInfo setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.lblDate setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.lblMakeName setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0f]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
