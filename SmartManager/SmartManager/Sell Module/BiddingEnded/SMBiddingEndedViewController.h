//
//  SMBiddingEndedViewController.h
//  Smart Manager
//
//  Created by Jignesh on 02/11/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMVehiclelisting.h"
#import "SMCustomSellObject.h"
#import "MBProgressHUD.h"
@interface SMBiddingEndedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate, MBProgressHUDDelegate>
{
    SMVehiclelisting        * objectVehicleListing;
    SMCustomSellObject      * objCustomSell;
    NSMutableArray          * array_EndedBids;
    
    IBOutlet UITableView    * table_BidsEnded;
    
    NSXMLParser             * xmlParser;
    NSMutableString         *currentNodeContent;

    int                       iBidEnded;

    MBProgressHUD *HUD;

    int                       totalRecordCount;
    
}
@end
