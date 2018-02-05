//
//  SMWSVINHistory.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 02/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMVINHistoryObject.h"
#import "SMVINHistoryXmlResultObject.h"
#import "SMCommonClassMethods.h"

@interface SMWSVINHistory : NSObject<NSXMLParserDelegate>

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMVINHistoryXmlResultObject *objSMVINHistoryXmlResultObject))successResponse
                              andError:(void(^)(NSError *error))failureResponse;
@end
