//
//  SMTradeVehicleListingViewController.h
//  Smart Manager
//
//  Created by Sandeep on 24/11/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTraderWinningBidCell.h"
#import "SMVehiclelisting.h"
#import "SMActiveTradesViewController.h"
#import "MBProgressHUD.h"

@interface SMTradeVehicleListingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,NSXMLParserDelegate>
{
    NSMutableArray *tradeVechicleListArray;
    IBOutlet UITableView *tradeVechicleTableView;
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    SMVehiclelisting *objectVehicleListing;

    int page;
    int pageSize;
    int totalRecordCount;
}
@end
