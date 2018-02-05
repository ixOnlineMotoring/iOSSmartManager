//
//  SMVehicle_DateWiseAudit_ViewController.h
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
#import "FGalleryViewController.h"
#import "SMStockAuditDetailObject.h"

@interface SMVehicle_DateWiseAudit_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,UIAlertViewDelegate,FGalleryViewControllerDelegate>
{
    NSMutableArray *arrayOFDateWiseAudit;
    
    NSXMLParser *xmlParser;
    MBProgressHUD *HUD;
    NSMutableString *currentNodeContent;
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
    
    
    // pagination stuff
    
    int pageNumberCount;
    BOOL isListingDataBeingFetched;
    BOOL isLoadMore;
    int totaCount;


}


@property(strong,nonatomic)SMStockAuditDetailObject *auditHistoryDetailObj;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldEmailAddress;

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnSubmit;

@property (strong, nonatomic) IBOutlet UITableView *tblViewDateWiseAuditList;

@property(strong,nonatomic) NSString *selectedDateStr;
@property(strong,nonatomic) NSString *selectedDateStrForTitle;

- (IBAction)btnSubmitDidClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnExpandEmailList;

- (IBAction)btnExpandEmailListDidClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIImageView *imgViewRightArrow;

@end
