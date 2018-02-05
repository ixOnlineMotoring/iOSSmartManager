//
//  SMSettings_MembersCell.m
//  Smart Manager
//
//  Created by Sandeep on 05/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSettings_MembersCell.h"

@implementation SMSettings_MembersCell
@synthesize memberNameLabel;

- (void)awakeFromNib {
    // Initialization code

    self.editButton.layer.cornerRadius = 4.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
