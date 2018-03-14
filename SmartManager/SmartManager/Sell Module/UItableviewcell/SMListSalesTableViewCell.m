//
//  SMListSalesTableViewCell.m
//  Smart Manager
//
//  Created by Jignesh on 02/11/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMListSalesTableViewCell.h"

@implementation SMListSalesTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.label_SaleCarCount.attributedText = [[NSAttributedString alloc] initWithString:@"8" attributes:underlineAttribute];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
