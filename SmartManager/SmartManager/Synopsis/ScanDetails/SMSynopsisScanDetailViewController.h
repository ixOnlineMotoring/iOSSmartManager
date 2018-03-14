//
//  SMSynopsisScanDetailViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 18/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMVINLookupObject.h"
#import "SMCustomTextFieldForDropDown.h"
#import "SMDropDownObject.h"
#import "MBProgressHUD.h"
#import "SMLoadVehiclesObject.h"
#import "SMVINScanDetailsObject.h"
#import "SMVINScanModelObject.h"
#import "UIBAlertView.h"
#import "SMDropDownObject.h"
#import "SMCustomButtonGrayColor.h"

@interface SMSynopsisScanDetailViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate,NSXMLParserDelegate>
{
    
    NSMutableArray *yearArray;
    NSMutableArray *makeArray;
    NSMutableArray *modelArray;
    NSMutableArray *variantArray;
    NSArray *arrayOfConditionOptions;
    NSMutableArray *VINDetailArray;
    NSMutableArray *stockArray;
    
    SMLoadVehiclesObject        *loadVehiclesObject;
    SMDropDownObject            *modelDropdownObj;
    NSMutableString *currentNodeContent;
    //---web service access---
    NSMutableString *soapResults;
    //---xml parsing---
    NSXMLParser *xmlParser;
    NSString *selectedYear;
    
    BOOL isStartYear;
    BOOL strHasModel;
    BOOL isExisiting;
    BOOL isModelText;
    
    int MaximumYear;
    int MinimumYear;
    int selectedType;

    int selectedMakeId;
    int selectedModelId;
    int selectedVariantId;
     NSString *selectedVariant;
     SMVINScanDetailsObject *VINScanDetailsObject;
     SMVINScanModelObject *vinScanModelObject;
    
    __weak IBOutlet UILabel *lblKilometers;
    
    __weak IBOutlet UILabel *lblExtrasCost;
    
    __weak IBOutlet UILabel *lblCondition;
    
    IBOutlet SMCustomButtonGrayColor *btnSaveForLater;
    
    
    __weak IBOutlet UIView *viewHoldingBottomFields;
    
}

@property (strong,nonatomic) SMVINLookupObject * VINLookupObject;
@property (assign) BOOL isFromScanPage;

@end
