//
//  SMAddEditTradePartnersViewController.h
//  Smart Manager
//
//  Created by Sandeep on 06/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMCustomTextFieldForDropDown.h"
#import "SMClassForNewTaskMembers.h"
#import "SMListTradePartnersObject.h"

@interface SMAddEditTradePartnersViewController : UIViewController<NSXMLParserDelegate,MBProgressHUDDelegate,UITextFieldDelegate>{
    
    IBOutlet SMCustomTextFieldForDropDown *selectTypeTextField;
    IBOutlet SMCustomTextFieldForDropDown *selectPartnerTextField;
    IBOutlet SMCustomTextFieldForDropDown *fromDayTextField;

    NSMutableArray *selectTypeArray;
    NSMutableArray *selectPartnerArray;
    NSMutableArray *fromDayArray;
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;

    int settingsID;
    int selectTypeID;
    int selectPartnerID;
    int selectFromDayID;
    int selectedTextFieldTag;

    SMClassForNewTaskMembers *membersObject;

    CGRect tableOriginalFrame;
    CGRect viewForClientsDropdownOriginalFrame;
}
@property (strong, nonatomic) SMListTradePartnersObject *obj;
@property (assign, nonatomic)BOOL isAddPartners;


@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (strong, nonatomic) IBOutlet UIView *viewForClientsDropdown;
@property (strong, nonatomic) IBOutlet UITableView *tblViewType;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveButtonDidClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
- (IBAction)removeButtonDidClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *tradeVechiclesCheckBoxButton;
@property (weak, nonatomic) IBOutlet UIButton *tenderVechiclesCheckBoxButton;
- (IBAction)checkBoxDidClicked:(id)sender;

@end
