//
//  SMGridModuleData.m
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMGridModuleData.h"


@implementation SMGridModuleData

@synthesize moduleName,isQuickLink,arrayOfPages;

-(id)init
{
    if (self = [super init])
    {
        self.moduleName = @"";
        self.arrayOfPages = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
