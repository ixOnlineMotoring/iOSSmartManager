//
//  SMJoinNowViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 08/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SMCustomLable.h"

@interface SMJoinNowViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblSmartManager;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblJoinNow;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblPleaseContact;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblPhone;

@property (strong, nonatomic) IBOutlet UIButton *btnPhone;

@property (strong, nonatomic) IBOutlet UIButton *infoImage;

@property (strong, nonatomic) IBOutlet UIButton *btnEmailAddress;

@property (strong, nonatomic) IBOutlet UIView *viewRectangle;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)btnCancelDidClicked:(id)sender;
- (IBAction)btnPhoneDidClicked:(id)sender;
- (IBAction)btnEmailAddressDidClicked:(id)sender;

@end
