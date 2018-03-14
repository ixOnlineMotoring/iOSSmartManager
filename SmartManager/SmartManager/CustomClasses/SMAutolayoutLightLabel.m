//
//  SMAutolayoutLightLabel.m
//  Smart Manager
//
//  Created by Prateek Jain on 21/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMAutolayoutLightLabel.h"

@implementation SMAutolayoutLightLabel

- (void)setFont:(UIFont *)font
{
    
    font = [UIFont fontWithName:FONT_NAME size:font.pointSize];
    [super setFont:font];
}

@end
