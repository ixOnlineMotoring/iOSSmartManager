//
//  SMSupportRequestViewController.m
//  Smart Manager
//
//  Created by Ketan Nandha on 10/11/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import "SMSupportRequestViewController.h"
#import "SMCellOfPlusImageCommentPV.h"
#import "Reachability.h"


@interface SMSupportRequestViewController ()
{
    
    NSMutableArray *arrmOfRequestTypes;
    SMDropDownObject *objRequestType;
    NSString *strPlanTaskID;
    int selectedRequestTypeID;
    int remainingUploadCount;
    NSData *fileData;
    
}

@end

@implementation SMSupportRequestViewController

@synthesize collectionViewImages;

NSArray  *arraySelectTeam;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ////////////// Monami remove extra row from dropdown ////////
    self.tableSortItems.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //////////////////// End///////////////////////////
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Support Request"];
    
   // arraySelectTeam = [NSArray arrayWithObjects:@"Google PPC",@"Social Media",@"Websites",@"Email & SMS Campaings",@"Stock",@"Leads",@"Webmasters",@"Accounts",@"User Access", nil];
    
    //arraySelectTeam = [NSArray arrayWithObjects:@"Website Development",@"Website Support",@"Stock",@"Leads",@"Google PPC",@"Social Media",@"Email and SMS Marketing",@"Webmasters",@"Accounts",@"Access, Users and Lead Recipients",@"Cancellations", nil];
    
    arrayOfImages=[[NSMutableArray alloc]init];
    arrForCloudData = [[NSMutableArray alloc]init];
    arrmOfRequestTypes = [[NSMutableArray alloc]init];
    imgCount=0;
    appdelegate=(SMAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.multipleImagePicker = [[RPMultipleImagePickerViewController alloc] init];
    self.multipleImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.multipleImagePicker.photoSelectionDelegate = self;
    [self design];
    [self registerNib];
    [self addingProgressHUD];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [self.view endEditing:YES];
    [_popUpViewForSort removeFromSuperview];
}

- (void)viewDidUnload {
    
    [arrForCloudData removeAllObjects];
    [arrayOfImages removeAllObjects];
    [super viewDidUnload];
}

///////////////// Register xib file for UI Design/////////////////////////////
- (void)registerNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImagePV"];
        
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfSupportRequest" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfSupportRequest"];
        
    }
    else
    {
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImagePV"];
        
       [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfSupportRequest~iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfSupportRequest"];
        
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


#pragma mark - ImageUpload View
/////////Design For Attach Image View/////////////////
-(void)design{


       self.viewDropdownFrame.layer.cornerRadius=15.0;
       self.viewDropdownFrame.clipsToBounds  = YES;
       self.viewDropdownFrame.layer.borderWidth=1.5;
       self.viewDropdownFrame.layer.borderColor=[[UIColor blackColor] CGColor];
    _vwImageViewUpload.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    _vwImageViewUpload.layer.borderWidth= 0.8f;
}

#pragma mark - Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
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
            
            
            
            
            //for(int i=0;i< images.count;i++)
            //{
                
                SMPhotosListNSObject *imageObject = [[SMPhotosListNSObject alloc]init];
                imageObject.strimageName=[images objectAtIndex:0];
            
                imageObject.isImageFromLocal = YES;
                imageObject.imagePriorityIndex=imgCount;
                imageObject.imageLink = [self loadImagePath:[images objectAtIndex:0]];
                imageObject.imageOriginIndex = -2;
                imageObject.isImageFromCamera = YES;
                imageObject.strExtensionFromCloud = @"NotDoc";
                [arrayOfImages addObject:imageObject];
                
                selectedImage = nil;
                
            //}
            NSLog(@"%lu",(unsigned long)[arrayOfImages count]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionViewImages reloadData];
                [self.multipleImagePicker.Originalimages removeAllObjects];
                
                
            });
            
        };
}

#pragma mark - Dismiss

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
    NSLog(@"%lu",(unsigned long)[assetsArray count]);
    
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
    [arrayOfImages addObjectsFromArray:arrForCloudData];
    NSLog(@"%lu",(unsigned long)[arrayOfImages count]);
    //[self.collectionViewImages reloadData];
    
    
    // Done callback
    self.multipleImagePicker.doneCallback = ^(NSArray *images)
    {
        
        for(int i=0;i< images.count;i++)
        {
            
            SMPhotosListNSObject *imageObject = [[SMPhotosListNSObject alloc]init];
            imageObject.strimageName=[images objectAtIndex:i];
            imageObject.isImageFromLocal = YES;
            imageObject.imageOriginIndex = i;
            imageObject.strExtensionFromCloud = @"NotDoc";
            imageObject.imgThumbnailFromCloud = nil;
            imageObject.imagePriorityIndex=imgCount;
            
            imageObject.imageLink = [self loadImagePath:[images objectAtIndex:i]];
            //imageObject.imageLink = fullPathOftheImage;
            imageObject.isImageFromCamera = NO;
            
            [arrayOfImages addObject:imageObject];
            NSLog(@"fileNameOfImage = %@",imageObject.strimageName);
            selectedImage = nil;
            
            
        }
        
        NSLog(@"%lu",(unsigned long)[arrayOfImages count]);
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
    [SMGlobalClass sharedInstance].isTapOnCancel = YES;
    NSLog(@"%lu",(unsigned long)arrayOfImages.count);
   // if(arrayOfImages.count>0)
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
//            //arrayOfImages = [NSMutableArray arrayWithArray:finalFilteredArray];
//        }
//        else
//        {
//            [arrayOfImages removeAllObjects]; // check here.
//        }
//        [arrForCloudData removeAllObjects];
//       //[arrayOfImages addObjectsFromArray:arrForCloudData];
//        
//        NSLog(@"%lu",(unsigned long)[arrayOfImages count]);
//        [self.collectionViewImages reloadData];
//        
//    }
     [self.collectionViewImages reloadData];
    [self dismissImagePickerControllerForCancel:YES];
    
//    for (UINavigationController *view in self.navigationController.viewControllers)
//    {
//        
//        if ([view isKindOfClass:[RPMultipleImagePickerViewController class]])
//        {
//            [self.navigationController popViewControllerAnimated:NO];
//            
//        }
//    }
    
}
////////////// Save the Image to document directory
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

-(NSString *)writeDataToDocuments:(NSData *)data withFilename:(NSString *)filename{
    NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [[NSString alloc] initWithString: [docsPath stringByAppendingPathComponent:filename]];
    [data writeToFile:filePath atomically:YES];
    return filePath;
}


- (NSString*)loadImagePath:(NSString*)imageName1 {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    
    return [NSString stringWithFormat:@"%@.jpg",fullPathOfImage];
    
}
- (NSString*)pdfsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    return [documentsDirectory stringByAppendingPathComponent:@"/DocumentRecord"];
    
}


- (UIImage*)loadImage:(NSString*)imageName1 {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    
    return [UIImage imageWithContentsOfFile:fullPathOfImage];
    
}


#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if(textField == self.txtfieldTeamList)
    {
        isTextFieldSortBy = YES;
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        [self loadTheRequestType];
    
        return NO;
    }
    return YES;
}
#pragma mark -
#pragma mark - UITextView Delegate

- (BOOL) textView: (UITextView*) textView
shouldChangeTextInRange: (NSRange) range
  replacementText: (NSString*) text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark - Load/Hide Drop Down For Team

-(void)loadPopUpView
{
    
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (vc != self)
        return;
    
    [self.popUpViewForSort setFrame:[UIScreen mainScreen].bounds];
    [self.popUpViewForSort setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [self.popUpViewForSort setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self.popUpViewForSort];
    [self.popUpViewForSort setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [self.popUpViewForSort setAlpha:0.75];
         [self.popUpViewForSort setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [self.popUpViewForSort setAlpha:1.0];
              [self.popUpViewForSort setTransform:CGAffineTransformIdentity];
              
          }
                          completion:^(BOOL finished)
          {
          }];
         
     }];
}

-(void) hidePopUpView
{
    [_popUpViewForSort setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popUpViewForSort];
    [UIView animateWithDuration:0.1 animations:^{
        [_popUpViewForSort setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [_popUpViewForSort setAlpha:0.3];
              [_popUpViewForSort setTransform:CGAffineTransformMakeScale(0.9,0.9)];
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   [_popUpViewForSort setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [_popUpViewForSort removeFromSuperview];
                   [_popUpViewForSort setTransform:CGAffineTransformIdentity];
               }];
          }];
     }];
}

- (IBAction)btnCancelDidClicked:(id)sender
{
    
    [self hidePopUpView];
    
}

#pragma mark - UITableViewDataSource

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    float maxHeigthOfView = [self view].frame.size.height/2+50.0;
    float totalFrameOfView = 0.0f;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        if(isTextFieldSortBy)
            totalFrameOfView = 32+([arrmOfRequestTypes count]*43);
        else
            totalFrameOfView = 32+([arrmOfRequestTypes count]*43);
    }
    else
    {
        if(isTextFieldSortBy)
            totalFrameOfView = 45+([arrmOfRequestTypes count]*60);
        else
            totalFrameOfView = 45+([arrmOfRequestTypes count]*60);
    }
    
    if (totalFrameOfView <= maxHeigthOfView)
    {
        //Make View Size smaller, no scrolling
        self.viewDropdownFrame.frame = CGRectMake(self.viewDropdownFrame.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, self.viewDropdownFrame.frame.size.width, totalFrameOfView);
    }
    else
    {
        self.viewDropdownFrame.frame = CGRectMake(self.viewDropdownFrame.frame.origin.x, maxHeigthOfView/2-22.0, self.viewDropdownFrame.frame.size.width, maxHeigthOfView);
    }

    
    return [arrmOfRequestTypes count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    SMDropDownObject *individualObj = (SMDropDownObject*)[arrmOfRequestTypes objectAtIndex:indexPath.row];
    cell.textLabel.text = individualObj.strMakeName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 40.0 : 60.0;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    SMDropDownObject *selectedObj = (SMDropDownObject*)[arrmOfRequestTypes objectAtIndex:indexPath.row];
    _txtfieldTeamList.text = selectedObj.strMakeName;
    selectedRequestTypeID = selectedObj.strMakeId.intValue;
    
    [self hidePopUpView];
}

#pragma mark - Plus Button Clicked methods
- (IBAction)btnAttachmentClicked:(id)sender {
    
    [SMGlobalClass sharedInstance].isTapOnCancel = NO;
    NSLog(@"Array Count ========= %lu",(unsigned long)[arrayOfImages count]);
    UIButton *button;
    if([arrayOfImages count] == 20){
    
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Maximum 20 attachments per upload."
                                                                       message:@"20 attachments already selected."
                                                                preferredStyle:UIAlertControllerStyleAlert]; // 1
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    
    }else{
        UIAlertController *alert;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    alert = [UIAlertController alertControllerWithTitle:@"Select Attachment Type:"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
        }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
            alert = [UIAlertController alertControllerWithTitle:@"Select Attachment Type:"
                                                        message:@""
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
        }
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"Image"
    style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self datafromMobile];
                                                          }]; // 2
    UIAlertAction *documentAction = [UIAlertAction actionWithTitle:@"Document"
    style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self dataFromCloud];
                                                           }]; // 3
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               
                                                           }]; // 3
    
    [alert addAction:imageAction]; // 4
    [alert addAction:documentAction]; // 5
    [alert addAction:cancelAction];
    
    //[self presentViewController:alert animated:YES completion:nil];
    [alert setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [alert
                                                         popoverPresentationController];
        popPresenter.sourceView = self.view;
        popPresenter.sourceRect = self.view.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(actionSheetPhotos){
    
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
                    
                    SMAlert(@"Error", KCameraNotAvailable);
                    
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
                break;
            case 2:
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
    
            }
                break;
            default:
                break;
        }
    }
    else{
    switch (buttonIndex) {
        case 0:
            [self datafromMobile];
            break;
        case 1:
            [self dataFromCloud];
            break;
        default:
            break;
    }
    }
}

/////////////// Select Image Option
-(void) datafromMobile{

    int RemainingCount;
    
    NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];
    NSLog(@"%@",predicateImages);
    NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
    if ([arrayFiltered count] > 0)
    {
        RemainingCount = (int)arrayOfImages.count-(int)arrayFiltered.count;
    }
    else
        RemainingCount =(int)arrayOfImages.count;
    
    if(RemainingCount<20)
    {
        
        UIAlertController *alert;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            alert = [UIAlertController alertControllerWithTitle:@"Select Image:"
                                                        message:@""
                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            alert = [UIAlertController alertControllerWithTitle:@"Select Image:"
                                                        message:@""
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
        }
        
        
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take From Camera"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [self openCamera];
                                                              }]; // 2
        UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Select From Gallery"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [self openGallery];
                                                               }]; // 3
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  ;
                                                               }]; // 3
        
        [alert addAction:cameraAction]; // 4
        [alert addAction:libraryAction]; // 5
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }

}
/////////////// Select Document From Cloud
-(void)dataFromCloud{
    
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.data"]
                                                                                                            inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];
    
}

///////////////////Document Picker Delegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    if (controller.documentPickerMode == UIDocumentPickerModeImport) {
        
        
        isfromDocument = YES;
        
        NSString *stringURL =  url.absoluteString;
        NSURL *url = [NSURL URLWithString:stringURL];
        NSString *path = [url path];
        NSString *extension = [path pathExtension];
        nameOfFileFromCloud = url.lastPathComponent;
        NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        NSError *error = nil;
        [coordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
            fileData = [NSData dataWithContentsOfURL:newURL];
            
            // Do something
        }];
        if (error) {
            // Do something else
        }
        
        SMPhotosListNSObject *imageObject = [[SMPhotosListNSObject alloc]init];
        imageObject.urlFromCloud = url;
        imageObject.imageOriginIndex = -3;
        NSLog(@"******************URL %@",url);
       //  NSLog(@"******************DOC fileData %@",fileData);
        
        // code for getting base64 string
        
        
       /* for(int i = 0;i<[arrayOfImages count];i++)
        {
            SMPhotosListNSObject *imagesObject = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:i];
            if(imagesObject.isImageFromLocal==YES)
            {
                UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imagesObject.strimageName];
                NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
                
                base64Str = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
                [self uploadTheCommentImagesToTheServerWithPriority:i];
            }
        }*/
        
        
            if ([extension isEqualToString:@"pdf"]){
            
            CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)url);
            CGPDFPageRef page;
            
            
            CGRect aRect = CGRectMake(0, 0, 70, 100); // thumbnail size
            UIGraphicsBeginImageContext(aRect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            
            
            NSUInteger totalNum = CGPDFDocumentGetNumberOfPages(pdf);
            
            for(int i = 0; i < totalNum; i++ ) {
                
                
                CGContextSaveGState(context);
                CGContextTranslateCTM(context, 0.0, aRect.size.height);
                CGContextScaleCTM(context, 1.0, -1.0);
                
                CGContextSetGrayFillColor(context, 1.0, 1.0);
                CGContextFillRect(context, aRect);
                
                
                // Grab the first PDF page
                page = CGPDFDocumentGetPage(pdf, i + 1);
                CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFMediaBox, aRect, 0, true);
                // And apply the transform.
                CGContextConcatCTM(context, pdfTransform);
                
                CGContextDrawPDFPage(context, page);
                
                // Create the new UIImage from the context
                thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
                
                //Use thumbnailImage (e.g. drawing, saving it to a file, etc)
                
                CGContextRestoreGState(context);
                
            }
            UIGraphicsEndImageContext();
            CGPDFDocumentRelease(pdf);
            
            
            imageObject.strimageName= nameOfFileFromCloud;
            imageObject.isImageFromLocal = YES;
            imageObject.strExtensionFromCloud = @"doc";
            imageObject.imagePriorityIndex=imgCount;
            imageObject.dataFromiCloudFile = fileData;
            //imageObject.imageLink = [self writeDataToDocuments:fileData withFilename:nameOfFileFromCloud];
            //imageObject.imageLink = fullPathOftheImage;
            imageObject.isImageFromCamera = NO;
            imageObject.imgThumbnailFromCloud = thumbnailImage;
            
            if([arrForCloudData count] == 0){
                [arrayOfImages addObject:imageObject];
                [arrForCloudData addObject:imageObject];
            }else{
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"urlFromCloud", imageObject.urlFromCloud];
            NSArray *filteredArray = [arrForCloudData filteredArrayUsingPredicate:predicate];
                if (filteredArray.count > 0){
                imageObject = [filteredArray objectAtIndex:0];
                }else{
            [arrayOfImages addObject:imageObject];
            [arrForCloudData addObject:imageObject];
                }
            }
            [collectionViewImages reloadData];
            
        }else if (([extension isEqualToString:@"doc"]) || ([extension isEqualToString:@"docx"]) || ([extension isEqualToString:@"txt"])){
            
            imageObject.strimageName= nameOfFileFromCloud;
            imageObject.isImageFromLocal = YES;
            imageObject.strExtensionFromCloud = @"doc";
            imageObject.imagePriorityIndex=imgCount;
            imageObject.dataFromiCloudFile = fileData;
           // imageObject.imageLink = [self writeDataToDocuments:fileData withFilename:nameOfFileFromCloud];
            //imageObject.imageLink = fullPathOftheImage;
            imageObject.isImageFromCamera = NO;
            imageObject.imgThumbnailFromCloud = [UIImage imageNamed:@"doc"];
            
            if([arrForCloudData count] == 0){
                [arrayOfImages addObject:imageObject];
                [arrForCloudData addObject:imageObject];
            }else{
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"urlFromCloud", imageObject.urlFromCloud];
                NSArray *filteredArray = [arrForCloudData filteredArrayUsingPredicate:predicate];
                if (filteredArray.count > 0){
                    imageObject = [filteredArray objectAtIndex:0];
                }else{
                    [arrayOfImages addObject:imageObject];
                    [arrForCloudData addObject:imageObject];
                }
            }
            [collectionViewImages reloadData];
        }
        else if (([extension isEqualToString:@"csv"]) || ([extension isEqualToString:@"xlsx"])){
            
            imageObject.strimageName= nameOfFileFromCloud;
            imageObject.isImageFromLocal = YES;
            imageObject.strExtensionFromCloud = @"doc";
             imageObject.dataFromiCloudFile = fileData;
            imageObject.imagePriorityIndex=imgCount;
           // imageObject.imageLink = [self writeDataToDocuments:fileData withFilename:nameOfFileFromCloud];
            //imageObject.imageLink = fullPathOftheImage;
            imageObject.isImageFromCamera = NO;
            imageObject.imgThumbnailFromCloud = [UIImage imageNamed:@"csv"];
            
            if([arrForCloudData count] == 0){
                [arrayOfImages addObject:imageObject];
                [arrForCloudData addObject:imageObject];
            }else{
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"urlFromCloud", imageObject.urlFromCloud];
                NSArray *filteredArray = [arrForCloudData filteredArrayUsingPredicate:predicate];
                if (filteredArray.count > 0){
                    imageObject = [filteredArray objectAtIndex:0];
                }else{
                    [arrayOfImages addObject:imageObject];
                    [arrForCloudData addObject:imageObject];
                }
            }
            [collectionViewImages reloadData];
        }
    }
}

//////////////// Take Pic From Camera
-(void)openCamera{

    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        isfromDocument = NO;
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

//////////////// Take Pic From Gallery
-(void)openGallery{
    
    isfromDocument = NO;
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

-(void) uploadTheDocsAndImagesToServer{
    
    NSString *base64ImageString;
    NSString *base64DocString;
    
    for(int i=0;i<[arrayOfImages count];i++)
    {
        
        SMPhotosListNSObject *imagesObject = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:i];
        
        if([imagesObject.strExtensionFromCloud isEqualToString:@"doc"])
        {
          // base64DocString = [imagesObject.dataFromiCloudFile
                                     //     base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
             base64DocString = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imagesObject.dataFromiCloudFile];
            
            [self saveTheSupportDocsWithBase64String:base64DocString andFileName:imagesObject.strimageName andPlanTaskID:strPlanTaskID.intValue];
            
        }
        else
        {
            UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imagesObject.strimageName];
            NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
            
            base64ImageString = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
           // base64ImageString = [imageDataForUpload
                                       //   base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [self saveTheSupportDocsWithBase64String:base64ImageString andFileName:[NSString stringWithFormat:@"%@.jpg",imagesObject.strimageName] andPlanTaskID:strPlanTaskID.intValue];
            
            
        }
        
        
       
        
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
    
    if (collectionView==collectionViewImages)
    {
//        self.lblPhotoCount.text = [NSString stringWithFormat:@"%d",(int)[arrayOfImages count]];
        return [arrayOfImages count];
    }
    
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.collectionViewImages)
    {
        SMCellOfPlusImageCommentPV *cellImages;
        
        {
cellImages = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMCellOfSupportRequest" forIndexPath:indexPath];
            
            [cellImages.btnDelete addTarget:self action:@selector(btnDeleteImageDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            cellImages.btnDelete.tag = indexPath.row;
            
            
            SMPhotosListNSObject *imageObj = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:indexPath.row];//was crashing here.....
            
            if([imageObj.strExtensionFromCloud isEqualToString:@"NotDoc"]){
            
            
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
            }else{
            
                cellImages.imgActualImage.image = imageObj.imgThumbnailFromCloud;
            }
            
            
            //isPrioritiesImageChanged = YES;
        }
        return cellImages;
    }
   
    return nil;
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
//    if (collectionView==collectionViewImages)
//    {
//        
//        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
//        networkGallery.startingIndex = indexPath.row;
//        
//        appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
//        appdelegate.isPresented =  YES;
//        [self.navigationController pushViewController:networkGallery animated:YES];
//    }
 
}

//////////////////// Alert For Delete

#pragma - Delete Clicked

-(IBAction)btnDeleteImageDidClicked:(id)sender1
{
    UIButton *button=(UIButton *)sender1;
    deleteButtonTag = button.tag;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:KLoaderTitle
                                                                   message:KDeleteImageAlert
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Yes"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [self deleteImage];
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"No"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"Hello");
                                                           }]; // 3
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

///////////////Click to delete image/doc
-(void)deleteImage{

        SMPhotosListNSObject *deleteImageObject = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:deleteButtonTag];
    NSLog(@"%@",deleteImageObject.urlFromCloud);
    for (int i=0;i<[arrForCloudData count];i++){
    
        if([arrForCloudData containsObject:deleteImageObject]){
            [arrForCloudData removeObjectAtIndex:i];
        }
        NSLog(@"%lu",(unsigned long)[arrForCloudData count]);
    
    }
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
                    SMPhotosListNSObject *deleteImageObjectTemp = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:i];
                    deleteImageObjectTemp.imageOriginIndex--;
                }
            }
        }
        
        [arrayOfImages removeObjectAtIndex:deleteButtonTag];
        [self.collectionViewImages reloadData];
    

}

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

#pragma mark - Webservice integration

-(void)loadTheRequestType
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    NSMutableURLRequest *requestURL=[SMWebServices loadRequestType:[SMGlobalClass sharedInstance].hashValue];
    
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
                                                        SMAlert(@"Error",
                                                                error.localizedDescription);
                                                        [self hideProgressHUD];
                                                        return;
                                                    });
                                                });
                                                
                                            }
                                            else
                                            {
                                                
                                                xmlParser = [[NSXMLParser alloc] initWithData:data];
                                                [xmlParser setDelegate:self];
                                                [xmlParser setShouldResolveExternalEntities:YES];
                                                [xmlParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
}

-(void)saveTheSupportRequest
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    NSMutableURLRequest *requestURL=[SMWebServices logNewSupportRequestWith:[SMGlobalClass sharedInstance].hashValue andRequestType:selectedRequestTypeID andRequestTitle:self.txtFieldRequestTitle.text andRequestDetails:self.txtvwRequest.text];
    
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
                                                [xmlParser setDelegate:self];
                                                [xmlParser setShouldResolveExternalEntities:YES];
                                                [xmlParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
}

-(void)saveTheSupportDocsWithBase64String:(NSString*) base64String andFileName:(NSString*) filename andPlanTaskID:(int) planTaskID
{
    NSURLSession *dataTaskSession ;
   // [HUD show:YES];
   // HUD.labelText = KLoaderText;
    
    NSMutableURLRequest *requestURL=[SMWebServices saveTheSupportRequestDocumentsWith:[SMGlobalClass sharedInstance].hashValue andbase64DocString:base64String andFileName:filename andPlanTaskID:planTaskID];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    remainingUploadCount--;
    
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
    
    if([elementName isEqualToString:@"RequestTypeName"])
    {
        objRequestType = [[SMDropDownObject alloc] init];
        objRequestType.strMakeId = [attributeDict valueForKey:@"RequestTypeID"];
        
    }
    
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"RequestTypeName"])
    {
        objRequestType.strMakeName = currentNodeContent;
        [arrmOfRequestTypes addObject:objRequestType];
        
    }
    if([elementName isEqualToString:@"PlanTaskID"])
    {
        strPlanTaskID = currentNodeContent;
    }
    if([elementName isEqualToString:@"ListRequestTypeResult"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do stuff to UI
            // self.objSMSynopsisResult.strVINNo = @"VNKKJ0D390A234522";
            [self.tableSortItems reloadData];
            [self loadPopUpView];
            //oldTableViewHeight = tblSMSendOffer.contentSize.height;
            
            [HUD hide:YES];
        });
        
    }
    if([elementName isEqualToString:@"LogNewSupportRequestResult"])
    {
        NSLog(@"Details Saved = %@",strPlanTaskID);
        
        remainingUploadCount = (int)arrayOfImages.count;
        
        if(remainingUploadCount > 0)
         [self uploadTheDocsAndImagesToServer];
        else
          [self showTheSuccessAlert];
        
    }
    if([elementName isEqualToString:@"NewSupportRequestDocResult"])
    {
        if(remainingUploadCount == 0)
        {
            NSLog(@"Data and all docs saved successfully....");
            
            [self showTheSuccessAlert];
            
        }
        
    }
    
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    
}

-(void) showTheSuccessAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Smart Manager."
                                                                   message:[NSString stringWithFormat:@"Task successfully created - your reference is #%@",strPlanTaskID]
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               
                                                               [HUD hide:YES];
                                                           });
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                           
                                                       }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [HUD hide:YES];
    });
    
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

- (IBAction)btnSubmitDidClicked:(id)sender {
    
    [self.view endEditing:YES];
    if([self validate] == YES)
        [self saveTheSupportRequest];
}

- (BOOL)validate
{
    if (self.txtfieldTeamList.text.length == 0)
    {
        SMAlert(KLoaderTitle, @"Please select the Request Type.");
        
        return NO;
    }
    else if (_txtFieldRequestTitle.text.length == 0)
    {
        SMAlert(KLoaderTitle, @"Please enter the Request Title");
        
        return NO;
    }
    else if (_txtvwRequest.text.length == 0)
    {
        SMAlert(KLoaderTitle, @"Please enter the Request Details");
        
        return NO;
    }
    else
        return YES;
}



@end
