//
//  SMSynopsisVehicleInStockViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 21/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMLoadVehiclesObject.h"
#import "SMCustomPopUpTableView.h"
#import "SMDropDownObject.h"
#import "SMCustomPopUpSearchTableView.h"
#import "SMLoadVehiclesObject.h"
#import "SMReusableSearchTableViewController.h"


@interface SMSynopsisVehicleInStockViewController : UIViewController<MBProgressHUDDelegate,NSXMLParserDelegate,SMPaginationRequestSearchDelegate,SMPaginationRequestDelegate>
{

    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    
    NSMutableArray *arrayOfStockList;
    NSMutableArray *arrayOfDealerMakes;
    NSMutableArray *arrayOfDealerModels;
    NSMutableArray *arrayOfDealerVariants;
    NSMutableString *currentNodeContent;

    int pageNumberCount;
    
    SMDropDownObject *vehicleObject;
    SMDropDownObject *variantDropdownObject;
    SMLoadVehiclesObject *objectForMakes;
    SMCustomPopUpSearchTableView *popUpView;
    SMCustomPopUpTableView *popUpViewNoSearch;
    NSMutableArray *arrayTempVehicles;
    
   // BOOL isInitialSearchLoad; // the initial array is stored on a temporary array to avoid repetative call to the service
    
    BOOL isVariantsWebserviceCalled;
    
    int selectedMakeId;
    int selectedModelId;
    int selectedVariantId;
    int selectedMakeYear;
    
    int vehicleMakeId;
    int vehicleModelId;
    int vehicleVariantId;
    int vehicleYear;
    int previousVehicleYear;
    BOOL isSearchPopUpView;
    
    SMReusableSearchTableViewController *searchMakeVC;
    NSArray *arrLoadNib1;
}



@end
