//
//  SMVINScanModelObject.h
//  SmartManager
//
//  Created by Priya on 18/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMVINScanModelObject : NSObject
@property(strong, nonatomic)NSString* strExisting ;
@property (nonatomic) BOOL  strHasModel ;
@property(strong, nonatomic)NSString* strMinYear ;
@property(strong, nonatomic)NSString* strMaxYear ;

@property(strong, nonatomic)NSString* strModelId ;
@property(strong, nonatomic)NSString* strModelName;
@property(strong, nonatomic)NSString* strModelMinYear ;
@property(strong, nonatomic)NSString* strModelMaxYear ;
@end
