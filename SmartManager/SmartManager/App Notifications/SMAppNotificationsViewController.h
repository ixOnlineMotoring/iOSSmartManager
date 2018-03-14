//
//  SMAppNotificationsViewController.h
//  Smart Manager
//
//  Created by Ketan Nandha on 02/02/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMCustomTextField.h"

@interface SMAppNotificationsViewController : UIViewController<MBProgressHUDDelegate,NSXMLParserDelegate,UITextFieldDelegate>
{
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    MBProgressHUD *HUD;

}


@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldSearch;

@property (strong, nonatomic) IBOutlet UIView *viewTableFooter;

@end
