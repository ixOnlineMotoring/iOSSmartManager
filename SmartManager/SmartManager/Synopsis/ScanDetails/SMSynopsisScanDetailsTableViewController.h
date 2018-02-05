//
//  SMSynopsisScanDetailsTableViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 22/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
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

@interface SMSynopsisScanDetailsTableViewController : UITableViewController <UITextFieldDelegate,MBProgressHUDDelegate,NSXMLParserDelegate>
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
    
     
}

@property (strong,nonatomic) SMVINLookupObject * VINLookupObject;
@property (assign) BOOL isFromScanPage;

@end

