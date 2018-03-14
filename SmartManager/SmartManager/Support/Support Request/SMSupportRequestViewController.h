//
//  SMSupportRequestViewController.h
//  Smart Manager
//
//  Created by Ketan Nandha on 10/11/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomButtonBlue.h"
#import "SMCustomTextField.h"
#import "CustomTextView.h"
#import "SMTraderSearchSortByCell.h"
#import "SMDropDownObject.h"
#import "QBImagePickerController.h"
#import "RPMultipleImagePickerViewController.h"
#import "SMPhotosListNSObject.h"
#import "FGalleryViewController.h"
#import "SMAppDelegate.h"
#import "UIImage+Resize.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "SMBase64ImageEncodingObject.h"

@interface SMSupportRequestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate,UITextViewDelegate,UIDocumentPickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ImageCropViewControllerDelegate,QBImagePickerControllerDelegate,presentTheMultiplePhotoSelectionLibraryDelegate,FGalleryViewControllerDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate,NSXMLParserDelegate>{

    UIActionSheet *actionSheetPhotos;
    ImageCropView* imageCropView;
    QBImagePickerController *imagePickerController;
    NSMutableArray *arrayOfImages;
    BOOL isCamera;
    BOOL isFromAppGallery;
    UIImagePickerController * picker;
    NSArray *assetsArray;
    SMPhotosListNSObject *photosListObject;
    int imgCount;
    NSData *imageData;
    NSString *fullPathOftheImage;
    NSString *documentsDirectory;
    UIImage *selectedImage;
    FGalleryViewController      *   localGallery;
    FGalleryViewController      *   networkGallery;
    SMAppDelegate *appdelegate;
    NSArray                     *   networkCaptions;
    NSMutableArray *arrForCloudData;
    
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    
    BOOL isfromDocument;
    UIImage* thumbnailImage;
    NSInteger deleteButtonTag;
    NSString *nameOfFileFromCloud;
    NSString *strDocType;
    BOOL isTextFieldSortBy;

    __weak IBOutlet UIButton *btnPlus;
    
}

@property (nonatomic, strong) RPMultipleImagePickerViewController *multipleImagePicker;
@property (nonatomic, strong) IBOutlet ImageCropView* imageCropView;
@property (nonatomic,weak) IBOutlet SMCustomButtonBlue *btnSubmit;
@property (nonatomic,weak) IBOutlet CustomTextView *txtvwRequest;
@property (nonatomic,weak) IBOutlet SMCustomTextField *txtfieldTeamList;
@property (weak, nonatomic) IBOutlet SMCustomTextField *txtFieldRequestTitle;


@property (nonatomic,weak) IBOutlet UIView *vwImageViewUpload;


- (IBAction)btnSubmitDidClicked:(id)sender;







@property (strong, nonatomic) IBOutlet UITableView *tableSortItems;
@property (strong, nonatomic) IBOutlet UIView *popUpViewForSort;
@property (strong, nonatomic) IBOutlet UIView *viewDropdownFrame;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewImages;

@end
