//
//  SMCustomMessageCell.m
//  Smart Manager
//
//  Created by Prateek Jain on 05/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomMessageCell.h"

@implementation SMCustomMessageCell

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.contentView layoutIfNeeded];

    // labelsCollection is an IBOutletCollection of my UILabel sublasses
    self.lblUserName.preferredMaxLayoutWidth = self.lblUserName.bounds.size.width;
    self.lblMessage.preferredMaxLayoutWidth =   self.lblMessage.bounds.size.width;
    // self.lblMessageTime.preferredMaxLayoutWidth =   self.lblMessageTime.bounds.size.width;



}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
