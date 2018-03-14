//
//  SMBiddingReceivedViewController.h
//  Smart Manager
//
//  Created by Jignesh on 02/11/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMVehiclelisting.h"
#import "SMCustomSellObject.h"
#import "MBProgressHUD.h"

@interface SMBiddingReceivedViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate, MBProgressHUDDelegate>

{
    SMVehiclelisting        *  objectVehicleListing;
    SMCustomSellObject      *  objCustomSell;
    IBOutlet UITableView    *  table_ReceivedBidding;
    
    NSXMLParser             *  xmlParser;
    int                        iActiveBids;
    int                        totalRecordCount;
    NSMutableString         *  currentNodeContent;

    NSMutableArray          *  array_ActibeBids;
    
    
    MBProgressHUD           * HUD;
    

}
@end
