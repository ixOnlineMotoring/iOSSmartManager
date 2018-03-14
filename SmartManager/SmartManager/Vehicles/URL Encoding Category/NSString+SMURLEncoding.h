//
//  NSString+SMURLEncoding.h
//  SmartManager
//
//  Created by Jignesh on 16/12/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SMURLEncoding)
- (NSString *)urlEncodeUsingEncoding:(CFStringEncoding)encoding;
- (NSString *)urlEncode;
-(NSString *)urlDecoding:(NSString *) urlDecode;

@end
