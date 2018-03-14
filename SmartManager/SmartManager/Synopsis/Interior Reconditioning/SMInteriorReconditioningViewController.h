//
//  SMInteriorReconditioningViewController.h
//  Smart Manager
//
//  Created by Ketan Nandha on 29/12/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMCustomButtonBlue.h"
#import "SMSynopsisXMLResultObject.h"

@interface SMInteriorReconditioningViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,NSXMLParserDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
{

    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;

}
@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnPlus;
@property(nonatomic,strong) SMSynopsisXMLResultObject *objSummary;

- (IBAction)btnPlusButtonDidClicked:(id)sender;
- (IBAction)btnSaveDidClicked:(id)sender;


@end



