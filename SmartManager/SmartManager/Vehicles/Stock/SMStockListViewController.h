//
//  SMStockListViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 29/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomButtonBlue.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMPhotosAndExtrasObject.h"
#import "SMCommonClassMethods.h"
#import "SMAppDelegate.h"
#import "SMConstants.h"
#import "SMCustomTextField.h"
#import "SMDropDownObject.h"
#import "SMAddToStockViewController.h"
#import "SMReusableSearchTableViewController.h"
#import "QBImagePickerController.h"
#import "RPMultipleImagePickerViewController.h"


@interface SMStockListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,UIScrollViewDelegate,refreshListModule,MBProgressHUDDelegate,UITextFieldDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate,QBImagePickerControllerDelegate,presentTheMultiplePhotoSelectionLibraryDelegate,UIImagePickerControllerDelegate>
{
    float rowHeight;
    UILabel *listActiveSpecialsNavigTitle;
    
    NSXMLParser *xmlPEParser;
    NSMutableArray *photosAndExtrasArray;
    NSMutableArray *arrayOfGroupStock;
    NSMutableArray  *arraySortObject;
    NSMutableArray  *arrayVehiclesObject;
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
    int selectedRowForVehiclesDropdown;
    BOOL isTheAttemtFirst;
    BOOL isSearchResult;
    BOOL isListingDataBeingFetched;
    BOOL isGroupStockSection;
    
    int totalMyStockCount;
    int totalGroupStockCount;
    
    NSOperationQueue *downloadingQueue;
    NSTimer *timerForDelay;
    
    SMDropDownObject *objectDropDown;
    SMAppDelegate *appdelegate;
    
    IBOutlet UIView         *popupView;
    
    MBProgressHUD *HUD;
    BOOL shouldGroupStockBeHidden;
    
    BOOL isNoRecordsAlertShown;
     SMReusableSearchTableViewController *searchMakeVC;
    NSArray *arrLoadNib;
    
    UIImagePickerController * picker;
    QBImagePickerController *imagePickerController;
    UIImage *selectedImage;
    NSArray *assetsArray;
    NSMutableArray *arrayOfImages;
    NSString          *documentsDirectory;
    NSString          *fullPathOftheImage;
     NSData            *imageData;
}

@property (nonatomic, strong) RPMultipleImagePickerViewController *multipleImagePicker;

@property(assign)BOOL isFromEBrochure;


@property (strong, nonatomic) IBOutlet UITableView *tblViewStockList;

@property (strong, nonatomic) IBOutlet UILabel *lblNoRecords;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIButton *btnShowFilter;

- (IBAction)btnShowFilterDidClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblSortBy;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldSortOption;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldKeywordSearch;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldVehiclesDropdown;

@property (strong, nonatomic) IBOutlet UILabel *lblVehlcesDropDown;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintForSortFilter;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintHeaderViewOld;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintOfHeaderOldToTableView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintProfilePicView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightUploadPicView;



@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintHeaderVariant;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightHeaderOLD;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControlForChoices;

@property (strong, nonatomic) IBOutlet UILabel *lblRetailCnt;

@property (strong, nonatomic) IBOutlet UILabel *lblExcludedCnt;

- (IBAction)segmentControlDidClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imgRightArrow;

@property (strong, nonatomic) IBOutlet UIImageView *imgUpDownArrow;

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnMyStock;

@property (strong, nonatomic) IBOutlet UIView *viewContainingSegment;



// popup view

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)btnCancelDidClicked:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *popUpViewForSort;


@property (strong, nonatomic) IBOutlet UIView *viewDropdownFrame;


@property (strong, nonatomic) IBOutlet UITableView *tableSortItems;

@property (strong, nonatomic) IBOutlet UIImageView *imgViewProfilePic;

@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePicFullRange;




/////////////////////////Monami///////////////////////////////

@property (strong, nonatomic) IBOutlet UIView *vwUpload;
@property (strong, nonatomic) IBOutlet UIView *vwReplace;
@property (strong,nonatomic) NSString *strImgName;
////////////////////  END ////////////////////////////////////


- (IBAction)btnListDidClicked:(id)sender;

- (IBAction)btnListUsedVehiclesDidClicked:(id)sender;

- (IBAction)btnReplaceProfilePicDidClciked:(id)sender;

@end
