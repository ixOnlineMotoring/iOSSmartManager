//
//  SMObjectAverageDays.m
//  Smart Manager
//
//  Created by Ankit S on 8/5/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMObjectAverageDays.h"

@implementation SMObjectAverageDays

-(id) init
{
    if(self=[super init])
    {
        self.iClientAverageDays=0;
        self.iClientTotalStockMovements=0;
        self.iCityAverageDays=0;
        self.iCityTotalStockMovements=0;
        self.iNationalAverageDays=0;
        self.iNationalTotalStockMovements=0;
    }
    return self;
}


@end
