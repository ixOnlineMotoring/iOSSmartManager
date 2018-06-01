//
//  SMCommentVideosPhotosAddViewController.m
//  SmartManager
//
//  Created by Sandeep on 05/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMCommentVideosPhotosAddViewController.h"
#import "SMCellOfPlusImageCommentPV.h"
#import "SMClassOfBlogImages.h"
#import "UIImage+Resize.h"
#import "SMUrlConnection.h"
#import "SMGlobalClass.h"
#import "HomeViewController.h"
#import "SMVideoInfoViewController.h"
#import "Reachability.h"
#import "UIBAlertView.h"

@interface SMCommentVideosPhotosAddViewController ()
{
    int imageLoopCount;
    CGFloat heightOfVehicleInfoSection;
    Reachability *reachability ;
    NetworkStatus internetStatus;
    BOOL ifUploadMobileData;
}

@end

@implementation SMCommentVideosPhotosAddViewController

@synthesize tblCommentVideoAndPhotos;
@synthesize lblPhotosPlaceHolder;
@synthesize collectionViewImages;
@synthesize photosExtrasObject;
@synthesize viewPhotos;
@synthesize viewVechicles;
//@synthesize youtubeHelper;
@synthesize lblCommentsImage;
@synthesize lblExtrasImage;
@synthesize lblVideosImage;
@synthesize lblColour;

@synthesize imageCropView;

static NSString *cellIdentifier= @"CommentsVPCellIdentifier";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"VideoArray count before  = %lu",(unsigned long)arrayOfVideos.count);

    [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                   withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
//                                             initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(pushBackToListingView)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-10.0f];
    ////////////// Monami ios 11 compatible button /////////////////////////////
    UIButton *buttonMenu = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 40, 20)];
    ///////////////// End ////////////////////////////
    [buttonMenu setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [buttonMenu addTarget:self action:@selector(pushBackToListingView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnMenu =  [[UIBarButtonItem alloc]initWithCustomView:buttonMenu];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,btnMenu];
    // self.navigationItem.leftBarButtonItem = btnMenu;
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ifUploadMobileData = YES;
    canClientUploadVideos = NO;
    didUserChangeAnyThing = NO;
    hasUserSavedAnyChangedInfo = NO;
    [self canUserUploadVideos];
    [self addingProgressHUD];
    appdelegate.isRefreshUI=NO;
    // Do any additional setup after loading the view from its nib.
    arrayOfImages=[[NSMutableArray alloc]init];
    arrayOfVideos=[[NSMutableArray alloc]init];
   
    imageCropView.controlColor = [UIColor cyanColor];
    indexpathOfSelectedVideo = -1;
    heightOfVehicleInfoSection = 0.0;
    imageLoopCount =0;
    imgCount=0;
    appdelegate=(SMAppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isRefreshUI=NO;
    
    
    
   // self.youtubeHelper = [[YouTubeHelper alloc] initWithDelegate:self];
    
    UILabel *labelNavigationTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        labelNavigationTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        self.lblVideoInfo.font = [UIFont fontWithName:FONT_NAME size:11.0];
    }
    else
    {
        labelNavigationTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        self.lblVideoInfo.font = [UIFont fontWithName:FONT_NAME size:13.0];
    }
    labelNavigationTitle.backgroundColor = [UIColor clearColor];
    labelNavigationTitle.textColor = [UIColor whiteColor]; // change this color
    labelNavigationTitle.text =self.photosExtrasObject.strVehicleName;
    self.navigationItem.titleView = labelNavigationTitle;
    [labelNavigationTitle sizeToFit];
    
    self.viewCollectionBk.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.viewCollectionBk.layer.borderWidth= 0.8f;
    
    self.viewCollectionVideoBk.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.viewCollectionVideoBk.layer.borderWidth= 0.8f;
    
    
    self.txtViewComment.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtViewComment.layer.borderWidth= 0.8f;
    
    self.btnSave.layer.cornerRadius=4.0f;
    
    self.txtViewExtras.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtViewExtras.layer.borderWidth= 0.8f;
    
    [self setCustomFont];
    
    [self registerNib];
    
    [self.txtViewExtras setPlaceholderColor:[UIColor whiteColor]];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
    
  //  self.lblVehicleName.text=[NSString stringWithFormat:@"%@ %@",self.photosExtrasObject.strUsedYear,self.photosExtrasObject.strVehicleName];
        
     [self setAttributedTextForVehicleDetailsWithFirstText:self.photosExtrasObject.strUsedYear andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:self.lblVehicleName];
        
    [self.lblVehicleName sizeToFit];
    
    self.lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",self.photosExtrasObject.strRegistration,self.photosExtrasObject.strColour,self.photosExtrasObject.strStockCode];
    [self.lblVehicleDetails1 sizeToFit];
    
        self.lblPriceRetail.text = photosExtrasObject.strRetailPrice;
        [self.lblPriceRetail sizeToFit];
        self.lblPriceTrade.text = photosExtrasObject.strTradePrice;
    
    [self setAttributedTextForVehicleDetailsWithFirstText:self.photosExtrasObject.strVehicleType andWithSecondText:[NSString stringWithFormat:@"| %@ Km",self.photosExtrasObject.strMileage] andWithThirdText:self.photosExtrasObject.strDays forLabel:self.lblVehicleDetails2];
    
    [self.lblVehicleDetails2 sizeToFit];
    
    self.lblVehicleDetails1.frame = CGRectMake(self.lblVehicleDetails1.frame.origin.x, self.lblVehicleName.frame.origin.y + self.lblVehicleName.frame.size.height +2.0, self.lblVehicleDetails1.frame.size.width, self.lblVehicleDetails1.frame.size.height);
    
     self.lblVehicleDetails2.frame = CGRectMake(self.lblVehicleDetails2.frame.origin.x, self.lblVehicleDetails1.frame.origin.y + self.lblVehicleDetails1.frame.size.height+2.0, self.lblVehicleDetails2.frame.size.width, self.lblVehicleDetails2.frame.size.height);
        
        self.viewContainingTraderPrice.frame = CGRectMake(self.lblPriceRetail.frame.origin.x + self.lblPriceRetail.frame.size.width+3.0, self.viewContainingTraderPrice.frame.origin.y , self.viewContainingTraderPrice.frame.size.width, self.viewContainingTraderPrice.frame.size.height);
        
        self.viewContainingPrice.frame = CGRectMake(self.viewContainingPrice.frame.origin.x, self.lblVehicleDetails2.frame.origin.y + self.lblVehicleDetails2.frame.size.height + 2.0, self.viewContainingPrice.frame.size.width, self.viewContainingPrice.frame.size.height);
    
     self.viewExtrasCommentsPhotos.frame = CGRectMake(self.viewExtrasCommentsPhotos.frame.origin.x, self.viewContainingPrice.frame.origin.y + self.viewContainingPrice.frame.size.height+2.0, self.viewExtrasCommentsPhotos.frame.size.width, self.viewExtrasCommentsPhotos.frame.size.height);
        
        heightOfVehicleInfoSection = self.lblVehicleName.frame.size.height + self.lblVehicleDetails1.frame.size.height + self.lblVehicleDetails2.frame.size.height + self.viewContainingTraderPrice.frame.size.height + self.viewExtrasCommentsPhotos.frame.size.height;
    
    }
    else
    {
       // self.lblVehicleName.text=[NSString stringWithFormat:@"%@ %@",self.photosExtrasObject.strUsedYear,self.photosExtrasObject.strVehicleName];
        //////////////////Monami UI Issue Fix Design improper/////////////////
        self.lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",self.photosExtrasObject.strRegistration,self.photosExtrasObject.strColour,self.photosExtrasObject.strStockCode];
        [self setAttributedTextForVehicleDetailsWithFirstText:self.photosExtrasObject.strVehicleType andWithSecondText:[NSString stringWithFormat:@"| %@ Km",self.photosExtrasObject.strMileage] andWithThirdText:self.photosExtrasObject.strDays forLabel:self.lblVehicleDetails2];
        [self.lblVehicleDetails1 sizeToFit];
        [self.lblVehicleDetails2 sizeToFit];
        
        self.lblVehicleDetails1.frame = CGRectMake(self.lblVehicleDetails1.frame.origin.x, self.lblVehicleName.frame.origin.y + self.lblVehicleName.frame.size.height +2.0, self.lblVehicleDetails1.frame.size.width, self.lblVehicleDetails1.frame.size.height);
        
        self.lblVehicleDetails2.frame = CGRectMake(self.lblVehicleDetails2.frame.origin.x, self.lblVehicleDetails1.frame.origin.y + self.lblVehicleDetails1.frame.size.height+2.0, self.lblVehicleDetails2.frame.size.width, self.lblVehicleDetails2.frame.size.height);
        
        self.viewContainingTraderPrice.frame = CGRectMake(self.lblPriceRetail.frame.origin.x + self.lblPriceRetail.frame.size.width+3.0, self.viewContainingTraderPrice.frame.origin.y , self.viewContainingTraderPrice.frame.size.width, self.viewContainingTraderPrice.frame.size.height);
        
        self.viewContainingPrice.frame = CGRectMake(self.viewContainingPrice.frame.origin.x, self.lblVehicleDetails2.frame.origin.y + self.lblVehicleDetails2.frame.size.height + 2.0, self.viewContainingPrice.frame.size.width, self.viewContainingPrice.frame.size.height);
        
        self.viewExtrasCommentsPhotos.frame = CGRectMake(self.viewExtrasCommentsPhotos.frame.origin.x, self.viewContainingPrice.frame.origin.y + self.viewContainingPrice.frame.size.height+2.0, self.viewExtrasCommentsPhotos.frame.size.width, self.viewExtrasCommentsPhotos.frame.size.height);
        
        heightOfVehicleInfoSection = self.lblVehicleName.frame.size.height + self.lblVehicleDetails1.frame.size.height + self.lblVehicleDetails2.frame.size.height + self.viewContainingTraderPrice.frame.size.height + self.viewExtrasCommentsPhotos.frame.size.height;
        ///////////////////////////// END ///////////////////////////
        
        [self setAttributedTextForVehicleDetailsWithFirstText:self.photosExtrasObject.strUsedYear andWithSecondText:self.photosExtrasObject.strVehicleName forLabel:self.lblVehicleName];

        //self.lblRegistration.text=self.photosExtrasObject.strRegistration;
        self.lblColour.text=self.photosExtrasObject.strColour;
        self.lblStockCode.text=self.photosExtrasObject.strStockCode;
        self.lblVehicleType.text=self.photosExtrasObject.strVehicleType;
        self.lblPriceRetail.text =self.photosExtrasObject.strRetailPrice;
         self.lblPriceTrade.text =self.photosExtrasObject.strTradePrice;
        self.lblMileage.text=[NSString stringWithFormat:@"%@ Km",self.photosExtrasObject.strMileage];
        self.lblRemaingDaysCount.text=self.photosExtrasObject.strDays;
       
    }
    self.lblPhotoCount.text=self.photosExtrasObject.strPhotoCounts;
     self.lblVideosImage.text=self.photosExtrasObject.strVideosCount;
    
    if (!self.photosExtrasObject.strExtras)
    {
        [self.lblExtrasImage setText:@"x"];
        [self.lblExtrasImage setTextColor:[UIColor redColor]];
    }
    else
    {
        [self.lblExtrasImage setText:@"\u2713"];
        [self.lblExtrasImage setTextColor:[UIColor greenColor]];
    }
    
    if (!self.photosExtrasObject.strComments)
    {
        [self.lblCommentsImage setText:@"x"];
        [self.lblCommentsImage setTextColor:[UIColor redColor]];
    }
    else
    {
        [self.lblCommentsImage setText:@"\u2713"];
        [self.lblCommentsImage setTextColor:[UIColor greenColor]];
    }
    
    self.tblCommentVideoAndPhotos.tableFooterView=self.viewSaveFooter;
    
    self.multipleImagePicker = [[RPMultipleImagePickerViewController alloc] init];
    self.multipleImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.multipleImagePicker.photoSelectionDelegate = self;
    
    [self performSelector:@selector(getLoadVehicleFromServer) withObject:nil afterDelay:0.1];
    
    
    [SMGlobalClass sharedInstance].totalImageSelected  = 0;
    [SMGlobalClass sharedInstance].isFromCamera = NO;

   
   
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
            [SMGlobalClass sharedInstance].totalImageSelected = (int)(arrayOfImages.count - arrayServerFiltered.count);
        
    }
    else
    {
        [SMGlobalClass sharedInstance].totalImageSelected = (int)arrayOfImages.count;
        
    }

}

-(void)pushBackToListingView
{
    NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];
    NSPredicate *predicateVideos = [NSPredicate predicateWithFormat:@"isVideoFromLocal == %d",YES];
    NSArray *arrayImageFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
     NSArray *arrayVideoFiltered = [arrayOfVideos filteredArrayUsingPredicate:predicateVideos];
    
    
    if(didUserChangeAnyThing || ((arrayImageFiltered.count > 0 || arrayVideoFiltered.count > 0) && !hasUserSavedAnyChangedInfo))
    {
    NSString *alertMsg = @"You have not saved the information. Are you sure you want to continue? ";
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:alertMsg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=301;
    [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)setCustomFont
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.btnSave.titleLabel.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.txtViewExtras.font = [UIFont fontWithName:FONT_NAME size:14.0];
        self.lblRegistration.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.lblColour.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        
        self.lblStockCode.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.lblPrice.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.lblMileage.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.lblRemaingDaysCount.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.txtViewComment.font = [UIFont fontWithName:FONT_NAME size:14.0];

        self.lblPhotoCount.font=[UIFont fontWithName:FONT_NAME_BOLD size:10.0f];
        self.lblVideosImage.font=[UIFont fontWithName:FONT_NAME_BOLD size:10.0f];
        self.lblExtras.font=[UIFont fontWithName:FONT_NAME size:10.0f];
        self.lblComments.font=[UIFont fontWithName:FONT_NAME size:10.0f];
        self.lblPhotos.font=[UIFont fontWithName:FONT_NAME size:10.0f];
        self.lblVideos.font=[UIFont fontWithName:FONT_NAME size:10.0f];
        
        self.lblExtrasImage.font=[UIFont fontWithName:FONT_NAME size:14.0f];
        self.lblCommentsImage.font=[UIFont fontWithName:FONT_NAME size:14.0f];
        self.lblPhotosPlaceHolder.font=[UIFont fontWithName:FONT_NAME size:11.0f];
        self.lblVideoPlaceHolder.font=[UIFont fontWithName:FONT_NAME size:11.0f];
    }
    else
    {
        self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.btnSave.titleLabel.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.txtViewExtras.font = [UIFont fontWithName:FONT_NAME size:20.0f];
        self.lblRegistration.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.lblColour.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        
        self.lblStockCode.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.lblPrice.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.lblMileage.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.lblRemaingDaysCount.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.txtViewComment.font = [UIFont fontWithName:FONT_NAME size:20.0];

        self.lblPhotoCount.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.lblExtras.font=[UIFont fontWithName:FONT_NAME size:20.0f];
        self.lblComments.font=[UIFont fontWithName:FONT_NAME size:20.0f];
        self.lblPhotos.font=[UIFont fontWithName:FONT_NAME size:20.0f];
        self.lblVideos.font=[UIFont fontWithName:FONT_NAME size:20.0f];
        
        self.lblExtrasImage.font=[UIFont fontWithName:FONT_NAME size:20.0f];
        self.lblCommentsImage.font=[UIFont fontWithName:FONT_NAME size:20.0f];
        self.lblVideosImage.font=[UIFont fontWithName:FONT_NAME size:20.0f];
        self.lblPhotosPlaceHolder.font=[UIFont fontWithName:FONT_NAME size:11.0f];
        self.lblVideoPlaceHolder.font=[UIFont fontWithName:FONT_NAME size:11.0f];
    }
}

- (void)registerNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImagePV"];
        
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImagePV"];
        
        [self.collectionViewVideos registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusVideoPV"];
        
        [self.collectionViewVideos registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualVideoPV"];
    }
    else
    {
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImagePV"];
        
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImagePV"];
        
        [self.collectionViewVideos registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusVideoPV"];
        
        [self.collectionViewVideos registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualVideoPV"];
    }
}

-(void)getVehicleListsFromServer
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL = [SMWebServices gettingListOfVehiclesImagesListForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue]];
    
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
            
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}


/*-(void)videoUploading
{
    NSLog(@"arrayCount = %lu",(unsigned long)arrayOfVideos.count);
    
    SMClassOfUploadVideos *objVideo = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:0];
    NSLog(@"URL..... = %@",objVideo.youTubeURL);
     NSLog(@"isVideoFromLocal = %d",objVideo.isVideoFromLocal);
    NSURL *url = [NSURL URLWithString:objVideo.youTubeURL];
    
    
    NSData* videoData = [NSData dataWithContentsOfURL:url];
    
    
    NSUInteger length = [videoData length];
   // NSUInteger chunkSize = 10000 * 1024; // chunk of 10MB size i.e // divide data into 10 mb
     NSUInteger chunkSize = 1000 * 1024; // chunk of 1MB
    NSUInteger offset = 0;
    do {
        NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
        NSData* chunk = [NSData dataWithBytesNoCopy:(char *)[videoData bytes] + offset
                                             length:thisChunkSize
                                       freeWhenDone:NO];
        offset += thisChunkSize;
        // do something with chunk
         NSString *base64Data = [chunk base64EncodedStringWithOptions:0];
        [self uploadTheVideoChunkToTheServerWithChunk:base64Data];
        
    } while (offset < length);

    
   
        
    
}*/


-(void)getLoadVehicleFromServer
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

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
            
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:self.tblCommentVideoAndPhotos];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 1;
    [self.tblCommentVideoAndPhotos setContentOffset:pt animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGPoint pt;
    [self.tblCommentVideoAndPhotos setContentOffset:pt animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    didUserChangeAnyThing = YES;
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - tableView delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        return 1;
    }
    else if (section==1)
    {
    
        return 2;
    }
    
    else if (section==2)
    {
        return 2;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return heightOfVehicleInfoSection+8.0;
    }
    else if (indexPath.section==1)
    {
        if(indexPath.row == 0)
        {
           return self.viewPhotos.frame.size.height;
        }
        else
        {
            return self.viewVideos.frame.size.height;
        }
       
    }
    else if(indexPath.section==2)
    {
        return self.viewComment.frame.size.height;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *commentVPCellIdentifer=@"commentVPCellIdentifer";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:commentVPCellIdentifer];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor blackColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    else
    {
        for (UIView *viw in cell.contentView.subviews)
        {
            [viw removeFromSuperview];
        }
    }
    if (indexPath.section==0)
    {
        [cell.contentView addSubview:self.viewVechicles];
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            [cell.contentView addSubview:self.viewPhotos];
            //cell.backgroundColor=[UIColor redColor];
        }
        else
        {
            [cell.contentView addSubview:self.viewVideos];
           // cell.backgroundColor=[UIColor purpleColor];
        }

    }
    else if (indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            [cell.contentView addSubview:self.viewComment];
            cell.backgroundColor=[UIColor greenColor];
        }
        else
        {
            [cell.contentView addSubview:self.viewExtras];
            cell.backgroundColor=[UIColor yellowColor];
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"arrayCnt = %lu",(unsigned long)arrayOfVideos.count);
    if (collectionView==collectionViewImages)
    {
        self.lblPhotoCount.text = [NSString stringWithFormat:@"%d",(int)[arrayOfImages count]];
        return [arrayOfImages count];
    }
    else
    {       self.lblVideosImage.text = [NSString stringWithFormat:@"%d",(int)[arrayOfVideos count]];
            return [arrayOfVideos count];
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.collectionViewImages)
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
    else
    {
       __weak SMCellOfPlusImageCommentPV *cellVideos = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMCellOfActualVideoPV" forIndexPath:indexPath];
            
            SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:indexPath.row];
           
            [cellVideos.btnDelete addTarget:self action:@selector(btnDeleteVideosDidClicked:) forControlEvents:UIControlEventTouchUpInside];
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
                    NSLog(@"ImageURL = %@",[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",videoObj.youTubeID]]);
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
    if (collectionView==collectionViewImages)
    {
        
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        networkGallery.startingIndex = indexPath.row;
        
        appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate.isPresented =  YES;
        [self.navigationController pushViewController:networkGallery animated:YES];
    }
    else
    {
        
        
        SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:indexPath.row];
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
            videoInfoVC.isFromPhotosNExtrasDetailPage = YES;
            videoInfoVC.isFromSendBrochureDetailPage = NO;
            videoInfoVC.isFromListPage = YES;
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
            NSString *videoFullPath;
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            
            [formatter setDateFormat:@"ddHHmmssSSS"];
            
            NSString *dateString=[formatter stringFromDate:[NSDate date]];
            
            NSString *videoName =[NSString stringWithFormat:@"%@_asset",dateString];
            
//          videoFullPath = [self saveVideo:videoUrl withName:videoName];
            NSLog(@"MoviePath = %@",moviePath);
            
//          videoThumImage=[[SMGlobalClass sharedInstance]generateVideoThumbnailImage:moviePath];
            
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
                    
                    [self.tblCommentVideoAndPhotos reloadData];
                    [self.collectionViewVideos reloadData];
                    
                });
                
                
            }];
        
        }
        
        // Picking Image from Camera/ Library
        SMVideoInfoViewController *videoInfoVC = [[SMVideoInfoViewController alloc] initWithNibName:@"SMVideoInfoViewController" bundle:nil];
        videoInfoVC.videoPathURL = moviePath;
        videoInfoVC.isVideoFromServer = NO;
        videoInfoVC.isFromCameraView = YES;
        videoInfoVC.isFromPhotosNExtrasDetailPage = YES;
        videoInfoVC.isFromSendBrochureDetailPage = NO;
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
            
                [arrayOfImages addObject:imageObject];
                
                selectedImage = nil;
            
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionViewImages reloadData];
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
    
    [self.collectionViewImages reloadData];
   
    
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
            [self.collectionViewImages reloadData];
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
#pragma mark - AlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== 101)
    {
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
                    
                    for (int i=deleteButtonTag+1;i<[arrayOfImages count];i++)
                    {
                        SMPhotosListNSObject *deleteImageObjectTemp = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:i];
                        deleteImageObjectTemp.imageOriginIndex--;
                    }
                }
            }
            
            
            
            isPrioritiesImageChanged = YES;
            
            [arrayOfImages removeObjectAtIndex:deleteButtonTag];
            [self.collectionViewImages reloadData];
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
                
                if(arrayOfVideos.count == 0)
                    [self.tblCommentVideoAndPhotos reloadData];
                [arrayOfVideos removeObjectAtIndex:deleteButtonTag];
                [self.collectionViewVideos reloadData];

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
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [HUD show:YES];
            [HUD setLabelText:KLoaderText];
            //[HUD hide:YES];
            // NSLog(@"thissssss");
            [self uploadingVideos];
        }
    }
    if (alertView.tag==901)
    {
        if(buttonIndex == 0)
        {
            NSMutableArray *arrmImageDetailObjects = [[NSMutableArray alloc] init] ;
            
            for(int i = 0;i<[arrayOfImages count];i++)
            {
                SMPhotosListNSObject *imageObj = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:i];
                
                if(imageObj.isImageFromLocal==YES)
                {
                NSString *imagePath = [self loadImagePath:[NSString stringWithFormat:@"%@.jpg",imageObj.strimageName]];
                
                // 2 for Vehicle
                NSDictionary *dictImageDetailObj = [NSDictionary dictionaryWithObjectsAndKeys:imagePath,@"ImagePath",[NSString stringWithFormat:@"%d",i+1],@"ImagePriority",@"2",@"ModuleIdentifier",self.photosExtrasObject.strUsedVehicleStockID,@"StockID",imageObj.strimageName,@"ImageFileName",[SMGlobalClass sharedInstance].strClientID,@"ClientID",[SMGlobalClass sharedInstance].strMemberID,@"MemberID", nil];
                
                [arrmImageDetailObjects addObject:dictImageDetailObj];
                }
                
            }
            ifUploadMobileData = NO;
            [[SMDatabaseManager theSingleTon] insertImageDetailsInDatabase:arrmImageDetailObjects];
            
            [self updateVehicleExtrasAndComments];
            
            // [[SMDatabaseManager theSingleTon] removeAllRecords];
            
        }
        else
        {
            
            for(int i = 0;i<[arrayOfImages count];i++)
            {
                SMPhotosListNSObject *imagesObject = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:i];
                if(imagesObject.isImageFromLocal==YES)
                {
                    UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imagesObject.strimageName];
                    NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
         
                    base64Str = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
                    [self uploadTheCommentImagesToTheServerWithPriority:i];
                }
            }
        }
    }
    
    
    
}
/*-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== 101)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
                     
                     for (int i=deleteButtonTag+1;i<[arrayOfImages count];i++)
                     {
                         SMPhotosListNSObject *deleteImageObjectTemp = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:i];
                         deleteImageObjectTemp.imageOriginIndex--;
                     }
                 }
            }
            
           
            
            isPrioritiesImageChanged = YES;
            
            [arrayOfImages removeObjectAtIndex:deleteButtonTag];
            [self.collectionViewImages reloadData];
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
           
            
            [arrayOfVideos removeObjectAtIndex:deleteButtonTag];
            if(arrayOfVideos.count == 0)
                [self.tblCommentVideoAndPhotos reloadData];
            
            [self.collectionViewVideos reloadData];
        }
    }
    if (alertView.tag==701)
    {
        if(buttonIndex==0)
        {
            [HUD hide:YES];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:kVehicleUpdatedSuccessfully delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 101;
             [alert show];
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
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [HUD hide:YES];
           // NSLog(@"thissssss");
            [self uploadingVideos];
        }
    }


    if (alertView==uploadAlert)
    {
        if (buttonIndex==1)
        {
            HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set determinate mode
            HUD.mode = MBProgressHUDModeAnnularDeterminate;
            HUD.delegate = self;
            HUD.labelText = @"\nUploading...";
            [self performSelector:@selector(uploadVideoMethod) withObject:nil afterDelay:0.5];
            
        }
        else
        {
            [arrayOfVideos removeObjectAtIndex:videoCellIndexPath.row];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(arrayOfVideos.count == 0)
                    [self.tblCommentVideoAndPhotos reloadData];
                
                [self.collectionViewVideos reloadData];
                
            });
        }
    }
}*/



#pragma mark - VideoPlayerNotification
-(void)moviePlaybackStateDidChange:(NSNotification *)notification
{
    MPMoviePlayerViewController *moviePlayerViewController = [notification object];
    
    if (moviePlayerViewController.moviePlayer.loadState == MPMovieLoadStatePlayable &&
        moviePlayerViewController.moviePlayer.playbackState != MPMoviePlaybackStatePlaying)
    {
        [moviePlayerViewController.moviePlayer play];
    }
    
    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:moviePlayerViewController];
    moviePlayerViewController = nil;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerViewController *moviePlayerViewController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerViewController];
    [self dismissMoviePlayerViewControllerAnimated];
    moviePlayerViewController = nil;
}

#pragma mark - UploadVideoMethods
-(void)uploadVideoMethod
{
    
    //[self.youtubeHelper uploadPrivateVideoWithTitle:self.photosExtrasObject.strVehicleName description:[self encodeString:self.txtViewComment.text] commaSeperatedTags:[self encodeString:self.txtViewExtras.text] andPath:moviePath];
    
}

#pragma mark - PlayVideoTapGestureMethod
-(void)videoPlayTapHandler:(UITapGestureRecognizer *)videoPlayerGestureRecog
{
    SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:videoPlayerGestureRecog.view.tag];
    
    MPMoviePlayerViewController *moviePlayeObj=[SMMoviePlayerClass allocMoviePlayerView:videoObj.localYouTubeURL];
    
    [self presentViewController:moviePlayeObj animated:YES completion:^{}];
    
    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:moviePlayeObj];
    
    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayeObj];
}

#pragma mark - LXReorderableCollectionViewDataSource methods
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
    if (collectionView==self.collectionViewImages)
    {
        SMPhotosListNSObject *imgObj = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:fromIndexPath.row];
        isPrioritiesImageChanged = YES;
        
        [arrayOfImages removeObjectAtIndex:fromIndexPath.item];
        [arrayOfImages insertObject:imgObj atIndex:toIndexPath.item];
    }
   /* else
    {
        SMClassOfUploadVideos *imageObject = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:fromIndexPath.row];
        
    
        [arrayOfVideos removeObjectAtIndex:fromIndexPath.item];
        [arrayOfVideos insertObject:imageObject atIndex:toIndexPath.item];
    }*/
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView==self.collectionViewImages)
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
    
    if (collectionView==self.collectionViewImages)
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
            ///////////////Monami issue while tap on cancel camera open//////////////////
            
            
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
             videoVC.isCameraViewFromEBrochure = NO;
            videoVC.videoVehicleName = [NSString stringWithFormat:@"%@-%@",self.lblVehicleName.text,self.photosExtrasObject.strStockCode];
            [self.navigationController pushViewController:videoVC animated:YES];
            
            SMClassOfUploadVideos *objVideo=[[SMClassOfUploadVideos alloc]init];

            
             [HomeViewController getTheGeneratedVideoWithCallBack:^(BOOL success, NSString *videoPath, UIImage *thumbnailImage,NSString *videoName, NSError *error)
            {
                if(success)
                {
                    NSLog(@"Called this 22......");
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
                     [self.tblCommentVideoAndPhotos reloadData];
                     [self.collectionViewVideos reloadData];
                     
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


- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    
    NSError *error = [theRequest error];
    NSString *errorString = [error localizedDescription];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:[NSString stringWithFormat:@"Vehicle updated successfully but could not upload video/s as %@.Do you wish to retry uploading video/s ?",errorString] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 801;
        [alert show];
        
    
    NSLog(@"/*/Failed to get data : %@",errorString);
    [HUD hide:YES];
    
}

- (void)uploadFinished:(ASIHTTPRequest *)theRequest
{
    
    NSString *response = [theRequest responseString];
    NSLog(@"/*/Response received : %@",response);
    
    NSRange range = [response rangeOfString:@"<Errors>"];
    
    if (range.location == NSNotFound)
    {
        NSLog(@"Authenticated!");// if <error> not found, record is present
        if(videoCount == (arrayOfVideos.count-1))
        {
            [HUD hide:YES];
            //uploadingHUD.hidden=YES;
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:kVehicleUpdatedSuccessfully delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 101;
            [alert show];
        }

    }
   else
    {
        [HUD hide:YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"Vehicle updated successfully but could not upload video/s." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 101;
        [alert show];
        

    }
    
   /* if([response hasPrefix:@"<Errors><Error>Client not set up to upload videos</Error></Errors>"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"Vehicle updated successfully but could not upload videos as Client is not set up to upload videos" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 101;
        [alert show];

    }
    else
    {
   // uploadingHUD.progress+=valueOfVideoProgress;
    
   // if (uploadingHUD.progress>=1.000000)
    {
        if(videoCount == (arrayOfVideos.count-1))
        {
        [HUD hide:YES];
        //uploadingHUD.hidden=YES;
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:kVehicleUpdatedSuccessfully delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 101;
        [alert show];
        }
        
    }
    }*/
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
   // uploadingHUD.progress = 0.0;
}



#pragma mark - uploadMethod
- (IBAction)btnSaveDidClicked:(id)sender
{
    appdelegate.isRefreshUI=YES;
    hasUserSavedAnyChangedInfo = YES;
   
    
   /* //ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:[NSURL URLWithString: urlString]];
    
    ASINetworkQueue  *networkQueue = [[ASINetworkQueue alloc] init];
    
    [networkQueue cancelAllOperations];
    
    [networkQueue setShowAccurateProgress:YES];
    
    [networkQueue setDelegate:self];
    
    [networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
    
    [networkQueue setRequestDidFailSelector: @selector(requestFailed:)];
    
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]] ;
    
    
    [request addRequestHeader:@"Content-Type"
                        value:@"multipart/form-data;boundary=---------------------------1842378953296356978857151853"];
    
    [request addRequestHeader:@"userHash" value:[SMGlobalClass sharedInstance].hashValue];
        [request addRequestHeader:@"Client" value:@"576"];
        [request addRequestHeader:@"usedVehicleStockID" value:self.photosExtrasObject.strUsedVehicleStockID];
        [request addRequestHeader:@"fileName" value:fileNameString];
        [request addRequestHeader:@"title" value:@"terrrst"];
        [request addRequestHeader:@"description" value:@"rr6767rrrr"];
        [request addRequestHeader:@"tags" value:@"file"];
        [request addRequestHeader:@"searchable" value:@"FALSE"];
        [request setRequestMethod:@"POST"];
    NSLog(@"objVideo.localYouTubeURLLLLLLL = %@",objVideo.localYouTubeURL);
    
    if(videoURL != nil)
    {
        [request setFile:objVideo.localYouTubeURL withFileName:fileNameString andContentType:@"video/quicktime" forKey:@"userfile"];
    }
   
    [request setTimeOutSeconds:5000];
    //NSLog(@"%@",request);
    [networkQueue addOperation:request];
   // [networkQueue go];*/
    
    
   /* if(arrayOfImages.count<=0)
    {
        [HUD show:YES];
        [HUD setLabelText:KLoaderText];
    }
    else
    {
        
        uploadingHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Set determinate mode
        uploadingHUD.mode = MBProgressHUDModeDeterminate;
        uploadingHUD.delegate = self;
        uploadingHUD.labelText = @"\nUploading...";
        
    }*/
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    
[self performSelector:@selector(uploadingImages) withObject:nil afterDelay:0.1];
    
}

/*- (void)requestFailed:(ASIHTTPRequest *)req
{
    if(req!= nil)
    {
        
        NSLog(@"[req responseStatusMessage] = %@",[req responseStatusMessage]);
        NSLog(@"[req responseStatusMessage] = %@",[req responseString]);
        [HUD hide:YES];
      
    }
    
   
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Failed to Post Item" message:[[req error] description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil, nil];
    [errorAlert show];
   
}
- (void)requestFinished:(ASIHTTPRequest *)req
{
    NSLog(@"Succeeeded....");
    [HUD hide:YES];
    NSLog(@"[req responseStatusMessage] = %@",[req responseStatusMessage]);
    NSLog(@"[req responseStatusMessage] = %@",[req responseString]);
    
  
    
}
*/



-(NSString *)mimeTypeForFileAtPath:(NSString*)path
{
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)CFBridgingRetain([path pathExtension]), NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    // Don't transfer ownership. ARC stays out of the way, and you must call `CFRelease` on `str` if appropriate (depending on how the `CFString` was created)
    NSString *string = (__bridge NSString *)MIMEType;
    
     return string;
}

- (IBAction)btnPlusBtnVideosDidClicked:(id)sender
{
    if(canClientUploadVideos)
    {
        NSPredicate *predicateLocalVideos = [NSPredicate predicateWithFormat:@"isVideoFromLocal == %d",YES];
        NSArray *arrayFiltered = [arrayOfVideos filteredArrayUsingPredicate:predicateLocalVideos];
        if(arrayFiltered.count<2)
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            actionSheetVideos=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Select from library", nil];
            }else{
            actionSheetVideos=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Select from library",@"Cancel", nil];
            }
            actionSheetVideos.tag=222;
            [actionSheetVideos showInView:self.view];
        }
    }
    else
    {
        [self loadPopup];
       
    }
    
}

-(void)uploadingImages
{
    
    NSPredicate *predicateVideos = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];
    NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateVideos];
    if ([arrayFiltered count] > 0)
    {
       
        isPrioritiesImageChanged = YES;
    }
    
    
    NSLog(@"isPrioritiesImageChanged = %d",isPrioritiesImageChanged);
    if (isPrioritiesImageChanged==YES)
    {
            if(arrayFiltered.count == 0)
             [self updateVehicleExtrasAndComments];
        
        // this stuff is for adding the new images to the server
        
            
            if(arrayFiltered.count >0)
            {
                reachability = [Reachability reachabilityForInternetConnection];
                internetStatus = [reachability currentReachabilityStatus];
                if (internetStatus != kReachableViaWiFi)
                {
                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Manager" message:@"You are on a mobile data network. Do you want to:" delegate:self cancelButtonTitle:@"Upload with WiFi" otherButtonTitles:@"Upload Now", nil];
                    alert.tag = 901;
                    [alert show];
                   
                }
                else
                {
                    
                    for(int i = 0;i<[arrayOfImages count];i++)
                    {
                        SMPhotosListNSObject *imagesObject = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:i];
                        if(imagesObject.isImageFromLocal==YES)
                        {
                            UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imagesObject.strimageName];
                            NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
                        
                            base64Str = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
                            [self uploadTheCommentImagesToTheServerWithPriority:i];
                        }
                    }
                }
               
            }
            
        for(int i=0;i<[arrayOfImages count];i++)
        {
            
            SMPhotosListNSObject *imagesObject = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:i];
            
            if(imagesObject.isImageFromLocal==NO)
            {
                [self updateCommentTheImagePrioritiesWithPriority:i andImageID:imagesObject.imageID];
            }
            
        }
        
        // this stuff is for deleting the images from the server
        for(int k=0;k<[[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted count];k++)
        {
            SMPhotosListNSObject *deleteImagesObject = (SMPhotosListNSObject*)[[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted objectAtIndex:k];
            
            [self deleteTheCommentImageWithImageID:deleteImagesObject.imageID usedVehicleStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue]];
        }
        
    }
    else if (isPrioritiesImageChanged==NO )
    {
        //uploadingHUD.hidden=YES;
        [HUD show:YES];
        [HUD setLabelText:KLoaderText];
        [self updateVehicleExtrasAndComments];
    }
}

-(void)uploadingVideos
{
   
    NSString *urlString = [SMWebServices uploadVideosWebserviceUrl]; // staging
    
    // this stuff is for adding the new videos to the server
    
    for(int i=0;i<[arrayOfVideos count];i++)
    {
        videoCount = i;
        SMClassOfUploadVideos *objVideo = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:i];
        
        NSString *isSearchable;
        
        if(objVideo.isSearchable)
            isSearchable = @"true";
        else
            isSearchable = @"false";
        
        NSLog(@"isSEarchable = %@",isSearchable);
        
        if(objVideo.isVideoFromLocal)
        {
            NSString *fileNameString = [objVideo.localYouTubeURL lastPathComponent];
            
            
            ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:[NSURL URLWithString: urlString]];
            NSLog(@"VIDEOURLL = %@",urlString);
            [request setTimeOutSeconds:120];
            
            [request setDelegate:self];
            [request setDidFailSelector:@selector(uploadFailed:)];
            [request setDidFinishSelector:@selector(uploadFinished:)];
            
            
            [request addRequestHeader:@"userHash" value:[SMGlobalClass sharedInstance].hashValue];
            [request addRequestHeader:@"Client" value:[SMGlobalClass sharedInstance].strClientID];
            [request addRequestHeader:@"usedVehicleStockID" value:self.photosExtrasObject.strUsedVehicleStockID];
            [request addRequestHeader:@"fileName" value:fileNameString];
            [request addRequestHeader:@"title" value:objVideo.videoTitle];
            [request addRequestHeader:@"description" value:objVideo.videoDescription];
            [request addRequestHeader:@"tags" value:objVideo.videoTags];
            [request addRequestHeader:@"searchable" value:isSearchable];
            [request setUploadProgressDelegate:HUD];
            
            //[request showAccurateProgress:YES];
            [request setFile:[[NSURL URLWithString:objVideo.localYouTubeURL] path] forKey:@"uploadfile"]; // this is POSIX path
            
             NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@",[SMGlobalClass sharedInstance].hashValue,[SMGlobalClass sharedInstance].strClientID,self.photosExtrasObject.strUsedVehicleStockID,fileNameString,objVideo.videoTitle,objVideo.videoDescription,objVideo.videoTags,isSearchable);
           // uploadingHUD.hidden = NO;
            [request setPostFormat:ASIMultipartFormDataPostFormat];
            [request setRequestMethod:@"POST"];
            
            [request startSynchronous];
        }
    }
    
}

-(void)updateVehicleExtrasAndComments
{
    // [HUD show:YES];
    // [HUD setLabelText:KLoaderText];
    NSLog(@"yyyyyyyy");
    NSMutableURLRequest *requestURL=[SMWebServices updateVehicleExtrasAndCommentsForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue] comments:[self encodeString:self.txtViewComment.text] extras:[self encodeString:self.txtViewExtras.text]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    //
    
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
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)deleteTheCommentImageWithImageID:(int)imageID usedVehicleStockID:(int)usedVehicleStockID
{
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices removeCommentImageFromVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:usedVehicleStockID imageID:imageID];
    
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
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)uploadTheCommentImagesToTheServerWithPriority:(int)priority
{
    
    SMPhotosListNSObject *imageObj = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:priority];
    
    NSMutableURLRequest *requestURL=[SMWebServices addImageToVehicleBase64ForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue] imageBase64:base64Str imageName:[NSString stringWithFormat:@"%@.jpg",imageObj.strimageName] imageTitle:[NSString stringWithFormat:@"%@",imageObj.strimageName] imageSource:@"phone app" imagePriority:priority+1 imageIsEtched:NO imageIsBranded:NO imageAngle:@""];
    
    NSLog(@"Request URL ==== %@",requestURL);
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    SMUrlConnection *connection = [[SMUrlConnection alloc] initWithRequest:requestURL delegate:self];
    connection.arrayIndex = priority;
    [connection start];
}

-(void)updateCommentTheImagePrioritiesWithPriority:(int)priority andImageID:(int)imageID
{
    NSMutableURLRequest *requestURL=[SMWebServices changeVehicleImagePriorityForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue] imageID:imageID newPriorityID:priority+1];
    
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
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)deleteTheSelectedVideoFromServerWithVideoLink:(int)videoLink
{
   NSMutableURLRequest *requestURL = [SMWebServices removeTheVideoLinkWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andVideoLinkID:videoLink];
    
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
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}
-(void)canUserUploadVideos
{
    NSMutableURLRequest *requestURL = [SMWebServices canUserUploadVideoWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
    
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
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
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
    if ([elementName isEqualToString:@"video"])
    {
        videoListObject=[[SMClassOfUploadVideos alloc]init];
    }
}

-(void)parser:(SMParserForUrlConnection *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(SMParserForUrlConnection *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"CanUploadVideoResult"])
    {
        canClientUploadVideos = [currentNodeContent boolValue];
        NSLog(@"canClientUploadVideos = %d",canClientUploadVideos);
    }
    if ([elementName isEqualToString:@"data"])
    {
        [HUD hide:YES];
      if([currentNodeContent isEqualToString:@"Link removed"])
          NSLog(@"Link removed");
        else
            NSLog(@"Failed to remove Link");
    }
    
    if ([elementName isEqualToString:@"LoadVehicleDetailsXMLResponse"])
    {
        if ([currentNodeContent isEqualToString:@"No Images"])
        { [self hideProgressHUD];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"No images found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag=101;
            
            [alert show];
            
        }
    }
    if ([elementName isEqualToString:@"ChangeImagePriorityForVehicleResponse"])
    {
       // uploadingHUD.progress+=valueOfProgress;
        imageLoopCount++;

        NSLog(@"imageLoopCount = %d",imageLoopCount);
        NSLog(@"arrayOfImages = %lu",(unsigned long)arrayOfImages.count);
       if(imageLoopCount == arrayOfImages.count)
        {
            [self updateVehicleExtrasAndComments];
           //  uploadingHUD.hidden=YES;
            
        }
        
       // NSLog(@"uploadingHUD.progress = %f",uploadingHUD.progress);

    }
    
    if ([elementName isEqualToString:@"UpdateVehicleExtrasAndCommentsResponse"])
    {
        
        //[HUD show:YES];
       // [HUD setLabelText:KLoaderText];

        isPrioritiesUpdateComments=NO;
        isPrioritiesImageChanged=NO;
        
        NSLog(@"DeleteVideosArrayCount = %lu",(unsigned long)[SMGlobalClass sharedInstance].arrayOfVideosToBeDeleted.count);
        if([[SMGlobalClass sharedInstance].arrayOfVideosToBeDeleted count]>0)
        {
            // this stuff is for deleting the videos from the server
            
            for(int k=0;k<[[SMGlobalClass sharedInstance].arrayOfVideosToBeDeleted count];k++)
            {
                SMClassOfUploadVideos *deleteImageObject = (SMClassOfUploadVideos*)[[SMGlobalClass sharedInstance].arrayOfVideosToBeDeleted objectAtIndex:k];
                
                [self deleteTheSelectedVideoFromServerWithVideoLink:deleteImageObject.videoLinkID];
                
            }
        }
        
        SMClassOfUploadVideos *videoObj ;
        if([arrayOfVideos count]>0)
        {
            videoObj = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:([arrayOfVideos count]-1)];
        }
        
        if([arrayOfVideos count]>0 && videoObj.isVideoFromLocal)
        {
            reachability = [Reachability reachabilityForInternetConnection];
            internetStatus = [reachability currentReachabilityStatus];
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
            
            
            NSString *alertMessage = [NSString stringWithFormat:@"It is recommended that you connect to a WiFi network to upload video files of %d MB, to avoid excessive data use. Do you want to:",(int)totalFileSizeMB];
            
            UIAlertView *alertt=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:alertMessage delegate:self cancelButtonTitle:@"Upload with WiFi" otherButtonTitles:@"Upload Now", nil];
                
            alertt.tag=701;
                
                if (ifUploadMobileData) {
                    [alertt show];
                }else{
                    [self loadVideoToDatabase];
                }
            }
        }
        else
        {
            {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:kVehicleUpdatedSuccessfully delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag=101;
            [alert show];
            [HUD hide:YES];
            }
           // uploadingHUD.progress=0.0;
        }
    }
    
    if ([elementName isEqualToString:@"AddImageToVehicleBase64Result"])
    {
        NSString *newString = [[currentNodeContent componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                               componentsJoinedByString:@""];
        
        SMPhotosListNSObject *imagePriorityIndexObject = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:parser.uniqueIdentifier];
        
        imagePriorityIndexObject.imageID = newString.intValue;
        NSLog(@"%d ********",parser.uniqueIdentifier);
        if(arrayOfImages.count>0)
            [self updateCommentTheImagePrioritiesWithPriority:parser.uniqueIdentifier andImageID:imagePriorityIndexObject.imageID];
        
    }

    
    // Image elements..
    
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
    else if ([elementName isEqualToString:@"imageLink"])
    {
        photosListObject.imageLink=currentNodeContent;
        
        NSString *fullImageString = photosListObject.imageLink;
        
        fullImageString = [fullImageString stringByReplacingOccurrencesOfString:@"width=340"
                                             withString:@"width=800"];
        
        photosListObject.imageLink = fullImageString;
        
        
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
        self.txtViewComment.text=currentNodeContent;
    }
    else if ([elementName isEqualToString:@"extras"])
    {
        self.txtViewExtras.text=currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"image"])
    {
        photosListObject.isImageFromLocal=NO;
        photosListObject.imageOriginIndex = -1;
        
        [arrayOfImages addObject:photosListObject];
        photosListObject=nil;
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
        videoListObject.isSearchable = currentNodeContent ;
    }
    if ([elementName isEqualToString:@"video"])
    {
        videoListObject.isVideoFromLocal=NO;
        NSLog(@"youTubeID = %@",videoListObject.youTubeID);
        [arrayOfVideos addObject:videoListObject];
        videoListObject=nil;
    }
    
    if ([elementName isEqualToString:@"LoadVehicleDetailsXMLResult"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideProgressHUD];
            [self.collectionViewImages reloadData];
            [self.collectionViewVideos reloadData];
        });
    }
    
    // video delete response
    
    
    
}

- (void)parserDidEndDocument:(SMParserForUrlConnection *)parser
{
   // [self hideProgressHUD];
}

#pragma mark - NSURL connection delegate methods


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"This is didReceiveAuthenticationChallenge");
    [[challenge sender] rejectProtectionSpaceAndContinueWithChallenge:challenge];
}
- (void)connection:(NSURLConnection *)connection
willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"This is didReceiveAuthenticationChallenge");
    [[challenge sender] rejectProtectionSpaceAndContinueWithChallenge:challenge];
}

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
    SMAlert(@"Error", error.localizedDescription);
}

- (void)connectionDidFinishLoading:(SMUrlConnection *)connection
{
    NSLog(@"hereeeeeeeeeee");
    NSLog(@"ResponseData length = %lu",(unsigned long)responseData.length);
    
    //NSString *xml = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
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
   
    [HUD hide:YES];
}

#pragma mark -

#pragma mark - Show Help View


// Purpose - this will encode string to CDATA XML

-(NSString *) encodeString:(NSString *) encodeString
{
    encodeString = [NSString stringWithFormat:@"<![CDATA[%@]]>",encodeString]; // category method call
    return encodeString;
}
- (NSString*)getImageFromImageName:(NSString*)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryy = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectoryy stringByAppendingPathComponent:imageName];
    return getImagePath;
}
///***************

#pragma mark - Action methods

#pragma mark - didReceiveMemoryWarning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)btnPlusImageDidClicked:(id)sender
{
    [SMGlobalClass sharedInstance].isTapOnCancel = NO;
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
        ///////////////Monami Add Cancel option for iPad//////////////////
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            actionSheetPhotos = [[UIActionSheet alloc] initWithTitle:@"Select the picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Select from library", nil];
        }else{
        actionSheetPhotos = [[UIActionSheet alloc] initWithTitle:@"Select the picture" delegate:self cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Select from library",@"Cancel", nil];
            
        }
        ///////////////// End/////////////////////////////////////
            actionSheetPhotos.actionSheetStyle = UIActionSheetStyleDefault;
            actionSheetPhotos.tag=101;
            [actionSheetPhotos showInView:self.view];
        
        
    }
    
}

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    //UIColor *foregroundColorGreen = [UIColor colorWithRed:64.0/255.0 green:198.0/255.0 blue:42.0/255.0 alpha:1.0];
    
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ |",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    
    
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
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

- (IBAction)btnEditDidClicked:(id)sender
{
    NSLog(@" edit with index %ld",(long)[sender tag]);
    
    SMAddToStockViewController *addToStockVC;
    
    addToStockVC = [[SMAddToStockViewController alloc]initWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)? @"SMAddToStockViewController" : @"SMAddToStockViewController_iPad" bundle:nil];
    
    addToStockVC.photosExtrasObject = self.photosExtrasObject;
    addToStockVC.isUpdateVehicleInformation = YES;
    addToStockVC.listRefreshDelegate = self;
    [SMGlobalClass sharedInstance].isListModule = YES;
    
    [self.navigationController pushViewController:addToStockVC animated:YES];
    
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
