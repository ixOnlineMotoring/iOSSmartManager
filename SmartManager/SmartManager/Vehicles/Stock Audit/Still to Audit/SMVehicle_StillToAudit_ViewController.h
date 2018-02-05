//
//  SMVehicle_StillToAudit_ViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 04/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomTextField.h"
#import "MBProgressHUD.h"
//#import "SMVehicleNameVinNoCell.h"
#import "SMStockListCell.h"
#import "SMVehicleAuditDetailCell.h"
#import "FGalleryViewController.h"
#import "SMStockAuditDetailObject.h"



// this to commit in SVN

@interface SMVehicle_StillToAudit_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,FGalleryViewControllerDelegate>
{

    // For Gallery View
    
    NSArray                     *   localCaptions;
    NSArray                     *   localImages;
    NSArray                     *   networkCaptions;
    NSArray                     *   networkImages;
    FGalleryViewController      *   localGallery;
    FGalleryViewController      *   networkGallery;
    
    NSString *finalPathLicseImage;
    NSString *finalPathVechImage;
    NSInteger buttonIndex;
    

    
    
    
    NSMutableArray *arrayOfSections;
    NSMutableArray *arrayForFirstSection;
    NSMutableArray *arrayForSecondSection;
    UIImageView *imageViewArrowForsection;
    
    NSXMLParser *xmlParser;
    MBProgressHUD *HUD;
    NSMutableString *currentNodeContent;
    
    BOOL isUnmatchedSectionClicked;
    int totalUnMatchedCount;
    int totalNotScannedVehicles;
    int totalAuditsCount;
    BOOL isSectionFirstOpened;
    BOOL isSectionSecondOpened;
    UILabel *countLbl;

    BOOL isSectionWisePagination;
    BOOL isCountSection;
    int pageNumberUnMatchedCount;
    int pageNumberUnScannedCount;
    BOOL isLoadMore;

}

@property(strong,nonatomic)SMStockAuditDetailObject *auditedTodayObject;


@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldEmailAddress;

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnSubmit;

@property (strong, nonatomic) IBOutlet UITableView *tblViewStillToAuditList;

- (IBAction)btnSubmitDidClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnExpandEmailList;

- (IBAction)btnExpandEmailListDidClicked:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *headerView;


@property (strong, nonatomic) IBOutlet UIImageView *imgRightArrowTH;


@property (strong, nonatomic) IBOutlet UIView *sectionfooterView;

@property (strong, nonatomic) IBOutlet UILabel *lblSectionFooter;

@property (strong, nonatomic) IBOutlet UIView *sectionFooterViewIpad;

@property (strong, nonatomic) IBOutlet UILabel *lblSectionFooterIPad;


@end
