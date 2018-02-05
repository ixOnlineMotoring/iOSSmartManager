//
//  SMStockAuditVinDetailsViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 19/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMVINLookupObject.h"
#import "QBImagePickerController.h"
#import "RPMultipleImagePickerViewController.h"
#import "SMClassOfBlogImages.h"
#import "UIActionSheet+Blocks.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomLable.h"
#import "MBProgressHUD.h"

@interface SMStockAuditVinDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,presentTheMultiplePhotoSelectionLibraryDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,UIAlertViewDelegate>
{

    MBProgressHUD *HUD;
    NSMutableString *currentNodeContent;

    UILabel *listActiveSpecialsNavigTitle;
    NSXMLParser *xmlParser;

    QBImagePickerController *imagePickerController;
    UIImagePickerController * picker;
    UIImage *selectedImage;
    UIImage *lastImage;
    NSString *documentsDirectory;
    NSString *fullPathOftheImage;
    NSData *imageData;
     NSMutableArray *arrayOfImages;
    int deleteButtonTag;
    NSTimer *timer;
    
    NSString *base64EncodedFronOfVehicle;
    NSString *base64EncodedVinDisc;
    
    
}
@property(nonatomic,strong)NSTimer *timer;

@property (nonatomic, strong) RPMultipleImagePickerViewController *multipleImagePicker;

@property (strong, nonatomic) IBOutlet UITableView *tblViewVinDetails;

@property(strong,nonatomic)SMVINLookupObject *VINLookupObject;


- (IBAction)btnAddImageDidClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewImages;

@property (strong, nonatomic) IBOutlet UIView *footerViewImages;

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnSave;

- (IBAction)btnSaveDetailsDidClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet SMCustomLable *lblCountDown;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblAlertText;


@end
