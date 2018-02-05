//
//  SMCreateBlogViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 18/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMCreateBlogViewController.h"
#import "SMCustomCellForSelectBlogTableViewCell.h"
#import "SMCellOfPlusImage.h"
#import "UIImage+Resize.h"
#import "SMBlogPostTypeObject.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMPreviewBlogViewController.h"
#import "SMSaveBlogDataObject.h"
#import "SMClassOfBlogImages.h"
#import "UIImageView+WebCache.h"
#import "SMCustomColor.h"
#import "SMCreateBlogTableViewCell.h"
#import "SMConstants.h"
#import "Fontclass.h"
#import "UIActionSheet+Blocks.h"
#import "SMUrlConnection.h"
#import "SMAppDelegate.h"
#import "SMCustomPopUpTableView.h"
#import "SMDropDownObject.h"
#import "Reachability.h"

@interface SMCreateBlogViewController ()
{
    NSMutableArray *arrmBlogTypePost;
    BOOL isWifiAvailable;
    Reachability *reachability ;
    NetworkStatus internetStatus;
}


@end

@implementation SMCreateBlogViewController
@synthesize popUpView;
@synthesize blogDelegate;


int imgCount=0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBlogEdited = NO;
        arrayOfImages = [[NSMutableArray alloc]init];

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getAllTheBlogTypesCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue];
    initialSelection = YES;
    isWifiAvailable = NO;
    [self addingProgressHUD];
    arrmBlogTypePost = [[NSMutableArray alloc] init];
    if (!self.isFromCustomerDelivery)
    {
        self.navigationItem.titleView = [SMCustomColor setTitle:(self.isBlogEdited) ? @"Edit Blog" : @"Create Blog"];
    }
    else
    {
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Delivery"];
    }
    
    [self registerNib];
    
    self.txtViewDetails.layer.borderColor   = [[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtViewDetails.layer.borderWidth   = 0.8f;
    self.txtViewDetails.textColor           = [UIColor whiteColor];

    self.dateView.layer.cornerRadius        = 15.0;
    self.dateView.clipsToBounds             = YES;
    self.dateView.layer.borderWidth         = 0.8;
    self.dateView.layer.borderColor         = [[UIColor blackColor] CGColor];
    
    self.viewCollectionImages.layer.borderColor =   [[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.viewCollectionImages.layer.borderWidth = 0.8f;

    self.btnPreview.layer.cornerRadius          = 4.0;
    self.btnSave.layer.cornerRadius             = 4.0;
    
    isExpandable                                = NO;
    isPrioritiesChanged                         = NO;
    
    self.tblViewCreateBlog.tableFooterView      = self.viewDetails;
    collectionCellCount                         = 1;
    
    arrayOfEditBlog = [[NSMutableArray alloc]init];
    
    
    
    
    
    if(self.isBlogEdited)
    {
        [self.btnSave setTitle:@"Update" forState:UIControlStateNormal];
        [self getTheBlogForEditingWithPostID:self.selectedBlogPostTypeID];
        
        //arrayOfImages = self.arrayOfEditImageObjects;
       // [self.collectionViewImages reloadData];
    }
    else
    {
         [self.btnSave setTitle:@"Save" forState:UIControlStateNormal];
    }
    
    [self setCustomFont];
    
    self.multipleImagePicker = [[RPMultipleImagePickerViewController alloc] init];
    self.multipleImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.multipleImagePicker.photoSelectionDelegate = self;

    [SMGlobalClass sharedInstance].totalImageSelected  = 0;
    [SMGlobalClass sharedInstance].isFromCamera = NO;

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                   withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    //[self.popUpView setHidden:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    
    NSPredicate *predicateServerImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];// from server
    NSArray *arrayServerFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateServerImages];
    
    NSPredicate *predicateLocalImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];// from server
    NSArray *arrayLocalFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateLocalImages];
    
    
    
    if ([arrayServerFiltered count] > 0)
    {
        
        if(arrayLocalFiltered.count == 0)
            [SMGlobalClass sharedInstance].totalImageSelected = 0;
        else
            [SMGlobalClass sharedInstance].totalImageSelected = arrayOfImages.count - arrayServerFiltered.count;
        
       
    }
    else
    {
        [SMGlobalClass sharedInstance].totalImageSelected = arrayOfImages.count;
        
    }
    
}


- (void)registerNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tblViewCreateBlog registerNib:[UINib nibWithNibName:@"SMCreateBlogTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMCreateBlogTableViewCellIdentifier"];
        
        [self.tblViewCreateBlog registerNib:[UINib nibWithNibName:@"SMCustomCellForSelectBlogTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMCustomCellForSelectBlogTableViewCell"];

        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImage" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImage"];
        
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImage" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImage"];
    }
    else
    {
        [self.tblViewCreateBlog registerNib:[UINib nibWithNibName:@"SMCreateBlogTableViewCell_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMCreateBlogTableViewCellIdentifier"];

        [self.tblViewCreateBlog registerNib:[UINib nibWithNibName:@"SMCustomCellForSelectBlogTableViewCell_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMCustomCellForSelectBlogTableViewCell"];
        
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImage_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImage"];
        
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImage_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImage"];
    }
}

- (void)setCustomFont
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblHoldImages.font         = [UIFont fontWithName:FONT_NAME size:11.0];
        
        self.txtViewDetails.font        = [UIFont fontWithName:FONT_NAME size:15.0];

        //self.btnSave.titleLabel.font    = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
       // self.btnPreview.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    }
    else
    {
        self.lblHoldImages.font         = [UIFont fontWithName:FONT_NAME size:13.0];
        
        self.txtViewDetails.font        = [UIFont fontWithName:FONT_NAME size:20.0];

       // self.btnSave.titleLabel.font    = [UIFont fontWithName:FONT_NAME_BOLD size:25.0];
       // self.btnPreview.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:25.0];
    }
}

#pragma mark - textField delegate methods

-(void) getBlogDropDown{
     NSArray *array = [[NSArray alloc]initWithObjects:@"UpComing Event",@"Customer Delivery",@"Job Opportunity",@"Community",@"FeedBack",@"Launch",@"Other", nil];
    [arrmBlogTypePost removeAllObjects];
    for(int i=0;i<arrayOfBlogPostType.count;i++)
    {
        SMDropDownObject *objCondition = [[SMDropDownObject alloc] init];
        objCondition.strMakeId = [NSString stringWithFormat:@"%d",i+1];
        objCondition.strMakeName = [array objectAtIndex:i];
        [arrmBlogTypePost addObject:objCondition];
    }
    
}

-(void) setBlogTextField:(UITextField *)textField{
    
    [self getBlogDropDown];
    [self.view endEditing:YES];
    /*************  your Request *******************************************************/
    [textField resignFirstResponder];
    NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
    SMCustomPopUpTableView *popUpView1 = [arrLoadNib objectAtIndex:0];
    
    [popUpView1 getTheDropDownData:arrmBlogTypePost withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
    
    [self.view addSubview:popUpView1];
    
    /*************  your Request *******************************************************/
    
    /*************  your Response *******************************************************/
    
    [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
        NSLog(@"selected text = %@",selectedTextValue);
        NSLog(@"selected ID = %d",selectIDValue);
        textField.text = selectedTextValue;
        
    }];
    
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtFieldStartDate || textField == self.txtFieldEndDate )
    {
        [self.view endEditing:YES];
        
        if(textField == self.txtFieldStartDate )
        {
            self.datePicker.tag = 1;
            self.datePicker.minimumDate = [NSDate date];
            [self loadPopup];
        }
        
        if(textField == self.txtFieldEndDate )
        {
            if([self.txtFieldStartDate.text length]==0)
            {
                SMAlert(KLoaderTitle, @"Please select the active date first");
                return NO;
            }
            
            self.datePicker.tag = 2;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd MMM yyyy"];
            
            NSDate *startDate = [dateFormatter dateFromString:self.txtFieldStartDate.text];
            
            int daysToAdd = 1;
            NSDate *newDate1 = [startDate dateByAddingTimeInterval:60*60*24*daysToAdd];
            
            self.datePicker.minimumDate = newDate1;

            [self loadPopup];
            
        }
        
        return NO;
    }
    return  YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(textField == self.txtFieldTitle)
        [self.txtViewDetails becomeFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //for shifting the scroll view up  of the keypad when the textfield is edited.
    
    
    if(textField == self.txtFieldStartDate || textField == self.txtFieldEndDate )
    {
        [self.txtFieldAuthor resignFirstResponder];
    
    }
    
    svos = self.tblViewCreateBlog.contentOffset;
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:self.tblViewCreateBlog];
    pt = rc.origin;
    pt.x = 0;
    
    pt.y -= 1;
    [self.tblViewCreateBlog setContentOffset:pt animated:YES];
    
    [self.tblViewCreateBlog setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 216.0, 0)];
    
    [self.tblViewCreateBlog scrollRectToVisible:[self.view convertRect:textField.frame fromView:textField.superview] animated:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    svos = self.tblViewCreateBlog.contentOffset;
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:self.tblViewCreateBlog];
    pt = rc.origin;
    pt.x = 0;
    
    pt.y -= 1;
    [self.tblViewCreateBlog setContentOffset:pt animated:YES];
}

#pragma mark- load popup


#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    
    if(gallery == networkGallery)
    {
        int num;
        num = (int)[arrayOfImages count];
        return num;
    }

    return 0;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    SMClassOfBlogImages *imageObject = (SMClassOfBlogImages *) arrayOfImages[index];

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
    SMClassOfBlogImages *imgObj = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:index];
    if (imgObj.isImageFromLocal)
    {
         return  imgObj.imageLink;
    }
    else
    {
        imgObj.originalImagePath = [imgObj.originalImagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *finalString = [NSString stringWithFormat:@"%@%@",[SMWebServices blogImageUrl],imgObj.originalImagePath];
        
        return finalString;
        
    }
    return nil;
}
- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    SMClassOfBlogImages *imgObj = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:index];
    
    if (imgObj.isImageFromLocal)
    {
        return  imgObj.imageLink;
    }
    else
    {
        imgObj.originalImagePath = [imgObj.originalImagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSString *finalString = [NSString stringWithFormat:@"%@%@",[SMWebServices blogImageUrl],imgObj.originalImagePath];
        
        return finalString;
        
    }

}

-(void)loadPopup
{
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (vc != self)
        return;
    
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

#pragma mark - tableView delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isExpandable)
    {
        
        return [arrayOfBlogPostType count]+1;
    }
    else
    {
        return 1;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        return 36.0;
    }
    else
    {
        return 50.0;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=0)
    {
        static NSString *cellIdentifier= @"SMCreateBlogTableViewCellIdentifier";

        SMCreateBlogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
        SMBlogPostTypeObject *obj = (SMBlogPostTypeObject*)[arrayOfBlogPostType objectAtIndex:indexPath.row-1];

        cell.lblName.text = obj.blogPostType;
        
        if (arrayOfBlogPostType.count==indexPath.row)
        {
            [cell.lblUnderline setHidden:YES];
        }
        else
        {
            [cell.lblUnderline setHidden:NO];
        }
        return cell;
    }
    else
    {
        static NSString *cellIdentifier= @"SMCustomCellForSelectBlogTableViewCell";
        
        SMCustomCellForSelectBlogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(self.isFromCustomerDelivery)
        {
            cell.lblBlogPostType.text = @"Customer Delivery";
            cell.imgRightArrow.hidden = YES;
            cell.userInteractionEnabled = NO;
        }
        
        else
        {
            if (isExpandable)
            {
                //cell.imgRightArrow.transform = CGAffineTransformMakeRotation(M_PI);
            }
            else
            {
                //cell.imgRightArrow.transform = CGAffineTransformMakeRotation(2 * M_PI);
            }
            
            cell.imgRightArrow.hidden = NO;
            if(initialSelection)
            {
                cell.lblBlogPostType.text = @"Select blog post type";
                cell.lblBlogPostType.tag = 101;
                cell.lblBlogPostType.delegate = self;
            }
            else
            {
                SMBlogPostTypeObject *obj   = (SMBlogPostTypeObject*)[arrayOfBlogPostType objectAtIndex:selectedIndex];
                selectedBlogType            = obj.blogPostType;
                selectedBlogPostID          = obj.blogPostTypeID;
                cell.lblBlogPostType.text   = obj.blogPostType;

            }
        }
        
        [cell setBackgroundColor:[UIColor blackColor]];
        
                return cell;
    
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (arrayOfBlogPostType.count>0)
    {
        isExpandable = !isExpandable;
        
        [self.view endEditing:YES];
        
       // if ([indexPath row] > 0)  //Change by Dr. Ankit
            initialSelection = NO;
        
        if(indexPath.row==0)
        {
                SMCustomCellForSelectBlogTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [self setBlogTextField:cell.lblBlogPostType];
        }
        else
        {
            selectedIndex = (int)indexPath.row-1;
            
            [self.tblViewCreateBlog reloadData];
        }
    }
    else
    {
        SMAlert(KLoaderTitle, @"Please wait until the types get loaded.");
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [arrayOfImages count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMCellOfPlusImage *cell;
        {
        cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"SMCellOfActualImage" forIndexPath:indexPath];
        
        
         [ cell.btnDelete addTarget:self action:@selector(btnDeleteDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            
         cell.btnDelete.tag = indexPath.row;
        
        
        SMClassOfBlogImages *imageObj = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:indexPath.row];
        
         if(imageObj.isImageFromLocal)
         {
             
             NSString *str = [NSString stringWithFormat:@"%@.jpg", imageObj.imageSelected];
             
             NSString *fullImgName=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
             
             
             
             cell.imgActualImage.image = [UIImage imageWithContentsOfFile:fullImgName];
             
         
         }
         else
         {
             imageObj.thumbImagePath = [imageObj.thumbImagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
             
             [cell.imgActualImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[SMWebServices blogImageUrl],imageObj.thumbImagePath]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
         
         }
            
        isPrioritiesChanged = YES;
    }

    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(94, 74);
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
    
   
   /*
    if([arrayOfImages count]==indexPath.row)
    {
        
        
        [UIActionSheet showInView:self.view
                        withTitle:@"Select the picture"
                cancelButtonTitle:@"Cancel"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"Camera", @"Select from library"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                             
                             switch (buttonIndex)
                             {
                                 case 0:
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
                                         SMAlert(KLoaderTitle, @"Camera Not Available.");
                                         return;
                                     }
                                 }
                                     break;
                                 case 1:
                                 {
                                     picker = [[UIImagePickerController alloc] init];
                                     picker.delegate = self;
                                     picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                     [self presentViewController:picker animated:YES completion:^{}];
                                     
                                 }
                                     
                                 default:
                                     break;
                             }
                         }];
    }
    else*/
    {
    
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        networkGallery.startingIndex = indexPath.row;
        
        SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate.isPresented =  YES;

        [self.navigationController pushViewController:networkGallery animated:YES];
    }

    
    
}




#pragma mark - UIActionSheetDelegate


- (UIImage *)scaleAndRotateImage:(UIImage *)image  {
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat boundHeight;
    
    boundHeight = bounds.size.height;
    bounds.size.height = bounds.size.width;
    bounds.size.width = boundHeight;
    transform = CGAffineTransformMakeScale(-1.0, 1.0);
    transform = CGAffineTransformRotate(transform, M_PI / 2.0); //use angle/360 *MPI
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
    
}


#pragma - mark Selecting Image from Camera and Library

- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImagePickerController *picker2 = picker1;
    
    // Picking Image from Camera/ Library
    [picker2 dismissViewControllerAnimated:NO completion:^{
        picker2.delegate=nil;
        picker2 = nil;
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
    
    
    if (selectedImage.imageOrientation == UIImageOrientationUp)
    {
        
    }
    else if (selectedImage.imageOrientation == UIImageOrientationLeft || selectedImage.imageOrientation == UIImageOrientationRight)
    {
        selectedImage = [self scaleAndRotateImage:selectedImage];
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
            
            SMClassOfBlogImages *imageObject = [[SMClassOfBlogImages alloc]init];
            
            imageObject.imageSelected=[images objectAtIndex:i];
            
            imageObject.isImageFromLocal = YES;
            imageObject.imagePriorityIndex=imgCount;
            imageObject.imageLink = [self loadImagePath:[images objectAtIndex:i]];
            imageObject.imageOriginIndex = -2;
            imageObject.isImageFromCamera = YES;
            imageObject.thumbImagePath = fullPathOftheImage;
            
            [arrayOfImages addObject:imageObject];
            
            
            selectedImage = nil;
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionViewImages reloadData];
            [self.multipleImagePicker.Originalimages removeAllObjects];
            
            
        });
        
        
        
    };
    
    
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1
{
    if([SMGlobalClass sharedInstance].isFromCamera)
        [SMGlobalClass sharedInstance].photoExistingCount--;
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
}



#pragma mark - Multiple Image selection and Image Editing


#pragma mark - MULTIPLE IMAGE SELECTION

- (void)dismissImagePickerControllerForCancel:(BOOL)cancelled
{
    if (self.presentedViewController)
    {
        
        
        [self dismissViewControllerAnimated:NO completion:
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

-(void)sendTheUpdatedImageArray:(NSMutableArray*)updatedArray
{
    arrayOfImages = updatedArray;
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
        //        QBImagePickerController *imagePickerController2 = [[QBImagePickerController alloc] init];
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
                
                for(int i=0; i<[arrayOfImages count];i++)
                {
                    SMClassOfBlogImages *imageObject = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:i];
                    if(imageObject.isImageFromLocal == NO)
                        imageObject.imageOriginIndex = -1;
                    
                }
                

                
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
                    
                    for(int i=0; i<[arrayOfImages count];i++)
                    {
                        SMClassOfBlogImages *imageObject = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:i];
                        if(imageObject.isImageFromLocal == NO)
                            imageObject.imageOriginIndex = -1;
                        
                    }
                    
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
            
            SMAlert(@"Error",KCameraNotAvailable);
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
        UIImage *img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        UIImage *imgThumbnail = [UIImage imageWithCGImage:[asset thumbnail]];
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"ddHHmmssSSS"];
        
        NSString *dateString=[formatter stringFromDate:[NSDate date]];
        
        NSString *imgName =[NSString stringWithFormat:@"%@_asset",dateString];
        
        [self saveImage:img :imgName];
        
        [self.multipleImagePicker addOriginalImages:imgName];
        
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
        [arrayOfImages removeAllObjects]; // check here.
    
    [self.collectionViewImages reloadData];
    
    // Done callback
    self.multipleImagePicker.doneCallback = ^(NSArray *images)
    {
        
        
        
        for(int i=0;i< images.count;i++)
        {
            
                        
            
            SMClassOfBlogImages *imageObject = [[SMClassOfBlogImages alloc]init];
            
            imageObject.imageSelected=[images objectAtIndex:i];
            
            imageObject.isImageFromLocal = YES;
            imageObject.imagePriorityIndex=imgCount;
            imageObject.imageLink = [self loadImagePath:[images objectAtIndex:i]];
            imageObject.imageOriginIndex = i;
            imageObject.isImageFromCamera = NO;
            imageObject.thumbImagePath = fullPathOftheImage;

            [arrayOfImages addObject:imageObject];
            
            selectedImage = nil;
            
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionViewImages reloadData];
            [self.multipleImagePicker.Originalimages removeAllObjects];
            //[self.multipleImagePicker.ThumbnailImages removeAllObjects];
            
        });
        
        
        
    };
    
    [self dismissImagePickerControllerForCancel:NO];
    
    
}

- (void)imagePickerControllerDidCancelled:(QBImagePickerController *)imagePickerController
{
    
    [self dismissImagePickerControllerForCancel:YES];
}



#pragma mark - Cropping Delegate method


- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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

//loading an image

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


#pragma mark - code for dragging image



#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    SMClassOfBlogImages *imgObj = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:fromIndexPath.row];
  
             isPrioritiesChanged = YES;
    
        [arrayOfImages removeObjectAtIndex:fromIndexPath.item];
        [arrayOfImages insertObject:imgObj atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
    return YES;

}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
   
    
    return YES;
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - IBActions

- (IBAction)doneButtonForDatePickerDidClicked:(id)sender
{
    [self dismissPopup];
    
    if(self.datePicker.tag==1)
    {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //[dateFormatter setDateFormat:@"MM/dd/yyyy"];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:self.datePicker.date]];
    
    [self.txtFieldStartDate setText:textDate];

        
    }
    else
    {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:self.datePicker.date]];
        
        
        
        [self.txtFieldEndDate setText:textDate];
        
        
    }
    
    
}

- (IBAction)btnSaveDidClicked:(id)sender
{
    if(!self.isFromCustomerDelivery)
    {
        selectedBlogType = [selectedBlogType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if([selectedBlogType length]==0)
        {
            SMAlert(KLoaderTitle, @"Please select the blog type");
            return;
        }
    }
    
    self.txtFieldTitle.text = [self.txtFieldTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([self.txtFieldTitle.text length]==0)
    {
        
        SMAlert(KLoaderTitle, @"Please enter the title");
        return;
    }
    
    self.txtViewDetails.text = [self.txtViewDetails.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if([self.txtViewDetails.text length]==0)
    {
        
        SMAlert(KLoaderTitle, @"Please enter the details");
        return;
    }
    
    if([self.txtFieldStartDate.text length]==0)
    {
        SMAlert(KLoaderTitle, @"Please enter active date of blog");
        return;
    }
    
    if(!self.btnCheckBoxActive.selected)
    {
        
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"This post is not active. Are you sure you want to save?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        alert.tag = 301;
        
        [alert show];
        return;
    }
    
    [self saveTheBlogPostDataToTheServer];
}

- (IBAction)btnCheckBoxActiveDidClicked:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    sender.selected = !sender.selected;
}

- (IBAction)cancelBtnDidClicked:(id)sender
{
    [self dismissPopup];
}

- (IBAction)btnClearDidClicked:(id)sender
{
    if(self.datePicker.tag == 1)
    {
        self.txtFieldStartDate.text = @"";
    }
    
    else
    {
        self.txtFieldEndDate.text = @"";
    }
    
    self.tblViewCreateBlog.scrollEnabled = YES;
    
}

- (IBAction)btnPreviewDidClicked:(id)sender
{
   
    SMSaveBlogDataObject *blogData = [[SMSaveBlogDataObject alloc]init];
    
    blogData.strTitle = self.txtFieldTitle.text;
    blogData.strAuthorName = self.txtFieldAuthor.text;
    blogData.strBlogDetails = self.txtViewDetails.text;
    blogData.strPostedDate = self.txtFieldStartDate.text;
    blogData.strExpiryDate = self.txtFieldEndDate.text;
    blogData.arrOfImages = arrayOfImages;
    
    
    SMPreviewBlogViewController *previewViewController;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        previewViewController = [[SMPreviewBlogViewController alloc]initWithNibName:@"SMPreviewBlogViewController" bundle:nil];
    }
    else
    {
        previewViewController = [[SMPreviewBlogViewController alloc]initWithNibName:@"SMPreviewBlogViewController_iPad" bundle:nil];
    }
    
    previewViewController.previewDelegate = self;
    previewViewController.previewBlogObj = blogData;
    
    if(self.isBlogEdited)
    {
        previewViewController.isFromEditBlog = YES;
    }
    else
    {
         previewViewController.isFromEditBlog = NO;
    }
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil]];
    
    
    
    if([self lengthOfBlogTypeTextFieldText]==0 || [self.txtFieldTitle.text length]==0 || [self.txtViewDetails.text length]==0 ||[self.txtFieldStartDate.text length]==0 )
    {
        SMAlert(KLoaderTitle, @"Please enter all the mandatory information");
        return;
    }
    else
    {
        [self.navigationController pushViewController:previewViewController animated:YES];
    }
}

- (IBAction)btnDeleteDidClicked:(id)sender
{
    
    deleteButtonTag = (int)[sender tag];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:KLoaderTitle message:@"Are you sure you want to delete?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    alert.tag = 201;
    [alert show];
    
}



#pragma mark - custom methods 

-(void)populateTheBlogPostArray
{
   

    NSArray *array = [[NSArray alloc]initWithObjects:@"UpComing Event",@"Customer Delivery",@"Job Opportunity",@"Community",@"FeedBack",@"Launch",@"Other", nil];
    
    for(int i=0;i<=6;i++)
    {
        SMBlogPostTypeObject *obj1 = [[SMBlogPostTypeObject alloc]init];
        obj1.blogPostTypeID = i;
        obj1.blogPostType = [array objectAtIndex:i];
        
        [arrayOfBlogPostType addObject:obj1];
    
    }
    
}


-(void)SaveTheBlogFromPreview
{
    [self saveTheBlogPostDataToTheServer];

}

-(void)getTheRemainingDaysCount
{
    /*NSString *start = @"2010-09-01";
    NSString *end = @"2010-12-01";
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:start];*/
    
    
    
}



-(NSString*)convertTheGivenStringIntoRequiredFormat:(NSString*)givenDateString andIsUTC:(BOOL)isUTC
{
    // to convert the date string in proper format
    
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *requiredDate1 = [dateFormatter dateFromString:givenDateString];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"dd MMM yyyy"];
        if (isUTC)
        {
            [dateFormatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        }
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:requiredDate1]];
        return textDate;
    }
    @catch (NSException *exception) {
        return @"";
    }
    
}

-(NSString*)dateConsideringTimezoneMilisecFromString:(NSString*)strDate andIsUTC:(BOOL)isUTC
{
    @try {
        NSRange range = [strDate rangeOfString:@":" options: NSBackwardsSearch];
        NSString *dateFirst = [strDate substringToIndex:(range.location)];
        NSString *dateSecond = [strDate substringFromIndex:(range.location+1)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SZ"];
        NSDate *dateReceived = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@%@",dateFirst,dateSecond]];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        if (isUTC)
        {
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        }

        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dateReceived]];
        if (isUTC)
        return textDate;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

-(NSString*)dateConsideringTimezoneFromString:(NSString*)strDate andIsUTC:(BOOL)isUTC
{
    @try {
        NSRange range = [strDate rangeOfString:@":" options: NSBackwardsSearch];
        NSString *dateFirst = [strDate substringToIndex:(range.location)];
        NSString *dateSecond = [strDate substringFromIndex:(range.location+1)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSDate *dateReceived = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@%@",dateFirst,dateSecond]];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        if (isUTC)
        {
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        }

        
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dateReceived]];
        return textDate;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

-(NSString*)dateConsideringMilisecondsFromString:(NSString*)strDate andIsUTC:(BOOL)isUTC
{
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.S"];
        NSDate *dateReceived = [dateFormatter dateFromString:strDate];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        if (isUTC)
        {
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        }

        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dateReceived]];
      
        return textDate;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

-(NSString*)sendTheAppropriateDateFormatFromTheString:(NSString*)strDate andIsUTC:(BOOL)isUTC
{
    
    if ([strDate rangeOfString:@"."].location != NSNotFound && [strDate rangeOfString:@"+"].location != NSNotFound)
    {
        return [self dateConsideringTimezoneMilisecFromString:strDate andIsUTC:isUTC];
        
    }
    else if ([strDate rangeOfString:@"+"].location != NSNotFound)
    {
        
        return [self dateConsideringTimezoneFromString:strDate andIsUTC:isUTC];
        
    }
    else if ([strDate rangeOfString:@"."].location != NSNotFound)
    {
        
        return [self dateConsideringMilisecondsFromString:strDate andIsUTC:isUTC];
    }
    else
    {
       
        return [self convertTheGivenStringIntoRequiredFormat:strDate andIsUTC:isUTC];
    
    }
    
    
}

-(int)lengthOfBlogTypeTextFieldText
{
    if(self.isFromCustomerDelivery)
    {
        return 1;
        
    }
    else
    {
        return [selectedBlogType length];
        
    }

}

#pragma mark - Web service implementation


-(void)getAllTheBlogTypesCorrespondingToUserHash:(NSString*)userHash
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices getAllBlogTypesCorrespondingToUserHash:userHash];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [SMUrlConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
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
             
             //You create an instance of the SMParserForUrlConnection class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
              arrayOfBlogPostType = [[NSMutableArray alloc]init];
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}



-(void)saveTheBlogPostDataToTheServer
{
  
    
    if([self.txtFieldEndDate.text length]==0)
    {
            self.txtFieldEndDate.text = @"";
    
    }
    NSMutableURLRequest *requestURL;
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    if(self.isBlogEdited)
    {
        requestURL=[SMWebServices saveTheBlogDataWithUserHashValue:[SMGlobalClass sharedInstance].hashValue andBlogPostTypeID:selectedBlogPostID andBlogTitle:self.txtFieldTitle.text andBlogDetails:self.txtViewDetails.text andStartDate:self.txtFieldStartDate.text andEndDate:self.txtFieldEndDate.text andAuthor:self.txtFieldAuthor.text andActiveStatus:self.btnCheckBoxActive.isSelected andUserID:[SMGlobalClass sharedInstance].strMemberID andClientID:[SMGlobalClass sharedInstance].strClientID andBlogPostID:self.selectedBlogPostTypeID];
        
                
        
        
    }
    else
    {
        requestURL=[SMWebServices saveTheBlogDataWithUserHashValue:[SMGlobalClass sharedInstance].hashValue andBlogPostTypeID:selectedBlogPostID andBlogTitle:self.txtFieldTitle.text andBlogDetails:self.txtViewDetails.text andStartDate:self.txtFieldStartDate.text andEndDate:self.txtFieldEndDate.text andAuthor:self.txtFieldAuthor.text andActiveStatus:self.btnCheckBoxActive.isSelected andUserID:[SMGlobalClass sharedInstance].strMemberID andClientID:[SMGlobalClass sharedInstance].strClientID andBlogPostID:0];

    
    }
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [SMUrlConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
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
             
             //You create an instance of the SMParserForUrlConnection class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}


-(NSString *) encodeString:(NSString *) encodeString
{
    encodeString = [NSString stringWithFormat:@"<![CDATA[%@]]>",encodeString]; // category method call
    return encodeString;
}
-(void)deleteTheBlogImageWithImageID:(int)imageID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices deleteTheBlogImageCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andBlogPostId:imageID];
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [SMUrlConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             
             //You create an instance of the SMParserForUrlConnection class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}







-(void)uploadTheImagesToTheServerWithPriority:(int)priority
{
    
    SMClassOfBlogImages *imageObj = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:priority];
    
    
   NSMutableURLRequest *requestURL= [SMWebServices saveTheImagesToTheServerWithUserHashValue:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andBlogPostID:[SMGlobalClass sharedInstance].receivedBlogPostID andUserID:[[SMGlobalClass sharedInstance].strMemberID intValue] andPriority:priority+1 andOriginalFileName:[NSString stringWithFormat:@"%@.jpg",imageObj.imageSelected] andEncodedImage:base64Str];
    
    NSLog(@"request URL = %@",requestURL);
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
     SMUrlConnection *connection = [[SMUrlConnection alloc] initWithRequest:requestURL delegate:self];
    connection.arrayIndex = priority;
    [connection start];
    
 
}

-(void)updateTheImagePrioritiesWithPriority:(int)priority andImageID:(int)imageID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices updateBlogImagePriorityCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andBlogImageID:imageID andPriority:priority+1];
        
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [SMUrlConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
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
             
             
             
             
             //You create an instance of the SMParserForUrlConnection class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}


#pragma mark - Parsing delegate methods

// The first method to implement is parser:didStartElement:namespaceURI:qualifiedName:attributes:, which is fired when the start tag of an element is found:

//---when the start of an element is found---

-(void) parser:(SMParserForUrlConnection *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict
{
    
    if([elementName isEqualToString:@"a:BlogType"])
    {
        self.blogPostType = [[SMBlogPostTypeObject alloc]init];
    }
    if([elementName isEqualToString:@"GetBlogResult"])
    {
        self.editObject = [[SMEditSearchObject alloc]init];
    }
    
    if([elementName isEqualToString:@"Table1"])
    {
        
        {
            self.editImageObject = [[SMClassOfBlogImages alloc]init];
        }
        
    }
    
    
}


//The next method to implement is parser:foundCharacters:, which gets fired when the parser finds the text of an element:

-(void)parser:(SMParserForUrlConnection *)parser foundCharacters:(NSString *)string
{
    currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


//Finally, when the parser encounters the end of an element, it fires the parser:didEndElement:namespaceURI:qualifiedName: method:

//---when the end of element is found---

-(void)parser:(SMParserForUrlConnection *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"a:Active"])
    {
        self.blogPostType.activeStatus = currentNodeContent;

    }
    if([elementName isEqualToString:@"a:BlogPostTypeID"])
    {
        self.blogPostType.blogPostTypeID = [currentNodeContent intValue];
        
    }
    if([elementName isEqualToString:@"a:Name"])
    {
        self.blogPostType.blogPostType = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"a:BlogType"])
    {
        [arrayOfBlogPostType addObject:self.blogPostType];
        
        
        
    }
    if([elementName isEqualToString:@"GetBlogTypesResult"])
    {
        if(!self.isBlogEdited)
        {
        NSPredicate *predicateBlogType = [NSPredicate predicateWithFormat:@"blogPostType == %@",@"Customer Delivery"];
        NSArray *arrayFiltered = [arrayOfBlogPostType filteredArrayUsingPredicate:predicateBlogType];
        if ([arrayFiltered count] > 0)
        {
            SMBlogPostTypeObject *obj = (SMBlogPostTypeObject*)[arrayFiltered objectAtIndex:0];
            selectedBlogPostID = obj.blogPostTypeID;
        }
        
        [self.tblViewCreateBlog reloadData];
        }
        
    }
    
    
    
    if([elementName isEqualToString:@"SaveBlogPostResult"])
    {
        NSString *successMessage;
        NSString *faiureMessage;
        
        if(self.isBlogEdited)
        {
            successMessage = @"Blog updated successfully";
            faiureMessage = @"Could not update to the server";
        }
        else
        {
            successMessage = @"Blog saved successfully";
            faiureMessage = @"Could not save to the server";
        }
        
        
        if([currentNodeContent intValue]<=0)
        {
            SMAlert(KLoaderTitle, faiureMessage);
        }
        else
        {
            [SMGlobalClass sharedInstance].receivedBlogPostID = [currentNodeContent intValue];
          
            
            if(!self.isBlogEdited)
            {
                reachability = [Reachability reachabilityForInternetConnection];
                internetStatus = [reachability currentReachabilityStatus];
                
                NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];
                NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
               
                if(arrayFiltered.count>0)
                {
                if (internetStatus != kReachableViaWiFi)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Manager" message:@"You are on a mobile data network. Do you want to:" delegate:self cancelButtonTitle:@"Upload with WiFi" otherButtonTitles:@"Upload Now", nil];
                    alert.tag = 401;
                    [alert show];
                    
                }
                else
                {
                    NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];
                    NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
                    
                    for(int i = 0;i<[arrayFiltered count];i++)
                    {
                        SMClassOfBlogImages *imageObj = (SMClassOfBlogImages*)[arrayFiltered objectAtIndex:i];
                
                        UIImage *imageToUpload = [self loadImage:[NSString stringWithFormat:@"%@.jpg",imageObj.imageSelected]];
                
                        NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
                
                
                        base64Str = [self encodeBase64WithData:imageDataForUpload];

                        [self uploadTheImagesToTheServerWithPriority:i];
                    
                    
                  }
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:KLoaderTitle message:successMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    alert.tag = 101;
                    [alert show];
                }
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:KLoaderTitle message:successMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    alert.tag = 101;
                    [alert show];
                }
                
            }
            else
            {
                
                // this stuff is for deleting the images from the server
                
                for(int k=0;k<[[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted count];k++)
                {
                    SMClassOfBlogImages *deleteImagesObject = (SMClassOfBlogImages*)[[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted objectAtIndex:k];
                    
                    [self deleteTheBlogImageWithImageID:deleteImagesObject.imageID];
                    
                }
                
                // this stuff is for adding the new images to the server
                
                NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];
                NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
                reachability = [Reachability reachabilityForInternetConnection];
                internetStatus = [reachability currentReachabilityStatus];
                if(arrayFiltered.count>0)
                {
                if (internetStatus != kReachableViaWiFi)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Manager" message:@"You are on a mobile data network. Do you want to:" delegate:self cancelButtonTitle:@"Upload with WiFi" otherButtonTitles:@"Upload Now", nil];
                    alert.tag = 401;
                    [alert show];
                    
                }
                else
                {
                    for(int i=0;i<[arrayOfImages count];i++)
                    {
                        
                        SMClassOfBlogImages *imagesObject = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:i];
                        
                        if(imagesObject.isImageFromLocal==YES)
                        {
                            
                            UIImage *imageToUpload = [self loadImage:[NSString stringWithFormat:@"%@.jpg",imagesObject.imageSelected]];
                            
                            NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
                            
                            
                            base64Str = [self encodeBase64WithData:imageDataForUpload];
                            
                            [self uploadTheImagesToTheServerWithPriority:i];
                            
                            
                        }
                        
                        
                        // this stuff is for updating the priorities
                        
                        [self updateTheImagePrioritiesWithPriority:i andImageID:imagesObject.imageID];
                        
                    }
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:KLoaderTitle message:successMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    alert.tag = 101;
                    [alert show];

                }
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:KLoaderTitle message:successMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    alert.tag = 101;
                    [alert show];
                }
                
            }

        }
       
        
    }
    
   //////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    // response for Edit Blog web service
    
    if([elementName isEqualToString:@"a:Active"])
    {
        self.editObject.activeStatus = [currentNodeContent boolValue];
        
    }
    if([elementName isEqualToString:@"a:Author"])
    {
        self.editObject.strAuthor = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"a:BlogPostID"])
    {
        self.editObject.blogPostID = [currentNodeContent intValue];
        //NSLog(@"Blog post id : %d",self.editObject.blogPostID);
        
    }
    if([elementName isEqualToString:@"a:BlogPostTypeID"])
    {
        self.editObject.blogPostTypeID = [currentNodeContent intValue];
        
    }
    if([elementName isEqualToString:@"a:CreatedDate"])
    {
        self.editObject.strCreatedDate = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"a:Details"])
    {
        NSString *strHtml = currentNodeContent;
        
        NSScanner *myScanner;
        NSString *text = nil;
        myScanner = [NSScanner scannerWithString:strHtml];
        
        while ([myScanner isAtEnd] == NO) {
            
            [myScanner scanUpToString:@"<" intoString:NULL] ;
            
            [myScanner scanUpToString:@">" intoString:&text] ;
            
            strHtml = [strHtml stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
        }
        //
        strHtml = [strHtml stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        self.editObject.strDetails = strHtml;
    }
    if([elementName isEqualToString:@"a:EndDate"])
    {
        self.editObject.strEndDate = currentNodeContent;
    }
    if([elementName isEqualToString:@"a:Images"])
    {
        self.editObject.strImageURL = currentNodeContent;
    }
    if([elementName isEqualToString:@"a:IsDeleted"])
    {
        self.editObject.isDeleted = [currentNodeContent boolValue];
    }
    if([elementName isEqualToString:@"a:PublishDate"])
    {
        self.editObject.strPublishDate = currentNodeContent;
    }
    if([elementName isEqualToString:@"a:Title"])
    {
        self.editObject.strTitle = currentNodeContent;
    }
    if([elementName isEqualToString:@"a:cmUserID"])
    {
        self.editObject.userID = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"GetBlogResult"])
    {
        [self getAllTheImagesForEditingFromTheServer];
    }
    
    // response for edit image web service
    
    if([elementName isEqualToString:@"BlogImageID"])
    {
        self.editImageObject.imageID = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"BlogPostID"])
    {
        self.editImageObject.blogPostID = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"Path"])
    {
        self.editImageObject.originalImagePath = currentNodeContent;
    }
    if([elementName isEqualToString:@"OriginalFileName"])
    {
        self.editImageObject.imageOriginalFileName = currentNodeContent ;
    }
    if([elementName isEqualToString:@"thumbpath"])
    {
        self.editImageObject.thumbImagePath = currentNodeContent;
    }
    /*if([elementName isEqualToString:@"TotalCount"])
     {
     
     
     }*/
    if([elementName isEqualToString:@"Table1"])
    {
        
        {
            [arrayOfEditBlog addObject:self.editObject];
            [arrayOfEditImages addObject:self.editImageObject];
        }
        
    }

    if([elementName isEqualToString:@"GetBlogImagesByBlogPostIDResult"])
    {
        
        arrayOfImages = arrayOfEditImages;
        [self.collectionViewImages reloadData];
        
        
        self.txtFieldStartDate.text = [self sendTheAppropriateDateFormatFromTheString:self.self.editObject.strPublishDate andIsUTC:NO];
        
        if([[self sendTheAppropriateDateFormatFromTheString:self.self.editObject.strEndDate andIsUTC:YES] isEqualToString:@"31 Dec 1899"])
        {
            self.txtFieldEndDate.text = @"";
        }
        else
        {
            self.txtFieldEndDate.text = [self sendTheAppropriateDateFormatFromTheString:self.self.editObject.strEndDate andIsUTC:NO];
        }
        
        self.txtFieldAuthor.text = self.self.editObject.strAuthor;
        self.txtFieldTitle.text = self.self.editObject.strTitle;
        self.txtViewDetails.text = self.self.editObject.strDetails;
        
        self.btnCheckBoxActive.selected = self.self.editObject.activeStatus;
        
        for (int i=0;i<[arrayOfBlogPostType count];i++)
        {
            SMBlogPostTypeObject *blogTypeObj = (SMBlogPostTypeObject*)[arrayOfBlogPostType objectAtIndex:i];
            if (self.editObject.blogPostTypeID == blogTypeObj.blogPostTypeID)
            {
                selectedIndex = i;
                initialSelection = NO;
                break;
            }
        }

        if(arrayOfBlogPostType.count>0)
        {
            [self.tblViewCreateBlog reloadData];
            [self hideProgressHUD];
        }
        
     
    }
    
    
}

- (void)parserDidEndDocument:(SMParserForUrlConnection *)parser
{
    [self hideProgressHUD];
}

#pragma mark - base64 image encoding


static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};


- (NSString *)encodeBase64WithData:(NSData *)objData {
    const unsigned char * objRawData = [objData bytes];
    char * objPointer;
    char * strResult;
    
    // Get the Raw Data length and ensure we actually have data
    int intLength = [objData length];
    if (intLength == 0) return nil;
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (char *)calloc((((intLength + 2) / 3) * 4) + 1, sizeof(char));
    objPointer = strResult;
    
    // Iterate through everything
    while (intLength > 2) { // keep going until we have less than 24 bits
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3;
    }
    
    // now deal with the tail end of things
    if (intLength != 0) {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Terminate the string-based result
    *objPointer = '\0';
    
    // Create result NSString object
    NSString *base64String = [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
    
    // Free memory
    free(strResult);
    
    return base64String;
}

#pragma mark - AlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== 101)
    {
        
         [self.blogDelegate updateBlogList];
        
      [self.navigationController popViewControllerAnimated:NO];
      [self.navigationController popViewControllerAnimated:NO];
        
       
        
    }
    
    if(alertView.tag==201)
    {
        
        if(buttonIndex==0)
        {
            
        }
        else
        {
            
            {
                SMClassOfBlogImages *deleteImageObject = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:deleteButtonTag];
                
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
                        
                        for (int i=deleteButtonTag+1;i<[arrayOfImages count];i++)
                        {
                             SMClassOfBlogImages *deleteImageObjectTemp = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:i];
                            
                           deleteImageObjectTemp.imageOriginIndex--;
                            
                        }
                    }
                }
                
                
                isPrioritiesChanged = YES;
                [arrayOfImages removeObjectAtIndex:deleteButtonTag];
                [self.collectionViewImages reloadData];
            }
            
            
        }

        
    
    }
    if(alertView.tag==301)
    {
        if(buttonIndex == 1)
        {
           // self.btnCheckBoxActive.selected = YES;
            //[self btnSaveDidClicked:self.btnSave];
            [self saveTheBlogPostDataToTheServer];
        
        }
        
    }
    if(alertView.tag == 401)
    {
        NSString *successMessage;
        NSString *faiureMessage;
        
        if(self.isBlogEdited)
        {
            successMessage = @"Blog updated successfully";
            faiureMessage = @"Could not update to the server";
        }
        else
        {
            successMessage = @"Blog saved successfully";
            faiureMessage = @"Could not save to the server";
        }
        
       if(buttonIndex == 0)
       {
         NSMutableArray *arrmImageDetailObjects = [[NSMutableArray alloc] init] ;
        NSLog(@"Blog saved successfully");
           NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];
           NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
        for(int i = 0;i<[arrayFiltered count];i++)
        {
            SMClassOfBlogImages *imageObj = (SMClassOfBlogImages*)[arrayFiltered objectAtIndex:i];
            
            NSString *imagePath = [self loadImagePath:[NSString stringWithFormat:@"%@.jpg",imageObj.imageSelected]];
            
             // 1 for blog
            NSDictionary *dictImageDetailObj = [NSDictionary dictionaryWithObjectsAndKeys:imagePath,@"ImagePath",[NSString stringWithFormat:@"%d",i+1],@"ImagePriority",@"1",@"ModuleIdentifier",[NSString stringWithFormat:@"%d",[SMGlobalClass sharedInstance].receivedBlogPostID],@"StockID",imageObj.imageSelected,@"ImageFileName",[SMGlobalClass sharedInstance].strClientID,@"ClientID",[SMGlobalClass sharedInstance].strMemberID,@"MemberID", nil];
            
            [arrmImageDetailObjects addObject:dictImageDetailObj];
            
            
        }
        
        [[SMDatabaseManager theSingleTon] insertImageDetailsInDatabase:arrmImageDetailObjects];
        
        // [[SMDatabaseManager theSingleTon] removeAllRecords];
           
       
        
        
    }
    else
    {
        NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];
        NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
        
        for(int i = 0;i<[arrayFiltered count];i++)
        {
            SMClassOfBlogImages *imageObj = (SMClassOfBlogImages*)[arrayFiltered objectAtIndex:i];
                
            UIImage *imageToUpload = [self loadImage:[NSString stringWithFormat:@"%@.jpg",imageObj.imageSelected]];
                
            NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
                
                
            base64Str = [self encodeBase64WithData:imageDataForUpload];
                
            [self uploadTheImagesToTheServerWithPriority:i];
                
        }
    }
      
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:KLoaderTitle message:successMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        alert.tag = 101;
        [alert show];
    
    }
}



/*- (void) reachabilityChanged:(NSNotification *)notice
{
    
    NSLog(@"!!!!!!!!!! CODE IS CALL NOW !!!!!!!!!!");
    
    NetworkStatus remoteHostStatus = [_reach currentReachabilityStatus];
    
     if (remoteHostStatus == ReachableViaWiFi)
     {
         NSLog(@"**** wifi ****");
     }
   
}*/


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
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey];
}

- (void)connectionDidFinishLoading:(SMUrlConnection *)connection
{
    

    xmlParser = [[SMParserForUrlConnection alloc] initWithData:responseData];
    xmlParser.uniqueIdentifier = connection.arrayIndex;
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];

}

#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPlusImageDidClicked:(id)sender
{
    int RemainingCount;
    
    NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];
    NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
    if ([arrayFiltered count] > 0)
    {
        RemainingCount = (int)arrayOfImages.count-(int)arrayFiltered.count;
    }
    else
        RemainingCount = (int)arrayOfImages.count;
    
    
    
    if(RemainingCount<20)
    {
        
        [UIActionSheet showInView:self.view
                        withTitle:@"Select the picture"
                cancelButtonTitle:@"Cancel"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"Camera", @"Select from library"]
                  didDismissBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                      
                             
                             switch (buttonIndex) {
                                 case 0:
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
                                         SMAlert(KLoaderTitle, @"Camera Not Available.");
                                         return;
                                     }
                                 }
                                     break;
                                 case 1:
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
                                     
                                 default:
                                     break;
                             }
                             
                             
                         }];
        
    }

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


-(void)dismissTheLoader
{
    [imagePickerController dismissTheLoaderAction];
    
    
}


// Newly added
 

-(void)getTheBlogForEditingWithPostID:(int)postID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices getTheBlogToEditCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andBlogPostId:postID];
     NSLog(@"RequestURL = %@",requestURL);
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             //NSLog(@"Error in the conneciton =%@",error);
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             //NSLog(@"Data//////////=%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
             
             
             //NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[data length]);
             
             
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}

-(void)getAllTheImagesForEditingFromTheServer
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices getTheBlogImagesToEditCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andBlogPostId:self.selectedBlogPostTypeID];
   

    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             //NSLog(@"Data//////////=%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
             
             
             //NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[data length]);
             
             
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             arrayOfEditImages = [[NSMutableArray alloc]init];
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
     }];
}






@end
