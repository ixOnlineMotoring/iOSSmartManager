//
//  SMSynopsisVerifyVINViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 19/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomButtonGrayColor.h"
#import "MBProgressHUD.h"
#import "SMCustomLabelAutolayout.h"
#import "SMCustomTextField.h"

@interface SMSynopsisVerifyVINViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate,NSXMLParserDelegate>
{
    BOOL isChangeModelVariantButtonExpanded;
    BOOL isVINVerificationButtonExpanded;
    BOOL isFullVerificationButtonExpanded;
    BOOL isYearValueChanged;
    
    BOOL isBlueButtonClicked;
    BOOL isYellowButtonClicked;
    
    
    IBOutlet UILabel *lblBottomSectionTitle;
    
    IBOutlet UIButton *btnFullVerification;
    
    
    IBOutlet UILabel *lblNoRecord;
    
    IBOutlet UIView *viewBottomHeaders;
    
    IBOutlet UIImageView *imgViewArrow1;
    IBOutlet UIImageView *imgViewArrow2;
    
    IBOutlet SMCustomTextField *txtVinNumber;
    NSMutableString *currentNodeContent;
    //---web service access---
    NSMutableString *soapResults;
    //---xml parsing---
    NSXMLParser *xmlParser;
    
    int selectedMakeId;
    int selectedModelId;
    NSString *selectedYear;

    IBOutlet NSLayoutConstraint *heightConstraintForVINVerification;

    IBOutlet NSLayoutConstraint *heightConstraintForFullVerification;
}

@property (strong, nonatomic) IBOutlet SMCustomLabelAutolayout *lblMainVehicleName;
@property(strong, nonatomic) NSString *strMainVehicleName;
@property(strong, nonatomic) NSString *strMainVehicleYear;
@property(assign)int strSelectedMakeID;
@property(assign)int strSelectedModelID;
@property(assign)int strSelectedVariantID;
@property(strong, nonatomic) NSString *strSelectedVINNumber;
@property(strong, nonatomic) NSString *strSelectedKiloMeters;
@property(strong, nonatomic) NSString *strSelectedExtrasCost;
@property(strong, nonatomic) NSString *strSelectedCondition;
@property(strong, nonatomic) NSString *strSelectedMMCode;
@property(strong, nonatomic) NSString *strSelectedRegNo;
@property(assign) int previousPageNumber; // 1 - Summary page, 2 - VehicleLookup Page, 3 - VehicleCode page

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtRegNo;

- (IBAction)btnFullVerificationDidClicked:(id)sender;
- (IBAction)btnVINVerificationButtonDidClicked:(id)sender;
- (IBAction)btnBackToSummaryDidClicked:(id)sender;

- (IBAction)btnBlueVerifyVinDidClicked:(id)sender;

- (IBAction)btnYellowFullVerificationDidClicked:(id)sender;
@end
