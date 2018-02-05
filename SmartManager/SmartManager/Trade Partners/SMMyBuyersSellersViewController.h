//
//  SMMyBuyersSellersViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 07/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMTradeSettingsObject.h"
#import "SMCustomLabelAutolayout.h"

@interface SMMyBuyersSellersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,MBProgressHUDDelegate>
{
    IBOutlet UITableView *tblViewMyBuyersSellers;
    IBOutlet UIView *viewHeader;
    IBOutlet UIView *viewFooter;
     MBProgressHUD *HUD;
    IBOutlet UIView *viewFooterEveryone;
    NSMutableArray *arrayOfBuyersSellersList;
    UILabel *listActiveSpecialsNavigTitle;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    
    SMTradeSettingsObject *tradeObject;
    BOOL isEveryone;
    
    __weak IBOutlet SMCustomLabelAutolayout *lblHeadingTitle;
    

}

@property(assign,nonatomic)NSUInteger viewControllerTradePartnerType;


@end
