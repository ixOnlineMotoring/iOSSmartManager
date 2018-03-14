//
//  SMWSDemand.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 17/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//


#import "SMObjectDemandXml.h"
#import "SMCommonClassMethods.h"

@interface SMWSDemand : NSObject<NSXMLParserDelegate>

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMObjectDemandXml *objSMObjectDemandXml))successResponse
                              andError:(void(^)(NSError *error))failureResponse;
@end
