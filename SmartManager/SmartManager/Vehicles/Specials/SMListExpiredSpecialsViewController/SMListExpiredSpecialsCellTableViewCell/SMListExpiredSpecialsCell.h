//
//  SMListExpiredSpecialsCell.h
//  SmartManager
//
//  Created by Sandeep on 20/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"
#import "SMCustomLabelBold.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomButtonGrayColor.h"

@interface SMListExpiredSpecialsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewActive;
@property (weak, nonatomic) IBOutlet SMCustomLabelBold *lblVehicleName;
@property (weak, nonatomic) IBOutlet SMCustomLabelBold *lblVehicleDetail;
//@property (weak, nonatomic) IBOutlet SMCustomLable *lblVehicleDetailName;

@property (weak, nonatomic) IBOutlet SMCustomLable *lblColor;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblRegistration;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblMileage;
//@property (weak, nonatomic) IBOutlet SMCustomLable *lblInStock;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblExpired;

@property (weak, nonatomic) IBOutlet SMCustomLable *lblNormal;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblSpecial;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblSave;

@property (weak, nonatomic) IBOutlet SMCustomLable *lblNormalPrice;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblSpecialPrice;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblSavePrice;

@property (weak, nonatomic) IBOutlet SMCustomLable *lblCreated;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblFrom;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblTo;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblCreatedDate;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblFromDate;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblToDate;

@property (weak, nonatomic) IBOutlet SMCustomButtonGrayColor *btnEnd;
@property (weak, nonatomic) IBOutlet SMCustomButtonBlue *btnEdit;

@property (weak, nonatomic) IBOutlet UIView *viewUnderline;

@end
