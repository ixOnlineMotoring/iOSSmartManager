//
//  SMListUpdateVariantViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 27/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"
#import "SMCustomTextField.h"
#import "MBProgressHUD.h"
#import "SMLoadVehiclesObject.h"
#import "SMCustomTextFieldForDropDown.h"


@protocol refreshVehicleVairantname <NSObject>

-(void) getRefreshedVairnatName;

@end

@interface SMListUpdateVariantViewController : UIViewController<NSXMLParserDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,MBProgressHUDDelegate>
{

    IBOutlet UIView *popupView;
    NSMutableString *currentNodeContent;
    NSXMLParser *xmlParser;
    
    NSMutableArray *makeArray;
    NSMutableArray *modelArray;
    NSMutableArray *variantArray;

    NSMutableArray *yearArray;
    
    MBProgressHUD *HUD;
    SMLoadVehiclesObject        *loadVehiclesObject;
    
    int selectedType;
    int selectedMakeId;
    int selectedModelId;
    int selectedVariantId;
    
    int selectedMakeIndex;
    int selectedModelIndex;
    int selectedVariantIndex;
    
    NSString *selectedMeanCode;
    NSString *strSelectedVarinatName;
    NSString *strPickerValue;

}


@property (strong, nonatomic) IBOutlet SMCustomLable *lblYear;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblMake;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblModel;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblVariant;


@property (strong, nonatomic) IBOutlet UIView *pickerView;

@property (strong, nonatomic) IBOutlet UIPickerView *yearPickerView;

@property (strong, nonatomic) IBOutlet UITableView *tblViewLoadVarient;


@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldYear;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldMake;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldModel;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldVariant;

@property (strong, nonatomic) IBOutlet UIView *tableParentView;

@property (strong, nonatomic) IBOutlet UIView *cancelButtonView;

@property (strong, nonatomic) IBOutlet UIButton *btnCancelList;


@property (strong, nonatomic) IBOutlet UIButton *btnCancels;

@property (strong, nonatomic) IBOutlet UIButton *btnSet;

@property (nonatomic, weak) id <refreshVehicleVairantname> vehicleListDelegates;

- (IBAction)btnCancelYearDidClicked:(id)sender;

- (IBAction)btnCancelListDidClicked:(id)sender;


@end
