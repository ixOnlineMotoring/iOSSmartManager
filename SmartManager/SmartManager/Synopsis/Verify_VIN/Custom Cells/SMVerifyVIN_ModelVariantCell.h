//
//  SMVerifyVIN_ModelVariantCell.h
//  Smart Manager
//
//  Created by Prateek Jain on 19/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomButtonGrayColor.h"
#import "SMCustomTextFieldForDropDown.h"
#import "SMAutolayoutLightLabel.h"
#import "SMCustomButtonBlue.h"
@interface SMVerifyVIN_ModelVariantCell : UITableViewCell

@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnChangeModelVariant;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintForColumn;

@property (strong, nonatomic) IBOutlet UIView *viewContainingColumn;

@property (strong, nonatomic) IBOutlet UIView *viewContainingModelVariantTextfields;

@property (strong, nonatomic) IBOutlet UIImageView *imgViewArrow;

@property (strong, nonatomic) IBOutlet UILabel *lblDescription;

@property (strong, nonatomic) IBOutlet UIView *viewContainingTwoLabels;

@property (strong, nonatomic) IBOutlet UILabel *lblLeft;

@property (strong, nonatomic) IBOutlet UILabel *lblRight;

@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnClearDidClicked;
@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnUpdateDidClicked;
@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldYear;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldMake;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldModel;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldVariant;

@property (strong, nonatomic) IBOutlet UILabel *lblLeftTitle;
@property (strong, nonatomic) IBOutlet SMAutolayoutLightLabel *lblProvided;
@property (strong, nonatomic) IBOutlet SMAutolayoutLightLabel *lblVerified;



- (IBAction)btnClearDidClicked:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *lblDetailFullVerification;







@end
