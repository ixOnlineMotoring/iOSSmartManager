//
//  SMTraderBuyViewController.h
//  SmartManager
//
//  Created by Ketan Nandha on 23/03/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomButtonBlue.h"
#import "SMCustomButtonGrayColor.h"
#import "SMCustomLable.h"
#import "SMCustomLabelBold.h"
#import "SMCustomTextField.h"

#import "MBProgressHUD.h"
#import "SMDetailTrade.h"
#import "FGalleryViewController.h"
#import "SMVehiclelisting.h"
#import "HCSStarRatingView.h"
#import "SMRateBuyerObject.h"
#import <MessageUI/MessageUI.h>
#import "SMAppDelegate.h"

enum status
{
    iClear = 1,
    iBuyNow = 2,
    iAutomatedBid = 3,
    iPlacingBid = 4,
    iRemoveAutoBid = 5
};

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)

@protocol refreshVehicleListing <NSObject>

-(void) getRefreshedVehicleListing;

@end

@interface SMTraderBuyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,NSXMLParserDelegate,UITextFieldDelegate,MBProgressHUDDelegate,FGalleryViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
    SMDetailTrade               *objectTradeDeatilsVehicle;
//    SMVehiclelisting            *objectVehicleList;

    NSMutableArray              *arrayVehicleListing;
    NSMutableArray              *arrayTradeSliderDetails;
    NSMutableArray              *arrayFullImages;
    NSMutableArray              *arrayVehicleImages;
    NSMutableArray              *arrayVehicleDetail;
    NSMutableArray              *arrayOfRateQuestions;
    NSMutableArray              *arrayOfMessages;
    
    MBProgressHUD *HUD;
    
    //---xml parsing---
    NSXMLParser                 *xmlParser;
    NSMutableString             *currentNodeContent;
    
    NSString *strTradeCost;
    NSString *strHighestBid;
    NSString *buyNowPrice;
    NSString *minBidPriceUpdated;
    
    NSString *strMyHighest;
    int sellerClientID;
    
    int bidAmountWithIncrement;
    int AutoBidAmount;
    int listingHeight;
    int checkStatus;
    
    int totalSellerReviews;
    float sellerRatingStarValue;

    // For Gallery View
    NSArray                     *   networkCaptions;
    FGalleryViewController      *   networkGallery;
    SMRateBuyerObject           *   rateSellerObject;
    SMVehiclelisting            *   messageObject;
    
    __weak id <refreshVehicleListing> vehicleListDelegates;
    
    
    
    UIImageView *imageViewArrowForsection;
    UILabel *countLbl;
    
    BOOL isSectionFirstExpanded;
    BOOL isSectionSecondExpanded;
    BOOL isSectionThirdExpanded;
    BOOL isPlaceBidFailed;
     BOOL isAutomatedBidFailed;
    BOOL isBuyNowBidFailed;
    BOOL isDetailServiceCalled;
    BOOL isQuestionsMainTagEntered;
    BOOL isLabelWinBeatValueHidden;
    BOOL cantViewVehicleDetails;
    
    __weak IBOutlet SMCustomLable *lblFirstQuestion;
    
    __weak IBOutlet SMCustomLable *lblSecondQuestion;
    
    __weak IBOutlet SMCustomLable *lblThirdQuestion;
    
    IBOutlet UIView *popUpView;
    IBOutlet UIView *customAlertBox;
    
    IBOutlet UILabel *lblCustomPopupMessage;
    
    
    SMAppDelegate *appdelegate;
    
}

@property (nonatomic, weak) id <refreshVehicleListing> vehicleListDelegates;

@property(nonatomic,strong)SMVehiclelisting *vehicleObj;

@property (strong, nonatomic) IBOutlet UITableView          *tableBuy;
@property (strong, nonatomic) IBOutlet UITableView          *tableVehicleListing;
@property (nonatomic, strong) IBOutlet UICollectionView     *collectionDetail;

@property (nonatomic,strong) IBOutlet UIView            *viewPlacedBid;
@property (nonatomic,strong) IBOutlet UIView            *viewTableHeader;
@property (nonatomic,strong) IBOutlet UIView            *viewCollection;
@property (nonatomic,strong) IBOutlet UIView            *viewAutomatedBidding;
@property (nonatomic,strong) IBOutlet UIView            *viewAutomatedExpanded;
@property (nonatomic,strong) IBOutlet UIView            *viewBuyNow;
@property (nonatomic,strong) IBOutlet UIView            *viewTableFooter;

@property (strong, nonatomic) IBOutlet SMCustomTextField         *textFieldPlaceBid;
@property (strong, nonatomic) IBOutlet SMCustomTextField         *textFieldLimitBidAmount;

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue        *buttonPlaceBid;
@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor   *buttonAutomatedBidding;
@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor   *btnCancelForExpandableView;
@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor   *btnActivateForExpandableView;
@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor   *buttonBuyNow;

@property (strong, nonatomic) IBOutlet SMCustomLable            *lblStockNumber;
@property (strong, nonatomic) IBOutlet SMCustomLable            *labelStockNumber;
@property (strong, nonatomic) IBOutlet SMCustomLable            *lblRegisterNumber;
@property (strong, nonatomic) IBOutlet SMCustomLable            *labelRegisterNumber;
@property (strong, nonatomic) IBOutlet SMCustomLable            *lblVinNumber;
@property (strong, nonatomic) IBOutlet SMCustomLable            *labelVinNumber;

@property (strong, nonatomic) IBOutlet SMCustomLabelBold        *labelExtrasHeading;
@property (strong, nonatomic) IBOutlet SMCustomLabelBold        *labelCommentHeading;
@property (strong, nonatomic) IBOutlet SMCustomLable            *labelComment;
@property (strong, nonatomic) IBOutlet SMCustomLable            *labelExtras;
@property (strong, nonatomic) IBOutlet SMCustomLabelBold        *lblOwnerName;

@property (strong, nonatomic) IBOutlet SMCustomLable            *lblMaximumBid;
@property (strong, nonatomic) IBOutlet SMCustomLable            *lblTitle;

@property (nonatomic) BOOL  isLabelMinBidHide;

- (IBAction)buttonPlaceBidDidClicked:(id)sender;
- (IBAction)buttonBuyNowDidClicked:(id)sender;
- (IBAction)buttonAutomatedBiddingDidClicked:(id)sender;
- (IBAction)btnCancelForExpandableViewDidClicked:(id)sender;
- (IBAction)btnActivateForExpandableViewDidClicked:(id)sender;

@property(strong, nonatomic) NSString           *strSelectedVehicleId;
@property(strong, nonatomic) NSString           *strOwnerName;
@property(strong, nonatomic) NSString           *strBuyNowValue;
@property(strong, nonatomic) NSString           *strIncrementValue;
@property(strong, nonatomic) NSString           *strBidValue;

@property(weak, nonatomic)  IBOutlet SMCustomLabelBold      *labelVehicleName;
@property(weak, nonatomic)  IBOutlet SMCustomLabelBold      *labelVehicleMileage;
@property(weak, nonatomic)  IBOutlet SMCustomLabelBold      *labelVehicleColor;
@property(weak, nonatomic)  IBOutlet SMCustomLabelBold      *labelVehicleLocation;
@property(weak, nonatomic)  IBOutlet SMCustomLabelBold      *labelVehicleCost;
@property(weak, nonatomic)  IBOutlet SMCustomLabelBold      *labelTradeTimeLeft;
@property (weak, nonatomic) IBOutlet SMCustomLabelBold      *labelMyBidValue;
@property (weak, nonatomic) IBOutlet SMCustomLabelBold      *lblWinningBeaten;

@property(weak, nonatomic)  IBOutlet UIImageView      *imageVehicle;
@property(weak, nonatomic)  IBOutlet UIImageView      *imageViewBuyItNow;
@property(strong, nonatomic)  IBOutlet UIButton        *buttonImageClickable;

// custom view holding comment

@property (strong, nonatomic) IBOutlet UIView *viewHoldingCommentTextField;

@property (weak, nonatomic) IBOutlet SMCustomTextField *txtFieldComment;

- (IBAction)btnSubmitCommentDidClicked:(id)sender;


// custom view holding rating values

@property (strong, nonatomic) IBOutlet UIView *viewHoldingRatingValues;


@property (weak, nonatomic) IBOutlet SMCustomLable *lblReviewsCount;

@property (weak, nonatomic) IBOutlet SMCustomLable *lblPriceChange;

@property (weak, nonatomic) IBOutlet SMCustomLable *lblVehicleDescribed;

@property (weak, nonatomic) IBOutlet SMCustomLable *lblVehicleDispatched;


- (IBAction)buttonImageClickableDidPressed:(id)sender;


- (IBAction)btnEmailDidClicked:(id)sender;

- (IBAction)btnPhoneDidClicked:(id)sender;


- (IBAction)btnCancelCustomAlertDidClicked:(id)sender;




@end
