//
//  SMCarTouchRecognitionDetailViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 12/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelAutolayout.h"
#import "CustomTextView.h"
#import "SMCustomTextField.h"
#import "QBImagePickerController.h"
#import "RPMultipleImagePickerViewController.h"
#import "UIActionSheet+Blocks.h"
#import "SMPhotosListNSObject.h"
#import "FGalleryViewController.h"
#import "SMAppDelegate.h"
#import "MBProgressHUD.h"


@interface SMCarTouchRecognitionDetailViewController : UIViewController<UIImagePickerControllerDelegate,QBImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,presentTheMultiplePhotoSelectionLibraryDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,UIActionSheetDelegate,FGalleryViewControllerDelegate>
{
    
    IBOutlet SMCustomLabelAutolayout *lblCarAreaName;
    
    IBOutlet CustomTextView *txtViewComments;

    IBOutlet SMCustomTextField *txtFieldPrice;
    
    IBOutlet UICollectionView *collectionViewImages;
    
    
    IBOutlet UIView *viewContainingImages;
    
    IBOutlet UIButton *btnRepair;
    
    IBOutlet UIButton *btnReplace;
    
    
    BOOL isFromAppGallery;
    int imgCount;

    UIImage *selectedImage;

    NSMutableArray *arrayOfImages;
    
    QBImagePickerController *imagePickerController;
    SMPhotosListNSObject *photosListObject;
    NSString *documentsDirectory;
    NSData *imageData;
    UIImagePickerController * picker;
    NSString *fullPathOftheImage;
    NSArray *assetsArray;
    SMAppDelegate *appdelegate;
    BOOL isPrioritiesImageChanged;
    BOOL isAnythingChangedAndNotSavedYet;
    NSInteger deleteButtonTag;

    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    
    
    UIActionSheet *actionSheetPhotos;
    UIActionSheet *actionSheetVideos;
    
    // For Gallery View
    
    NSArray                     *   localCaptions;
    NSArray                     *   localImages;
    NSArray                     *   networkCaptions;
    NSArray                     *   networkImages;
    FGalleryViewController      *   localGallery;
    FGalleryViewController      *   networkGallery;

}
@property (nonatomic, strong) RPMultipleImagePickerViewController *multipleImagePicker;

@property(nonatomic,strong)NSString *selectedCarArea;
@property(nonatomic,strong)NSString *selectedCarPartNumber;

- (IBAction)btnCheckBoxRepairDidClicked:(id)sender;

- (IBAction)btnCheckBoxReplaceDidClicked:(id)sender;

- (IBAction)btnPlusDidClicked:(id)sender;

- (IBAction)btnSaveDetailsDidClicked:(id)sender;



@end
