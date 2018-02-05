//
//  SMGridViewViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMNavigationController.h"
#import "SMViewController.h"
#import "SMCustomTextField.h"
#import "SMClassForRefreshingData.h"
#import "SMPhotosAndExtrasListViewController.h"
#import "SMSpecialsViewController.h"
#import "SMGlobalClassForImpersonation.h"
#import "MBProgressHUD.h"
#import "SMImpersonationClientListing.h"
#import "QBImagePickerController.h"
#import "RPMultipleImagePickerViewController.h"

@interface SMGridViewViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,SMAuthenticationDelegate,impersonateClientsDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,delegateForProfilePicBackNavigation,QBImagePickerControllerDelegate,presentTheMultiplePhotoSelectionLibraryDelegate,UIImagePickerControllerDelegate>
{
    NSUserDefaults *prefs;
    NSMutableArray *arrGridModileObjects;
    NSMutableArray *arrayDropDown;
    NSMutableArray *arrayOfClientNames;
    NSMutableArray *arrayOfBlog;
    NSMutableArray *arrayOfModules;
    NSMutableArray *arrayOfImages;
    NSMutableString *currentNodeContent;
    
    UIImagePickerController * picker;
    QBImagePickerController *imagePickerController;
    UIImage *selectedImage;
    NSArray *assetsArray;
    
    SMGridModuleData *moduleObjFromSlideMenu;
    MBProgressHUD *HUD;
    
    NSArray *filteredArray;
    
     float heightForTheDropDown;
   
    NSXMLParser *xmlParser;
    NSString *resultString;
    NSOperationQueue *downloadingQueue;
    
    int selectedModule;
    
    int moduleClicked;
    
    int subModuleNumber;
    NSUInteger previousSubModuleNumber;
    int subModuleCount;
    NSString *subModulePageName;
    NSString *strModuleName;
    NSMutableArray *arrayOfSubModulePages;
    
    NSData            *imageData;
    NSString          *documentsDirectory;
    NSString          *fullPathOftheImage;
    NSString          *previousModuleName;
    
    BOOL isThirdLevelGridNeedToBeDisplayedFromSideMenu;
    BOOL isBackToHome;
    
    //////////////////////////////////////Monami////////////////////////
    
    NSString *strBase64;
    NSString *strForProfileImage;
    NSString *strImgName;
    ///////////////////////////////////////////////////////////////////

}
@property (nonatomic, strong) RPMultipleImagePickerViewController *multipleImagePicker;

@property (strong, nonatomic) IBOutlet UITextView *txtDummy;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewModuleList;
@property(strong, nonatomic)  SMNavigationController *navigationController;

@property (strong, nonatomic) IBOutlet UITableView *tblViewDropDown;

@property (strong, nonatomic) IBOutlet UITableView *tblSearchClients;

@property (strong, nonatomic) IBOutlet UIView *viewForSearch;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldSearch;

@property (strong, nonatomic) SMClassForRefreshingData *refreshData;

@property (strong, nonatomic) IBOutlet UIView *confirmationView;

@property (nonatomic, strong) SMImpersonationClientListing *prototypeCell;

- (IBAction)btnGoDidClicked:(id)sender;

- (IBAction)btnBackgroundDidClicked:(id)sender;

// this function was added by jignesh
-(IBAction)tapGestuteForRemovingImpersonationListing:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblHome;

@property (strong, nonatomic) IBOutlet UILabel *lblSearchImpersonate;




// Bottom Tab bar


@property (strong, nonatomic) IBOutlet UIView *viewBottomBar;

@property (strong, nonatomic) IBOutlet UIButton *btnHome;

@property (strong, nonatomic) IBOutlet UIButton *btnSynopsis;

@property (strong, nonatomic) IBOutlet UIButton *btnPost;

@property (strong, nonatomic) IBOutlet UIButton *btnDCard;

@property (strong, nonatomic) IBOutlet UIButton *btnContact;


@property (strong, nonatomic) IBOutlet UILabel *lblSynopsis;

@property (strong, nonatomic) IBOutlet UILabel *lblPost;

@property (strong, nonatomic) IBOutlet UILabel *lblDCard;

@property (strong, nonatomic) IBOutlet UILabel *lblContact;


@property (strong, nonatomic) IBOutlet UILabel *lblNoRecords;

@property (strong, nonatomic) IBOutlet UIImageView *imgClientImage;

@property (nonatomic, strong) SMImpersonateObject *impersonateClientObj;

- (IBAction)btnHomeDidClicked:(id)sender;

- (IBAction)btnSynopsisDidClicked:(id)sender;

- (IBAction)btnPostDidClicked:(id)sender;

- (IBAction)btnDCardDidClicked:(id)sender;

- (IBAction)btnContactDidClicked:(id)sender;


@end
