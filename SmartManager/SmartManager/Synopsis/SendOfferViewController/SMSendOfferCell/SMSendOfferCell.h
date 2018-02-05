//
//  SMSendOfferCell.h
//  Smart Manager
//
//  Created by Sandeep on 22/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"

@interface SMSendOfferCell : UITableViewCell
@property (weak, nonatomic)IBOutlet UILabel *vechiclesNameLabel;
@property (weak, nonatomic)IBOutlet UILabel *vechiclesDescriptionLabel;
@property (weak, nonatomic)IBOutlet UILabel *vechiclesVINOrChassisNOLabel;
@property (weak, nonatomic)IBOutlet UILabel *vechiclesRegistrationNOLabel;
@property (weak, nonatomic)IBOutlet UILabel *vechiclesColorLabel;
@property (weak, nonatomic)IBOutlet UILabel *vechiclesMileageLabel;
@property (weak, nonatomic)IBOutlet SMCustomTextField *txtName;
@property (weak, nonatomic)IBOutlet SMCustomTextField *txtSurname;
@property (weak, nonatomic)IBOutlet SMCustomTextField *txtCompany;
@property (weak, nonatomic)IBOutlet SMCustomTextField *txtEmail;
@property (weak, nonatomic)IBOutlet SMCustomTextField *txtMobile;
@property (weak, nonatomic)IBOutlet SMCustomTextField *txtMyOffer;

@property (strong, nonatomic) IBOutlet UIButton *btnPlus;

@property (strong, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldExpiresIn;
@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldSubjectTo;


//@property (weak, nonatomic)IBOutlet SMCustomTextField *txtAdditionalRecipientsEmail;
//@property (weak, nonatomic)IBOutlet SMCustomTextField *txtAdditionalRecipientsSMS;
@end
