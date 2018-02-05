//
//  SMNewPricePlotterObject.m
//  Smart Manager
//
//  Created by Ankit S on 6/30/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMNewPricePlotterObject.h"

@implementation SMNewPricePlotterObject
-(id) init
{
    if(self=[super init])
    {
        self.strDate = @"";
        self.strValue = @"";
    }
    return self;
}
@end
