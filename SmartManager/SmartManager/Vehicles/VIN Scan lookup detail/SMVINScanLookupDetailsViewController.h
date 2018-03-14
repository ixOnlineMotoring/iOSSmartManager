//
//  SMVINScanLookupDetailsViewController.h
//  SmartManager
//
//  Created by Priya on 17/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMVINLookupObject.h"
#import "SMVINScanDetailsObject.h"
#import "SMCustomTextField.h"
#import "SMVINScanModelObject.h"
#import "SMLoadVehiclesObject.h"
#import "SMExistingVehicleTableViewCell.h"
#import "SMToolBarCustomField.h"
#import "SMPopOverButtons.h"
#import "SMCustomLable.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomButtonGrayColor.h"
#import "MBProgressHUD.h"
#import  <CoreLocation/CoreLocation.h>

@protocol refreshVehicleListing <NSObject>

-(void) getSavedVINListingRefreshing;

@end

@interface SMVINScanLookupDetailsViewController : UIViewController<NSXMLParserDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate,SMToolBarCustomFieldDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate>
{
    NSMutableString *currentNodeContent;
    //---web service access---
    NSMutableString *soapResults;
    //---xml parsing---
    NSXMLParser *xmlParser;
    
    NSMutableArray *VINDetailArray;
    NSMutableArray *yearArray;
    NSMutableArray *modelArray;
    NSMutableArray *variantArray;
    NSMutableArray *stockIdArray;
    NSMutableArray *listArray;
    NSMutableArray *detailArray;
    NSMutableArray *stockArray;

    int selectedType;
    int selectedModelId;
    int selectedVariantId;
    int scanedModelId;
    int selectedStockIdId;

    NSString *strPickerValue;
    
    BOOL isStartYear;
    BOOL strHasModel;
    BOOL isExisiting;
    BOOL isModelText;
    
    NSString *strMaxYear;
    NSString *strMinYear;
    NSString *selectedVarientMeanCode;
    NSString *strSelectedStockNumber;
    NSString *strSelectedVariantName;
    NSString *strGeoLocation;
    
    CLLocationCoordinate2D coordCurrentLocation;
    CLLocationManager *locationManager;
    
    float currentLatitude;
    float currentLongitude;

    dispatch_queue_t backGroundQueue;
    
    MBProgressHUD *HUD;

    SMVINScanDetailsObject *VINScanDetailsObject;
    SMVINScanModelObject *vinScanModelObject;
    SMLoadVehiclesObject *loadVehiclesObject;

    IBOutlet UIScrollView *scrollView;
    
    IBOutlet SMCustomLable *lblMake;
    IBOutlet SMCustomLable *lblModel;
    IBOutlet SMCustomLable *lblStartYear;
    IBOutlet SMCustomLable *lblEndYear;
    IBOutlet SMCustomLable *lblVariant;
    IBOutlet SMCustomLable *lblColour;
    IBOutlet SMCustomLable *lblLicenseNo;
    IBOutlet SMCustomLable *lblRegNo ;
    IBOutlet SMCustomLable *lblEngineNo;
    IBOutlet SMCustomLable *lblVINNo;
    IBOutlet SMCustomLable *lblExpires;
    IBOutlet SMCustomLable *lblStolen;
    IBOutlet SMCustomLable *lblFinanced;
    IBOutlet SMCustomLable *lblHasAccidents;
    IBOutlet SMCustomLable *lblTitle;
    IBOutlet SMCustomLable *lbValiodationText;
    IBOutlet SMCustomLable *lblStockNo;

    IBOutlet UIButton *validateButtons;
    IBOutlet UIButton *downArrowButton1;
    IBOutlet UIButton *downArrowButton2;
    IBOutlet UIButton *downArrowButton3;
    IBOutlet UIButton *downArrowButton4;
    IBOutlet UIButton *downArrowButton5;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *cancelButtons;
    IBOutlet UIButton *setButton;
    IBOutlet UIButton *stolenCheckButton;
    IBOutlet UIButton *accidentCheckButton;
    IBOutlet UIButton *updateButton;

    IBOutlet UIView *contentView;
    IBOutlet UIView *popupView;
    IBOutlet UIView *pickerView;
    int MaxYear;
    int MinYear;
    IBOutlet UITableView *loadVehicleTableView;
    IBOutlet UITableView *existingVehicleTableView;
    IBOutlet UIPickerView *yearPickerView;
    
    
    __weak id <refreshVehicleListing> vehicleListDelegates;
    
    IBOutlet UILabel *lblVariantNote;
    
    

    
}

@property (readonly) CLLocationCoordinate2D currentUserCoordinate;

@property (nonatomic, weak) id <refreshVehicleListing> vehicleListDelegates;

@property (nonatomic) BOOL isFromSaveListing;
@property(strong,nonatomic)SMVINLookupObject *VINLookupObject;

@property(strong,nonatomic)IBOutlet UITableView *VINDetailsTableView;

@property BOOL isFromAddToStockPage;


@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtStartYear;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtEndYear;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtMake;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtModel;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtVariants;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtColour;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtLicenseNo;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtRegNo;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtEngineNo;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtVINNo;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtVINScan;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtExpires;
@property(weak, nonatomic)  IBOutlet SMCustomTextField  *txtStockNo;



@property(weak, nonatomic)  IBOutlet SMCustomButtonGrayColor *discardButton;
@property(weak, nonatomic)  IBOutlet SMCustomButtonBlue      *saveForLaterButton;
@property(weak, nonatomic)  IBOutlet SMCustomButtonBlue      *AddToStockButton;


@property(weak, nonatomic)    IBOutlet UITextField  *txtStolen;
@property(weak, nonatomic)    IBOutlet UITextField  *txtFinanced;
@property(weak, nonatomic)    IBOutlet UITextField  *txtHasAccidents;
@property (strong, nonatomic) IBOutlet UIView       *footerView;

-(IBAction)btnDiscardDidClicked:(id)sender;
-(IBAction)btnSaveForLaterDidClicked:(id)sender;
-(IBAction)btnAddToStocklDidClicked:(id)sender;
-(IBAction)btnValidateDidClicked:(id)sender;
-(IBAction)btnCancelDidClicked:(id)sender;
-(IBAction)btnStolenCheckDidClicked:(id)sender;
-(IBAction)btnHasAccidentCheckDidClicked:(id)sender;

@end
