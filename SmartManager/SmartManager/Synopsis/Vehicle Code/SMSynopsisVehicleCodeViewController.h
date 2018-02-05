//
//  SMSynopsisVehicleCodeViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 21/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMToolBarCustomField.h"

@interface SMSynopsisVehicleCodeViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,
NSXMLParserDelegate,MBProgressHUDDelegate>
{
    NSString *selectedYear;
    BOOL isTxtKiloMetersSelected;
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
}

@end
