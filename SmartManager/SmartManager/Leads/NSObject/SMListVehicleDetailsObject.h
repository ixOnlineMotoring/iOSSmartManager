//
//  SMListVehicleDetailsObject.h
//  SmartManager
//
//  Created by Liji Stephen on 13/05/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMListVehicleDetailsObject : NSObject

@property(nonatomic,strong)NSString *leadVehicleType;
@property(assign)BOOL leadVehicleMatched;
@property(nonatomic,strong)NSString *leadVehicleMakeAsked;
@property(nonatomic,strong)NSString *leadVehicleModelAsked;
@property(nonatomic,strong)NSString *leadVehicleYearAsked;
@property(nonatomic,strong)NSString *leadVehicleMileageAsked;
@property(nonatomic,strong)NSString *leadVehicleColorAsked;
@property(nonatomic,strong)NSString *leadVehiclePriceAsked;




@end
