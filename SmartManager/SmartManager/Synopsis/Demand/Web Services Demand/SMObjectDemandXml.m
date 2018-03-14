//
//  SMObjectDemandXml.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 17/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMObjectDemandXml.h"

@implementation SMObjectDemandXml


-(id) init
{
    if(self=[super init])
    {
        self.strClientName = @"";
        self.strVariantName= @"";
        self.strModelName= @"";
        self.strClientVariantLeadCount= @"";
        self.strClientVariantLeadCountRanking= @"";
        self.strClientVariantSoldLeadCountRanking= @"";
        self.strClientModelLeadCount= @"";
        self.strClientModelLeadCountRanking= @"";
        self.strClientModelSoldLeadCount= @"";
        self.strClientModelSoldLeadCountRanking= @"";
        self.strClientVariantSoldLeadCount= @"";
        
        self.strCityName= @"";
        self.strCityVariantLeadCount= @"";
        self.strCityVariantLeadCountRanking= @"";
        self.strCityVariantSoldLeadCount= @"";
        self.strCityVariantSoldLeadCountRanking= @"";
        self.strCityModelLeadCount= @"";
        self.strCityModelLeadCountRanking= @"";
        self.strCityModelSoldLeadCount= @"";
        self.strCityModelSoldLeadCountRanking= @"";
        
        self.strProvinceName= @"";
        self.strProvinceVariantLeadCount= @"";
        self.strProvinceVariantLeadCountRanking= @"";
        self.strProvinceVariantSoldLeadCount= @"";
        self.strProvinceVariantSoldLeadCountRanking= @"";
        self.strProvinceModelLeadCount= @"";
        self.strProvinceModelLeadCountRanking= @"";
        self.strProvinceModelSoldLeadCount= @"";
        self.strProvinceModelSoldLeadCountRanking= @"";
        
        self.strNationalVariantLeadCount= @"";
        self.strNationalVariantLeadCountRanking= @"";
        self.strNationalVariantSoldLeadCount= @"";
        self.strNationalVariantSoldLeadCountRanking= @"";
        self.strNationalModelLeadCount= @"";
        self.strNationalModelLeadCountRanking= @"";
        self.strNationalModelSoldLeadCount= @"";
        self.strNationalModelSoldLeadCountRanking= @"";

    }
return self;
}

@end
