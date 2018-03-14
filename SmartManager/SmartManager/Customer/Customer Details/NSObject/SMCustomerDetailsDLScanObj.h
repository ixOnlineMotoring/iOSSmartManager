//
//  SMCustomerDetailsDLScanObj.h
//  SmartManager
//
//  Created by Liji Stephen on 09/07/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCustomerDetailsDLScanObj : NSObject

@property(nonatomic,strong)NSString *customerName;
@property(nonatomic,strong)NSString *customerID;
@property(nonatomic,strong)NSString *custDOB;
@property(nonatomic,strong)NSString *custAge;
@property(nonatomic,strong)NSString *custGender;
@property(nonatomic,strong)NSString *custRestriction;
@property(nonatomic,strong)NSString *custCertificateNo;
@property(nonatomic,strong)NSString *custClasses;
@property(nonatomic,strong)NSString *custIssuedDate;
@property(nonatomic,strong)NSString *custPhoto;
@property(nonatomic,strong)NSString *custPhoneNumber;
@property(nonatomic,strong)NSString *custEmailAddress;
@property(nonatomic,strong)NSString *custScanID;
@property(nonatomic,strong)NSMutableArray *arrayDriverVehicleClasses;
@end
