//
//  SMStockAuditVinDetailsViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 19/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMStockAuditVinDetailsViewController.h"
#import "SMCustomDynamicCell.h"
#import "SMCellOfPlusImage.h"
#import "SMGlobalClass.h"
#import "SMVehicleStockAuditList.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMCustomerScanViewController.h"

@interface SMStockAuditVinDetailsViewController ()
{
    UILabel *progress;
    
    int currMinute;
    int currSeconds;


}




@end

@implementation SMStockAuditVinDetailsViewController
@synthesize timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTheTitleForScreen];
    [self addingProgressHUD];

    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImage" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImage"];
        
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImage" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImage"];
    }
    else
    {
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImage_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImage"];
        
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImage_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImage"];
    }

    
    
    
    arrayOfImages = [[NSMutableArray alloc]init];
    
    self.multipleImagePicker = [[RPMultipleImagePickerViewController alloc] init];
    self.multipleImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.multipleImagePicker.photoSelectionDelegate = self;
    
    [SMGlobalClass sharedInstance].totalImageSelected  = 0;
    [SMGlobalClass sharedInstance].isFromCamera = YES;

    self.lblAlertText.font = [UIFont fontWithName:FONT_NAME size:11.0];
    self.lblCountDown.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    [self.lblCountDown setText:@"Time remaining : 3:00"];
    currMinute=3;
    currSeconds=00;

    [self startTimer];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(pushBackToViewController)];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    //[self.timer invalidate];
}

-(void)pushBackToViewController
{
    SMVehicleStockAuditList *selectType;
    
        for (UINavigationController *view in self.navigationController.viewControllers)
    {
        //when found, do the same thing to find the MasterViewController under the nav controller
        if ([view isKindOfClass:[SMVehicleStockAuditList class]])
        {
            selectType = (SMVehicleStockAuditList*)view;
            
        }
    }
    [self.navigationController popToViewController:selectType animated:YES];
    
    //[self.navigationController popViewControllerAnimated:YES];
    return;
    
    
}




#pragma mark - Table View Delegates And Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier3= @"SMCustomDynamicCell";
    
    SMCustomDynamicCell     *dynamicCell;
    
    
        UILabel *lblTitle;
        UILabel *lblValue;
    
        CGFloat height = 0.0f;
    
    
        if (dynamicCell == nil)
        {
            dynamicCell = [[SMCustomDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
            
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(4,4,101,21)];
                lblValue = [[UILabel alloc] initWithFrame:CGRectMake(114,4,190,height)];
                lblTitle.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
                lblValue.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
               
                
            }
            else
            {
                lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(8,4,125,26)];
                lblValue = [[UILabel alloc] initWithFrame:CGRectMake(150,4,500,height)];
                lblTitle.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
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
                lblTitle.text = @"Make";
                lblValue.text = self.VINLookupObject.Make;
            }
                break;
            case 1:
            {
                
                lblTitle.text = @"Model";
                lblValue.text = self.VINLookupObject.Model;
                
            }
                break;
            case 2:
            {
                lblTitle.text = @"Color";
                lblValue.text = self.VINLookupObject.Colour;
                
                
            }
                break;
            case 3:
            {
                lblTitle.text = @"Reg#";
                lblValue.text = self.VINLookupObject.Registration;
            }
                break;
            case 4:
            {
                
                lblTitle.text = @"Engine#";
                lblValue.text = self.VINLookupObject.EngineNo;
                
                
            }
                break;
            case 5:
            {
                lblTitle.text = @"VIN#";
                lblValue.text = self.VINLookupObject.VIN;
            }
                break;
            case 6:
            {
                lblTitle.text = @"License#";
                lblValue.text = self.VINLookupObject.Entry4;
                
            }
                break;
            case 7:
            {
                lblTitle.text = @"Expires";
                lblValue.text = self.VINLookupObject.DateExpires;
                
            }
                break;
            case 8:
            {
                lblTitle.text = @"Geo Location";
               lblValue.text = self.VINLookupObject.geoLocationAddress;
                
            }
                break;
                
            default:
                break;
        }
        
        
        lblTitle.textColor = [UIColor whiteColor];
        
        lblValue.textColor = [UIColor whiteColor];
        lblValue.numberOfLines = 0;
        [lblValue sizeToFit];
        
        dynamicCell.backgroundColor = [UIColor blackColor];
        
        return dynamicCell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
            CGFloat height = 0.0f;
            
            switch (indexPath.row)
            {
                case 0:
                {
                    height = [self heightForText:self.VINLookupObject.Make];
                }
                    break;
                case 1:
                {
                    height = [self heightForText:self.VINLookupObject.Model];
                }
                    break;
                case 2:
                {
                    height = [self heightForText:self.VINLookupObject.Colour];
                }
                    break;
                case 3:
                {
                    height = [self heightForText:self.VINLookupObject.Registration];
                }
                    break;
                case 4:
                {
                    height = [self heightForText:self.VINLookupObject.EngineNo];
                }
                    break;
                case 5:
                {
                    height = [self heightForText:self.VINLookupObject.VIN];
                }
                    break;
                case 6:
                {
                    height = [self heightForText:self.VINLookupObject.Entry4];
                }
                    break;
                case 7:
                {
                    height = [self heightForText:self.VINLookupObject.DateExpires];
                }
                    break;
                case 8:
                {
                   
                    height = [self heightForText:self.VINLookupObject.geoLocationAddress];
                }
                    break;

                    
                default:
                    break;
            }
            
            
            return height+5.0;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 179.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    //self.footerViewImages.backgroundColor = [UIColor blackColor];
    return self.footerViewImages;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    //self.footerViewImages.backgroundColor = [UIColor blackColor];
    return self.viewHeader;
    
}



- (CGFloat)heightForText:(NSString *)bodyText
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
        textSize = 190;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
        textSize = 500;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAddImageDidClicked:(id)sender
{
    
    if(arrayOfImages.count ==2)
        return;
        
    [UIActionSheet showInView:self.view
                    withTitle:@"Select The Picture"
            cancelButtonTitle:@"Cancel"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"Camera"]
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
                          
                          
                      default:
                          break;
                  }
                  
                  
              }];
    
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
        
        
        
       
        cell.btnDelete.hidden = YES;
        
        SMClassOfBlogImages *imageObj = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:indexPath.row];
        
        if(imageObj.isImageFromLocal)
        {
            
            NSString *str = [NSString stringWithFormat:@"%@.jpg", imageObj.imageSelected];
            
            NSString *fullImgName=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
            
            
            
            cell.imgActualImage.image = [UIImage imageWithContentsOfFile:fullImgName];
            
            
        }
        
        
        
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
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    
    
}


#pragma - mark Selecting Image from Camera and Library

- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Picking Image from Camera/ Library
    
    __block UIImagePickerController *picker2 = picker1;
    
    NSLog(@"imagePicker delegate called...");
    
    // Picking Image from Camera/ Library
    [picker2 dismissViewControllerAnimated:NO completion:^{
        picker2.delegate=nil;
        picker2 = nil;
    }];
    
    selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
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
    
    NSLog(@"selectedImage = %@",imgName);
    
    [self saveImage:selectedImage :imgName];
    
    NSData *vehicleImageData  = UIImageJPEGRepresentation(selectedImage,0.6);
    
    float imageSize = vehicleImageData.length;
    
    NSLog(@"SIZE OF OLD IMAGE: %.2f Mb", (float)imageSize/1024/1024);

    
    
    
    // Dispatch a global queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
                   , ^(void)
                   {
                       // do some time consuming things here
                       
                       selectedImage = [self returnTheCompressedImageForTheGivenImage:selectedImage];
                       
                       
                       NSData *vehicleImageData  = UIImageJPEGRepresentation(selectedImage,0.6);
                       
                       float imageSize = vehicleImageData.length;
                       
                       NSLog(@"SIZE OF NEW IMAGE: %.2f Mb", (float)imageSize/1024/1024);
                       
                       
                       if(base64EncodedFronOfVehicle.length == 0)
                           base64EncodedFronOfVehicle = [vehicleImageData base64EncodedStringWithOptions:0];
                       else
                           base64EncodedVinDisc = [vehicleImageData base64EncodedStringWithOptions:0];
                       
                       
                   });
    
    
    
    SMClassOfBlogImages *imageObject = [[SMClassOfBlogImages alloc]init];
    
    
    imageObject.imageSelected=imgName;
    
    
    
    imageObject.isImageFromLocal = YES;
    
    imageObject.imageLink = [self loadImagePath:imgName];
    imageObject.imageOriginIndex = -2;
    imageObject.isImageFromCamera = YES;
    imageObject.thumbImagePath = fullPathOftheImage;
    
    NSLog(@"imageObject.imageSelected = %@",imageObject.imageSelected);
    
    [arrayOfImages addObject:imageObject];
    [self.collectionViewImages reloadData];

    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1
{

    [picker dismissViewControllerAnimated:NO completion:NULL];
}


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

- (void)saveImage:(UIImage*)image :(NSString*)imageName
{
    
    if (documentsDirectory == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        documentsDirectory = [paths objectAtIndex:0];
    }
    
    
    
    imageData = UIImageJPEGRepresentation(image,0.6); //convert image into .jpg format.
    
    fullPathOftheImage = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageName]];
    
    
    
    //    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
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

/*-(void)delegateFunction:(UIImage*)imageToBeDeleted
{
    [imagePickerController deleteTheImageFromTheFirstLibrary:imageToBeDeleted];
}
*/
-(void)delegateFunctionForDeselectingTheSelectedPhotos
{
    [imagePickerController deSelectAllTheSelectedPhotosWhenCancelAction];
    
}


-(void)dismissTheLoader
{
    [imagePickerController dismissTheLoaderAction];
    
    
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
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Camera Not Available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]
             show];
            return;
        }
    }
    
}

/*- (IBAction)btnDeleteDidClicked:(id)sender
{
    
    deleteButtonTag = (int)[sender tag];
    
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure you want to delete?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    alert.tag = 201;
    [alert show];
    
    // NSLog(@"third delete button clicked");
    
}*/

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
    listActiveSpecialsNavigTitle.text = @"Vehicle Audit";
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
    

    
}

-(void)startTimer
{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [self.lblCountDown setText:[NSString stringWithFormat:@"%@%d%@%02d",@"Time remaining : ",currMinute,@":",currSeconds]];
        if(currMinute ==0 && currSeconds == 00)
        {
            
            SMVehicleStockAuditList *selectType;
            
            
            for (UINavigationController *view in self.navigationController.viewControllers)
            {
                //when found, do the same thing to find the MasterViewController under the nav controller
                if ([view isKindOfClass:[SMVehicleStockAuditList class]])
                {
                    selectType = (SMVehicleStockAuditList*)view;
                    
                }
            }
            [self.navigationController popToViewController:selectType animated:YES];
            
            //[self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        NSLog(@"timer text = %@",self.lblCountDown.text);
    }
    else
    {
        [self.timer invalidate];
    }
}

- (IBAction)btnSaveDetailsDidClicked:(id)sender
{
    if(arrayOfImages.count !=2)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"Please add 2 images, 1 of the front of the vehicle and 1 of the license disc to save this audit." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
    
    }
    
    
    
    [timer invalidate];
    timer = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
                   , ^(void)
                   {
                       [self saveTheScannedVinDetailstoServer];
                       
                   });

    
    
}

-(void)delegateFunctionWithOriginIndex:(int)originIndex
{
    if(![SMGlobalClass sharedInstance].isFromCamera)
        [imagePickerController deleteTheImageFromTheFirstLibraryWithIndex:originIndex];
    
}



#pragma mark - WEbservice integration 

-(void)saveTheScannedVinDetailstoServer
{
    
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    
        NSMutableURLRequest *requestURL=[SMWebServices saveStockAuditWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andVin:self.VINLookupObject.VIN andRegistration:self.VINLookupObject.Registration andMake:self.VINLookupObject.Make andModel:self.VINLookupObject.Model andColor:self.VINLookupObject.Colour andEngineNum:self.VINLookupObject.EngineNo andLatitude:[SMGlobalClass sharedInstance].googleLatitude andLongitude:[SMGlobalClass sharedInstance].googleLongitude andBase64VinImage:base64EncodedVinDisc andBase64VehicleImage:base64EncodedFronOfVehicle];
        
        NSLog(@"Request URL = %@",requestURL);
        
        
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
        
        
        
        [NSURLConnection sendAsynchronousRequest:requestURL
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
         {
             
             
             [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
             
             
             if (error!=nil)
             {
                 
                 [self hideProgressHUD];
                 
                 
                 [[[UIAlertView alloc]initWithTitle:@"Error"
                                            message:[error.localizedDescription capitalizedString]
                                           delegate:self cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil, nil]
                  show];
                 
             }
             else
             {
                 
                xmlParser = [[NSXMLParser alloc] initWithData: data];
                 [xmlParser setDelegate: self];
                 [xmlParser setShouldResolveExternalEntities:YES];
                 [xmlParser parse];
                 
             }
             
             
             
         }];
    


}

#pragma mark - Parsing delegate methods

// The first method to implement is parser:didStartElement:namespaceURI:qualifiedName:attributes:, which is fired when the start tag of an element is found:

//---when the start of an element is found---

-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict
{
    
     currentNodeContent = [NSMutableString stringWithString:@""];
    
}

//The next method to implement is parser:foundCharacters:, which gets fired when the parser finds the text of an element:

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];

    
    
}


//Finally, when the parser encounters the end of an element, it fires the parser:didEndElement:namespaceURI:qualifiedName: method:

//---when the end of element is found---

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    [self hideProgressHUD];
    
    
    if([elementName isEqualToString:@"Status"])
    {
        if([currentNodeContent isEqualToString:@"Success"])
        {
           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"Audit saved successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        
    }

    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    SMVehicleStockAuditList *selectType;
    
    
    for (UINavigationController *view in self.navigationController.viewControllers)
    {
        //when found, do the same thing to find the MasterViewController under the nav controller
        if ([view isKindOfClass:[SMVehicleStockAuditList class]])
        {
            selectType = (SMVehicleStockAuditList*)view;
            
        }
    }
    [self.navigationController popToViewController:selectType animated:YES];
    
    //[self.navigationController popViewControllerAnimated:YES];
    return;

    

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


-(UIImage*)returnTheCompressedImageForTheGivenImage:(UIImage*)givenImage
{
     NSLog(@"Size of old image Width : %f, Heigth : %f",givenImage.size.width,givenImage.size.height);
    
    if (givenImage.size.width < givenImage.size.height)
    {
        
        CGSize newSize;
        
        if ((givenImage.size.width >= 1200) || (givenImage.size.height >= 600))
        {
            if (givenImage.size.width > givenImage.size.height)
            {
                double factorPercentage = (1200/givenImage.size.width);
                float valueHeigth = givenImage.size.height * factorPercentage;
                
                if(valueHeigth<200)
                    newSize.height = 200;
                else
                    newSize.height = valueHeigth;
                
                newSize.width = 1200;
            }
            else
            {
                double factorPercentage = (600/givenImage.size.height);
                float valueWidth = givenImage.size.width * factorPercentage;
                
                if(valueWidth<400)
                    newSize.width = 400;
                else
                    newSize.width = valueWidth;
                
                newSize.height = 600;
            }
            NSLog(@"Size of new image Width : %f, Heigth : %f",newSize.width,newSize.height);
            lastImage = [self imageWithImage:givenImage scaledToSize:newSize];
            givenImage = lastImage;
        }
        /*else
         {
         lastImage = croppedImage;
         selectedImage = lastImage;
         }*/
        
    }
    else
    {
        lastImage = givenImage;
        //        if (!isCamera)
        {
            
            CGSize newSize;
            if ((givenImage.size.width > 1200) || (givenImage.size.height > 600))
            {
                if (givenImage.size.width > givenImage.size.height)
                {
                    double factorPercentage = (1200/givenImage.size.width);
                    float valueHeigth = givenImage.size.height * factorPercentage;
                    if(valueHeigth<200)
                        newSize.height = 200;
                    else
                        newSize.height = valueHeigth;
                    newSize.width = 1200;
                }
                else
                {
                    double factorPercentage = (600/givenImage.size.height);
                    float valueWidth = givenImage.size.width * factorPercentage;
                    
                    if(valueWidth<400)
                        newSize.width = 400;
                    else
                        newSize.width = valueWidth;
                    newSize.height = 600;
                }
                NSLog(@"Size of new image Width : %f, Heigth : %f",newSize.width,newSize.height);
                lastImage = [self imageWithImage:givenImage scaledToSize:newSize];
                givenImage = lastImage;
            }
            /*else
             {
             lastImage = croppedImage;
             selectedImage = lastImage;
             }*/
        }
    }
    return givenImage;
    
}


- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



@end
