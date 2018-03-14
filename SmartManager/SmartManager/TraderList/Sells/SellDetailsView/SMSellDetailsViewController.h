//
//  SMSellDetailsViewController.h
//  SmartManager
//
//  Created by Ketan Nandha on 10/12/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGalleryViewController.h"
#import "SMVehiclelisting.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomButtonGrayColor.h"
#import "SMCustomLabelBold.h"
#import "SMCustomLable.h"
#import "MBProgressHUD.h"
enum taskSelected
{
    acceptBidTrade = 1,
    rejectBidTrade = 2,
    extendBidTrade = 3,
    noBidTrade = 4
};

@interface SMSellDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,UICollectionViewDelegate,UICollectionViewDataSource,FGalleryViewControllerDelegate,MBProgressHUDDelegate>
{
    NSMutableArray          *arrayVehicleListing;
    NSMutableArray          *arrayImages;
    FGalleryViewController  *networkGallery;
    NSArray                 *networkCaptions;
    NSIndexPath             *checkedIndexPath;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    SMVehiclelisting *objectVehicleList;
    BOOL checkFlag;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UITableView *tblViewSellDetails;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionSellDetails;
@property (strong, nonatomic) SMVehiclelisting *objectVehicleListing;

@property (strong, nonatomic) IBOutlet UIView *headerViewSellDetails;
@property (strong, nonatomic) IBOutlet UIView *headerViewForLabel;
@property (strong, nonatomic) IBOutlet UIView *sectionHeaderBidReceived;
@property (strong, nonatomic) IBOutlet UIView *sectionHeaderRejectAcceptBid;
@property (strong, nonatomic) IBOutlet UIView *sectionHeaderExtendBidding;
@property (strong, nonatomic) IBOutlet UIView *sectionHeaderEditVehicles;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblVehicle;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblDays;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblStreetName;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblRetailPrice;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblType;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblFullDate;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblEnded;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblBidReceived;

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnAcceptBid;

@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnRejectBid;
@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnExtendBidding;
@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnEditVehiclesDetail;

- (IBAction)btnAcceptBidDidClicked:(id)sender;
- (IBAction)btnRejectBidDidClicked:(id)sender;
- (IBAction)btnExtendBiddingDidClicked:(id)sender;
- (IBAction)btnEditVehiclesDetailDidClicked:(id)sender;

@end
