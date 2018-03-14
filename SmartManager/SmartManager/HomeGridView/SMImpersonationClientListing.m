//
//  SMImpersonationClientListing.m
//  SmartManager
//
//  Created by Jignesh on 12/03/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMImpersonationClientListing.h"

@implementation SMImpersonationClientListing


// (1)
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.contentView.frame = self.bounds;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    // ADDED BUY JIGS :)
    
    // (2)
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    // (3)
    self.lblClientName.preferredMaxLayoutWidth = CGRectGetWidth(self.lblClientName.frame);
}
@end
