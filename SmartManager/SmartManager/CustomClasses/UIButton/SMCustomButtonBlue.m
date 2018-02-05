//
//  SMCustomButtonBlue.m
//  SmartManager
//
//  Created by Jignesh on 07/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomButtonBlue.h"
#import "SMCustomColor.h"
#import "SMConstants.h"

@implementation SMCustomButtonBlue

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ?
    [[self titleLabel] setFont:[UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone]]:
    [[self titleLabel] setFont:[UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad]];

    
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds      = YES;

    [self setExclusiveTouch:YES];
    [self setBackgroundColor:[SMCustomColor setBlueColorThemeButton]];

}

@end
