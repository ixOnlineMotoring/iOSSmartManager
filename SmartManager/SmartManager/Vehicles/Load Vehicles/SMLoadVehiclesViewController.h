//
//  SMLoadVehiclesViewController.h
//  SmartManager
//
//  Created by Priya on 15/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "SMLoadVehiclesObject.h"
#import "SMLoadVehiclesDetailsObject.h"
#import "SMVINLookUpViewController.h"
#import "SMAddToStockViewController.h"
#import "MBProgressHUD.h"
#import "SMCustomLable.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomButtonGrayColor.h"
#import "SMPopOverButtons.h"
//#import "Constant.h"
@interface SMLoadVehiclesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,NSXMLParserDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *yearArray;
    NSMutableArray *makeArray;
    NSMutableArray *modelArray;
    NSMutableArray *variantArray;
    
    // this will store index
    int selectedMakeIndex;
    int selectedModelIndex;
    int selectedVariantsIndex;
    
    NSString *strPickerValue;
    NSString *strSelectedMakeId;
    NSString *strSelectedVarinatName;
    
    kListSelectionType selectedType;
    int selectedMakeId;
    int selectedModelId;
    int selectedVariantId;
    NSString *selectedMeanCode;
    
    
    
    SMLoadVehiclesObject        *loadVehiclesObject;
    SMLoadVehiclesDetailsObject *loadVehiclesDetailsObject;
    
    MBProgressHUD *HUD;
    
    IBOutlet UIButton *setButton;
    IBOutlet UIButton *downArrowButton1;
    IBOutlet UIButton *downArrowButton2;
    IBOutlet UIButton *downArrowButton3;
    IBOutlet UIButton *downArrowButton4;
    IBOutlet UIButton *downArrowButton5;

    IBOutlet UIView *popupView;
    IBOutlet UIView *pickerView;

    IBOutlet UITableView *loadVehicleTableView;
    IBOutlet UIPickerView *yearPickerView;
    
    NSMutableString *currentNodeContent;
        //---web service access---
    NSMutableString *soapResults;
    //---xml parsing---
    NSXMLParser *xmlParser;
    
}

@property(weak, nonatomic)  IBOutlet UITextField  *txtYear;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtMake;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtModel;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtVariants;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtVINScan;


@property(weak, nonatomic)IBOutlet SMCustomLable *lblOr;
@property(weak, nonatomic)IBOutlet SMCustomLable *lblYear;
@property(weak, nonatomic)IBOutlet SMCustomLable *lblMake;
@property(weak, nonatomic)IBOutlet SMCustomLable *lblModel;
@property(weak, nonatomic)IBOutlet SMCustomLable *lblVariants;



@property(weak, nonatomic) IBOutlet SMCustomButtonBlue      *nextButton;
@property(weak, nonatomic) IBOutlet SMCustomButtonGrayColor *clearButton;


@property(strong, nonatomic) IBOutlet UIView        *cancelButtonView;


@property(strong, nonatomic)  IBOutlet SMPopOverButtons         *cancelButtons;
@property(strong, nonatomic)  IBOutlet SMPopOverButtons         *cancelButtonList;



-(IBAction)btnClearDidClicked:(id)sender;
-(IBAction)btnNextDidClicked:(id)sender;
-(IBAction)btnCancelDidClicked:(id)sender;

@end
