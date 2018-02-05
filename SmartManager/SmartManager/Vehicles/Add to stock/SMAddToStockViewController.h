//
//  SMAddToStockViewController.h
//  SmartManager
//
//  Created by Priya on 21/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SMCustomTextField.h"
#import "SMCustomTextFieldForDropDown.h"
#import "SMVINLookupObject.h"
#import "UIImage+Resize.h"
#import "UIImageView+WebCache.h"
#import "SMVehicleTypeObject.h"
#import "SMLoadVehiclesObject.h"
#import "SMToolBarCustomField.h"
#import "SMToolBarCustomTextView.h"
#import "MBProgressHUD.h"
#import "SMCommonClassMethods.h"
#import "SMPhotosListNSObject.h"
#import "SMClassOfUploadVideos.h"
#import "SMMoviePlayerClass.h"
#import "MBProgressHUD.h"
#import "SMBase64ImageEncodingObject.h"
#import "SMPhotosAndExtrasObject.h"
#import "FGalleryViewController.h"
#import "SMPopOverButtons.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomLable.h"
#import "SMLoadVehiclesObject.h"
#import "SMCustomLable.h"
#import "ImageCropView.h"
#import "QBImagePickerController.h"
#import "RPMultipleImagePickerViewController.h"
#import "SMParserForUrlConnection.h"
#import "SMListUpdateVariantViewController.h"
#import "ASIFormDataRequest.h"
@protocol refreshListModule <NSObject>

-(void) refreshTheVehicleListModule;

@end





@interface SMAddToStockViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSXMLParserDelegate,UIScrollViewDelegate,SMToolBarCustomFieldDelegate,SMToolBarCustomTextViewDelegate, UIAlertViewDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate,UIActionSheetDelegate,MBProgressHUDDelegate,FGalleryViewControllerDelegate,ImageCropViewControllerDelegate,QBImagePickerControllerDelegate,presentTheMultiplePhotoSelectionLibraryDelegate,UIGestureRecognizerDelegate,refreshVehicleVairantname>
{
    
    ImageCropView* imageCropView;
    QBImagePickerController *imagePickerController;
    
    SMVehicleTypeObject              *vehicleTypeObject;
    SMLoadVehiclesObject             *loadVehiclesObject;
    SMClassOfUploadVideos            *videoListObject;
    
    IBOutlet SMToolBarCustomTextView *txtExtras;
    IBOutlet SMToolBarCustomTextView *txtComment;
    IBOutlet SMToolBarCustomField    *txtCondition;
    IBOutlet SMToolBarCustomField    *txtType;
    IBOutlet SMToolBarCustomField    *txtColour;
    IBOutlet SMToolBarCustomField    *txtMileage;
    IBOutlet SMToolBarCustomField    *txtStock;
    IBOutlet SMToolBarCustomField    *txtPriceRetail;
    IBOutlet SMToolBarCustomField    *txtTrade;
    IBOutlet SMToolBarCustomField    *txtProgramName;
    IBOutlet UITextField             *txtVehicleYear;
    
    IBOutlet UITableView             *loadVehicleTableView;
    
    
    IBOutlet SMCustomLable           *lblBasicInfo;
    IBOutlet SMCustomLable           *lblMM;
    IBOutlet SMCustomLable           *lblVehicleName;
    
    IBOutlet UIButton                *btnVehicleProgram;
    IBOutlet UIButton                *btnVehicleIsTender;
    IBOutlet UIButton                *btnVehicleIsRetail;
    IBOutlet UIButton                *downArrowButton5;
    IBOutlet UIButton                *downArrowButton6;
    
    IBOutlet UIButton                *cancelButtons;
    IBOutlet UIButton                *setButton;
    IBOutlet UIButton                *cancelButton;
    
   
    
    // Additional info for video upload
    
     IBOutlet UILabel *lblVideoInfo;

    
    NSMutableArray    *vehicleTypeArray;
    NSMutableArray    *arrayOfImages;
    NSMutableArray    *listAddToTenderArray;
    NSMutableArray    *yearArray;
    NSArray *assetsArray;
    
    NSString          *documentsDirectory;
    NSString          *strPickerValue;
    NSString          *base64Str;
    NSString          *resultString;
    NSString          *fullPathOftheImage;
    
    
    
    NSData *imageData;
    
    NSMutableString *currentNodeContent;
    
    //---web service access---
    NSMutableString *soapResults;
    SMParserForUrlConnection *xmlParser;
    
    // For Gallery View
    
    NSArray                     *   localCaptions;
    NSArray                     *   localImages;
    NSArray                     *   networkCaptions;
    NSArray                     *   networkImages;
    
    
    FGalleryViewController      *   networkGallery;
    
    MBProgressHUD *HUD;
    
    NSDateFormatter* formatter;
    
    IBOutlet UIView *popupView;
    IBOutlet UIView *pickerView;
    IBOutlet UIView *pickerVehicleView;
    IBOutlet UIView *pickerVehicleViewContainer;
    IBOutlet UIView *titleView;
    IBOutlet UIView *viewPhotosOuter;
    IBOutlet UIView *viewVideosOuter;
    IBOutlet UIView *viewContainingVideos;
    
    IBOutlet UIPickerView *yearPickerView;
    IBOutlet UIPickerView *yearVehiclePickerView;
    
    IBOutlet UIView *popUpView;
    IBOutlet UIView *customAlertBox;
    IBOutlet SMCustomButtonBlue *btnCancelCustomAlert;
    
    
    UIImage *lastImage;
    UIImage *selectedImage;
    
    CGPoint svos;
    
    BOOL isTextFieldSelected;
    BOOL isTender;
    BOOL isVehicleType;
    BOOL isPrioritiesImageChanged;
    BOOL isPrioritiesUpdateComments;
    BOOL isExpandable;
    BOOL isSaveAndClosed;
    BOOL isLoadVehicle;
    BOOL isListingPhotosVehicle;
    BOOL isFromAppGallery;
    BOOL isAllImagesAreRemoved;
    BOOL isEditStockVariantDetailsResult;
    BOOL isInfoOnlySaved;
    BOOL didUserChangeAnything;

    
    int strSlectedTenderId;
    int strSlectedTypeId;
    int selectedVehicleTypeId;
    int currentYear;
    int imgCount;
    int countForShowingAlert;
    int countOfSpec;
    int indexpathOfSelectedVideo;
    
    
    NSString *strEditStockVehicleDetails;
    NSString *strVariantKW_Value;
    NSString *strVariantPetrol_Value;
    NSString *strVariantNM_Value;
    UIImageView *imageVieww;
    NSInteger deleteButtonTag;
    
    UIImagePickerController * picker;
    UIActionSheet *actionSheetVideos;
    NSString *moviePath;
    UIAlertView *uploadAlert;
    
    
    SMPhotosListNSObject *photosListObject;
    NSIndexPath *videoCellIndexPath;
    NSMutableArray *arrayOfVideos;
    NSString  *filToBeuplaoded;
    NSString *videoURL;
    BOOL isCamera;
    BOOL canClientUploadVideos;
    BOOL isSpecDetails;
    int videoCount;

    MBProgressHUD *uploadingHUD;
    NSMutableData *responseData;

    float valueOfProgress;
    float valueOfProgressDeletion;
    NSMutableArray *temporaryVideosUploadArray;

}

@property (nonatomic, strong) RPMultipleImagePickerViewController *multipleImagePicker;
@property (nonatomic, weak) id <refreshListModule> listRefreshDelegate;


@property (nonatomic, strong) IBOutlet ImageCropView      * imageCropView;


@property(strong, nonatomic) IBOutlet SMPopOverButtons    * buttonCancelPopOver;



@property(strong, nonatomic) IBOutlet SMCustomButtonBlue  * btnSave;
@property(strong, nonatomic) IBOutlet SMCustomButtonBlue  * btnSaveAndClose;



@property (nonatomic, strong) IBOutlet UIScrollView       *scrollView;

@property (strong, nonatomic) IBOutlet  UIView             *footerView;
@property (strong, nonatomic) IBOutlet  UIView             *headerView;
@property(strong, nonatomic)  IBOutlet  UIView             *viewCancelbutton;

@property (strong, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *videosCollectionView;
@property (strong, nonatomic) IBOutlet UITableView      *tableView;


@property (strong,nonatomic)  SMVINLookupObject            *VINLookupObject;
@property (strong,nonatomic)  SMLoadVehiclesObject         *vehicleObject;



@property(strong,nonatomic) NSString *strMeanCode;
@property(strong,nonatomic) NSString *strProgramName;
@property(strong,nonatomic) NSString *strUsedYear;
@property(strong,nonatomic) NSString *strSelctedVarinatName;
@property(strong,nonatomic) NSString *strSlectedVehicleYear;
@property(strong,nonatomic) NSString *strStockNumber;


@property(nonatomic)        int       iStockID;
@property(nonatomic)        int       strVariantId;

@property(nonatomic) BOOL isUpdateVehicleInformation;
@property(nonatomic) BOOL isAddingVehicleToStock;
@property(nonatomic) BOOL isFromVinLookUpEditPage;

@property (strong, nonatomic) SMPhotosAndExtrasObject *photosExtrasObject;
@property (strong, nonatomic) SMPhotosAndExtrasObject *photosExtrasDetailsObject;



@property (nonatomic, strong) UIPopoverController *userDataPopover;

@property (strong, nonatomic) IBOutlet UIButton *btnEditVariant;



@property (weak, nonatomic) IBOutlet SMCustomLable *lblMakeModel;

@property(strong, nonatomic) IBOutlet  SMCustomLable *lableType;
@property(strong, nonatomic) IBOutlet  SMCustomLable *lableYear;
@property(strong, nonatomic) IBOutlet  SMCustomLable *lableColor;
@property(strong, nonatomic) IBOutlet  SMCustomLable *lableMileage;
@property(strong, nonatomic) IBOutlet  SMCustomLable *lableStockNo;
@property(strong, nonatomic) IBOutlet  SMCustomLable *lablePrice;
@property(strong, nonatomic) IBOutlet  SMCustomLable *lablePriceRetail;
@property(strong, nonatomic) IBOutlet  SMCustomLable *lableProgramName;
@property(strong, nonatomic) IBOutlet  SMCustomLable *lableCondition;
@property(strong, nonatomic) IBOutlet  SMCustomLable *lableComment;
@property(strong, nonatomic) IBOutlet  SMCustomLable *lableExtras;
@property (nonatomic, strong) IBOutlet SMCustomLable *lblInfos;
@property (nonatomic, strong) IBOutlet SMCustomLable *lblTitle;

@property (strong, nonatomic) IBOutlet UIButton *btnPlusImage;

- (IBAction)btnPlusImageDidClicked:(id)sender;

-(IBAction)btnVehicleProgramDidPressed:(id)sender;
-(IBAction)btnActivateCPADidPressed:(id)sender;
-(IBAction)btnIgnoreExcludeSettingDidPressed:(id)sender;
-(IBAction)btnRemoveVehicleDidPressed:(id)sender;
-(IBAction)btnDontLetOverrideDidPressed:(id)sender;
-(IBAction)btnSaveDidPressed:(id)sender;
-(IBAction)btnCancelDidClicked:(id)sender;
-(IBAction)uploadDidClicked:(id)sender;

-(IBAction)buttonCancelVehicleDidPressed:(id)sender;
-(IBAction)buttonDoneVehicleDidPressed:(id)sender;
-(IBAction)btnIsRetailDidPressed:(id) sender;
-(IBAction)btnIsTenderDidPressed:(id) sender;

-(IBAction)buttonSaveAndClosedDidPressed:(id)sender;

-(void) updateVehicleInformations;

- (IBAction)btnForUpdatingVariantDidClicked:(id)sender;

 - (IBAction)btnPlusBtnVideosDidClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewHoldingBottomHeaderData;

@property (strong, nonatomic) IBOutlet UIView *viewHoldingTopHeaderData;


@property (weak, nonatomic) IBOutlet UIImageView *imgViewVehicle;

@property (weak, nonatomic) IBOutlet SMCustomLable *lblVehicleName;

@property (weak, nonatomic) IBOutlet SMCustomLable *lblMMCode;

@property (weak, nonatomic) IBOutlet SMCustomLable *lblVehicleDetails;

@property (strong, nonatomic) IBOutlet UIButton *btnEditVehicle;

- (IBAction)btnEmailDidClicked:(id)sender;

- (IBAction)btnPhoneDidClicked:(id)sender;


- (IBAction)btnCancelCustomAlertDidClicked:(id)sender;

@property BOOL isFromAddToStockPage;

@end
