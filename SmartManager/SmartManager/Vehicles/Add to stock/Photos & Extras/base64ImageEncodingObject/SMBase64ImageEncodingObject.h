//
//  SMBase64ImageEncodingObject.h
//  SmartManager
//
//  Created by Sandeep on 10/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMBase64ImageEncodingObject : NSObject

+(SMBase64ImageEncodingObject *)shareManager;
- (NSString *)encodeBase64WithData:(NSData *)objData;
@end
