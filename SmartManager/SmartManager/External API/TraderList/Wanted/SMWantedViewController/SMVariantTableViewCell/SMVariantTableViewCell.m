//
//  SMVariantTableViewCell.m
//  SmartManager
//
//  Created by Ketan Nandha on 24/02/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMVariantTableViewCell.h"

@implementation SMVariantTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.lblName setFont:[UIFont fontWithName:FONT_NAME size:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 15.0f : 20.0f]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
