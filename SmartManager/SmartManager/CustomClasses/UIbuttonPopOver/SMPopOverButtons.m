//
//  SMPopOverButtons.m
//  SmartManager
//
//  Created by Jignesh on 07/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMPopOverButtons.h"
#import "SMCustomColor.h"
@implementation SMPopOverButtons

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
    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ?
    [self.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:15]]:
    [self.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:20]];
    [self setBackgroundColor:[SMCustomColor setPopOverButtonColor]];
    
}


@end
