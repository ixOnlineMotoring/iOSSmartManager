//
//  SMCustomDynamicCell.m
//  SmartManager
//
//  Created by Liji Stephen on 05/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomDynamicCell.h"

@implementation SMCustomDynamicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    self.lblValue.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblValue.numberOfLines = 0;
}

@end
