//
//  SMWSSimilarVehicle.h
//  Smart Manager
//
//  Created by Ankit S on 6/30/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSimilarVehicleXmlObject.h"

@interface SMWSSimilarVehicle : NSObject<NSXMLParserDelegate>

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMSimilarVehicleXmlObject *objSMSimilarVehicleXmlObject))successResponse
                              andError:(void(^)(NSError *error))failureResponse;

@end
