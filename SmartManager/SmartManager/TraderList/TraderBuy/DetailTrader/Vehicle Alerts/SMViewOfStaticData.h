//
//  SMViewOfStaticData.h
//  Smart Manager
//
//  Created by Prateek Jain on 02/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "SMCustomButtonGrayColor.h"
@interface SMViewOfStaticData : UIView

@property (strong, nonatomic) IBOutlet UILabel *lblCommentValue;

@property (strong, nonatomic) IBOutlet UILabel *lblPhotosCount;

@property (strong, nonatomic) IBOutlet UILabel *lblExtrasValue;

@property (strong, nonatomic) IBOutlet UILabel *lblVideosCount;

@property (strong, nonatomic) IBOutlet UIButton *checkBoxIsActive;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldTradePrice;

@property (strong, nonatomic) IBOutlet UIButton *btnEdit;

@property (strong, nonatomic) IBOutlet UIButton *btnActivateTrade;

@property (strong, nonatomic) IBOutlet UIView *viewContainingEditBtn;


@property (strong, nonatomic) IBOutlet UIButton *btnEdit_MissingInfo;

@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnEditMisingInfo;

@property (strong, nonatomic) IBOutlet UILabel *lblCommentValue_Info;

@property (strong, nonatomic) IBOutlet UILabel *lblPhotosCount_Info;

@property (strong, nonatomic) IBOutlet UILabel *lblExtrasValue_Info;

@property (strong, nonatomic) IBOutlet UILabel *lblVideosCount_Info;

@property (strong, nonatomic) IBOutlet UIView *viewInnerView;

@end
