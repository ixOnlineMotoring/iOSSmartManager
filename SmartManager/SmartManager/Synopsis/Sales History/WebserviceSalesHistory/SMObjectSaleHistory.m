//
//  SMObjectSaleHistory.m
//  Smart Manager
//
//  Created by Ankit S on 8/22/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMObjectSaleHistory.h"

@implementation SMObjectSaleHistory
-(id) init
{
    if(self=[super init])
    {
        self.strVariantName = @"";
        self.strSalesCount = @"";
        
    }
    return self;
}

@end
