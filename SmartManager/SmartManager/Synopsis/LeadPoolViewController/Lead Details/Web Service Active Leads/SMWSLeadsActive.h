//
//  SMWSLeadsActive.h
//  Smart Manager
//
//  Created by Ankit S on 8/10/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMObjectActiveLead.h"
#import "SMObjectLeadsActiveXml.h"

@interface SMWSLeadsActive : NSObject<NSXMLParserDelegate>

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMObjectLeadsActiveXml *objSMObjectLeadsActiveXml))successResponse
                              andError:(void(^)(NSError *error))failureResponse;


@end
