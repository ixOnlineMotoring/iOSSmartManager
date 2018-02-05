//
//  SMObjectVerificationDetailAttribute.h
//  Smart Manager
//
//  Created by Ankit S on 8/29/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMObjectVerificationDetailAttribute : NSObject

@property (strong,nonatomic) NSMutableAttributedString    *strFINAL;


#pragma mark - Finance History and Finance
@property (strong,nonatomic) NSString *strTUA_FinanceHistoryID;
@property (strong,nonatomic) NSString *strTUA_ConvergedDataID;
@property (strong,nonatomic) NSString *strAgreementOrAccountNumber;
@property (strong,nonatomic) NSString *strAgreementType;
@property (strong,nonatomic) NSString *strEndDate;
@property (strong,nonatomic) NSString *strFinanceHouse;
@property (strong,nonatomic) NSString *strStartDate;
@property (strong,nonatomic) NSString *strTelephoneNumber;
@property (strong,nonatomic) NSString *strFinanceBranch;
@property (strong,nonatomic) NSString *strFinanceProvider;

#pragma mark - Accident History , Alert History , FactoryFittedExtra , IVID History , Mileage History, Registration History and Stolen
@property (strong,nonatomic) NSString *strDate;
@property (strong,nonatomic) NSString *strResultCodeDescription;
@property (strong,nonatomic) NSString *strCertificateNumber;

#pragma mark - Enquiries History
@property (strong,nonatomic) NSString *strSource;
@property (strong,nonatomic) NSString *strTransactionDate;

#pragma mark - Microdot History
@property (strong,nonatomic) NSString *strCompany;
@property (strong,nonatomic) NSString *strContactNumber;
@property (strong,nonatomic) NSString *strDateApplied;
@property (strong,nonatomic) NSString *strReferenceNumber;

#pragma mark - Vehicle Confirmation
@property (strong,nonatomic) NSString *strHPINumber;
@property (strong,nonatomic) NSString *strMatchColour;
@property (strong,nonatomic) NSString *strMatchEngineNumber;
@property (strong,nonatomic) NSString *strMatchManufacturer;
@property (strong,nonatomic) NSString *strMatchModel;
@property (strong,nonatomic) NSString *strMatchString;
@property (strong,nonatomic) NSString *strMatchVehicleRegistration;
@property (strong,nonatomic) NSString *strMatchVinorChassis;
@property (strong,nonatomic) NSString *strMatchYear;
@end
