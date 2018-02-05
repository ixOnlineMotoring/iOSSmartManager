//
//  SMMyLeadsDetailViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 04/05/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"
#import "MBProgressHUD.h"
#import "SMLeadListObject.h"
#import "SMLeadDetailObject.h"
#import <MessageUI/MessageUI.h>


@protocol refreshLeadList <NSObject>

-(void) refreshTheLeadListModule;

@end


@interface SMMyLeadsDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,MFMailComposeViewControllerDelegate>
{

    SMLeadListObject *leadObject;
    
    NSMutableArray  *arrayForSections;
    NSMutableString *currentNodeContent;
    
    CGPoint svos;
    MBProgressHUD   *HUD;
    NSXMLParser     *xmlParser;
    
    BOOL isTheLeadNew;
    BOOL isTheLeadMatched;
    BOOL isActivityParsing;
    BOOL isActivityOptions;
    BOOL isTradeInPresent;
    BOOL isActivitySelectedIsDelivered;
    CGRect originalHeaderHeight;
    CGRect originalBottomHeight;
    
    int selectedActivityID;
    int activityID;
    NSString *strLeadYear;
    NSString *strLeadMileage;
    NSString *strLeadName;
    
    // vehicle details..
    
    NSString *vehicleName;
    NSString *vehicleMMCode;
    NSString *vehicleYear;
    NSString *vehicleMileage;
    NSString *vehicleColor;
    NSString *usedVehicleStockID;
    NSString *vehicleStockCode;
    NSString *userProspectName;
    
    // last update details.
    
    NSString *lastUpdateDate;
    NSString *lastUpdateActivity;
    NSString *lastUpdateUser;
    
    UIImageView *imageViewArrowForsection;
    UILabel *listActiveSpecialsNavigTitle;
    
    
    NSString *lblTradeInVehicleName;
    NSString *lblTradeInYearModel;
    NSString *lblTradeInMileage;
    
    SMLeadDetailObject        *leadDetailObject;
    
    
    IBOutlet UIView *popUpDateView;
    
    IBOutlet UIView *dateView;
    
    IBOutlet UIDatePicker *datePickerForTime;
    
    IBOutlet UIView *sectionTradeIn;
    
    IBOutlet UIButton *btnTradeIb;
    
    BOOL isTradeIn;
    
}



-(IBAction)buttonCancelPopupDidPressed:(id)sender;

@property (nonatomic, weak) id <refreshLeadList> listRefreshDelegate;

@property (strong, nonatomic) NSMutableArray  *arrayForActivity;

@property (strong, nonatomic) SMLeadDetailObject *leadDetailObject;
@property(assign) NSIndexPath *indexPathForActivity;

@property (assign) int leadID;

//@property (strong, nonatomic) IBOutlet UIView        *headerView;
@property (strong, nonatomic) IBOutlet UIView        *viewBottom;

@property (strong, nonatomic) IBOutlet UIView        *popUpView;
//@property (strong, nonatomic) IBOutlet UIView        *headerViewIpad;
@property (strong, nonatomic) IBOutlet UIView        *innerPopUpView;

@property (strong, nonatomic) IBOutlet UITableView *tblViewLeadDetails;
@property (strong, nonatomic) IBOutlet UITableView *tblViewActivity;
@property (strong, nonatomic) IBOutlet UIView *sectionHeaderView;

@property (strong, nonatomic) IBOutlet UIButton *sectionLabelBtn;

@property (strong, nonatomic) IBOutlet UIView *sectionHeaderViewIpad;

@property (strong, nonatomic) IBOutlet UIButton *sectionLabelBtnIpad;




@property (strong, nonatomic) IBOutlet SMCustomLable *lblProspect;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblPhone;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblEmail;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblEnquiredOn;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblTiming;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblSource;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblDate;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblLastUpdate;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblProspectValue;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblPhoneValue;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblEmailValue;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblEnquiredValue;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblTimingValue;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblSourceValue;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblDateValue;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblLastUpdateValue;



// for iPad

@property (strong, nonatomic) IBOutlet SMCustomLable *lblProspectIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblPhoneIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblEmailIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblEnquiredOnIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblTimingIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblSourceIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblDateIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblLastUpdateIpad;
@property (strong, nonatomic) IBOutlet UIView        *viewBottomIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblProspectValueIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblPhoneValueIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblEmailValueIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblEnquiredValueIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblTimingValueIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblSourceValueIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblDateValueIpad;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblLastUpdateValueIpad;

- (IBAction)btnCancelDateDidClicked:(id)sender;

- (IBAction)btnSetDateDidClicked:(id)sender;



@end
