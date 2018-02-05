//
//  SMSettings_MembersViewController.h
//  Smart Manager
//
//  Created by Sandeep on 05/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSettings_MembersCell.h"
#import "SMAddEditTradeMemeberViewController.h"
#import "SMMemeberUpdateList.h"
#import "MBProgressHUD.h"
#import "SMTradeMembersObject.h"

@interface SMSettings_MembersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SMMemeberUpdateListDelegate,NSXMLParserDelegate,MBProgressHUDDelegate>{
    IBOutlet UITableView *settingsMembersTableView;

    IBOutlet UIView *tableHeaderView;
    IBOutlet UIView *tableHeaderViewiPad;
    IBOutlet UIButton *addMemberButton;
    IBOutlet UIButton *addMemberButtoniPad;

    NSMutableArray *memebersArray;

    NSInteger selectedUpdateIndex;
    SMTradeMembersObject *tradeMemeberObj;
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
}
-(IBAction)addMemberDidClicked:(id)sender;
@end
