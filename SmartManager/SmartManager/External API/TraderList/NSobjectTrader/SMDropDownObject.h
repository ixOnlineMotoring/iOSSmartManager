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
@property(nonatomic) NSNumber *isNumber;
@property(strong, nonatomic) NSString *Results;

@end
