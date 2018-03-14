//
//  SMSettings_AuctionViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 04/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextFieldForDropDown.h"
#import "SMDropDownObject.h"
#import "MyRSAPickerView.h"
#import "MBProgressHUD.h"


@interface SMSettings_AuctionViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,MBProgressHUDDelegate,NSXMLParserDelegate>
{

    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    MBProgressHUD *HUD;
    
    NSMutableArray  *arraySortObject;
    SMDropDownObject *objectDropDown;
    __weak IBOutlet UIButton *btnSaveAuction;

    IBOutlet UIScrollView *scrollView;

    IBOutlet UIView *contentView;

    IBOutlet SMCustomTextFieldForDropDown *txtFieldAskingPrice;

    IBOutlet SMCustomTextFieldForDropDown *txtFieldBidIncrease;

    IBOutlet SMCustomTextFieldForDropDown *txtFieldBuyNowPrice;
    
    IBOutlet SMCustomTextFieldForDropDown *txtFieldFrom;
    
    IBOutlet SMCustomTextFieldForDropDown *txtFieldFor;
    
    IBOutlet SMCustomTextFieldForDropDown *txtFieldBidsReceived;
    
    IBOutlet UIView *popUpView;
    
    IBOutlet UIView *viewDropdownFrame;
    
    IBOutlet UITableView *tblViewOptions;
    
    IBOutlet UIButton *btnCancelOptions;
    
    NSUInteger selectedRowIndex;
    
    MyRSAPickerView *pickerViewAskingPrice;
    MyRSAPickerView *pickerViewBidIncrease;
    MyRSAPickerView *pickerViewBuyNowPrice;
    MyRSAPickerView *pickerViewAvailableFrom;
    MyRSAPickerView *pickerViewAvailableFor;
    MyRSAPickerView *pickerViewExtendBuy;
    
    __weak IBOutlet UIButton *checkBox1;
    
    __weak IBOutlet UIButton *checkBox2;
   
}

- (IBAction)checkBoxAutoExtendBidDidClicked:(id)sender;

- (IBAction)checkBoxAcceptBidsDidClciked:(id)sender;

- (IBAction)btnSaveDidClicked:(id)sender;

- (IBAction)btnCancelOptionsDidClicked:(id)sender;


@end
