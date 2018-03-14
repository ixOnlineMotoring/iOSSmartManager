//
//  SMWSSimpleLogic.h
//  Smart Manager
//
//  Created by Ankit S on 8/9/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCommonClassMethods.h"
#import "SMObjectSimpleLogicXml.h"
@interface SMWSSimpleLogic : NSObject<NSXMLParserDelegate>

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMObjectSimpleLogicXml *objSMObjectSimpleLogicXml))successResponse
                              andError:(void(^)(NSError *error))failureResponse;
@end
