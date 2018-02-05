//
//  SMWSNewsPricePlotter.h
//  Smart Manager
//
//  Created by Ankit S on 6/30/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMNewsPricePlotterXmlObject.h"
@interface SMWSNewsPricePlotter : NSObject<NSXMLParserDelegate>

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMNewsPricePlotterXmlObject *objSMNewsPricePlotterXmlObject))successResponse
                              andError:(void(^)(NSError *error))failureResponse;

@end
