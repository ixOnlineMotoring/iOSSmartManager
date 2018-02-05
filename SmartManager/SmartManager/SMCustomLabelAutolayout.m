//
//  SMCustomLabelAutolayout.m
//  Smart Manager
//
//  Created by Prateek Jain on 07/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomLabelAutolayout.h"

@implementation SMCustomLabelAutolayout

- (void)setFont:(UIFont *)font
{
    
    font = [UIFont fontWithName:FONT_NAME_BOLD size:font.pointSize];
    [super setFont:font];
}

@end
