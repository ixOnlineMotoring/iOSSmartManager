//
//  SMTradeSettingsObject.h
//  Smart Manager
//
//  Created by Prateek Jain on 07/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMTradeSettingsObject : NSObject

@property(nonatomic,strong)NSString *tradeSettingsID;
@property(nonatomic,strong)NSString *tradePeriod;
@property(assign)BOOL tradeAuctionAccess;
@property(assign)BOOL tradeTenderAccess;
@property(nonatomic,strong)NSString *tradeClientID;
@property(nonatomic,strong)NSString *tradeClientName;
@property(nonatomic,strong)NSString *tradeClientType;
@property(nonatomic,strong)NSString *tradeClientTypeID;

@end
