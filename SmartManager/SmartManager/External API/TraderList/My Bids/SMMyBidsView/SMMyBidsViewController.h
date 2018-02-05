//
//  SMMyBidsViewController.h
//  SmartManager
//
//  Created by Ketan Nandha on 10/12/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMClassForToDoMemberLocationObject.h"
#import "SMVehiclelisting.h"
#import "SMCustomSellObject.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomTextField.h"
#import "SMClassForToDoObjects.h"
#import "SMCalenderTextField.h"

@interface SMMyBidsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,UITextFieldDelegate>
{
    NSMutableArray *arrayForSections;
    UIImageView *imageViewArrowForsection;
    UILabel *countLbl;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    
    SMVehiclelisting *objectVehicleListing;
    SMCustomSellObject *objCustomSell;
    SMClassForToDoObjects *sectionObject;
    
    int currentIndex;
    int previousIndex;
    
    int selectedType;

    NSDate *startDate;
    NSDate *endDate;

    int iWinning;
    int iLoosing;
    int iWon;
    int iLost;
    
    int iTotalWon;
    int iTotalLost;
    int iTotalLoosing;
    int iTotalWinning;
        
    NSMutableArray *tempDataArray;
    int totalRecordCount;
}
@property (strong, nonatomic) IBOutlet UITableView *tblViewMyBids;

@property (strong, nonatomic) IBOutlet SMCalenderTextField *txtStartDate;
@property (strong, nonatomic) IBOutlet SMCalenderTextField *txtEndDate;
@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnSearch;

@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (strong, nonatomic) IBOutlet UIView *viewDatePicker;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

-(IBAction)btnSearchDidClicked:(id)sender;
-(IBAction)btnCancelDidClicked:(id)sender;
-(IBAction)btnDoneDidClicked:(id)sender;

@property(nonatomic,strong) NSMutableArray *arrayGetCount;
@property(nonatomic,strong) NSMutableArray *arrayLosingBid;
@property(nonatomic,strong) NSMutableArray *arrayWinningBid;
@property(nonatomic,strong) NSMutableArray *arrayWon;
@property(nonatomic,strong) NSMutableArray *arrayLost;

@end
