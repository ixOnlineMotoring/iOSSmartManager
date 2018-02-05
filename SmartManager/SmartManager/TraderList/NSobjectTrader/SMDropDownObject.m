//
//  SMDropDownObject.m
//  SmartManager
//
//  Created by Jignesh on 09/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMDropDownObject.h"

@implementation SMDropDownObject

@synthesize dropDownID,strSortText,isAscending,strSortTextID;
-(id) init
{
    if(self=[super init])
    {
        self.strVINNo = @"";
        self.strRegNo = @"";
        self.strMakeName = @"";
    }
    return self;
}

@end