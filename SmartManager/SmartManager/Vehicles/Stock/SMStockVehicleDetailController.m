


//
//  SMStockVehicleDetailController.m
//  SmartManager
//
//  Created by Liji Stephen on 01/07/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMStockVehicleDetailController.h"
#import "SMSellCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "SMCustomDynamicCell.h"
#import "UIBAlertView.h"
#import "SMConstants.h"
#import "SMAppDelegate.h"
#import "SMCustomMoreInfoCell.h"
#import "SMSendInfoMultiSelectCell.h"
#import "SMCellOfPlusImageCommentPV.h"
#import "SMGlobalClass.h"
#import "HomeViewController.h"
#import "SMVideoInfoViewController.h"
#import "Reachability.h"
#import "UIBAlertView.h"
#import "SMClassOfUploadVideos.h"
#import "SMUrlConnection.h"

#define ACCEPTABLE_CHARACTERS      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ACCEPTABLE_CHARACTERS_TRIM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ACCEPTABLE_CHARACTERS_OEM  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ACCEPTABLE_CHARACTERS_Number @"0123456789"


@interface SMStockVehicleDetailController ()
{
    
    IBOutlet UICollectionView *collectionViewVideo;
    NSMutableArray *arrVideofromWebService;
    SMClassOfUploadVideos *videoListObject;
    NSMutableArray *arrayOfVideoID;
    BOOL ifUploadMobileData;
}
@end

@implementation SMStockVehicleDetailController

//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    if(arrayOfImages.count > 0 || arrayOfVideos > 0)
//    {
//    [self headerview];
//    }
//}
//
//-(void) headerview{
//    UIView *headerView = self.tblViewStockVehicleDetails.tableHeaderView;
//    
//    [headerView setNeedsLayout];
//    [headerView layoutIfNeeded];
//    
//   
//}
//

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    ifUploadMobileData = YES;
    NSLog(@"Diddddddddd%f",self.lblVariantName.frame.size.width);
    /////////////Monami UI Issue resolved by set frame ///////////
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.collectionViewImages.frame = CGRectMake(self.collectionViewImages.frame.origin.x, self.collectionViewImages.frame.origin.y, [[UIScreen mainScreen] bounds].size.width -15, self.collectionViewImages.frame.size.height);
    }
    ////////////////////////////End////////////////////////////
    [self registerNib];
    [self addingProgressHUD];
     canClientUploadVideos = NO;
    [self canUserUploadVideos];
  
    vehicleComments = @"None loaded";
    vehicleExtras = @"None loaded";
    vehicleType = @"None loaded";
    indexpathOfSelectedVideo = -1;
    currentPhotoCount = 0;
    shouldSectionBeExpanded = NO;
    shouldPersonalisedPhotoSectionBeExpanded = NO;
    shouldPersonalisedVideoSectionBeExpanded = NO;
    isSendPhotosChecked = NO;
    isSendVideosChecked = NO;
    strSpecDetails = @"";
    
    [self setTheTitleForScreen];
    //[self.view bringSubviewToFront:self.btnSend];
       // self.btnSend.backgroundColor = [UIColor greenColor];

    viewCollectionPhotosBk.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    viewCollectionPhotosBk.layer.borderWidth= 0.8f;
    
    viewCollectionVideoBk.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    viewCollectionVideoBk.layer.borderWidth= 0.8f;
       
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        self.lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        self.lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        self.lblVehicleDetails3.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    }
    else
    {
        self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        self.lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        self.lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        self.lblVehicleDetails3.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
    
    }
    
   // self.txtViewComment.font = [UIFont fontWithName:FONT_NAME size:20.0];
    
   
    arrayOfVideoID = [[NSMutableArray alloc]init];
    
    arrayOfImages = [[NSMutableArray alloc]init];
    arrayOfSliderImages = [[NSMutableArray alloc]init];
    arrayOfPhotos = [[NSMutableArray alloc]init];
    arrayOfVideos = [[NSMutableArray alloc]init];
    arrVideofromWebService = [[NSMutableArray alloc] init];
    
    self.multipleImagePicker = [[RPMultipleImagePickerViewController alloc] init];
    self.multipleImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.multipleImagePicker.photoSelectionDelegate = self;
    [SMGlobalClass sharedInstance].totalImageSelected  = 0;
    [SMGlobalClass sharedInstance].isFromCamera = NO;
    
    
    if(!_isFromVariantList)
    {
        if(self.selectedVehicleDropdownValue == 1 || self.selectedVehicleDropdownValue == 4)
        {
            [self setAttributedTextForVehicleNameWithFirstText:@"" andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:self.lblVehicleName];
        }
        else
        {
            [self setAttributedTextForVehicleNameWithFirstText:self.photosExtrasObject.strUsedYear andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:self.lblVehicleName];
        }
        
        [self.lblVehicleName sizeToFit];
        
        [self loadVehicleDetailsFromServer];
        
    }
    else
    {
        [self webserviceCallForVariantImagesNVideos];
        
    }
      
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    
    NSPredicate *predicateLocalImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];// from server
    NSArray *arrayLocalFiltered = [arrayOfPhotos filteredArrayUsingPredicate:predicateLocalImages];
    
    {
        
        if(arrayLocalFiltered.count == 0)
            [SMGlobalClass sharedInstance].totalImageSelected = 0;
        else
            [SMGlobalClass sharedInstance].totalImageSelected = arrayOfPhotos.count;
        
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                   withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)textViewDidChange:(UITextView *)textView
{
  SMCustomMoreInfoCell *cell = (SMCustomMoreInfoCell*)[self.tblViewStockVehicleDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    
  cell.lblTextViewCharRemaining.text =[NSString stringWithFormat:@"Character Remaining : %d",(int)(160 -textView.text.length) ];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
   
    if([text isEqualToString:@"\b"]){
        DLog(@"Ohoooo");
        return YES;
    }else if([[textView text] length] - range.length + text.length > 160){
        
        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    SMCustomMoreInfoCell *cell = (SMCustomMoreInfoCell*)[self.tblViewStockVehicleDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    
    
    if(textField == cell.txtFieldRecepientName)
        [cell.txtFieldRecepientSurname becomeFirstResponder];
    else if(textField == cell.txtFieldRecepientSurname)
        [cell.txtFieldRecepientMobile becomeFirstResponder];
    else if(textField == cell.txtFieldRecepientMobile)
        [cell.txtFieldEmailAddress becomeFirstResponder];
    else if(textField == cell.txtFieldEmailAddress)
        [cell.textViewComment becomeFirstResponder];
    return YES;
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 1001)
    {
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_Number] invertedSet];
    
    NSString       *filtered       = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    if(newLength>10)
    {
        return (newLength > 10) ? NO : YES;
    }
    else
    {
        return [string isEqualToString:filtered];
    }
    }
    return YES;
}


#pragma mark - LXReorderableCollectionViewDataSource methods
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
    
    if (collectionView==collectionViewPhotos)
    {
        
         SMPhotosListNSObject *imageObj = (SMPhotosListNSObject*)[arrayOfPhotos objectAtIndex:fromIndexPath.row];
        isPrioritiesImageChanged = YES;
        
        [arrayOfPhotos removeObjectAtIndex:fromIndexPath.row];
        [arrayOfPhotos insertObject:imageObj atIndex:toIndexPath.row];
    }
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView==collectionViewPhotos)
    {
        if(indexPath.row == 0)
        {
            return YES;
        }
        return YES;
    }
    else
    {
        return NO;
    }
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
    if (collectionView==collectionViewPhotos)
    {
        if(toIndexPath.row == 0)
        {
            return YES;
        }
        return YES;
    }
    else
    {
        return NO;
    }
    
}
#pragma mark - UITableView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == self.collectionViewImages)
    return arrayOfSliderImages.count;
    else if(collectionView == collectionViewPhotos)
        return arrayOfPhotos.count;
    else if(collectionView == collectionViewVideo || collectionView == collectinViewVideosWithNoImages)
    {
        return arrVideofromWebService.count;
        

        
    }
    else
        return arrayOfVideos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.collectionViewImages)
    {
        SMSellCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier" forIndexPath:indexPath];
    
        [cell.imageVehicle   setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        SMPhotosListNSObject *photosObject = (SMPhotosListNSObject*)[arrayOfSliderImages objectAtIndex:indexPath.item];
        
        cell.imageVehicle.contentMode = UIViewContentModeScaleAspectFill;
        
        [cell.imageVehicle setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photosObject.imageLink]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        
        return cell;
    }
    else if (collectionView==collectionViewPhotos) // this is the personalized photos section
    {
        SMCellOfPlusImageCommentPV *cellImages;
        
        {
            cellImages =
            [collectionView dequeueReusableCellWithReuseIdentifier:@"SMCellOfActualImagePV" forIndexPath:indexPath];
            
            [cellImages.btnDelete addTarget:self action:@selector(btnDeleteImageDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            cellImages.btnDelete.tag = indexPath.row;
            
            SMPhotosListNSObject *imageObj = (SMPhotosListNSObject*)[arrayOfPhotos objectAtIndex:indexPath.row];//was crashing here.....
            
            
            if(imageObj.isImageFromLocal)
            {
                
                if(![imageObj.strimageName isEqualToString:@""])
                {
                    NSString *str = [NSString stringWithFormat:@"%@.jpg",imageObj.strimageName];
                    
                    NSString *fullImgName=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
                    cellImages.imgActualImage.contentMode = UIViewContentModeScaleAspectFill;
                    cellImages.imgActualImage.image = [UIImage imageWithContentsOfFile:fullImgName];
                    
                }
                
            }
            else
            {
                cellImages.imgActualImage.contentMode = UIViewContentModeScaleAspectFill;
                
                [cellImages.imgActualImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageObj.imageLink]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
            }
            
            //isPrioritiesImageChanged = YES;
        }
        cellImages.imgActualImage.contentMode = UIViewContentModeScaleAspectFill;
        return cellImages;
    }
    else if (collectionView==collectionViewVideo || collectionView == collectinViewVideosWithNoImages)
    {
        __weak SMCellOfPlusImageCommentPV *cellVideos = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMCellOfActualVideoPV" forIndexPath:indexPath];
        
        SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrVideofromWebService objectAtIndex:indexPath.row];
        
        //[cellVideos.btnDelete addTarget:self action:@selector(btnDeleteVideosWebServiceDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        cellVideos.btnDelete.hidden = YES;
        
        cellVideos.btnDelete.tag = indexPath.row;
        
        if (videoObj.isVideoFromLocal==NO) // from server
        {
            cellVideos.webVYouTube.backgroundColor=[UIColor clearColor];
            cellVideos.webVYouTube.hidden=YES;
            
            
            [cellVideos.imgActualImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",videoObj.youTubeID]] placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
                cellVideos.imgActualImage.image = image;
                NSLog(@"IMAGEEE = %@",image);
            } failure:^(NSError *error) {
                NSLog(@"Error image = %@",[error localizedDescription]);
            }];
            
        }
        else
        {
            
            cellVideos.imgActualImage.image=videoObj.thumnailImage;
            cellVideos.imgViewPlayVideo.hidden=NO;
        }
        
        cellVideos.imgViewPlayVideo.hidden=NO;
        return cellVideos;
    }
    
    else if (collectionView==collectionViewVideos) // personalized videos
    {
       __weak SMCellOfPlusImageCommentPV *cellVideos;
        
        {
            
            cellVideos = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMCellOfActualVideoPV" forIndexPath:indexPath];
            
            SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:indexPath.row];
            
            [cellVideos.btnDelete addTarget:self action:@selector(btnDeleteVideosDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            cellVideos.btnDelete.tag = indexPath.row;
            
            if (videoObj.isVideoFromLocal==NO) // from server
            {
                cellVideos.webVYouTube.backgroundColor=[UIColor clearColor];
                cellVideos.webVYouTube.hidden=YES;
                [cellVideos.imgActualImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",videoObj.youTubeID]] placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
                    cellVideos.imgActualImage.image = image;
                    NSLog(@"IMAGEEE = %@",image);
                } failure:^(NSError *error) {
                    NSLog(@"Error image = %@",[error localizedDescription]);
                }];
            }
            else
            {
                
                cellVideos.imgActualImage.image=videoObj.thumnailImage;
                cellVideos.imgViewPlayVideo.hidden=NO;
            }
            
            cellVideos.imgViewPlayVideo.hidden=NO;
            //[cellVideos.contentView bringSubviewToFront:cellVideos.imgViewPlayVideo];
        }
        return cellVideos;
        
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(78, 78);
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
    if (collectionView==self.collectionViewImages)
    {
        
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        networkGallery.startingIndex = indexPath.row+1;
        SMAppDelegate *appdelegate1 = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate1.isPresented =  YES;
        [self.navigationController pushViewController:networkGallery animated:YES];
    }
    else if (collectionView == collectionViewVideo)
    {
        SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrVideofromWebService objectAtIndex:indexPath.row];
    if(videoObj.isVideoFromLocal == NO)
    {
        
        SMVideoInfoViewController *videoInfoVC = [[SMVideoInfoViewController alloc] initWithNibName:@"SMVideoInfoViewController" bundle:nil];
        
        {
            imageVieww = [[UIImageView alloc]init];
            [imageVieww setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",videoObj.youTubeID]] placeholderImage:nil options:nil success:^(UIImage *image, BOOL cached) {
                videoObj.thumnailImage = image;
            } failure:^(NSError *error) {
                NSLog(@"failure reason = %@",[error localizedDescription]);
            }];
            //[SMGlobalClass sharedInstance].imageThumbnailForVideo = imageVieww.image;
            // videoObj.thumnailImage = [SMGlobalClass sharedInstance].imageThumbnailForVideo;
        }
        /*else
         {
         videoObj.thumnailImage = [SMGlobalClass sharedInstance].imageThumbnailForVideo;
         }*/
        
        videoInfoVC.videoObject = videoObj;
        videoInfoVC.isVideoFromServer = YES;
        videoInfoVC.isFromCameraView = NO;
        videoInfoVC.vehicleName = [NSString stringWithFormat:@"%@-%@",self.lblVehicleName.text,self.photosExtrasObject.strStockCode];
        [self.navigationController pushViewController:videoInfoVC animated:YES];
    }
    else
    {
        SMVideoInfoViewController *videoInfoVC = [[SMVideoInfoViewController alloc] initWithNibName:@"SMVideoInfoViewController" bundle:nil];
        videoInfoVC.videoObject = videoObj;
        indexpathOfSelectedVideo = (int)indexPath.row;
        videoInfoVC.isVideoFromServer = NO;
        videoInfoVC.videoPathURL = videoObj.localYouTubeURL;
        videoInfoVC.indexpathOfSelectedVideo = indexpathOfSelectedVideo;
        videoInfoVC.isFromPhotosNExtrasDetailPage = NO;
        videoInfoVC.isFromSendBrochureDetailPage = YES;
        videoInfoVC.isFromListPage = NO;
        videoInfoVC.vehicleName = [NSString stringWithFormat:@"%@-%@",self.lblVehicleName.text,self.photosExtrasObject.strStockCode];
        [self.navigationController pushViewController:videoInfoVC animated:YES];
    }
    
    }
    else if (collectionView == collectionViewVideos)
    {
        
        SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:indexPath.row];
        if(videoObj.isVideoFromLocal == NO)
        {
            [SMGlobalClass sharedInstance].imageThumbnailForVideo = videoObj.thumnailImage;
            
            SMVideoInfoViewController *videoInfoVC = [[SMVideoInfoViewController alloc] initWithNibName:@"SMVideoInfoViewController" bundle:nil];
            
            // NSLog(@"imageVieww.image = %@");
            if(imageVieww == nil)
            {
                imageVieww = [[UIImageView alloc]init];
                [imageVieww setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",videoObj.youTubeID]]];
                
                [SMGlobalClass sharedInstance].imageThumbnailForVideo = imageVieww.image;
                videoObj.thumnailImage = [SMGlobalClass sharedInstance].imageThumbnailForVideo;
            }
            else
            {
                videoObj.thumnailImage = [SMGlobalClass sharedInstance].imageThumbnailForVideo;
            }
            
            videoInfoVC.videoObject = videoObj;
            videoInfoVC.isVideoFromServer = YES;
            videoInfoVC.isFromCameraView = NO;
            [self.navigationController pushViewController:videoInfoVC animated:YES];
        }
        else
        {
            SMVideoInfoViewController *videoInfoVC = [[SMVideoInfoViewController alloc] initWithNibName:@"SMVideoInfoViewController" bundle:nil];
            videoInfoVC.videoObject = videoObj;
            indexpathOfSelectedVideo = (int)indexPath.row;
            videoInfoVC.isVideoFromServer = NO;
            videoInfoVC.videoPathURL = videoObj.localYouTubeURL;
            videoInfoVC.indexpathOfSelectedVideo = indexpathOfSelectedVideo;
            videoInfoVC.isFromPhotosNExtrasDetailPage = NO;
            videoInfoVC.isFromSendBrochureDetailPage = YES;
             videoInfoVC.isFromListPage = NO;
             videoInfoVC.vehicleName = [NSString stringWithFormat:@"%@-%@",self.lblVehicleName.text,self.photosExtrasObject.strStockCode];
            [self.navigationController pushViewController:videoInfoVC animated:YES];
        }
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


#pragma mark - UITableViewDataSource

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section)
    {
        case 1://0
        {
            if(arrayOfImages.count >0 && arrVideofromWebService.count>0)
                return 2;
            else if(arrayOfImages.count == 0 && arrVideofromWebService.count == 0)
                return 0;
            else
                return 1;
            
        }
        break;
        case 2:
        {
            if(shouldPersonalisedPhotoSectionBeExpanded)
            {
                return 1;
            }
            return 0;
        }
        break;
        case 3:
        {
            if(shouldPersonalisedVideoSectionBeExpanded)
            {
                return 1;
            }
            return 0;
        }
        break;
        case 0:
        {
           // if(!self.isFromVariantList)
            //{
                if(shouldSectionBeExpanded)
                {
                    return 6;
                }
           // }
           // return 0;
        }
        break;
        case 4:
        {
            return 1;
        }
            
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMCustomDynamicCell     *dynamicCell;
    
    static NSString *cellIdentifier3= @"SMCustomDynamicCell";
    static NSString *cellIdentifier4= @"SMCustomMoreInfoCell";
    static NSString *cellIdentifier5= @"SMSendInfoMultiSelectCell";
    
    
    if(indexPath.section == 1)
    {
        SMSendInfoMultiSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier5 forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blackColor];
        
        if(arrayOfImages.count > 0 && arrVideofromWebService.count>0)
        {
            
            if(indexPath.row == 0)
                cell.lblSendVideosPhots.text = @"Send Vehicle Photos";
            else
                cell.lblSendVideosPhots.text = @"Send Vehicle Videos";
            
            cell.btnCheckBox.tag = indexPath.row;
            [cell.btnCheckBox addTarget:self action:@selector(btnCheckBoxDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return cell;
        }
        else if(arrayOfImages.count > 0 && arrVideofromWebService.count == 0)
        {
            if(indexPath.row == 0)
                cell.lblSendVideosPhots.text = @"Send Vehicle Photos";
            
            cell.btnCheckBox.tag = indexPath.row;
            [cell.btnCheckBox addTarget:self action:@selector(btnCheckBoxDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return cell;
        }
        else if(arrayOfImages.count == 0 && arrVideofromWebService.count > 0)
        {
            if(indexPath.row == 0)
                cell.lblSendVideosPhots.text = @"Send Vehicle Videos";
            
            cell.btnCheckBox.tag = indexPath.row;
            [cell.btnCheckBox addTarget:self action:@selector(btnCheckBoxDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    }
    else if(indexPath.section == 2 )
    {
        static NSString *cellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        else
        {
            for (UIView *viw in cell.contentView.subviews)
            {
                [viw removeFromSuperview];
            }
        }
        ////////////////////Monami UI Issue resolved when tap on plus button for Image
        cell.backgroundColor = [UIColor clearColor];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            viewPhotos.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 120);
        }
        //////////////// End///////////////////////////
        [cell.contentView addSubview:viewPhotos];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else if(indexPath.section == 3 )
    {
        static NSString *cellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        else
        {
            for (UIView *viw in cell.contentView.subviews)
            {
                [viw removeFromSuperview];
            }
        }
        ////////////////////Monami UI Issue resolved when tap on plus button for Image
        cell.backgroundColor = [UIColor clearColor];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            viewCollectionVideoBk.frame = CGRectMake(5, 0, [[UIScreen mainScreen] bounds].size.width-10, 140);
            viewVideos.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width-10, 140);
        }
        //////////////// End///////////////////////////
        [cell.contentView addSubview:viewVideos];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if(indexPath.section == 0)
    {
        
        UILabel *lblTitle;
        UILabel *lblValue;
        CGFloat height = 0.0f;
        
        if (dynamicCell == nil)
        {
            dynamicCell = [[SMCustomDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
            
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(8,1,84,21)];
                lblValue = [[UILabel alloc] initWithFrame:CGRectMake(110,1,210,height)];
                lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblValue.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
                
            }
            else
            {
                lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(8,3,200,30)];
                lblValue = [[UILabel alloc] initWithFrame:CGRectMake(150,3,500,height)];
                lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblValue.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
            }
            
            lblTitle.tag = 1001;
            [dynamicCell.contentView addSubview:lblTitle];
            
            lblValue.tag = 1002;
            [dynamicCell.contentView addSubview:lblValue];
            
            
        }
        else
        {
            lblTitle = (UILabel *)[dynamicCell.contentView viewWithTag:1001];
            lblValue = (UILabel *)[dynamicCell.contentView viewWithTag:1002];
            
        }
        lblTitle.textColor = [UIColor whiteColor];
        
        lblValue.textColor = [UIColor whiteColor];
        dynamicCell.backgroundColor = [UIColor clearColor];
        
        switch (indexPath.row)
        {
            case 2:
            {
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    lblTitle.frame = CGRectMake(8,1,84,21);
                    lblValue.frame = CGRectMake(8,25,290,height);
                }
                else
                {
                    lblTitle.frame = CGRectMake(8,2,100,25);
                    lblValue.frame = CGRectMake(8,25,680,height);
                }
                if([strSpecDetails length]> 0)
                    lblTitle.text = @"Specs";
                else
                    lblTitle.text = @"";
                    
                lblValue.text = strSpecDetails;
                
                lblValue.numberOfLines = 0;
                [lblValue sizeToFit];
                return dynamicCell;

            }
                break;
            case 0:
            {
               
                lblTitle.text = @"Comments:";
                if([vehicleComments length]!= 0)
                {
                    //lblValue.text = @"this is to test the multiline functionality";
                    lblValue.text = vehicleComments;
                }
                else
                    lblValue.text = @"None loaded";
                
                lblValue.numberOfLines = 0;
                [lblValue sizeToFit];
                return dynamicCell;

                
            }
                break;
            case 1:
            {
              
                lblTitle.text = @"Extras:";
                if([vehicleExtras length]!= 0)
                    lblValue.text = vehicleExtras;
                else
                    lblValue.text = @"None loaded";
                
                lblValue.numberOfLines = 0;
                [lblValue sizeToFit];
                return dynamicCell;
                
            }
            break;
            case 3:
            {
               
                 lblTitle.text = @"";
                 lblValue.text = @"";
                return dynamicCell;
                
            }
            break;
            case 4:
            {
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
                    lblValue.font = [UIFont fontWithName:FONT_NAME size:12.0];
                    lblTitle.frame = CGRectMake(8,1,100,21);
                    lblValue.frame = CGRectMake(110,4,210,height);
                }
                else
                {
                    lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:17.0];
                    lblValue.font = [UIFont fontWithName:FONT_NAME size:17.0];
                    lblTitle.frame = CGRectMake(8,1,140,25);
                    lblValue.frame = CGRectMake(150,1,600,height);
                }
                
                if([strInternalNote length] > 0)
                {
                    lblTitle.text = @"Internal Memo:";
                    lblValue.text = strInternalNote;
                }
                else
                {
                    lblTitle.text = @"";
                    lblValue.text = @"";
                }
                
                lblValue.numberOfLines = 0;
                [lblValue sizeToFit];
                return dynamicCell;
                
            }
            break;
            case 5:
            {
                lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
                lblTitle.frame = CGRectMake(0,1,self.view.frame.size.width,1);
                lblTitle.backgroundColor = [UIColor whiteColor];
                return dynamicCell;
                
            }
                break;
                
            default:
                break;
        }
        
    }
    else if(indexPath.section == 4 )
    {
        SMCustomMoreInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier4 forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blackColor];
        cell.textViewComment.delegate = self;
        cell.txtFieldRecepientName.delegate = self;
        cell.txtFieldRecepientSurname.delegate = self;
        cell.txtFieldEmailAddress.delegate = self;
        [cell.btnSendInfo addTarget:self action:@selector(btnSendDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.txtFieldRecepientMobile.delegate = self;
        cell.txtFieldRecepientMobile.tag = 1001;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (CGFloat)heightForText:(NSString *)bodyText withWidth:(float)textWidth
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
        textSize = textWidth;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
        textSize = textWidth;
    }
    CGSize constraintSize = CGSizeMake(textSize, MAXFLOAT);
    CGRect textRect = [bodyText boundingRectWithSize:constraintSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:cellFont}
                                             context:nil];
    
    CGSize labelSize = textRect.size;
    CGFloat height = labelSize.height;
    
    return height;
}

- (CGFloat)heightForTextForInternalNote:(NSString *)bodyText withWidth:(float)textWidth
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:12];
        textSize = textWidth;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:17];
        textSize = textWidth;
    }
    CGSize constraintSize = CGSizeMake(textSize, MAXFLOAT);
    CGRect textRect = [bodyText boundingRectWithSize:constraintSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:cellFont}
                                             context:nil];
    
    CGSize labelSize = textRect.size;
    CGFloat height = labelSize.height;
    
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tblViewStockVehicleDetails)
    {
        
        switch (indexPath.section)
        {
            case 1:
            {
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    return 37.0;
                }
                else
                {
                    return 60.0;
                }
            }
            break;
            case 2:
            {
                if(shouldPersonalisedPhotoSectionBeExpanded)
                 return 117.0;
                else
                    return 0.0;
            }
            break;
            case 3:
            {
                if(shouldPersonalisedVideoSectionBeExpanded)
                    return 144.0;
                else
                    return 0.0;
            }
            break;
            case 0:
            {
                CGFloat height = 0.0f;
                
                switch (indexPath.row)
                {
                    case 2:
                    {
                        if([strSpecDetails length] > 0)
                        {
                            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                            {
                                height = [self heightForText:strSpecDetails withWidth:290];
                                return height+30;
                            }
                            else{
                                height = [self heightForText:strSpecDetails withWidth:650];
                                return height+30;
                            }
                        }
                        return 0;
                        
                    }
                    break;
                    case 0:
                    {
                        
                        if([vehicleComments length]== 0)
                            vehicleComments = @"None loaded";
                        
                        //if([strSpecDetails length] > 0)
                        {
                            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                            {
                                height = [self heightForText:vehicleComments withWidth:210];
                                return height+10;
                            }
                            else{
                                height = [self heightForText:vehicleComments withWidth:650];
                                return height+10;
                            }
                        }
                       
                    }
                    break;
                    case 1:
                    {
                        
                        if([vehicleExtras length]== 0)
                            vehicleExtras = @"None loaded";
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                        {
                            height = [self heightForText:vehicleExtras withWidth:210];
                            return height+10;
                        }
                        else
                        {
                            height = [self heightForText:vehicleExtras withWidth:650];
                            return height+10;
                        }
                       
                    }
                    break;
                    case 3:
                    {
                        return 0;
                        /*height = [self heightForText:@"Cheverolet Utility vehicle/s in stock: 9" withWidth:270];
                        return height+10;*/
                    }
                        break;
                    case 4:
                    {
                        if([strInternalNote length] >0)
                        {
                            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                            {
                                height = [self heightForTextForInternalNote:strInternalNote withWidth:210];
                                return height+10;
                            }
                            else
                            {
                                height = [self heightForTextForInternalNote:strInternalNote withWidth:650];
                                return height+10;
                            }
                            
                        }
                        return 0;
                    }
                        break;
                    case 5:
                    {
                        return 5;
                    }
                        break;
                    default:
                        break;
                }
                
            }
            break;
            case 4:
            {
                return 324.0;
            }
            break;
            default:
                break;
        }
        
}
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 1://0
           return 0.0;
            break;
        case 2://1
        {
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                return 40.0f;
            }
            else
            {
                return 45.0f;
            }
        }
            break;
        case 3://2
        {
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                return 40.0f;
            }
            else
            {
                return 45.0;
            }
        }
            break;
        case 0://3
        {
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                return 40.0f;
               
            }
            else
            {
                return 50.0f;
            }
        }
        break;
        case 4://4
            return 0.0;
            break;
            
        default:
            break;
    }
    return 0.0;
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSLog(@"sectionn = %ld",(long)section);
    
    switch (section)
    {
        case 1://0
            return nil;
            break;
        case 2://1
        {
                
                UIView *headerView = [[UIView alloc] init];
                UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
                
                
               UIImageView *imageViewCheckBox = [[UIImageView alloc]init];
                
                imageViewCheckBox.contentMode = UIViewContentModeScaleAspectFit;
                
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
                    sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,40);
                    sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
                    [imageViewCheckBox setFrame:CGRectMake(tableView.bounds.size.width-29,5,25,25)];
                }
                else
                {
                    [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 45)];
                    sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,45);
                    sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
                    [imageViewCheckBox setFrame:CGRectMake(tableView.bounds.size.width-293,13,30,30)];
                    
                }
                
                if(shouldPersonalisedPhotoSectionBeExpanded)
                {
                    imageViewCheckBox.image = [UIImage imageNamed:@"check_box"];
                }
                else
                {
                    imageViewCheckBox.image = [UIImage imageNamed:@"uncheck_box"];
                }
            
                headerView.backgroundColor = [UIColor blackColor];
            
                [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                [sectionLabelBtn addTarget:self action:@selector(btnPersonalisedSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                [sectionLabelBtn setTag:section];// set the tag for each section
                sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                
                [sectionLabelBtn setTitle:@"Send Personalised Photo/s" forState:UIControlStateNormal];
                //[sectionLabelBtn.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:12.0]];
                
                [headerView addSubview:sectionLabelBtn];
                [headerView addSubview:imageViewCheckBox];
                headerView.clipsToBounds = YES;
               headerView.backgroundColor = [UIColor blackColor];
                return headerView;
            
        }
            break;
        case 3://2
        {
            
            UIView *headerView = [[UIView alloc] init];
            UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
            
            
            UIImageView *imageViewCheckBox = [[UIImageView alloc]init];
            
            imageViewCheckBox.contentMode = UIViewContentModeScaleAspectFit;
            
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
                sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,40);
                sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
                [imageViewCheckBox setFrame:CGRectMake(tableView.bounds.size.width-29,5,25,25)];
            }
            else
            {
                [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 45)];
                sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,45);
                sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
                [imageViewCheckBox setFrame:CGRectMake(tableView.bounds.size.width-293,13,30,30)];
            }
            
            if(shouldPersonalisedVideoSectionBeExpanded)
            {
                imageViewCheckBox.image = [UIImage imageNamed:@"check_box"];
            }
            else
            {
                imageViewCheckBox.image = [UIImage imageNamed:@"uncheck_box"];
            }
            
            headerView.backgroundColor = [UIColor blackColor];
            
            [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [sectionLabelBtn addTarget:self action:@selector(btnPersonalisedSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [sectionLabelBtn setTag:section];// set the tag for each section
            sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [sectionLabelBtn setTitle:@"Send Personalised Video/s" forState:UIControlStateNormal];
            //[sectionLabelBtn.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:12.0]];
            
            [headerView addSubview:sectionLabelBtn];
            [headerView addSubview:imageViewCheckBox];
            headerView.clipsToBounds = YES;
            headerView.backgroundColor = [UIColor blackColor];
            return headerView;
            
        }
            break;
        case 0://3
        {
            {
            UIView *headerView = [[UIView alloc] init];
            UIView *headerColorView = [[UIView alloc] init];
            UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
            
            
            imageViewArrowForsection = [[UIImageView alloc]init];
            
            imageViewArrowForsection.contentMode = UIViewContentModeScaleAspectFit;
            
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                [headerView setFrame:CGRectMake(7, 0, tableView.bounds.size.width-14.0, 30)];
                [headerColorView setFrame:CGRectMake(7, 0, tableView.bounds.size.width-14.0, 30)];
                sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,30);
                sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0f];
                [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-40,5,20,20)];
            }
            else
            {
                [headerView setFrame:CGRectMake(5, 0, tableView.bounds.size.width+200, 40)];
                [headerColorView setFrame:CGRectMake(5, 0, tableView.bounds.size.width-10.0, 40)];
                sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width-10.0,40);
                sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:17.0f];
                [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-35,10,20,20)];
            }
            
            if(shouldSectionBeExpanded)
            {
                [UIView animateWithDuration:2 animations:^
                 {
                     if(section == 0)
                     {
                         
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                         
                     }
                     
                     
                 }
                                 completion:nil];
            }
            
            
            UIImage *image = [UIImage imageNamed:@"side_Arrow.png"];
            [imageViewArrowForsection setImage:image];
            
            
            [headerColorView addSubview:imageViewArrowForsection];
            
            headerView.backgroundColor = [UIColor clearColor];
            
            
            headerColorView.backgroundColor=[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
            
            [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [sectionLabelBtn addTarget:self action:@selector(btnSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [sectionLabelBtn setTag:section];// set the tag for each section
            sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [sectionLabelBtn setTitle:@"See More Info" forState:UIControlStateNormal];
            //[sectionLabelBtn.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:12.0]];
            headerColorView.layer.cornerRadius = 5.0;
            headerView.layer.cornerRadius = 5.0;

            [headerColorView addSubview:sectionLabelBtn];
            [headerView addSubview:headerColorView];
            headerView.clipsToBounds = YES;
            
            return headerView;
            }
        }
        break;
        case 4://4
            return nil;
            
        default:
            break;
    }
    
    return nil;
}

-(IBAction)btnSectionTitleDidClicked:(id)sender
{
   
    shouldSectionBeExpanded = !shouldSectionBeExpanded;
    
    [self.tblViewStockVehicleDetails reloadData];
}

-(IBAction)btnCheckBoxDidClicked:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.tblViewStockVehicleDetails];
    NSIndexPath *indexPath = [self.tblViewStockVehicleDetails indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    SMSendInfoMultiSelectCell* cell = (SMSendInfoMultiSelectCell *)[self.tblViewStockVehicleDetails cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:{
            if(arrayOfImages.count > 0)
            {
                //[cell.btnCheckBox setSelected:!cell.btnCheckBox.selected];
                
                UIImage *secondImage = [UIImage imageNamed:@"check_box"];
                
                NSData *imgData1 = UIImagePNGRepresentation(cell.imgViewCheckBox.image);
                NSData *imgData2 = UIImagePNGRepresentation(secondImage);
                
                BOOL isCompare =  [imgData1 isEqual:imgData2];
                if(isCompare)
                {
                    cell.imgViewCheckBox.image = [UIImage imageNamed:@"uncheck_box"];
                    isSendPhotosChecked = NO;
                }
                else
                {
                    cell.imgViewCheckBox.image = [UIImage imageNamed:@"check_box"];
                    isSendPhotosChecked = YES;
                }

            }
            else if(arrVideofromWebService.count > 0)
            {
                UIImage *secondImage = [UIImage imageNamed:@"check_box"];
                
                NSData *imgData1 = UIImagePNGRepresentation(cell.imgViewCheckBox.image);
                NSData *imgData2 = UIImagePNGRepresentation(secondImage);
                
                BOOL isCompare =  [imgData1 isEqual:imgData2];
                if(isCompare)
                {
                    cell.imgViewCheckBox.image = [UIImage imageNamed:@"uncheck_box"];
                    isSendVideosChecked = NO;// Dr. Ankit
                }
                else
                {
                    cell.imgViewCheckBox.image = [UIImage imageNamed:@"check_box"];
                    isSendVideosChecked = YES;// Dr. Ankit
                }
                
            }
        }
            break;
        case 1:{
            if(arrVideofromWebService.count > 0)
            {
                UIImage *secondImage = [UIImage imageNamed:@"check_box"];
                
                NSData *imgData1 = UIImagePNGRepresentation(cell.imgViewCheckBox.image);
                NSData *imgData2 = UIImagePNGRepresentation(secondImage);
                
                BOOL isCompare =  [imgData1 isEqual:imgData2];
                if(isCompare)
                {
                    cell.imgViewCheckBox.image = [UIImage imageNamed:@"uncheck_box"];
                    isSendVideosChecked = NO;
                }
                else
                {
                    cell.imgViewCheckBox.image = [UIImage imageNamed:@"check_box"];
                    isSendVideosChecked = YES;
                }


            }
        }
            break;
   
        default:
            break;
    }
    
}
-(IBAction)btnPersonalisedSectionTitleDidClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    
    if (button.tag ==  2)
    {
        shouldPersonalisedPhotoSectionBeExpanded = !shouldPersonalisedPhotoSectionBeExpanded;
    
        [self.tblViewStockVehicleDetails reloadData];
    }
    else
    {
        shouldPersonalisedVideoSectionBeExpanded = !shouldPersonalisedVideoSectionBeExpanded;
        
        [self.tblViewStockVehicleDetails reloadData];
    }
}


- (void)registerNib
{
    [self.collectionViewImages registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMSellCollectionCell" : @"SMSellCollectionCell_iPad" bundle:nil]            forCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier"];
    
    [self.tblViewStockVehicleDetails registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMCustomMoreInfoCell" : @"SMCustomMoreInfoCell~iPad" bundle:nil] forCellReuseIdentifier:@"SMCustomMoreInfoCell"];
    
    [self.tblViewStockVehicleDetails registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMSendInfoMultiSelectCell" : @"SMSendInfoMultiSelectCell~iPad" bundle:nil] forCellReuseIdentifier:@"SMSendInfoMultiSelectCell"];
    
    [collectionViewPhotos registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImagePV"];
    
    [collectionViewPhotos registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImagePV"];
    
    [collectionViewVideo registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusVideoPV"];
    
    [collectionViewVideo registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualVideoPV"];
    
    [collectinViewVideosWithNoImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusVideoPV"];
    
    [collectinViewVideosWithNoImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualVideoPV"];
    
    [collectionViewVideos registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusVideoPV"];
    
    [collectionViewVideos registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualVideoPV"];
}


-(void)setAttributedTextForVehicleDetailsWithFirstTextt:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
{
    
    UIFont *regularFont;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];

    }
    else
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];

    }

    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    UIColor *foregroundColorGreen = [UIColor greenColor];
    
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorGreen, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:firstText
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:secondText
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:thirdText
                                                                                            attributes:ThirdAttribute];
    
    
    
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
}

-(void)setAttributedTextForVehicleNameWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    NSMutableAttributedString *attributedSecondText;
    
    if(self.selectedVehicleDropdownValue == 1 || self.selectedVehicleDropdownValue == 4)
    {
        attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    }
    else
    {
        attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",secondText]
                                                                      attributes:SecondAttribute];
    }
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    [label setAttributedText:attributedFirstText];
    
    
}

#pragma mark - Set Attributed Text

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText forLabel:(UILabel*)label
{
    NSLog(@"price1 = %@",secondText);
    NSLog(@"price2 = %@",fourthText);
    
    UIFont *valueFont;
    UIFont *titleFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:9.0];
        
    }
    
    else
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    
    UIColor *foregroundColorGreen = [UIColor colorWithRed:64.0/255.0 green:198.0/255.0 blue:42.0/255.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FourthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorGreen, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ |",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ |",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    NSMutableAttributedString *attributedFourthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",fourthText]
                                                                                             attributes:FourthAttribute];
    
    
    
    [attributedThirdText appendAttributedString:attributedFourthText];
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

- (void)setTheTitleForScreen
{
    listActiveSpecialsNavigTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        listActiveSpecialsNavigTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0f];//SavingsBond
    }
    else
    {
        listActiveSpecialsNavigTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];//SavingsBond
    }
    listActiveSpecialsNavigTitle.backgroundColor = [UIColor clearColor];
    listActiveSpecialsNavigTitle.textColor = [UIColor whiteColor]; // change this color
    listActiveSpecialsNavigTitle.text = @"eBrochure";
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
}

- (IBAction)btnSendDidClicked:(id)sender
{
    
    [self.view endEditing:YES];
    appdelegate.isRefreshUI=YES;
    
    SMCustomMoreInfoCell *cell = (SMCustomMoreInfoCell*)[self.tblViewStockVehicleDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regExpred =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringCheck = [regExpred evaluateWithObject:cell.txtFieldEmailAddress.text];
    
    
    if([cell.txtFieldRecepientName.text length] == 0)
    {
        
        SMAlert(KLoaderTitle,@"Please enter name");
        return;
    }
    if(![self mobileNumberValidate:cell.txtFieldRecepientMobile.text])
    {
        SMAlert(KLoaderTitle,@"Please enter valid phone number");
        return;
    }

    if(!myStringCheck)
    {
        
        SMAlert(KLoaderTitle,@"Please enter valid email address");
        return;
    }
    
    if([cell.textViewComment.text length] == 0)
    {
        
        SMAlert(KLoaderTitle,@"Please add a comment");
        return;
    }
    
    
    if(arrayOfPhotos.count > 0)
    {
        [self beginTheTimerForUploadingBrochure];
    }
    else if (arrayOfVideos.count > 0)
    {
       
          NSLog(@"check111");
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus internetStatus = [reachability currentReachabilityStatus];
            if (internetStatus == kReachableViaWiFi)
            {
                NSLog(@"Uplading Videoss in WiFi");
                [self uploadingVideos];
            }
            else
            {
                float totalFileSizeMB = 0.0;
                
                for(int i =0;i<[arrayOfVideos count];i++)
                {
                    SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:i];
                    
                    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:videoObj.localYouTubeURL error:nil];
                    
                    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
                    long long fileSize = [fileSizeNumber longLongValue];
                    NSLog(@"File size: %lld",fileSize);
                    
                    float sizeMB = (float)fileSize/1000000;
                    totalFileSizeMB = totalFileSizeMB+sizeMB;
                    NSLog(@"Original = %f",sizeMB);
                }
                
                [self uploadingVideos];
                
               /* NSString *alertMessage = [NSString stringWithFormat:@"It is recommended that you connect to a WiFi network to upload video files of %d MB, to avoid excessive data use. Do you want to:",(int)totalFileSizeMB];
                
                UIAlertView *alertt=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:alertMessage delegate:self cancelButtonTitle:@"Upload with WiFi" otherButtonTitles:@"Upload Now", nil];
                
                if (ifUploadMobileData) {
                    [alertt show];
                }else{
                    [self loadVideoToDatabase];
                }*/
            }
        
    }
    else
    {
        [HUD show:YES];
        [HUD setLabelText:KLoaderText];
        
        arrayVideoDetails1 = nil;
        arrayVideoDetails2 = nil;
        [self sendTheBrochureWithoutImages];
    }
    
}


-(void)loadVehicleImagesFromServer
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    isImageWebserviceCallled = YES;
    
    NSMutableURLRequest *requestURL = [SMWebServices gettingListOfVehiclesImagesListForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             NSLog(@"***checkThis8");
             return;
             
             
         }
         else
         {
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)loadVehicleDetailsFromServer
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL = [SMWebServices gettingLoadVehiclesImagesListForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             NSLog(@"***checkThis9");
             return;
             
             
         }
         else
         {
             if(arrayOfImages.count > 0)
                 [arrayOfImages removeAllObjects];
             
             if(arrayOfSliderImages.count > 0)
                 [arrayOfSliderImages removeAllObjects];
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)beginTheTimerForUploadingBrochure
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
    NSMutableURLRequest *requestURL = [SMWebServices beginThePersonalizedImageList];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             NSLog(@"***checkThis10");
             return;
             
             
         }
         else
         {
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)endTheTimerForUploadingBrochure
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
    NSMutableURLRequest *requestURL = [SMWebServices endThePersonalizedImageListWithToken:strPhotosToken];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             NSLog(@"***checkThis11");
             return;
             
             
         }
         else
         {
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)sendTheBrochureWithImages
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
     SMCustomMoreInfoCell *cell = (SMCustomMoreInfoCell*)[self.tblViewStockVehicleDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    
    NSMutableURLRequest *requestURL;
    
    if(!self.isFromVariantList)
    {
        requestURL = [SMWebServices sendBrochureWithImagesAndIsSendPhotos:isSendPhotosChecked andIsSendVideos:isSendVideosChecked withUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockId:[self.photosExtrasObject.strUsedVehicleStockID intValue] andClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVideoDetails1:arrayVideoDetails1 withVideoDetails2:arrayVideoDetails2 WithEmail:cell.txtFieldEmailAddress.text WithFirstName:cell.txtFieldRecepientName.text WithMobile:cell.txtFieldRecepientMobile.text WithLastName:cell.txtFieldRecepientSurname.text withComments:cell.textViewComment.text withImageToken:strPhotosToken andIsVariant:NO];
    }
    else
    {
        requestURL = [SMWebServices sendBrochureWithImagesAndIsSendPhotos:isSendPhotosChecked andIsSendVideos:isSendVideosChecked withUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockId:[self.objVariantSelected.strMakeId intValue] andClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVideoDetails1:arrayVideoDetails1 withVideoDetails2:arrayVideoDetails2 WithEmail:cell.txtFieldEmailAddress.text WithFirstName:cell.txtFieldRecepientName.text WithMobile:cell.txtFieldRecepientMobile.text WithLastName:cell.txtFieldRecepientSurname.text withComments:cell.textViewComment.text withImageToken:strPhotosToken andIsVariant:YES];
    }
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             NSLog(@"***checkThis12");
             return;
             
             
         }
         else
         {
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)sendTheBrochureWithoutImages
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    SMCustomMoreInfoCell *cell = (SMCustomMoreInfoCell*)[self.tblViewStockVehicleDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    
    NSMutableURLRequest *requestURL;
    
    if(!self.isFromVariantList)
    {
        requestURL = [SMWebServices sendBrochureWithoutImagesAndIsSendPhotos:isSendPhotosChecked andIsSendVideos:isSendVideosChecked withUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockId:[self.photosExtrasObject.strUsedVehicleStockID intValue] andClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVideoDetails1:arrayVideoDetails1 withVideoDetails2:arrayVideoDetails2 WithEmail:cell.txtFieldEmailAddress.text WithFirstName:cell.txtFieldRecepientName.text WithMobile:cell.txtFieldRecepientMobile.text WithLastName:cell.txtFieldRecepientSurname.text withComments:cell.textViewComment.text andIsVariant:NO];
    }
    else
    {
        requestURL = [SMWebServices sendBrochureWithoutImagesAndIsSendPhotos:isSendPhotosChecked andIsSendVideos:isSendVideosChecked withUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockId:[self.objVariantSelected.strMakeId intValue] andClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVideoDetails1:arrayVideoDetails1 withVideoDetails2:arrayVideoDetails2 WithEmail:cell.txtFieldEmailAddress.text WithFirstName:cell.txtFieldRecepientName.text WithMobile:cell.txtFieldRecepientMobile.text WithLastName:cell.txtFieldRecepientSurname.text withComments:cell.textViewComment.text andIsVariant:YES];
    }
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             NSLog(@"***checkThis13");
             return;
             
         }
         else
         {
             xmlParser = [[SMParserForUrlConnection alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}


-(void)sendTheBrochureInfoToServer
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    isImageWebserviceCallled = YES;
    
    SMCustomMoreInfoCell *cell = (SMCustomMoreInfoCell*)[self.tblViewStockVehicleDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    
  NSMutableURLRequest *requestURL = [SMWebServices sendTheBrochureWithUserHash:[SMGlobalClass sharedInstance].hashValue andStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue] andEmailToAddress:cell.txtFieldEmailAddress.text andComment:cell.textViewComment.text];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             NSLog(@"***checkThis14");
             return;
             
             
         }
         else
         {
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}




#pragma mark - xmlParserDelegate
-(void) parser:(SMParserForUrlConnection *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentNodeContent = [NSMutableString stringWithString:@""];
    
    if ([elementName isEqualToString:@"image"])
    {
        photosListObject=[[SMPhotosListNSObject alloc]init];
    }
    if ([elementName isEqualToString:@"imageLink"] && self.isFromVariantList)
    {
         photosListObject=[[SMPhotosListNSObject alloc]init];
    }
    if ([elementName isEqualToString:@"Details"])
    {
        isImageWebserviceCallled = NO;
    }
    
    if ([elementName isEqualToString:@"video"])
    {
        videoListObject=[[SMClassOfUploadVideos alloc]init];
    }
    
    if( [elementName isEqualToString:@"SpecDetails"])
    {
        //arrayOfSpecs = [[NSMutableArray alloc]init];
        dictSpecDetails = [[NSMutableDictionary alloc]init];
    }
    if( [elementName isEqualToString:@"spec"])
    {
        
        strSpecDetails = [attributeDict valueForKey:@"name"];
        
       // [dictSpecDetails setObject:@"" forKey:[attributeDict valueForKey:@"name"]];
       
    }

}

-(void)parser:(SMParserForUrlConnection *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(SMParserForUrlConnection *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if( [elementName isEqualToString:@"spec"])
    {
        
       // dictSpecDetails = [[NSMutableDictionary alloc]init];
        [dictSpecDetails setObject:currentNodeContent forKey:strSpecDetails];
       
        
        //[arrayOfSpecs addObject:dictSpecDetails];
        
    }
    
    
    if( [elementName isEqualToString:@"SpecDetails"])
    {
        
         NSLog(@"dictSpecDetails = %@",dictSpecDetails);
        strSpecDetails=@"";
        
        
        NSString *str = [dictSpecDetails objectForKey:@"Engine CC"];
        if (str == nil) {
            
        }
        else{
        str = [str substringToIndex:5];
        strSpecDetails = [strSpecDetails stringByAppendingFormat:@"%@ cc; ",str];
        }
        
        str = [dictSpecDetails objectForKey:@"Power KW"];
        if (str == nil) {
            
        }
        else{
           strSpecDetails = [strSpecDetails stringByAppendingFormat:@"%@; ",str];
        }
        
        str = [dictSpecDetails objectForKey:@"Torque NM"];
        if (str == nil) {
            
        }
        else
        {
            strSpecDetails = [strSpecDetails stringByAppendingFormat:@"%@; ",str];
        }
        str = [dictSpecDetails objectForKey:@"Accel 0-100"];
        if (str == nil) {
            
        }
        else
        {
            strSpecDetails = [strSpecDetails stringByAppendingFormat:@"0-100kph in %@; ",str];
        }
        str = [dictSpecDetails objectForKey:@"Max Speed"];
        if (str == nil) {
            
        }
        else
        {
           strSpecDetails = [strSpecDetails stringByAppendingFormat:@"Top Speed %@; ",str];
        }
        str = [dictSpecDetails objectForKey:@"Gearbox"];
        if (str == nil) {
            
        }
        else
        {
            strSpecDetails = [strSpecDetails stringByAppendingFormat:@"%@; ",str];
        }
        str = [dictSpecDetails objectForKey:@"Gears"];
        if (str == nil) {
            
        }
        else
        {
             strSpecDetails = [strSpecDetails stringByAppendingFormat:@"%@; ",str];
        }
        str = [dictSpecDetails objectForKey:@"Fuel Type"];
        if (str == nil) {
            
        }
        else
        {
            strSpecDetails = [strSpecDetails stringByAppendingFormat:@"%@; ",str];
        }
        str = [dictSpecDetails objectForKey:@"Fuel per 100km - average"];
        if (str == nil) {
            
        }
        else
        {
           strSpecDetails = [strSpecDetails stringByAppendingFormat:@"Cons. %@/100Km; ",str];
        }
        str = [dictSpecDetails objectForKey:@"Warranty (RSA)"];
        if (str == nil) {
            
        }
        else
        {
            strSpecDetails = [strSpecDetails stringByAppendingFormat:@"Warranty %@ ",str];
        }
        str = [dictSpecDetails objectForKey:@"Warranty Period (RSA)"];
        if (str == nil) {
            
        }
        else
        {
             strSpecDetails = [strSpecDetails stringByAppendingFormat:@"/%@; ",str];
        }
        
        str = [dictSpecDetails objectForKey:@"Maintenance Plan"];
        if (str == nil) {
            
        }
        else
        {
            strSpecDetails = [strSpecDetails stringByAppendingFormat:@"Maintenance Plan %@",str];
        }
        str = [dictSpecDetails objectForKey:@"Maintenance Plan Period"];
        if (str == nil) {
            
        }
        else
        {
            strSpecDetails = [strSpecDetails stringByAppendingFormat:@"/%@. ",str];
        }
        
        NSLog(@"strSpecDetails = %@",strSpecDetails);
        
    }
    if( [elementName isEqualToString:@"internalnote"])
    {
        if([currentNodeContent length] == 0)
            strInternalNote = @"";
        else
            strInternalNote = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"CanUploadVideoResult"])
    {
        canClientUploadVideos = [currentNodeContent boolValue];
        NSLog(@"canClientUploadVideos = %d",canClientUploadVideos);
    }
    
    if ([elementName isEqualToString:@"LoadVehicleDetailsXMLResponse"])
    {
        if ([currentNodeContent isEqualToString:@"No Images"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"No images found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag=101;
            
            [alert show];
            
        }
    }
    if ([elementName isEqualToString:@"BeginPersonalizedImageListResult"])
    {
        strPhotosToken = currentNodeContent;
        
        if(self.isFromVariantList)
            [self uploadingImagesIsVariant:YES];
        else
            [self uploadingImagesIsVariant:NO];
        
    }
    if ([elementName isEqualToString:@"EndPersonalizedImageListResult"])
    {
         if(arrayOfVideos.count > 0)
        {
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus internetStatus = [reachability currentReachabilityStatus];
            
            if (internetStatus == kReachableViaWiFi)
            {
                NSLog(@"Uplading Videoss in WiFi");
                [self uploadingVideos];
            }
            else
            {
                float totalFileSizeMB = 0.0;
                
                for(int i =0;i<[arrayOfVideos count];i++)
                {
                    SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:i];
                    
                    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:videoObj.localYouTubeURL error:nil];
                    
                    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
                    long long fileSize = [fileSizeNumber longLongValue];
                    NSLog(@"File size: %lld",fileSize);
                    
                    float sizeMB = (float)fileSize/1000000;
                    totalFileSizeMB = totalFileSizeMB+sizeMB;
                    NSLog(@"Original = %f",sizeMB);
                }
                
                   [self uploadingVideos];
                
                
               /* NSString *alertMessage = [NSString stringWithFormat:@"It is recommended that you connect to a WiFi network to upload video files of %d MB, to avoid excessive data use. Do you want to:",(int)totalFileSizeMB];
                
                UIAlertView *alertt=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:alertMessage delegate:self cancelButtonTitle:@"Upload with WiFi" otherButtonTitles:@"Upload Now", nil];
                
                alertt.tag=701;
                
                if (ifUploadMobileData) {
                    [alertt show];
                }else{
                    [self loadVideoToDatabase];
                }*/
            }
        }
        else
        {
            arrayVideoDetails1 = nil;
            arrayVideoDetails2 = nil;
            NSLog(@"isThis1???");
            [self sendTheBrochureWithImages];
        }
        
        
    }
    if ([elementName isEqualToString:@"UploadPersonalizedImageAsPngResult"])
    {
        NSLog(@"uploadResult = %@",currentNodeContent);
        NSLog(@"currentPhotoCount = %d",currentPhotoCount);
        currentPhotoCount = currentPhotoCount + 1;
          if(currentPhotoCount == arrayOfPhotos.count)
          {
              // call the EndTracking webservice.
              
               NSLog(@"entered hereee");
              
              [self endTheTimerForUploadingBrochure];
          }
        
    }
    if ([elementName isEqualToString:@"UploadNewPersonalizedImageAsPngResult"])
    {
        NSLog(@"uploadResult = %@",currentNodeContent);
        NSLog(@"currentPhotoCount = %d",currentPhotoCount);
        currentPhotoCount = currentPhotoCount + 1;
        if(currentPhotoCount == arrayOfPhotos.count)
        {
            // call the EndTracking webservice.
            
            NSLog(@"entered hereee");
            
            [self endTheTimerForUploadingBrochure];
        }
        
    }
    if ([elementName isEqualToString:@"uciID"])
    {
        photosListObject.uciID=[currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"imageID"])
    {
        photosListObject.imageID=[currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"imagePriority"])
    {
        photosListObject.imagePriority=[currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"imageTypeName"])
    {
        photosListObject.imageTypeName=currentNodeContent;
    }
    else if ([elementName isEqualToString:@"imagePath"])
    {
        photosListObject.imagePath=currentNodeContent;
    }
    else if ([elementName isEqualToString:@"imageLink"] && self.isFromVariantList)
    {
        photosListObject.imageLink = currentNodeContent;
        
            photosListObject.isImageFromLocal=NO;
            photosListObject.imageOriginIndex = -1;
            
            [arrayOfImages addObject:photosListObject];
            [arrayOfSliderImages addObject:photosListObject];
            photosListObject=nil;
        
    }
    else if ([elementName isEqualToString:@"imageLink"] && !self.isFromVariantList)
    {
        {
            photosListObject.imageLink=currentNodeContent;
            
            NSString *fullImageString = photosListObject.imageLink;
            
            fullImageString = [fullImageString stringByReplacingOccurrencesOfString:@"width=340"
                                                                         withString:@"width=800"];
            
            photosListObject.imageLink = fullImageString;
        }
    }
    else if ([elementName isEqualToString:@"imageSize"])
    {
        photosListObject.imageSize=currentNodeContent;
    }
    else if ([elementName isEqualToString:@"imageRes"])
    {
        photosListObject.imageRes=currentNodeContent;
    }
    else if ([elementName isEqualToString:@"imageType"])
    {
        photosListObject.imageType=[currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"imageDPI"])
    {
        photosListObject.ImageDPI=[currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"comments"])
    {
       vehicleComments=currentNodeContent;
    }
    else if ([elementName isEqualToString:@"extras"])
    {
        vehicleExtras=currentNodeContent;
        
    }
    else if ([elementName isEqualToString:@"department"])
    {
        vehicleType=currentNodeContent;
    }
    if ([elementName isEqualToString:@"image"])
    {
        {
            photosListObject.isImageFromLocal=NO;
            photosListObject.imageOriginIndex = -1;
            
            [arrayOfImages addObject:photosListObject];
            [arrayOfSliderImages addObject:photosListObject];
            photosListObject=nil;
        }
    }
    
    // video elelements
    
    if ([elementName isEqualToString:@"title"])
    {
        videoListObject.videoTitle = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Keywords"])
    {
        videoListObject.videoTags = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"description"])
    {
        videoListObject.videoDescription = currentNodeContent ;
    }
    else if ([elementName isEqualToString:@"youtubeID"])
    {
        videoListObject.youTubeID = currentNodeContent ;
    }
    else if ([elementName isEqualToString:@"VideoLinkID"])
    {
        videoListObject.videoLinkID = [currentNodeContent intValue] ;
    }
    else if ([elementName isEqualToString:@"videoURL"])
    {
        videoListObject.localYouTubeURL = currentNodeContent ;
    }
    else if ([elementName isEqualToString:@"Searchable"])
    {
        videoListObject.isSearchable = currentNodeContent.boolValue ;
    }
   else if ([elementName isEqualToString:@"video"])
    {
        videoListObject.isVideoFromLocal=NO;
        NSLog(@"youTubeID = %@",videoListObject.youTubeID);
        [arrVideofromWebService addObject:videoListObject];
        videoListObject=nil;
    }
    else if ([elementName isEqualToString:@"VariantDetailsXMLResult"])
    {
        NSLog(@"arrayOfImages counttt = %lu",(unsigned long)arrayOfImages.count);
        
        if (arrayOfSliderImages.count>0)
        {
            [arrayOfSliderImages removeObjectAtIndex:0];
        }
        if(arrayOfImages.count > 0)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self setAttributedTextForVehicleNameWithFirstText:@"" andWithSecondText:self.objVariantSelected.strMakeName forLabel:self.lblVehicleName];
                
                [self.lblVehicleName sizeToFit];
                
                
                if([self.objVariantSelected.strPrice isEqualToString:@"R0"])
                    self.objVariantSelected.strPrice = @"R?";
                [self setAttributedTextForVehicleDetailsWithFirstText:@"New" andWithSecondText:self.objVariantSelected.strMeanCodeNumber andWithThirdText:@"Ret." andWithFourthText:self.objVariantSelected.strPrice forLabel:self.lblVehicleDetails1];
                [self.lblVehicleDetails1 sizeToFit];
                
                self.lblVehicleDetails2.text = @"";
                self.lblVehicleDetails3.text = @"";
                
                self.lblVehicleDetails1.frame = CGRectMake(self.lblVehicleDetails1.frame.origin.x, self.lblVehicleName.frame.origin.y + self.lblVehicleName.frame.size.height, self.lblVehicleDetails1.frame.size.width, self.lblVehicleDetails1.frame.size.height);
                
                int lineCount = [self lineCountForLabel:self.lblVehicleDetails1];
                
                self.lblVehicleDetails2.frame = CGRectMake(self.lblVehicleDetails2.frame.origin.x, self.lblVehicleDetails1.frame.origin.y + self.lblVehicleDetails1.frame.size.height+1.0, self.lblVehicleDetails2.frame.size.width, self.lblVehicleDetails2.frame.size.height);
                
                self.lblVehicleDetails3.frame = CGRectMake(self.lblVehicleDetails3.frame.origin.x, self.lblVehicleDetails2.frame.origin.y + self.lblVehicleDetails2.frame.size.height+1.0, self.lblVehicleDetails3.frame.size.width, self.lblVehicleDetails3.frame.size.height);
                
                if(lineCount == 1)
                {
                    self.viewCollectionContainer.frame = CGRectMake(self.viewCollectionContainer.frame.origin.x, self.imageVehicle.frame.origin.y + self.imageVehicle.frame.size.height+3.0, self.viewCollectionContainer.frame.size.width, self.viewCollectionContainer.frame.size.height);
                }
                else
                {
                    if(self.isFromVariantList)
                    {
                        self.viewCollectionContainer.frame = CGRectMake(self.viewCollectionContainer.frame.origin.x, self.imageVehicle.frame.origin.y + self.imageVehicle.frame.size.height+3.0, self.viewCollectionContainer.frame.size.width, self.viewCollectionContainer.frame.size.height);
                    }
                    else
                    {
                        self.viewCollectionContainer.frame = CGRectMake(self.viewCollectionContainer.frame.origin.x, self.lblVehicleDetails3.frame.origin.y + self.lblVehicleDetails3.frame.size.height+1.0, self.viewCollectionContainer.frame.size.width, self.viewCollectionContainer.frame.size.height);
                    }
                    
                    collectionViewVideo.frame = CGRectMake(collectionViewVideo.frame.origin.x,self.viewCollectionContainer.frame.origin.y + self.viewCollectionContainer.frame.size.height+7.0, collectionViewVideo.frame.size.width, collectionViewVideo.frame.size.height);
                }

                
                CGRect headerFrame;
                if(arrayOfVideos.count>0 && arrayOfImages.count > 1)
                {
                    collectionViewVideo.hidden = NO;
                    collectionViewVideo.frame = CGRectMake(collectionViewVideo.frame.origin.x,self.viewCollectionContainer.frame.origin.y + self.viewCollectionContainer.frame.size.height+7.0, collectionViewVideo.frame.size.width, collectionViewVideo.frame.size.height);
                    headerFrame = self.viewHeader.frame;
                    headerFrame.size.height = 225;
                    self.viewHeader.frame = headerFrame;
                    
                }
                else if(arrayOfVideos.count == 0 && arrayOfImages.count > 1)
                {
                    collectionViewVideo.hidden = YES;
                    headerFrame = self.viewHeader.frame;
                    headerFrame.size.height = 178;
                    self.viewHeader.frame = headerFrame;
                }
                else
                {
                    collectionViewVideo.hidden = YES;
                    headerFrame = self.viewHeader.frame;
                    headerFrame.size.height = 106;
                    self.viewHeader.frame = headerFrame;
                }

                NSLog(@"Header 3333 %@",self.viewHeader);
                self.tblViewStockVehicleDetails.tableHeaderView = self.viewHeader;
                [self.tblViewStockVehicleDetails reloadData];
                [self.collectionViewImages reloadData];
                [self hideProgressHUD];
            });
        }
        else
        {
            [self setAttributedTextForVehicleNameWithFirstText:@"" andWithSecondText:self.objVariantSelected.strMakeName forLabel:self.lblVariantName];
            [self.lblVariantName sizeToFit];
            if([self.objVariantSelected.strPrice isEqualToString:@"R0"])
                self.objVariantSelected.strPrice = @"R?";
            [self setAttributedTextForVehicleDetailsWithFirstText:@"New" andWithSecondText:self.objVariantSelected.strMeanCodeNumber andWithThirdText:@"Ret." andWithFourthText:self.objVariantSelected.strPrice forLabel:self.lblVariantDetails];
            [self.lblVariantDetails sizeToFit];
            NSLog(@"NameHeight = %f",self.lblVariantName.frame.size.height);
            self.lblVariantDetails.frame = CGRectMake(self.lblVariantDetails.frame.origin.x, self.lblVariantName.frame.origin.y + self.lblVariantName.frame.size.height+4.0, self.lblVariantDetails.frame.size.width, self.lblVariantDetails.frame.size.height);
            CGRect frame = self.viewHeaderVariant.frame;
            if(self.lblVariantName.frame.size.height > 33.0)
                frame.size.height = 80;
            else
                frame.size.height = 60;
            self.viewHeaderVariant.frame = frame;
            NSLog(@"Header 4444 %@",self.viewHeader);
            self.tblViewStockVehicleDetails.tableHeaderView = self.viewHeaderVariant;
        
        }
    }
    else if ([elementName isEqualToString:@"LoadVehicleDetailsXMLResult"])
    {
        NSLog(@"arrayOfImages counttt = %lu",(unsigned long)arrayOfImages.count);
        
        if (arrayOfSliderImages.count>0)
        {
            [arrayOfSliderImages removeObjectAtIndex:0];
        }
        if(arrayOfImages.count > 0)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
               
                if(self.selectedVehicleDropdownValue == 1 || self.selectedVehicleDropdownValue == 4)
                {
                    [self setAttributedTextForVehicleNameWithFirstText:@"" andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:self.lblVehicleName];
                    
                    [self.lblVehicleName sizeToFit];
                    
                    NSString *mileage = [NSString stringWithFormat:@"%@",self.photosExtrasObject.strMileage];
                    
                    self.lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@",mileage,self.photosExtrasObject.strStockCode];
                    [self.lblVehicleDetails1 sizeToFit];
                    
                    self.lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@",@"New",self.photosExtrasObject.strColour];
                    
                }
                else
                {
                    [self setAttributedTextForVehicleNameWithFirstText:self.photosExtrasObject.strUsedYear andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:self.lblVehicleName];
                    
                    [self.lblVehicleName sizeToFit];
    ///////////////////Monami set frame for iPad UI Issue//////////////////////
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                        self.lblVehicleName.frame = CGRectMake(self.lblVehicleName.frame.origin.x, self.lblVehicleName.frame.origin.y, [[UIScreen mainScreen] bounds].size.width-100, 30);
                    }
    ///////////////////////////////////////////////////////////////////////
                    NSLog(@"%f",self.lblVehicleName.frame.size.height);
                    NSString *mileage = [NSString stringWithFormat:@"%@",self.photosExtrasObject.strMileage];
                    
                    self.lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@",mileage,self.photosExtrasObject.strStockCode];
                    [self.lblVehicleDetails1 sizeToFit];
                    
                    self.lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@",self.photosExtrasObject.strRegistration,self.photosExtrasObject.strColour];
                    
                }
               
                [self setAttributedTextForVehicleDetailsWithFirstTextt:self.photosExtrasObject.strRetailPrice andWithSecondText:@" | " andWithThirdText:self.photosExtrasObject.strDays forLabel:self.lblVehicleDetails3];
                
                //self.lblVehicleName.textColor = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
                
                self.lblVehicleDetails1.textColor = [UIColor whiteColor];
                self.lblVehicleDetails2.textColor = [UIColor whiteColor];
                
                
                self.lblVehicleDetails1.frame = CGRectMake(self.lblVehicleDetails1.frame.origin.x, self.lblVehicleName.frame.origin.y + self.lblVehicleName.frame.size.height, [[UIScreen mainScreen] bounds].size.width-100, self.lblVehicleDetails1.frame.size.height);
                
                int lineCount = [self lineCountForLabel:self.lblVehicleDetails1];
                
                self.lblVehicleDetails2.frame = CGRectMake(self.lblVehicleDetails2.frame.origin.x, self.lblVehicleDetails1.frame.origin.y + self.lblVehicleDetails1.frame.size.height+1.0, [[UIScreen mainScreen] bounds].size.width-100, self.lblVehicleDetails2.frame.size.height);
                
                //////////Monami UI Issue lable text cut///////////
                    self.lblVehicleDetails3.frame = CGRectMake(self.lblVehicleDetails3.frame.origin.x, self.lblVehicleDetails2.frame.origin.y + self.lblVehicleDetails2.frame.size.height+1.0, [[UIScreen mainScreen] bounds].size.width-100, self.lblVehicleDetails3.frame.size.height);
                
                NSLog(@"LBL3 %@", self.lblVehicleDetails3.text);
                ///////////// End/////////////////
                if(lineCount == 1)
                {
                    /////////////Monami frame set for UI /////////
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    self.viewCollectionContainer.frame = CGRectMake(self.viewCollectionContainer.frame.origin.x, self.lblVehicleDetails3.frame.origin.y+self.lblVehicleDetails3.frame.size.height+10, self.viewCollectionContainer.frame.size.width, self.viewCollectionContainer.frame.size.height);
                        /////////// End /////////////////
                    }else{
                    self.viewCollectionContainer.frame = CGRectMake(self.viewCollectionContainer.frame.origin.x, self.imageVehicle.frame.origin.y + self.imageVehicle.frame.size.height+3.0, self.viewCollectionContainer.frame.size.width, self.viewCollectionContainer.frame.size.height);
                    }
                }
                else
                {
                    if(self.isFromVariantList)
                    {
                        /////////////Monami frame set for UI /////////
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                        self.viewCollectionContainer.frame = CGRectMake(self.viewCollectionContainer.frame.origin.x, self.lblVehicleDetails3.frame.origin.y + self.lblVehicleDetails3.frame.size.height+3.0, self.viewCollectionContainer.frame.size.width, self.viewCollectionContainer.frame.size.height);
                    //////////// End //////////////
                }else{
                self.viewCollectionContainer.frame = CGRectMake(self.viewCollectionContainer.frame.origin.x, self.imageVehicle.frame.origin.y+10 + self.imageVehicle.frame.size.height+3.0, self.viewCollectionContainer.frame.size.width, self.viewCollectionContainer.frame.size.height);
                }
                    }
                    else
                    {
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                      self.viewCollectionContainer.frame = CGRectMake(self.viewCollectionContainer.frame.origin.x, self.lblVehicleDetails3.frame.origin.y+10 + self.lblVehicleDetails3.frame.size.height+1.0, self.viewCollectionContainer.frame.size.width, self.viewCollectionContainer.frame.size.height);
                }else{
                self.viewCollectionContainer.frame = CGRectMake(self.viewCollectionContainer.frame.origin.x, self.lblVehicleDetails3.frame.origin.y + self.lblVehicleDetails3.frame.size.height+1.0, self.viewCollectionContainer.frame.size.width, self.viewCollectionContainer.frame.size.height);
                }
                    }
                    
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    collectionViewVideo.frame = CGRectMake(collectionViewVideo.frame.origin.x,self.viewCollectionContainer.frame.origin.y + self.viewCollectionContainer.frame.size.height+17.0, collectionViewVideo.frame.size.width, collectionViewVideo.frame.size.height);
                    }else{
                    collectionViewVideo.frame = CGRectMake(collectionViewVideo.frame.origin.x,self.viewCollectionContainer.frame.origin.y + self.viewCollectionContainer.frame.size.height+7.0, collectionViewVideo.frame.size.width, collectionViewVideo.frame.size.height);
                    }
                }
    ////////// Monami UI issue resolve ///////////////////////////////
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    CGRect newFrame = self.viewHeader.frame;
                    newFrame.size.height = newFrame.size.height + 20;
                    self.viewHeader.frame = newFrame;
                }
   ///////////////////////////// END///////////////////////////////////
                NSLog(@"Header 5555 %@",self.viewHeader);
                self.tblViewStockVehicleDetails.tableHeaderView = self.viewHeader;
                
                [self.collectionViewImages reloadData];
        });
        }
        else
        {
            
            if(self.selectedVehicleDropdownValue == 1 || self.selectedVehicleDropdownValue == 4)
            {
                [self setAttributedTextForVehicleNameWithFirstText:@"" andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:self.lblVehicleNameNoImages];
                
                [self.lblVehicleNameNoImages sizeToFit];
                
                self.lblVehicleDetails2NoImages.text = [NSString stringWithFormat:@"%@ | %@",@"New",self.photosExtrasObject.strColour];
                
            }
            else
            {
                [self setAttributedTextForVehicleNameWithFirstText:self.photosExtrasObject.strUsedYear andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:self.lblVehicleNameNoImages];
                
                [self.lblVehicleNameNoImages sizeToFit];
                
               self.lblVehicleDetails2NoImages.text = [NSString stringWithFormat:@"%@ | %@",self.photosExtrasObject.strRegistration,self.photosExtrasObject.strColour];
                
            }
            

            NSString *mileage = [NSString stringWithFormat:@"%@",self.photosExtrasObject.strMileage];
            
            self.lblVehicleDetails1NoImages.text = [NSString stringWithFormat:@"%@ | %@",mileage,self.photosExtrasObject.strStockCode];
            
            
            [self setAttributedTextForVehicleDetailsWithFirstTextt:self.photosExtrasObject.strRetailPrice andWithSecondText:@" | " andWithThirdText:self.photosExtrasObject.strDays forLabel:self.lblVehicleDetails3NoImages];
            
            
            self.lblVehicleDetails1NoImages.textColor = [UIColor whiteColor];
            self.lblVehicleDetails2NoImages.textColor = [UIColor whiteColor];
            
            self.lblVehicleDetails1NoImages.frame = CGRectMake(self.lblVehicleDetails1NoImages.frame.origin.x, self.lblVehicleNameNoImages.frame.origin.y + self.lblVehicleNameNoImages.frame.size.height+ 7.0, self.lblVehicleDetails1NoImages.frame.size.width, self.lblVehicleDetails1NoImages.frame.size.height);
            
            self.lblVehicleDetails2NoImages.frame = CGRectMake(self.lblVehicleDetails2NoImages.frame.origin.x, self.lblVehicleDetails1NoImages.frame.origin.y + self.lblVehicleDetails1NoImages.frame.size.height+ 7.0, self.lblVehicleDetails2NoImages.frame.size.width, self.lblVehicleDetails2NoImages.frame.size.height);
            
            self.lblVehicleDetails3NoImages.frame = CGRectMake(self.lblVehicleDetails3NoImages.frame.origin.x, self.lblVehicleDetails2NoImages.frame.origin.y + self.lblVehicleDetails2NoImages.frame.size.height+ 10.0, self.lblVehicleDetails3NoImages.frame.size.width, self.lblVehicleDetails3NoImages.frame.size.height);
            
           /*CGRect headerFrame;
            headerFrame = self.ViewHeaderNoImages.frame;
            int lineCount = [self lineCountForLabel:self.lblVehicleNameNoImages];
            if(lineCount == 1)
                headerFrame.size.height = 21 + 25 + 25 + 25;
            else
                headerFrame.size.height = 42 + 25 + 25 + 25;
            
            self.ViewHeaderNoImages.frame = headerFrame;
            
            self.tblViewStockVehicleDetails.tableHeaderView = self.ViewHeaderNoImages;*/

        }
        [self.tblViewStockVehicleDetails reloadData];
        [self hideProgressHUD];

    }
   
    
    if ([elementName isEqualToString:@"SendBrochureToAddressWithImagesResult"] || [elementName isEqualToString:@"SendNewBrochureToAddressWithImagesResult"])
    {
        if([currentNodeContent isEqualToString:@"true"])
        {
            BOOL isVideoUploaded = true;
            for (NSString *strVideo in arrayOfVideoID) {
                if ([strVideo containsString:@"<Error>"]) {
                    isVideoUploaded = false;
                    break;
                }
            }
            
            if (isVideoUploaded) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"Brochure sent successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag = 101;
                [alert show];
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"Brochure has been sent successfully but could not attach the video/s." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag = 101;
                [alert show];
            }
        }
        else
        {
            [HUD hide:YES];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"Error while sending brochure please try later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 101;
            [alert show];
            
        }
    
    }
    
    if( [elementName isEqualToString:@"s:Fault"])
    {
        [HUD hide:YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"Error while sending brochure please try later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 101;
        [alert show];

    }
    
    if ([elementName isEqualToString:@"SendBrochureToAddressWithoutImagesResult"] || [elementName isEqualToString:@"SendNewBrochureToAddressWithoutImagesResult"])
    {
        if([currentNodeContent isEqualToString:@"true"])
        {
           BOOL isVideoUploaded = true;
           for (NSString *strVideo in arrayOfVideoID) {
               if ([strVideo containsString:@"<Error>"]) {
                   isVideoUploaded = false;
                   break;
               }
            }
            
            if (isVideoUploaded) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"Brochure sent successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag = 101;
                [alert show];
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"Brochure has been sent successfully but could not attach the video/s." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag = 101;
                [alert show];
            }
        }
        else
        {
            [HUD hide:YES];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"Error while sending brochure please try later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             alert.tag = 101;
             [alert show];
            
        }
        
    }
    
}


- (void)parserDidEndDocument:(SMParserForUrlConnection *)parser
{
    if(!self.isFromVariantList)
    {
    if(arrayOfImages.count > 0)
    {
        [collectionViewVideo reloadData];
        
        if(arrayOfSliderImages.count == 0)
        {
            if(arrVideofromWebService.count == 0)
            {
                collectionViewVideo.frame = self.viewCollectionContainer.frame;
                collectionViewVideo.hidden = YES;
                collectionViewVideo.backgroundColor = [UIColor greenColor];
                self.viewCollectionContainer.hidden = YES;
                CGRect frame = self.viewHeader.frame;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    if (self.lblVehicleName.frame.size.height < 40.0f) {
                        frame.size = CGSizeMake(self.viewHeader.frame.size.width, 108.0);
                    }else{
                        frame.size = CGSizeMake(self.viewHeader.frame.size.width, 125.0);
                    }

                }
                else{
                    frame.size = CGSizeMake(self.viewHeader.frame.size.width, 120.0);
                }
                self.viewHeader.frame = frame;
            }
            else
            {
                collectionViewVideo.frame = self.viewCollectionContainer.frame;
                self.viewCollectionContainer.hidden = YES;
                CGRect frame = self.viewHeader.frame;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    if (self.lblVehicleName.frame.size.height < 40.0f) {
                        frame.size = CGSizeMake(self.viewHeader.frame.size.width, 180.0f);
                    }else{
                        frame.size = CGSizeMake(self.viewHeader.frame.size.width, 195.0f);
                    }
                    
                }
                else{
                    frame.size = CGSizeMake(self.viewHeader.frame.size.width, 195.0f);
                }
                self.viewHeader.frame = frame;
                
            }
        }
        else
        {
        
            if(arrVideofromWebService.count == 0)
            {
                
                CGRect frame = self.viewHeader.frame;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    if (self.lblVehicleName.frame.size.height < 40.0f) {
                        frame.size = CGSizeMake(self.viewHeader.frame.size.width, 180.0f);
                    }else{
                        frame.size = CGSizeMake(self.viewHeader.frame.size.width, 195.0f);
                    }
                    
                }
                else{
                    frame.size = CGSizeMake(self.viewHeader.frame.size.width, 195.0f);
                }
                self.viewHeader.frame = frame;
            }
            else
            {
                
                collectionViewVideo.frame = CGRectMake(collectionViewVideo.frame.origin.x,self.viewCollectionContainer.frame.origin.y + self.viewCollectionContainer.frame.size.height+7.0, collectionViewVideo.frame.size.width, collectionViewVideo.frame.size.height);
                
                CGRect frame = self.viewHeader.frame;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    if (self.lblVehicleName.frame.size.height < 40.0f) {
                        frame.size = CGSizeMake(self.viewHeader.frame.size.width, 255.0f);
                    }else{
                        frame.size = CGSizeMake(self.viewHeader.frame.size.width, 270.0f);
                    }
                   
                }
                else{
                    frame.size = CGSizeMake(self.viewHeader.frame.size.width, 265.0f);
                }
                self.viewHeader.frame = frame;
        
          }
        }
        
        
        
            SMPhotosListNSObject *photosObject1 = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:0];
          [self.imageVehicle setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photosObject1.imageLink]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        
        NSLog(@"Header 1111 %@",self.viewHeader);
        self.tblViewStockVehicleDetails.tableHeaderView = self.viewHeader;
    }
    else
    {
        [collectinViewVideosWithNoImages reloadData];
        CGFloat height;
        if(arrVideofromWebService.count==0)
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                height = 135.0f;
            }
            else{
                height = 155.0f;
            }
        }
        else
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                height = 215.0f;
            }
            else{
                height = 215.0f;
            }
        }
        CGRect frame = self.ViewHeaderNoImages.frame;
        frame.size.height = height;
        self.ViewHeaderNoImages.frame = frame;
        
        
        
        [self.imageVehicle setImageWithURL:[NSURL URLWithString:@""]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        //self.imageVehicle.contentMode = UIViewContentModeScaleAspectFit;
        NSLog(@"Header 2222 %@",self.viewHeader);
        self.tblViewStockVehicleDetails.tableHeaderView = self.ViewHeaderNoImages;
    }
    }
    else
    {
        if(arrayOfImages.count > 0)
        {
        SMPhotosListNSObject *photosObject1 = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:0];
        [self.imageVehicle setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photosObject1.imageLink]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        }
    }
    
}

-(NSString *) encodeString:(NSString *) encodeString
{
    encodeString = [NSString stringWithFormat:@"<![CDATA[%@]]>",encodeString]; // category method call
    return encodeString;
}

- (int)lineCountForLabel:(UILabel *)label {
    CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:UILineBreakModeWordWrap];
    
    return ceil(size.height / label.font.lineHeight);
}


#pragma mark - UIKeyboard Notification

- (void)keyboardWasShown:(NSNotification*)textFieldNotification
{
    CGSize kbSize = [[[textFieldNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[textFieldNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(50, 0, 280, 0);
        
        [self.tblViewStockVehicleDetails setContentInset:edgeInsets];
        [self.tblViewStockVehicleDetails setScrollIndicatorInsets:edgeInsets];
    }];

    
}

- (void)keyboardWasHidden:(NSNotification*)textFieldNotification
{
    NSTimeInterval duration = [[[textFieldNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [self.tblViewStockVehicleDetails setContentInset:edgeInsets];
        [self.tblViewStockVehicleDetails setScrollIndicatorInsets:edgeInsets];
    }];

    
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
            NSLog(@"***checkThis15");
        });
    });
}


-(IBAction)buttonImageClickableDidPressed:(id) sender
{
    if ([arrayOfImages count]>0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            networkGallery               = [[FGalleryViewController alloc] initWithPhotoSource:self];
            networkGallery.startingIndex = [sender tag];
            SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
            appdelegate.isPresented =  YES;

            [self.navigationController pushViewController:networkGallery animated:YES];
        });
    }


}

- (IBAction)btnSeeMoreInfoDidClciked:(id)sender {
}
- (IBAction)btnPlusPhotosDidClicked:(id)sender
{
    int RemainingCount =(int)arrayOfPhotos.count;
    
    if(RemainingCount<20)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            actionSheetPhotos = [[UIActionSheet alloc] initWithTitle:@"Select the picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Select from library",nil];
        }else{
            actionSheetPhotos = [[UIActionSheet alloc] initWithTitle:@"Select the picture" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Select from library",@"Cancel", nil];
            
        }
//        actionSheetPhotos = [[UIActionSheet alloc] initWithTitle:@"Select the picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Select from library",nil];
        actionSheetPhotos.actionSheetStyle = UIActionSheetStyleDefault;
        actionSheetPhotos.tag=101;
        [actionSheetPhotos showInView:self.view];
        
    }
    
}

- (IBAction)btnPlusVideosDidClicked:(id)sender
{
    if(canClientUploadVideos)
    {
        NSPredicate *predicateLocalVideos = [NSPredicate predicateWithFormat:@"isVideoFromLocal == %d",YES];// from local
        NSArray *arrayFiltered = [arrayOfVideos filteredArrayUsingPredicate:predicateLocalVideos];
        
        if(arrayFiltered.count<2)
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                actionSheetVideos = [[UIActionSheet alloc] initWithTitle:@"Select The Video" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Select from library",nil];
            }else{
                actionSheetVideos = [[UIActionSheet alloc] initWithTitle:@"Select The Video" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Select from library",@"Cancel", nil];
                
            }
            
//            actionSheetVideos=[[UIActionSheet alloc]initWithTitle:@"Select The Video" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Select from library", nil];
            actionSheetVideos.tag=222;
            [actionSheetVideos showInView:self.view];
        }
    }
   else
    {
        lblPopupMessage.text = @"Sorry, you have not been activated for this service yet.";
        
        [self loadPopup];
        
    }
    
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
        else if(i == 2)
        {
//            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
//            {
//                self.multipleImagePicker.isFromApp = YES;
//                picker = [[UIImagePickerController alloc] init];
//                picker.delegate = self;
//                [picker setAllowsEditing:NO];
//
//                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                [self presentViewController:picker animated:YES completion:^{}];
//            }
            
            
        }
    }
    else if (actionSheet==actionSheetVideos)
    {
        if (i==0)
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                HomeViewController *videoVC = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
                videoVC.isCameraViewFromPhotosNExtras = YES;
                videoVC.isCameraViewFromEBrochure = YES;
               // NSLog(@"vvvehicleName = %@ %@",self.lblVehicleName.text,self.photosExtrasObject.strStockCode);
                if(!self.isFromVariantList)
                  videoVC.videoVehicleName = [NSString stringWithFormat:@"%@-%@",self.lblVehicleName.text,self.photosExtrasObject.strStockCode];
                else
                  videoVC.videoVehicleName = [NSString stringWithFormat:@"%@",self.lblVehicleName.text];
                    
                [self.navigationController pushViewController:videoVC animated:YES];
                
                SMClassOfUploadVideos *objVideo=[[SMClassOfUploadVideos alloc]init];
                
                
                [HomeViewController getTheGeneratedVideoWithCallBack:^(BOOL success, NSString *videoPath, UIImage *thumbnailImage,NSString *videoName, NSError *error)
                 {
                     if(success)
                     { NSLog(@"Called this 22......");
                         objVideo.isVideoFromLocal=YES;
                         objVideo.localYouTubeURL= videoPath;
                         objVideo.videoFullPath = [[SMGlobalClass sharedInstance] saveVideo:videoPath];
                         objVideo.isUploaded=NO;
                         objVideo.thumnailImage= thumbnailImage;
                         NSLog(@"objVideo.localYouTubeURL = %@",objVideo.localYouTubeURL);
                         
                     }
                     
                 }];
                
                [SMVideoInfoViewController getTheVideoInfoWithCallBack:^(int indexPath, BOOL isSearchable, NSString *videoTitle, NSString *videoTag,NSString *videoDesc)
                 {
                     NSLog(@"Called this 11......");
                     NSLog(@"videoPathhhhhhh22 = %@",objVideo.localYouTubeURL);
                     objVideo.videoTitle = videoTitle;
                     objVideo.videoTags = videoTag;
                     objVideo.videoDescription = videoDesc;
                     objVideo.isSearchable = isSearchable;
                     NSLog(@"VideoArray count before camera = %lu",(unsigned long)arrayOfVideos.count);
                     NSLog(@"received indexpath = %d",indexPath);
                     if(indexPath == indexpathOfSelectedVideo)
                     {
                         NSLog(@"Replaced....");
                         if(arrayOfVideos.count > 0)
                             [arrayOfVideos replaceObjectAtIndex:indexPath withObject:objVideo];
                         else
                             [arrayOfVideos addObject:objVideo];
                     }
                     else
                     {
                         NSLog(@"Added....");
                         [arrayOfVideos addObject:objVideo];
                     }
                     
                     NSLog(@"VideoArray count camera = %lu",(unsigned long)arrayOfVideos.count);
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [collectionViewVideos reloadData];
                         
                     });
                     
                     
                 }];
                
            }
        }
        else if (i==1)
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                picker= [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
                picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
                
                [self presentViewController:picker animated:YES completion:nil];
            }
        }
    }
}

#pragma mark - MULTIPLE IMAGE SELECTION

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

#pragma mark - AlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== 101)
    {
        [HUD hide:YES];
        NSLog(@"***checkThis1");
        [self.navigationController popViewControllerAnimated:YES];
    }
    if(alertView.tag== 301)
    {
        if(buttonIndex == 1)
            [self.navigationController popViewControllerAnimated:YES];
    }
    if(alertView.tag==201)
    {
        if(buttonIndex==0)
        {
            
        }
        else
        {
            SMPhotosListNSObject *deleteImageObject = (SMPhotosListNSObject*)[arrayOfPhotos objectAtIndex:deleteButtonTag];
           
            
                if (deleteImageObject.imageOriginIndex >= 0)
                {
                    [SMGlobalClass sharedInstance].isFromCamera = NO;
                    
                    //Means image from that picker of multiple image selection
                    [self delegateFunctionWithOriginIndex:deleteImageObject.imageOriginIndex];
                    
                    for (int i=(int)deleteButtonTag+1;i<[arrayOfPhotos count];i++)
                    {
                        SMPhotosListNSObject *deleteImageObjectTemp = (SMPhotosListNSObject*)[arrayOfPhotos objectAtIndex:i];
                        deleteImageObjectTemp.imageOriginIndex--;
                    }
                }
            
            
            isPrioritiesImageChanged = YES;
            
            [arrayOfPhotos removeObjectAtIndex:deleteButtonTag];
            [collectionViewPhotos reloadData];
        }
    }
    
    if (alertView.tag==501)
    {
        if(buttonIndex==0)
        {
            
        }
        else
        {
            SMClassOfUploadVideos *deleteImageObject = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:deleteButtonTag];
            
            if(deleteImageObject.isVideoFromLocal==NO)
            {
                
                [[SMGlobalClass sharedInstance].arrayOfVideosToBeDeleted addObject:[arrayOfVideos objectAtIndex:deleteButtonTag]];
                
            }
            //else
            {
                
               
                [arrayOfVideos removeObjectAtIndex:deleteButtonTag];
                [collectionViewVideos reloadData];
                
            }
        }
    }
    if (alertView.tag==502)
    {
        if(buttonIndex==0)
        {
            
        }
        else
        {
            SMClassOfUploadVideos *deleteImageObject = (SMClassOfUploadVideos*)[arrVideofromWebService objectAtIndex:deleteButtonTag];
            
            if(deleteImageObject.isVideoFromLocal==NO)
            {
                
                [[SMGlobalClass sharedInstance].arrayOfVideosToBeDeleted addObject:[arrVideofromWebService objectAtIndex:deleteButtonTag]];
                
            }
            //else
            {
                
                if(arrVideofromWebService.count == 0)
                    [self.tblViewStockVehicleDetails reloadData];
                
                [arrVideofromWebService removeObjectAtIndex:deleteButtonTag];
                [collectionViewVideo reloadData];
                
            }
        }
    }

    if (alertView.tag==701)
    {
        if(buttonIndex==0)
        {
            [self loadVideoToDatabase];
            //            [HUD hide:YES];
            //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:kVehicleUpdatedSuccessfully delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //            alert.tag = 101;
            //            [alert show];
        }
        else
        {
            alertView.hidden = YES;
            [alertView removeFromSuperview];
            alertView = nil;
            [HUD show:YES];
            [HUD setLabelText:KLoaderText];
            NSLog(@"thissssss");
            [self uploadingVideos];
        }
    }
    if (alertView.tag==801)
    {
        if(buttonIndex==0)
        {
            [HUD hide:YES];
            NSLog(@"***checkThis3");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [HUD hide:YES];
            NSLog(@"***checkThis4");
            [self uploadingVideos];
        }
    }
    
}

#pragma mark - Image,Video uploading services

-(void)uploadPersonalizedImagesToTheServerWithIndex:(int)index andRequestURL:(NSMutableURLRequest*) requestURL
{
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    SMUrlConnection *connection = [[SMUrlConnection alloc] initWithRequest:requestURL delegate:self];
    connection.arrayIndex = index;
    
    [connection start];
}
#pragma mark - NSURL connection delegate methods
- (void)connection:(SMUrlConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    responseData = [[NSMutableData alloc]init];
}

- (void)connection:(SMUrlConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(SMUrlConnection *)connection didFailWithError:(NSError *)error
{
    
    SMAlert(@"Error", [error localizedDescription]);
    [HUD hide:YES];
    NSLog(@"***checkThis5");
    [uploadingHUD hide:YES];
    return;
}

- (void)connectionDidFinishLoading:(SMUrlConnection *)connection
{
    xmlParser = [[SMParserForUrlConnection alloc] initWithData:responseData];
    xmlParser.uniqueIdentifier = connection.arrayIndex;
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}



-(void)uploadingImagesIsVariant:(BOOL) isVariant
{
   
    {
        float arrayCount=(float)[arrayOfPhotos count];
        valueOfProgress=1.0/arrayCount;
        uploadingHUD.hidden = NO;
        
        
        // this stuff is for adding the new images to the server
        for(int i=0;i<[arrayOfPhotos count];i++)
        {
            
            SMPhotosListNSObject *imagesObject = (SMPhotosListNSObject*)[arrayOfPhotos objectAtIndex:i];
            
            if(imagesObject.isImageFromLocal==YES)
            {
                UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imagesObject.strimageName];
                NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
                
                base64Str = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
                
                if(!isVariant)
                {
                    NSMutableURLRequest *requestURL=[SMWebServices uploadPersonalizedImageWithImageToken:strPhotosToken andVehicleStockID:self.photosExtrasObject.strUsedVehicleStockID andBase64String:base64Str];
                    

                    [self uploadPersonalizedImagesToTheServerWithIndex:i andRequestURL:requestURL];
                }
                else
                {
                    NSMutableURLRequest *requestURL=[SMWebServices uploadVariantPersonalizedImageWithImageToken:strPhotosToken andVariantID:self.objVariantSelected.strMakeId andBase64String:base64Str];
                    
                     [self uploadPersonalizedImagesToTheServerWithIndex:i andRequestURL:requestURL];
                
                }
            }
            
        }
        
    }
    
}

-(void)uploadingVideos
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    [self performSelector:@selector(methodForLoadingVideos) withObject:nil afterDelay:0.2];
    
    NSLog(@"startLoaderAgain..");
    
    
}

-(void)methodForLoadingVideos
{
    
    NSString *urlString = [SMWebServices uploadVideosWebserviceUrl]; // staging
    
    // this stuff is for adding the new videos to the server
    
    NSLog(@"VIDEOSSCNT = %lu",(unsigned long)arrayOfVideos.count);
    for(int i=0;i<[arrayOfVideos count];i++)
    {
        
        
        videoCount = i;
        SMClassOfUploadVideos *objVideo = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:i];
        
        NSString *isSearchable;
        
        if(objVideo.isSearchable)
            isSearchable = @"true";
        else
            isSearchable = @"false";
        
        if(objVideo.isVideoFromLocal)
        {
            NSString *fileNameString = [objVideo.localYouTubeURL lastPathComponent];
            
            
            ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:[NSURL URLWithString: urlString]];
            NSLog(@"VIDEOURLLBrochure = %@",urlString);
            [request setTimeOutSeconds:120];
            
            [request setDelegate:self];
            [request setDidFailSelector:@selector(uploadFailed:)];
            [request setDidFinishSelector:@selector(uploadFinished:)];
            
            
            [request addRequestHeader:@"userHash" value:[SMGlobalClass sharedInstance].hashValue];
            [request addRequestHeader:@"Client" value:[SMGlobalClass sharedInstance].strClientID];
            
            NSLog(@"VARAIANTID: %@",self.objVariantSelected.strMakeId);
            if(!self.isFromVariantList)
                [request addRequestHeader:@"usedVehicleStockID" value:self.photosExtrasObject.strUsedVehicleStockID];
            else
               [request addRequestHeader:@"variantID" value:self.objVariantSelected.strMakeId];
            
            [request addRequestHeader:@"fileName" value:fileNameString];
            [request addRequestHeader:@"title" value:objVideo.videoTitle];
            [request addRequestHeader:@"description" value:objVideo.videoDescription];
            [request addRequestHeader:@"tags" value:objVideo.videoTags];
            [request addRequestHeader:@"searchable" value:isSearchable];
            [request setUploadProgressDelegate:HUD];
            
            //[request showAccurateProgress:YES];
            [request setFile:[[NSURL URLWithString:objVideo.localYouTubeURL] path] forKey:@"uploadfile"]; // this is POSIX path
            
            
            // uploadingHUD.hidden = NO;
            [request setPostFormat:ASIMultipartFormDataPostFormat];
            [request setRequestMethod:@"POST"];
             NSLog(@"%@",request);
            [request startSynchronous];
        }
    }

}

- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    
    NSError *error = [theRequest error];
    NSString *errorString = [error localizedDescription];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:[NSString stringWithFormat:@"Vehicle updated successfully but could not upload video/s as %@.Do you wish to retry uploading video/s ?",errorString] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 801;
    [alert show];
    NSLog(@"/*/Failed to get data : %@",errorString);
    [HUD hide:YES];
    NSLog(@"***checkThis6");
    
}

- (void)uploadFinished:(ASIHTTPRequest *)theRequest
{
    
    NSString *response = [theRequest responseString];
    NSLog(@"/*/Response received : %@",response);
    
    [arrayOfVideoID addObject:response];
    
     if(arrayOfVideos.count == arrayOfVideoID.count)
     {
         arrayVideoDetails1 = [[NSMutableArray alloc]init];
         arrayVideoDetails2 = [[NSMutableArray alloc]init];
         
         for(int i = 0; i < arrayOfVideos.count; i++)
         {
              if(arrayOfVideos.count == 1)
              {
                  arrayVideoDetails2 = nil;
              }
                  
             SMClassOfUploadVideos *objVideo = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:i];
             NSString *strIsSearchable = [NSString stringWithFormat:@"%d",objVideo.isSearchable];
              NSLog(@"isSearchable : %d",objVideo.isSearchable);
             
             if(i == 0)
             {
                 [arrayVideoDetails1 addObject:[arrayOfVideoID objectAtIndex:i]];
                 [arrayVideoDetails1 addObject:strIsSearchable];
             }
              
             else
             {
                 [arrayVideoDetails2 addObject:[arrayOfVideoID objectAtIndex:i]];
                 [arrayVideoDetails2 addObject:strIsSearchable];
             }
             
         }
         
         NSLog(@"arrayVideoDetails1 count = %lu",(unsigned long)arrayVideoDetails1.count);
         
         if(arrayOfPhotos.count > 0)
         {
             NSLog(@"isThis1???");
             [self sendTheBrochureWithImages];
         }
         else
             [self sendTheBrochureWithoutImages];
     
     }
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
}

-(void)canUserUploadVideos
{
    NSMutableURLRequest *requestURL = [SMWebServices canUserUploadVideoWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             NSLog(@"***checkThis7");
             return;
             
         }
         else
         {
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}


#pragma mark - Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)// Video
    {
        
        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        moviePath = [videoUrl path];
        NSLog(@"MOVIEPATH url = %@",moviePath);
        
        
        NSError *attributesError;
        //                        imageData  = [NSData dataWithContentsOfFile:videoPath];
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:moviePath error:&attributesError];
        
        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
        long long fileSize = [fileSizeNumber longLongValue];
        NSLog(@"File size: %lld",fileSize);
        
        float sizeMB = (float)fileSize/1000000;
        NSLog(@"Original = %f",sizeMB);
        UIImage *videoThumImage;
        if(sizeMB > 50)
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry! This video cannot be uploaded" message:@"Video size is more than 50 MB." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
            
            [picker dismissViewControllerAnimated:NO completion:^{
                picker.delegate=nil;
                picker = nil;
                
            }];
            
        }
        else
        {
            
            NSString *videoTimeStamp=[self createIdFromCurrentDateTimestamp];
            
            filToBeuplaoded= [NSString stringWithFormat:@"%@-Video-Thumbnail",videoTimeStamp];
            
            NSLog(@"MoviePath = %@",moviePath);
            //            videoThumImage=[[SMGlobalClass sharedInstance]generateVideoThumbnailImage:moviePath];
            
            [[SMGlobalClass sharedInstance]saveImage:videoThumImage imageName:filToBeuplaoded];
            
            [SMVideoInfoViewController getTheVideoInfoWithCallBack:^(int indexPath, BOOL isSearchable, NSString *videoTitle, NSString *videoTag,NSString *videoDesc)
             {
                 SMClassOfUploadVideos *objVideo=[[SMClassOfUploadVideos alloc]init];
                 
                 objVideo.isVideoFromLocal=YES;
                 objVideo.localYouTubeURL=moviePath;
                 objVideo.isUploaded=NO;
                 objVideo.thumnailImage=[[SMGlobalClass sharedInstance]generateVideoThumbnailImage:moviePath];
                 objVideo.videoTitle = videoTitle;
                 objVideo.videoTags = videoTag;
                 objVideo.videoDescription = videoDesc;
                 objVideo.isSearchable = isSearchable;
                 objVideo.videoFullPath = moviePath;
                 NSLog(@"VideoArray count before photo library = %lu",(unsigned long)arrayOfVideos.count);
                 if(indexPath == indexpathOfSelectedVideo)
                 {
                     NSLog(@"Replaced....");
                     if(arrayOfVideos.count > 0)
                         [arrayOfVideos replaceObjectAtIndex:indexPath withObject:objVideo];
                     else
                         [arrayOfVideos addObject:objVideo];
                 }
                 else
                 {
                     NSLog(@"Added....");
                     [arrayOfVideos addObject:objVideo];
                 }
                 NSLog(@"VideoArray count photo library = %lu",(unsigned long)arrayOfVideos.count);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [collectionViewVideos reloadData];
                     
                 });
                 
                 
             }];
            
        }
        
        // Picking Image from Camera/ Library
        SMVideoInfoViewController *videoInfoVC = [[SMVideoInfoViewController alloc] initWithNibName:@"SMVideoInfoViewController" bundle:nil];
        videoInfoVC.videoPathURL = moviePath;
        videoInfoVC.isVideoFromServer = NO;
        videoInfoVC.isFromCameraView = YES;
        videoInfoVC.isFromPhotosNExtrasDetailPage = NO;
        videoInfoVC.isFromSendBrochureDetailPage = YES;
         videoInfoVC.isFromListPage = NO;
        videoInfoVC.thumbNailImage = [[SMGlobalClass sharedInstance]generateVideoThumbnailImage:moviePath];
        videoInfoVC.vehicleName = [NSString stringWithFormat:@"%@-%@",self.lblVehicleName.text,self.photosExtrasObject.strStockCode];
        [picker dismissViewControllerAnimated:NO completion:^{
            picker.delegate=nil;
            picker = nil;
            [self.navigationController pushViewController:videoInfoVC animated:NO];
        }];
    }
    else
    {
        // Picking Image from Camera/ Library
        [picker dismissViewControllerAnimated:NO completion:^{
            picker.delegate=nil;
            picker = nil;
        }];
        
        
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
        
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"ddHHmmssSSS"];
        
        NSString *dateString=[formatter stringFromDate:[NSDate date]];
        
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
                 NSLog(@"11113");
                [arrayOfPhotos addObject:imageObject];
                selectedImage = nil;
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [collectionViewPhotos reloadData];
                [self.multipleImagePicker.Originalimages removeAllObjects];
                
            });
            
        };
        
    }
}

-(NSString*)createIdFromCurrentDateTimestamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

-(NSDate*)getDateFromDateString:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSLog(@"Date : %@",[dateFormatter dateFromString:dateString]);
    return [dateFormatter dateFromString:dateString];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1
{
    if([SMGlobalClass sharedInstance].isFromCamera)
        [SMGlobalClass sharedInstance].photoExistingCount--;
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
}


-(UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}



- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
        UIImage *imgThumbnail = [UIImage imageWithCGImage:[asset thumbnail]];
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"ddHHmmssSSS"];
        
        NSString *dateString=[formatter stringFromDate:[NSDate date]];
        
        NSString *imgName =[NSString stringWithFormat:@"%@_asset",dateString];
        
        [self saveImage:img :imgName];
        
        [self.multipleImagePicker addOriginalImages:imgName];
        };
    }
    
    NSPredicate *predicateServerImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];// from server
    NSArray *arrayServerFiltered = [arrayOfPhotos filteredArrayUsingPredicate:predicateServerImages];
    
    NSPredicate *predicateCameraImages = [NSPredicate predicateWithFormat:@"isImageFromCamera == %d",YES];// from server
    NSArray *arrayCameraFiltered = [arrayOfPhotos filteredArrayUsingPredicate:predicateCameraImages];
    
    NSArray *finalFilteredArray = [arrayServerFiltered arrayByAddingObjectsFromArray:arrayCameraFiltered];
    
    if ([finalFilteredArray count] > 0)
    {
        [arrayOfPhotos removeAllObjects];
        arrayOfPhotos = [NSMutableArray arrayWithArray:finalFilteredArray];
    }
    else
    {
        [arrayOfPhotos removeAllObjects]; // check here.
    }
    
    [collectionViewPhotos reloadData];
    
    
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
            NSLog(@"11112");
            [arrayOfPhotos addObject:imageObject];
            
            selectedImage = nil;
            
        }
        NSLog(@"arrayOfPhotos = %@",arrayOfPhotos);
        dispatch_async(dispatch_get_main_queue(), ^{
            [collectionViewPhotos reloadData];
            [self.multipleImagePicker.Originalimages removeAllObjects];
            //[self.multipleImagePicker.ThumbnailImages removeAllObjects];
            
        });
        
    };
    
    [self dismissImagePickerControllerForCancel:NO];
    
    
}
/////////////// Monami tap on cancel of image gallery, image delete 
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
//        [self.collectionViewImages reloadData];
//
//    }
      [self.collectionViewImages reloadData];
    [self dismissImagePickerControllerForCancel:YES];
    
    for (UINavigationController *view in self.navigationController.viewControllers)
    {
        
        if ([view isKindOfClass:[RPMultipleImagePickerViewController class]])
        {
            [self.navigationController popViewControllerAnimated:NO];
            
        }
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



- (IBAction)btnDeleteVideosDidClicked:(id)sender1
{
    UIButton *button=(UIButton *)sender1;
    deleteButtonTag = button.tag;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:KLoaderTitle message:KDeleteImageAlert delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    alert.tag = 501;
    [alert show];
}
-(IBAction)btnDeleteImageDidClicked:(id)sender1
{
    UIButton *button=(UIButton *)sender1;
    deleteButtonTag = button.tag;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:KLoaderTitle message:KDeleteImageAlert delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    alert.tag = 201;
    [alert show];
}



- (IBAction)btnCheckBoxPersonalisedDidClicked:(id)sender
{
    
}
-(void)dismissTheLoader
{
    [imagePickerController dismissTheLoaderAction];
}

-(void)delegateFunctionWithOriginIndex:(int)originIndex
{
    if(![SMGlobalClass sharedInstance].isFromCamera)
        [imagePickerController deleteTheImageFromTheFirstLibraryWithIndex:originIndex];
    
}

-(void)delegateFunction:(UIImage*)imageToBeDeleted
{
    [imagePickerController deleteTheImageFromTheFirstLibrary:imageToBeDeleted];
}

-(void)delegateFunctionForDeselectingTheSelectedPhotos
{
    [imagePickerController deSelectAllTheSelectedPhotosWhenCancelAction];
    
}


#pragma mark - webserive integration

-(void) webserviceCallForVariantImagesNVideos
{
    [HUD show:YES];
    // 17984
    NSMutableURLRequest * requestURL = [SMWebServices gettingDetailsForEditStockVehicles:[SMGlobalClass sharedInstance].hashValue variantId:self.objVariantSelected.strMakeId.intValue];
    
    NSURLSession *dataTaskSession ;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            NSLog(@"Response = %@",response.description);
                                            NSLog(@"error = %@",error.description);
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
                                                if(arrayOfImages.count > 0)
                                                   [arrayOfImages removeAllObjects];
                                                
                                                if(arrayOfSliderImages.count > 0)
                                                    [arrayOfSliderImages removeAllObjects];
                                                
                                                xmlParser = [[SMParserForUrlConnection alloc] initWithData:data];
                                                [xmlParser setDelegate:self];
                                                [xmlParser setShouldResolveExternalEntities:YES];
                                                                                                [xmlParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
}



#pragma mark - Custom AlertView

#pragma mark- load popup
-(void)loadPopup
{
    
    [popUpView setFrame:[UIScreen mainScreen].bounds];
    [popUpView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.50]];
    [popUpView setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popUpView];
    [popUpView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [popUpView setAlpha:0.75];
         [popUpView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [popUpView setAlpha:1.0];
              
              [popUpView setTransform:CGAffineTransformIdentity];
          }
                          completion:^(BOOL finished)
          {
          }];
         
     }];
}

#pragma mark - dismiss popup
-(void)dismissPopup
{
    [popUpView setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popUpView];
    [UIView animateWithDuration:0.1 animations:^{
        [popUpView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [popUpView setAlpha:0.3];
              [popUpView setTransform:CGAffineTransformMakeScale(0.9    ,0.9)];
              
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   
                   [popUpView setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [popUpView removeFromSuperview];
                   [popUpView setTransform:CGAffineTransformIdentity];
                   
                   
               }];
              
          }];
         
     }];
    
}

#pragma mark -

- (IBAction)btnCancelCustomAlertDidClicked:(id)sender
{
    [self dismissPopup];
}

- (IBAction)btnDeleteVideosWebServiceDidClicked:(id)sender1
{
    UIButton *button=(UIButton *)sender1;
    deleteButtonTag = button.tag;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:KLoaderTitle message:KDeleteImageAlert delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    alert.tag = 502;
    [alert show];
}

- (IBAction)btnEmailDidClicked:(id)sender
{
    [self dismissPopup];
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setToRecipients:@[@"support@ix.co.za"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:mail animated:YES completion:NULL];
            
        });
    }
    else
    {
        UIAlertView *alertInternal = [[UIAlertView alloc]
                                      initWithTitle: NSLocalizedString(@"Notification", @"")
                                      message: NSLocalizedString(@"You have not configured your e-mail client.", @"")
                                      delegate: nil
                                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                      otherButtonTitles:nil];
        [alertInternal show];
    }
    
    
    
}

- (IBAction)btnPhoneDidClicked:(id)sender
{
    [self dismissPopup];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0861292999"]];
}
- (BOOL)mobileNumberValidate:(NSString*)number
{
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}
#pragma mark


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultSent:
            [self showAlert:@"You Sent The Email."];
            break;
        case MFMailComposeResultSaved:
            [self showAlert:@"You Saved A Draft Of This Email."];
            break;
        case MFMailComposeResultCancelled:
            [self showAlert:@"You Cancelled Sending This Email."];
            break;
        case MFMailComposeResultFailed:
            [self showAlert:@"An Error Occurred When Trying To Compose This Email."];
            break;
        default:
            [self showAlert:@"An Error Occurred When Trying To Compose This Email"];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showAlert:(NSString*)message
{
    SMAlert(KLoaderTitle, message);
}

-(void)loadVideoToDatabase
{
    
    NSMutableArray *arrmImageDetailObjects = [[NSMutableArray alloc] init] ;
    
    for(int i = 0;i<[arrayOfVideos count];i++)
    {
        SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:i];
        if(videoObj.isVideoFromLocal==YES)
        {
            NSString *str;
            if (videoObj.isSearchable) {
                str = @"true";
            }else{
                str = @"false";
            }
            // 2 for Vehicle
            NSDictionary *dictVideoDetailObj = [NSDictionary dictionaryWithObjectsAndKeys:[SMGlobalClass sharedInstance].strClientID,@"ClientID",[SMGlobalClass sharedInstance].strMemberID,@"MemberID",videoObj.videoFullPath,@"VideoFullPath",self.photosExtrasObject.strUsedVehicleStockID,@"VariantId",videoObj.videoTitle,@"VideoTitle",videoObj.videoDescription,@"VideoDescription",videoObj.videoTags,@"VideoTags",str,@"Searchable",@"2",@"ModuleIdentifier",videoObj.youTubeID,@"YoutubeID", nil];
            
            [arrmImageDetailObjects addObject:dictVideoDetailObj];
        }
    }
    
    [[SMDatabaseManager theSingleTon] insertVideosDetailsInDatabase:arrmImageDetailObjects];
    
    [HUD hide:YES];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:kVehicleUpdatedSuccessfully delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alert.tag = 101;
    [alert show];
}

@end
