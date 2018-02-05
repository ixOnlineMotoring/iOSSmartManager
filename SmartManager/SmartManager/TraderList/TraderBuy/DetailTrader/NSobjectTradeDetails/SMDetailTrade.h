//
//  SMDetailTrade.h
//  SmartManager
//
//  Created by Jignesh on 15/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMDetailTrade : NSObject

@property(strong, nonatomic) NSString *strKey;
@property(strong, nonatomic) NSString *strValue;

@property(strong, nonatomic) NSString *strStockNumber;
@property(strong, nonatomic) NSString *strRegisterNumber;
@property(strong, nonatomic) NSString *strVinNumber;

@property(strong, nonatomic) NSString *strComments;
@property(strong, nonatomic) NSString *strExtras;
@property(strong, nonatomic) NSString *strOwnerID;

@property(strong, nonatomic) NSString *strLocation;
@property(strong, nonatomic) NSString *strOwnerName;


@end
