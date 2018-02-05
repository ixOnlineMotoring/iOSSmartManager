//
//  SMObjectAvaibilityXml.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 16/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMObjectAvaibilityXml.h"

@implementation SMObjectAvaibilityXml
-(id) init
{
    if(self=[super init])
    {
        self.strGroupName = @"";
        self.strProvinceName = @"";
    }
    return self;
}

@end
