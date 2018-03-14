//
//  SMStockAuditDetailObject.m
//  SmartManager
//
//  Created by Liji Stephen on 06/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMStockAuditDetailObject.h"

@implementation SMStockAuditDetailObject
@synthesize auditGeoAddress,auditStockNo,auditVehicleDetails,auditVehicleName,auditVinID,auditTime,auditStockType,auditCompleted,auditMatched,arrayOfVehicleImages;
@synthesize auditHistoryDate;
@synthesize auditHistoryVehiclesCount;
@synthesize auditVehicleYear;
@synthesize auditVehicleDays;
@synthesize auditVehicleColor;
@synthesize auditVehicleMileage;
@synthesize auditVehiclePriceRetail;@synthesize auditVehiclePriceTrade;
@synthesize auditVehicleType;@synthesize auditVehicleRegNum;


-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.arrayOfVehicleImages = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
