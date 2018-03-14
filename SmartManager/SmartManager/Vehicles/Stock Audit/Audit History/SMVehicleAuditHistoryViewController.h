//
//  SMVehicleAuditHistoryViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 04/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMStockAuditDetailObject.h"

@interface SMVehicleAuditHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,NSXMLParserDelegate>
{

    NSXMLParser *xmlParser;
    MBProgressHUD *HUD;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrayOfAuditHistory;
    
    int pageNumberCount;
    BOOL isListingDataBeingFetched;
    BOOL isLoadMore;
    BOOL isCountOfIndividualVehicle;
    
    int totalCount;
    
}

@property (strong, nonatomic) IBOutlet UILabel *lblSelectAuditDate;

@property (strong, nonatomic) IBOutlet UITableView *tblViewAuditDates;
@property(strong,nonatomic) SMStockAuditDetailObject *auditHistoryObj;

@property (weak, nonatomic) IBOutlet UILabel *lblNoRecords;



@end
