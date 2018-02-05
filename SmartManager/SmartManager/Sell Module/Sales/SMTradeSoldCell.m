//
//  SMTradeSoldCell.m
//  Smart Manager
//
//  Created by Sandeep on 27/11/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMTradeSoldCell.h"

@implementation SMTradeSoldCell
@synthesize lblRateBuyerQuestion;
@synthesize txtRateBuyerRatting;
@synthesize buttonSubmit;


- (void)awakeFromNib {
    // Initialization code

    self.buttonSubmit.layer.cornerRadius = 4.0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
