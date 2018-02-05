//
//  SMSVNScanDetailsObject.h
//  SmartManager
//
//  Created by Priya on 17/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMVINScanDetailsObject : NSObject
@property(strong, nonatomic)NSString* strExisting ;
@property (nonatomic) BOOL  strHasModel ;
@property(strong, nonatomic)NSString* strMinYear ;
@property(strong, nonatomic)NSString* strMaxYear ;
@property(strong, nonatomic)NSString* strModelId;

@property(strong, nonatomic)NSString* strVariantsId ;
@property(strong, nonatomic)NSString* strVariantsName;
@property(strong, nonatomic)NSString* strVariantsCode ;
@property(strong, nonatomic)NSString* strVariantsMinYear ;
@property(strong, nonatomic)NSString* strVariantsMaxYear ;
@property(strong, nonatomic)NSString* strVariantsFriendly ;

@end
