//
//  SMActiveTradesViewController.h
//  Smart Manager
//
//  Created by Jignesh on 03/11/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMVehiclelisting.h"
#import "MBProgressHUD.h"
#import "FGalleryViewController.h"
#import "SMAppDelegate.h"


@interface SMActiveTradesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,NSXMLParserDelegate,MBProgressHUDDelegate,FGalleryViewControllerDelegate>
{

    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    MBProgressHUD *HUD;
    UILabel                         *   countLbl;

    IBOutlet UITableView            *   table_ActiveTrades;
    IBOutlet UICollectionView       *   collectionView_Images;
    
    IBOutlet UIView                 *   view_TableHeader;
    
    NSMutableArray                  *   images_CollectionHeaders;
    NSMutableArray                  *   arrayFullImages;
    UIImageView                     *   imageViewArrowForsection;

    IBOutlet UIView                 *   messagesReceivedViewHeader;
    IBOutlet UIView                 *   messagesReceivedViewFooterHeader;

    FGalleryViewController          *   networkGallery;
    // UIheader lables
    
    IBOutlet UILabel                *    lable_VehicleYear;
    IBOutlet UILabel                *    lable_VehicleCode;
    IBOutlet UILabel                *    lable_VehicleDays;
    IBOutlet UILabel                *    label_MessageReceivedCount;

    IBOutlet UILabel                *    lable_ExpireTime;
    IBOutlet UILabel                *    label_BidRecieved;

    IBOutlet UIButton                *   btnExtend;

    NSInteger selectedIndex;
    
    BOOL isFirstSectionExpanded;
    BOOL isSecondSectionExpanded;
    BOOL isLoadVehicleWebservice;
    BOOL isDeactivateTradeWebserviceCalled;
    
    SMVehiclelisting *bidsObject;
     SMVehiclelisting *messageObject;
    
    NSMutableArray *arrayOfBids;
     NSMutableArray *arrayOfMessages;
    
    __weak IBOutlet UILabel *lblRetailPriceValue;
    
    __weak IBOutlet UILabel *lblTradePriceValue;
    
    __weak IBOutlet UILabel *lblBidPriceValue;
    
    IBOutlet UILabel *lblPriceValues;
    
    
    // Vehicle details
    
     NSString *strYear;
    NSString *strFriendlyName;
    NSString *strRegistration;
    NSString *strColor;
    NSString *strStockCode;
    NSString *strVehicleType;
    NSString *strMileage;
    NSString *strDays;
     NSString *strExpiresDate;
    NSString *strRetailPrice;
    NSString *strTradePrice;
    NSString *strBidPrice;
    NSString *strHighestBidReceived;

    NSArray                     *   networkCaptions;
    NSString *msgActivateTradeFail;
    
    NSString *strExtendedDate;
    BOOL isExpiryDateExtended;

}

@property(nonatomic,strong)SMVehiclelisting *selectedVehicleObj;

@property(assign)int listingScreenPageNumber;

- (IBAction)btnEditVehicleDidClicked:(id)sender;

- (IBAction)btnExtendDidClicked:(id)sender;

- (IBAction)btnRejectBidDidClicked:(id)sender;


- (IBAction)btnAcceptBidDidClicked:(id)sender;
- (IBAction)btnDeactivateTradeDidClciked:(id)sender;


@end
