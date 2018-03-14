//
//  SMCreateBlogViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 18/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "CustomTextView.h"
#import "SMPreviewBlogViewController.h"

#import "SMBlogPostTypeObject.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import <QuartzCore/QuartzCore.h>
#import "SMEditSearchObject.h"
#import "MBProgressHUD.h"

#import "FGalleryViewController.h"
#import "SMCustomLable.h"
#import "ImageCropView.h"
#import "SMCustomLabelBold.h"
#import "SMCalenderTextField.h"
#import "QBImagePickerController.h"
#import "RPMultipleImagePickerViewController.h"
#import "SMParserForUrlConnection.h"
#import "SMClassOfBlogImages.h"

@class SMSearchBlogViewController;

@protocol searchBlogDelegate <NSObject>

- (void)updateBlogList;

@end

@interface SMCreateBlogViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout,UITextFieldDelegate,NSXMLParserDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,SMSaveTheBlogFromPreviewDelegate,MBProgressHUDDelegate,FGalleryViewControllerDelegate,ImageCropViewControllerDelegate,QBImagePickerControllerDelegate,presentTheMultiplePhotoSelectionLibraryDelegate>
{
    
    ImageCropView* imageCropView;
    UIImagePickerController * picker;
    QBImagePickerController *imagePickerController;
    
    SMParserForUrlConnection *xmlParser;
    NSString *base64Str;
    NSData *imageData;
    NSString *fullPathOftheImage;
    NSMutableArray *arrayOfBlogPostType;
    NSMutableArray *arrayOfImages;
    NSMutableString *currentNodeContent;
     NSMutableArray *arrayOfEditImages;
    NSMutableArray *arrayOfEditBlog;
    
    NSArray *arrayFilteredForEditBlogPostType;
    NSArray *assetsArray;
    
    
    UIImage *lastImage;
    UIImage *selectedImage;
    
    
    NSMutableData *responseData;
    
    NSString *selectedBlogType;
    
   // int selectedBlogPostTypeID;
    
    int selectedBlogPostID;
    int blogPostTypeIdForEdit;
    
    int deleteButtonTag;
    
    BOOL isExpandable;
    BOOL isFromAppGallery;
    
    int collectionCellCount;
     NSString *documentsDirectory;
    int selectedIndex;
    BOOL initialSelection;
    BOOL isPrioritiesChanged;
    BOOL isCamera;
    CGPoint svos;
    MBProgressHUD *HUD;


    
    // added by Jignesh K on 5 feb for Gallery View
    NSArray                     *networkCaptions;
    FGalleryViewController      *networkGallery;
    
    __weak id <searchBlogDelegate> blogDelegate;
}


@property (nonatomic, strong) RPMultipleImagePickerViewController *multipleImagePicker;
//@property (nonatomic, strong) SMSearchBlogViewController *searchBlogScreen;

@property (nonatomic, weak) id <searchBlogDelegate> blogDelegate;

@property (nonatomic, strong) IBOutlet ImageCropView* imageCropView;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblTitle;


@property (strong, nonatomic) IBOutlet SMCustomLable *lblDetails;


@property (strong, nonatomic) IBOutlet SMCustomLable *lblAuthor;

@property (strong, nonatomic) IBOutlet UITableView *tblViewCreateBlog;

@property (strong, nonatomic) IBOutlet UIView *viewDetails;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldTitle;

@property (strong, nonatomic) IBOutlet CustomTextView *txtViewDetails;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldAuthor;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewImages;

@property (strong, nonatomic) IBOutlet UIView *viewCollectionImages;

@property (strong, nonatomic) IBOutlet UIButton *btnCheckBoxActive;

@property (strong, nonatomic) IBOutlet SMCustomLabelBold *lblActive;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;

@property (strong, nonatomic) IBOutlet UIButton *btnPreview;

@property (strong, nonatomic) IBOutlet UILabel *lblHoldImages;

@property (strong, nonatomic) IBOutlet UIView *popUpView;

@property (strong, nonatomic) IBOutlet SMCalenderTextField *txtFieldStartDate;
@property (strong, nonatomic) IBOutlet SMCalenderTextField *txtFieldEndDate;

@property (strong, nonatomic) IBOutlet UIView *dateView;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) SMBlogPostTypeObject *blogPostType;

@property (strong, nonatomic) SMEditSearchObject *searchBlogForEdit;
@property (strong, nonatomic) SMEditSearchObject *editObject;
@property (strong, nonatomic) SMClassOfBlogImages *editImageObject;
@property (strong, nonatomic) NSMutableArray *arrayOfEditImageObjects;

@property(assign)BOOL isFromCustomerDelivery;

@property (assign)int blogPostIdForEditing;

@property (assign)int selectedBlogPostTypeID;

@property(assign)BOOL isBlogEdited;

- (IBAction)btnPlusImageDidClicked:(id)sender;

- (IBAction)doneButtonForDatePickerDidClicked:(id)sender;


- (IBAction)btnSaveDidClicked:(id)sender;

- (IBAction)btnCheckBoxActiveDidClicked:(id)sender;

- (IBAction)cancelBtnDidClicked:(id)sender;

- (IBAction)btnClearDidClicked:(id)sender;

- (IBAction)btnPreviewDidClicked:(id)sender;

@end
