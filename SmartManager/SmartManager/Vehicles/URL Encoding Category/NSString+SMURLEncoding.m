//
//  NSString+SMURLEncoding.m
//  SmartManager
//
//  Created by Jignesh on 16/12/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "NSString+SMURLEncoding.h"

@implementation NSString (SMURLEncoding)

- (NSString *)urlEncodeUsingEncoding:(CFStringEncoding)encoding
{
    
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)self,
                                                                     NULL,
                                                                     CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                     encoding));
}

- (NSString *)urlEncode
{
    
    return [self urlEncodeUsingEncoding:kCFStringEncodingUTF8];
}


-(NSString *)urlDecoding:(NSString *) urlDecode
{
    
    urlDecode  = (NSMutableString *)[urlDecode stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return urlDecode;
    
}

@end
