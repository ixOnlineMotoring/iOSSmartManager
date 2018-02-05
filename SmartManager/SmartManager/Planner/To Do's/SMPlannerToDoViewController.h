//
//  SMPlannerToDoViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 04/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMClassForToDoMemberLocationObject.h"
#import "SMClassForToDoInnerObjects.h"
#import  <CoreLocation/CoreLocation.h>
#import "CustomTextView.h"
#import "SMCustomCellForTodayTableViewCell.h"
#import "MBProgressHUD.h"
@interface SMPlannerToDoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,UITextFieldDelegate,pushingViewContollerForEnlargingPhotoDelegate,MBProgressHUDDelegate>
{
    
    // for location
    
    CLLocationCoordinate2D coordCurrentLocation;
    CLLocationManager *locationManager;
    
    
    float currentLatitude;
    float currentLongitude;
    BOOL isMemberPeriod;
    BOOL isTaskNew;
    
    int taskIDForRejectTask;
    NSIndexPath *taskIDForDoneTask;
    
    NSString *txtReason;
    NSString *resultString;
    
    NSMutableArray *arrayForSections;
    NSMutableArray *arrayOfInnerObjects;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    int selectedTaskID;
    NSMutableArray *arrayOfMemberLocationObjects;
     NSMutableArray *arrayOfMemberPeriodObjects;
    
    NSComparisonResult result;
    UIImageView *imageViewArrowForsection;
    UILabel *countLbl;
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UIView *popUpView;

@property (strong, nonatomic) IBOutlet UIView *viewForReason;


@property (strong, nonatomic) IBOutlet CustomTextView *txtViewReason;


@property (strong, nonatomic) IBOutlet UIButton *btnReasonCancel;


@property (strong, nonatomic) IBOutlet UIButton *btnReasonSend;

@property (strong, nonatomic) IBOutlet UILabel *lblDynamicHeight;


@property (strong, nonatomic) IBOutlet UITableView *tblViewToDo;

@property (strong, nonatomic) IBOutlet UIView *viewForTaskDetails;

@property (strong, nonatomic) IBOutlet UILabel *lblTaskDetails;



@property (strong, nonatomic) SMClassForToDoMemberLocationObject *locMemberObject;
@property (strong, nonatomic) SMClassForToDoInnerObjects *taskDetailObject;


- (IBAction)btnCancelForReasonDidClicked:(id)sender;

- (IBAction)btnSendForReasonDidClicked:(id)sender;

- (IBAction)btnCancelForTaskDetailsDidClicked:(id)sender;



@end
