//
//  SMLoadVehiclesObject.h
//  SmartManager
//
//  Created by Priya on 15/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMLoadVehiclesObject : NSObject
@property(strong, nonatomic) NSString *strMakeName;
@property(strong, nonatomic) NSString *strMakeId;
@property(strong, nonatomic) NSString *strMeanCodeNumber;
@property(strong, nonatomic) NSString *strPrice;
@property(strong, nonatomic) NSString *strMakeYear;
@property(strong, nonatomic) NSString *strMaxYear;
@property(strong, nonatomic) NSString *strMinYear;
@property(assign) BOOL isEBrochureFlag;
@end
