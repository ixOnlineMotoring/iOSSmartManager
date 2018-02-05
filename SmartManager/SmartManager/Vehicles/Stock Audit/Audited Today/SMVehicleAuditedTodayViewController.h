//
//  SMVehicleAuditedTodayViewController.h
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
#import "SMStockAuditDetailObject.h"
#import "FGalleryViewController.h"
#import "SMDonePlannerButton.h"

@interface SMVehicleAuditedTodayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,UIAlertViewDelegate,FGalleryViewControllerDelegate>
{
    
    NSXMLParser *xmlParser;
    MBProgressHUD *HUD;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrayOfAuditedToday;
     UICollectionView *imagesCollectionView;
    UIImage *lastImage;
    
    NSIndexPath *collectioIndex;
    
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
    
    int totalMatchedCount;

    
}

@property(strong,nonatomic)SMStockAuditDetailObject *auditedTodayObject;


@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldEmailAddress;

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnSubmit;

@property (strong, nonatomic) IBOutlet UITableView *tblViewAuditedTodayList;

- (IBAction)btnSubmitDidClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnExpandEmailList;

- (IBAction)btnExpandEmailListDidClicked:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIImageView *imgViewRightArrow;


@end
