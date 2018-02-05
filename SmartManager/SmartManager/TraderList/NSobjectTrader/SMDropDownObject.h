//
//  SMDropDownObject.h
//  SmartManager
//
//  Created by Jignesh on 09/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMDropDownObject : NSObject

@property(strong, nonatomic) NSString *strDropDownValue;
@property(strong, nonatomic) NSString *dropDownID;
@property BOOL isSelected;

@property(assign)int strSortTextID;
@property(strong, nonatomic) NSString *strSortText;
@property(assign) BOOL isAscending;
@property(nonatomic) int iWantedSearchID;
@property(nonatomic) int iVariantID;


@property(strong, nonatomic) NSString *FriendlyName;
@property(strong, nonatomic) NSString *YearRange;
@property(strong, nonatomic) NSString *Provinces;
@property(strong, nonatomic) NSString *Results;



////By Ankit
@property(strong, nonatomic) NSString *strMakeName;// for variant name
@property(strong, nonatomic) NSString *strMakeId;
@property(strong, nonatomic) NSString *strMeanCodeNumber;
@property(strong, nonatomic) NSString *strMakeYear;
@property(strong, nonatomic) NSString *strMaxYear;
@property(strong, nonatomic) NSString *strMinYear;
@property(strong, nonatomic) NSString *strColor;
@property(strong, nonatomic) NSString *strVariantId;
@property(strong, nonatomic) NSString *strModelId;
@property(strong, nonatomic) NSString *strStockId;
@property(strong, nonatomic) NSString *strVINNo;
@property(strong, nonatomic) NSString *strRegNo;
@end
