//
//  MultipleImagePickerViewController.h
//
//  Created by Renato Peterman on 17/08/14.
//  Copyright (c) 2014 Renato Peterman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "RPImageCell.h"
#import "SMtextFiledWithoutBorder.h"
#import "ImageCropView.h"
#import "MBProgressHUD.h"
@protocol presentTheMultiplePhotoSelectionLibraryDelegate <NSObject>


-(void)callTheMultiplePhotoSelectionLibraryWithRemainingCount:(int)remainingCount andFromEditScreen:(BOOL)isFromEditScreen;
-(void)callToSelectImagesFromCameraWithRemainingCount:(int)remainingCount andFromEditScreen:(BOOL)isFromEditScreen;
-(void)sendTheUpdatedImageArray:(NSMutableArray*)updatedArray;
-(void)delegateFunction:(UIImage*)imageToBeDeleted;
-(void)delegateFunctionWithOriginIndex:(int)originIndex;
-(void)delegateFunctionForDeselectingTheSelectedPhotos;
-(void)dismissTheLoader;

//-(void) callTheMultiplePhotoSelectionLibraryWithArray:(NSMutableArray*)updatedArray;

@end



typedef void (^ RPMultipleImagePickerDoneCallback)(NSArray *images);

@interface RPMultipleImagePickerViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UINavigationBarDelegate,MBProgressHUDDelegate>
{
    
     MBProgressHUD *HUD;
    UIButton *btnDelete;
    UIButton *btnRotate;
    UIButton *btnCrop;
    UIBarButtonItem *doneButton;
    NSIndexPath *selectedIndexpath;
    NSMutableArray *arrayOfOriginalSizeImages;
    NSMutableArray *arrayFinalEditedImage;
    
    UIImage *selectedImage;
    UIImage *lastImage;
    
    int existingCount;
    
    NSString *documentsDirectory;
    NSData *imageData;
    NSString *fullPathOftheImage;

}
@property (nonatomic, copy) RPMultipleImagePickerDoneCallback doneCallback;
@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, strong) NSMutableArray *Originalimages;
//@property (nonatomic, strong) NSMutableArray *ThumbnailImages;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) IBOutlet UIButton *btRemover;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, readwrite) NSUInteger selectedIndex;
@property (nonatomic, readwrite) UIImagePickerControllerSourceType sourceType;
@property (assign)BOOL isFromApp;
@property (assign)BOOL isFromStockAuditScreen;
@property (assign)BOOL isFromGridView;

@property (strong, nonatomic) IBOutlet UITextField *txtFieldCaption;

@property(nonatomic,strong)id <presentTheMultiplePhotoSelectionLibraryDelegate> photoSelectionDelegate;

@property (nonatomic, strong) ImageCropView *cropView;


- (void)addOriginalImages:(NSString*)imageName;
- (void)addThumbnailImages:(UIImage*)image;
//- (void)addThumbnailImages:(UIImage*)image;

- (IBAction)remove:(id)sender;

@end
