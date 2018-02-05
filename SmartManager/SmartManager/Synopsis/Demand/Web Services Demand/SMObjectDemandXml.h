//
//  SMObjectDemandXml.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 17/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SMDemandObject.h"
@interface SMObjectDemandXml : NSObject
@property int iStatus;
@property (strong,nonatomic) NSMutableArray *arrmDemands;


//Client
@property (strong,nonatomic) NSString *strClientName;
@property (strong,nonatomic) NSString *strVariantName;
@property (strong,nonatomic) NSString *strModelName;
@property (strong,nonatomic) NSString *strClientVariantLeadCount;
@property (strong,nonatomic) NSString *strClientVariantLeadCountRanking;
@property (strong,nonatomic) NSString *strClientVariantSoldLeadCount;
@property (strong,nonatomic) NSString *strClientVariantSoldLeadCountRanking;
@property (strong,nonatomic) NSString *strClientModelLeadCount;
@property (strong,nonatomic) NSString *strClientModelLeadCountRanking;
@property (strong,nonatomic) NSString *strClientModelSoldLeadCount;
@property (strong,nonatomic) NSString *strClientModelSoldLeadCountRanking;

//City
@property (strong,nonatomic) NSString *strCityName;
@property (strong,nonatomic) NSString *strCityVariantLeadCount;
@property (strong,nonatomic) NSString *strCityVariantLeadCountRanking;
@property (strong,nonatomic) NSString *strCityVariantSoldLeadCount;
@property (strong,nonatomic) NSString *strCityVariantSoldLeadCountRanking;
@property (strong,nonatomic) NSString *strCityModelLeadCount;
@property (strong,nonatomic) NSString *strCityModelLeadCountRanking;
@property (strong,nonatomic) NSString *strCityModelSoldLeadCount;
@property (strong,nonatomic) NSString *strCityModelSoldLeadCountRanking;

//Province
@property (strong,nonatomic) NSString *strProvinceName;
@property (strong,nonatomic) NSString *strProvinceVariantLeadCount;
@property (strong,nonatomic) NSString *strProvinceVariantLeadCountRanking;
@property (strong,nonatomic) NSString *strProvinceVariantSoldLeadCount;
@property (strong,nonatomic) NSString *strProvinceVariantSoldLeadCountRanking;
@property (strong,nonatomic) NSString *strProvinceModelLeadCount;
@property (strong,nonatomic) NSString *strProvinceModelLeadCountRanking;
@property (strong,nonatomic) NSString *strProvinceModelSoldLeadCount;
@property (strong,nonatomic) NSString *strProvinceModelSoldLeadCountRanking;

//National
@property (strong,nonatomic) NSString *strNationalVariantLeadCount;
@property (strong,nonatomic) NSString *strNationalVariantLeadCountRanking;
@property (strong,nonatomic) NSString *strNationalVariantSoldLeadCount;
@property (strong,nonatomic) NSString *strNationalVariantSoldLeadCountRanking;
@property (strong,nonatomic) NSString *strNationalModelLeadCount;
@property (strong,nonatomic) NSString *strNationalModelLeadCountRanking;
@property (strong,nonatomic) NSString *strNationalModelSoldLeadCount;
@property (strong,nonatomic) NSString *strNationalModelSoldLeadCountRanking;







@end
