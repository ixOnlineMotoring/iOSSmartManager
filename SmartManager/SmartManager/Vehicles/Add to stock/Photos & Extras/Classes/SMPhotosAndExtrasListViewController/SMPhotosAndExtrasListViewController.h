//
//  SMPhotosAndExtrasListViewController.h
//  SmartManager
//
//  Created by Sandeep on 03/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPhotosAndExtrasTableViewCell.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMPhotosAndExtrasObject.h"
#import "SMCommentVideosPhotosAddViewController.h"
#import "SMCommonClassMethods.h"
#import "SMAppDelegate.h"
#import "SMConstants.h"
#import "SMCustomTextField.h"
#import "SMDropDownObject.h"
#import "SMAddToStockViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface SMPhotosAndExtrasListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,UIScrollViewDelegate,refreshListModule,MBProgressHUDDelegate>
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
    SMAppDelegate *appdelegate;
    
    IBOutlet UIView         *popupView;
    
    MBProgressHUD *HUD;
    
    UILabel *labelforNavigationTitle;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tblPhotosAndExtras;

@property (strong, nonatomic) IBOutlet UILabel *lblNoRetail;
@property (strong, nonatomic) IBOutlet UILabel *lblNoExcluded;
@property (strong, nonatomic) IBOutlet UILabel *lblNoInvalid;
@property (strong, nonatomic) IBOutlet UILabel *lblNoAll;

@property (strong, nonatomic) IBOutlet UIImageView *imageUpDownArrow;


@property (strong, nonatomic) IBOutlet UILabel *lblNoRecordFound;


@property(strong,nonatomic)     IBOutlet  UITableView        *tableSortItems;
@property(strong, nonatomic)    IBOutlet  UIView             *viewDropdownFrame;

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UIView *headerView;


@property (strong, nonatomic) IBOutlet UIButton *btnShowFilter;

@property (strong, nonatomic) IBOutlet UIImageView *imgRightArrow;

@property (strong, nonatomic) IBOutlet UILabel *lblSortBy;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldSort;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldSearch;

@property (strong, nonatomic) IBOutlet UIView *viewForStatusChoices;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControlForStatusChoices;

- (IBAction)segmentControlForStatusDidClicked:(id)sender;

- (IBAction)buttonCancelDidPressed:(id)sender;

- (IBAction)btnShowFilterDidClicked:(id)sender;

- (void)loadPhotosAndExtrasWSWithStatusID:(int)statusID;

@end
