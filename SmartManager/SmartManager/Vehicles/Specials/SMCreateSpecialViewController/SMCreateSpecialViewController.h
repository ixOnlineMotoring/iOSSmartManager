//
//  SMCreateSpecialViewController.h
//  SmartManager
//
//  Created by Sandeep on 19/11/14. // modification by Jignesh
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+Padding.h"
#import "CustomTextView.h"
#import "SMCustomTextField.h"
#import "SMCellOfPlusImageCommentPV.h"
#import "SMPhotosListNSObject.h"
#import "UIImageView+WebCache.h"
#import "SMCommonClassMethods.h"
#import "SMGlobalClass.h"
#import "SMLoadSpecialObject.h"
#import "SMCustomLable.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomColor.h"
#import "SMBase64ImageEncodingObject.h"
#import "SMActiveSpecial.h"
#import "SMLoadVehiclesObject.h"
#import "FGalleryViewController.h"
#import "ImageCropView.h"
#import "MBProgressHUD.h"
#import "SMCalenderTextField.h"

#import "QBImagePickerController.h"
#import "RPMultipleImagePickerViewController.h"


// added by ketan
enum checkBoolean
{
    isImage = 1,
    isEditable = 2,
    isNone = 3
};

@protocol ActiveListingRefreshing <NSObject>

-(void) getAllActiveListingRefreshed;

@end



@interface SMCreateSpecialViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSXMLParserDelegate,MBProgressHUDDelegate,UICollectionViewDataSource,UICollectionViewDelegate,FGalleryViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ImageCropViewControllerDelegate,QBImagePickerControllerDelegate,presentTheMultiplePhotoSelectionLibraryDelegate>
{
    SMLoadVehiclesObject        *loadVehiclesObject;
    SMPhotosListNSObject        *loadImageData;
    SMLoadSpecialObject         *loadSpecialObject;

    NSArray                     *networkCaptions;
    FGalleryViewController      *networkGallery;

    ImageCropView               * imageCropView;
    UIImage                     * selectedImage;
    UIImage                     * lastImage;
    
    UIActionSheet               *actionCreateSpSheetPhotos;
    UIActionSheet               *actionSheetPhotos;

    NSMutableArray              *arrayCreateSpOfImages;
    NSMutableArray              *typeArray;
    NSMutableArray              *arrayYears;

    NSMutableArray              *makeArray;
    NSMutableArray              *modelArray;
    NSMutableArray              *variantArray;
    NSMutableArray              *vehicleArray;
    NSArray *assetsArray;
    BOOL isFromAppGallery;
    
    
    NSData                      *imageData;
    
    NSDate                      *startDate;

    NSString                    *documentsDirectory;
    NSString                    *fullPathOftheImage;
    NSString                    *base64Str;
    
    UIImagePickerController     *picker;

    NSInteger                   deleteButtonTag;
    NSInteger                   selectedRow;

    MBProgressHUD               *uploadingHUD;
    MBProgressHUD               *HUD;

    NSXMLParser                 *xmlParser;
    NSMutableString             *currentNodeContent;
    
    int checkImage;
    int selectedIndexForImage;

    BOOL isPrioritiesChanged;
    BOOL isVehicleTypeisSelected;
    BOOL isStatus;
    BOOL isChecked;
    BOOL isVehicleisAlreadyInStcok;
    BOOL isCamera;
    
    int lastSelected;
    
    float valueOfProgress;

    int selectedType;
    int selectedSpecialTypeID;
    int specialID;
    int currentUserID;
    int savedSpecialID;
    
    int iMakeID;
    int iModelID;
    int iVariantID;
    int itemID;
    int currentYear;

    int makeIndex;
    int modelIndex;
    int variantIndex;

     QBImagePickerController *imagePickerController;
    
    IBOutlet UIButton *cancelButton;
}

@property (nonatomic, strong) IBOutlet ImageCropView* imageCropView;

@property (nonatomic, strong) RPMultipleImagePickerViewController *multipleImagePicker;

#pragma mark - user define functions
- (IBAction)btnCancelDidClicked:(id)sender;
- (IBAction)btnSetDidClicked:(id)sender;
- (IBAction)dismissNumberPad:(id)sender;

#pragma mark - Properties

// alignments added by jignesh
@property (strong, nonatomic)   IBOutlet   UIView *selectTypeView;
@property (strong, nonatomic)   IBOutlet   UIView *moreInfoView;
@property (strong, nonatomic)   IBOutlet   UIView *vehicleDetailView;
@property (strong, nonatomic)   IBOutlet   UIView *otherDetailsView;
@property (strong, nonatomic)   IBOutlet   UIView *collectionInnerView;
@property (strong, nonatomic)   IBOutlet   UIView *pickerView;
@property (strong, nonatomic)   IBOutlet   UIView *popupView;
@property (strong, nonatomic)   IBOutlet   UIView *viewHeader;
@property (strong, nonatomic)   IBOutlet   UIView *footerView;
@property (strong, nonatomic)   IBOutlet   UIView *viewForAlreadyInStock;

@property (weak, nonatomic) IBOutlet SMCustomLable *lblTypePlace;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblVehiclePlace;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblMakePlace;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblModelPlace;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblVariantPlace;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblRetailPlace;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblSpecialPlace;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblTitlePlace;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblDescriptionPlace;

@property (weak, nonatomic) IBOutlet SMCustomLable *lblType;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblVehicleName;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblName;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblYear;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblColour;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblMileage;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblPrice;
//@property (weak, nonatomic) IBOutlet SMCustomLable *lblCorrectedError;
@property (weak, nonatomic) IBOutlet SMCustomLable *lblTo;
@property (weak,nonatomic)  IBOutlet SMCustomLable *lblRequiredFieldsInfo;


@property (weak, nonatomic) IBOutlet SMCustomTextField  *txtSelectType;
@property (weak, nonatomic) IBOutlet SMCustomTextField  *txtSelectVehicle;
@property (weak, nonatomic) IBOutlet SMCustomTextField  *txtNormalPriceR;
@property (weak, nonatomic) IBOutlet SMCustomTextField  *txtSpecialPrice;
@property (weak, nonatomic) IBOutlet SMCustomTextField  *txtTitle;
@property (weak, nonatomic) IBOutlet SMCustomTextField  *txtMake;
@property (weak, nonatomic) IBOutlet SMCustomTextField  *txtModel;
@property (weak, nonatomic) IBOutlet SMCustomTextField  *txtVariant;

@property (weak, nonatomic) IBOutlet SMCalenderTextField  *txtStartDate;
@property (weak, nonatomic) IBOutlet SMCalenderTextField  *txtEndDate;


@property (weak, nonatomic) IBOutlet SMCustomButtonBlue *btnSave;


@property (strong, nonatomic) IBOutlet CustomTextView     *txtvDescription;


@property (strong, nonatomic) IBOutlet UITableView        *tblCreateSpecial;
@property (strong, nonatomic) IBOutlet UITableView        *loadSpecialTableView;

@property (strong, nonatomic) IBOutlet UICollectionView   *collectionViewSpecialImages;

@property (weak, nonatomic)    IBOutlet UIButton           *btnCorrected;
@property (strong,nonatomic)   IBOutlet UIButton           *cancelButton;
@property (weak,nonatomic)     IBOutlet UIButton           *btnSet;
@property (weak,nonatomic)     IBOutlet UIButton           *btnCancel;
@property (strong,nonatomic)   IBOutlet UIButton           *btnDone;

@property (weak,nonatomic)     IBOutlet UIDatePicker        *datePickerView;
@property (strong, nonatomic)   IBOutlet UIView         *yearView;
@property (strong, nonatomic)   IBOutlet UIPickerView         *yearPickerView;

@property (nonatomic, strong) SMActiveSpecial *activeSpecialObj;
@property (nonatomic) int     iCheckSpecial;

- (IBAction)btnPlusImageDidClicked:(id)sender;


#pragma mark -

@end
