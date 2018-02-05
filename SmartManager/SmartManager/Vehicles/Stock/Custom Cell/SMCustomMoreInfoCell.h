//
//  SMCustomMoreInfoCell.h
//  Smart Manager
//
//  Created by Tejas on 03/09/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"
#import "SMCustomTextField.h"
#import "CustomTextView.h"
#import "SMCustomButtonBlue.h"

@interface SMCustomMoreInfoCell : UITableViewCell


@property (weak, nonatomic) IBOutlet SMCustomLable *lblEmail;

@property (weak, nonatomic) IBOutlet SMCustomTextField *txtFieldEmailAddress;


@property (weak, nonatomic) IBOutlet SMCustomLable *lblComment;

@property (weak, nonatomic) IBOutlet CustomTextView *textViewComment;

@property (weak, nonatomic) IBOutlet SMCustomTextField *txtFieldRecepientName;

@property (weak, nonatomic) IBOutlet SMCustomTextField *txtFieldRecepientSurname;

@property (weak, nonatomic) IBOutlet SMCustomTextField *txtFieldRecepientMobile;





- (IBAction)btnSendEmailCommentDidClicked:(id)sender;

@property (weak, nonatomic) IBOutlet SMCustomButtonBlue *btnSendInfo;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblTextViewCharRemaining;

@end
