//
//  SMReusableHeaderViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 05/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMCustomTextField.h"
#import "CustomTextView.h"
#import "SMDropDownObject.h"
#import "MBProgressHUD.h"

@interface SMReusableHeaderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,NSXMLParserDelegate,MBProgressHUDDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{

    __weak IBOutlet UITableView *tblViewReusableHeaderDemo;
    
    UIImageView *imageViewArrowForsection;
    UILabel *countLbl;
    
    NSMutableArray *arrayOfSections;
    NSMutableArray *arrayOfMessages;
     IBOutlet CustomTextView *txtviewComments;
    
    //---xml parsing---
    NSXMLParser                 *xmlParser;
    NSMutableString             *currentNodeContent;
    IBOutlet UIButton *btnSubmit;
    
    int selectedIndexPath;
    
    
    MBProgressHUD *HUD;
    __weak IBOutlet UIView *tblHeaderView;
    
    
    // Table Header filters 
    
    IBOutlet UITableView   *tablePopUp;
    IBOutlet UITableView   *tableVariant;
    IBOutlet UITableView   *tableRegion;
    IBOutlet UIView    *popupView;
    IBOutlet UIView    *viewTablePopUp;
    IBOutlet UIView    *viewPickerPopUp;
    IBOutlet UIView    *viewRegion;
    IBOutlet UIImageView   *imgViewArrow;
    IBOutlet UIPickerView  *pickerYear;
    IBOutlet UILabel   *lblYear;
    IBOutlet UILabel   *lblTo;
    IBOutlet UILabel   *lblMake;
    IBOutlet UILabel   *lblModel;
    IBOutlet UILabel   *lblVariant;
    IBOutlet UILabel   *lblRegion;
    IBOutlet SMCustomTextField     *txtFromYear;
    IBOutlet SMCustomTextField     *txtToYear;
    IBOutlet SMCustomTextField     *txtMake;
    IBOutlet SMCustomTextField     *txtModel;
    IBOutlet CustomTextView        *txtVariant;
    IBOutlet UIButton      *btnHeaderFilter;
    IBOutlet UIButton      *btnCancel;
    IBOutlet UIButton      *btnDone;
    
    int currentYear;
    int selectedIndex;
    int makeID;
    int modelID;
    int selectedMakeIndex;
    int selectedModelIndex;
    
    NSInteger selectedRowFromYear;
    NSInteger selectedRowToYear;
    
    NSMutableArray  *arrayYears;
    NSMutableArray  *arrayVariant;
    NSMutableArray  *arrayRegion;
    
    NSMutableArray  *arrayMake;
    NSMutableArray  *arrayModel;

     NSDateFormatter *formatter;
    
    SMDropDownObject *objectDropDown;
    
    NSString* selectedFromYear;
    NSString*  selectedToYear;

}
- (IBAction)btnactnSubmitDidClicked:(id)sender;

-(IBAction)btnHeaderFilterDidClicked:(id)sender;
-(IBAction)btnCancelDidClicked:(id)sender;
-(IBAction)btnDoneDidClicked:(id)sender;

- (IBAction)btnListDidClicked:(id)sender;

- (IBAction)btnClearDidClicked:(id)sender;


@end
