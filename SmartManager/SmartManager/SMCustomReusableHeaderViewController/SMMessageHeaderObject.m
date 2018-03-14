//
//  SMMessageHeaderObject.m
//  Smart Manager
//
//  Created by Prateek Jain on 05/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMMessageHeaderObject.h"

@implementation SMMessageHeaderObject

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.arrayOfInnerMessages = [[NSMutableArray alloc] init];
        self.isSectionExpanded = NO;
        self.strComments = @"";
        self.strDetails1 = @"";
        self.strDetails2 = @"";
    }
    
    return self;
}
@end
