//
//  SMActiveSpecial.h
//  SmartManager
//
//  Created by Jignesh on 09/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMActiveSpecial : NSObject


@property(strong, nonatomic) NSString *stractiveName;
@property(strong, nonatomic) NSString *stractiveDetails;
@property(strong, nonatomic) NSString *strUsedYear;
@property(strong, nonatomic) NSString *strSpecialID;

@property(strong, nonatomic) NSString *strCurrenUserID;


@property(strong, nonatomic) NSString *strNormalPrice;
@property(strong, nonatomic) NSString *strSpecialPrice;
@property(strong, nonatomic) NSString *strSavePrice;

@property(strong, nonatomic) NSString *strSpecialStartDate;
@property(strong, nonatomic) NSString *strSpecialEndDate;

@property(strong, nonatomic) NSString *strSpecialDetails;
@property(strong, nonatomic) NSString *strSummarySpecial;

@property(strong, nonatomic) NSString *strSpecailImageURL;

@property(strong, nonatomic) NSString *strSpecialCreatedDate;

@property (nonatomic) BOOL isCorrected;
@property(strong, nonatomic) NSString *strType;
@property(strong, nonatomic) NSString *strTypeID;
@property(strong, nonatomic) NSString *strTitle;
@property(strong, nonatomic) NSString *strMakeID;
@property(strong, nonatomic) NSString *strModelID;
@property(strong, nonatomic) NSString *strVariantID;

@property(strong, nonatomic) NSString *strMileage;
@property(strong, nonatomic) NSString *strColor;

// added on 22 Jan 
@property(nonatomic) int ItemID;
@property(nonatomic) BOOL isAllowGroup;
@property(nonatomic) BOOL isDeleted;
@property(nonatomic) BOOL canPublish;
@property(nonatomic) BOOL isExpired;
@property(strong, nonatomic) NSString *strImagePriority;
@property(strong, nonatomic) NSString *strStockCode;
@property(strong, nonatomic) NSString *strItemValue;
@property(strong, nonatomic) NSString *strEndStatus;
@property(strong, nonatomic) NSString *strMakeName;
@property(strong, nonatomic) NSString *strModelName;
@property(strong, nonatomic) NSString *strVariantName;

@property(strong, nonatomic) NSMutableArray *arrmForImage;
@end
