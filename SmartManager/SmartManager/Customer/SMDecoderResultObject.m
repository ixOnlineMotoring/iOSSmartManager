//
//  SMDecoderResultObject.m
//  SmartManager
//
//  Created by Liji Stephen on 04/05/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMDecoderResultObject.h"

@implementation SMDecoderResultObject

static SMDecoderResultObject *sharedMyManager = nil;

+(SMDecoderResultObject *)shareCommonClassManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}



@synthesize succeeded;
//@synthesize result;

+(SMDecoderResultObject *)createSuccess:(MWResult *)result {
    SMDecoderResultObject *obj = [[SMDecoderResultObject alloc] init];
    if (obj != nil) {
        obj.succeeded = YES;
        obj.result = result;
    }
    return obj;
}

+(SMDecoderResultObject *)createFailure {
    SMDecoderResultObject *obj = [[SMDecoderResultObject alloc] init];
    if (obj != nil) {
        obj.succeeded = NO;
        obj.result = nil;
    }
    return obj;
}


@end
