//
//  SMLoadSpecialObject.h
//  SmartManager
//
//  Created by Ketan Nandha on 25/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMLoadSpecialObject : NSObject

@property(strong, nonatomic) NSString *strSelectName;
@property(strong, nonatomic) NSString *strSelectId;

@property(strong, nonatomic) NSString *strVehicleName;


@property(strong, nonatomic) NSString *strVehicleUsedYear;
@property(strong, nonatomic) NSString *strVehicleFriendlyName;
@property(strong, nonatomic) NSString *strVehicleColor;
@property(strong, nonatomic) NSString *strVehicleMileage;
@property(strong, nonatomic) NSString *strVehicleStockCode;

@property(strong, nonatomic) NSString *strVehicleMakeID;
@property(strong, nonatomic) NSString *strVehicleModelID;
@property(strong, nonatomic) NSString *strVehicleVariantID;

@property (strong, nonatomic) NSString *strUsedVehicleStockID;

@property(strong, nonatomic) NSString *strMakeName;
@property(strong, nonatomic) NSString *strModelName;
@property(strong, nonatomic) NSString *strRetailPrice;

@end
