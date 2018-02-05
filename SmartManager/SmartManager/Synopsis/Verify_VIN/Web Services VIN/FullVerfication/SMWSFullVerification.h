//
//  SMWSFullVerification.h
//  Smart Manager
//
//  Created by Ankit S on 8/29/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCommonClassMethods.h"
#import "SMFullVerificationObjectXML.h"

@interface SMWSFullVerification : NSObject<NSXMLParserDelegate>

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMFullVerificationObjectXML *objSMFullVerificationObjectXML))successResponse
                              andError:(void(^)(NSError *error))failureResponse;

@end

