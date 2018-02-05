//
//  SMBuyersSummaryListingViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 26/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMVehiclelisting.h"
#import "SMGlobalClass.h"



@interface SMBuyersSummaryListingViewController : UIViewController<UITableViewDataSource,UITableViewDataSource,NSXMLParserDelegate,MBProgressHUDDelegate>
{
    
    IBOutlet UITableView *table_BuyersInformation;
    NSXMLParser *xmlParser;
    
    NSMutableString *currentNodeContent;
    NSMutableArray *arrayOfBuyers;
    
    MBProgressHUD *HUD;
    SMVehiclelisting *objectVehicleListing;
    BOOL isSearchTrue;
    
   
     

}
@property(strong,nonatomic) NSString *strClientId;

@end
