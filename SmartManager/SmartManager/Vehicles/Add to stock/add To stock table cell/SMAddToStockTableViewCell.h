//
//  SMAddToStockTableViewCell.h
//  SmartManager
//
//  Created by Priya on 27/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "SMCustomTextFieldForDropDown.h"
#import "SMToolBarCustomField.h"
#import "SMToolBarCustomTextView.h"
#import "SMCustomLable.h"
#import "SMCustomButtonGrayColor.h"

@interface SMAddToStockTableViewCell : UITableViewCell<UITextViewDelegate,UITextFieldDelegate,SMToolBarCustomFieldDelegate,SMToolBarCustomTextViewDelegate>
@property(nonatomic)BOOL isTenderAvailable;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *leftAroow;
@property (strong, nonatomic) IBOutlet UIButton *btnActivateCPA;
@property (strong, nonatomic) IBOutlet UIButton *btnIgnoreExcludeSetting;
@property (strong, nonatomic) IBOutlet UIButton *btnRemoveVehicle;
@property (strong, nonatomic) IBOutlet UIButton *btnDontLetOverride;
@property (strong, nonatomic) IBOutlet SMToolBarCustomField *txtStandInR;
@property (strong, nonatomic) IBOutlet SMToolBarCustomField *txtCostR;
@property (strong, nonatomic) IBOutlet SMToolBarCustomField *txtLocation;
@property (strong, nonatomic) IBOutlet SMToolBarCustomField *txtOmeNo;
@property (strong, nonatomic) IBOutlet SMToolBarCustomField *txtRegNo;
@property (strong, nonatomic) IBOutlet SMToolBarCustomField *txtEngineNo;
@property (strong, nonatomic) IBOutlet SMToolBarCustomField *txtVinNo;
@property (strong, nonatomic) IBOutlet SMToolBarCustomField *txtTrim;
@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtAddToTender;
@property (strong, nonatomic) IBOutlet SMToolBarCustomField          *txtInternalNote;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblAVehicleIsRemoved;


@property(strong, nonatomic) IBOutlet SMCustomLable *lableVIN;
@property(strong, nonatomic) IBOutlet SMCustomLable *lableEngineNo;
@property(strong, nonatomic) IBOutlet SMCustomLable *lableRegNo;
@property(strong, nonatomic) IBOutlet SMCustomLable *lableOEM;


@property(strong, nonatomic) IBOutlet SMCustomLable *lablelocation;
@property(strong, nonatomic) IBOutlet SMCustomLable *lableTrim;
@property(strong, nonatomic) IBOutlet SMCustomLable *lableCost;
@property(strong, nonatomic) IBOutlet SMCustomLable *lableStand;


@property(strong, nonatomic) IBOutlet SMCustomLable *lableInternalNote;
@property(strong, nonatomic) IBOutlet SMCustomLable *lableTender;

@property(strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnAdditionalInfo;

@end
