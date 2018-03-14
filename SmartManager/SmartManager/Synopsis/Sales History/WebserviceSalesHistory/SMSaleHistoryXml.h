//
//  SMSaleHistoryXml.h
//  Smart Manager
//
//  Created by Ankit S on 8/22/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSaleHistoryXml : NSObject
@property int iStatus;
@property (strong,nonatomic) NSMutableArray *arrmSalesHistory;
@property(strong,nonatomic) NSString *strAverageStockHolding30Days;
@property(strong,nonatomic) NSString *strAverageStockHolding45Days;
@property(strong,nonatomic) NSString *strAverageStockHolding60Days;
@property(strong,nonatomic) NSString *strAverageSalesPerMonth;
@property(strong,nonatomic) NSString *strInStock;
@end
