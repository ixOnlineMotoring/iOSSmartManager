//
//  SMSettings_TradePriceViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 04/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMCustomTextField.h"

@interface SMSettings_TradePriceViewController : UIViewController<NSXMLParserDelegate,MBProgressHUDDelegate,UITextViewDelegate>
{
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    MBProgressHUD *HUD;
    __weak IBOutlet UIButton *btnSaveTradePrice;
    
    __weak IBOutlet SMCustomTextField *txtFieldTradePrice;

}
- (IBAction)btnSaveTradePriceDidClicked:(id)sender;

@end
