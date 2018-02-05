//
//  SMTradeMembersObject.h
//  Smart Manager
//
//  Created by Sandeep on 17/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMTradeMembersObject : NSObject
@property (assign, nonatomic)NSInteger ID;
@property (assign, nonatomic)NSInteger memberID;
@property (strong, nonatomic)NSString *memberNameString;
@property (assign, nonatomic)BOOL tradeBuyBoolValue;
@property (assign, nonatomic)BOOL tradeSellBoolValue;
@property (assign, nonatomic)BOOL tenderAcceptBoolValue;
@property (assign, nonatomic)BOOL tenderDeclineBoolValue;
@property (assign, nonatomic)BOOL tenderManagerBoolValue;
@property (assign, nonatomic)BOOL tenderAuditorBoolValue;
@end
