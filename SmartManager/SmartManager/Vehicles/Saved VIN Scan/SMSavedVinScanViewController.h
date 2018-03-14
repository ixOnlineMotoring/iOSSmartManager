//
//  SMSavedVinScanViewController.h
//  SmartManager
//
//  Created by Priya on 28/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMVINLookupObject.h"
#import "SMVINScanLookupDetailsViewController.h"
#import "MBProgressHUD.h"

@interface SMSavedVinScanViewController : UIViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,refreshVehicleListing,MBProgressHUDDelegate>
{
    NSMutableString *currentNodeContent;
    //---web service access---
    NSMutableString *soapResults;
    //---xml parsing---
    NSXMLParser *xmlParser;
    SMVINLookupObject* VINLookupObject;
    NSMutableArray *savedVINScanArray;
    IBOutlet UILabel *lblTitle;

    MBProgressHUD *HUD;
    
    
}
@property(strong,nonatomic)IBOutlet UITableView *tableView;
@end
