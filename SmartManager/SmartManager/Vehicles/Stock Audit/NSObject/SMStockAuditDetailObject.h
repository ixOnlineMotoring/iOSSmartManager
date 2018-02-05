//
//  SMStockAuditDetailObject.h
//  SmartManager
//
//  Created by Liji Stephen on 06/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMStockAuditDetailObject : NSObject

@property(nonatomic,strong)NSString *auditGeoAddress;
@property(nonatomic,strong)NSString *auditVehicleName;
@property(nonatomic,strong)NSString *auditVehicleDetails;
@property(nonatomic,strong)NSString *auditStockNo;
@property(nonatomic,strong)NSString *auditVinID;
@property(nonatomic,strong)NSString *auditTime;
@property(nonatomic,strong)NSString *auditStockType;
@property(nonatomic,strong)NSString *auditCompleted;
@property(nonatomic,strong)NSString *auditMatched;
@property(nonatomic,strong)NSString *auditLicenseURL;
@property(nonatomic,strong)NSString *auditVehicleURL;
@property(nonatomic,strong)NSString *auditVehicleYear;
@property(nonatomic,strong)NSString *auditVehicleRegNum;
@property(nonatomic,strong)NSString *auditVehicleColor;
@property(nonatomic,strong)NSString *auditVehicleDays;
@property(nonatomic,strong)NSString *auditVehicleMileage;
@property(nonatomic,strong)NSString *auditVehicleType;
@property(nonatomic,strong)NSString *auditVehiclePriceRetail;
@property(nonatomic,strong)NSString *auditVehiclePriceTrade;


// Audit History section

@property(nonatomic,strong)NSString *auditHistoryDate;
@property(nonatomic,strong)NSString *auditHistoryVehiclesCount;



// image

@property(nonatomic,strong)NSMutableArray *arrayOfVehicleImages;


@end
