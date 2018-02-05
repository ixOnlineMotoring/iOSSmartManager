//
//  SMObjectVerificationDetailAttribute.m
//  Smart Manager
//
//  Created by Ankit S on 8/29/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMObjectVerificationDetailAttribute.h"


@implementation SMObjectVerificationDetailAttribute

@synthesize strTelephoneNumber,strDateApplied,strDate,strEndDate,strStartDate,strTransactionDate,strContactNumber;

-(id)init{
  
    if(self=[super init])
    {
        [[self.strFINAL mutableString] setString:@""];
        
#pragma mark - Finance History  and Finance
        self.strTUA_FinanceHistoryID=@"";
        self.strTUA_ConvergedDataID=@"";
        self.strAgreementOrAccountNumber=@"";
        self.strAgreementType=@"";
        self.strEndDate=@"";
        self.strFinanceHouse=@"";
        self.strStartDate=@"";
        self.strTelephoneNumber=@"";
        self.strFinanceBranch=@"";
        self.strFinanceProvider=@"";
        
#pragma mark - Accident History , Alert History , FactoryFittedExtra , IVID History , Mileage History, Registration History and Stolen
        self.strDate=@"";
        self.strResultCodeDescription=@"";
        self.strCertificateNumber=@"";
        
#pragma mark - Enquiries History
        self.strSource=@"";
        self.strTransactionDate=@"";
        
#pragma mark - Microdot History
        self.strCompany=@"";
        self. strContactNumber=@"";
        self. strDateApplied=@"";
        self.strReferenceNumber=@"";
        
#pragma mark - Vehicle Confirmation
        self.strHPINumber=@"";
        self. strMatchColour=@"";
        self.strMatchEngineNumber=@"";
        self.strMatchManufacturer=@"";
        self.strMatchModel=@"";
        self.strMatchString=@"";
        self.strMatchVehicleRegistration=@"";
        self.strMatchVinorChassis=@"";
        self.strMatchYear=@"";
        
    }
    return self;
}

- (void)setStrTelephoneNumber:(NSString *)newValue {
    newValue = [newValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    strTelephoneNumber = [SMAttributeStringFormatObject formatPhoneNumber:newValue];;
}

- (void)setStrContactNumber:(NSString *)newValue {
    newValue = [newValue stringByReplacingOccurrencesOfString:@" " withString:@""];
    strContactNumber = [SMAttributeStringFormatObject formatPhoneNumber:newValue];;
}

- (void)setStrStartDate:(NSString *)newValue {
    strStartDate = [[SMCommonClassMethods shareCommonClassManager]customDateFormatFunctionWithDate:newValue withFormat:1];
}
- (void)setStrEndDate:(NSString *)newValue {
    strEndDate = [[SMCommonClassMethods shareCommonClassManager]customDateFormatFunctionWithDate:newValue withFormat:1];
}
- (void)setStrDate:(NSString *)newValue {
    strDate =  [[SMCommonClassMethods shareCommonClassManager]customDateFormatFunctionWithDate:newValue withFormat:1];
}
- (void)setStrDateApplied:(NSString *)newValue {
    strDateApplied =  [[SMCommonClassMethods shareCommonClassManager]customDateFormatFunctionWithDate:newValue withFormat:1];
}
- (void)setStrTransactionDate:(NSString *)newValue {
    strTransactionDate =  [[SMCommonClassMethods shareCommonClassManager]customDateFormatFunctionWithDate:newValue withFormat:1];
}


@end
