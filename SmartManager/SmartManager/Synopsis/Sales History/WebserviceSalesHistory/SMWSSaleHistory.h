//
//  SMWSSaleHistory.h
//  Smart Manager
//
//  Created by Ankit S on 8/22/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCommonClassMethods.h"
#import "SMObjectSaleHistory.h"
#import "SMSaleHistoryXml.h"
@interface SMWSSaleHistory : NSObject<NSXMLParserDelegate>

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMSaleHistoryXml *objSMSalesHitoryXml))successResponse
                              andError:(void(^)(NSError *error))failureResponse;

@end
