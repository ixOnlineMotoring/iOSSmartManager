//
//  SMClassForToDoObjects.m
//  SmartManager
//
//  Created by Liji Stephen on 05/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMClassForToDoObjects.h"

@implementation SMClassForToDoObjects

@synthesize strSectionID,strSectionName,arrayOfInnerObjects,iCountOfLeadForEachRow;

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.arrayOfInnerObjects = [[NSMutableArray alloc] init];
        self.isExpanded = NO;
    }
   
    return self;
}

@end
