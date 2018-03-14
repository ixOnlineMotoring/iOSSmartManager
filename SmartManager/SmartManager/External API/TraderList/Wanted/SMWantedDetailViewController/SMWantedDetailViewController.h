//
//  SMWantedDetailViewController.h
//  SmartManager
//
//  Created by Ketan Nandha on 02/03/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMDropDownObject.h"
#import "SMVehiclelisting.h"

@interface SMWantedDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,MBProgressHUDDelegate>
{
    NSXMLParser         *xmlParser;
    MBProgressHUD       *HUD;
    NSMutableString     *currentNodeContent;
    
    NSMutableArray      *arrayVehicle;
    SMVehiclelisting    *objectVehicleListing;
    
    int pageNo;
}

@property (nonatomic, strong) SMDropDownObject        *objectDropDown;

@property (nonatomic, strong) IBOutlet UITableView   *tableWantedDetail;

@property (nonatomic) int count;

@end
