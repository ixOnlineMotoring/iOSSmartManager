//
//  SMTradeSoldViewController.h
//  Smart Manager
//
//  Created by Sandeep Parmar on 25/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "SMVehiclelisting.h"
#import "SMCustomLable.h"
#import "SMCustomLabelBold.h"
#import "SMRateBuyerObject.h"
#import "SMTradeSoldCell.h"
#import "MBProgressHUD.h"
#import "MyRSAPickerView.h"

@interface SMTradeSoldViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,NSXMLParserDelegate,UITextFieldDelegate,MBProgressHUDDelegate>

{

    BOOL isRateBuyerSectionExpanded;
    BOOL isMessageSectionExpanded;
    UIImageView *imageViewArrowForsection;
    UILabel *countLbl;
    
    NSMutableArray *arrayFullImages;
    NSMutableArray *arrayRateBuyerList;
    NSMutableArray *arrayOfMessages;


    IBOutlet UITableView *tableSold;
    IBOutlet UICollectionView *viewCollection;

    IBOutlet UIView *viwForRateBuyer;
    IBOutlet SMCustomTextField *txtForMessMeAround;
    IBOutlet SMCustomTextField *txtForOnTime;
    IBOutlet SMCustomTextField *txtForRenegotiatePrice;

     SMVehiclelisting            *   messageObject;
    
    IBOutlet UIView *viwFooterComments;
    IBOutlet UIView *viwForCollectionImages;
    
    IBOutlet SMCustomLable            *lblStockNumber;
    IBOutlet SMCustomLable            *labelStockNumber;
    IBOutlet SMCustomLable            *lblRegisterNumber;
    IBOutlet SMCustomLable            *labelRegisterNumber;
    IBOutlet SMCustomLable            *lblVinNumber;
    IBOutlet SMCustomLable            *labelVinNumber;
    IBOutlet SMCustomLabelBold        *labelExtrasHeading;
    IBOutlet SMCustomLabelBold        *labelCommentHeading;
    IBOutlet SMCustomLable            *labelComment;
    IBOutlet SMCustomLable            *labelExtras;
    IBOutlet SMCustomLabelBold        *lblOwnerName;

    MyRSAPickerView *pickerViewRating;
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;

    SMRateBuyerObject *rateBuyerObj;
    NSMutableArray *arrayListSellerRating;

    BOOL isError;

    BOOL isSeller;
    BOOL isLoadVehicleService;
    
    NSString *strVinNumber;
    NSString *strRegistrationNumber;

NSArray                     *   networkCaptions;
//    NSString *strComments;
//    NSString *strExtras;
    
    NSString *ownerName;
    NSString *ownerLocation;
    int OwnerID;
    int vechicleID;

    int totalCount;
    int uploadRatingCount;
}
@property(nonatomic,strong)SMVehiclelisting *vehicleObj;
@property(nonatomic,strong)NSString *strFromWhichScreen;

- (IBAction)btnactnSubmit:(id)sender;

@end

