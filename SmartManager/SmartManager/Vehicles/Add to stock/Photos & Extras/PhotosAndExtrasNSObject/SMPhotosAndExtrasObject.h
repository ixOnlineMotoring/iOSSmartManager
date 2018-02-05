//
//  SMPhotosAndExtrasObject.h
//  SmartManager
//
//  Created by Sandeep on 04/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMPhotosAndExtrasObject : NSObject
@property(strong,nonatomic)NSString *strVehicleName;
@property(strong,nonatomic)NSString *strUsedYear;
@property(strong,nonatomic)NSString *strRegistration;
@property(strong,nonatomic)NSString *strColour;
@property(strong,nonatomic)NSString *strStockCode;
@property(strong,nonatomic)NSString *strMileage;
@property(strong,nonatomic)NSString *strImageLink;
@property(strong,nonatomic)NSString *strTradePrice;
@property(strong,nonatomic)NSString *strRetailPrice;
@property(strong,nonatomic)NSString *strVehicleType;
@property(strong,nonatomic)NSString *strPriceValue;
@property(strong,nonatomic)NSString *strDays;
@property(strong,nonatomic)NSString *strPhotoCounts;
@property(strong,nonatomic)NSString *strVideosCount;
@property(strong,nonatomic)NSString *strDate;
@property(assign)BOOL strComments;
@property(assign)BOOL strExtras;
@property(strong,nonatomic)NSString *strMakeName;
@property(strong,nonatomic)NSString *strUsedVehicleStockID;

//@property(nonatomic) int strUsedVehicleStockID;
@property(assign)int extrasFlag;
@property(assign)int commentsFlag;
@property(assign)int PhotosCount;
@property(assign)int VideosFlag;
@property(assign)int priceForSorting;
@property(assign)int numOfDaysForSorting;
@property(assign)int mileageForSorting;
@property(assign)int stockIDForSorting;
@property(assign)int variantID;


@property(assign)int photosForSorting;
@property(assign)int commentsForSorting;
@property(assign)int extrasForSorting;
// for list module..

@property(strong,nonatomic)NSString *vinNumber;
@property(strong,nonatomic)NSString *EngineNumber;
@property(strong,nonatomic)NSString *RegNumber;
@property(strong,nonatomic)NSString *oemCode;

@property(strong,nonatomic)NSString *strLocation;
@property(strong,nonatomic)NSString *strTrim;
@property(strong,nonatomic)NSString *strCostR;
@property(strong,nonatomic)NSString *strStandinR;
@property(strong,nonatomic)NSString *internalNote;
@property(assign)BOOL checkBox1;
@property(assign)BOOL checkBox2;
@property(assign)BOOL checkBox3;
@property(assign)BOOL checkBox4;
@property(assign)BOOL isTender;
@property(assign)BOOL istrade;
@property(assign)BOOL isretail;
@property(assign)BOOL override;
@property(assign)BOOL isVehicleProgram;
@property(assign)BOOL isEditable;
@property(assign)int stockID;

@property(strong,nonatomic)NSString *vehicleYear;
@property(strong,nonatomic)NSString *strNotes;
@end
