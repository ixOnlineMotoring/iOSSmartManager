//
//  SMLoginViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "SMImpersonateObject.h"
#import "SMClassForRefreshingData.h"
#import "SMCustomButtonBlue.h"
#import <MessageUI/MessageUI.h>
#import "SMCustomLable.h"
#import "SMCustomLabelBold.h"

@interface SMLoginViewController : UIViewController<NSXMLParserDelegate,SMAuthenticationDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate>
{
    NSUserDefaults *prefs;

    //---web service access---
   
    NSMutableString *soapResults;
   
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
    BOOL moduleElementFound;
    BOOL isAuthenticated;
    BOOL isImpersonateFound;
    NSString *AuthenticatedValue;
    
    NSMutableArray *arrOfUserDetails;
    NSMutableArray *arrOfModules;
    
    SMClassForRefreshingData *refreshData;
}

@property (strong, nonatomic) IBOutlet UILabel *lblLoginErrorMessage;



@property (strong, nonatomic) IBOutlet UIView *viewUsername;
@property (strong, nonatomic) IBOutlet UIView *viewPassword;

@property (strong, nonatomic) IBOutlet UILabel *lblHeaderTitle;

@property (strong, nonatomic) IBOutlet UITextField *txtFieldUserName;

@property (strong, nonatomic) IBOutlet UITextField *txtFieldPassword;

@property (strong, nonatomic) IBOutlet UILabel *lblLoginDetails;

@property (strong, nonatomic) IBOutlet UIButton *btnLogin;

@property (strong, nonatomic) IBOutlet UIButton *btnJoinNow;

@property (strong, nonatomic) IBOutlet UIButton *btnUserImage;
@property (strong, nonatomic) IBOutlet UIButton *btnPasswordImage;

@property (strong, nonatomic) IBOutlet UIButton *infoImage;

//@property (strong, nonatomic) UIImage *clientImage;


@property (strong, nonatomic) IBOutlet UIView *popUpView;


@property (strong, nonatomic) IBOutlet UIView *customAlertBox;


@property (weak, nonatomic) IBOutlet UIImageView *imgClientImage;



@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnCancelCustomAlert;

- (IBAction)btnEmailDidClicked:(id)sender;

- (IBAction)btnPhoneDidClicked:(id)sender;


- (IBAction)btnCancelCustomAlertDidClicked:(id)sender;



@property (nonatomic, strong) SMImpersonateObject *impersonateClientObj;

- (IBAction)btnLoginDidClicked:(id)sender;

- (IBAction)btnJoinNowDidClicked:(id)sender;

@end
