//
//  SMDemandObject.m
//  Smart Manager
//
//  Created by Ankit S on 7/5/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMDemandObject.h"

@implementation SMDemandObject


-(id) init
{
    if(self=[super init])
    {
        self.strName = @"";
        self.strLeads = @"";
        self.strSales = @"";
        
    }
    return self;
}
@end
