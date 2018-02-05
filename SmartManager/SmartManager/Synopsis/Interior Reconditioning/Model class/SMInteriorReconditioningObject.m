//
//  SMInteriorReconditioningObject.m
//  Smart Manager
//
//  Created by Ketan Nandha on 30/12/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMInteriorReconditioningObject.h"

@implementation SMInteriorReconditioningObject

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.arrmOptions = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
