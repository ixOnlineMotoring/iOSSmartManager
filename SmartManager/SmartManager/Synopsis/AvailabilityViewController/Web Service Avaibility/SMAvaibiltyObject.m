//
//  SMAvaibiltyObject.m
//  Smart Manager
//
//  Created by Ankit S on 8/19/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMAvaibiltyObject.h"

@implementation SMAvaibiltyObject
-(id) init
{
    if(self=[super init])
    {
        self.strVariantName = @"";
        self.strProvinceAvailability = @"";
        self.strNationalAvailability = @"";
        self.strGroupAvailability = @"";
        self.strClientAvailability = @"";
    }
    return self;
}

@end
