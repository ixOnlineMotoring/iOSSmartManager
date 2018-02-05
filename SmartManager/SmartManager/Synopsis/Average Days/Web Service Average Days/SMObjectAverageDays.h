//
//  SMObjectAverageDays.h
//  Smart Manager
//
//  Created by Ankit S on 8/5/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMObjectAverageDays : NSObject
@property(strong,nonatomic) NSString *strVariantName;

@property  int  iClientAverageDays;
@property  int iClientTotalStockMovements;
@property  int iCityAverageDays;
@property  int iCityTotalStockMovements;
@property  int iNationalAverageDays;
@property  int iNationalTotalStockMovements;
@end
