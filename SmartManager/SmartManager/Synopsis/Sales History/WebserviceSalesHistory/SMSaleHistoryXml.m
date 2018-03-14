//
//  SMSaleHistoryXml.m
//  Smart Manager
//
//  Created by Ankit S on 8/22/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMSaleHistoryXml.h"

@implementation SMSaleHistoryXml
-(id) init
{
    if(self=[super init])
    {
        self.strAverageStockHolding30Days = @"";
        self.strAverageStockHolding45Days = @"";
        self.strAverageStockHolding60Days = @"";
        self.strAverageSalesPerMonth = @"";
        self.strInStock = @"";
    }
    return self;
}

@end
