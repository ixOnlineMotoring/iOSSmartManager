//
//  SMVehicleStockListViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 09/02/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMDropDownObject.h"
#import "MBProgressHUD.h"
#import "SMPhotosAndExtrasObject.h"


@interface SMVehicleStockListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate,NSXMLParserDelegate>
{
    NSXMLParser *xmlPEParser;
    NSMutableArray *photosAndExtrasArray;
    NSMutableArray  *arraySortObject;
    NSMutableString *currentNodeContent;
    SMPhotosAndExtrasObject *loadPhotosAndExtrasObject;
    SMPhotosAndExtrasObject *loadPhotosAndExtrasSearchObject;
    BOOL isCompletedLoading;
    int pageNumberCount;
    int iTotalArrayCount;
    
    int StatusIDForChoices;
    
    NSInteger oldArrayCount;
    NSString *resultString;
    BOOL isLoadMore;
    int selectedRow;
    BOOL isTheAttemtFirst;
    BOOL isSearchResult;
    BOOL isListingDataBeingFetched;
    BOOL hasUserChangedTheDefaultSortOption;
    
    NSOperationQueue *downloadingQueue;
    NSTimer *timerForDelay;
    
    SMDropDownObject *objectDropDown;
    
    IBOutlet UIView         *popupView;
    
    MBProgressHUD *HUD;

    IBOutlet UIButton *btnShowFilter;
    
    __weak IBOutlet UIImageView *imgSortOderIcon;
    

}



@end
