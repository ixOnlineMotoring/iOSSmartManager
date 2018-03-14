//
//  SMSynopsisPurchaseDetailsViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 29/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMSynopsisXMLResultObject.h"


@interface SMSynopsisPurchaseDetailsViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,NSXMLParserDelegate>
{
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;

    IBOutlet UIView       *dateView;
    IBOutlet UIView       *popupView;
    IBOutlet UIDatePicker *datePickerForTime;


}

-(IBAction)buttonCancelDidPressed:(id)sender;
-(IBAction)buttonDoneDidPrssed:(id) sender;
@property(nonatomic,strong) SMSynopsisXMLResultObject *objSummary;


@end
