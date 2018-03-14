//
//  SMAddToStockTableViewCell.m
//  SmartManager
//
//  Created by Priya on 27/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMAddToStockTableViewCell.h"

@implementation SMAddToStockTableViewCell

- (void)awakeFromNib
{
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone)
    {
        self.btnAdditionalInfo.titleLabel.font = [UIFont fontWithName:FONT_NAME size:15.0];
        [self.btnActivateCPA.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:15.0]];
        [self.btnDontLetOverride.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:15.0]];
        [self.btnIgnoreExcludeSetting.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:15.0]];
        [self.btnRemoveVehicle.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:15.0]];

    }
    else
    {
        self.btnAdditionalInfo.titleLabel.font = [UIFont fontWithName:FONT_NAME size:20.0];
        [self.btnActivateCPA.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
        [self.btnDontLetOverride.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
        [self.btnIgnoreExcludeSetting.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
        [self.btnRemoveVehicle.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
    }

    self.txtInternalNote.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtInternalNote.layer.borderWidth= 0.8f;
    self.txtAddToTender.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtAddToTender.layer.borderWidth= 0.8f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
