//
//  SMCustomerScanViewController.h
//  SmartManager
//
//  Created by Jignesh on 02/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomButtonBlue.h"
#import "SWTableViewCell.h"
#import "SMCustomLable.h"
#import "SMCustomLabelBold.h"
#import "MBProgressHUD.h"
#import "SMCustomerDetailsDLScanObj.h"
#import "SMCustomerVehicleClassObj.h"
#import "SMCustomerDLScanViewController.h"
#import "SMCustomerScanDetailViewController.h"


@interface SMCustomerScanViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,SWTableViewCellDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,SMRefreshDLDelegate,pushDLDetailsScreen,refreshDLList>
{
    int cellScrolled;
    NSMutableArray *arrayOfDriverLicences;
    MBProgressHUD *HUD;

    NSXMLParser *xmlParser;
    NSOperationQueue *downloadingQueue;
    NSMutableString *currentNodeContent;
    
    // pagination stuff
    
    int pageNumberCount;
    BOOL isListingDataBeingFetched;
    BOOL isLoadMore;
    
    int totalCount;
    BOOL isIndividualVehicleClassDone;
    NSString *tempDriverRestrictionStr;
      NSString *custSurName;
    int ScanID;
    
    int selectedIndexForDelete;
    
}


-(IBAction)buttonscanDriverLicenseDidPressed;

@property (strong, nonatomic) SMCustomerDetailsDLScanObj *custDetailsObj;
@property (strong, nonatomic) SMCustomerVehicleClassObj *vehicleClassObj;
@property (strong, nonatomic) NSMutableArray *arrayOfVehicleClass;

@property(weak,  nonatomic)   IBOutlet   SMCustomLable      *labelSwipeToRemove;
@property(weak,  nonatomic)   IBOutlet   SMCustomLabelBold  *labelScannedLicense;
@property(strong,nonatomic)   IBOutlet   SMCustomButtonBlue *buttonScanLicense;
@property(strong,nonatomic)   IBOutlet   UITableView        *tableScanLicenseList;
@property(strong,nonatomic)   IBOutlet   UIView             *mainHeaderView;

@property (strong, nonatomic) IBOutlet UILabel *lblNoRecords;



@end
