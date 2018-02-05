//
//  SMSellerFooterView.h
//  Smart Manager
//
//  Created by Sandeep on 06/01/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "CustomTextView.h"
#import "SMCustomButtonBlue.h"

@interface SMSellerFooterView : UIView

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldEmailID;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldMobilNum;

@property (strong, nonatomic) IBOutlet CustomTextView *txtViewComment;

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnSave;


@end
