//
//  SMExteriorReconditioning.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 11/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMExteriorReconditioning : NSObject

@property(strong,nonatomic) NSString *strExteriorTypeID;
@property(strong,nonatomic) NSString *strPriceValue;
@property(strong,nonatomic) NSString *strExteriorType;
@property(assign) BOOL isRepairSelected;
@property(assign) BOOL isPriceSelected;
@property(assign) int intPrice;
@property(strong,nonatomic) NSString *strBase64Image;
@end
