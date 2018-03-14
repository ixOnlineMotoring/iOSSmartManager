//
//  Fontclass.h
//  FontAwesomeDemo
//
//  Created by Ketan Nandha on 12/02/15.
//  Copyright (c) 2015 Ketan Nandha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Fontclass : NSObject

+(NSArray*)iconIdentiferArray;
+(NSDictionary*)icons;
+(void)AttributeStringMethodwithFontWithLabel:(UILabel*)label moduleName:(NSString*)strModuleName;
+(void)AttributeStringMethodwithFontWithButton:(UIButton*)button iconID:(int)iconID;
+(void)AttributeStringMethodwithFontWithButtonForLogin:(UIButton*)button iconID:(int)iconID;

+(void)ButtonWithAttributedFont:(UIButton*)button iconID:(int)iconID;
+(void)AttributeStringMethodwithFontWithLabelForLogin:(UILabel*)label iconID:(int)iconID;
@end
