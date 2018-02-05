//
//  SMListTradePartnersObject.h
//  Smart Manager
//
//  Created by Sandeep on 19/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMListTradePartnersObject : NSObject
@property (assign, nonatomic)int ID;
@property (strong, nonatomic)NSString *nameString;
@property (assign, nonatomic)int settingID;
@property (assign, nonatomic)int traderPeriod;
@property (assign, nonatomic)BOOL auctionAccess;
@property (assign, nonatomic)BOOL tenderAccess;
@property (strong, nonatomic)NSString *typeString;
@property (assign, nonatomic)int typeID;




@end
