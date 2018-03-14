//
//  SMLeadsListViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 29/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "SMCustomLable.h"
#import "MBProgressHUD.h"
#import "SMLeadListObject.h"
#import "SMListVehicleDetailsObject.h"
#import "SMMyLeadsDetailViewController.h"

@interface SMLeadsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,MBProgressHUDDelegate,UITextFieldDelegate,refreshLeadList>
{
    NSMutableArray *arrayForSections;
    NSXMLParser    *xmlParser;
    
    NSMutableArray *arrayOfWIPLeads;
    NSMutableArray *arrayOfUnseenLeads;
    NSMutableString *currentNodeContent;
    BOOL isSeen;
    BOOL isSectionWisePagination;
    
    int pageNumberUnseenCount;
    int pageNumberWIPCount;
    int iTotalArrayCount;
    int iTotalArrayCountUnseen;
    
    int sortByOptionSelectedWIP;
    int sortByOptionSelectedUnseen;
    int sectionNumberSelected;
    
    NSInteger oldArrayCount;
    BOOL isLoadMore;
    int selectedRow;
    BOOL isContactInfoPresent;
    BOOL isVehicleDetailsPresent;
    BOOL isSortByOptionDisabled;
    MBProgressHUD *HUD;
    SMLeadListObject *leadObj;
    SMListVehicleDetailsObject *leadVehicleObj;
    UIImageView *imageViewArrowForsection;
    UILabel *countLbl;
    
    BOOL isSectionFirstOpened;
    BOOL isSectionSecondOpened;
    BOOL isBothSectionsClosed;
    NSString *tempSearchStringFirstSection;
    NSString *tempSearchStringSecondSection;
    
    NSString *tempSortStringFirstSection;
    NSString *tempSortStringSecondSection;
    
    BOOL isPaginationForWIPLeads;
    
    
    
}

-(IBAction)buttonCancelPopupView:(id)sender;


@property(strong,nonatomic) NSMutableArray *arraySortFilter;

@property (strong, nonatomic) IBOutlet UITableView *tblViewMyLeadsList;


@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIButton *btnHideFilter;


@property (strong, nonatomic)  IBOutlet SMCustomLable *lblSearchKey;

@property (strong, nonatomic)  IBOutlet SMCustomLable *lblSortBy;

@property (weak, nonatomic)    IBOutlet SMCustomTextField *txtFieldSearch;
@property (weak, nonatomic)    IBOutlet SMCustomTextField *txtFieldSortBy;


@property (strong, nonatomic) IBOutlet UIView *popUpView;

@property (strong, nonatomic) IBOutlet UIView *innerPopUpView;



@property (strong, nonatomic) IBOutlet UITableView *tblSortingOption;


@end
