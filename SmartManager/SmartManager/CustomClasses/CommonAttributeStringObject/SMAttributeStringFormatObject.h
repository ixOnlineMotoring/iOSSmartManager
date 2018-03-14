//
//  SMAttributeStringFormatObject.h
//  Smart Manager
//
//  Created by Sandeep on 31/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMCustomPopUpTableView.h"

#define ACCEPTABLE_CHARACTERS      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ACCEPTABLE_CHARACTERS_TRIM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ACCEPTABLE_CHARACTERS_OEM  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ACCEPTABLE_CHARACTERS_Number @"0123456789"

#define kKilometerLimit 6
@interface SMAttributeStringFormatObject : NSObject
+ (SMAttributeStringFormatObject *) sharedService;

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label;

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label;

-(void)setAttributedTextForVehicleNameWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label;

-(void)setAttributedTextForChangeVehicleSectionWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label;

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText forLabel:(UILabel*)label;

-(void)setAttributedTextForPricingwithTitle:(NSString*)firstText andwithDetail:(NSString*)secondText forLabel:(UILabel*)label;

-(void)setAttributedTextForVehicleDetailsWithFirstTextPricing:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label;

-(void)setAttributedTextForVehiclePricesWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText andWithFifthText:(NSString*)fifthText andWithSixthText:(NSString*)sixthText andWithSeventhText:(NSString*)seventhText andWithEighthText:(NSString*) eighthText forLabel:(UILabel*)label;

+(NSMutableArray *)getDropDownArray:(NSMutableArray *)array;
+ (NSMutableArray *)getYear;
+(void) showAlertWebServicewithMessage:(NSString *)strAlertMessage ForViewController:(UIViewController *)vcCurrent;
+(void)setButtonUnderlineText:(NSString *)strText forButton:(UIButton* ) btn;

+(void)setAttributedTextLeadDetailBlueColourWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label;

+(void)setAttributedTextLeadDetailRedColourWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText withSize:(CGFloat) size forLabel:(UILabel*)label;
+(void)setAttributedTextLeadDetailWhiteColourWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label;
+(void)setButtonUnderlineText:(NSString *)strText withColour:(UIColor *)color forButton:(UIButton *) btn;
+(void)setAttributedTextLeadPoolHeaderFullColourWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label;
+(NSString*) formatPhoneNumber:(NSString *)phoneNumber;

+(void)setAttributedTextForDemandLeadsAndSales:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label;
+(NSString*) setRankingPrefix:(NSString *)strRanking;

//+(BOOL) valdateKilometer:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//
//    
//+(BOOL) valdateExtraAtCost:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//
//+(BOOL) valdatePhoneNumber:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
+(void) handleWebServiceErrorForCode:(int)iStauts ForViewController:(UIViewController *)vcCurrent withGOBack:(BOOL)isBack;
+(BOOL) valdateTextFeild:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string withValidationType:(NSString *)strType andLimit:(int)iLimit;

@end
