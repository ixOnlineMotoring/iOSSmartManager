//
//  SMSynopsisXMLResultObject.h
//  Smart Manager
//
//  Created by Ketan Nandha on 04/05/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSynopsisXMLResultObject : NSObject
@property (strong, nonatomic)NSString *strVariantImage;
@property (assign,nonatomic)int intYear;
@property (assign,nonatomic)int intMakeId;
@property (assign,nonatomic)int intModelId;
@property (assign,nonatomic)int intVariantId;
@property (strong, nonatomic)NSString *strMakeName;
@property (strong, nonatomic)NSString *strModelName;;
@property (strong, nonatomic)NSString *strVariantName;
@property (strong, nonatomic)NSString *strFriendlyName;
@property (strong,nonatomic)NSString *strMMCode;
@property (strong, nonatomic)NSString *strTransmission;
@property (strong, nonatomic)NSString *strStartDate;
@property (strong, nonatomic)NSString *strEndDate;
@property (strong, nonatomic)NSString *strVariantDetails;
@property (strong, nonatomic)NSString *strVINNo;
@property (strong, nonatomic)NSString *strKilometers;
@property (assign,nonatomic) int intGears;
@property (strong, nonatomic) NSString *strFuel_Type;
@property (assign,nonatomic) int intPower_KW;
@property (assign,nonatomic) int intTorque_NM;
@property (assign,nonatomic) int intEngine_CC;
@property (strong, nonatomic) NSString *strGearbox;
@property (assign,nonatomic) int intSources;
@property (assign,nonatomic) float floatAverageTradePrice;
@property (assign,nonatomic) float floatAveragePrice;
@property (assign,nonatomic) float floatMarketPrice;
@property (assign,nonatomic) int intReviewCount;
@property (assign,nonatomic) int iStatus;
@property (strong, nonatomic)NSString *pricingTraderPrice;
@property (strong, nonatomic)NSString *pricingRetailPrice;
@property (strong, nonatomic)NSString *pricingPrivateAdvertPrice;
@property (strong, nonatomic)NSString *pricingSLTradePrice;
@property (strong, nonatomic)NSString *pricingSLRetailPrice;
@property (strong, nonatomic)NSString *pricingTUATradePrice;
@property (strong, nonatomic)NSString *pricingTUARetailPrice;
@property (strong, nonatomic)NSString *strTUASearchDateTime;
@property (strong,nonatomic)NSString *strRegNo;
@property(nonatomic, strong) NSString *appraisalID;
@property (strong, nonatomic) NSMutableArray *arrmDemandSummary;
@property (strong, nonatomic) NSMutableArray *arrmAverageAvailableSummary;
@property (strong, nonatomic) NSMutableArray *arrmAverageDaysInStockSummary;
@property (strong, nonatomic) NSMutableArray *arrmLeadPoolSummary;
@property (strong, nonatomic) NSMutableArray *arrmWarrantySummary;
@property (strong, nonatomic) NSMutableArray *arrVariantDetails;
@property (strong, nonatomic) NSMutableArray *arrmSalesSummary;


@property (strong, nonatomic)NSString *strExtras;
@property (strong, nonatomic)NSString *strCondition;

@end
