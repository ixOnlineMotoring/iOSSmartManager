//
//  SMTraderDetailViewController.h
//  SmartManager
//
//  Created by Jignesh on 13/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMDetailTrade.h"
#import "SMCustomTextField.h"
#import "SMBiddingButton.h"
#import "SMVehiclelisting.h"
#import "FGalleryViewController.h"
#import "SMTraderViewTableViewCell.h"
#import "MBProgressHUD.h"
#import "SMCustomLabelBold.h"
#import "SMCustomLable.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomButtonGrayColor.h"

enum checkStatus
{
    isClear = 1,
    isBuyNow = 2,
    isAutomatedBid = 3,
    isPlacingBid = 4,
    isRemoveAutoBid = 5
};

@protocol refreshVehicleListing <NSObject>

-(void) getRefreshedVehicleListing;

@end

@interface SMTraderDetailViewController : UIViewController <
     UICollectionViewDataSource,UICollectionViewDelegate,
     NSXMLParserDelegate,
     UITableViewDelegate, UITableViewDataSource,
     UITextFieldDelegate,
     UIAlertViewDelegate,
     UITextFieldDelegate,
     FGalleryViewControllerDelegate,MBProgressHUDDelegate >
{
    SMDetailTrade             *objectTradeDeatilsVehicle;
    SMVehiclelisting          *objectVehicleList;

    IBOutlet UICollectionView *sliderCollection;
  
    IBOutlet SMCustomButtonGrayColor  *buttonBuyNow;
    
    IBOutlet SMBiddingButton  *buttonAutomatedBidding;
    
    //---xml parsing---
    NSXMLParser               *xmlParser;
    NSMutableString           *currentNodeContent;

    // array for getitng all vehicle informations listing

    NSMutableArray            *arrayVehicleListing;
    NSMutableDictionary       *vehicleDictionary;
    
    NSMutableArray            *arrayTradeSliderDetails;
    NSMutableArray            *arrayFullImages;
    
    IBOutlet UIView           *viewTableFooterForVehicleStock;
    
    NSString *buyNowPrice;
    
    IBOutlet UIView           *viewHeaderForVehcileStock;
    
    // For Gallery View
    
    NSArray                     *   localCaptions;
    NSArray                     *   localImages;
    NSArray                     *   networkCaptions;
    NSArray                     *   networkImages;
	FGalleryViewController      *   localGallery;    
    FGalleryViewController      *   networkGallery;
    
    int bidAmountWithIncrement;
    
    NSString *strCurrentBidAmount;
    NSString *strTradeCost;
    NSString *strHighestBid;
    
    // this will identify specific bididng part
    
    BOOL checkStatus;
    BOOL isTheViewExpandedInHeader;
    
    MBProgressHUD *HUD;
    
    __weak id <refreshVehicleListing> vehicleListDelegates;
    
    NSMutableArray *arrayVehicleDetail;
    
    int AutoBidAmount;
}

-(IBAction)buttonAutomatedDidPressed:(id)sender;
-(IBAction)buttonPlaceBid:(id)sender;
-(IBAction)buttonBuyNowDidPressed:(id)sender;
-(IBAction)submitLimitWithBidAmount:(id)sender;
- (IBAction)cancelLimitWithBidAmount:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewAdjust;

@property (strong, nonatomic) IBOutlet SMCustomLable    *lblMaximumBid;
@property (strong, nonatomic) IBOutlet SMCustomLable    *lblTitle;
@property (strong, nonatomic) IBOutlet SMCustomLable    *labelComment;
@property (strong, nonatomic) IBOutlet SMCustomLable    *labelExtras;
@property (strong, nonatomic) IBOutlet SMCustomLable    *lblStockNumber;
@property (strong, nonatomic) IBOutlet SMCustomLable    *lableStockNumber;
@property (strong, nonatomic) IBOutlet SMCustomLable    *lblRegisterNumber;
@property (strong, nonatomic) IBOutlet SMCustomLable    *labelRegisterNumber;
@property (strong, nonatomic) IBOutlet SMCustomLable    *lblVinNumber;
@property (strong, nonatomic) IBOutlet SMCustomLable    *labelVinNumber;

@property(strong, nonatomic) IBOutlet SMCustomLabelBold *labelExtrasHeading;
@property(strong, nonatomic) IBOutlet SMCustomLabelBold *labelCommentHeading;
@property(strong, nonatomic) IBOutlet SMCustomLabelBold *labelOwnerName;

@property(strong, nonatomic) NSString         *strSelectedVehicleId;
@property(strong, nonatomic) NSString         *strBuyNowValue;
@property(strong, nonatomic) NSString         *strBidValue;
@property(strong, nonatomic) NSString         *strIncrementValue;
@property(strong, nonatomic) NSString         *strOwnerLocation;
@property(strong, nonatomic) NSString         *strVehicleComments;
@property(strong, nonatomic) NSString         *strBidtextValue;

@property(strong, nonatomic)SMVehiclelisting  *objectVehicleList;

@property(strong, nonatomic) IBOutlet SMCustomTextField         *textFieldPlaceBid;

@property(strong, nonatomic) IBOutlet UITextField               *textFieldLimitBidAmount;

@property(strong, nonatomic) IBOutlet SMCustomButtonBlue *buttonPlaceBid;

@property(strong, nonatomic) IBOutlet UITableView *tableVehicleListing;
@property(strong, nonatomic) IBOutlet UITableView *tableViewHeader;


@property (nonatomic, weak) id <refreshVehicleListing> vehicleListDelegates;

// changes by Liji

@property (strong, nonatomic) IBOutlet UIView *viewToBeExpanded;

@property (strong, nonatomic) IBOutlet UIButton *btnCancelForExpandableView;

@property (strong, nonatomic) IBOutlet UIButton *btnActivateForExpandableView;



@end
