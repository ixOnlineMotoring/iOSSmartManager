//
//  SMVINHistoryObject.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 02/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMVINHistoryObject.h"

@implementation SMVINHistoryObject
-(id) init
{
    if(self=[super init])
    {
        self.strLastSeen = @"";
        self.strDealer = @"";
        self.strLocation = @"";
        self.strMileage = @"";
        self.strPrice = @"";
    }
    return self;
}
@end
