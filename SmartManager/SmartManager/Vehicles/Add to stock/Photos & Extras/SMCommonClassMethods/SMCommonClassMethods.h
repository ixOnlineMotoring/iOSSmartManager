//
//  SMCommonClassMethods.h
//  SmartManager
//
//  Created by Sandeep on 12/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MyRSAPickerView.h"

@interface SMCommonClassMethods : NSObject


+ (SMCommonClassMethods *)shareCommonClassManager;
- (NSString *)priceConvertCurrencyEn_AF:(NSString *)tempString;
- (NSString *)mileageConvertEn_AF:(NSString *)tempString;
- (NSString *)flattenHTML:(NSString *)html;
- (NSString *)flattenHTMLWithOnlyWhiteColor:(NSString *)html;
- (UIImage *)getImageFromPathImage:(NSString*)imageName1;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;
- (NSString *)embedYouTube:(NSString*)url webViewWidth:(float)width webViewheight:(float)height;
- (NSString*) customDateFormatFunctionWithDate:(NSString *)receivedDate withFormat:(int)iDate;

+(void)setDeviceToken:(NSString *)deviceToken;
+(NSString *)getDeviceToken;

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@property(strong, nonatomic) NSString*(^convertDate)(NSString*, int);
-(MyRSAPickerView *)getMyRSAPickerViewObj;

@end
