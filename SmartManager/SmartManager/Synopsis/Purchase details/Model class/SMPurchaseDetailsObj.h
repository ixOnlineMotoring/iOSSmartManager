//
//  SMPurchaseDetailsObj.h
//  Smart Manager
//
//  Created by Ketan Nandha on 22/12/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMPurchaseDetailsObj : NSObject
@property(strong, nonatomic) NSString *strAppraisalID;
@property(strong, nonatomic) NSString *strPurchaseDetailsID;
@property(strong, nonatomic) NSString *strBoughtFrom;
@property(strong, nonatomic) NSString *strDate;
@property(strong, nonatomic) NSString *strFinanceHouse;
@property(strong, nonatomic) NSString *strSettlement;
@property(strong, nonatomic) NSString *strAccountNum;
@property(strong, nonatomic) NSString *strDetails;
@property(strong, nonatomic) NSString *strComments;

@end
