

//
//  SMSynopsisConditionViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 04/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMSynopsisXMLResultObject.h"

@interface SMSynopsisConditionViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    
    
    NSMutableString *currentNodeContent;

}

- (IBAction)btnSaveDidClicked:(id)sender;
@property(nonatomic,strong) SMSynopsisXMLResultObject *objSummary;

@end
