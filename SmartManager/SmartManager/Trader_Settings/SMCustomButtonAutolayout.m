//
//  SMCustomButtonAutolayout.m
//  Smart Manager
//
//  Created by Prateek Jain on 30/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomButtonAutolayout.h"

@implementation SMCustomButtonAutolayout

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setFont:(UIFont *)font
{
    
    font = [UIFont fontWithName:FONT_NAME_BOLD size:font.pointSize];
    [super setFont:font];
}


@end
