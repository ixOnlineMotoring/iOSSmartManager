//
//  SMVINVerificationXml.h
//  Smart Manager
//
//  Created by Ankit S on 8/31/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SMVINVerificationXml : NSObject
@property int iStatus;
@property(strong,nonatomic) NSString *strTUA_VehicleCodeAndDescriptionID;
@property(strong,nonatomic) NSString *strTUA_ConvergedDataIDForCode;
@property(strong,nonatomic) NSString *strDiscontinuedDate;
@property(strong,nonatomic) NSString *strIntroductionDate;
@property(strong,nonatomic) NSString *strResultCode;
@property(strong,nonatomic) NSString *strResultCodeDescription;
@property(strong,nonatomic) NSString *strTUA_VehicleConfirmationID;
@property(strong,nonatomic) NSString *strTUA_ConvergedDataIDForVehicle;
@property(strong,nonatomic) NSString *strMatchColour;
@property(strong,nonatomic) NSString *strHPINumber;
@property(strong,nonatomic) NSString *strMatchEngineNumber;
@property(strong,nonatomic) NSString *strMatchModel;
@property(strong,nonatomic) NSString *strMatchString;
@property(strong,nonatomic) NSString *strMatchVehicleRegistration;
@property(strong,nonatomic) NSString *strMatchVinorChassis;
@property(strong,nonatomic) NSString *strMatchYear;
@property(strong,nonatomic) NSString *strMatchManufacturer;
@property(strong,nonatomic) NSString *str1YearLicenced;
@property(strong,nonatomic) NSString *strWarrantyYear;
@property(strong,nonatomic) NSString *strLicenceExpiry;
@end
