//
//  SMWSVINVerification.h
//  Smart Manager
//
//  Created by Ankit S on 8/31/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCommonClassMethods.h"
#import "SMVINVerificationXml.h"

@interface SMWSVINVerification : NSObject<NSXMLParserDelegate>

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMVINVerificationXml *objSMVINVerificationXml))successResponse
                              andError:(void(^)(NSError *error))failureResponse;

@end