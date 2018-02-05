//
//  SMObjectSimpleLogicXml.m
//  Smart Manager
//
//  Created by Ankit S on 8/9/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMObjectSimpleLogicXml.h"

@implementation SMObjectSimpleLogicXml
-(id) init
{
    if(self=[super init])
    {
        self.strAge = @"";
        self.strTrade = @"";
        self.strRetail = @"";
        self.strMileage = @"";
        self.strLatestPrice = @"";
        self.strAgeDepreciation = @"";
        self.strMileageAdjustment = @"";
    }
    return self;
}

@end
