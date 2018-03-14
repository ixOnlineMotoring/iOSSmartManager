//
//  SMWSforSummaryDetails.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 12/05/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMOEMSpecsXMLObject.h"
#import "SMOEMSpecsDetails.h"
#import "SMOEMSpecsDetailsSpecification.h"

@interface SMWSforOEMSpecsDetails : NSObject<NSXMLParserDelegate>


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                                   response:(void(^)(SMOEMSpecsXMLObject *objSMOEMSpecsXMLObject))successResponse
                                   andError:(void(^)(NSError *error))failureResponse;
@end