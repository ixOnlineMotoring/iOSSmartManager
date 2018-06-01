//
//  SMCarTouchRecognitionDetailViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 12/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMCarTouchRecognitionDetailViewController.h"
#import "SMGlobalClass.h"
#import "SMSellCollectionCell.h"
#import "SMCellOfPlusImageCommentPV.h"
#import "UIImageView+WebCache.h"
#import "SMCommonClassMethods.h"
#import "SMWebServices.h"

@interface SMCarTouchRecognitionDetailViewController ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,UITextViewDelegate>
{
    NSString*  base64Str;
    BOOL isSaveExteriorWSResponse;
}

@end

@implementation SMCarTouchRecognitionDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.navigationItem.titleView = [SMCustomColor setTitle:@"Recon Item / Area"];
    lblCarAreaName.text = self.selectedCarArea;
    [self registerNib];
    [self addingProgressHUD];
    txtViewComments.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    txtViewComments.layer.borderWidth= 0.8f;
    
    viewContainingImages.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
   viewContainingImages.layer.borderWidth= 0.8f;

    arrayOfImages = [[NSMutableArray alloc]init];
    
    self.multipleImagePicker = [[RPMultipleImagePickerViewController alloc] init];
    self.multipleImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.multipleImagePicker.photoSelectionDelegate = self;
    
    [SMGlobalClass sharedInstance].totalImageSelected  = 0;
    [SMGlobalClass sharedInstance].isFromCamera = NO;

}

#pragma mark - UITableView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"arrayOfImages count = %lu",(unsigned long)arrayOfImages.count);
        return arrayOfImages.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
        SMCellOfPlusImageCommentPV *cellImages;
        
        {
            cellImages =
            [collectionView dequeueReusableCellWithReuseIdentifier:@"SMCellOfActualImagePV" forIndexPath:indexPath];
            
            [cellImages.btnDelete addTarget:self action:@selector(btnDeleteImageDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            cellImages.btnDelete.tag = indexPath.row;
            
            SMPhotosListNSObject *imageObj = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:indexPath.row];//was crashing here.....
            
            cellImages.webVYouTube.hidden=YES;
            
            if(imageObj.isImageFromLocal)
            {
                if(![imageObj.strimageName isEqualToString:@""])
                {
                    NSString *str = [NSString stringWithFormat:@"%@.jpg",imageObj.strimageName];
                    
                    NSString *fullImgName=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
                    
                    cellImages.imgActualImage.image = [UIImage imageWithContentsOfFile:fullImgName];
                    
                }
                
            }
            else
            {
                [cellImages.imgActualImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageObj.imageLink]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
            }
            
            //isPrioritiesImageChanged = YES;
        }
        return cellImages;
   
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(94, 78);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (collectionView==collectionViewImages)
    {
        
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        networkGallery.startingIndex = indexPath.row;
        SMAppDelegate *appdelegate1 = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate1.isPresented =  YES;
        [self.navigationController pushViewController:networkGallery animated:YES];
    }
    
}

#pragma mark -

#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    
    if(gallery == networkGallery)
    {
        num = (int)[arrayOfImages count];
    }
    return num;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    SMPhotosListNSObject *imageObject = (SMPhotosListNSObject*) arrayOfImages[index];
    
    if (imageObject.isImageFromLocal == NO)
    {
        return FGalleryPhotoSourceTypeNetwork;
    }
    else
    {
        return FGalleryPhotoSourceTypeLocal;
    }
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    if( gallery == networkGallery )
    {
        caption = [networkCaptions objectAtIndex:index];
    }
    return caption;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    
    SMPhotosListNSObject *imgObj = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:index];
    return  imgObj.imageLink;
    
}
- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    SMPhotosListNSObject *imgObj = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:index];
    return  imgObj.imageLink;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnCheckBoxRepairDidClicked:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if(sender.isSelected)
        btnReplace.selected = NO;
}

- (IBAction)btnCheckBoxReplaceDidClicked:(UIButton*)sender
{
     sender.selected = !sender.selected;
    if(sender.isSelected)
        btnRepair.selected = NO;
}

- (IBAction)btnPlusDidClicked:(id)sender
{
    int RemainingCount;
    
    NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];
    NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
    if ([arrayFiltered count] > 0)
    {
        RemainingCount = (int)arrayOfImages.count-(int)arrayFiltered.count;
    }
    else
        RemainingCount =(int)arrayOfImages.count;
    
    if(RemainingCount<20)
    {
        
        actionSheetPhotos = [[UIActionSheet alloc] initWithTitle:@"Select the picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Select from library", nil];
        actionSheetPhotos.actionSheetStyle = UIActionSheetStyleDefault;
        actionSheetPhotos.tag=101;
        [actionSheetPhotos showInView:self.view];
        
    }
    
}
-(IBAction)btnDeleteImageDidClicked:(id)sender1
{
    UIButton *button=(UIButton *)sender1;
    deleteButtonTag = button.tag;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:KLoaderTitle message:KDeleteImageAlert delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    alert.tag = 201;
    [alert show];
}
#pragma mark - AlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==201)
    {
        if(buttonIndex==0)
        {
            
        }
        else
        {
            SMPhotosListNSObject *deleteImageObject = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:deleteButtonTag];
            
            if(deleteImageObject.isImageFromLocal==NO)
            {
                [[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted addObject:[arrayOfImages objectAtIndex:deleteButtonTag]];
            }
            else
            {
                if (deleteImageObject.imageOriginIndex >= 0)
                {
                    [SMGlobalClass sharedInstance].isFromCamera = NO;
                    
                    //Means image from that picker of multiple image selection
                    [self delegateFunctionWithOriginIndex:deleteImageObject.imageOriginIndex];
                    
                    for (int i=(int)deleteButtonTag+1;i<[arrayOfImages count];i++)
                    {
                        SMPhotosListNSObject *deleteImageObjectTemp = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:i];
                        deleteImageObjectTemp.imageOriginIndex--;
                    }
                }
            }
            
            
            
            isPrioritiesImageChanged = YES;
            
            [arrayOfImages removeObjectAtIndex:deleteButtonTag];
            [collectionViewImages reloadData];
        }
    }
    
    
    
    
}


#pragma - mark Selecting Image from Camera and Library

- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    {
        // Picking Image from Camera/ Library
        [picker dismissViewControllerAnimated:NO completion:^{
            picker.delegate=nil;
            picker = nil;
        }];
        
        
        //@"UIImagePickerControllerOriginalImage"
        selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        
        
        
        
        if (picker1.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            [SMGlobalClass sharedInstance].isFromCamera = YES;
        }
        
        
        if (!selectedImage)
        {
            return;
        }
        
        
        if (selectedImage.imageOrientation == UIImageOrientationLeft || selectedImage.imageOrientation == UIImageOrientationRight)
        {
            selectedImage = [[SMCommonClassMethods shareCommonClassManager] scaleAndRotateImage:selectedImage];
        }
        
        
        
        NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
        
        [formatter1 setDateFormat:@"ddHHmmssSSS"];
        
        NSString *dateString=[formatter1 stringFromDate:[NSDate date]];
        
        NSString *imgName =[NSString stringWithFormat:@"%@_asset",dateString];
        
        [self saveImage:selectedImage :imgName];
        
        [self.multipleImagePicker addOriginalImages:imgName];
        
        
        BOOL isViewControllerPresent = NO;
        
        for (UINavigationController *view in self.navigationController.viewControllers)
        {
            //when found, do the same thing to find the MasterViewController under the nav controller
            if ([view isKindOfClass:[RPMultipleImagePickerViewController class]])
            {
                isViewControllerPresent = YES;
                
                
            }
            
            
        }
        
        
        if(!isViewControllerPresent)
        {
            self.multipleImagePicker.isFromStockAuditScreen = NO;
            self.multipleImagePicker.isFromGridView = NO;
            [self.navigationController pushViewController:self.multipleImagePicker animated:YES];
        }
        
        
        
        // Done callback
        self.multipleImagePicker.doneCallback = ^(NSArray *images)
        {
            
            
            
            
            for(int i=0;i< images.count;i++)
            {
                
                SMPhotosListNSObject *imageObject = [[SMPhotosListNSObject alloc]init];
                imageObject.strimageName=[images objectAtIndex:i];
                imageObject.isImageFromLocal = YES;
                imageObject.imagePriorityIndex=imgCount;
                imageObject.imageLink = [self loadImagePath:[images objectAtIndex:i]];
                imageObject.imageOriginIndex = -2;
                imageObject.isImageFromCamera = YES;
                
                [arrayOfImages addObject:imageObject];
                
                selectedImage = nil;
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [collectionViewImages reloadData];
                [self.multipleImagePicker.Originalimages removeAllObjects];
            });
        };
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1
{
    if([SMGlobalClass sharedInstance].isFromCamera)
        [SMGlobalClass sharedInstance].photoExistingCount--;
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
}

-(NSString*)createIdFromCurrentDateTimestamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [dateFormatter stringFromDate:[NSDate date]];
}



#pragma mark - QBImagePickerControllerDelegate


-(void)callTheMultiplePhotoSelectionLibraryWithRemainingCount:(int)remainingCount andFromEditScreen:(BOOL)isFromEditScreen;
{
    
    if(isFromEditScreen)
    {
        
        if(imagePickerController == nil)
            imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
    
    else
    {
        if(imagePickerController == nil)
            imagePickerController = [[QBImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        
        
        if(remainingCount>20)
        {
            imagePickerController.maximumNumberOfSelection = 0;
        }
        
        else
        {
            if(isFromAppGallery)
            {
                NSPredicate *predicateImages1 = [NSPredicate predicateWithFormat:@"imageOriginIndex >= %d",0];
                NSArray *arrayFiltered1 = [arrayOfImages filteredArrayUsingPredicate:predicateImages1];
                imagePickerController.maximumNumberOfSelection = remainingCount+[arrayFiltered1 count];
                
                isFromAppGallery = NO;
            }
            else
            {
                NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];
                NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
                if ([arrayFiltered count] > 0)
                {
                    imagePickerController.maximumNumberOfSelection = 20;
                }
                else
                {
                    NSPredicate *predicateImages1 = [NSPredicate predicateWithFormat:@"imageOriginIndex >= %d",0];
                    NSArray *arrayFiltered1 = [arrayOfImages filteredArrayUsingPredicate:predicateImages1];
                    imagePickerController.maximumNumberOfSelection = remainingCount+arrayFiltered1.count;
                }
            }
        }
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
    
}

-(void)callToSelectImagesFromCameraWithRemainingCount:(int)remainingCount andFromEditScreen:(BOOL)isFromEditScreen
{
    
    
    
    if(remainingCount>0)
    {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            [picker setAllowsEditing:NO];
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{}];
        }
        else
        {
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Camera Not Available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]
             show];
            return;
        }
    }
    
}


- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    [self dismissImagePickerControllerForCancel:NO];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    [self.multipleImagePicker.Originalimages removeAllObjects];// caught here
    
    
    assetsArray = [NSArray arrayWithArray:assets];
    
    
    for(ALAsset *asset in assets)
    {
        @autoreleasepool {
        UIImage *img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"ddHHmmssSSS"];
        
        NSString *dateString=[formatter stringFromDate:[NSDate date]];
        
        NSString *imgName =[NSString stringWithFormat:@"%@_asset",dateString];
        
        [self saveImage:img :imgName];
        
        [self.multipleImagePicker addOriginalImages:imgName];
        };
    }
    
    NSPredicate *predicateServerImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];// from server
    NSArray *arrayServerFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateServerImages];
    
    NSPredicate *predicateCameraImages = [NSPredicate predicateWithFormat:@"isImageFromCamera == %d",YES];// from server
    NSArray *arrayCameraFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateCameraImages];
    
    NSArray *finalFilteredArray = [arrayServerFiltered arrayByAddingObjectsFromArray:arrayCameraFiltered];
    
    if ([finalFilteredArray count] > 0)
    {
        [arrayOfImages removeAllObjects];
        arrayOfImages = [NSMutableArray arrayWithArray:finalFilteredArray];
    }
    else
    {
        [arrayOfImages removeAllObjects]; // check here.
    }
    
    [collectionViewImages reloadData];
    
    
    // Done callback
    self.multipleImagePicker.doneCallback = ^(NSArray *images)
    {
        
        for(int i=0;i< images.count;i++)
        {
            
            
            SMPhotosListNSObject *imageObject = [[SMPhotosListNSObject alloc]init];
            
            imageObject.strimageName=[images objectAtIndex:i];
            imageObject.isImageFromLocal = YES;
            imageObject.imageOriginIndex = i;
            imageObject.imagePriorityIndex=imgCount;
            
            imageObject.imageLink = [self loadImagePath:[images objectAtIndex:i]];
            //imageObject.imageLink = fullPathOftheImage;
            imageObject.isImageFromCamera = NO;
            
            [arrayOfImages addObject:imageObject];
            
            selectedImage = nil;
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [collectionViewImages reloadData];
            [self.multipleImagePicker.Originalimages removeAllObjects];
            //[self.multipleImagePicker.ThumbnailImages removeAllObjects];
            
        });
        
    };
    
    [self dismissImagePickerControllerForCancel:NO];
    
    
}
///////////// monami tap on cancel image removed from gallery
- (void)imagePickerControllerDidCancelled:(QBImagePickerController *)imagePickerController
{
     [SMGlobalClass sharedInstance].isTapOnCancel = YES;
    
//    if(arrayOfImages.count>0)
//    {
//        NSPredicate *predicateServerImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];// from server
//        NSArray *arrayServerFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateServerImages];
//
//        NSPredicate *predicateCameraImages = [NSPredicate predicateWithFormat:@"isImageFromCamera == %d",YES];// from server
//        NSArray *arrayCameraFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateCameraImages];
//
//        NSArray *finalFilteredArray = [arrayServerFiltered arrayByAddingObjectsFromArray:arrayCameraFiltered];
//
//        if ([finalFilteredArray count] > 0)
//        {
//            [arrayOfImages removeAllObjects];
//            arrayOfImages = [NSMutableArray arrayWithArray:finalFilteredArray];
//        }
//        else
//        {
//            [arrayOfImages removeAllObjects]; // check here.
//        }
//
//        [collectionViewImages reloadData];
//
//    }
    [collectionViewImages reloadData];
    [self dismissImagePickerControllerForCancel:YES];
    
    for (UINavigationController *view in self.navigationController.viewControllers)
    {
        
        if ([view isKindOfClass:[RPMultipleImagePickerViewController class]])
        {
            [self.navigationController popViewControllerAnimated:NO];
            
        }
    }
    
}
- (void)dismissImagePickerControllerForCancel:(BOOL)cancelled
{
    if (self.presentedViewController)
    {
        
        [self dismissViewControllerAnimated:YES completion:
         ^{
             if(!cancelled)
             {
                 
                 RPMultipleImagePickerViewController *selectType;
                 BOOL isViewControllerPresent = NO;
                 for (UINavigationController *view in self.navigationController.viewControllers)
                 {
                     //when found, do the same thing to find the MasterViewController under the nav controller
                     if ([view isKindOfClass:[RPMultipleImagePickerViewController class]])
                     {
                         isViewControllerPresent = YES;
                         selectType = (RPMultipleImagePickerViewController*)view;
                         self.multipleImagePicker = (RPMultipleImagePickerViewController*)view;
                         [self.navigationController popToViewController:selectType animated:YES];
                         
                     }
                 }
                 
                 if(!isViewControllerPresent)
                 {
                     self.multipleImagePicker.isFromStockAuditScreen = NO;
                     self.multipleImagePicker.isFromGridView = NO;
                     [self.navigationController pushViewController:self.multipleImagePicker animated:YES];
                 }
                 
             }
             
         }];
    }
    else
    {
        [self.navigationController popToViewController:self animated:YES];
    }
}

- (void)saveImage:(UIImage*)image :(NSString*)imageName
{
    if (documentsDirectory == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
    }
    imageData = UIImageJPEGRepresentation(image,0.6); //convert image into .jpg format.
    fullPathOftheImage = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageName]];
    
    
    [imageData writeToFile:fullPathOftheImage atomically:NO];
    imageData = nil;
}

- (UIImage*)loadImage:(NSString*)imageName1 {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    
    return [UIImage imageWithContentsOfFile:fullPathOfImage];
    
}

- (NSString*)loadImagePath:(NSString*)imageName1 {
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    
    return [NSString stringWithFormat:@"%@.jpg",fullPathOfImage];
    
}

-(void)delegateFunctionWithOriginIndex:(int)originIndex
{
    if(![SMGlobalClass sharedInstance].isFromCamera)
        [imagePickerController deleteTheImageFromTheFirstLibraryWithIndex:originIndex];
    
}

-(void)dismissTheLoader
{
    [imagePickerController dismissTheLoaderAction];
    
    
}



-(void)delegateFunction:(UIImage*)imageToBeDeleted
{
    [imagePickerController deleteTheImageFromTheFirstLibrary:imageToBeDeleted];
}

-(void)delegateFunctionForDeselectingTheSelectedPhotos
{
    [imagePickerController deSelectAllTheSelectedPhotosWhenCancelAction];
    
}



#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSInteger i = buttonIndex;
    
    if (actionSheet==actionSheetPhotos)
    {
        if (i==0)
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                self.multipleImagePicker.isFromApp = YES;
                picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                [picker setAllowsEditing:NO];
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:^{}];
            }
            else
            {
                
                SMAlert(@"Error", KCameraNotAvailable);
                
            }
        }
        else if(i==1)
        {
            int RemainingCount;
            
            NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];
            NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
            if ([arrayFiltered count] > 0)
            {
                NSPredicate *predicateLocalImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d AND isImageFromCamera == %d",YES,NO];// from server
                NSArray *arrayLocalFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateLocalImages];
                
                NSPredicate *predicateCameraImages = [NSPredicate predicateWithFormat:@"isImageFromCamera == %d",YES];// from server
                NSArray *arrayCameraFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateCameraImages];
                
                NSArray *finalFilteredArray = [arrayLocalFiltered arrayByAddingObjectsFromArray:arrayCameraFiltered];
                
                if(finalFilteredArray.count == 0)
                    RemainingCount = 0;
                else
                    RemainingCount = (int)finalFilteredArray.count;
            }
            else
                RemainingCount = (int)arrayOfImages.count;
            
            [SMGlobalClass sharedInstance].isFromCamera = NO;
            
            isFromAppGallery = YES;
            [self callTheMultiplePhotoSelectionLibraryWithRemainingCount:20 - RemainingCount andFromEditScreen:NO];
            
            
        }
        
    }
    
}

- (void)registerNib
{
   // [collectionViewImages registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMSellCollectionCell" : @"SMSellCollectionCell_iPad" bundle:nil]            forCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier"];
    
    
    [collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImagePV"];
    
    [collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImagePV"];
    
    
}


- (IBAction)btnSaveDetailsDidClicked:(id)sender
{
    [self.view endEditing:YES];
    
    if(!btnRepair.selected && !btnReplace.selected)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Please select an option above: Either - Repair or Replace" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    
    }
    else
    [self webserviceCallForSavingExteriorWithUserHash:[SMGlobalClass sharedInstance].hashValue ExteriorTypeID:self.selectedCarPartNumber isRelpace:[NSString stringWithFormat:@"%d",btnReplace.isSelected] isRepair:[NSString stringWithFormat:@"%d",btnRepair.isSelected] priceValue:[NSString stringWithFormat:@"%d",txtFieldPrice.text.intValue] comments:txtViewComments.text appraisalID:@"1" clientID:[SMGlobalClass sharedInstance].strClientID vinNum:@"123"];
    
}

-(void) webserviceCallForSavingExteriorWithUserHash:(NSString*) userHash ExteriorTypeID:(NSString*) exteriorTypeID isRelpace:(NSString*) isReplace isRepair:(NSString*) isRepair priceValue:(NSString*) priceValue comments:(NSString*) comments appraisalID:(NSString*) appraisalID clientID:(NSString*) clientID vinNum:(NSString*) vinNum
{
     NSURLSession *dataTaskSession ;
    [HUD show:YES];
     HUD.labelText = KLoaderText;
    NSMutableURLRequest * requestURL = [SMWebServices saveExteriorReconditioning:userHash
                                                               andExteriorTypeID:exteriorTypeID andIsRepair:isReplace andIsReplace:isRepair andPriceValue:priceValue andComments:comments andAppraisalID:appraisalID andClientID:clientID andVIN:vinNum];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error!=nil)
        {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                dispatch_async(dispatch_get_main_queue(), ^{
                    SMAlert(@"Error", error.localizedDescription);
                    [self hideProgressHUD];
                    return;
                });
            });
            
        }
        else
        {
            
            xmlParser = [[NSXMLParser alloc] initWithData:data];
            isSaveExteriorWSResponse = YES;
            [xmlParser setDelegate:self];
            [xmlParser setShouldResolveExternalEntities:YES];
            [xmlParser parse];
        }
    }];
    
    [uploadTask resume];
    
}


-(void) webserviceCallForSavingExteriorImages:(NSMutableArray*) arrayOfImagesObject
{
    NSURLSession *dataTaskSession ;
    //[HUD show:YES];
   // HUD.labelText = KLoaderText;
    
      NSMutableURLRequest * requestURL = [SMWebServices saveExteriorImages:[SMGlobalClass sharedInstance].hashValue andImagesArray:arrayOfImagesObject andAppraisalID:@"1" andClientID:[SMGlobalClass sharedInstance].strClientID andVinNum:@"123" andExteriorVaueID:self.selectedCarPartNumber];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            if (error!=nil)
                                            {
                                                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                    // Do something...
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        SMAlert(@"Error", error.localizedDescription);
                                                        [self hideProgressHUD];
                                                        return;
                                                    });
                                                });
                                                
                                            }
                                            else
                                            {
                                                
                                                xmlParser = [[NSXMLParser alloc] initWithData:data];
                                                isSaveExteriorWSResponse = NO;
                                                [xmlParser setDelegate:self];
                                                [xmlParser setShouldResolveExternalEntities:YES];
                                                [xmlParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
}

#pragma mark - NSXMLParser Delegate Methods

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    
    if ([elementName isEqualToString:@"Item"])
    {
        NSLog(@"Item received");
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
     if ([elementName isEqualToString:@"PassOrFailed"] && isSaveExteriorWSResponse)
    {
        if([currentNodeContent isEqualToString:@"true"])
        {
            
            NSMutableArray *arrmImageDetailObjects = [[NSMutableArray alloc] init] ;
            
            for(int i = 0;i<[arrayOfImages count];i++)
            {
                SMPhotosListNSObject *imageObj = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:i];
                
                    UIImage *imageToUpload = [self loadImage:[NSString stringWithFormat:@"%@.jpg",imageObj.strimageName]];
                    
                    NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
                    
                    base64Str = [imageDataForUpload base64EncodedStringWithOptions:0];
                    
                    // 2 for Vehicle
                    NSDictionary *dictImageDetailObj = [NSDictionary dictionaryWithObjectsAndKeys:base64Str,@"ExteriorImage", nil];
                    
                    [arrmImageDetailObjects addObject:dictImageDetailObj];
                
            }
            
            [self webserviceCallForSavingExteriorImages:arrmImageDetailObjects];
            
           /* UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:[NSString stringWithFormat:@"%@ saved successfully.",self.selectedCarArea] preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* okButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                            [self.navigationController popViewControllerAnimated:YES];
                                        }];
            
            [alertController addAction:okButton];
            [self presentViewController:alertController animated:YES completion:nil];*/
        }
        
    }
    else if([elementName isEqualToString:@"PassOrFailed"] && !isSaveExteriorWSResponse)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do stuff to UI
            [HUD hide:YES];
        });

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:[NSString stringWithFormat:@"%@ saved successfully.",self.selectedCarArea] preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
        
        [alertController addAction:okButton];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}
#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.color = [UIColor blackColor];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}
-(void) hideProgressHUD
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
        });
    });
}


@end
