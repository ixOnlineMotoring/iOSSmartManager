//
//  SMCustomColor.m
//  SmartManager
//
//  Created by Jignesh on 07/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomColor.h"
@implementation SMCustomColor



// Use Below Class Fucntion For Setting Blue Color To Button

+(UIColor *)setBlueColorThemeButton
{
    return [self colorWithRed:52.0 green:118.0 blue:190.0 alpha:1.0];
}


// Use Below Class Fucntion For Setting Gray Color To Button

+(UIColor *)setGrayColorThemeButton
{
    return [self colorWithRed:127.0 green:127.0 blue:127.0 alpha:1.0];
}

// this method will return popoverbuttonClearColor
+(UIColor *) setPopOverButtonColor
{
    
    return [UIColor blackColor];
}

// this function will retur blue colore of textfileds which is used in complete application
+(UIColor *) setBackGroundColorForTextView
{
    return [self colorWithRed:24.0 green:85.0 blue:152.0 alpha:1.0];
}

+(UIColor *)setColorYellowishOrange
{
    return [self colorWithRed:211.0 green:138.0 blue:7.0 alpha:1.0];
}

// This method will retun RGB cordinates for UIColor

+(UIColor *)colorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}


// this method has been added by Ketan

// Purpose :  Pass string and it will rettun navigation bar title.
// On class when you need to add navigation bar title just call this method and pass your navigation bar title

+ (UILabel *) setTitle :(NSString *)strText
{
    UILabel *labelforNavigationTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    
    (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? [labelforNavigationTitle setFont:[UIFont fontWithName:FONT_NAME_BOLD size:15.0f]] : [labelforNavigationTitle  setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0f]];
    
    labelforNavigationTitle.backgroundColor = [UIColor clearColor];
    labelforNavigationTitle.textColor = [UIColor whiteColor];
    labelforNavigationTitle.text = strText;
    
    [labelforNavigationTitle sizeToFit];
    
    return labelforNavigationTitle;
}



@end
