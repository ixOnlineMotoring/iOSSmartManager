//
//  SMLeadsDetailCell.m
//  SmartManager
//
//  Created by Liji Stephen on 05/05/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMLeadsDetailCell.h"

@implementation SMLeadsDetailCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.txtViewComment.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtViewComment.layer.borderWidth= 0.8f;
    self.txtViewComment.delegate=self;
    
    [self.buttonChangeStatus setSelected:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
