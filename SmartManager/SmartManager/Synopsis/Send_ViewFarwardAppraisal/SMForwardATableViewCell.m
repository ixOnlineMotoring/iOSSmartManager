//
//  SMForwardATableViewCell.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 25/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMForwardATableViewCell.h"

@implementation SMForwardATableViewCell

- (void)awakeFromNib {
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
