//
//  SMWantedViewController.h
//  SmartManager
//
//  Created by Ketan Nandha on 23/02/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "CustomTextView.h"
#import "MBProgressHUD.h"
#import "SMDropDownObject.h"
#import "SWTableViewCell.h"

enum
{
    isAddWanted,
    isRemoveWanted
};

@interface SMWantedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,NSXMLParserDelegate,MBProgressHUDDelegate,SWTableViewCellDelegate>
{
    NSMutableArray  *arrayWantedSearch;
//    NSMutableArray  *arrayMakeModelData;
    NSMutableArray  *arrayYears;
    NSMutableArray  *arrayVariant;
    NSMutableArray  *arrayRegion;

    NSMutableArray  *arrayMake;
    NSMutableArray  *arrayModel;

    int currentYear;
    int selectedIndex;
    int makeID;
    int modelID;
    BOOL isWanted;
    BOOL isClicked;

    int selectedMakeIndex;
    int selectedModelIndex;

    NSInteger selectedRowFromYear;
    NSInteger selectedRowToYear;
    
    NSDateFormatter *formatter;

    NSXMLParser *xmlParser;
    MBProgressHUD *HUD;
    NSMutableString *currentNodeContent;
    
    SMDropDownObject *objectDropDown;
    
    NSMutableString *strRegion;
    NSMutableString *strVariant;
    
    NSInteger indexRow;
    NSIndexPath *indexRemoved;
    
    int cellScrolled;
}
@property (nonatomic,strong) IBOutlet UITableView   *tableWanted;
@property (nonatomic,strong) IBOutlet UITableView   *tablePopUp;
@property (nonatomic,strong) IBOutlet UITableView   *tableVariant;
@property (nonatomic,strong) IBOutlet UITableView   *tableRegion;

@property (nonatomic,strong) IBOutlet UIView    *headerView;
@property (nonatomic,strong) IBOutlet UIView    *secondHeaderView;
@property (nonatomic,strong) IBOutlet UIView    *popupView;
@property (nonatomic,strong) IBOutlet UIView    *viewTablePopUp;
@property (nonatomic,strong) IBOutlet UIView    *viewPickerPopUp;
@property (nonatomic,strong) IBOutlet UIView    *viewRegion;

@property (nonatomic,strong) IBOutlet UIImageView   *imgViewArrow;

@property (nonatomic,strong) IBOutlet UIPickerView  *pickerYear;

@property (nonatomic,strong) IBOutlet UILabel   *lblYear;
@property (nonatomic,strong) IBOutlet UILabel   *lblTo;
@property (nonatomic,strong) IBOutlet UILabel   *lblMake;
@property (nonatomic,strong) IBOutlet UILabel   *lblModel;
@property (nonatomic,strong) IBOutlet UILabel   *lblVariant;
@property (nonatomic,strong) IBOutlet UILabel   *lblRegion;

@property (nonatomic,strong) IBOutlet UILabel   *lblUpperline;
@property (nonatomic,strong) IBOutlet UILabel   *lblUnderline;

@property (nonatomic,strong) IBOutlet UILabel   *lblWantedList;
@property (nonatomic,strong) IBOutlet UILabel   *lblSwipe;

@property (nonatomic,strong) IBOutlet SMCustomTextField     *txtFromYear;
@property (nonatomic,strong) IBOutlet SMCustomTextField     *txtToYear;
@property (nonatomic,strong) IBOutlet SMCustomTextField     *txtMake;
@property (nonatomic,strong) IBOutlet SMCustomTextField     *txtModel;
@property (nonatomic,strong) IBOutlet CustomTextView        *txtVariant;

@property (nonatomic,strong) IBOutlet UIButton      *btnAddToWantedList;
@property (nonatomic,strong) IBOutlet UIButton      *btnHeaderFilter;
@property (nonatomic,strong) IBOutlet UIButton      *btnSearchAll;
@property (nonatomic,strong) IBOutlet UIButton      *btnCancel;
@property (nonatomic,strong) IBOutlet UIButton      *btnDone;

-(IBAction)btnHeaderFilterDidClicked:(id)sender;
-(IBAction)btnSearchAllDidClicked:(id)sender;
-(IBAction)btnCancelDidClicked:(id)sender;
-(IBAction)btnDoneDidClicked:(id)sender;

@end
