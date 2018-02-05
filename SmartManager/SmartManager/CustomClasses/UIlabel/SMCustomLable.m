//
//  SMCustomLable.m
//  SmartManager
//
//  Created by Jignesh on 07/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomLable.h"
#import "SMConstants.h"

@implementation SMCustomLable

// added by jignesh

// IMportannt  - setup will setupt the font
// If you're loading from a xib or storyboard, the initialization is done by initWithCoder

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
        [self setFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone]] :
        [self setFont:[UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad]];
}


@end
