//
//  SMAvaibiltyObject.h
//  Smart Manager
//
//  Created by Ankit S on 8/19/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SMAvaibiltyObject : NSObject
@property(strong,nonatomic) NSString *strVariantName;
@property(strong,nonatomic) NSString *strClientAvailability;
@property(strong,nonatomic) NSString *strGroupAvailability;
@property(strong,nonatomic) NSString *strProvinceAvailability;
@property(strong,nonatomic) NSString *strNationalAvailability;
@end
