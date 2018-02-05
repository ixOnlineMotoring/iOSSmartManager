//
//  SMVINLookupObject.h
//  SmartManager
//
//  Created by Priya on 17/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMVINLookupObject : NSObject


@property(strong, nonatomic)NSString* Entry0 ;
@property(strong, nonatomic)NSString* Entry1 ;
@property(strong, nonatomic)NSString* Entry2 ;
@property(strong, nonatomic)NSString* Entry3;
@property(strong, nonatomic)NSString* Entry4 ;
@property(strong, nonatomic)NSString* Registration ;
@property(strong, nonatomic)NSString* Entry6 ;
@property(strong, nonatomic)NSString* Shape ;
@property(strong, nonatomic)NSString* Make ;
@property(strong, nonatomic)NSString* Model ;
@property(strong, nonatomic)NSString* variant ;
@property(strong, nonatomic)NSString* Colour ;
@property(strong, nonatomic)NSString* VIN;
@property(strong, nonatomic)NSString* EngineNo ;
@property(strong, nonatomic)NSString* DateExpires;
@property(strong, nonatomic)NSString* savedScanID;
@property(strong, nonatomic)NSString* geoLocationAddress;
@property(strong, nonatomic)NSString* strYear ;
@property(strong, nonatomic)NSString* strKiloMeters;
@property(strong, nonatomic)NSString* strExtras;
@property(strong, nonatomic)NSString* strCondition;
@property(strong, nonatomic)NSString* strVariantName;
@property(strong, nonatomic)NSString* strScannedDate;

// for expanded condition of 4 tcok marks

@property(assign)BOOL checkBox1; // Don't Let override info // IgnoreSetting Flag From Web Service
@property(assign)BOOL checkBox2; // Ignore Exclude Setting // Override flag form web service
@property(assign)BOOL checkBox3; // Activate CPA error // showErrorDisclaimer from web service
@property(assign)BOOL checkBox4; // Remove Vehicle // Is deleted flag

// other informations
@property(strong, nonatomic)NSString* strLocation;
@property(strong, nonatomic)NSString* oemNo;
@property(strong, nonatomic)NSString* regNumber;
@property(strong, nonatomic)NSString* internalNote;
@property(strong, nonatomic)NSString* trim;
@property(strong, nonatomic)NSString* costR;
@property(strong, nonatomic)NSString* standR;
@property(assign)BOOL isEditable;


@end
