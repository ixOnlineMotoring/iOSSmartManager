//
//  SMWSReviews.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 24/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SMReviewsXmlResultObject.h"
#import "SMCommonClassMethods.h"

@interface SMWSReviews : NSObject<NSXMLParserDelegate>
{
    BOOL isOnlyForDetailPageContent;

}

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMReviewsXmlResultObject *objSMReviewsXmlResultObject))successResponse
                              andError:(void(^)(NSError *error))failureResponse;
@end
