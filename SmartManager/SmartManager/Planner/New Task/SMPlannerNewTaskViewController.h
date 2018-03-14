//
//  SMPlannerNewTaskViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 20/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextFieldForDropDown.h"
#import "SMCustomTextField.h"
#import "CustomTextView.h"

#import "LXReorderableCollectionViewFlowLayout.h"
#import <QuartzCore/QuartzCore.h>
#import "SMClassForPlannerTypeList.h"
#import "SMClassForNewTaskMembers.h"
#import "SMClassForLocationClients.h"
#import "SMCustomLable.h"
#import "ImageCropView.h"
#import "MBProgressHUD.h"
#import "QBImagePickerController.h"
#import "RPMultipleImagePickerViewController.h"
#import "SMCalenderTextField.h"


@interface SMPlannerNewTaskViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate, NSXMLParserDelegate,UITextFieldDelegate,MBProgressHUDDelegate,ImageCropViewControllerDelegate,QBImagePickerControllerDelegate,presentTheMultiplePhotoSelectionLibraryDelegate>
{
    
    ImageCropView* imageCropView;
     QBImagePickerController *imagePickerController;
     UIImagePickerController * picker;
    UIImage *selectedImage;
    UIImage *lastImage;

    BOOL isCamera;
    
    NSXMLParser *xmlParser;
    
    NSMutableArray *arrayOfImages;
    NSMutableArray *arrayOfPlannerType;
    NSMutableArray *arrayOfMembers;
    NSMutableArray *arrayOfAvailableClients;
    NSArray *filteredArrayForClientDropdown;
    
    NSMutableData *responseData;
    
    NSString *documentsDirectory;
    NSData *imageData;
    NSString *fullPathOftheImage;
    NSString *base64Str;
    
    NSMutableString *currentNodeContent;
    
    NSOperationQueue *downloadingQueue;
    NSString *resultString;
    NSArray *assetsArray;
    BOOL isFromAppGallery;
    
    
    int imgCountPlanner;
    int deleteButtonTag;
    int selectedClientId;
    int plannerTypeID;
    int recipientID;
    
    int taskIDForUploadingImages;
    
     BOOL isClientsDropdownExpanded;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) RPMultipleImagePickerViewController *multipleImagePicker;

@property (nonatomic, strong) IBOutlet ImageCropView* imageCropView;

@property (strong, nonatomic) IBOutlet UITableView *tblViewNewTask;

@property (strong, nonatomic) IBOutlet UIView *viewDetails;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldClientFilter;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldSelectClient;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldType;

@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtFieldSelectRecipient;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldTitle;

@property (strong, nonatomic) IBOutlet CustomTextView *txtViewDetails;

@property (strong, nonatomic) IBOutlet SMCalenderTextField *txtFieldSelectDate;

@property (strong, nonatomic) IBOutlet SMCalenderTextField *txtFieldSelectTime;
@property (strong, nonatomic) IBOutlet UILabel *lblCalenderEvent;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;

@property (strong, nonatomic) SMClassForPlannerTypeList *plannerTypeListObject;
@property (strong, nonatomic) SMClassForNewTaskMembers *membersObject;
@property (strong, nonatomic) SMClassForLocationClients *locClientObject;

@property (strong, nonatomic) IBOutlet UIButton *checkBoxCalenderEvent;


@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewImages;

@property (strong, nonatomic) IBOutlet UIView *dateView;

@property (strong, nonatomic) IBOutlet UIView *timeView;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerForTime;

@property (strong, nonatomic) IBOutlet UIView *popUpView;

@property (strong, nonatomic) IBOutlet UITableView *tblViewType;

@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@property (strong, nonatomic) IBOutlet UITableView *tblViewClientsDropdown;

@property (strong, nonatomic) IBOutlet UIView *viewForClientsDropdown;

// Labels

@property (strong, nonatomic) IBOutlet SMCustomLable *lblFilter;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblClient;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblType;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblUser;


@property (strong, nonatomic) IBOutlet SMCustomLable *lblTitle;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblDetails;

@property (strong, nonatomic) IBOutlet UIView *outerViewOfImages;


- (IBAction)btnPlusImageDidClicked:(id)sender;

- (IBAction)cancelFromDatePickerDidClicked:(id)sender;

- (IBAction)clearFromDatePickerDidClicked:(id)sender;

- (IBAction)doneBtnForDatePickerDidClicked:(id)sender;

- (IBAction)doneBtnForTimePickerDidClicked:(id)sender;

- (IBAction)checkBoxCalenderEventDidClicked:(id)sender;

- (IBAction)clearButtonFromTimePickerDidClicked:(id)sender;

- (IBAction)btnSaveDidClicked:(id)sender;

- (IBAction)btnCancelDidClicked:(id)sender;


@end
