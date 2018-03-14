//
//  SMDecoderResultObject.h
//  SmartManager
//
//  Created by Liji Stephen on 04/05/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@class MWResult;

@interface SMDecoderResultObject : NSObject

{
    BOOL succeeded;
    NSString *result;
    MWResult *mwResult;
    
}

@property (nonatomic, assign) BOOL succeeded;
@property (nonatomic, retain) NSString *resultt;
@property (nonatomic, retain) MWResult *result;


+ (SMDecoderResultObject *)shareCommonClassManager;

+(SMDecoderResultObject *)createSuccess:(MWResult *)result;

+(SMDecoderResultObject *)createFailure;


@end
