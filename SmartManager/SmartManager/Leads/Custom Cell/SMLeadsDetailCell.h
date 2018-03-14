//
//  SMLeadsDetailCell.h
//  SmartManager
//
//  Created by Liji Stephen on 05/05/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"
#import "SMCustomTextFieldForDropDown.h"
#import "CustomTextView.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomTextField.h"
#import "SMCalenderTextField.h"

@interface SMLeadsDetailCell : UITableViewCell<UITextViewDelegate>
{
   
    
}

@property (strong, nonatomic) IBOutlet UIButton *buttonChangeStatus;

@property (strong, nonatomic) IBOutlet UIButton *buttonActivity;


@property (strong, nonatomic) IBOutlet SMCustomLable *lblActivity;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblChangeStatus;


@property (strong, nonatomic) IBOutlet SMCustomLable *lblComment;

@property (strong, nonatomic) IBOutlet CustomTextView *txtViewComment;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldLeadActivity;


@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnSubmit;

@property (strong, nonatomic) IBOutlet UIView *viewBottomSmall;

@property (strong, nonatomic) IBOutlet UIView *viewBottomBig;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldInvoiceNo;

@property (strong, nonatomic) IBOutlet SMCalenderTextField *txtFieldDate;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldRIncl;


@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldInvoiceTo;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldSalesPerson;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldStockNo;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldVehicleDept;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldVehicleType;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldGender;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldRace;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldAge;

@property (strong, nonatomic) IBOutlet CustomTextView *txtViewCommentsSold;

@property (strong, nonatomic) IBOutlet UIButton *btnChangeStatusSold;

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnSubmitSold;


// Second cell

@property (strong, nonatomic) IBOutlet SMCustomLable *lblCurrentVehicle;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblYearModel;


@property (strong, nonatomic) IBOutlet SMCustomLable *lblMileage;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblCurrentVehicleValue;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblYearValue;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblMileageValue;




@end
