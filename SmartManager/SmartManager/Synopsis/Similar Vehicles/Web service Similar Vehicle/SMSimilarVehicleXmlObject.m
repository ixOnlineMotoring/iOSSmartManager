//
//  SMSimilarVehicleXmlObject.m
//  Smart Manager
//
//  Created by Ankit S on 6/30/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMSimilarVehicleXmlObject.h"

@implementation SMSimilarVehicleXmlObject

-(id) init
{
    if(self=[super init])
    {
        self.strYearOlderCnt = @"";
        self.strOtherModelsCnt = @"";
        self.strYearYoungerCnt = @"";
    }
    return self;
}

@end
