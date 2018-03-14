//
//  SMTrader_WinningBidsViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 27/10/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCalenderTextField.h"
#import "SMCustomButtonBlue.h"
#import "SMVehiclelisting.h"
#import "SMCustomSellObject.h"
#import "MBProgressHUD.h"

// hjhjghjghjghjghjj
@interface SMTrader_WinningBidsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;

    IBOutlet UITableView *tblViewMyBids;
    MBProgressHUD *HUD;

    IBOutlet SMCalenderTextField *txtStartDate;
    IBOutlet SMCalenderTextField *txtEndDate;
    IBOutlet SMCustomButtonBlue *btnSearch;
    
    IBOutlet UIView *popupView;
    IBOutlet UIView *viewDatePicker;
    IBOutlet UIButton *btnCancel;
    IBOutlet UIButton *btnDone;
    UILabel *listActiveSpecialsNavigTitle;
    IBOutlet UIDatePicker *datePicker;
    
    int iCancelled;
    int iWithdrawn;
    int iPrivate;
    int iWon;
    int iLost;
    
    int iTotalWon;
    int iTotalLost;
    int iTotalCancelled;
    int iTotalWithdrawn;
    int iTotalPrivateOffers;
    
    int totalRecordCount;
    int selectedType;
    BOOL isDefaultList;
    NSDate *startDate;
    NSDate *endDate;

    NSMutableArray *tempDataArray;

    
    
    
    SMVehiclelisting *objectVehicleListing;
    SMCustomSellObject *objCustomSell;

}

@property(assign,nonatomic)NSUInteger viewControllerBidType;

@property(nonatomic,strong) NSMutableArray *arrayWithdrawnBids;
@property(nonatomic,strong) NSMutableArray *arrayPrivateBids;
@property(nonatomic,strong) NSMutableArray *arrayCancelledBids;
@property(nonatomic,strong) NSMutableArray *arrayWon;
@property(nonatomic,strong) NSMutableArray *arrayLost;

-(IBAction)btnSearchDidClicked:(id)sender;
-(IBAction)btnCancelDidClicked:(id)sender;
-(IBAction)btnDoneDidClicked:(id)sender;


@end
