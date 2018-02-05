//
//  SMWSforSummaryDetails.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 12/05/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSynopsisXMLResultObject.h"
@interface SMWSforSummaryDetails : NSObject<NSXMLParserDelegate>


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                                   response:(void(^)(SMSynopsisXMLResultObject *objSMSynopsisXMLResultObject))successResponse
                                   andError:(void(^)(NSError *error))failureResponse;
@end
