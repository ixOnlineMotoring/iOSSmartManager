//
//  SMSettings_ReadinessViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 03/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "MBProgressHUD.h"


@interface SMSettings_ReadinessViewController : UIViewController<NSXMLParserDelegate,MBProgressHUDDelegate>
{

    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    MBProgressHUD *HUD;
    int DaysPositionNumber;
    
    IBOutlet SMCustomTextField *txtFieldNewVehicles;
    
    IBOutlet SMCustomTextField *txtFieldUsedRetail;
    
    IBOutlet SMCustomTextField *txtFieldUsedDemos;
    __weak IBOutlet UIButton *btnSaveReadiness;

}

- (IBAction)btnSaveReadinessDidClicked:(id)sender;


@end
