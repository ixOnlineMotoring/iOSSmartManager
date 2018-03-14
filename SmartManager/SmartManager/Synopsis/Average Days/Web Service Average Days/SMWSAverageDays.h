//
//  SMWSAverageDays.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 17/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMObjectAverageDaysXml.h"
#import "SMCommonClassMethods.h"
#import "SMObjectAverageDays.h"
@interface SMWSAverageDays : NSObject<NSXMLParserDelegate>

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMObjectAverageDaysXml *objSMObjectAverageDaysXml))successResponse
                              andError:(void(^)(NSError *error))failureResponse;
@end
