//
//  MultipleImagePickerViewController.m
//
//  Created by Renato Peterman on 17/08/14.
//  Copyright (c) 2014 Renato Peterman. All rights reserved.
//

#import "RPMultipleImagePickerViewController.h"
#import "SMGlobalClass.h"

#import "NSString+FontAwesome.h"
#import "Fontclass.h"
#import "UIImage+Resize.h"
#import "SMCommonClassMethods.h"

@interface RPMultipleImagePickerViewController ()

@end

@implementation RPMultipleImagePickerViewController

@synthesize cropView;

- (instancetype)init
{
    self = [super initWithNibName:@"RPMultipleImagePicker" bundle:[NSBundle mainBundle]];
    if (self) {
        self.sourceType = UIImagePickerControllerSourceTypeCamera; // Default
        self.Originalimages = [NSMutableArray new];
       // self.ThumbnailImages = [NSMutableArray new];
        arrayFinalEditedImage = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardToBeShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardToBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
     
    
    // Refresh
    
  
    
    [self setCurrentImage:self.originalImage];
    
    if(arrayFinalEditedImage.count>0)
        [arrayFinalEditedImage removeAllObjects];
    
    
    for(int i=0;i<self.Originalimages.count;i++)
    {
        NSString *str = [NSString stringWithFormat:@"%@.jpg",[self.Originalimages objectAtIndex:i]];
        
        UIImage *image =  [[self loadImage:str] thumbnailImageWithWidth:40.0 andWithHeigth:40.0 transparentBorder:1 cornerRadius:1 interpolationQuality:kCGInterpolationLow];
        
       
        
        [arrayFinalEditedImage addObject:image];
        
    }
     NSLog(@"CALLED 2ND.....");
    
    if(!self.isFromGridView)
    {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            gradient.frame = CGRectMake(0, 0, 768, 71);
        }
        else
            gradient.frame = self.bgView.bounds;    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor darkGrayColor] CGColor], nil];
        [self.bgView.layer insertSublayer:gradient atIndex:0];
        
        // Background view for images collection
        self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.bgView.layer.shadowRadius = 3.0f;
        self.bgView.layer.shadowOpacity = 0.15f;
        [self reloadCollectionView];
        self.collectionView.hidden = NO;
        
    }
    else
    {
        self.bgView.hidden = YES;
        self.collectionView.hidden = YES;
    }
   
    
}

- (void)viewDidAppear:(BOOL)animated
{
       [self selectLastImage];
    [self.photoSelectionDelegate dismissTheLoader];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self addingProgressHUD];
    
    // Style
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Background
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.collectionView registerClass:[RPImageCell class] forCellWithReuseIdentifier:@"RPImageCell"];
    
    self.selectedIndex = 0;
    
   
    
    // Customize default ImageView
    self.imageView.layer.masksToBounds = true;
    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageView.layer.shadowOpacity = 0.3f;
    self.imageView.layer.shadowRadius = 6.0f;
    
    // Picker Controller Init
    self.pickerController = [[UIImagePickerController alloc] init];
    self.pickerController.delegate = self;
    self.pickerController.sourceType = self.sourceType;
    
    // Bt Remover
    self.btRemover.backgroundColor = [UIColor whiteColor];
    self.btRemover.layer.cornerRadius = 15.0f;
    self.btRemover.hidden = YES;
    
    // Set buttons to navigation
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Done") style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    doneButton.tag = 1;

    // iOS 7 only
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        doneButton.tintColor = [UIColor yellowColor];
    }
    
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [self.navigationItem setRightBarButtonItem:doneButton];
    
    self.navigationController.navigationBarHidden = NO;
    
    UIView *buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 200, 44)];
    buttonContainer.backgroundColor = [UIColor clearColor];
    
    btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDelete setFrame:CGRectMake(28, 7, 30, 30)];
    [btnDelete addTarget:self action:@selector(btnDeleteAction) forControlEvents:UIControlEventTouchUpInside];
    [btnDelete setAdjustsImageWhenDisabled:YES];
    
    btnRotate = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRotate setFrame:CGRectMake(83, 7, 30, 30)];
    btnRotate.titleLabel.text = @"2nd";
    [btnRotate setAdjustsImageWhenDisabled:YES];
    [btnRotate addTarget:self action:@selector(btnRotateAction) forControlEvents:UIControlEventTouchUpInside];
   
    
    btnCrop = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCrop setFrame:CGRectMake(138, 7, 30, 30)];
    btnCrop.titleLabel.text = @"3rd";
    [btnCrop setAdjustsImageWhenDisabled:YES];
   [btnCrop addTarget:self action:@selector(btnCropAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [buttonContainer addSubview:btnDelete];
    [buttonContainer addSubview:btnRotate];
    [buttonContainer addSubview:btnCrop];
    
    self.navigationItem.titleView = buttonContainer;
    
    [Fontclass AttributeStringMethodwithFontWithButton:btnDelete iconID:551];
    [Fontclass AttributeStringMethodwithFontWithButton:btnRotate iconID:439];
    [Fontclass AttributeStringMethodwithFontWithButton:btnCrop iconID:160];
    
    [SMGlobalClass sharedInstance].photoExistingCount = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Util

/*- (void)addOriginalImages:(UIImage*)image
{
    self.originalImage = image;
    [self.Originalimages addObject:image];
}*/

- (void)addOriginalImages:(NSString*)imageName
{
    
    //for(int i=0;i<self.Originalimages.count;i++)
    {
        NSString *str = [NSString stringWithFormat:@"%@.jpg",imageName];
        
        UIImage *img = [self loadImage:str];
       
        self.originalImage = img;
        [self.Originalimages addObject:imageName];
    }
    [self setCurrentImage:self.originalImage];
    if(arrayFinalEditedImage.count>0)
        [arrayFinalEditedImage removeAllObjects];
    for(int i=0;i<self.Originalimages.count;i++)
    {
        NSString *str = [NSString stringWithFormat:@"%@.jpg",[self.Originalimages objectAtIndex:i]];
        
        UIImage *image =  [[self loadImage:str] thumbnailImageWithWidth:40.0 andWithHeigth:40.0 transparentBorder:1 cornerRadius:1 interpolationQuality:kCGInterpolationLow];
       
        [arrayFinalEditedImage addObject:image];
        
    }

    NSLog(@"CALLED 1ST.....");
    [self reloadCollectionView];
    
    [self selectLastImage];
}

- (void)saveImageWithImageData:(NSData*)dataImage :(NSString*)imageName
{
    if (documentsDirectory == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
    }
    
    fullPathOftheImage = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]];
    
    NSLog(@"full path of image... = %@",fullPathOftheImage);
    
    [dataImage writeToFile:fullPathOftheImage atomically:NO];
    dataImage = nil;
}

- (void)saveImage:(UIImage*)image :(NSString*)imageName
{
    if (documentsDirectory == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
    }
    imageData = UIImageJPEGRepresentation(image,0.6); //convert image into .jpg format.
    fullPathOftheImage = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]];
    
    NSLog(@"full path of image... = %@",fullPathOftheImage);
    
    [imageData writeToFile:fullPathOftheImage atomically:NO];
    imageData = nil;
}

- (UIImage*)loadImage:(NSString*)imageName1 {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    NSLog(@"full path of IMGG = %@",fullPathOftheImage);
    return [UIImage imageWithContentsOfFile:fullPathOfImage];
    
}

- (void)removeImage:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success)
    {
        //NSLog(@"REmoved file successfully !!!");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}


- (void) selectLastImage
{
    if(self.Originalimages.count > 0)
    {
        self.selectedIndex = self.Originalimages.count-1;
        NSLog(@"Second selectedIndex = %d",self.selectedIndex);
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
    }else
    {
        self.selectedIndex = 0;
    }
}

- (void) setCurrentImage:(UIImage *) image {
    
    self.imageView.image = image;

    
    [self.cropView setImage:image];
    self.cropView.bounds = CGRectMake(self.imageView.bounds.origin.x, self.imageView.bounds.origin.y, self.imageView.bounds.size.width, self.imageView.bounds.size.height);
    
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(IBAction)done:(id)sender // 2nd done
{
     UIButton *doneBtn = (UIButton*)sender; // Linto
    
    NSLog(@"button tag = %d",doneBtn.tag);
    
    switch (doneBtn.tag)
    {
        case 1:
        {
            if(self.doneCallback)
            {
                [HUD show:YES];
                [HUD setLabelText:KLoaderText];
                
                for(int i=0;i<self.Originalimages.count;i++)
                {
                    NSString *str = [NSString stringWithFormat:@"%@.jpg",[self.Originalimages objectAtIndex:i]];
                    
                    UIImage *croppedImage = [self loadImage:str];
                    
                    
                    NSLog(@"Size of old image Width : %f, Heigth : %f",croppedImage.size.width,croppedImage.size.height);
                    
                    if (croppedImage.size.width < croppedImage.size.height)
                    {
                        //        if (isCamera)
                        //        {
                        //            lastImage = [[SMCommonClassMethods shareCommonClassManager]scaleAndRotateImage:croppedImage];
                        //        }
                        //        else
                        {
                            CGSize newSize;
                            
                            if ((croppedImage.size.width >= 1200) || (croppedImage.size.height >= 600))
                            {
                                if (croppedImage.size.width > croppedImage.size.height)
                                {
                                    double factorPercentage = (1200/croppedImage.size.width);
                                    float valueHeigth = croppedImage.size.height * factorPercentage;
                                    
                                    if(valueHeigth<200)
                                        newSize.height = 200;
                                    else
                                        newSize.height = valueHeigth;
                                    
                                    newSize.width = 1200;
                                }
                                else
                                {
                                    double factorPercentage = (600/croppedImage.size.height);
                                    float valueWidth = croppedImage.size.width * factorPercentage;
                                    
                                    if(valueWidth<400)
                                        newSize.width = 400;
                                    else
                                        newSize.width = valueWidth;
                                    
                                    newSize.height = 600;
                                }
                                NSLog(@"Size of new image Width : %f, Heigth : %f",newSize.width,newSize.height);
                                lastImage = [self imageWithImage:croppedImage scaledToSize:newSize];
                                selectedImage = lastImage;
                            }
                            else
                            {
                                lastImage = croppedImage;
                                selectedImage = lastImage;
                            }
                            
                            
                        }
                        
                    }
                    else
                    {
                        lastImage = selectedImage;
                        //        if (!isCamera)
                        {
                            
                            CGSize newSize;
                            if ((croppedImage.size.width > 1200) || (croppedImage.size.height > 600))
                            {
                                if (croppedImage.size.width > croppedImage.size.height)
                                {
                                    double factorPercentage = (1200/croppedImage.size.width);
                                    float valueHeigth = croppedImage.size.height * factorPercentage;
                                    if(valueHeigth<200)
                                        newSize.height = 200;
                                    else
                                        newSize.height = valueHeigth;
                                    newSize.width = 1200;
                                }
                                else
                                {
                                    double factorPercentage = (600/croppedImage.size.height);
                                    float valueWidth = croppedImage.size.width * factorPercentage;
                                    
                                    if(valueWidth<400)
                                        newSize.width = 400;
                                    else
                                        newSize.width = valueWidth;
                                    newSize.height = 600;
                                }
                                NSLog(@"Size of new image Width : %f, Heigth : %f",newSize.width,newSize.height);
                                lastImage = [self imageWithImage:croppedImage scaledToSize:newSize];
                                selectedImage = lastImage;
                            }
                            else
                            {
                                lastImage = croppedImage;
                                selectedImage = lastImage;
                            }
                        }
                    }
                    
                   
                    
                    NSData *Data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(selectedImage, 0.8)];
                    [self removeImage:str];
                    [self saveImageWithImageData:Data :str];
                    
                    // need to check here........gggg
                    
                }
                
                [self hideProgressHUD];
                
                
                
                self.doneCallback(self.Originalimages);
            }
            
            
            [self.navigationController popViewControllerAnimated:NO];
  
        }
        break;
            
        case 2:
        {
            btnDelete.enabled = YES;
            btnRotate.enabled = YES;
            btnCrop.enabled = YES;
           
            self.collectionView.userInteractionEnabled = YES;
            
            doneButton.tag = 1;
            doneButton.title = @"Send";
            
            UIImage *croppedImage;
            if (self.cropView.imageView.image != nil)
            {
                
                // this is for taking screen shot
                NSLog(@"Area: %@",NSStringFromCGRect(self.cropView.cropAreaInImage));
                CGRect CropRect = self.cropView.cropAreaInImage;
                CGImageRef imageRef = CGImageCreateWithImageInRect([self.cropView.imageView.image CGImage], CropRect) ;
                croppedImage = [UIImage imageWithCGImage:imageRef];
                CGImageRelease(imageRef);
                
                /////////////////////////////////////////////////////////////////
                
                
                NSLog(@"Size of old image Width : %f, Heigth : %f",croppedImage.size.width,croppedImage.size.height);
                
                if (croppedImage.size.width < croppedImage.size.height)
                {
                    //        if (isCamera)
                    //        {
                    //            lastImage = [[SMCommonClassMethods shareCommonClassManager]scaleAndRotateImage:croppedImage];
                    //        }
                    //        else
                    {
                        CGSize newSize;
                        
                        if ((croppedImage.size.width >= 1200) || (croppedImage.size.height >= 600))
                        {
                            if (croppedImage.size.width > croppedImage.size.height)
                            {
                                double factorPercentage = (1200/croppedImage.size.width);
                                float valueHeigth = croppedImage.size.height * factorPercentage;
                                
                                if(valueHeigth<200)
                                    newSize.height = 200;
                                else
                                    newSize.height = valueHeigth;
                                
                                newSize.width = 1200;
                            }
                            else
                            {
                                double factorPercentage = (600/croppedImage.size.height);
                                float valueWidth = croppedImage.size.width * factorPercentage;
                                
                                if(valueWidth<400)
                                    newSize.width = 400;
                                else
                                    newSize.width = valueWidth;
                                
                                newSize.height = 600;
                            }
                            NSLog(@"Size of new image Width : %f, Heigth : %f",newSize.width,newSize.height);
                            lastImage = [self imageWithImage:croppedImage scaledToSize:newSize];
                            selectedImage = lastImage;
                        }
                        else
                        {
                            lastImage = croppedImage;
                            selectedImage = lastImage;
                        }
                        
                        
                    }
                }
                else
                {
                    lastImage = selectedImage;
                    //        if (!isCamera)
                    {
                        
                        CGSize newSize;
                        if ((croppedImage.size.width > 1200) || (croppedImage.size.height > 600))
                        {
                            if (croppedImage.size.width > croppedImage.size.height)
                            {
                                double factorPercentage = (1200/croppedImage.size.width);
                                float valueHeigth = croppedImage.size.height * factorPercentage;
                                if(valueHeigth<200)
                                    newSize.height = 200;
                                else
                                    newSize.height = valueHeigth;
                                newSize.width = 1200;
                            }
                            else
                            {
                                double factorPercentage = (600/croppedImage.size.height);
                                float valueWidth = croppedImage.size.width * factorPercentage;
                                
                                if(valueWidth<400)
                                    newSize.width = 400;
                                else
                                    newSize.width = valueWidth;
                                newSize.height = 600;
                            }
                            NSLog(@"Size of new image Width : %f, Heigth : %f",newSize.width,newSize.height);
                            lastImage = [self imageWithImage:croppedImage scaledToSize:newSize];
                            selectedImage = lastImage;
                        }
                        else
                        {
                            lastImage = croppedImage;
                            selectedImage = lastImage;
                        }
                    }
                }
                
                
                
                /////////////////////////////////////////////////////////////////
                
                
                NSString *str = [NSString stringWithFormat:@"%@.jpg",[self.Originalimages objectAtIndex:self.selectedIndex]];
                 NSLog(@"str111 = %@,%@",str,selectedImage);
                
                NSData *Data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(selectedImage, 0.6)];
                [self removeImage:str];
//
                
                [self saveImageWithImageData:Data :str];

                
                
               [self setCurrentImage:[self loadImage:str]];
                
                if(arrayFinalEditedImage.count>0)
                    [arrayFinalEditedImage removeAllObjects];
                
               
                
                for(int i=0;i<self.Originalimages.count;i++)
                {
                    NSString *str = [NSString stringWithFormat:@"%@.jpg",[self.Originalimages objectAtIndex:i]];
                   // NSLog(@"str222 = %@",str);
                    UIImage *image =  [self loadImage:str];
                   // NSLog(@"imageee = %@",image);
                    
                     image =  [image thumbnailImageWithWidth:40.0 andWithHeigth:40.0 transparentBorder:1 cornerRadius:1 interpolationQuality:kCGInterpolationLow];
                    
                    [arrayFinalEditedImage addObject:image];
                
                }
                
                [self reloadCollectionView];
                
                RPImageCell *selectedCell = (RPImageCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexpath];
                [selectedCell setSelected:YES];

                [self.cropView removeFromSuperview];
                
            }
           
 
        }
        break;
            
        default:
            break;
    }
    
    
    //[self.images removeAllObjects];
    
}

- (void) cancel///////
{
    self.originalImage = nil;
   
    [self.Originalimages removeAllObjects];
    
    [self.photoSelectionDelegate delegateFunctionForDeselectingTheSelectedPhotos];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) reloadCollectionView
{
    [self.collectionView performBatchUpdates:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:nil];
}



#pragma mark - Collection view delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(self.isFromStockAuditScreen)
    {
        if(arrayFinalEditedImage.count == 2)
            return arrayFinalEditedImage.count;
        
        return arrayFinalEditedImage.count + 1;
        
    }
    return arrayFinalEditedImage.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *CellIdentifier = @"RPImageCell";
    RPImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[RPImageCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    }
    
    
    
    if(indexPath.row == arrayFinalEditedImage.count)
    {
        [cell styleAddButton];
        cell.backgroundImageView.image = nil;
    }
    else
    {
        [cell styleImage];
        cell.backgroundImageView.image = [arrayFinalEditedImage objectAtIndex:(indexPath.row)];
    }

    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 50);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RPImageCell *selectedCell = (RPImageCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexpath];
    [selectedCell setSelected:NO];
    
    NSLog(@"totalImageSelected = %d",[SMGlobalClass sharedInstance].totalImageSelected);
    
    if(self.isFromApp)
    {
        [SMGlobalClass sharedInstance].photoExistingCount = [SMGlobalClass sharedInstance].totalImageSelected;
        //existingCount = [SMGlobalClass sharedInstance].totalImageSelected;
        self.isFromApp = NO;
        
    }
   
    
    if(indexPath.row == arrayFinalEditedImage.count)
    {
                    
        if(20-[SMGlobalClass sharedInstance].photoExistingCount == 1 )
        {
            
            [self showTheRestrictionPopup];
            
        }
       
        else
        {
            if([SMGlobalClass sharedInstance].isFromCamera)
            {
                
                
                [self.photoSelectionDelegate callToSelectImagesFromCameraWithRemainingCount:20-[SMGlobalClass sharedInstance].photoExistingCount andFromEditScreen:YES];
                
               [SMGlobalClass sharedInstance].photoExistingCount++;
                 NSLog(@"photoExistingCount1 = %d",[SMGlobalClass sharedInstance].photoExistingCount);
                
                
                
            }
            else
            {
                [self.photoSelectionDelegate callTheMultiplePhotoSelectionLibraryWithRemainingCount:20 - [SMGlobalClass sharedInstance].photoExistingCount andFromEditScreen:YES];
                
            }
           
        }
        
        
        
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"%@.jpg",[self.Originalimages objectAtIndex:(indexPath.row)]];
        
        [self setCurrentImage:[self loadImage:str]];
        self.selectedIndex = indexPath.row;
        selectedIndexpath = indexPath;
        NSLog(@"First selectedIndex = %d",(int)self.selectedIndex);
        
    }
}

-(void)showTheRestrictionPopup
{
   
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Maximum 20 photos per upload." message:@"20 photos already selected." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - ImagePicker delegate methods

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        if(self.Originalimages == nil){
            self.Originalimages = [NSMutableArray new];
        }
        
        editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage]; // Edited image if available
        originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        imageToUse = editedImage ? editedImage : originalImage;
        
        [self addOriginalImages:imageToUse];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

#pragma mark - UI navigation bar delegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}

#pragma mark - IBActions

-(IBAction)remove:(id)sender
{
    
    [self.Originalimages removeObjectAtIndex:(self.selectedIndex-1)];
    
    [self reloadCollectionView];
    [self selectLastImage];
    
    if(self.Originalimages.count > 0)
    {
        [self setCurrentImage:[self.Originalimages objectAtIndex:(self.selectedIndex-1)]];
    }else
    {
        //[self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    //[self refreshTitle];
}


-(void)btnDeleteAction
{
    [SMGlobalClass sharedInstance].photoExistingCount--;
    NSLog(@"originalArray count = %d",arrayOfOriginalSizeImages.count);
    
    
    
    [self.photoSelectionDelegate delegateFunctionWithOriginIndex:self.selectedIndex];
    
     NSString *str = [NSString stringWithFormat:@"%@.jpg",[self.Originalimages objectAtIndex:(self.selectedIndex)]];
    
    [self removeImage:str];
    
    [self.Originalimages removeObjectAtIndex:(self.selectedIndex)];
    
    if(arrayFinalEditedImage.count>0)
        [arrayFinalEditedImage removeAllObjects];
    
    
    for(int i=0;i<self.Originalimages.count;i++)
    {
        NSString *str = [NSString stringWithFormat:@"%@.jpg",[self.Originalimages objectAtIndex:i]];
        
        UIImage *image =  [[self loadImage:str] thumbnailImageWithWidth:40.0 andWithHeigth:40.0 transparentBorder:1 cornerRadius:1 interpolationQuality:kCGInterpolationLow];
        
        [arrayFinalEditedImage addObject:image];
        
    }

    
    [self reloadCollectionView];
    [self selectLastImage];
    
    if(self.Originalimages.count > 0)
    {
         NSString *str = [NSString stringWithFormat:@"%@.jpg",[self.Originalimages objectAtIndex:(self.selectedIndex)]];
        
        [self setCurrentImage:[self loadImage:str]];
    }
    else
    {
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    
   

}


- (void)keyboardToBeShown:(NSNotification*)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.bgView.frame = CGRectMake(self.bgView.frame.origin.x, self.bgView.frame.origin.y, self.bgView.frame.size.width, [self view].bounds.size.height - (keyboardSize.height+2.0));
    
}

- (void)keyboardToBeHidden:(NSNotification*)notification
{
    self.bgView.frame = CGRectMake(self.bgView.frame.origin.x, self.bgView.frame.origin.y, self.bgView.frame.size.width, [self view].bounds.size.height);
    
}


#pragma mark - Image Rotation function

- (UIImage*)rotateUIImage:(UIImage*)sourceImage clockwise:(BOOL)clockwise
{
    CGSize size = sourceImage.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width));
    [[UIImage imageWithCGImage:[sourceImage CGImage] scale:1.0 orientation:clockwise ? UIImageOrientationRight : UIImageOrientationLeft] drawInRect:CGRectMake(0,0,size.height ,size.width)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)btnRotateAction
{
   
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
     NSString *str = [NSString stringWithFormat:@"%@.jpg",[self.Originalimages objectAtIndex:(self.selectedIndex)]];
   
    UIImage *imageToRotate = [self loadImage:str];
    
   UIImage *rotatedImage = [self rotateUIImage:imageToRotate clockwise:YES];
    
   
   // NSData *Data = [[NSData alloc] initWithData:UIImageJPEGRepresentation(rotatedImage, 0.8)];
    
    [self removeImage:str];
    [self saveImage:rotatedImage:str];
    [self setCurrentImage:rotatedImage];

    [self hideProgressHUD];
   
    
    if(arrayFinalEditedImage.count>0)
        [arrayFinalEditedImage removeAllObjects];
    
   // NSLog(@"originalImages count = %d",(int)self.Originalimages.count);
    
    for(int i=0;i<self.Originalimages.count;i++)
    {
        NSString *str = [NSString stringWithFormat:@"%@.jpg",[self.Originalimages objectAtIndex:i]];
        // NSLog(@"str = %@",str);
        UIImage *image =  [self loadImage:str];
         //NSLog(@"image = %@",image);
           image =  [image thumbnailImageWithWidth:40.0 andWithHeigth:40.0 transparentBorder:1 cornerRadius:1 interpolationQuality:kCGInterpolationLow];
        
       // NSLog(@"image = %@",image);
        [arrayFinalEditedImage addObject:image];
        
    }
    
    
    [self reloadCollectionView];
    RPImageCell *selectedCell = (RPImageCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexpath];
    [selectedCell setSelected:YES];
    
}

-(IBAction)btnCropAction:(id)sender
{
    
    btnDelete.enabled = NO;
    btnRotate.enabled = NO;
    btnCrop.enabled = NO;
   
    self.collectionView.userInteractionEnabled = NO;
    
    [doneButton setTitle:@"Crop"];
    doneButton.tag = 2;
    
    UIButton *btn = (UIButton*)sender;
    
    NSLog(@"done button tag = %d",doneButton.tag);
    
    
   // if (!btn.selected)
    {
        //Initialise cropper view
        
        CGRect rect = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y,self.imageView.frame.size.width, self.imageView.frame.size.height);
        
        self.cropView  = [[ImageCropView alloc] initWithFrame:rect blurOn:YES];
        [self.view addSubview:self.cropView];
    
        self.cropView.frame = self.imageView.frame;
        self.cropView.image = self.imageView.image;
        [self.cropView setImage:self.imageView.image];
        
        
        [self.view bringSubviewToFront:self.collectionView];
        //[self.view bringSubviewToFront:self.txtFieldCaption];
        
    }
}


#pragma mark - Progress Bar Functions User Define
-(void) addingProgressHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}

-(void) hideProgressHUD
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
        });
    });
}

-(UIImage*)makeTheGivenImagePortrait:(UIImage*)landscapeImage
{

    
    if (landscapeImage.imageOrientation == UIImageOrientationUp)
    {
        NSLog(@"portrait");
    }
    else if (landscapeImage.imageOrientation == UIImageOrientationLeft || landscapeImage.imageOrientation == UIImageOrientationRight)
    {
        NSLog(@"landscape");
    }
    
    landscapeImage = [[SMCommonClassMethods shareCommonClassManager]scaleAndRotateImage:landscapeImage];
   
    if (self.originalImage.imageOrientation == UIImageOrientationUp)
    {
        NSLog(@"portrait");
    }
    else if (self.originalImage.imageOrientation == UIImageOrientationLeft || self.originalImage.imageOrientation == UIImageOrientationRight)
    {
        NSLog(@"landscape");
    }
    return landscapeImage;

    

}




@end
