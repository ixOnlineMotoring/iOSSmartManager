//
//  SMCommonClassMethods.m
//  SmartManager
//
//  Created by Sandeep on 12/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMCommonClassMethods.h"


@implementation SMCommonClassMethods

static SMCommonClassMethods *sharedMyManager = nil;

+(SMCommonClassMethods *)shareCommonClassManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(NSString *)priceConvertCurrencyEn_AF:(NSString *)tempString
{
    NSNumberFormatter *Dformatter = [NSNumberFormatter new];
    Dformatter.currencyCode       = @"R";
    Dformatter.numberStyle        = NSNumberFormatterCurrencyStyle;
    Dformatter.locale             = [NSLocale localeWithLocaleIdentifier:@"en_AF"];
    
    NSString *string  = [[[[[Dformatter stringFromNumber:[NSNumber numberWithFloat:tempString.floatValue]] componentsSeparatedByString:@"."] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@" "] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

-(NSString *)mileageConvertEn_AF:(NSString *)tempString
{
    NSNumberFormatter *Dformatter = [NSNumberFormatter new];
    Dformatter.currencyCode       = @" ";
    Dformatter.numberStyle        = NSNumberFormatterCurrencyStyle;
    Dformatter.locale             = [NSLocale localeWithLocaleIdentifier:@"en_AF"];
    
    NSString *string  = [[[[[Dformatter stringFromNumber:[NSNumber numberWithFloat:tempString.floatValue]] componentsSeparatedByString:@"."] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@" "] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

- (NSString *)flattenHTMLWithOnlyWhiteColor:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        if([text containsString:@"#444444"])
           html = [html stringByReplacingOccurrencesOfString:@"#444444" withString:@"#FFFFFF"];
         else if([text containsString:@"#797C84"])
           html = [html stringByReplacingOccurrencesOfString:@"#797C84" withString:@"#FFFFFF"];
         else if([text containsString:@"#797c84"])
             html = [html stringByReplacingOccurrencesOfString:@"#797c84" withString:@"#FFFFFF"];
         else if([text containsString:@"#a3a4a7"])
             html = [html stringByReplacingOccurrencesOfString:@"#a3a4a7" withString:@"#FFFFFF"];
       
    }
   // html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

- (UIImage*)getImageFromPathImage:(NSString*)imageName1
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageName1]];
    
    return [UIImage imageWithContentsOfFile:fullPathOfImage];
}




- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat boundHeight;
    
    boundHeight = bounds.size.height;
    bounds.size.height = bounds.size.width;
    bounds.size.width = boundHeight;
    transform = CGAffineTransformMakeScale(-1.0, 1.0);
    transform = CGAffineTransformRotate(transform, M_PI / 2.0); //use angle/360 *MPI
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (NSString *)embedYouTube:(NSString*)videoIdentifier webViewWidth:(float)width webViewheight:(float)height
{
    NSString* embedHTML = @"<iframe width=\"83\" height=\"68\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>";
    
    NSString* html = [NSString stringWithFormat:embedHTML, videoIdentifier];

    
    return [html copy];
}

- (NSString*) customDateFormatFunctionWithDate:(NSString *)receivedDate withFormat:(int)iDate
{
    if ([receivedDate isKindOfClass:[NSNull class]]) {
        return @"";
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    switch (iDate)
    {
        case 3:
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
            break;
            
        case 2:
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.S"];
            break;
            
        case 1:
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            break;
        case 4:{
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            
            NSDate *date = [dateFormat dateFromString:receivedDate];
            
            NSDateFormatter *dateFormatOut = [[NSDateFormatter alloc] init] ;
            [dateFormatOut setDateFormat:@"yyyy"];
            //    [dateFormatOut setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            receivedDate = [dateFormatOut stringFromDate:date];
            return receivedDate;

        }
        case 5:{
            [dateFormat setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
            
            NSDate *date = [dateFormat dateFromString:receivedDate];
            
            NSDateFormatter *dateFormatOut = [[NSDateFormatter alloc] init] ;
            [dateFormatOut setDateFormat:@"dd-MM-yyyy"];
            //    [dateFormatOut setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            receivedDate = [dateFormatOut stringFromDate:date];
            return receivedDate;
            
        }
            
            break;

        case 6:{
            [dateFormat setDateFormat:@"yyyy mm dd hh:mm:ss"];
            
            NSDate *date = [dateFormat dateFromString:receivedDate];
            
            NSDateFormatter *dateFormatOut = [[NSDateFormatter alloc] init] ;
            [dateFormatOut setDateFormat:@"EEE dd MMM yyyy HH:mm a"];
            //    [dateFormatOut setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            receivedDate = [dateFormatOut stringFromDate:date];
            return receivedDate;
            
        }
            
            break;
        case 7:{
            [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
            
            NSDate *date = [dateFormat dateFromString:receivedDate];
            
            NSDateFormatter *dateFormatOut = [[NSDateFormatter alloc] init] ;
            [dateFormatOut setDateFormat:@"dd MMM yyyy"];
            //    [dateFormatOut setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            receivedDate = [dateFormatOut stringFromDate:date];
            return receivedDate;
            
        }
            
            break;

        default:
            break;
    }

    NSDate *date = [dateFormat dateFromString:receivedDate];
    
    NSDateFormatter *dateFormatOut = [[NSDateFormatter alloc] init] ;
    [dateFormatOut setDateFormat:@"dd MMM yyyy"];
    //    [dateFormatOut setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    receivedDate = [dateFormatOut stringFromDate:date];
    return receivedDate;
}



+(void)setDeviceToken:(NSString *)deviceToken
{
    
    [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:@"kDeviceTokenForSmartManager"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+(NSString *)getDeviceToken
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"kDeviceTokenForSmartManager"];
}

- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(MyRSAPickerView *)getMyRSAPickerViewObj
{
    NSArray *arrMyRSAAlertView = [[NSBundle mainBundle]loadNibNamed:@"MyRSAPickerView" owner:self options:nil];
    
    MyRSAPickerView *picker = [arrMyRSAAlertView objectAtIndex:0];
    
    return picker;
}

@end
