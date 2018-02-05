//
//  SMTraderPrivateOffersViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 28/10/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCalenderTextField.h"
#import "SMCustomButtonBlue.h"
#import "SMVehiclelisting.h"
#import "MBProgressHUD.h"

@interface SMTraderPrivateOffersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    MBProgressHUD *HUD;

    IBOutlet UITableView *tblViewMyBids;
    IBOutlet UIView *popupView;
    IBOutlet UIView *viewDatePicker;
    IBOutlet UIButton *btnCancel;
    
    IBOutlet UIButton *btnDone;
    IBOutlet UIDatePicker *datePicker;
    UILabel *listActiveSpecialsNavigTitle;

    int iWinning;
    int iLosing;
    int iAutoBid;
    int totalRecordCount;
    int iTotalWinning;
    int iTotalLosing;
    int iTotalAutoBid;

    
    SMVehiclelisting *objectVehicleListing;
    NSMutableArray *tempDataArray;

}

@property(assign,nonatomic)NSUInteger viewControllerBidType;

@property(nonatomic,strong) NSMutableArray *arrayAutoBid;
@property(nonatomic,strong) NSMutableArray *arrayLosingBid;
@property(nonatomic,strong) NSMutableArray *arrayWinningBid;

-(IBAction)btnCancelDidClicked:(id)sender;
-(IBAction)btnDoneDidClicked:(id)sender;


@end
