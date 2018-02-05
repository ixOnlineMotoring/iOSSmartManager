//
//  SMSaveAndSendViewCell.h
//  Smart Manager
//
//  Created by Sandeep on 23/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomButtonBlue.h"
#import "SMCustomTextField.h"
@interface SMSaveAndSendViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnCheckBoxSms;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckBoxEmail;

@property (strong, nonatomic) IBOutlet UIButton *btnCheckboxEmailCopyTo;

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnSaveAndSendOffer;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldEmailCopyTo;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldSMS;



@end
