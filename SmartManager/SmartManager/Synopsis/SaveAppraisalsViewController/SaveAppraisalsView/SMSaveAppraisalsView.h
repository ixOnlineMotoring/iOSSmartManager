//
//  SMSaveAppraisalsView.h
//  Smart Manager
//
//  Created by Sandeep on 21/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCalenderTextField.h"
#import "SMCustomTextField.h"
#import "SMCustomButtonBlue.h"

@interface SMSaveAppraisalsView : UIView
@property (strong, nonatomic) IBOutlet SMCalenderTextField *txtFieldStartDate;
@property (strong, nonatomic) IBOutlet SMCalenderTextField *txtFieldEndDate;
@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldCustomerSurname;
@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *buttonList;
@end
