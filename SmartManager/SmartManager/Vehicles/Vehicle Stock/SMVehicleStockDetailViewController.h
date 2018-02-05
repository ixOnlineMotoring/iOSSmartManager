//
//  SMVehicleStockDetailViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 12/02/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelBold.h"
#import "SMCustomButtonBlue.h"
#import "CustomTextView.h"
#import "SMCustomLable.h"
#import "SMCustomTextField.h"
#import "SMPhotosAndExtrasObject.h"
#import "MBProgressHUD.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMPhotosListNSObject.h"
#import "FGalleryViewController.h"
#import "SMAppDelegate.h"
#import "QBImagePickerController.h"
#import "RPMultipleImagePickerViewController.h"
#import "SMPhotosAndExtrasObject.h"
#import <MessageUI/MessageUI.h>

#import <MediaPlayer/MediaPlayer.h>
#import "SMMoviePlayerClass.h"
#import "SMLoadVehiclesObject.h"

@interface SMVehicleStockDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,MBProgressHUDDelegate,FGalleryViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate,QBImagePickerControllerDelegate,presentTheMultiplePhotoSelectionLibraryDelegate,MFMailComposeViewControllerDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    UILabel *listActiveSpecialsNavigTitle;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    MBProgressHUD *HUD;
    
    SMPhotosListNSObject *photosListObject;
    NSMutableArray *arrayOfImages;
    NSMutableArray *arrayOfSliderImages;
    
    NSString *stockCode;
    NSString *registration;
    BOOL isImageWebserviceCallled;
    BOOL shouldSectionBeExpanded;
    
    NSString *vehicleType;
    NSString *vehicleExtras;
    NSString *vehicleComments;
    UIImageView *imageViewArrowForsection;
    
    NSMutableDictionary *dictSpecDetails;
    NSMutableArray *arrayOfSpecs;
    
    NSString *strWarrantyPeriod;
    NSString *strMaintainancePeriod;
    NSString *strInternalNote;
    NSString *strSpecDetails;
    
    // For Gallery View
    
    NSArray                     *   localCaptions;
    NSArray                     *   localImages;
    NSArray                     *   networkCaptions;
    NSArray                     *   networkImages;
    FGalleryViewController      *   localGallery;
    FGalleryViewController      *   networkGallery;
    
    SMAppDelegate *appdelegate;
    
    IBOutlet UITableView *tblViewStockVehicleDetails;
    IBOutlet UIButton *buttonImageClickable;
    IBOutlet UIImageView *imageVehicle;
    IBOutlet SMCustomLabelBold *lblVehicleName;
    IBOutlet SMCustomLabelBold *lblVehicleDetails1;
    IBOutlet SMCustomLabelBold *lblVehicleDetails2;
    IBOutlet SMCustomLabelBold *lblVehicleDetails3;
    IBOutlet UICollectionView *collectionViewImages;
    IBOutlet UIView *viewHeader;
    IBOutlet UIView *viewCollectionContainer;
    
    IBOutlet SMCustomLable *lblEmailDetails;
    IBOutlet SMCustomButtonBlue *btnSend;
    IBOutlet UIView *viewFooter;
    
    // headerView no images
    
    IBOutlet UIView *ViewHeaderNoImages;
    IBOutlet SMCustomLabelBold *lblVehicleNameNoImages;
    IBOutlet SMCustomLabelBold *lblVehicleDetails1NoImages;
    IBOutlet SMCustomLabelBold *lblVehicleDetails2NoImages;
    IBOutlet SMCustomLabelBold *lblVehicleDetails3NoImages;
    
    
    
    IBOutlet UIView *viewTableFooter;
    
    IBOutlet UICollectionView *collectionViewVideos;
    
    __weak IBOutlet UICollectionView *collectionViewVideosWithNoImages;
    
    
    IBOutlet UIView *popUpView;
    IBOutlet UIView *customAlertBox;
    UIImageView *imageVieww;
    
     int indexpathOfSelectedVideo;
    
}

@property (strong, nonatomic) SMPhotosAndExtrasObject *photosExtrasObject;
@property (strong, nonatomic) SMLoadVehiclesObject *objVariantSelected;
@property(assign) BOOL isFromVariantList;
@property(assign) int selectedVehicleIDFromDropdown;

@property (strong, nonatomic) IBOutlet UIView *viewHeaderVariant;

@property (strong, nonatomic) IBOutlet UILabel *lblVariantName;

@property (strong, nonatomic) IBOutlet UILabel *lblVariantDetails;

@property (nonatomic, strong) RPMultipleImagePickerViewController *multipleImagePicker;


-(IBAction)buttonImageClickableDidPressed:(id) sender;

- (IBAction)btnSendBrochureDidClicked:(id)sender;

- (IBAction)btnEmailDidClicked:(id)sender;

- (IBAction)btnPhoneDidClicked:(id)sender;


- (IBAction)btnCancelCustomAlertDidClicked:(id)sender;


@end
