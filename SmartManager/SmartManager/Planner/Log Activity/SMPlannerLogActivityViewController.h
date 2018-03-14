//
//  SMPlannerLogActivityViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 17/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "CustomTextView.h"
#import "SMCustomTextFieldForDropDown.h"
#import "SMClassForLocationClients.h"
#import "SMClassForPlannerTypeList.h"
#import "SMClassForAvailableClients.h"
#import  <CoreLocation/CoreLocation.h>
#import "SMCustomLable.h"
#import "MBProgressHUD.h"

@interface SMPlannerLogActivityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,UITextFieldDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,MBProgressHUDDelegate>
{
    
    // for location
    
    CLLocationCoordinate2D coordCurrentLocation;
    CLLocationManager *locationManager;
    
    float currentLatitude;
    float currentLongitude;
    
    
    NSXMLParser *xmlParser;
     CGPoint svos;
    NSMutableArray *arrayOfTimeSpent;
    NSMutableArray *arrayOfPlanerType;
    NSMutableArray *arrayOfLocationClients;
    NSMutableArray *arrayOfAvailableClients;
    
    NSString *strLocationAddress;
    NSString *resultString;
    NSMutableString *currentNodeContent;
    NSArray *filteredArrayForClientDropdown;
    
    NSOperationQueue *downloadingQueue;
    NSTimer *timerForDelay;
    
    
    int selectedRow;
    int selectedplannerType;
    int selectedClientId;
    
    BOOL ischeckInBtnPressed;
    BOOL shouldShowErrorMessage;
    BOOL isClientsDropdownExpanded;
    BOOL isError;
    MBProgressHUD *HUD;
}


@property (strong, nonatomic) IBOutlet UITableView *tblViewActivityLog;

@property (strong, nonatomic) IBOutlet UIView *viewDetails;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldClientFilter;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldSelectClient;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldType;


@property (strong, nonatomic) IBOutlet CustomTextView *txtViewDetails;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldPersonSeenNone;



@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldTimeSpent;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldSelectDate;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldCheckIn;


@property (strong, nonatomic) SMClassForLocationClients *locClientObject;
@property (strong, nonatomic) SMClassForPlannerTypeList *plannerTypeListObject;
@property (strong, nonatomic) SMClassForAvailableClients *availableClientObject;


// Labels.

@property (strong, nonatomic) IBOutlet SMCustomLable *lblFilter;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblClient;


@property (strong, nonatomic) IBOutlet SMCustomLable *lblType;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblDetails;


@property (strong, nonatomic) IBOutlet SMCustomLable *lblPersonSeen;





@property (strong, nonatomic) IBOutlet UIButton *checkBoxInternal;

@property (strong, nonatomic) IBOutlet UIButton *checkBoxToday;

- (IBAction)checkBoxBtnInternalDidClicked:(id)sender;

- (IBAction)checkBoxBtnTodayDidClicked:(id)sender;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblInternal;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblToday;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblOr;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;

@property (strong, nonatomic) IBOutlet UIImageView *imgDownArrow;


@property (strong, nonatomic) IBOutlet UIView *dateView;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;


@property (strong, nonatomic) IBOutlet UIView *popUpView;


@property (strong, nonatomic) IBOutlet UIView *viewHeader;


@property (strong, nonatomic) IBOutlet UITableView *tblViewTimeSpent;

@property (strong, nonatomic) IBOutlet UITableView *tblViewClientsDropdown;


@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UIButton *btnCheckIn;


@property (strong, nonatomic) IBOutlet UILabel *lblLocationAddress;

@property (strong, nonatomic) IBOutlet UIView *viewForClientsDropdown;



- (IBAction)btnCheckInDidClicked:(id)sender;


- (IBAction)btnCancelDidClicked:(id)sender;


- (IBAction)btnCancelFromDatePickerDidClicked:(id)sender;

- (IBAction)btnClearFromDatePickerDidClicked:(id)sender;

- (IBAction)btnDoneFromDateViewDidClicked:(id)sender;


- (IBAction)btnSaveDidClicked:(id)sender;


@end
