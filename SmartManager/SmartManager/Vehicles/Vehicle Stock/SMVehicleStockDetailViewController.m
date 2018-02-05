//
//  SMVehicleStockDetailViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 12/02/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMVehicleStockDetailViewController.h"
#import "SMSellCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "SMCustomDynamicCell.h"
#import "UIBAlertView.h"
#import "SMConstants.h"
#import "SMAppDelegate.h"
#import "SMCustomMoreInfoCell.h"
#import "SMClassOfUploadVideos.h"
#import "SMStockVehicleDetailController.h"
#import "SMCellOfPlusImageCommentPV.h"

#import "HomeViewController.h"
#import "SMVideoInfoViewController.h"
#import "Reachability.h"
#import "UIBAlertView.h"
#import "SMClassOfUploadVideos.h"
#import "SMVehicleStockDetailsTableViewCell.h"

@interface SMVehicleStockDetailViewController ()
{
    NSMutableArray *arrVideofromWebService;
    SMClassOfUploadVideos *videoListObject;
    NSString *strVehicleSpecsDetail;

}

@end

@implementation SMVehicleStockDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNib];
    [self addingProgressHUD];
    
    
    shouldSectionBeExpanded = NO;
    [self setTheTitleForScreen];
    //[self.view bringSubviewToFront:self.btnSend];
    // self.btnSend.backgroundColor = [UIColor greenColor];
    
    strVehicleSpecsDetail = @"";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        lblVehicleDetails3.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    }
    else
    {
        lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        lblVehicleDetails3.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        
    }
    
    // self.txtViewComment.font = [UIFont fontWithName:FONT_NAME size:20.0];
    
    tblViewStockVehicleDetails.tableFooterView = viewTableFooter;
    
    arrayOfImages = [[NSMutableArray alloc]init];
    arrayOfSliderImages = [[NSMutableArray alloc]init];
    arrVideofromWebService = [[NSMutableArray alloc] init];
    
    if(!self.isFromVariantList)
     [self loadVehicleDetailsFromServer];
    else
    {
        [self webserviceCallForVariantImagesNVideos];
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    SMCustomMoreInfoCell *cell = (SMCustomMoreInfoCell*)[tblViewStockVehicleDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell.textViewComment resignFirstResponder];
    [cell.txtFieldEmailAddress resignFirstResponder];
    
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



-(void)textViewDidBeginEditing:(CustomTextView *)textView
{
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:tblViewStockVehicleDetails];
    pt = rc.origin;
    pt.x = 0;
    
    pt.y -= 118;
    [tblViewStockVehicleDetails setContentOffset:pt animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:tblViewStockVehicleDetails];
    pt = rc.origin;
    pt.x = 0;
    
    pt.y -= 98;
    [tblViewStockVehicleDetails setContentOffset:pt animated:YES];
}

#pragma mark - UITableView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"arrayOfImages counts = %lu",(unsigned long)arrayOfImages.count);
    
     if(collectionView == collectionViewVideos || collectionView == collectionViewVideosWithNoImages)
        return arrVideofromWebService.count;
    
    return arrayOfSliderImages.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView==collectionViewVideos || collectionView == collectionViewVideosWithNoImages)
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
            NSLog(@"YouTubeId = %@",videoObj.youTubeID);
            
            [cellVideos.imgActualImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",videoObj.youTubeID]] placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
                cellVideos.imgActualImage.image = image;
                NSLog(@"IMAGEEE = %@",image);
            } failure:^(NSError *error) {
                NSLog(@"Error image = %@",[error localizedDescription]);
            }];
            
            
        }
        else
        {
            NSLog(@"ThumbnailImage = %@",videoObj.thumnailImage);
            
            cellVideos.imgActualImage.image=videoObj.thumnailImage;
            cellVideos.imgViewPlayVideo.hidden=NO;
        }
        
        cellVideos.imgViewPlayVideo.hidden=NO;
        return cellVideos;
    }
    else
    {
        
        
        SMSellCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier" forIndexPath:indexPath];
        
        
        
        [cell.imageVehicle   setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        
       
        
        cell.imageVehicle.contentMode = UIViewContentModeScaleAspectFill;
        
        SMPhotosListNSObject *photosObject1 = (SMPhotosListNSObject*)[arrayOfSliderImages objectAtIndex:indexPath.item];
        
        [cell.imageVehicle setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photosObject1.imageLink]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        
        
        return cell;
    }
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (collectionView==collectionViewImages)
    {
        
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        networkGallery.startingIndex = indexPath.row+1;
        SMAppDelegate *appdelegate1 = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate1.isPresented =  YES;
        [self.navigationController pushViewController:networkGallery animated:YES];
    }
    else if (collectionView==collectionViewVideos || collectionView == collectionViewVideosWithNoImages)
    {
        {
            SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrVideofromWebService objectAtIndex:indexPath.row];
            if(videoObj.isVideoFromLocal == NO)
            {
                //[SMGlobalClass sharedInstance].imageThumbnailForVideo = videoObj.thumnailImage;
                
                SMVideoInfoViewController *videoInfoVC = [[SMVideoInfoViewController alloc] initWithNibName:@"SMVideoInfoViewController" bundle:nil];
                
                NSLog(@"videoObj.youTubeIdD = %@",videoObj.youTubeID);
                // if(imageVieww == nil)
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
                videoInfoVC.vehicleName = [NSString stringWithFormat:@"%@-%@",lblVehicleName.text,self.photosExtrasObject.strStockCode];
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
                videoInfoVC.vehicleName = [NSString stringWithFormat:@"%@-%@",lblVehicleName.text,self.photosExtrasObject.strStockCode];
                [self.navigationController pushViewController:videoInfoVC animated:YES];
            }
            
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
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section == 0)
        return 6;
    
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMCustomDynamicCell     *dynamicCell;
    
    static NSString *cellIdentifier3= @"SMCustomDynamicCell";
    
    if(indexPath.section == 0)
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
                lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(8,1,101,21)];
                lblValue = [[UILabel alloc] initWithFrame:CGRectMake(104,1,self.view.frame.size.width - 112,height)];
                lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblValue.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
            }
            else
            {
                lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(8,3,120,30)];
                lblValue = [[UILabel alloc] initWithFrame:CGRectMake(170,2,self.view.frame.size.width-178,height)];
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
        
        
        switch (indexPath.row)
        {
            case 0:
            {
                lblTitle.text = @"Comments:";
                if([vehicleComments length]!= 0)
                    lblValue.text = vehicleComments;
                else
                    lblValue.text = @"None loaded.";
                
//                lblTitle.text = @"Type:";
//                lblValue.text = vehicleType;
                
            }
                break;
            case 1:
            {
                lblTitle.text = @"Extras:";
                if([vehicleExtras length]!= 0)
                    lblValue.text = vehicleExtras;
                else
                    lblValue.text = @"None loaded.";
                
                
//                lblTitle.text = @"Comments:";
//                if([vehicleComments length]!= 0)
//                    lblValue.text = vehicleComments;
//                else
//                    lblValue.text = @" ";
                
            }
                break;
            case 2:
            {
                if([strSpecDetails length] != 0)
                    lblTitle.text = @"Specs";
                else
                    lblTitle.text = @" ";
                
                lblValue.text = @" ";
            }
                break;

            case 3:
            {
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    [lblValue setFrame:CGRectMake(8,1,self.view.frame.size.width - 16,height)];
                }
                else{
                     [lblValue setFrame:CGRectMake(8,2,self.view.frame.size.width - 16,height)];
                }
                if([strSpecDetails length] > 0)
                    lblValue.text = strSpecDetails;
                else
                    lblValue.text = @"";
                
                
            }
            break;
            
            case 4:{
            
                
                SMVehicleStockDetailsTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"SMVehicleStockDetailsTableViewCell"];
                cell.lblText.hidden = YES;
               /* NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:self.photosExtrasObject.strVehicleName
                                                                                         attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}]];
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"9"
                                                                                         attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                                                                        NSBackgroundColorAttributeName: [UIColor clearColor]}]];
               
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    cell.lblText.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                }
                else
                {
                    cell.lblText.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                }
              
                [cell.lblText setAttributedText:attributedString];
                cell.lblText.textColor = [UIColor whiteColor];
                cell.lblText.numberOfLines = 0;
                [cell.lblText sizeToFit];
                cell.backgroundColor = [UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;*/
                return cell;
                }
                break;
                
            case 5:{
                /*  SMVehicleStockDetailsTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"SMVehicleStockDetailsTableViewCell"];
                 
                 
                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                 {
                 cell.lblText.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
                 }
                 else
                 {
                 cell.lblText.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
                 }
                 
                 [cell.lblText setText:strInternalNote];
                 cell.lblText.textColor = [UIColor whiteColor];
                 cell.lblText.numberOfLines = 0;
                 [cell.lblText sizeToFit];
                 cell.backgroundColor = [UIColor blackColor];
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
                 return cell;*/
                lblValue.font = [UIFont fontWithName:FONT_NAME size:12.0];
                lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
                
                lblTitle.frame = CGRectMake(8,1,101,21);
                lblValue.frame = CGRectMake(104,4,self.view.frame.size.width - 112,height);
                
                
                if([strInternalNote length]!= 0)
                {
                    lblTitle.text = @"Internal Memo: ";
                    lblValue.text = strInternalNote;
                }
                else
                {
                    lblTitle.text = @"";
                    lblValue.text = @"";
                }
                
            }
                break;
            default:
                break;
        }
        
        lblTitle.textColor = [UIColor whiteColor];        
        lblValue.textColor = [UIColor whiteColor];
        lblValue.numberOfLines = 0;
        [lblValue sizeToFit];
        
        //            lblValue.backgroundColor = [UIColor redColor];
        dynamicCell.backgroundColor = [UIColor clearColor];
        
        return dynamicCell;
    }
    else
    
    return nil;
}

- (CGFloat)heightForText:(NSString *)bodyText
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
        textSize = self.view.frame.size.width - 112;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
        textSize = self.view.frame.size.width - 178;
    }
    CGSize constraintSize = CGSizeMake(textSize, MAXFLOAT);
    CGSize labelSize = [bodyText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = labelSize.height;
    
    return height;
}

- (CGFloat)heightForInternalNoteText:(NSString *)bodyText
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:12];
        textSize = self.view.frame.size.width - 112;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:17];
        textSize = self.view.frame.size.width - 178;
    }
    CGSize constraintSize = CGSizeMake(textSize, MAXFLOAT);
    CGSize labelSize = [bodyText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = labelSize.height;
    
    return height;
}


- (CGFloat)heightForVehicleText:(NSString *)bodyText
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
        textSize = self.view.frame.size.width - 50;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
        textSize = self.view.frame.size.width - 50;
    }
    CGSize constraintSize = CGSizeMake(textSize, MAXFLOAT);
    CGSize labelSize = [bodyText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = labelSize.height;
    
    return height;
}



- (CGFloat)heightForTextSpecs:(NSString *)bodyText
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
        textSize = self.view.frame.size.width - 8;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
        textSize = self.view.frame.size.width - 8;
    }
    CGSize constraintSize = CGSizeMake(textSize, MAXFLOAT);
    CGSize labelSize = [bodyText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = labelSize.height;
    
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == tblViewStockVehicleDetails)
    {
        if (indexPath.section == 0)
        {
            CGFloat height = 0.0f;
            
            switch (indexPath.row)
            {
                case 0:
                {
                    if([vehicleComments length]== 0)
                        vehicleComments = @"None loaded";
                    
                    height = [self heightForText:vehicleComments];
                    
                }
                    break;
                case 1:
                {
                    if([vehicleExtras length]== 0)
                        vehicleExtras = @"None loaded";
                    height = [self heightForText:vehicleExtras];
                }
                    break;
                case 2:
                {
                    if([strSpecDetails length] == 0)
                        return 0.0f;
                    
                    height = [self heightForText:@" "];
                }
                    break;
                    
                case 3:
                {
                    
                    if([strSpecDetails length] == 0)
                        return 0.0f;
                    
                    height = [self heightForTextSpecs:strSpecDetails];
                }
                    break;
                case 4:
                {
                    //height = [self heightForText:self.photosExtrasObject.strVehicleName];
                    return 0;
                }
                    break;
                case 5:
                {
                    if([strInternalNote length]== 0)
                    {
                        return 0;
                    }
                    
                    height = [self heightForInternalNoteText:strInternalNote];
                }
                    break;
                    
                default: height = 30.0f;
                    break;
            }
            
            
            return height+10;
        }
        else
        {
            return 182.0;
            
        }
        
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 4:
            {
                NSLog(@"9 printed");
            }
                break;
                
            default:
                break;
        }
    }
}

-(IBAction)btnSectionTitleDidClicked:(id)sender
{
    
    shouldSectionBeExpanded = !shouldSectionBeExpanded;
    
    
    [tblViewStockVehicleDetails reloadData];
}


- (void)registerNib
{
    [collectionViewImages registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMSellCollectionCell" : @"SMSellCollectionCell_iPad" bundle:nil]            forCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier"];
    
    [tblViewStockVehicleDetails registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMCustomMoreInfoCell" : @"SMSellListDetailCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMCustomMoreInfoCell"];
    
    [tblViewStockVehicleDetails registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMVehicleStockDetailsTableViewCell" : @"SMVehicleStockDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMVehicleStockDetailsTableViewCell"];
    
    [collectionViewVideos registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusVideoPV"];
    
    [collectionViewVideos registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualVideoPV"];
    
    [collectionViewVideosWithNoImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusVideoPV"];
    
    [collectionViewVideosWithNoImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualVideoPV"];
}


-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
{
    
    if([firstText length] == 0)
    {
      firstText = @"No Data";
    }
    
    if([secondText length] == 0)
    {
        secondText = @"No Data";
    }
    
    if([thirdText length] == 0)
    {
        thirdText = @"No Data";
    }
    
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

#pragma mark - Set Attributed Text

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
    
    if(self.selectedVehicleIDFromDropdown == 1 || self.selectedVehicleIDFromDropdown == 4)
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
    listActiveSpecialsNavigTitle.text = @"Vehicle Info";
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
    
    
    
}

- (IBAction)btnSendDidClicked:(id)sender
{
    NSLog(@"Send button clicked...");
    
    [self.view endEditing:YES];
    appdelegate.isRefreshUI=YES;
    
    SMCustomMoreInfoCell *cell = (SMCustomMoreInfoCell*)[tblViewStockVehicleDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regExpred =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringCheck = [regExpred evaluateWithObject:cell.txtFieldEmailAddress.text];
    
    if(!myStringCheck)
    {
        SMAlert(KLoaderTitle,@"Please enter valid email");
        return;
    }
    
    if([cell.textViewComment.text length] == 0)
    {
        SMAlert(KLoaderTitle,@"Please add comment");
        return;
    }
    
    [self sendTheBrochureInfoToServer];
    
    
   
}


-(void)loadVehicleImagesFromServer
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    isImageWebserviceCallled = YES;
    
    NSMutableURLRequest *requestURL = [SMWebServices gettingListOfVehiclesImagesListForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue]];
    
    // NSMutableURLRequest *requestURL = [SMWebServices gettingListOfVehiclesImagesListForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             return;
             
             
         }
         else
         {
             
             
             xmlParser = [[NSXMLParser alloc] initWithData:data];
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
    
    //1628
   // NSMutableURLRequest *requestURL = [SMWebServices gettingLoadVehiclesImagesListForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue]];
    NSMutableURLRequest *requestURL = [SMWebServices gettingLoadVehiclesImagesListForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             return;
             
             
         }
         else
         {
             
             
             xmlParser = [[NSXMLParser alloc] initWithData:data];
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
    
    SMCustomMoreInfoCell *cell = (SMCustomMoreInfoCell*)[tblViewStockVehicleDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSMutableURLRequest *requestURL = [SMWebServices sendTheBrochureWithUserHash:[SMGlobalClass sharedInstance].hashValue andStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue] andEmailToAddress:cell.txtFieldEmailAddress.text andComment:cell.textViewComment.text];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             return;
             
             
         }
         else
         {
             
             
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
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



#pragma mark - xmlParserDelegate
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
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
    if ([elementName isEqualToString:@"video"])
    {
        videoListObject=[[SMClassOfUploadVideos alloc]init];
    }
    if ([elementName isEqualToString:@"Details"])
    {
        isImageWebserviceCallled = NO;
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

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if( [elementName isEqualToString:@"spec"])
    {
        
        // dictSpecDetails = [[NSMutableDictionary alloc]init];
        [dictSpecDetails setObject:currentNodeContent forKey:strSpecDetails];
        
        
        //[arrayOfSpecs addObject:dictSpecDetails];
        
    }
    else if( [elementName isEqualToString:@"SpecDetails"])
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
    else if( [elementName isEqualToString:@"internalnote"])
    {
        if([currentNodeContent length] == 0)
            strInternalNote = @"";
        else
            strInternalNote = currentNodeContent;
    }
    
    
    else if ([elementName isEqualToString:@"LoadVehicleDetailsXMLResponse"])
    {
        if ([currentNodeContent isEqualToString:@"No Images"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"No images found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag=101;
            
            [alert show];
            
        }
    }
    
    else if ([elementName isEqualToString:@"uciID"])
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
    else if ([elementName isEqualToString:@"image"])
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
    
    else if ([elementName isEqualToString:@"title"])
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
        videoListObject.isSearchable = currentNodeContent ;
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
                
                [self setAttributedTextForVehicleNameWithFirstText:@"" andWithSecondText:self.objVariantSelected.strMakeName forLabel:lblVehicleName];
                
                [lblVehicleName sizeToFit];
                
                if([self.objVariantSelected.strPrice isEqualToString:@"R0"])
                    self.objVariantSelected.strPrice = @"R?";
                [self setAttributedTextForVehicleDetailsWithFirstText:@"New" andWithSecondText:self.objVariantSelected.strMeanCodeNumber andWithThirdText:@"Ret." andWithFourthText:self.objVariantSelected.strPrice forLabel:lblVehicleDetails1];
                [lblVehicleDetails1 sizeToFit];
                
                lblVehicleDetails2.text = @"";
                lblVehicleDetails3.text = @"";
                
                
                lblVehicleDetails1.frame = CGRectMake(lblVehicleDetails1.frame.origin.x,lblVehicleName.frame.origin.y + lblVehicleName.frame.size.height, lblVehicleDetails1.frame.size.width, lblVehicleDetails1.frame.size.height);
                
                int lineCount = [self lineCountForLabel:lblVehicleDetails1];
                
                lblVehicleDetails2.frame = CGRectMake(lblVehicleDetails2.frame.origin.x, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+1.0, lblVehicleDetails2.frame.size.width,lblVehicleDetails2.frame.size.height);
                
                lblVehicleDetails3.frame = CGRectMake(lblVehicleDetails3.frame.origin.x, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+1.0, lblVehicleDetails3.frame.size.width,lblVehicleDetails3.frame.size.height);
                
                if(lineCount == 1)
                {
                    viewCollectionContainer.frame = CGRectMake(viewCollectionContainer.frame.origin.x, imageVehicle.frame.origin.y + imageVehicle.frame.size.height+3.0, viewCollectionContainer.frame.size.width, viewCollectionContainer.frame.size.height);
                }
                else
                {
                    if(self.isFromVariantList)
                    {
                        viewCollectionContainer.frame = CGRectMake(viewCollectionContainer.frame.origin.x, imageVehicle.frame.origin.y + imageVehicle.frame.size.height+3.0, viewCollectionContainer.frame.size.width, viewCollectionContainer.frame.size.height);
                    }
                    else
                    {
                        viewCollectionContainer.frame = CGRectMake(viewCollectionContainer.frame.origin.x,lblVehicleDetails3.frame.origin.y + lblVehicleDetails3.frame.size.height+1.0,viewCollectionContainer.frame.size.width,viewCollectionContainer.frame.size.height);
                    }
                }
                
                
                CGRect headerFrame;
                if(arrVideofromWebService.count>0 && arrayOfImages.count > 1)
                {
                    collectionViewVideos.hidden = NO;
                    collectionViewVideos.frame = CGRectMake(collectionViewVideos.frame.origin.x,viewCollectionContainer.frame.origin.y +viewCollectionContainer.frame.size.height+7.0, collectionViewVideos.frame.size.width, collectionViewVideos.frame.size.height);
                    headerFrame = viewHeader.frame;
                    headerFrame.size.height = 225;
                    viewHeader.frame = headerFrame;
                    
                }
                else if(arrVideofromWebService.count == 0 && arrayOfImages.count > 1)
                {
                    collectionViewVideos.hidden = YES;
                    headerFrame = viewHeader.frame;
                    headerFrame.size.height = 178;
                    viewHeader.frame = headerFrame;
                }
                else
                {
                    collectionViewVideos.hidden = YES;
                    headerFrame = viewHeader.frame;
                    headerFrame.size.height = 106;
                    viewHeader.frame = headerFrame;
                }
                
                
                tblViewStockVehicleDetails.tableHeaderView = viewHeader;
                [tblViewStockVehicleDetails reloadData];
                [collectionViewImages reloadData];
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
            tblViewStockVehicleDetails.tableHeaderView = self.viewHeaderVariant;
            
        }
    }
    
    else if ([elementName isEqualToString:@"LoadVehicleDetailsXMLResult"])
    {
        NSLog(@"arrayOfImages counttt = %lu",(unsigned long)arrayOfImages.count);
        NSLog(@"arrayOfVideos counttt = %lu",(unsigned long)arrVideofromWebService.count);
        
        if (arrayOfSliderImages.count>0)
        {
            [arrayOfSliderImages removeObjectAtIndex:0];
        }
        
        if(arrayOfImages.count > 0)
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(self.selectedVehicleIDFromDropdown == 1 || self.selectedVehicleIDFromDropdown == 4)
                {
                    [self setAttributedTextForVehicleNameWithFirstText:@"" andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:lblVehicleName];
                    
                NSString *mileage = [NSString stringWithFormat:@"%@",self.photosExtrasObject.strMileage];
                    lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@",mileage,self.photosExtrasObject.strStockCode];
                    [lblVehicleDetails1 sizeToFit];
                    
                    lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@",@"New",self.photosExtrasObject.strColour];
  
                    
                }
                else
                {
                    [self setAttributedTextForVehicleNameWithFirstText:self.photosExtrasObject.strUsedYear andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:lblVehicleName];
                    
                    [lblVehicleName sizeToFit];
                    
                    NSString *mileage = [NSString stringWithFormat:@"%@",self.photosExtrasObject.strMileage];
                    lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@",mileage,self.photosExtrasObject.strStockCode];
                    [lblVehicleDetails1 sizeToFit];
                    
                    lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@",self.photosExtrasObject.strRegistration,self.photosExtrasObject.strColour];

                
                }
                
                [self setAttributedTextForVehicleDetailsWithFirstText:self.photosExtrasObject.strRetailPrice andWithSecondText:@" | " andWithThirdText:self.photosExtrasObject.strDays forLabel:lblVehicleDetails3];
                
               // lblVehicleName.textColor = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
                
                lblVehicleDetails2.textColor = [UIColor whiteColor];
                
                
                lblVehicleDetails1.frame = CGRectMake(lblVehicleDetails1.frame.origin.x,lblVehicleName.frame.origin.y + lblVehicleName.frame.size.height,lblVehicleDetails1.frame.size.width, lblVehicleDetails1.frame.size.height);
                
                int lineCount = [self lineCountForLabel:lblVehicleDetails1];
                
                lblVehicleDetails2.frame = CGRectMake(lblVehicleDetails2.frame.origin.x,lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+1.0, lblVehicleDetails2.frame.size.width, lblVehicleDetails2.frame.size.height);
                
                lblVehicleDetails3.frame = CGRectMake(lblVehicleDetails3.frame.origin.x,lblVehicleDetails2.frame.origin.y +lblVehicleDetails2.frame.size.height+1.0, lblVehicleDetails3.frame.size.width, lblVehicleDetails3.frame.size.height);
                
                if(lineCount == 1)
                {
                    viewCollectionContainer.frame = CGRectMake(viewCollectionContainer.frame.origin.x,imageVehicle.frame.origin.y + imageVehicle.frame.size.height+3.0, viewCollectionContainer.frame.size.width,viewCollectionContainer.frame.size.height);
                }
                else
                {
                    if(self.isFromVariantList)
                    {
                        viewCollectionContainer.frame = CGRectMake(viewCollectionContainer.frame.origin.x,imageVehicle.frame.origin.y + imageVehicle.frame.size.height+5.0, viewCollectionContainer.frame.size.width,viewCollectionContainer.frame.size.height);
                    }
                    else
                    {
                        viewCollectionContainer.frame = CGRectMake(viewCollectionContainer.frame.origin.x, lblVehicleDetails3.frame.origin.y + lblVehicleDetails3.frame.size.height+1.0, viewCollectionContainer.frame.size.width,viewCollectionContainer.frame.size.height);
                    }
                }
                
               
                tblViewStockVehicleDetails.tableHeaderView = viewHeader;
                
                [collectionViewImages reloadData];
            });
        }
        else
        {
            
            if(self.selectedVehicleIDFromDropdown == 1 || self.selectedVehicleIDFromDropdown == 4)
            {
                [self setAttributedTextForVehicleDetailsWithFirstText:@"" andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:lblVehicleNameNoImages];
                [lblVehicleNameNoImages sizeToFit];
                lblVehicleDetails2NoImages.text = [NSString stringWithFormat:@"%@ | %@",@"New",self.photosExtrasObject.strColour];
            
            }
            else
            {
                [self setAttributedTextForVehicleDetailsWithFirstText:self.photosExtrasObject.strUsedYear andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:lblVehicleNameNoImages];
                [lblVehicleNameNoImages sizeToFit];
                lblVehicleDetails2NoImages.text = [NSString stringWithFormat:@"%@ | %@",self.photosExtrasObject.strRegistration,self.photosExtrasObject.strColour];
                
                
            }
            
            
            NSString *mileage = [NSString stringWithFormat:@"%@",self.photosExtrasObject.strMileage];
            
            lblVehicleDetails1NoImages.text = [NSString stringWithFormat:@"%@ | %@",mileage,self.photosExtrasObject.strStockCode];
            
            
            [self setAttributedTextForVehicleDetailsWithFirstText:self.photosExtrasObject.strRetailPrice andWithSecondText:@" | " andWithThirdText:self.photosExtrasObject.strDays forLabel:lblVehicleDetails3NoImages];
            
            
           // lblVehicleNameNoImages.textColor = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
            
            lblVehicleDetails1NoImages.textColor = [UIColor whiteColor];
            lblVehicleDetails2NoImages.textColor = [UIColor whiteColor];
            
            
            lblVehicleDetails1NoImages.frame = CGRectMake(lblVehicleDetails1NoImages.frame.origin.x, lblVehicleNameNoImages.frame.origin.y + lblVehicleNameNoImages.frame.size.height+4.0, lblVehicleDetails1NoImages.frame.size.width,lblVehicleDetails1NoImages.frame.size.height);
            
            lblVehicleDetails2NoImages.frame = CGRectMake(lblVehicleDetails2NoImages.frame.origin.x, lblVehicleDetails1NoImages.frame.origin.y + lblVehicleDetails1NoImages.frame.size.height+4.0, lblVehicleDetails2NoImages.frame.size.width,lblVehicleDetails2NoImages.frame.size.height);
            
            lblVehicleDetails3NoImages.frame = CGRectMake(lblVehicleDetails3NoImages.frame.origin.x, lblVehicleDetails2NoImages.frame.origin.y + lblVehicleDetails2NoImages.frame.size.height+4.0,lblVehicleDetails3NoImages.frame.size.width,lblVehicleDetails3NoImages.frame.size.height);
            
            
            tblViewStockVehicleDetails.tableHeaderView = ViewHeaderNoImages;
            
        }
        [tblViewStockVehicleDetails reloadData];
        
    }
    
    else if ([elementName isEqualToString:@"SendBrochureResult"])
    {
        if([currentNodeContent isEqualToString:@"Brochure Sent"])
        {
            UIBAlertView *alert;
            alert = [[UIBAlertView alloc] initWithTitle:@"Smart Manager" message:@"Brochure sent successfully" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 
                 if (didCancel)
                 {
                     [self.navigationController popViewControllerAnimated:YES];
                     
                     return;
                 }
             }];
            
            
        }
    }
    
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(!self.isFromVariantList)
    {
    if(arrayOfImages.count > 0)
    {
        [collectionViewVideos reloadData];
        
        if(arrayOfSliderImages.count == 0)
        {
            if(arrVideofromWebService.count == 0)
            {
                collectionViewVideos.frame = viewCollectionContainer.frame;
                collectionViewVideos.hidden = YES;
                collectionViewVideos.backgroundColor = [UIColor greenColor];
                viewCollectionContainer.hidden = YES;
                CGRect frame = viewHeader.frame;
                frame.size = CGSizeMake(viewHeader.frame.size.width, 108.0);
                viewHeader.frame = frame;
            }
            else
            {
                collectionViewVideos.frame = viewCollectionContainer.frame;
                viewCollectionContainer.hidden = YES;
                CGRect frame = viewHeader.frame;
                frame.size = CGSizeMake(viewHeader.frame.size.width, 180.0);
                viewHeader.frame = frame;
                
            }
        }
        else
        {
            
            if(arrVideofromWebService.count == 0)
            {
                
                CGRect frame = viewHeader.frame;
                frame.size = CGSizeMake(viewHeader.frame.size.width, 180.0);
                viewHeader.frame = frame;
            }
            else
            {
                
                collectionViewVideos.frame = CGRectMake(collectionViewVideos.frame.origin.x,viewCollectionContainer.frame.origin.y + viewCollectionContainer.frame.size.height+7.0, collectionViewVideos.frame.size.width, collectionViewVideos.frame.size.height);
                
                CGRect frame = viewHeader.frame;
                frame.size = CGSizeMake(viewHeader.frame.size.width, 255.0);
                viewHeader.frame = frame;
                
            }
        }
        
        SMPhotosListNSObject *photosObject = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:0];
        
            [imageVehicle setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photosObject.imageLink]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        

        tblViewStockVehicleDetails.tableHeaderView = viewHeader;
    }
    else
    {
        [collectionViewVideosWithNoImages reloadData];
        CGFloat height;
        if(arrVideofromWebService.count==0)
        {
            [self setAttributedTextForVehicleDetailsWithFirstText:self.photosExtrasObject.strUsedYear andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:lblVehicleName];
            height = [self heightForVehicleText:lblVehicleName.text];
            height = height + 85;
        }
        else
        {
            height = 188.0f;
        }
        
        CGRect frame = ViewHeaderNoImages.frame;
        frame.size.height = height;
        ViewHeaderNoImages.frame = frame;
        
        
        [imageVehicle setImageWithURL:[NSURL URLWithString:@""]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        tblViewStockVehicleDetails.tableHeaderView = ViewHeaderNoImages;
    }
    
    }
    else
    {
        if(arrayOfImages.count > 0)
        {
        SMPhotosListNSObject *photosObject1 = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:0];
        [imageVehicle setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",photosObject1.imageLink]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        }
    }
    [self hideProgressHUD];
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
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, 280, 0);
        
        [tblViewStockVehicleDetails setContentInset:edgeInsets];
        [tblViewStockVehicleDetails setScrollIndicatorInsets:edgeInsets];
    }];
    
    
}

- (void)keyboardWasHidden:(NSNotification*)textFieldNotification
{
    NSTimeInterval duration = [[[textFieldNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [tblViewStockVehicleDetails setContentInset:edgeInsets];
        [tblViewStockVehicleDetails setScrollIndicatorInsets:edgeInsets];
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

- (IBAction)btnSendBrochureDidClicked:(id)sender
{
    if([SMGlobalClass sharedInstance].isBrochureFlag)
    {
        
        if(!self.isFromVariantList)
        {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                SMStockVehicleDetailController *vehicleDetailVC = [[SMStockVehicleDetailController alloc] initWithNibName:@"SMStockVehicleDetailController" bundle:nil];
                
                vehicleDetailVC.photosExtrasObject = self.photosExtrasObject;
                vehicleDetailVC.isFromVariantList = NO;
                [self.navigationController pushViewController:vehicleDetailVC animated:YES];
            }
            else
            {
                SMStockVehicleDetailController *vehicleDetailVC = [[SMStockVehicleDetailController alloc] initWithNibName:@"SMStockVehicleDetailControlleriPad" bundle:nil];
                
                vehicleDetailVC.photosExtrasObject = self.photosExtrasObject;;
                 vehicleDetailVC.isFromVariantList = NO;
                [self.navigationController pushViewController:vehicleDetailVC animated:YES];
                
            }
        }
        else
        {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                SMStockVehicleDetailController *vehicleDetailVC = [[SMStockVehicleDetailController alloc] initWithNibName:@"SMStockVehicleDetailController" bundle:nil];
                
                vehicleDetailVC.objVariantSelected = self.objVariantSelected;
                 vehicleDetailVC.isFromVariantList = YES;
                [self.navigationController pushViewController:vehicleDetailVC animated:YES];
            }
            else
            {
                SMStockVehicleDetailController *vehicleDetailVC = [[SMStockVehicleDetailController alloc] initWithNibName:@"SMStockVehicleDetailControlleriPad" bundle:nil];
                
                vehicleDetailVC.objVariantSelected = self.objVariantSelected;
                 vehicleDetailVC.isFromVariantList = NO;
                [self.navigationController pushViewController:vehicleDetailVC animated:YES];
        }
    }
    }
    else
    {
        [self loadPopup];
    }
    
    
}

// popup


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
-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
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
    
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

@end
