//
//  SMStockVehicleDetailController.h
//  SmartManager
//
//  Created by Liji Stephen on 01/07/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
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

#import "SMBase64ImageEncodingObject.h"
#import "SMCommonClassMethods.h"
#import "ImageCropView.h"
#import "QBImagePickerController.h"
#import "RPMultipleImagePickerViewController.h"
#import "SMParserForUrlConnection.h"
#import "ASIFormDataRequest.h"// for videos
#import "ASINetworkQueue.h" // for videos
#import <MessageUI/MessageUI.h>
#import "SMLoadVehiclesObject.h"

@interface SMStockVehicleDetailController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,MBProgressHUDDelegate,FGalleryViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,QBImagePickerControllerDelegate,presentTheMultiplePhotoSelectionLibraryDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    
    IBOutlet UIView *popUpView;
    IBOutlet UIView *customAlertBox;
    IBOutlet SMCustomButtonBlue *btnCancelCustomAlert;

    
    
    ImageCropView* imageCropView;
    QBImagePickerController *imagePickerController;
     UIImagePickerController * picker;
    
    UILabel *listActiveSpecialsNavigTitle;
    SMParserForUrlConnection *xmlParser;
    NSMutableString *currentNodeContent;
    MBProgressHUD *HUD;
    MBProgressHUD *uploadingHUD;

     SMPhotosListNSObject *photosListObject;
    NSMutableArray *arrayOfImages;
    NSMutableArray *arrayOfSliderImages;
    NSMutableArray *arrayOfVideos;
    NSMutableArray *arrayOfPhotos;
    
    NSString *stockCode;
    NSString *registration;
    BOOL isImageWebserviceCallled;
    BOOL shouldSectionBeExpanded;
    BOOL shouldPersonalisedPhotoSectionBeExpanded;
    BOOL shouldPersonalisedVideoSectionBeExpanded;
    BOOL isPrioritiesImageChanged;
    BOOL isFromAppGallery;
    BOOL canClientUploadVideos;
    int indexpathOfSelectedVideo;
    NSString *documentsDirectory;
    NSString  *filToBeuplaoded;
    NSString *videoURL;
   float valueOfProgress;
    NSData *imageData;
    NSString *fullPathOftheImage;
    int imgCount;
    int videoCount;
    NSInteger deleteButtonTag;
    int selectedIndexForImage;
    int currentPhotoCount;
    
    BOOL isSendPhotosChecked;
    BOOL isSendVideosChecked;
    
     NSString *moviePath;
    NSString *base64Str;
    NSMutableData *responseData;
    NSArray *assetsArray;
    UIImage *selectedImage;
    NSMutableArray *arrayVideoDetails1;
    NSMutableArray *arrayVideoDetails2;
    NSString *vehicleType;
    NSString *vehicleExtras;
    NSString *vehicleComments;
    UIImageView *imageViewArrowForsection;
    NSString *strPhotosToken;
    NSString *strSpecDetails;
    NSMutableDictionary *dictSpecDetails;
    NSMutableArray *arrayOfSpecs;
    
    NSString *strWarrantyPeriod;
    NSString *strMaintainancePeriod;
    NSString *strInternalNote;
    // For Gallery View
    
    NSArray                     *   localCaptions;
    NSArray                     *   localImages;
    NSArray                     *   networkCaptions;
    NSArray                     *   networkImages;
    FGalleryViewController      *   localGallery;
    FGalleryViewController      *   networkGallery;

     SMAppDelegate *appdelegate;
    
     IBOutlet UIView *viewPhotos;
     IBOutlet UIView *viewVideos;
    IBOutlet UIView *viewCollectionVideoBk;
    IBOutlet UIView *viewCollectionPhotosBk;
    
    IBOutlet UICollectionView *collectionViewPhotos;
    IBOutlet UICollectionView *collectionViewVideos;
    
    __weak IBOutlet UICollectionView *collectinViewVideosWithNoImages;
    
    
    UIActionSheet *actionSheetPhotos;
    UIActionSheet *actionSheetVideos;
     UIImageView *imageVieww;
    
    
    __weak IBOutlet UILabel *lblPopupMessage;
    
}
@property (nonatomic, strong) RPMultipleImagePickerViewController *multipleImagePicker;
@property (nonatomic, strong) IBOutlet ImageCropView* imageCropView;
@property (strong, nonatomic) IBOutlet UITableView *tblViewStockVehicleDetails;

@property (nonatomic,strong) IBOutlet UIButton *buttonImageClickable;
@property (nonatomic,strong) IBOutlet UIImageView *imageVehicle;

@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleName;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleDetails1;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleDetails2;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleDetails3;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewImages;

@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UIView *viewCollectionContainer;

@property (strong, nonatomic) IBOutlet UIView *viewHeaderVariant;

@property (strong, nonatomic) IBOutlet UILabel *lblVariantName;

@property (strong, nonatomic) IBOutlet UILabel *lblVariantDetails;

-(IBAction)buttonImageClickableDidPressed:(id) sender;

@property (strong, nonatomic) SMPhotosAndExtrasObject *photosExtrasObject;
@property (strong, nonatomic) SMLoadVehiclesObject *objVariantSelected;
@property(assign) BOOL isFromVariantList;
@property(assign) int selectedVehicleDropdownValue;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblEmailDetails;


@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnSend;

@property (strong, nonatomic) IBOutlet UIView *viewFooter;

- (IBAction)btnSendDidClicked:(id)sender;


// header view when no images

@property (strong, nonatomic) IBOutlet UIView *ViewHeaderNoImages;

@property (strong, nonatomic) IBOutlet SMCustomLabelBold *lblVehicleNameNoImages;

@property (strong, nonatomic) IBOutlet SMCustomLabelBold *lblVehicleDetails1NoImages;

@property (strong, nonatomic) IBOutlet SMCustomLabelBold *lblVehicleDetails2NoImages;

@property (strong, nonatomic) IBOutlet SMCustomLabelBold *lblVehicleDetails3NoImages;

// See More Info Button

- (IBAction)btnPlusPhotosDidClicked:(id)sender;

- (IBAction)btnPlusVideosDidClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewPersonalisedHeader;

@property (weak, nonatomic) IBOutlet UILabel *lblPersonalisedItem;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckBoxPersonalised;

- (IBAction)btnCheckBoxPersonalisedDidClicked:(id)sender;

- (IBAction)btnEmailDidClicked:(id)sender;

- (IBAction)btnPhoneDidClicked:(id)sender;

- (IBAction)btnCancelCustomAlertDidClicked:(id)sender;



@end
