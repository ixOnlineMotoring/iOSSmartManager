//
//  SMTradePartnersCell.m
//  Smart Manager
//
//  Created by Sandeep on 06/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMTradePartnersCell.h"

@implementation SMTradePartnersCell
@synthesize editButton;

- (void)awakeFromNib {
    // Initialization code

    self.editButton.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
