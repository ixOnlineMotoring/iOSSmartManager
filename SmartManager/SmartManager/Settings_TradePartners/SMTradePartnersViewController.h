//
//  SMAddEditTradePartnersViewController.h
//  Smart Manager
//
//  Created by Sandeep on 06/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTraderPartnersObject.h"
#import "SMTradePartnersCell.h"
#import "SMAddEditTradePartnersViewController.h"
#import "SMListTradePartnersObject.h"

@interface SMTradePartnersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,MBProgressHUDDelegate>
{
    IBOutlet UIView *tableHeaderView;
    IBOutlet UITableView *tradePartnersTableView;
    IBOutlet UIButton *addPartnersButton;
    NSMutableArray *memebersArray;

    IBOutlet UIButton *radioButton;
    IBOutlet UIButton *radioButton1;

    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;

    BOOL AllowGlobalBoolValue;

    SMListTradePartnersObject *tradePartnersObj;

    BOOL isEveryOne;
}
-(IBAction)addPartnersButtonDidClicked:(id)sender;

-(IBAction)radioButtonDidClicked:(id)sender;
@end
