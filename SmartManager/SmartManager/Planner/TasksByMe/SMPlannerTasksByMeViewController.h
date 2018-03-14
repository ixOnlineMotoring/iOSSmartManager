//
//  SMPlannerTasksByMeViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 19/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMClassForToDoInnerObjects.h"
#import "SMClassForToDoMemberLocationObject.h"
#import "CustomTextView.h"
#import "SMCustomCellForTodayTableViewCell.h"
#import "MBProgressHUD.h"
@interface SMPlannerTasksByMeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,pushingViewContollerForEnlargingPhotoDelegate,MBProgressHUDDelegate>
{
    
    MBProgressHUD *HUD;
    
    NSMutableArray *arrayForSections;
    NSMutableArray *arrayOfInnerObjects;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrayOfMemberLocationObjects;
    NSMutableArray *arrayOfMemberPeriodObjects;
    
    NSComparisonResult result;
    UIImageView *imageViewArrowForsection;
    UILabel *countLbl;

     NSIndexPath *taskIDForDoneTask;
    
    BOOL isTaskRejected;
    
    int taskIDForRejectTask;
}

@property (strong, nonatomic) IBOutlet UITableView *tblViewTasksByMe;

@property (strong, nonatomic) IBOutlet UIView *popUpView;

@property (strong, nonatomic) IBOutlet UIView *viewForReason;


@property (strong, nonatomic) IBOutlet CustomTextView *txtViewReason;


@property (strong, nonatomic) IBOutlet UIButton *btnReasonCancel;


@property (strong, nonatomic) IBOutlet UIButton *btnReasonSend;

@property (strong, nonatomic) IBOutlet UILabel *lblDynamicHeight;
@property (strong, nonatomic) IBOutlet UIView *viewForTaskDetails;

@property (strong, nonatomic) IBOutlet UILabel *lblTaskDetails;



- (IBAction)btnCancelForReasonDidClicked:(id)sender;

- (IBAction)btnSendForReasonDidClicked:(id)sender;

- (IBAction)btnCancelForTaskDetailsDidClicked:(id)sender;




@property (strong, nonatomic) SMClassForToDoMemberLocationObject *locMemberObject;
@property (strong, nonatomic) SMClassForToDoInnerObjects *taskDetailObject;



@end
