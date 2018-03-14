//
//  SMSummaryObject.m
//  Smart Manager
//
//  Created by Ketan Nandha on 04/05/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMSummaryObject.h"

@implementation SMSummaryObject
-(id) init
{
    if(self=[super init])
    {
        self.strArea = @"";
        self.strType = @"";
    }
    return self;
}

@end
