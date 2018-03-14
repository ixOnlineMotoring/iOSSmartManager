//
//  SMLeadsHeaderTableViewCell.m
//  Smart Manager
//
//  Created by Ankit S on 8/4/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMLeadsHeaderTableViewCell.h"

@implementation SMLeadsHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
    }
     // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
