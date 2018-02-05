//
//  SMAddEditTradeMemeberViewController.h
//  Smart Manager
//
//  Created by Sandeep on 06/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextFieldForDropDown.h"
#import "SMTradeMembersObject.h"
#import "SMMemeberUpdateList.h"
#import "MBProgressHUD.h"
#import "SMClassForNewTaskMembers.h"

@interface SMAddEditTradeMemeberViewController : UIViewController<NSXMLParserDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
{
    IBOutlet SMCustomTextFieldForDropDown *memeberTextField;

    IBOutlet UIButton *buyButton;
    IBOutlet UIButton *sellButton;
    IBOutlet UIButton *acceptButton;
    IBOutlet UIButton *declineButton;
    IBOutlet UIButton *managerButton;
    IBOutlet UIButton *auditorButton;
    IBOutlet UIButton *removeButton;
    IBOutlet UIButton *saveButton;
    MBProgressHUD *HUD;
    SMTradeMembersObject *obj;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;

    int selectedClientId;
    NSMutableArray *arrayOfMembers;
}
@property (strong, nonatomic) SMClassForNewTaskMembers *membersObject;
@property (assign, nonatomic)BOOL isAddMember;
@property (strong, nonatomic)SMTradeMembersObject *obj;
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (strong, nonatomic) IBOutlet UIView *viewForClientsDropdown;
@property (strong, nonatomic) IBOutlet UITableView *tblViewType;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
-(IBAction)saveButtonDidclicked:(id)sender;
-(IBAction)removeButtonDidclicked:(id)sender;
-(IBAction)checkBoxButtonDidclicked:(id)sender;
@end
