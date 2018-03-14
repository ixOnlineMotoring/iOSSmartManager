//
//  SMCustomLabelBold.m
//  SmartManager
//
//  Created by Ketan Nandha on 08/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomLabelBold.h"
#import "SMConstants.h"

// added by ketan

// IMportannt  - setup will setupt the font
// If you're loading from a xib or storyboard, the initialization is done by initWithCoder

@implementation SMCustomLabelBold

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
    [self setFont:[UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone]] :
    [self setFont:[UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad]];
}

@end
