//
//  SMDoAppraisalObject.h
//  Smart Manager
//
//  Created by Ketan Nandha on 26/07/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMDoAppraisalObject : NSObject

@property(nonatomic, strong) NSString *appraisalID;
@property(nonatomic, strong) NSString *appraisalName;
@property(assign) BOOL isSeller;
@property(assign) BOOL isPurchaseDetails;
@property(nonatomic, strong) NSString *appraisalCondition;
@property(nonatomic, strong) NSString *appraisalCreateDate;
@property(nonatomic, strong) NSString *appraisalVehicleExtras;
@property(nonatomic, strong) NSString *appraisalInteriorR;
@property(nonatomic, strong) NSString *appraisalEngineD;
@property(nonatomic, strong) NSString *appraisalExteriorR;
@property(nonatomic, strong) NSString *appraisalValuationStart;
@property(nonatomic, strong) NSString *appraisalValuationEnd;
@end
