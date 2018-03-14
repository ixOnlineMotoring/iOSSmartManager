//
//  SMAttributeStringFormatObject.m
//  Smart Manager
//
//  Created by Sandeep on 31/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMAttributeStringFormatObject.h"
#import "SMDropDownObject.h"





@implementation SMAttributeStringFormatObject

+ (SMAttributeStringFormatObject *) sharedService
{
    static SMAttributeStringFormatObject *webService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webService = [[self alloc] init];
    });
    return webService;
}
#pragma mark - Set Attributed Text

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];

    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];

    // Create the attributes

    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];




    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];





    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",firstText]
                                                                                           attributes:FirstAttribute];



    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];





    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
{
    UIFont *regularFont;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];

    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    //UIColor *foregroundColorGreen = [UIColor colorWithRed:64.0/255.0 green:198.0/255.0 blue:42.0/255.0 alpha:1.0];


    // Create the attributes

    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];




    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];

    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorBlue, NSForegroundColorAttributeName, nil];



    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];



    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ |",secondText]
                                                                                             attributes:SecondAttribute];



    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",thirdText]
                                                                                            attributes:ThirdAttribute];



    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];


}

-(void)setAttributedTextForVehicleNameWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    //UIColor *foregroundColorGreen = [UIColor colorWithRed:64.0/255.0 green:198.0/255.0 blue:42.0/255.0 alpha:1.0];
    
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    
    
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

-(void)setAttributedTextForChangeVehicleSectionWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
{
    UIFont *regularFont;
     UIFont *smallFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        smallFont =   [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
    }
    else
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        smallFont =   [UIFont fontWithName:FONT_NAME_BOLD size:17.0];
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    //UIColor *foregroundColorGreen = [UIColor colorWithRed:64.0/255.0 green:198.0/255.0 blue:42.0/255.0 alpha:1.0];
    
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    smallFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    
    
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}


-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText forLabel:(UILabel*)label
{
    NSLog(@"price1 = %@",secondText);
    NSLog(@"price2 = %@",fourthText);

    UIFont *valueFont;
    UIFont *titleFont;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:10.0];

    }

    else
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    }

    UIColor *foregroundColorWhite = [UIColor whiteColor];

    UIColor *foregroundColorYellow = [UIColor colorWithRed:187.0/255.0 green:140.0/255.0 blue:20.0/255.0 alpha:1.0];

    // Create the attributes

    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];




    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];

    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];

    NSDictionary *FourthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorYellow, NSForegroundColorAttributeName, nil];




    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",firstText]
                                                                                           attributes:FirstAttribute];



    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",secondText]
                                                                                             attributes:SecondAttribute];



    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@:",thirdText]
                                                                                            attributes:ThirdAttribute];

    NSMutableAttributedString *attributedFourthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",fourthText]
                                                                                             attributes:FourthAttribute];



    [attributedThirdText appendAttributedString:attributedFourthText];
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];


}

-(void)setAttributedTextForPricingwithTitle:(NSString*)firstText andwithDetail:(NSString*)secondText forLabel:(UILabel*)label{
    
    UIFont *regularFont,*regularFontBold;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
    else
        regularFont = [UIFont fontWithName:FONT_NAME size:20.0];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFontBold = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
    else
        regularFontBold = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    //UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFontBold, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
    
    
}

-(void)setAttributedTextForVehicleDetailsWithFirstTextPricing:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont,*regularFontBold;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
    else
        regularFont = [UIFont fontWithName:FONT_NAME size:20.0];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFontBold = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
    else
        regularFontBold = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    //UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFontBold, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

-(void)setAttributedTextForVehiclePricesWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText andWithFifthText:(NSString*)fifthText andWithSixthText:(NSString*)sixthText andWithSeventhText:(NSString*)seventhText andWithEighthText:(NSString*) eighthText forLabel:(UILabel*)label
{
    UIFont *valueFont;
    UIFont *titleFont;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:11.0];
        
    }
    else
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorGreen = [UIColor colorWithRed:62.0/255.0 green:211.0/255.0 blue:22.0/255.0 alpha:1.0];
    UIColor *foregroundColorYellow = [UIColor colorWithRed:187.0/255.0 green:140.0/255.0 blue:20.0/255.0 alpha:1.0];
    UIColor *foregroundColorViolet = [UIColor colorWithRed:135.0/255.0 green:67.0/255.0 blue:198.0/255.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorGreen, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FourthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     titleFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FifthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorYellow, NSForegroundColorAttributeName, nil];
    
    NSDictionary *SixthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *SeventhAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                      titleFont, NSFontAttributeName,
                                      foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *EighthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorViolet, NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    NSMutableAttributedString *attributedFourthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",fourthText]
                                                                                             attributes:FourthAttribute];
    
    NSMutableAttributedString *attributedFifthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",fifthText]
                                                                                            attributes:FifthAttribute];
    
    NSMutableAttributedString *attributedSixthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",sixthText]
                                                                                            attributes:SixthAttribute];
    
    NSMutableAttributedString *attributedSeventhText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",seventhText]
                                                                                              attributes:SeventhAttribute];
    
    NSMutableAttributedString *attributedEighthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",eighthText]
                                                                                             attributes:EighthAttribute];
    
    
    [attributedSeventhText appendAttributedString:attributedEighthText];
    [attributedSixthText appendAttributedString:attributedSeventhText];
    [attributedFifthText appendAttributedString:attributedSixthText];
    [attributedFourthText appendAttributedString:attributedFifthText];
    [attributedThirdText appendAttributedString:attributedFourthText];
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}


+(NSMutableArray *)getDropDownArray:(NSMutableArray *)array{
    NSMutableArray *arrmYearDropDown = [[NSMutableArray alloc] init];
    for(int i=0;i<array.count;i++)
    {
        SMDropDownObject *objCondition = [[SMDropDownObject alloc] init];
        objCondition.strMakeId = [NSString stringWithFormat:@"%d",i+1];
        objCondition.strMakeName = [array objectAtIndex:i];
        [arrmYearDropDown addObject:objCondition];
    }
    return arrmYearDropDown;
}

+ (NSMutableArray *)getYear
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    int year = (int)[components year];
    NSMutableArray   *yearArray=[[NSMutableArray alloc]init];
    //[self.txtYear setText:[NSString stringWithFormat:@"%d",year]];
    for (int i=year; i>=1990; i--)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    NSMutableArray *arrmYearDropDown = [[NSMutableArray alloc] init];
    arrmYearDropDown = [self getDropDownArray:yearArray];
    return arrmYearDropDown;
}

+(void) handleWebServiceErrorForCode:(int)iStauts ForViewController:(UIViewController *)vcCurrent withGOBack:(BOOL)isBack{
 
    

    switch (iStauts) {
        case kWSCrash:
        {
            if (isBack) {
                [SMAttributeStringFormatObject showAlertWebServicewithMessage:KWSCrashMessage ForViewController:vcCurrent];
            }else{
            SMAlert(kTitle, KWSCrashMessage);
            }
        }
            break;
            
        case kWSNoRecord:
        {
            if (isBack) {
                 [SMAttributeStringFormatObject showAlertWebServicewithMessage:KNorecordsFousnt ForViewController:vcCurrent];
            }else{
                SMAlert(kTitle, KNorecordsFousnt);
            }
        }
            break;
            
        case kWSError:
        {
            if (isBack) {
                [SMAttributeStringFormatObject showAlertWebServicewithMessage:KNorecordsFousnt ForViewController:vcCurrent];
            }else{
                SMAlert(kTitle, KNorecordsFousnt);
            }
        }
            break;
       
        case kWSNOGroupIdFound:
        {
            if (isBack) {
               [SMAttributeStringFormatObject showAlertWebServicewithMessage:KNoGroupDataFound ForViewController:vcCurrent];
            }else{
                SMAlert(kTitle, KNoGroupDataFound);
            }
        }
            break;
            
        case kWSNOVINNoFound:
        {
            if (isBack) {
               [SMAttributeStringFormatObject showAlertWebServicewithMessage:kNOVINPresent ForViewController:vcCurrent];
            }else{
                SMAlert(kTitle, kNOVINPresent);
            }
        }
            break;
            
        default:
            break;
    }

}

+(void) showAlertWebServicewithMessage:(NSString *)strAlertMessage ForViewController:(UIViewController *)vcCurrent{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:kTitle
                                  message:strAlertMessage  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Ok"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [vcCurrent.navigationController popViewControllerAnimated:YES];
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    [vcCurrent presentViewController:alert animated:YES completion:nil];
    
}

+(void)setButtonUnderlineText:(NSString *)strText forButton:(UIButton* ) btn{
    
    NSDictionary *attrDict;
    ifIphone{
        attrDict= @{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_BOLD size:13.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:52.0/255.0f green:118.0/255.0f blue:190.0/255.0f alpha:1.0]};
    }else{
        attrDict= @{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_BOLD size:15.0f],NSForegroundColorAttributeName : [UIColor colorWithRed:52.0/255.0f green:118.0/255.0f blue:190.0/255.0f alpha:1.0]};
    }
    NSMutableAttributedString *title =[[NSMutableAttributedString alloc] initWithString:strText attributes: attrDict];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0,[strText length])];
    [btn setAttributedTitle:title forState:UIControlStateNormal];
    
}
+(void)setAttributedTextLeadDetailBlueColourWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | ",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

+(void)setAttributedTextLeadDetailRedColourWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText withSize:(CGFloat) size forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:size];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:size+4.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorred = [UIColor redColor];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorred, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

+(void)setAttributedTextLeadDetailWhiteColourWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorred = [UIColor redColor];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",firstText]
                                                                                           attributes:FirstAttribute];
    
    NSMutableAttributedString *attributedSecondText;
    if (secondText.length == 0) {
        attributedSecondText   = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"| email?"]
                                                                        attributes:SecondAttribute];
        
    }
    else{
        attributedSecondText   = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"| %@",secondText]
                                                                        attributes:SecondAttribute];
        
    }
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

+(void)setAttributedTextLeadPoolHeaderFullColourWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    UIFont *regularFontFirstText;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFontFirstText = [UIFont fontWithName:FONT_NAME_BOLD size:13.0f];
    else
        regularFontFirstText = [UIFont fontWithName:FONT_NAME_BOLD size:18.0f];
    
    //UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorred = [UIColor redColor];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFontFirstText, NSFontAttributeName,
                                    foregroundColorred, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorred, NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}
+(void)setButtonUnderlineText:(NSString *)strText withColour:(UIColor *)color forButton:(UIButton *) btn {
    
    NSDictionary *attrDict;
    ifIphone{
        attrDict= @{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_BOLD size:13.0f],NSForegroundColorAttributeName : color};
    }else{
        attrDict= @{NSFontAttributeName : [UIFont fontWithName:FONT_NAME_BOLD size:15.0f],NSForegroundColorAttributeName : color};
    }
    NSMutableAttributedString *title =[[NSMutableAttributedString alloc] initWithString:strText attributes: attrDict];
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0,[strText length])];
    [btn setAttributedTitle:title forState:UIControlStateNormal];
    
}

+(NSString*) formatPhoneNumber:(NSString *)phoneNumber
{
    //000 000 0000
    
    NSMutableString *stringts = [NSMutableString stringWithString:phoneNumber];
    if([phoneNumber length] == 10)
    {
        [stringts insertString:@" " atIndex:3];
        [stringts insertString:@" " atIndex:7];
    }
    else if([phoneNumber length] > 10)
    {
        [stringts insertString:@" " atIndex:3];
        [stringts insertString:@" " atIndex:7];
        [stringts insertString:@" " atIndex:11];
    }
    else
    {
        
    }
    
    NSString *formattedString = [NSString stringWithString:stringts];
    return formattedString;
}


+(void)setAttributedTextForDemandLeadsAndSales:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME size:12.0f];
    else
        regularFont = [UIFont fontWithName:FONT_NAME size:15.0f];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    // UIColor *foregroundColorred = [UIColor whiteColor];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSMutableAttributedString *attributedFirstText;
    
    
    if(firstText.length == 0){
        if (label.tag == 1) {
            attributedFirstText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Leads?"]
                                                                         attributes:FirstAttribute];
        }
        else{
            attributedFirstText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Sales?"]
                                                                         attributes:FirstAttribute];
        }
    }
    else{
        attributedFirstText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                     attributes:FirstAttribute];
    }
    
    NSMutableAttributedString *attributedSecondText;
    if (secondText.length == 0) {
        attributedSecondText   = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"/Ranked?"]
                                                                        attributes:SecondAttribute];
        
    }
    else{
        attributedSecondText   = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%@",secondText]
                                                                        attributes:SecondAttribute];
        
    }
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

+(NSString*) setRankingPrefix:(NSString *)strRanking{
    
    NSString *strFinal;
    
    
    if ([strRanking isEqualToString:@""]) {
        strFinal = @"";
    }
    else
    {
        switch ([strRanking intValue]) {
            case 0:{
                strFinal = @"0";
            }
                break;
            case 1:{
                strFinal = @"1st";
            }
                break;
            case 2:{
                strFinal = @"2nd";
            }
                break;
            case 3:{
                strFinal = @"3rd";
            }
                break;
                
            default:{
                strFinal = [NSString stringWithFormat:@"%@th",strRanking];
            }
                break;
        }
    }
    
    return strFinal;
}

+(BOOL) valdateKilometer:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_Number] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
   
    if(newLength>6)
    {
        return (newLength > 6) ? NO : YES;
    }
    else
    {
        return [string isEqualToString:filtered];
    }
}

+(BOOL) valdateTextFeild:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string withValidationType:(NSString *)strType andLimit:(int)iLimit{
    
    if (iLimit == 0) {
        iLimit = 10000;
    }
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:strType] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if(newLength>iLimit)
    {
        return (newLength > iLimit) ? NO : YES;
    }
    else
    {
        return [string isEqualToString:filtered];
    }
}



+(BOOL) valdateExtraAtCost:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
// NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_Number] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
    
//int newLength =(int)textField.text.length;
   

//    if(newLength>0)
//    {
//        return (newLength > 0) ? NO : YES;
//    }
//    else
//    {
//        return [string isEqualToString:filtered];
//    }

}

+(BOOL) valdatePhoneNumber:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int length = [self getLength:textField.text];
    //NSLog(@"Length  =  %d ",length);
    
    if(length == 10)
    {
        if(range.length == 0)
            return NO;
    }
    
    if(length == 3)
    {
        NSString *num = [self formatPhoneNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"%@ ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6)
    {
        NSString *num = [self formatPhoneNumber:textField.text];
        //NSLog(@"%@",[num  substringToIndex:3]);
        //NSLog(@"%@",[num substringFromIndex:3]);
        textField.text = [NSString stringWithFormat:@"%@ %@",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@ %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    
    return YES;
}

+(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    int length = (int)[mobileNumber length];
    
    return length;
}

@end
