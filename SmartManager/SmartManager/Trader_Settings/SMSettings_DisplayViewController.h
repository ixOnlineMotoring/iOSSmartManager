//
//  SMSettings_DisplayViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 03/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface SMSettings_DisplayViewController : UIViewController<NSXMLParserDelegate,MBProgressHUDDelegate>
{
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    MBProgressHUD *HUD;
    __weak IBOutlet UIButton *btnSaveDisplay;

    IBOutlet UIButton *checkBoxTradePrice;
    IBOutlet UIButton *checkBoxDaysinStock;
    IBOutlet UIButton *checkBoxAppraisal;
    
}

- (IBAction)checkBoxTradePriceDidClicked:(id)sender;


- (IBAction)checkBoxDaysInStockDidClicked:(id)sender;

- (IBAction)checkBoxAppraisalDidClicked:(id)sender;


- (IBAction)btnSaveDisplayDidClicked:(id)sender;

@end
