//
//  SMSalesViewController.h
//  Smart Manager
//
//  Created by Jignesh on 27/10/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomButtonGrayColor.h"
#import "SMCustomLabelBold.h"
#import "SMCalenderTextField.h"
#import "MBProgressHUD.h"
#import "SMVehiclelisting.h"


@interface SMSalesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,NSXMLParserDelegate,MBProgressHUDDelegate>
{

    NSXMLParser *xmlParser;
    
    NSMutableString *currentNodeContent;
    NSMutableArray *arrayOfSales;
    
    MBProgressHUD *HUD;
    SMVehiclelisting *objectVehicleListing;

    IBOutlet UITableView        *table_SalesInformation;
    
    
    IBOutlet SMCalenderTextField  *textField_StartRange;
    IBOutlet SMCalenderTextField  *textField_EndRange;

    IBOutlet SMCustomButtonBlue           *buttonBuyer;
    IBOutlet UIButton           *buttonSeller;
    
    IBOutlet SMCustomLabelBold  *lable_salesNote;
    
    __weak IBOutlet SMCustomLabelBold *lblRedNote;
    
    
    //
  
 
    IBOutlet UIView       *dateView;
    IBOutlet UIView       *popupView;
    IBOutlet UIDatePicker *datePickerForTime;

    int                          selectedType;
    
    int                          selectedTypeForTable;
    
    int totalCount;
    int totalSalesRecordsCount;
    int iSalesPageCount;
    
    BOOL isSearchTrue;
    
}

-(IBAction)buttonCancelDidPressed:(id)sender;
-(IBAction)buttonDoneDidPrssed:(id) sender;

-(IBAction)buttonActionListSalesDidPressed:(id)sender;
-(IBAction)buttonBuyerSelleDidPrssed:(id)sender;


@end
