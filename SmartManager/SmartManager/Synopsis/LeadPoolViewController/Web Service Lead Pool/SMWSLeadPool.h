//
//  SMWSLeadPool.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 16/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMObjectLeadPoolXml.h"
#import "SMCommonClassMethods.h"

@interface SMWSLeadPool : NSObject<NSXMLParserDelegate>

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMObjectLeadPoolXml *objSMObjectLeadPoolXml))successResponse
                              andError:(void(^)(NSError *error))failureResponse;
@end
