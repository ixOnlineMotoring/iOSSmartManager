//
//  SMCustomColor.h
//  SmartManager
//
//  Created by Jignesh on 07/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCustomColor : NSObject

+(UIColor *)setBlueColorThemeButton;

+(UIColor *)setGrayColorThemeButton;

+(UIColor *) setPopOverButtonColor;

+(UIColor *) setBackGroundColorForTextView;

+(UIColor *) setBackGroundColorForTextField;

+(UIColor *)colorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

+ (UILabel *) setTitle :(NSString *)strText;

+(UIColor *)setColorYellowishOrange;

@end
