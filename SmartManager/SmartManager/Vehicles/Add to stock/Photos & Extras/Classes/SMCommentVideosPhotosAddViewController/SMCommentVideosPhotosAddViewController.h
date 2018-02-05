//
//  SMCommentVideosPhotosAddViewController.h
//  SmartManager
//
//  Created by Sandeep on 05/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPhotosAndExtrasTableViewCell.h"
#import "SMPhotosAndExtrasObject.h"
#import "CustomTextView.h"
#import "UIImage+Resize.h"
#import "SMGlobalClass.h"
//#import "YouTubeHelper.h"
#import "MBProgressHUD.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SMWebServices.h"
#import "UIImageView+WebCache.h"
#import "SMBase64ImageEncodingObject.h"
#import "SMClassOfPhotoAndVideoImages.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SMPhotosListNSObject.h"
#import "SMCommonClassMethods.h"
#import "SMPhotosAndExtrasListViewController.h"
#import "SMAppDelegate.h"
#import "SMClassOfUploadVideos.h"
#import "SMMoviePlayerClass.h"
#import "SMCustomLable.h"
#import "FGalleryViewController.h"
#import "ImageCropView.h"
#import "QBImagePickerController.h"
#import "RPMultipleImagePickerViewController.h"
#import "SMParserForUrlConnection.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import <MessageUI/MessageUI.h>
#import "SMCustomButtonBlue.h"
#import "SMAddToStockViewController.h"
@interface SMCommentVideosPhotosAddViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,UIWebViewDelegate,FGalleryViewControllerDelegate,ImageCropViewControllerDelegate,QBImagePickerControllerDelegate,presentTheMultiplePhotoSelectionLibraryDelegate,MFMailComposeViewControllerDelegate,refreshListModule>
{
    
    ImageCropView* imageCropView;
    QBImagePickerController *imagePickerController;
    
    
    IBOutlet UIView *popUpView;
    IBOutlet UIView *customAlertBox;
    IBOutlet UIImageView *imgClientImage;
    IBOutlet SMCustomButtonBlue *btnCancelCustomAlert;
    
    
    UIImage *selectedImage;
     UIImage *lastImage;
    
    NSMutableArray *arrayOfImages;
    NSMutableArray *arrayOfVideos;
    NSString *documentsDirectory;
    NSString  *filToBeuplaoded;
    NSString *videoURL;
    
    BOOL isPrioritiesImageChanged;
    BOOL isPrioritiesUpdateComments;
    BOOL isCamera;
    BOOL isFromAppGallery;
    BOOL didUserChangeAnyThing;
    BOOL photoCollectionSelected;
    BOOL canClientUploadVideos;
    BOOL hasUserSavedAnyChangedInfo;
    
    
   // BOOL isViewControllerPresent;
    
    NSData *imageData;
    NSString *fullPathOftheImage;
    int imgCount;
    int videoCount;
    NSInteger deleteButtonTag;
    int selectedIndexForImage;
    
    // For Gallery View
    
    NSArray                     *   localCaptions;
    NSArray                     *   localImages;
    NSArray                     *   networkCaptions;
    NSArray                     *   networkImages;
    FGalleryViewController      *   localGallery;
    FGalleryViewController      *   networkGallery;

    NSString *moviePath;
    MBProgressHUD *HUD;
    MBProgressHUD *uploadingHUD;
    
    UIActionSheet *actionSheetPhotos;
    UIActionSheet *actionSheetVideos;
    
    UIAlertView *uploadAlert;
    
    SMParserForUrlConnection *xmlParser;
    
    SMClassOfPhotoAndVideoImages *loadPhotosAndExtrasImagesObject;
    NSMutableString *currentNodeContent;
    
    UIImagePickerController * picker;
    
    SMPhotosListNSObject *photosListObject;
    SMClassOfUploadVideos *videoListObject;
    
    NSString *base64Str;
    NSMutableData *responseData;
    NSArray *assetsArray;
    
    SMAppDelegate *appdelegate;
    
    NSIndexPath *videoCellIndexPath;
   
    float valueOfProgress;
    float valueOfVideoProgress;
    
    int indexpathOfSelectedVideo;
    
    UIImageView *imageVieww;
}

@property (nonatomic, strong) RPMultipleImagePickerViewController *multipleImagePicker;
@property (nonatomic, strong) IBOutlet ImageCropView* imageCropView;
@property (strong, nonatomic) IBOutlet CustomTextView *txtViewComment;
@property (strong, nonatomic) IBOutlet CustomTextView *txtViewExtras;
//@property (strong) YouTubeHelper *youtubeHelper;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewImages;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewVideos;
@property (strong, nonatomic) SMPhotosAndExtrasObject *photosExtrasObject;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotosPlaceHolder;
@property (weak, nonatomic) IBOutlet UITableView *tblCommentVideoAndPhotos;
@property (strong, nonatomic) IBOutlet UIView *viewVechicles;
@property (strong, nonatomic) IBOutlet UIView *viewPhotos;
@property (strong, nonatomic) IBOutlet UIView *viewVideos;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoPlaceHolder;
@property (strong, nonatomic) IBOutlet UIView *viewComment;
@property (strong, nonatomic) IBOutlet UIView *viewExtras;
@property (strong, nonatomic) IBOutlet UIView *viewSaveFooter;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIView *viewCollectionBk;
@property (weak, nonatomic) IBOutlet UIView *viewCollectionVideoBk;
@property (weak, nonatomic) IBOutlet UIButton *btnUploadVideo;
@property (weak, nonatomic) IBOutlet UILabel *lblVehicleName;
@property (weak, nonatomic) IBOutlet UILabel *lblRegistration;
@property (weak, nonatomic) IBOutlet UILabel *lblColour;
@property (weak, nonatomic) IBOutlet UILabel *lblStockCode;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblMileage;
@property (weak, nonatomic) IBOutlet UILabel *lblRemaingDaysCount;
@property (weak, nonatomic) IBOutlet UILabel *lblExtras;
@property (weak, nonatomic) IBOutlet UILabel *lblComments;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotos;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotoCount;
@property (weak, nonatomic) IBOutlet UILabel *lblVideos;

@property (weak, nonatomic) IBOutlet UILabel *lblVehicleDetails1;

@property (weak, nonatomic) IBOutlet UILabel *lblVehicleDetails2;


@property (weak, nonatomic) IBOutlet UIView *viewExtrasCommentsPhotos;


@property (weak, nonatomic) IBOutlet UILabel *lblExtrasImage;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentsImage;
@property (weak, nonatomic) IBOutlet UILabel *lblVideosImage;

@property (weak, nonatomic) IBOutlet UIButton *btnPlusImage;


- (IBAction)btnPlusImageDidClicked:(id)sender;


@property(weak,nonatomic) IBOutlet SMCustomLable *lableExtrasComment;
@property(weak,nonatomic) IBOutlet SMCustomLable *lableComment;
@property (weak, nonatomic) IBOutlet UIView *viewContainingPrice;


@property (weak, nonatomic) IBOutlet UILabel *lblPriceRetail;

@property (weak, nonatomic) IBOutlet UILabel *lblPriceTrade;

@property (weak, nonatomic) IBOutlet UIView *viewContainingTraderPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblVehicleType;


- (void)getVehicleListsFromServer;
- (IBAction)btnSaveDidClicked:(id)sender;

- (IBAction)btnPlusBtnVideosDidClicked:(id)sender;

// Additional info for video upload


@property (weak, nonatomic) IBOutlet UILabel *lblVideoInfo;

- (IBAction)btnEmailDidClicked:(id)sender;

- (IBAction)btnPhoneDidClicked:(id)sender;


- (IBAction)btnCancelCustomAlertDidClicked:(id)sender;

- (IBAction)btnEditDidClicked:(id)sender;


@end
