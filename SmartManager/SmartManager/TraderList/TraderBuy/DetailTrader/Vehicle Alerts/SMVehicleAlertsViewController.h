//
//  SMVehicleAlertsViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 17/09/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "SMPhotosAndExtrasObject.h"
#import "MBProgressHUD.h"
#import "SMAddToStockViewController.h"

@interface SMVehicleAlertsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSXMLParserDelegate,UINavigationControllerDelegate,refreshListModule,MBProgressHUDDelegate>
{
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    
    UILabel *listActiveSpecialsNavigTitle;
    SMPhotosAndExtrasObject *photosAndExtrasObject;
    NSMutableArray *arrayOfMissingPrice;
    NSMutableArray *arrayOfMissingInfo;
    NSMutableArray *arrayOfViewObject;
    NSMutableArray *arrayOfActivateTrade;
    NSString *msgActivateTradeFail;
    
    MBProgressHUD *HUD;

    int totalRecordCount;
    int iMissingPrice;
    int iActivateRetail;
    int iMissingInfo;
    int iTotalMissingPrice;
    int iTotalActivateRetail;
    int iTotalMissingInfo;
    
    __weak IBOutlet UIView *viewTableHeader;

}

@property (strong, nonatomic) IBOutlet UITableView *tblViewVehicleAlerts;

@property(assign,nonatomic)NSUInteger viewControllerVehicleAlertType;




@end
