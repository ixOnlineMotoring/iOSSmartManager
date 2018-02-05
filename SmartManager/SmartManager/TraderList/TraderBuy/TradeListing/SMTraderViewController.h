//
//  SMTraderViewController.h
//  SmartManager
//
//  Created by Jignesh on 07/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "SMRefreshFilterData.h"

// NSobjects
#import "SMDropDownObject.h"
#import "SMLoadVehiclesObject.h"
#import "SMVehiclelisting.h"

#import "SMCustomLable.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomButtonGrayColor.h"
#import "SMTraderBuyViewController.h"
#import "SMAppDelegate.h"


@interface SMTraderViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,NSXMLParserDelegate, UIPickerViewDataSource,UIPickerViewDelegate,refreshVehicleListing,MBProgressHUDDelegate>

{
    IBOutlet UIButton           *buttonHeaderFilter;
    IBOutlet SMCustomButtonBlue *buttonSearch;
    
    IBOutlet UIView            *popupView;
    IBOutlet UIView            *viewDropDownYears;
    
    IBOutlet UIImageView        *imageView;
    IBOutlet UIPickerView       *yearPicker;
    
    
        
    NSMutableArray      *arrayYears;
    NSMutableArray      *arrayMake;
    NSMutableArray      *arrayModel;
    NSMutableArray      *arrayVariant;

    NSMutableArray      *arraySortObject;
    NSMutableArray      *arrayVehicleListing;
    NSMutableArray      *arrOfUserDetails;
    NSMutableArray      *arrOfModules;
    
    BOOL isModel;
    BOOL isTheAttemtFirst;
    BOOL isPaginationCompleted;

    int selectedDropdown;
    int selectedRow;
    int startIndex;
    int currentYear;
    int lastYear;

    // this will store index
    int selectedMakeIndex;
    int selectedModelIndex;
    int selectedVariantsIndex;
    
    // this will hold the selected parameter for filter
    int selectedMakeId;
    int selectedModelId;
    int selectedVariantId;

    NSMutableString *currentNodeContent;
    NSMutableString *soapResults;
    
    NSXMLParser *xmlParser;
    
    NSString *AuthenticatedValue;
    NSString *selectedFromYear;
    NSString *selectedToYear;
    NSString   *paginationEndCount;
    int minBidValue;
    
    
    SMRefreshFilterData *refreshClassFilterData;
    SMDropDownObject *objectDropDown;
    SMLoadVehiclesObject *objectForMakes;
    SMVehiclelisting *objectVehicleListing;
    
    NSDateFormatter* formatter;
    
    NSInteger selectedRowFromYear;
    NSInteger selectedRowToYear;
    
    MBProgressHUD *HUD;
    SMAppDelegate *appdelegate;
    NSString *sortingText;
    
    BOOL isSearch;
    BOOL isLabelWinBeatValueHidden;
    
    __weak IBOutlet UIButton *checkBoxAll;
    
    __weak IBOutlet UIButton *checkBoxTrade;
    
    __weak IBOutlet UIButton *checkBoxFactory;
    
    __weak IBOutlet UIButton *checkBoxTenders;
    
    __weak IBOutlet UIButton *checkBoxPrivate;
    
    // down arrow images for hidding at run time
    
    __weak IBOutlet UIImageView *imgViewArrow1;
    
    __weak IBOutlet UIImageView *imgViewArrow2;
    
    __weak IBOutlet UIImageView *imgViewArrow3;
    
    __weak IBOutlet UILabel *lblVehicleCountSeparator;
    
    __weak IBOutlet UIImageView *imgViewSelectMakeDownArrow;
    
}

#pragma mark -

@property(weak,nonatomic)     IBOutlet  SMCustomLable        *lblDefaultYear;
@property(weak,nonatomic)     IBOutlet  SMCustomLable        *lblDefaultMake;
@property(weak,nonatomic)     IBOutlet  SMCustomLable        *lblDefaultModel;
@property(weak,nonatomic)     IBOutlet  SMCustomLable        *lblDefaultVariant;
@property(weak,nonatomic)     IBOutlet  SMCustomLable        *lblDefaultTo;
@property(weak, nonatomic)    IBOutlet  SMCustomLable        *labelNoSearchResult;
@property (strong, nonatomic) IBOutlet  SMCustomLable        *lblSortBy;

#pragma mark - Properties
@property(weak,nonatomic)     IBOutlet  UITableView          *tableTrader;
@property(weak,nonatomic)     IBOutlet  UITableView          *tableSearch;
//@property(weak,nonatomic)     IBOutlet  UITableView          *tableSlide;

@property(strong,nonatomic)   IBOutlet  UIView               *viewHeader;
@property(weak, nonatomic)    IBOutlet  UIView               *viewYearFrame;
@property(weak, nonatomic)    IBOutlet  UIView               *viewDropdownFrame;

@property(weak, nonatomic)    IBOutlet  UIView               *viewVehicleFound;

@property (strong, nonatomic) IBOutlet  SMCustomLabelBold    *lblVehicleFound;

@property(weak, nonatomic)    IBOutlet SMCustomTextField     *txtYearFrom;
@property(weak, nonatomic)    IBOutlet SMCustomTextField     *txtYearTo;
@property(weak, nonatomic)    IBOutlet SMCustomTextField     *txtMake;
@property(weak, nonatomic)    IBOutlet SMCustomTextField     *txtModel;
@property(weak, nonatomic)    IBOutlet SMCustomTextField     *txtVariants;

@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnClear;

@property (strong, nonatomic) IBOutlet UITextField           *txtFieldSortBy;

@property (weak, nonatomic)   IBOutlet UIButton              *cancelButton;
@property (weak, nonatomic)   IBOutlet UIButton              *clearBtn;
@property (strong, nonatomic) IBOutlet UIButton              *pickerBtnCancel;
@property (strong, nonatomic) IBOutlet UIButton              *pickerBtnDone;

#pragma mark -  Methods

-(IBAction)buttonSearchDidClicked:(id)sender;

-(IBAction)buttonFilterDidPressed:(id)sender;

-(IBAction)buttonCancelDidPressed:(id)sender;

-(IBAction)buttonSetFromDate:(id)sender;

-(IBAction)buttonCancelDatePicker:(id)sender;

- (IBAction)clearBtnClicked:(id)sender;

- (IBAction)btnClearDidClicked:(id)sender;

- (void) getRefreshedVehicleListing;

// CheckBoxes

- (IBAction)checkBoxAllDidClicked:(id)sender;

- (IBAction)checkBoxTradeDidClicked:(id)sender;

- (IBAction)checkBoxFactoryDidClicked:(id)sender;

- (IBAction)checkBoxTenderDidClicked:(id)sender;

- (IBAction)checkBoxPrivateDidClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgDownArrowYearFrom;


@end
