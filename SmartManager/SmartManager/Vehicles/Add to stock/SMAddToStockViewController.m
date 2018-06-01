//
//  SMAddToStockViewController.m
//  SmartManager
//
//  Created by Priya on 21/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMAddToStockViewController.h"
#import "SMAddToStockTableViewCell.h"
#import "SMCellOfPlusImage.h"
#import "SMClassOfBlogImages.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMPreviewBlogViewController.h"
#import "SMSaveBlogDataObject.h"
#import "SMClassOfBlogImages.h"
#import "UIImageView+WebCache.h"
#import "SMLoadVehicleTableViewCell.h"
#import "SMCellOfPlusImageCommentPV.h"
#import "SMCellOfPlusImageCommentPV.h"
#import "UIBAlertView.h"
#import "UIActionSheet+Blocks.h"
//load vehicle
#import "SMLoadVehiclesViewController.h"
// list of vehicle in phots and extrs
#import "SMPhotosAndExtrasListViewController.h"

#import "NSString+SMURLEncoding.h"

#import "SMUrlConnection.h"
#import "SMAppDelegate.h"
#import "Constant.h"
#import "HomeViewController.h"
#import "SMVideoInfoViewController.h"
#import "Reachability.h"


#define ACCEPTABLE_CHARACTERS      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ACCEPTABLE_CHARACTERS_TRIM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ACCEPTABLE_CHARACTERS_OEM  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ACCEPTABLE_CHARACTERS_Number @"0123456789"
#define ACCEPTABLE_CHARACTERS_WITHSPACE @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
typedef enum : NSUInteger {
    kTextLocation = 1,
    kTextReg = 2,
    kTextVin= 3,
    kTextEngibe = 4,
    kTextOme = 5,
    kTextCostR = 6,
    kTextStanInR= 7,
    KTextAddTender= 8,
    KTextViewInternamNote= 9,
    KTextTrim=10,
    
} textViewTags;



@interface SMAddToStockViewController ()
{
    int imageLoopCount;
    Reachability *reachability ;
    NetworkStatus internetStatus;
    NSArray *arrayFilteredImages;
    BOOL ifUploadMobileData;
   
}

@end

@implementation SMAddToStockViewController
@synthesize strSelctedVarinatName, isUpdateVehicleInformation,strVariantId;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        arrayOfImages           = [[NSMutableArray alloc]init];
        arrayOfVideos           = [[NSMutableArray alloc]init];
        temporaryVideosUploadArray           = [[NSMutableArray alloc]init];
        listAddToTenderArray    = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
     ifUploadMobileData = YES;
    canClientUploadVideos = NO;
    [self canUserUploadVideos];
    
    indexpathOfSelectedVideo = -1;
    imageLoopCount = 0;
    
    viewContainingVideos.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    viewContainingVideos.layer.borderWidth= 0.8f;
    
     if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
         lblVideoInfo.font = [UIFont fontWithName:FONT_NAME size:10.0];
    else
         lblVideoInfo.font = [UIFont fontWithName:FONT_NAME size:13.0];
    
    imgCount =0;

    [self addingProgressHUD];

    [txtType setText:@"Used"];
    
    [btnVehicleIsRetail setSelected:YES];// Change by Dr. Ankit because of RUAN tester
    
    if([SMGlobalClass sharedInstance].isListModule == YES) // IF FROM LIST MODULE
    {
         self.navigationItem.titleView = [SMCustomColor setTitle:@"Edit Stock"];
        
        [self.lblMakeModel removeFromSuperview];
        [lblMM removeFromSuperview];
        [self.lblInfos removeFromSuperview];
        
     
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        singleTap.delegate = self;
        self.imgViewVehicle.userInteractionEnabled = YES;
        [self.imgViewVehicle addGestureRecognizer:singleTap];
        
        if([self.photosExtrasObject.strColour isEqualToString:@"Colour?"])
        {
             txtColour.text  = @"";
        }
        else
        {
            txtColour.text      = self.photosExtrasObject.strColour;
        }
        
        if([self.photosExtrasObject.strStockCode isEqualToString:@"Stock code?"])
        {
            txtStock.text  = @"";
        }
        else
        {
            txtStock.text      = self.photosExtrasObject.strStockCode;
        }
        
        txtMileage.text     = self.photosExtrasObject.strMileage;
        self.strUsedYear    = self.photosExtrasObject.strUsedYear;
        lblVehicleName.text = [NSString stringWithFormat:@"%@ %@",self.strUsedYear,self.photosExtrasObject.strVehicleName];
        [self getLoadVehicleFromServer];
    }
    else
    {
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Add To Stock"];
       
        NSString *strYearStr = [strSelctedVarinatName substringToIndex:4];
        NSString *strMakeModel = [strSelctedVarinatName substringFromIndex:5];
         NSLog(@"lblVehicleName222 = %@***%@",strYearStr,strMakeModel);
        [self setAttributedTextForVehicleDetailsWithFirstText:strYearStr andWithSecondText:strMakeModel forLabel:self.lblMakeModel];
        [self.lblMakeModel sizeToFit];
        
        lblMM.frame = CGRectMake(lblMM.frame.origin.x,self.lblMakeModel.frame.origin.y + self.lblMakeModel.frame.size.height + 8.0, lblMM.frame.size.width, lblMM.frame.size.height);
        
        self.lblInfos.frame = CGRectMake(self.lblInfos.frame.origin.x,lblMM.frame.origin.y + lblMM.frame.size.height + 10.0,self.lblInfos.frame.size.width,self.lblInfos.frame.size.height);
        
        if(![SMGlobalClass sharedInstance].isListModule)
        {
        self.viewHoldingBottomHeaderData.frame = CGRectMake(self.viewHoldingBottomHeaderData.frame.origin.x, self.lblInfos.frame.origin.y + self.lblInfos.frame.size.height +3.0, self.viewHoldingBottomHeaderData.frame.size.width, self.viewHoldingBottomHeaderData.frame.size.height);
        }
        
        [txtVehicleYear setText:self.strUsedYear];
        txtColour.text = self.VINLookupObject.Colour;
        txtStock.text  = self.strStockNumber;
        lblMM.text     = [NSString stringWithFormat:@"M&M : %@",self.strMeanCode];
        [self fetchVariantDetialsWithVariantID:strVariantId]; // getting all variant informations
        
        if (isUpdateVehicleInformation == NO)
        {
            strSlectedTypeId = 2;
            //[btnVehicleIsRetail setSelected:YES];
        }
        
        
    }
    [self gettingYearCustomFunction];
    
    
        
    self.tableView.tableHeaderView=self.headerView;
    self.tableView.tableFooterView = self.footerView;

    [self setCustomFont];
    // Check for tender
    [self checkAddToTenderVisibleOrNot];
    // fetching all vehicle type (Departments)
    [self fetchVehicleType];
    // Registering All the Nib
    [self registeringTheNib];
    
    if([SMGlobalClass sharedInstance].isListModule == NO)
        [self.btnEditVariant setHidden:YES];
    else
        [self.btnEditVehicle setHidden:YES];
    
    self.multipleImagePicker = [[RPMultipleImagePickerViewController alloc] init];
    self.multipleImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.multipleImagePicker.photoSelectionDelegate = self;
    isInfoOnlySaved = NO;
    didUserChangeAnything = NO;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                   withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-7.0f];
    UIButton *buttonMenu = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 21)];
    [buttonMenu setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [buttonMenu addTarget:self action:@selector(pushBackToListingView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnMenu =  [[UIBarButtonItem alloc]initWithCustomView:buttonMenu];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,btnMenu];
    // self.navigationItem.leftBarButtonItem = btnMenu;
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    /*self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(pushBackToListingView)];*/
    
   /* UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"defaultBackBtn"] style:UIBarButtonItemStylePlain target:self action:@selector(pushBackToListingView)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];*/
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [self hideProgressHUD];
    //[SMGlobalClass sharedInstance].isListModule = NO; // this was made zero because while picking videos from library the video details was blank in the video info page
    [popupView removeFromSuperview];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    
    NSPredicate *predicateServerImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];// from server
    NSArray *arrayServerFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateServerImages];
    
    NSPredicate *predicateLocalImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];// from device
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
    
    BOOL thirdConditionResult = ((arrayImageFiltered.count > 0 || arrayVideoFiltered.count > 0) && !isInfoOnlySaved);
    
    NSLog(@"isInfoOnlySaved = %d",isInfoOnlySaved);
     NSLog(@"didUserChangeAnything = %d",didUserChangeAnything);
     NSLog(@"thirdConditionResult = %d",thirdConditionResult);
    
    if(didUserChangeAnything || ((arrayImageFiltered.count > 0 || arrayVideoFiltered.count > 0) ))
    {
        if(!isInfoOnlySaved)
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
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
#pragma mark -

#pragma mark - custom font

-(void)setCustomFont
{
    pickerView.layer.cornerRadius=15.0;
    pickerView.clipsToBounds      = YES;
    pickerView.layer.borderWidth=1.5;
    pickerView.layer.borderColor=[[UIColor blackColor] CGColor];
    
    pickerVehicleViewContainer.layer.cornerRadius=15.0;
    pickerVehicleViewContainer.clipsToBounds      = YES;
    pickerVehicleViewContainer.layer.borderWidth=1.5;
    pickerVehicleViewContainer.layer.borderColor=[[UIColor blackColor] CGColor];

    
    loadVehicleTableView.layer.cornerRadius =15.0;
    loadVehicleTableView.clipsToBounds      =YES;
    loadVehicleTableView.layer.borderWidth  =1.5;
    loadVehicleTableView.layer.borderColor  =[[UIColor blackColor] CGColor];
    
    
    txtType.toolbarDelegate = self;
    [txtType setRightViewMode:UITextFieldViewModeAlways];
    txtType.rightView= downArrowButton5;
   
    txtVehicleYear.delegate = self;
    [txtVehicleYear setRightViewMode:UITextFieldViewModeAlways];
    txtVehicleYear.rightView = downArrowButton6;
    

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        btnVehicleProgram.titleLabel.font   = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
        btnVehicleIsRetail.titleLabel.font  = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
        btnVehicleIsTender.titleLabel.font  = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
        txtVehicleYear.font                 = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        btnVehicleProgram.titleLabel.font   = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
        btnVehicleIsRetail.titleLabel.font  = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
        btnVehicleIsTender.titleLabel.font  = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
        txtVehicleYear.font                 = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];

    }

    txtTrade.toolbarDelegate      = self;
    txtColour.toolbarDelegate     = self;
    txtMileage.toolbarDelegate    = self;
    txtPriceRetail.toolbarDelegate= self;
    txtStock.toolbarDelegate      = self;
    txtProgramName.toolbarDelegate= self;
    txtCondition.toolbarDelegate  = self;

    [txtComment setPlaceholderColor:[UIColor whiteColor]];
    txtComment.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    txtComment.layer.borderWidth= 0.8f;
    txtComment.toolbarDelegate=self;
    txtComment.delegate=self;
    
    
    
    [txtComment setFont:[UIFont fontWithName:FONT_NAME size:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? FONT_SIZE_iPHone:FONT_SIZE_iPad]];
    [txtExtras setFont:[UIFont fontWithName:FONT_NAME size:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? FONT_SIZE_iPHone:FONT_SIZE_iPad]];
    
    [txtExtras setPlaceholderColor:[UIColor whiteColor]];
    txtExtras.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    txtExtras.layer.borderWidth= 0.8f;
    txtExtras.toolbarDelegate=self;
    txtExtras.delegate=self;
    

    
    viewPhotosOuter.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    viewPhotosOuter.layer.borderWidth= 0.8f;

    //viewVideoOuter.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    //viewVideoOuter.layer.borderWidth= 0.8f;
    
   
    txtVehicleYear.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    txtVehicleYear.layer.borderWidth= 0.8f;
    
    txtVehicleYear.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [txtVehicleYear setLeftViewMode:UITextFieldViewModeAlways];
    [txtVehicleYear setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)]];
    
    [txtVehicleYear setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark - User Define Function For Calling Web Service
-(void)checkAddToTenderVisibleOrNot
{
    
    
    NSMutableURLRequest *requestURL=[SMWebServices lisAddToTenderForUserhash:[SMGlobalClass sharedInstance].hashValue];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [HUD show:YES];
    HUD.labelText = KLoaderText;

    
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
             
             listAddToTenderArray = [[NSMutableArray alloc] init];
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
    
}
-(void)fetchVehicleType
{
    
    NSMutableURLRequest *requestURL=[SMWebServices fectchListVehicleTypeForUserhash:[SMGlobalClass sharedInstance].hashValue];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [HUD show:YES];
    HUD.labelText = KLoaderText;

    
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
             
             vehicleTypeArray = [[NSMutableArray alloc] init];
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}
-(void)fetchVariantDetialsWithVariantID:(int)variantID
{
    
    NSMutableURLRequest *requestURL;
    
    
    if(![SMGlobalClass sharedInstance].isListModule)
    {
        //isSpecDetails = YES;
        requestURL=[SMWebServices gettingDetailsOfVINForVehicles:[SMGlobalClass sharedInstance].hashValue  variantId:variantID];
        
    }
    else
    {
       // isSpecDetails = NO;
        requestURL=[SMWebServices gettingDetailsForEditStockVehicles:[SMGlobalClass sharedInstance].hashValue  variantId:variantID];
    }
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [HUD show:YES];

    HUD.labelText = KLoaderText;
    
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
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}
-(void)getImageExtrasAndComment
{
    
    NSMutableURLRequest *requestURL = [SMWebServices gettingLoadVehiclesImagesListForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:self.iStockID];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [HUD show:YES];
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
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



#pragma mark - 


#pragma mark - xml parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    countOfSpec =0;

}

-(void) parser:(SMParserForUrlConnection *)  parser
didStartElement:(NSString *)    elementName
  namespaceURI:(NSString *)     namespaceURI
 qualifiedName:(NSString *)     qName
    attributes:(NSDictionary *)    attributeDict
{
    if ([elementName isEqualToString:@"SpecDetails"])
    {
        isSpecDetails = YES;
    }
    
    if ([elementName isEqualToString:@"spec"])
    {
        countOfSpec++;
    }
    if ([elementName isEqualToString:@"LoadVehicleDetailsXMLResult"])
    {
        self.photosExtrasDetailsObject=[[SMPhotosAndExtrasObject alloc]init];
    }
    if ([elementName isEqualToString:@"image"])
    {
        photosListObject=[[SMPhotosListNSObject alloc]init];
    }
    if ([elementName isEqualToString:@"video"])
    {
        videoListObject=[[SMClassOfUploadVideos alloc]init];
    }
    /*if ([elementName isEqualToString:@"spec"])
    {
        strVariantPetrol_Value = [attributeDict valueForKey:@"Fuel Type"];
        strVariantKW_Value = [attributeDict valueForKey:@"Power KW"];
        strVariantNM_Value = [attributeDict valueForKey:@"Torque NM"];
        
        NSLog(@"strVariantPetrol_Value = %@",strVariantPetrol_Value);
        NSLog(@"strVariantKW_Value = %@",strVariantKW_Value);
        NSLog(@"strVariantNM_Value = %@",strVariantNM_Value);
        
    }*/

    currentNodeContent = [NSMutableString stringWithString:@""];
}

-(void)parser:(SMParserForUrlConnection *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}


-(void)parser:(SMParserForUrlConnection *)parser foundCDATA:(NSData *)CDATABlock
{

    NSString *string = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
     [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}


-(void)parser:(SMParserForUrlConnection *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
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

    
    //get varientDetails data
    if ([elementName isEqualToString:@"VariantDetailsResult"])
    {
        
        
        // IF no infomration present jst show "No Information loaded" else show information
        //currentNodeContent.length == 0 ? (self.lblInfos.text = @"") : (self.lblInfos.text = currentNodeContent);
        if(currentNodeContent.length == 0) {
            self.lblInfos.text = @"";
        }
        else
        {
            NSArray *arr = [currentNodeContent componentsSeparatedByString:@"|"];
            NSString *string  = [NSString stringWithFormat:@"%@| %@ | %@",arr[2],arr[0],arr[1]];
            self.lblInfos.text = string;
            NSLog(@"wwwwwwwwwwwwww");
        }
        /// once got variant detail informations and is Updation then fetch extras and comments
        if(isUpdateVehicleInformation == YES && ![SMGlobalClass sharedInstance].isListModule)
            [self getImageExtrasAndComment];
        else
            [self hideProgressHUD];
        
    }
    
    if ([elementName isEqualToString:@"spec"])
    {
        if(isSpecDetails)
        {
        if(countOfSpec == 2)
            strVariantPetrol_Value = currentNodeContent;
        
        if(countOfSpec == 3)
            strVariantKW_Value = currentNodeContent;
        
        if(countOfSpec == 4)
            strVariantNM_Value = currentNodeContent;
       
        if(countOfSpec ==4)
        {
            
            strEditStockVehicleDetails = [NSString stringWithFormat:@"%@ | %@ | %@",strVariantKW_Value,strVariantNM_Value,strVariantPetrol_Value];
            
            self.lblVehicleDetails.text = strEditStockVehicleDetails;
             NSLog(@"aaaaaaaaaaa");
            [self hideProgressHUD];
            
        }
        }
        
    }
    if ([elementName isEqualToString:@"VariantDetailsXMLResponse"])
    {
         if([currentNodeContent length] == 0)
         strEditStockVehicleDetails = @"";
        
        [self hideProgressHUD];
    }
    //*************  Getting vehicle type**************
    
    if ([elementName isEqualToString:@"ListVehicletypeJSONResult"])
    {
        NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                vehicleTypeObject           =[[SMVehicleTypeObject alloc]init];
                vehicleTypeObject.strTypeId =dictionary[@"vtID"];
                vehicleTypeObject.strType   =dictionary[@"vtName"];
                [vehicleTypeArray addObject:vehicleTypeObject];
            }
            
        }
        else
        {
            SMAlert(KLoaderTitle, [jsonObject valueForKey:@"message"]);
        }
        
    }
    
    
    if ([elementName isEqualToString:@"department"])
    {
        if([currentNodeContent isEqualToString:@""])
        {
            [txtType setText:@"Used"];
            strSlectedTypeId = 2;
        }
        else
        [txtType setText:currentNodeContent];
    }
    if ([elementName isEqualToString:@"departmentID"])
    {
        strSlectedTypeId = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"friendlyName"])
    {
        if([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"[No MM Code]"])
        {
            NSLog(@"cosOfThis1");
            self.lblVehicleName.text = @"";
        }
        else
        {
             NSLog(@"cosOfThis2");
            self.lblVehicleName.text = currentNodeContent;
        }
    }
    
    
    if ([elementName isEqualToString:@"ListVehicletypeJSONResponse"])
    {
        if (vehicleTypeArray.count!=0)
        {
            pickerView.hidden=YES;
            loadVehicleTableView.hidden=NO;
        }
    }
    //************* END -  Getting vehicle type**************
    
    
    
    //*************  Getting List Of Tender**************
    if ([elementName isEqualToString:@"ListTenderJSONResult"])
    {
      //  isVehicleType=NO;
        
        NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                loadVehiclesObject              =[[SMLoadVehiclesObject alloc]init];
                loadVehiclesObject.strMakeId    =dictionary[@"tenderID"];
                loadVehiclesObject.strMakeName  =dictionary[@"tenderName"];
                [listAddToTenderArray   addObject:loadVehiclesObject];
            }
        }
        else
        {
            isTender=NO;
        }
    }
    if ([elementName isEqualToString:@"ListTenderJSONResponse"])
    {
        [[self tableView]reloadData];
        
    }
    //************* END - Getting List Of Tender**************
    
    
    
    
    //************* Getting Add Vehicle To Stcok Resposne **************
    
   
    if ([elementName isEqualToString:@"AddVehicleViaObjResponse"])
    {
        NSArray *strSeprated=[currentNodeContent componentsSeparatedByString:@":"];
        if ([[strSeprated objectAtIndex:0]isEqualToString:@"OK"])
        {
            
            self.iStockID = [[NSString stringWithFormat:@"%@",[strSeprated objectAtIndex:1]] intValue];
            
             NSLog(@"self.iStockID 22 = %d",self.iStockID);
            
           // [self hideProgressHUD];
            
              if(!isUpdateVehicleInformation)
              {
                  if(arrayOfImages.count>0)
                  {
                      [HUD show:YES];
                       [HUD setLabelText:KLoaderText];
                      [self uploadTheImagesWhenNewStock];
                  }
                  else
                  {
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
                      if([temporaryVideosUploadArray count]>0)
                      {
                          videoObj = (SMClassOfUploadVideos*)[temporaryVideosUploadArray objectAtIndex:([temporaryVideosUploadArray count]-1)];
                      }
                      
                      if([temporaryVideosUploadArray count]>0 && videoObj.isVideoFromLocal)
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
                              
                              for(int i =0;i<[temporaryVideosUploadArray count];i++)
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
                          
                          UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:kVehicleStockSuccess delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                          alert.tag=101;
                          NSLog(@"thisMessage11");
                          [alert show];
                         // uploadingHUD.progress=0.0;
                      }
                      
                  }
              }
              else
              {
            
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
                if([temporaryVideosUploadArray count]>0)
                {
                    videoObj = (SMClassOfUploadVideos*)[temporaryVideosUploadArray objectAtIndex:([temporaryVideosUploadArray count]-1)];
                }
                
                if([temporaryVideosUploadArray count]>0 && videoObj.isVideoFromLocal)
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
                        
                        for(int i =0;i<[temporaryVideosUploadArray count];i++)
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
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:kVehicleStockSuccess delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    alert.tag=101;
                    
                    [alert show];
                    //uploadingHUD.progress=0.0;
                }
           }
        
        }
        else
        {
            SMAlert(KLoaderTitle,KErrorInSavingStcok);
            [self hideProgressHUD];
        }
    }
    
    if ([elementName isEqualToString:@"faultcode"])
    {
        SMAlert(KLoaderTitle,KErrorInSavingStcok);
        [self hideProgressHUD];
        return;
    }
    
    
    //************* END -Getting Add Vehicle To Stcok Resposne **************
    
    
    
    //************* Getting Vehicle Images **************
    
    if ([elementName isEqualToString:@"ListVehicleImagesXMLResponse"])
    {
        if ([currentNodeContent isEqualToString:@"No Images"])
        {
            SMAlert(KLoaderTitle,KNoimagesFound);
        }
    }
    if ([elementName isEqualToString:@"RemoveImageFromVehicleResponse"])
    {
        countForShowingAlert--;
        
        
        if (arrayOfImages.count == 0) {
            
        
        //uploadingHUD.progress+=valueOfProgressDeletion;
            
            
                    if (countForShowingAlert<=0)
                    {
                        [HUD hide:YES];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            NSLog(@"33333");

                            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:kVehicleStockSuccess cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                                if (didCancel)
                                {
            
                                    if([self.listRefreshDelegate respondsToSelector:@selector(refreshTheVehicleListModule)])
                                    {
                                        [self.listRefreshDelegate refreshTheVehicleListModule];
                                    }
                                    if (isSaveAndClosed == YES)
                                    {
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                    return;
                                    
                                    
                                }
                                
                            }];
                            
                            
                            
                        });
                    }
 
        
        
        }
        
    }
    
    
    //************* END - Getting Vehicle Images **************
    
    
    
    //*************Image Priority Changed**************
    
    if ([elementName isEqualToString:@"ChangeImagePriorityForVehicleResponse"])
    {
        NSPredicate *predicateVideos = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];
        NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateVideos];
        imageLoopCount++;
        NSLog(@"imageLoopCount = %d",imageLoopCount);
        NSLog(@"arrayOfImages = %lu",(unsigned long)arrayFiltered.count);
       // uploadingHUD.progress+=valueOfProgress;
        
        // NSLog(@"uploadingHUD.progress 1 = %f",uploadingHUD.progress);
       // kjkjkhjk
        //if (uploadingHUD.progress >= 0.99999988)
        if(imageLoopCount == arrayFiltered.count)
        {
            imageLoopCount = 0;
           // [uploadingHUD setHidden:YES];
            
            if ([SMGlobalClass sharedInstance].isListModule)
            {
                [self updateVehicleInformations];
                
            }
            else
            {
                if(!isUpdateVehicleInformation)
                {
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
                    if([temporaryVideosUploadArray count]>0)
                    {
                        videoObj = (SMClassOfUploadVideos*)[temporaryVideosUploadArray objectAtIndex:([temporaryVideosUploadArray count]-1)];
                    }
                    
                    if([temporaryVideosUploadArray count]>0 && videoObj.isVideoFromLocal)
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
                            
                            for(int i =0;i<[temporaryVideosUploadArray count];i++)
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
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:kVehicleStockSuccess delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    alert.tag=101;
                    NSLog(@"thisMessage11");
                    [alert show];
                   // uploadingHUD.progress=0.0;
                    }
                    
                }
                else
                {
                    
                    if(!isSaveAndClosed)
                    {
                        isUpdateVehicleInformation == YES ? [self updateVehicleInformations] : [self addvehicleInToStock];
                    }
                    else
                    {
                        [self updateVehicleInfoWhenNotInListModule];
                    }
                }
                
                
            }

            
           /* dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"44444");
                NSLog(@"uploadingHUD.progress = %f",uploadingHUD.progress);

                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:kVehicleStockSuccess cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 isPrioritiesImageChanged = NO;
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                    if (didCancel)
                    {
                        
                        if([self.listRefreshDelegate respondsToSelector:@selector(refreshTheVehicleListModule)])
                        {
                            [self.listRefreshDelegate refreshTheVehicleListModule];
                        }
                        if (isSaveAndClosed == YES)
                        {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        return;
                    }
                    
                }];
                

            });*/
        }
     
       // NSLog(@"uploadingHUD.progress 2 = %f",uploadingHUD.progress);

    }
    //*************END - Image Priority Changed**************
    
    
    
    //************* Update Vehicle Comments And Extra Response**************
    
    if ([elementName isEqualToString:@"UpdateVehicleExtrasAndCommentsResponse"])
    {
       // [uploadingHUD setHidden:YES];
        
       // isPrioritiesVideoChanged=NO;
        isPrioritiesImageChanged=NO;
        
        
        dispatch_async(dispatch_get_main_queue(),^{
            
            NSLog(@"55555");

            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:kVehicleStockSuccess cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            isPrioritiesImageChanged = NO;
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                if (didCancel)
                {
                    
                    if([self.listRefreshDelegate respondsToSelector:@selector(refreshTheVehicleListModule)])
                    {
                        [self.listRefreshDelegate refreshTheVehicleListModule];
                    }
                    if (isSaveAndClosed == YES)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    return;
                
                    
                    return;
                }
                
            }];
            
        });
        
        //uploadingHUD.progress=0.0;
    }
    //************* END - Update Vehicle Comments And Extra Response**************
    
    
    
    //************* Update Vehicle Resposne **************
    
    if ([elementName isEqualToString:@"UpdateVehicleViaObjResult"])
    {
        
       // [uploadingHUD setHidden:YES];
        
        NSArray *arrayUpdateSuccessMessage = [currentNodeContent componentsSeparatedByString:@":"];
        
        if([arrayUpdateSuccessMessage containsObject:@"OK"])
        {
           // [self performSelector:@selector(uploadingAddStockImages) withObject:nil afterDelay:0.1];
            
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
            if([temporaryVideosUploadArray count]>0)
            {
                videoObj = (SMClassOfUploadVideos*)[temporaryVideosUploadArray objectAtIndex:([temporaryVideosUploadArray count]-1)];
            }
            
            if([temporaryVideosUploadArray count]>0 && videoObj.isVideoFromLocal)
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
                    
                    for(int i =0;i<[temporaryVideosUploadArray count];i++)
                    {
                        SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[temporaryVideosUploadArray objectAtIndex:i];
                        
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
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:kVehicleStockSuccess delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag=101;
                
                [alert show];
               // uploadingHUD.progress=0.0;
            }

            
        }
        else if([arrayUpdateSuccessMessage containsObject:@"ERROR"])
        {
        
            SMAlert(@"Error",KDuplicateStockCode);
            [self hideProgressHUD];
           // [uploadingHUD setHidden:NO];

        }
        else
        {
            SMAlert(KLoaderTitle, currentNodeContent);
            [self hideProgressHUD];
           // [uploadingHUD setHidden:NO];
        }
    
    }
    
    //************* END - Update Vehicle Resposne **************
    
    
    if ([elementName isEqualToString:@"ListVehicleImagesXMLResult"])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.photosCollectionView reloadData];
            [self.videosCollectionView reloadData];
        });
    }
    
    
    
    //************* Fetching All Other Infromation for Vehicle **************
    
    
    // comments and extras
    
    
    
    if ([elementName isEqualToString:@"extras"])
    {
        [txtExtras setText:currentNodeContent];
    }
    
    if([elementName isEqualToString:@"condition"])
    {
        [txtCondition setText:currentNodeContent];
    }
    if([elementName isEqualToString:@"comments"])
    {
        [txtComment setText:currentNodeContent];
        [self hideProgressHUD];

    }
    
    
    // for displaying the details from the list module
    
    if([elementName isEqualToString:@"mmcode"])
    {
        [lblMM setText: [NSString stringWithFormat:@"M&M : %@",currentNodeContent]];
        
        if([currentNodeContent length] == 0)
            self.lblMMCode.text = @" M&M?";
         else
            [self.lblMMCode setText: [NSString stringWithFormat:@"M&M : %@",currentNodeContent]];
        
        self.strMeanCode = currentNodeContent;
    }
    if([elementName isEqualToString:@"programname"])
    {
        [txtProgramName setText:currentNodeContent];
    }
    if([elementName isEqualToString:@"price"])
    {
        NSArray *cuurecyremoved = [currentNodeContent componentsSeparatedByString:@"."];
        [txtPriceRetail setText:[cuurecyremoved objectAtIndex:0]];
    }
    
    // addded by Jignesh On 4 feb
    if ([elementName isEqualToString:@"mileage"])
    {
        [txtMileage setText:currentNodeContent];
    }
    if([elementName isEqualToString:@"tradeprice"])
    {
        if(currentNodeContent.floatValue == 0.00f)
        {
            [txtTrade setText:@""];
        }
        else
        {
            NSArray *cuurecyremovedTrader = [currentNodeContent componentsSeparatedByString:@"."];
            [txtTrade setText:[cuurecyremovedTrader objectAtIndex:0]];
        }
    }

    if([elementName isEqualToString:@"vin"])
    {
        
        if([currentNodeContent isEqualToString:@"(null)"] || [currentNodeContent isEqualToString:@""])
            self.photosExtrasDetailsObject.vinNumber = @"";
        else
            self.photosExtrasDetailsObject.vinNumber = currentNodeContent;
    }
    if([elementName isEqualToString:@"engine"])
    {
        
        if ([SMGlobalClass sharedInstance].isListModule == YES)
        {
            if([currentNodeContent isEqualToString:@"(null)"] || [currentNodeContent isEqualToString:@""])
                self.photosExtrasDetailsObject.EngineNumber = @"";
            else
                self.photosExtrasDetailsObject.EngineNumber = currentNodeContent;
        }
        else
        {
            if([currentNodeContent isEqualToString:@"(null)"] || [currentNodeContent isEqualToString:@""])
                self.VINLookupObject.EngineNo = @"";
            else
                self.VINLookupObject.EngineNo = currentNodeContent;
        }
        
    }
    if([elementName isEqualToString:@"registration"])
    {
        if([currentNodeContent isEqualToString:@"(null)"] || [currentNodeContent isEqualToString:@""])
            self.photosExtrasDetailsObject.RegNumber = @"";
        else
            self.photosExtrasDetailsObject.RegNumber = currentNodeContent;
    }
    if([elementName isEqualToString:@"oem"])
    {
        if ([SMGlobalClass sharedInstance].isListModule == YES)
            self.photosExtrasDetailsObject.oemCode = currentNodeContent;
        else
            self.VINLookupObject.oemNo = currentNodeContent;
    }
    if([elementName isEqualToString:@"location"])
    {
        if ([SMGlobalClass sharedInstance].isListModule == YES)
            self.photosExtrasDetailsObject.strLocation = currentNodeContent;
        else
            self.VINLookupObject.strLocation = currentNodeContent;

    }
    if([elementName isEqualToString:@"trim"])
    {
        if ([SMGlobalClass sharedInstance].isListModule == YES)
            self.photosExtrasDetailsObject.strTrim = currentNodeContent;
        else
            self.VINLookupObject.trim              = currentNodeContent;

    }
    if([elementName isEqualToString:@"standin"])
    {
        
        if(currentNodeContent.floatValue == 0.00f)
        {
            self.photosExtrasDetailsObject.strStandinR = @"";
            self.VINLookupObject.standR                = @"";
        }
        else
        {
            NSArray *stand = [currentNodeContent componentsSeparatedByString:@"."];

            if ([SMGlobalClass sharedInstance].isListModule == YES)
                self.photosExtrasDetailsObject.strStandinR = [stand objectAtIndex:0];
            else
                self.VINLookupObject.standR = [stand objectAtIndex:0];
        }
    }
    if([elementName isEqualToString:@"cost"])
    {
        
        if(currentNodeContent.floatValue == 0.00f)
        {
        
            self.photosExtrasDetailsObject.strCostR =@"";
            self.VINLookupObject.costR              =@"";
            
        }
        else
        {
        
            NSArray *cost = [currentNodeContent componentsSeparatedByString:@"."];

            if ([SMGlobalClass sharedInstance].isListModule == YES)
                self.photosExtrasDetailsObject.strCostR = [cost objectAtIndex:0];
            else
                self.VINLookupObject.costR  = [cost objectAtIndex:0];
        }
    }
    
    
    // The Expandable state Four Conditions are Done Here
    // Please do Not Modify untill needed
    if([elementName isEqualToString:@"ignoreonimport"])
    {
        if ([SMGlobalClass sharedInstance].isListModule == NO)
           self.VINLookupObject.checkBox1 = [currentNodeContent boolValue];
        else
            self.photosExtrasDetailsObject.checkBox1 = [currentNodeContent boolValue];
    }
    if([elementName isEqualToString:@"override"])
    {
        if ([SMGlobalClass sharedInstance].isListModule == YES)
            self.photosExtrasDetailsObject.checkBox2 = [currentNodeContent boolValue];
        else
            self.VINLookupObject.checkBox2 = [currentNodeContent boolValue];
    }
    if([elementName isEqualToString:@"cpaerror"])
    {
        if ([SMGlobalClass sharedInstance].isListModule == YES)// added by jignesh
            self.photosExtrasDetailsObject.checkBox3 = [currentNodeContent boolValue];
        else
            self.VINLookupObject.checkBox3 = [currentNodeContent boolValue];
    }
    if([elementName isEqualToString:@"isprogram"])
    {
        btnVehicleProgram.selected = [currentNodeContent boolValue];
    }
    if([elementName isEqualToString:@"istrade"])
    {
        btnVehicleIsTender.selected = [currentNodeContent boolValue];
    }
    if([elementName isEqualToString:@"isretail"])
    {
        btnVehicleIsRetail.selected = [currentNodeContent boolValue];
        
    }

    
    // End For - The Expandable state Four Conditions are Done Here
    // End For - Please do Not Modify untill needed
    
    if([elementName isEqualToString:@"variantID"])
    {
        self.photosExtrasDetailsObject.variantID = [currentNodeContent intValue];
        
        if([SMGlobalClass sharedInstance].isListModule) // for coming on LIST Module DONT REMOVE
        {
            
        if([currentNodeContent isKindOfClass:[NSNull class]] || [currentNodeContent intValue] == 0)
        {
            if([SMGlobalClass sharedInstance].isListModule == NO)
                [self.btnEditVariant setHidden:NO];
            else
                 [self.btnEditVehicle setHidden:NO];
        }
        else
        {
            if([SMGlobalClass sharedInstance].isListModule == NO)
                [self.btnEditVariant setHidden:YES];
            else
                [self.btnEditVehicle setHidden:YES];
        }
           
            if(self.photosExtrasDetailsObject.variantID != 0)
            {
                 NSLog(@"this variant...");
                [self fetchVariantDetialsWithVariantID:self.photosExtrasDetailsObject.variantID];
            }
        }
    }
    
    
    
    if([elementName isEqualToString:@"istender"])
    {
        isTender  = [currentNodeContent boolValue]; // added by jignesh
        if (isTender == YES)
        {
            [btnVehicleIsRetail setSelected:NO];
            [btnVehicleIsTender setSelected:NO];
        }
        else
        {
            [btnVehicleIsRetail setSelected:YES];
            [btnVehicleIsTender setSelected:YES];
        }
    }
    if([elementName isEqualToString:@"usedVehicleStockID"])
    {
        self.photosExtrasDetailsObject.stockID = [currentNodeContent intValue];
       
        self.iStockID = [currentNodeContent intValue];
        
        NSLog(@"self.iStockID11 = %d",self.iStockID);
    }
    if([elementName isEqualToString:@"year"])
    {
        txtVehicleYear.text = currentNodeContent;
        
        if([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"0"] )
        {
             NSLog(@"cosOfThis3");
            self.lblVehicleName.text = @"Year?Make?Model?";
        }
        else
        {
             NSLog(@"cosOfThis4");
            //self.lblVehicleName.text = [NSString stringWithFormat:@"%@ %@",currentNodeContent,self.lblVehicleName.text];
            
            [self setAttributedTextForVehicleDetailsWithFirstText:currentNodeContent andWithSecondText:self.lblVehicleName.text forLabel:self.lblVehicleName];
            
        }

    }
    if([elementName isEqualToString:@"editable"])
    {
        if ([SMGlobalClass sharedInstance].isListModule == YES)
            self.photosExtrasDetailsObject.isEditable = [currentNodeContent boolValue];
        else
            self.VINLookupObject.isEditable  = [currentNodeContent boolValue];
    }
    if([elementName isEqualToString:@"internalnote"])
    {
        NSLog(@"ParsedInternalNote = %@",currentNodeContent);
        
        if ([SMGlobalClass sharedInstance].isListModule == NO)
            self.VINLookupObject.internalNote = currentNodeContent;
        else
            self.photosExtrasDetailsObject.internalNote = currentNodeContent;
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
    else if ([elementName isEqualToString:@"imageLink"])
    {
        photosListObject.imageLink=currentNodeContent;
       
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
        //[temporaryVideosUploadArray addObject:videoListObject];
        videoListObject=nil;
    }

    
    //************* END - Fetching All Other Infromation for Vehicle **************
    
    if ([elementName isEqualToString:@"image"])
    {
        photosListObject.isImageFromLocal=NO;
        photosListObject.imageOriginIndex = -1;

        
        [arrayOfImages addObject:photosListObject];
        photosListObject=nil;
    }
    
    if ([elementName isEqualToString:@"LoadVehicleDetailsXMLResult"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photosCollectionView reloadData];
            [self.videosCollectionView reloadData];
            NSLog(@"ParsedInternalNotet = %@",self.photosExtrasDetailsObject.internalNote);
            [self.tableView reloadData];
        });
    }
    if([elementName isEqualToString:@"Details"])
    {
       // dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"ParsedInternalNote = %@",self.photosExtrasDetailsObject.internalNote);
        
       // });
        
    }
    
    if ([elementName isEqualToString:@"AddImageToVehicleBase64Result"])
    {
        if(!isUpdateVehicleInformation)
        {
            
                    NSString *newString = [[currentNodeContent componentsSeparatedByCharactersInSet:
                                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                           componentsJoinedByString:@""];
                    
                    SMPhotosListNSObject *imagePriorityIndexObject = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:parser.uniqueIdentifier];
                    
                    imagePriorityIndexObject.imageID = newString.intValue;
                    NSLog(@"%d ********",parser.uniqueIdentifier);
                    
                    if(arrayOfImages.count>0)
                        // this stuff is for updating the priorities
                        [self updateCommentTheImagePrioritiesWithPriority:parser.uniqueIdentifier andImageID:imagePriorityIndexObject.imageID];
            
        }
        else
        {
        NSString *newString = [[currentNodeContent componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                               componentsJoinedByString:@""];
        
        SMPhotosListNSObject *imagePriorityIndexObject = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:parser.uniqueIdentifier];
        
        imagePriorityIndexObject.imageID = newString.intValue;
        NSLog(@"%d ********",parser.uniqueIdentifier);
        
        if(arrayOfImages.count>0)
            // this stuff is for updating the priorities
            [self updateCommentTheImagePrioritiesWithPriority:parser.uniqueIdentifier andImageID:imagePriorityIndexObject.imageID];
        }
        
    }
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if([SMGlobalClass sharedInstance].isListModule == YES || self.isFromVinLookUpEditPage) // IF FROM LIST MODULE
    {
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            self.lblMMCode.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            self.lblVehicleDetails.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];

            [self.lblVehicleName sizeToFit];
            [self.lblMMCode sizeToFit];
            [self.lblVehicleDetails sizeToFit];
            
            self.lblVehicleName.frame = CGRectMake(113, 7 , 200, self.lblVehicleName.frame.size.height);
            
            self.lblMMCode.frame = CGRectMake(113, self.lblVehicleName.frame.origin.y + self.lblVehicleName.frame.size.height +2.0, 185, self.lblMMCode.frame.size.height);
            
            self.lblVehicleDetails.frame = CGRectMake(113, self.lblMMCode.frame.origin.y + self.lblMMCode.frame.size.height +2.0, 185, self.lblVehicleDetails.frame.size.height);
        }
        else
        {
            self.lblMMCode.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            self.lblVehicleDetails.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];

            self.lblVehicleName.frame = CGRectMake(122, 7 , 550, self.lblVehicleName.frame.size.height);
            
            self.lblMMCode.frame = CGRectMake(121, self.lblVehicleName.frame.origin.y + self.lblVehicleName.frame.size.height +2.0, 550, self.lblMMCode.frame.size.height);
            
            self.lblVehicleDetails.frame = CGRectMake(122, self.lblMMCode.frame.origin.y + self.lblMMCode.frame.size.height +2.0, 550, self.lblVehicleDetails.frame.size.height);
        }
    
    [self.headerView addSubview:self.viewHoldingTopHeaderData];
    
    self.viewHoldingBottomHeaderData.frame = CGRectMake(self.viewHoldingBottomHeaderData.frame.origin.x, self.viewHoldingTopHeaderData.frame.origin.y + self.viewHoldingTopHeaderData.frame.size.height +3.0, self.viewHoldingBottomHeaderData.frame.size.width, self.viewHoldingBottomHeaderData.frame.size.height);
    }

}

#pragma mark - picker datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;// or the number of vertical "columns" the picker will show...
}
- (NSInteger)pickerView:(UIPickerView *)pickerView1 numberOfRowsInComponent:(NSInteger)component
{
    
    if (pickerView1 == yearVehiclePickerView)
    {
     
        return [yearArray count];
    }
    else
    {
        if (vehicleTypeArray!=nil)
        {
            return [vehicleTypeArray count];//this will tell the picker how many rows it has - in this case, the size of your loaded array...
        }
        return 0;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView1 viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* lbl = (UILabel*)view;
    // Customise Font
    if (lbl == nil)
    {
        //label size
        CGRect frame = CGRectMake(0.0, 0.0, yearPickerView.frame.size.width-20, 30);
        
        lbl = [[UILabel alloc] initWithFrame:frame];
        
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor blackColor]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        //here you can play with fonts
        [lbl setFont:[UIFont fontWithName:FONT_NAME_BOLD size:15.0]];
        
    }
    
    if (pickerView1 == yearVehiclePickerView)
    {
    
        [lbl setText:[yearArray objectAtIndex:row]];

    }
    else
    {
        SMVehicleTypeObject *obj = (SMVehicleTypeObject*)[vehicleTypeArray objectAtIndex:row];

        //picker view array is the datasource
        [lbl setText:obj.strType];
    }
    
    
    return lbl;
}

- (NSString *)pickerView:(UIPickerView *)pickerView1 titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (pickerView1 == yearVehiclePickerView)
    {
    
        return [yearArray objectAtIndex:row];
    }
    else
    {
        //you can also write code here to descide what data to return depending on the component ("column")
        if (vehicleTypeArray!=nil)
        {
            SMVehicleTypeObject *obj = (SMVehicleTypeObject*)[vehicleTypeArray objectAtIndex:row];
        
            return obj.strType;
            //assuming the array contains strings..
        }
    }
    return @"";//or nil, depending how protective you are
}
#pragma mark -
#pragma mark - picker delegate
- (void)pickerView:(UIPickerView *)pickerView1 didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView1 == yearVehiclePickerView)
    {
        self.strSlectedVehicleYear  = [yearArray objectAtIndex:row];
    }
    else
    {
        SMVehicleTypeObject *obj = (SMVehicleTypeObject*)[vehicleTypeArray objectAtIndex:row];
        strPickerValue=obj.strType;
    }
    didUserChangeAnything = YES;
}
#pragma mark -

#pragma mark- load popup
-(void)loadPopup
{

    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (vc != self)
        return;
    [popupView setFrame:[UIScreen mainScreen].bounds];
    [popupView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [popupView setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popupView];
    [popupView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [popupView setAlpha:0.75];
         [popupView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [popupView setAlpha:1.0];
              
              [popupView setTransform:CGAffineTransformIdentity];
          }
                          completion:^(BOOL finished)
          {
          }];
         
     }];
}
-(void)loadPopupVehicle
{
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (vc != self)
        return;
    [pickerVehicleView setFrame:[UIScreen mainScreen].bounds];
    [pickerVehicleView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [pickerVehicleView setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:pickerVehicleView];
    [pickerVehicleView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [pickerVehicleView setAlpha:0.75];
         [pickerVehicleView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [pickerVehicleView setAlpha:1.0];
              
              [pickerVehicleView setTransform:CGAffineTransformIdentity];
          }
                          completion:^(BOOL finished)
          {
          }];
         
     }];
}
#pragma mark -
#pragma mark - dismiss popup
-(void)dismissPopup
{
    [popupView setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popupView];
    [UIView animateWithDuration:0.1 animations:^{
        [popupView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [popupView setAlpha:0.3];
              [popupView setTransform:CGAffineTransformMakeScale(0.9    ,0.9)];
              
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   
                   [popupView setAlpha:0.0];
               }
                completion:^(BOOL finished)
               {
                   [popupView removeFromSuperview];
                   [popupView setTransform:CGAffineTransformIdentity];
                   
                   
               }];
              
          }];
         
     }];
    
}
-(void)dismissPopupVehicle
{
    [pickerVehicleView setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:pickerVehicleView];
    [UIView animateWithDuration:0.1 animations:^{
        [pickerVehicleView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [pickerVehicleView setAlpha:0.3];
              [pickerVehicleView setTransform:CGAffineTransformMakeScale(0.9    ,0.9)];
              
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   
                   [pickerVehicleView setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [pickerVehicleView removeFromSuperview];
                   [pickerVehicleView setTransform:CGAffineTransformIdentity];
                   
                   
               }];
              
          }];
         
     }];
    
}
#pragma mark -
#pragma mark -Memory Warnings
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - adjust size of view
-(void)adjustSizeOfView
{
    if (isExpandable)
    {
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
          listAddToTenderArray.count==0 ? (self.tableView.contentSize=CGSizeMake(320, 1850)):(self.tableView.contentSize=CGSizeMake(320, 1890));
        }
        else
        listAddToTenderArray.count==0 ? (self.tableView.contentSize=CGSizeMake(320, 2100)):(self.tableView.contentSize=CGSizeMake(320, 2200));
    }
    else
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            self.tableView.contentSize=CGSizeMake(320, 1240);
        }
        else
        {
            self.tableView.contentSize=CGSizeMake(320, 1500);
        }
    }
}


#pragma mark - textField delegate

-(BOOL)textFieldShouldReturn:(SMToolBarCustomField *)textField
{
    [self.tableView setScrollEnabled:YES];
    isTextFieldSelected=NO;
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -

#pragma mark -

-(void)textFieldDidBeginEditing:(SMToolBarCustomField *)textField
{
    if (textField.tag==KTextAddTender)
    {
        [[self view]endEditing:YES];

        if (listAddToTenderArray.count==0)
        {
            SMAlert(KLoaderTitle,KNoTenderAvailable);
        }
        else
        {
            isVehicleType=NO;
            pickerView.hidden=YES;
            loadVehicleTableView.hidden=NO;
            [loadVehicleTableView reloadData];
            [self loadPopup];
        }
    }
    else if (textField==txtType)
    {
        [[self view]endEditing:YES];

        if (vehicleTypeArray.count !=0)
        {
            isVehicleType=YES;
            [loadVehicleTableView reloadData];
            [self loadPopup];
        }
    }
    
    else if (textField == txtVehicleYear)
    {
        [textField resignFirstResponder];
        //[self loadPopupVehicle];
        
        [self.view endEditing:YES];
        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
        SMCustomPopUpTableView *popUpView1 = [arrLoadNib objectAtIndex:0];
        
        [popUpView1 getTheDropDownData:[SMAttributeStringFormatObject getYear] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:YES]; // array to be passed for custom popup dropdown
        
        [self.view addSubview:popUpView1];
        
        [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
            NSLog(@"selected text = %@",selectedTextValue);
            NSLog(@"selected ID = %d",selectIDValue);
            textField.text = selectedTextValue;
            self.strSlectedVehicleYear = selectedTextValue;
            //selectedMakeId = selectIDValue;
        }];
        
    }

    
    else
    {
        [self.tableView setScrollEnabled:YES];      
        isTextFieldSelected=YES;
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:self.tableView];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 1;
        [self.tableView setContentOffset:pt animated:NO];
        
    }
    
}



-(void)doneWithNumberPad:(UITextField*)textfield
{
    [self.tableView setScrollEnabled:YES];
    isTextFieldSelected=NO;
    [self.view endEditing:YES];
}

#pragma mark - textView delegate
- (BOOL)textViewShouldEndEditing:(SMToolBarCustomTextView *)textView
{
    [textView resignFirstResponder];
    isTextFieldSelected=NO;
    [self.view endEditing:YES];
    return YES;
}

-(void)doneButtOnDIdPressed
{
    isTextFieldSelected=NO;
    [self.view endEditing:YES];
}

-(void)textViewDoneButtOnDidPressed
{
    isTextFieldSelected=NO;
    [self.view endEditing:YES];
}
- (void)textViewDidBeginEditing:(SMToolBarCustomTextView *)textView
{
    [self.tableView setScrollEnabled:YES];
    isTextFieldSelected=YES;
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:self.tableView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 1;
    [self.tableView setContentOffset:pt animated:NO];
}

- (BOOL)textView:(SMToolBarCustomTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    didUserChangeAnything = YES;
    [self.tableView setScrollEnabled:YES];
    isTextFieldSelected=YES;
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:self.tableView];
    pt = rc.origin;
    pt.x = 0;
    
    pt.y -= 1;
    [self.tableView setContentOffset:pt animated:NO];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    didUserChangeAnything = YES;
    SMAddToStockTableViewCell *cell = (SMAddToStockTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(textField.tag == kTextVin)
    {
        
        self.photosExtrasDetailsObject.vinNumber = resultString;
        
    }
    if(textField.tag == kTextEngibe)
    {
        
        self.photosExtrasDetailsObject.EngineNumber = resultString ;
        
    }
    if(textField.tag == kTextReg)
    {
        
        self.photosExtrasDetailsObject.RegNumber = resultString;
        
    }
    if(textField.tag == kTextOme)
    {
        
        self.photosExtrasDetailsObject.oemCode = resultString;
        
    }
    if(textField.tag == kTextCostR)
    {
        
        self.photosExtrasDetailsObject.strCostR = resultString;
        
    }
    if(textField.tag == kTextLocation)
    {
        
        self.photosExtrasDetailsObject.strLocation = resultString;
        
    }
    if(textField.tag == KTextTrim)
    {
        self.photosExtrasDetailsObject.strTrim = resultString;
    }
    
    if(textField.tag == kTextStanInR)
    {
        
        self.photosExtrasDetailsObject.strStandinR = resultString;
        
    }
    if(textField.tag == KTextViewInternamNote)
    {
        NSLog(@"internalNoteee* = %@",self.photosExtrasDetailsObject.internalNote);
        self.photosExtrasDetailsObject.internalNote = resultString;
        
    }

    if ([txtStock isFirstResponder])
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        NSString       *filtered       = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if(newLength>50)
        {
            return (newLength > 50) ? NO : YES;
        }
        else
        {
            return [string isEqualToString:filtered];
        }
    }
    
    if([txtColour isFirstResponder]||[cell.txtTrim isFirstResponder] || [txtStock isFirstResponder])
    {
    
        
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_WITHSPACE] invertedSet];
        NSString       *filtered       = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if(newLength>5000)
        {
            return (newLength > 5000) ? NO : YES;
        }
        else
        {
            return [string isEqualToString:filtered];
        }
    }
    

    if([txtMileage isFirstResponder] || [txtPriceRetail isFirstResponder] || [txtTrade isFirstResponder] ||[cell.txtCostR isFirstResponder] || [cell.txtStandInR isFirstResponder] || [cell.txtOmeNo isFirstResponder])
    {
    
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_Number] invertedSet];
        NSString       *filtered       = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if(newLength>8)
        {
            return (newLength > 8) ? NO : YES;
        }
        else
        {
            return [string isEqualToString:filtered];
        }

    }
    
    return YES;
}
#pragma mark -

#pragma mark - IBAction
-(IBAction)btnCancelDidClicked:(id)sender
{
    [self.view endEditing:YES];
    isTextFieldSelected=NO;
    [self dismissPopup];
    UIButton *btn=(UIButton*)sender;
    if (btn.tag==2)
    {
        [txtType setText:strPickerValue];
    }
}

-(IBAction)btnVehicleProgramDidPressed:(id)sender
{
    isTextFieldSelected=NO;
    [self.view endEditing:YES];
    
    BOOL tempInitialValue = btnVehicleProgram.selected;
    btnVehicleProgram.selected=!btnVehicleProgram.selected;
    
    if(btnVehicleProgram.selected != tempInitialValue )
        didUserChangeAnything = YES;
}
-(IBAction)btnIsRetailDidPressed:(id) sender
{
    isTextFieldSelected=NO;
    [self.view endEditing:YES];
     BOOL tempInitialValue = btnVehicleIsRetail.selected;
    btnVehicleIsRetail.selected=!btnVehicleIsRetail.selected;
    if(btnVehicleIsRetail.selected != tempInitialValue )
        didUserChangeAnything = YES;
    
    // make trade false
    isTender = NO;
    SMAddToStockTableViewCell *cell = (SMAddToStockTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.txtAddToTender setText:@""];
    
}

-(IBAction)btnIsTenderDidPressed:(id)sender
{
    isTextFieldSelected=NO;
    isTender = NO;
    [self.view endEditing:YES];
     BOOL tempInitialValue = btnVehicleIsTender.selected;
    btnVehicleIsTender.selected=!btnVehicleIsTender.selected;
    if(btnVehicleIsTender.selected != tempInitialValue )
        didUserChangeAnything = YES;
}

-(IBAction)buttonCancelVehicleDidPressed:(id)sender
{
    [self dismissPopupVehicle];
}
-(IBAction)buttonDoneVehicleDidPressed:(id)sender
{
    
    [txtVehicleYear setText:self.strSlectedVehicleYear];
    [self dismissPopupVehicle];

}


-(IBAction)btnAdditioanlInfoDidPressed:(UIButton*)sender
{
    [self.view endEditing:YES];
    isTextFieldSelected=NO;
    
    UIButton *btn = (UIButton *) sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    if(isExpandable)
    {
        isExpandable=NO;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }
    else
    {
        isExpandable=YES;
      
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        return;
        
    }
    
}
-(IBAction)btnActivateCPADidPressed:(UIButton*)sender
{
    [self.view endEditing:YES];
    isTextFieldSelected=NO;
    
    [self adjustSizeOfView];
    UIButton *btn = (UIButton *) sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    SMAddToStockTableViewCell* cell = (SMAddToStockTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    BOOL tempInitialValue = cell.btnActivateCPA.isSelected;
    cell.btnActivateCPA.selected = !cell.btnActivateCPA.selected;
    
    if(cell.btnActivateCPA.selected != tempInitialValue)
        didUserChangeAnything = YES;
    
    if([SMGlobalClass sharedInstance].isListModule == YES)
        self.photosExtrasDetailsObject.checkBox3= cell.btnActivateCPA.selected;
    else if(isUpdateVehicleInformation == YES)
        self.VINLookupObject.checkBox3 = cell.btnActivateCPA.selected;


}
-(IBAction)btnIgnoreExcludeSettingDidPressed:(UIButton*)sender
{
    [self.view endEditing:YES];
    isTextFieldSelected=NO;
    
    [self adjustSizeOfView];
    
    UIButton *btn = (UIButton *) sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    SMAddToStockTableViewCell* cell = (SMAddToStockTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    BOOL tempInitialValue = cell.btnIgnoreExcludeSetting.isSelected;

    cell.btnIgnoreExcludeSetting.selected=!cell.btnIgnoreExcludeSetting.selected;
    if(cell.btnIgnoreExcludeSetting.selected != tempInitialValue)
        didUserChangeAnything = YES;
    
    if([SMGlobalClass sharedInstance].isListModule == YES)
        self.photosExtrasDetailsObject.checkBox2 = cell.btnIgnoreExcludeSetting.selected;
    else if(isUpdateVehicleInformation == YES)
        self.VINLookupObject.checkBox2 = cell.btnIgnoreExcludeSetting.selected;

    
}
-(IBAction)btnRemoveVehicleDidPressed:(UIButton*)sender
{
    [self.view endEditing:YES];
    isTextFieldSelected=NO;
    
    [self adjustSizeOfView];
    
    UIButton *btn = (UIButton *) sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    SMAddToStockTableViewCell* cell = (SMAddToStockTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    BOOL tempInitialValue = cell.btnRemoveVehicle.isSelected;

    cell.btnRemoveVehicle.selected=!cell.btnRemoveVehicle.selected;
    
    if(cell.btnRemoveVehicle.selected != tempInitialValue)
        didUserChangeAnything = YES;
    
    if([SMGlobalClass sharedInstance].isListModule == YES)
        self.photosExtrasDetailsObject.checkBox4 = cell.btnRemoveVehicle.selected;
    else if(isUpdateVehicleInformation == YES)
        self.VINLookupObject.checkBox4           = cell.btnRemoveVehicle.selected;

}
-(IBAction)btnDontLetOverrideDidPressed:(id)sender
{
    [self.view endEditing:YES];
    isTextFieldSelected=NO;
    
    [self adjustSizeOfView];
    
    UIButton *btn = (UIButton *) sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    SMAddToStockTableViewCell* cell = (SMAddToStockTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.btnDontLetOverride.selected=!cell.btnDontLetOverride.selected;
    
    if([SMGlobalClass sharedInstance].isListModule == YES)
        self.photosExtrasDetailsObject.checkBox1 = cell.btnDontLetOverride.selected;
    else if(isUpdateVehicleInformation == YES)
        self.VINLookupObject.checkBox1 = cell.btnDontLetOverride.selected;
        
    
}

-(IBAction)btnSaveDidPressed:(id)sender
{
    isInfoOnlySaved = YES;
    
    [self.view endEditing:YES];
    isTextFieldSelected=NO;
    [self adjustSizeOfView];
    isSaveAndClosed = NO;
    if([self validateStock] == YES)
    {
        if ([SMGlobalClass sharedInstance].isListModule)
        {
            [self uploadingAddStockImages];
        }
        else
        {
            isUpdateVehicleInformation == YES ? [self uploadingAddStockImages] : [self addvehicleInToStock];
            
        }
    }
}

-(IBAction)buttonSaveAndClosedDidPressed:(id)sender
{
    isSaveAndClosed = YES;
    
    if([self validateStock] == NO)
        return;
    
    if ([SMGlobalClass sharedInstance].isListModule)
    {
        [self uploadingAddStockImages];
    }
    else
    {
        isUpdateVehicleInformation == YES ? [self uploadingAddStockImages] : [self addvehicleInToStock];
        
    }
    
    
}


-(void)uploadingAddStockImages
{
    
       NSPredicate *predicateVideos = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];
        arrayFilteredImages = [arrayOfImages filteredArrayUsingPredicate:predicateVideos];
    
        if ([arrayFilteredImages count] > 0)
        {
            isPrioritiesImageChanged = YES;
        }

    
    countForShowingAlert = (int)[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted.count;
    
    
    if (isPrioritiesImageChanged==YES)
    {
        
        if(arrayFilteredImages.count>0)
        {
            
            [HUD show:YES];
            HUD.labelText = KLoaderText;
      
        
        }
        
        if(arrayFilteredImages.count == 0)
        {
            if ([SMGlobalClass sharedInstance].isListModule)
            {
                [self updateVehicleInformations];
                
            }
            else
            {
                if(!isSaveAndClosed)
                {
                    isUpdateVehicleInformation == YES ? [self updateVehicleInformations] : [self addvehicleInToStock];
                }
                else
                {
                    [self updateVehicleInfoWhenNotInListModule];
                }
               
            }
        }
        
        if(arrayFilteredImages.count>0)
        {
        // this stuff is for adding the new images to the server
        
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
                    for(int i=0;i<[arrayFilteredImages count];i++)
                    {
                        SMPhotosListNSObject *imagesObject = (SMPhotosListNSObject*)[arrayFilteredImages objectAtIndex:i];
                        
                        UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imagesObject.strimageName];
                        NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
                        
                        base64Str = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
                        [self uploadTheCommentImagesToTheServerWithPriority:i];
                    }
                }
        }
               
        
        // this stuff is for updating the priorities
        //Changed by Sakshi "Earlier array name was arrayFilteredImages"
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
            
            if(![SMGlobalClass sharedInstance].isListModule)
                [self deleteTheCommentImageWithImageID:deleteImagesObject.imageID usedVehicleStockID:self.iStockID];
            else
                [self deleteTheCommentImageWithImageID:deleteImagesObject.imageID usedVehicleStockID:self.photosExtrasObject.strUsedVehicleStockID.intValue];
        }
    }
    else if (isPrioritiesImageChanged==NO) // IF no images added by the user
    {
       // uploadingHUD.hidden=YES;
        [HUD show:YES];
        [HUD setLabelText:KLoaderText];
        
        if ([SMGlobalClass sharedInstance].isListModule)
        {
            [self updateVehicleInformations];
            
        }
        else
        {
            if(!isSaveAndClosed)
            {
                isUpdateVehicleInformation == YES ? [self updateVehicleInformations] : [self addvehicleInToStock];
            }
            else
            {
                [self updateVehicleInfoWhenNotInListModule];
            }

            
        }

        
    }
}

-(void)uploadTheImagesWhenNewStock
{
    
    NSPredicate *predicateVideos = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];
    arrayFilteredImages = [arrayOfImages filteredArrayUsingPredicate:predicateVideos];
    if ([arrayFilteredImages count] > 0)
    {
        isPrioritiesImageChanged = YES;
    }
    
    
    countForShowingAlert = (int)[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted.count;
    
    
    if (isPrioritiesImageChanged==YES)
    {
       
        
        if(arrayFilteredImages.count>0)
        {
            // this stuff is for adding the new images to the server
            
            reachability = [Reachability reachabilityForInternetConnection];
            internetStatus = [reachability currentReachabilityStatus];
            if (internetStatus != kReachableViaWiFi)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Manager" message:@"You are on a mobile data network. Do you want to:" delegate:self cancelButtonTitle:@"Upload with WiFi" otherButtonTitles:@"Upload Now", nil];
                alert.tag = 901;
                [alert show];
                
            }
            else if(arrayFilteredImages.count> 0)
            {
                for(int i=0;i<[arrayFilteredImages count];i++)
                {
                    SMPhotosListNSObject *imagesObject = (SMPhotosListNSObject*)[arrayFilteredImages objectAtIndex:i];
                    
                    UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imagesObject.strimageName];
                    NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
                    
                    base64Str = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
                    [self uploadTheCommentImagesToTheServerWithPriority:i];
                }
            }
            
        }
        else
        {
                if ([SMGlobalClass sharedInstance].isListModule)
                {
                    [self updateVehicleInformations];
                    
                }
                else
                {
                    if(!isSaveAndClosed)
                    {
                        isUpdateVehicleInformation == YES ? [self updateVehicleInformations] : [self addvehicleInToStock];
                    }
                    else
                    {
                        [self updateVehicleInfoWhenNotInListModule];
                    }
                    
                }
        }
        
        
        
        // this stuff is for deleting the images from the server
        for(int k=0;k<[[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted count];k++)
        {
            SMPhotosListNSObject *deleteImagesObject = (SMPhotosListNSObject*)[[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted objectAtIndex:k];
            
            if(![SMGlobalClass sharedInstance].isListModule)
                [self deleteTheCommentImageWithImageID:deleteImagesObject.imageID usedVehicleStockID:self.iStockID];
            else
                [self deleteTheCommentImageWithImageID:deleteImagesObject.imageID usedVehicleStockID:self.photosExtrasObject.strUsedVehicleStockID.intValue];
        }
    }
    
}

-(void)uploadingVideos
{
   
     NSString *urlString = [SMWebServices uploadVideosWebserviceUrl]; // staging
    
    // this stuff is for adding the new videos to the server
    
  
    
    for(int i=0;i<[temporaryVideosUploadArray count];i++)
    {
        videoCount = i;
        SMClassOfUploadVideos *objVideo = (SMClassOfUploadVideos*)[temporaryVideosUploadArray objectAtIndex:i];
        
        NSString *isSearchable;
        
        if(objVideo.isSearchable)
            isSearchable = @"true";
        else
            isSearchable = @"false";
        
        NSLog(@"isVIDEOSearchable : %@",isSearchable);
        NSLog(@"STOCKID : %d",self.iStockID);
        
        if(objVideo.isVideoFromLocal)
        {
            NSString *fileNameString = [objVideo.localYouTubeURL lastPathComponent];
            NSString *strStockID = [NSString stringWithFormat:@"%d",self.iStockID];
            
            ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:[NSURL URLWithString: urlString]];
            [request setTimeOutSeconds:100];
            
            [request setDelegate:self];
            [request setDidFailSelector:@selector(uploadFailed:)];
            [request setDidFinishSelector:@selector(uploadFinished:)];
            
            
            [request addRequestHeader:@"userHash" value:[SMGlobalClass sharedInstance].hashValue];
            [request addRequestHeader:@"Client" value:[SMGlobalClass sharedInstance].strClientID];
            [request addRequestHeader:@"usedVehicleStockID" value:strStockID];
            [request addRequestHeader:@"fileName" value:fileNameString];
            [request addRequestHeader:@"title" value:objVideo.videoTitle];
            [request addRequestHeader:@"description" value:objVideo.videoDescription];
            [request addRequestHeader:@"tags" value:objVideo.videoTags];
            [request addRequestHeader:@"searchable" value:isSearchable];
            [request setUploadProgressDelegate:HUD];
            
            //[request showAccurateProgress:YES];
            [request setFile:[[NSURL URLWithString:objVideo.localYouTubeURL] path] forKey:@"uploadfile"]; // this is POSIX path
            
            NSLog(@"%@",request);
            // uploadingHUD.hidden = NO;
            [request setPostFormat:ASIMultipartFormDataPostFormat];
            [request setRequestMethod:@"POST"];
            
            [request startSynchronous];
        }
    }
    
}
- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    
    NSError *error = [theRequest error];
    NSString *errorString = [error localizedDescription];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:[NSString stringWithFormat:@"Vehicle updated successfully but could not upload videos as %@.Do you wish to retry uploading video/s ?",errorString] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
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
        if(videoCount == (temporaryVideosUploadArray.count-1))
        {
            [temporaryVideosUploadArray removeAllObjects];
            [HUD hide:YES];
            //uploadingHUD.hidden=YES;
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:kVehicleStockSuccess delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             NSLog(@"thisMessage122");
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
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
}

-(void)updateVehicleExtrasAndComments
{
    NSMutableURLRequest *requestURL=[SMWebServices updateVehicleExtrasAndCommentsForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:self.iStockID comments:txtComment.text extras:txtExtras.text];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
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
    NSMutableURLRequest *requestURL=[SMWebServices removeCommentImageFromVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:usedVehicleStockID imageID:imageID];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
            // [uploadingHUD hide:YES];
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
    
    NSMutableURLRequest *requestURL;
    
    

    if(![SMGlobalClass sharedInstance].isListModule)
    {
        requestURL=[SMWebServices addImageToVehicleBase64ForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:self.iStockID imageBase64:base64Str imageName:[NSString stringWithFormat:@"%@.jpg",imageObj.strimageName] imageTitle:[NSString stringWithFormat:@"%@",imageObj.strimageName] imageSource:@"phone app" imagePriority:priority+1 imageIsEtched:NO imageIsBranded:NO imageAngle:@""];
    }
    else
    {
        requestURL=[SMWebServices addImageToVehicleBase64ForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:self.photosExtrasObject.strUsedVehicleStockID.intValue imageBase64:base64Str imageName:[NSString stringWithFormat:@"%@.jpg",imageObj.strimageName] imageTitle:[NSString stringWithFormat:@"%@",imageObj.strimageName] imageSource:@"phone app" imagePriority:priority+1 imageIsEtched:NO imageIsBranded:NO imageAngle:@""];
        
    }
    
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    SMUrlConnection *connection = [[SMUrlConnection alloc] initWithRequest:requestURL delegate:self];
    connection.arrayIndex = priority;
    
    [connection start];
}

-(void)updateCommentTheImagePrioritiesWithPriority:(int)priority andImageID:(int)imageID
{
   
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL;
    
    if(![SMGlobalClass sharedInstance].isListModule)
    {
        requestURL=[SMWebServices changeVehicleImagePriorityForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:self.iStockID imageID:imageID newPriorityID:priority+1];
    }
    else
    {
        requestURL=[SMWebServices changeVehicleImagePriorityForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:self.photosExtrasObject.strUsedVehicleStockID.intValue imageID:imageID newPriorityID:priority+1];
    }

    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
            // [uploadingHUD hide:YES];
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
   // [uploadingHUD hide:YES];
    return;
}

- (void)connectionDidFinishLoading:(SMUrlConnection *)connection
{
    //NSString *xml = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    xmlParser = [[SMParserForUrlConnection alloc] initWithData:responseData];
    xmlParser.uniqueIdentifier = connection.arrayIndex;
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==self.photosCollectionView)
    {
       
        return [arrayOfImages count];
    }
    else
    {
        return [arrayOfVideos count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView==self.photosCollectionView)
    {
        SMCellOfPlusImageCommentPV *cellImages;
        
        {
            cellImages =
            [collectionView dequeueReusableCellWithReuseIdentifier:@"SMCellOfActualImagePV" forIndexPath:indexPath];
            
            [cellImages.btnDelete addTarget:self action:@selector(btnDeleteStockImageDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            cellImages.btnDelete.tag = indexPath.row;
            
            SMPhotosListNSObject *imageObj = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:indexPath.row];
            
            
            cellImages.webVYouTube.hidden=YES;
            if(imageObj.isImageFromLocal)
            {
                NSString *str = [NSString stringWithFormat:@"%@.jpg",imageObj.strimageName];
                
                NSString *fullImgName=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
                
                cellImages.imgActualImage.image = [UIImage imageWithContentsOfFile:fullImgName];
                
                
            }
            else
            {
                [cellImages.imgActualImage setImageWithURL:[NSURL URLWithString:imageObj.imageLink] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"] success:^(UIImage *image, BOOL cached)
                 {
                     if(indexPath.row == 0)
                     {
                         self.imgViewVehicle.image = image;
                         
                     }

                 }
                failure:^(NSError *error)
                 {
                     
                 }];
            }
            
           isPrioritiesImageChanged = YES;
            
        }
        cellImages.imgActualImage.contentMode = UIViewContentModeScaleAspectFill;

        return cellImages;
    }
    else
    {
        __weak SMCellOfPlusImageCommentPV *cellVideos;
        
        {
            
            cellVideos = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMCellOfActualVideoPV" forIndexPath:indexPath];
            
            
            [cellVideos.btnDelete addTarget:self action:@selector(btnDeleteStockVideosDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            cellVideos.btnDelete.tag = indexPath.row;
                      
            SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:indexPath.row];
            cellVideos.webVYouTube.hidden=YES;
            
            if(videoObj.isVideoFromLocal)
            {
                cellVideos.imgActualImage.image = videoObj.thumnailImage;
               
            }
            else
            {
                cellVideos.webVYouTube.hidden=YES;
                NSLog(@"YouTubeId = %@",videoObj.youTubeID);
                
                [cellVideos.imgActualImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",videoObj.youTubeID]] placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
                    cellVideos.imgActualImage.image = image;
                    NSLog(@"IMAGEEE = %@",image);
                } failure:^(NSError *error) {
                    NSLog(@"Error image = %@",[error localizedDescription]);
                }];
                
            }
            
        }
        cellVideos.imgViewPlayVideo.hidden=NO;
        return cellVideos;
    }
    return nil;
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
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    if (collectionView==self.photosCollectionView)
    {
      
        {
            networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
            networkGallery.startingIndex = indexPath.row;
            SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
            appdelegate.isPresented =  YES;

            [self.navigationController pushViewController:networkGallery animated:YES];
            
        }
    }
    else
    {
        
        
        SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:indexPath.row];
        if(videoObj.isVideoFromLocal == NO)
        {
            //[SMGlobalClass sharedInstance].imageThumbnailForVideo = videoObj.thumnailImage;
            
            SMVideoInfoViewController *videoInfoVC = [[SMVideoInfoViewController alloc] initWithNibName:@"SMVideoInfoViewController" bundle:nil];
            
            // NSLog(@"imageVieww.image = %@");
           // if(imageVieww == nil)
            {
                imageVieww = [[UIImageView alloc]init];
                [imageVieww setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",videoObj.youTubeID]] placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
                    videoObj.thumnailImage = image;
                } failure:^(NSError *error) {
                    NSLog(@"failure reason = %@",[error localizedDescription]);
                }];
                
                //[SMGlobalClass sharedInstance].imageThumbnailForVideo = imageVieww.image;
               // videoObj.thumnailImage = [SMGlobalClass sharedInstance].imageThumbnailForVideo;
            }
           /* else
            {
                videoObj.thumnailImage = [SMGlobalClass sharedInstance].imageThumbnailForVideo;
            }*/
            
            videoInfoVC.videoObject = videoObj;
            videoInfoVC.isVideoFromServer = YES;
            videoInfoVC.isFromCameraView = NO;
            if([SMGlobalClass sharedInstance].isListModule == YES || self.isFromVinLookUpEditPage)
                videoInfoVC.vehicleName = [NSString stringWithFormat:@"%@-%@",self.lblVehicleName.text,txtStock.text];
            else
                videoInfoVC.vehicleName = [NSString stringWithFormat:@"%@-%@",self.lblMakeModel.text,txtStock.text];
            [self.navigationController pushViewController:videoInfoVC animated:YES];
        }
        else
        {
            SMVideoInfoViewController *videoInfoVC = [[SMVideoInfoViewController alloc] initWithNibName:@"SMVideoInfoViewController" bundle:nil];
            videoInfoVC.videoObject = videoObj;
            indexpathOfSelectedVideo = (int)indexPath.row;
            videoInfoVC.isVideoFromServer = NO;
            videoInfoVC.isFromPhotosNExtrasDetailPage = NO;
            videoInfoVC.isFromSendBrochureDetailPage = NO;
            videoInfoVC.isFromListPage = YES;
            videoInfoVC.videoPathURL = videoObj.localYouTubeURL;
            if([SMGlobalClass sharedInstance].isListModule == YES || self.isFromVinLookUpEditPage)
                videoInfoVC.vehicleName = [NSString stringWithFormat:@"%@-%@",self.lblVehicleName.text,txtStock.text];
            else
                videoInfoVC.vehicleName = [NSString stringWithFormat:@"%@-%@",self.lblMakeModel.text,txtStock.text];
            videoInfoVC.indexpathOfSelectedVideo = indexpathOfSelectedVideo;
            NSLog(@"sent indexpath = %d",videoInfoVC.indexpathOfSelectedVideo);
            
            [self.navigationController pushViewController:videoInfoVC animated:YES];
        }
        
    }
}

-(void)handleSingleTap
{
    
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        networkGallery.startingIndex = 0;
        SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate.isPresented =  YES;
        
        [self.navigationController pushViewController:networkGallery animated:YES];
   
}

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
    SMPhotosListNSObject *imgObj = (SMPhotosListNSObject*)[arrayOfImages objectAtIndex:index];

    if (imgObj.isImageFromLocal == NO)
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

#pragma mark - PlayVideoTapGestureMethod
-(void)videoPlayStockTapHandler:(UITapGestureRecognizer *)videoPlayerGestureRecog
{
    SMClassOfUploadVideos *videoObj = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:videoPlayerGestureRecog.view.tag];
    
    MPMoviePlayerViewController *moviePlayeObj=[SMMoviePlayerClass allocMoviePlayerView:videoObj.localYouTubeURL];
    
    [self presentViewController:moviePlayeObj animated:YES completion:^{}];
    
    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStockPlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:moviePlayeObj];
    
    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieStockPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayeObj];
}

#pragma mark - VideoPlayerNotification
-(void)movieStockPlaybackStateDidChange:(NSNotification *)notification
{
    MPMoviePlayerViewController *moviePlayerViewController = [notification object];
    
    if (moviePlayerViewController.moviePlayer.loadState == MPMovieLoadStatePlayable && moviePlayerViewController.moviePlayer.playbackState != MPMoviePlaybackStatePlaying)
    {
        [moviePlayerViewController.moviePlayer play];
    }
    
    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:moviePlayerViewController];
    moviePlayerViewController = nil;
}

- (void) movieStockPlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerViewController *moviePlayerViewController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerViewController];
    
    [self dismissMoviePlayerViewControllerAnimated];
    moviePlayerViewController = nil;
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSInteger i = buttonIndex;
    
    if (actionSheet==actionSheetVideos)
    {
        if (i==0)
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                
                HomeViewController *videoVC = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
                videoVC.isCameraViewFromPhotosNExtras = NO;
                 videoVC.isCameraViewFromEBrochure = NO;
                if([SMGlobalClass sharedInstance].isListModule == YES || self.isFromVinLookUpEditPage)
                {
                    
                    videoVC.videoVehicleName = [NSString stringWithFormat:@"%@-%@",self.lblVehicleName.text,txtStock.text];
                    NSLog(@"VNAME1 = %@",videoVC.videoVehicleName);
                }
                else
                {
                    videoVC.videoVehicleName = [NSString stringWithFormat:@"%@-%@",self.lblMakeModel.text,txtStock.text];
                    NSLog(@"VNAME2 = %@",videoVC.videoVehicleName);
                }
                
                [self.navigationController pushViewController:videoVC animated:YES];
                
                SMClassOfUploadVideos *objVideo=[[SMClassOfUploadVideos alloc]init];
                
               
                [HomeViewController getTheGeneratedVideoWithCallBack:^(BOOL success, NSString *videoPath, UIImage *thumbnailImage,NSString *videoName, NSError *error)
                 {
                     if(success)
                     {
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
                     NSLog(@"videoTitle = %@",videoTitle);
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
                         [temporaryVideosUploadArray replaceObjectAtIndex:indexPath withObject:objVideo];
                     }
                     else
                     {
                         NSLog(@"Added....");
                         [arrayOfVideos addObject:objVideo];
                         [temporaryVideosUploadArray addObject:objVideo];
                     }
                     
                     NSLog(@"VideoArray count camera = %lu",(unsigned long)arrayOfVideos.count);
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //[self.tblCommentVideoAndPhotos reloadData];
                         [self.videosCollectionView reloadData];
                         
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

#pragma mark - UIAlertView Delegates Methods
#pragma mark - AlertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== 101)
    {
        [self hideProgressHUD];
        if ([SMGlobalClass sharedInstance].isListModule == YES)
        {
            if (!isSaveAndClosed)
            {
               /* if([self.listRefreshDelegate respondsToSelector:@selector(refreshTheVehicleListModule)])
                {
                    [self.listRefreshDelegate refreshTheVehicleListModule];
                }*/
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
                
                if([self.listRefreshDelegate respondsToSelector:@selector(refreshTheVehicleListModule)])
                {
                    [self.listRefreshDelegate refreshTheVehicleListModule];
                }
                
            }
            
           
            
        }
        else
        {
            
            isPrioritiesImageChanged = NO;
            
            if ([SMGlobalClass sharedInstance].isListModule == YES)
            {
                [self.navigationController popViewControllerAnimated:YES];
                if([self.listRefreshDelegate respondsToSelector:@selector(refreshTheVehicleListModule)])
                {
                    [self.listRefreshDelegate refreshTheVehicleListModule];
                }
            }
            else
            {
                if (isSaveAndClosed == YES)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }
            
        }
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
                NSLog(@"Enterred herererererer");
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
            [self.videosCollectionView reloadData];
        }
    }
    if(alertView.tag== 301)
    {
        if(buttonIndex == 1)
            [self.navigationController popViewControllerAnimated:YES];
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
                [self.videosCollectionView reloadData];
                
            }
        }
    }
    if (alertView.tag==701)
    {
        if(buttonIndex==0)
        {
            [self loadVideoToDatabase];
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
            [HUD show:YES];
            [HUD setLabelText:KLoaderText];
             NSLog(@"******");
            [self uploadingVideos];
        }
    }
    if (alertView.tag==901)
    {
        if(buttonIndex==0)
        {
            NSMutableArray *arrmImageDetailObjects = [[NSMutableArray alloc] init] ;
            
            for(int i = 0;i<[arrayFilteredImages count];i++)
            {
                SMPhotosListNSObject *imageObj = (SMPhotosListNSObject*)[arrayFilteredImages objectAtIndex:i];
                
                NSString *imagePath = [self loadImagePath:[NSString stringWithFormat:@"%@.jpg",imageObj.strimageName]];
                NSLog(@"self.photosExtrasObject.strUsedVehicleStockID = %d",self.iStockID);
                
                // 2 for Vehicle
                NSDictionary *dictImageDetailObj = [NSDictionary dictionaryWithObjectsAndKeys:imagePath,@"ImagePath",[NSString stringWithFormat:@"%d",i+1],@"ImagePriority",@"2",@"ModuleIdentifier",[NSString stringWithFormat:@"%d",self.iStockID],@"StockID",imageObj.strimageName,@"ImageFileName",[SMGlobalClass sharedInstance].strClientID,@"ClientID",[SMGlobalClass sharedInstance].strMemberID,@"MemberID", nil];
                
                
                [arrmImageDetailObjects addObject:dictImageDetailObj];
                
            }
            ifUploadMobileData = NO;
            [[SMDatabaseManager theSingleTon] insertImageDetailsInDatabase:arrmImageDetailObjects];
           
            [self callTheOtherWebservicesForSavingData];
            
            // [[SMDatabaseManager theSingleTon] removeAllRecords];
            
        }
        else
        {
            
            for(int i=0;i<[arrayFilteredImages count];i++)
            {
                SMPhotosListNSObject *imagesObject = (SMPhotosListNSObject*)[arrayFilteredImages objectAtIndex:i];
                
                UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imagesObject.strimageName];
                NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
             
                base64Str = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
                [self uploadTheCommentImagesToTheServerWithPriority:i];
            }
        }
        
        
    }
    
    
}
-(void) callTheOtherWebservicesForSavingData
{
    
    if ([SMGlobalClass sharedInstance].isListModule)
    {
        [self updateVehicleInformations];
        
    }
    else
    {
        if(!isUpdateVehicleInformation)
        {
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
            if([temporaryVideosUploadArray count]>0)
            {
                videoObj = (SMClassOfUploadVideos*)[temporaryVideosUploadArray objectAtIndex:([temporaryVideosUploadArray count]-1)];
            }
            
            if([temporaryVideosUploadArray count]>0 && videoObj.isVideoFromLocal)
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
                    
                    for(int i =0;i<[temporaryVideosUploadArray count];i++)
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
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:kVehicleStockSuccess delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.tag=101;
                NSLog(@"thisMessage11");
                [alert show];
                // uploadingHUD.progress=0.0;
            }
            
        }
        else
        {
            
            if(!isSaveAndClosed)
            {
                isUpdateVehicleInformation == YES ? [self updateVehicleInformations] : [self addvehicleInToStock];
            }
            else
            {
                [self updateVehicleInfoWhenNotInListModule];
            }
        }
        
        
    }
    
}

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

-(void)uploadVideoMethod
{
}

#pragma mark -

- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    
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
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
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
            
            // Picking Image from Camera/ Library
            SMVideoInfoViewController *videoInfoVC = [[SMVideoInfoViewController alloc] initWithNibName:@"SMVideoInfoViewController" bundle:nil];
            videoInfoVC.videoPathURL = moviePath;
            videoInfoVC.isVideoFromServer = NO;
            videoInfoVC.isFromCameraView = YES;
            videoInfoVC.isFromPhotosNExtrasDetailPage = NO;
            videoInfoVC.isFromSendBrochureDetailPage = NO;
            
            if([SMGlobalClass sharedInstance].isListModule == YES)
                videoInfoVC.isFromListPage = YES;
            else
                videoInfoVC.isFromListPage = NO;
            
            videoInfoVC.thumbNailImage = [[SMGlobalClass sharedInstance]generateVideoThumbnailImage:moviePath];
            
            if([SMGlobalClass sharedInstance].isListModule == YES || self.isFromVinLookUpEditPage)
            {
                videoInfoVC.vehicleName = [NSString stringWithFormat:@"%@-%@",self.lblVehicleName.text,txtStock.text];
                
            }
            else
            {
                videoInfoVC.vehicleName = [NSString stringWithFormat:@"%@-%@",self.lblMakeModel.text,txtStock.text];
            }
            
            [picker dismissViewControllerAnimated:NO completion:^{
                picker.delegate=nil;
                picker = nil;
                [self.navigationController pushViewController:videoInfoVC animated:NO];
            }];

            
            
            
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
                 if(indexPath == indexpathOfSelectedVideo)
                 {
                     NSLog(@"Replaced....");
                     [arrayOfVideos replaceObjectAtIndex:indexPath withObject:objVideo];
                     [temporaryVideosUploadArray replaceObjectAtIndex:indexPath withObject:objVideo];
                 }
                 else
                 {
                     NSLog(@"Added....");
                     [arrayOfVideos addObject:objVideo];
                     [temporaryVideosUploadArray addObject:objVideo];
                 }
                 NSLog(@"VideoArray count photo library = %lu",(unsigned long)arrayOfVideos.count);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     
                     [self.videosCollectionView reloadData];
                     
                 });
                 
                 
             }];
            
        }
        
        }
    else
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
                [self.photosCollectionView reloadData];
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



#pragma mark - Multiple Image Selection and Image Editing

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
        //QBImagePickerController *imagePickerController2 = [[QBImagePickerController alloc] init];
        
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
            SMAlert(@"Error", KCameraNotAvailable);
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
        [arrayOfImages removeAllObjects]; // check here.
    
    
    [self.photosCollectionView reloadData];
    
    
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
            imageObject.isImageFromCamera = NO;
            
            [arrayOfImages addObject:imageObject];
            
            selectedImage = nil;
            
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photosCollectionView reloadData];
            [self.multipleImagePicker.Originalimages removeAllObjects];
            //[self.multipleImagePicker.ThumbnailImages removeAllObjects];
            
        });
        
        
        
    };
    
    [self dismissImagePickerControllerForCancel:NO];
    
    
}
//////////// Monami Cancel picker all image removed

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
//        [self.photosCollectionView reloadData];
//
//
//    }
    
    [self.photosCollectionView reloadData];
    [self dismissImagePickerControllerForCancel:YES];
    
    
    
    for (UINavigationController *view in self.navigationController.viewControllers)
    {
        
        if ([view isKindOfClass:[RPMultipleImagePickerViewController class]])
        {
            [self.navigationController popViewControllerAnimated:NO];
            
        }
    }

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



-(void)cropMethod
{
    if(selectedImage != nil)
    {
        ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:selectedImage];
        controller.delegate = self;
        controller.blurredBackground = YES;
        [[self navigationController] pushViewController:controller animated:YES];
    }
    
    
}

- (void)ImageCropViewController:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    
    
    if (croppedImage.size.width < croppedImage.size.height)
    {
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
                lastImage = [self imageWithImage:croppedImage scaledToSize:newSize];
                selectedImage = lastImage;
            }
            else
            {
                lastImage = croppedImage;
                selectedImage = lastImage;
            }
        
    }
    
    
    
    
    imgCount++;
    
    SMPhotosListNSObject *imageObject = [[SMPhotosListNSObject alloc]init];
    
    NSDateFormatter *formatter2=[[NSDateFormatter alloc]init];
    
    [formatter2 setDateFormat:@"ddHHmmssSS"];
    
    NSString *dateString=[formatter2 stringFromDate:[NSDate date]];
    
    imageObject.strimageName=[NSString stringWithFormat:@"%@_thumbnail",dateString];
    
    // this will store the original big image inorder to send to the server.
    
    
    [self saveImage:selectedImage :imageObject.strimageName];
    
    imageObject.isImageFromLocal = YES;
    imageObject.imagePriorityIndex=imgCount;
    imageObject.imageLink = fullPathOftheImage;
    
    [arrayOfImages addObject:imageObject];
    
    selectedImage = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.photosCollectionView reloadData];
        
    });
    
    
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller
{
    [[self navigationController] popViewControllerAnimated:YES];
}



#pragma mark - Delegate method for cropping the image



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
    
    isPrioritiesImageChanged = YES;
    
    [arrayOfImages removeObjectAtIndex:fromIndexPath.item];
    [arrayOfImages insertObject:imgObj atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        return YES;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
    return YES;
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==loadVehicleTableView)
    {
        return  self.viewCancelbutton;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==loadVehicleTableView)
    {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 45 : 60;
        
    }
    return 0;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==loadVehicleTableView)
    {
        if(isVehicleType)
        {
            float maxHeigthOfView = [self view].frame.size.height/2+50.0;
            
            int heightNeedToAdd;
            
            heightNeedToAdd = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 45 : 75;
            
            float totalFrameOfView = heightNeedToAdd+([vehicleTypeArray count]*43);
            if (totalFrameOfView <= maxHeigthOfView)
            {
                //Make View Size smaller, no scrolling
                loadVehicleTableView.frame = CGRectMake(loadVehicleTableView.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, loadVehicleTableView.frame.size.width, totalFrameOfView);
            }
            else
            {
                loadVehicleTableView.frame = CGRectMake(loadVehicleTableView.frame.origin.x, maxHeigthOfView/2-22.0, loadVehicleTableView.frame.size.width, maxHeigthOfView);
            }
            
            return vehicleTypeArray.count;
        }
        float maxHeigthOfView = [self view].frame.size.height/2+50.0;
        int heightNeedToAdd;
        
        heightNeedToAdd = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 45 : 75;

        
        float totalFrameOfView = heightNeedToAdd+([listAddToTenderArray count]*43);
        if (totalFrameOfView <= maxHeigthOfView)
        {
            //Make View Size smaller, no scrolling
            loadVehicleTableView.frame = CGRectMake(loadVehicleTableView.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, loadVehicleTableView.frame.size.width, totalFrameOfView);
        }
        else
        {
            loadVehicleTableView.frame = CGRectMake(loadVehicleTableView.frame.origin.x, maxHeigthOfView/2-22.0, loadVehicleTableView.frame.size.width, maxHeigthOfView);
        }
        
        return listAddToTenderArray.count;
        
        
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==loadVehicleTableView)
    {
        return  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 45 : 65;
    }
    if (isExpandable)
    {
        return  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 611: 730;
    }
    return 40.0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==loadVehicleTableView)
    {
        static NSString *CellIdentifier = @"SMLoadVehicleTableViewCell";
        SMLoadVehicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (isVehicleType)
        {
            SMVehicleTypeObject *objectVehicleListingInCell = (SMVehicleTypeObject *) [vehicleTypeArray objectAtIndex:indexPath.row];
            [cell.lblMakeName      setText:objectVehicleListingInCell.strType];
        }
        else
        {
            if(![txtType isFirstResponder])
         
            {
                SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *) [listAddToTenderArray objectAtIndex:indexPath.row];
                [cell.lblMakeName      setText:objectVehicleListingInCell.strMakeName];
          
            }
            
        }
        
        return cell;
    }
    
    static NSString *cellIdentifier= @"SMAddToStockTableViewCell";
    
    SMAddToStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (self.isFromAddToStockPage) {
        cell.txtVinNo.text = self.VINLookupObject.VIN;
        cell.txtRegNo.text = self.VINLookupObject.Registration;
        cell.txtEngineNo.text = self.VINLookupObject.EngineNo;
        
    }
    
    if([SMGlobalClass sharedInstance].isListModule)
    {
        if(self.photosExtrasDetailsObject != nil)
        {
            NSLog(@"self.photosExtrasDetailsObject.oemCode = %@",self.photosExtrasDetailsObject.oemCode);
            NSLog(@"self.photosExtrasDetailsObject.internalNote = %@",self.photosExtrasDetailsObject.internalNote);
        }
        
        
        cell.txtOmeNo.text=  self.photosExtrasDetailsObject.oemCode;
        cell.txtCostR.text=self.photosExtrasDetailsObject.strCostR;
        cell.txtStandInR.text= self.photosExtrasDetailsObject.strStandinR;
        
        cell.txtVinNo.text = self.photosExtrasDetailsObject.vinNumber;
        cell.txtEngineNo.text= self.photosExtrasDetailsObject.EngineNumber;
        
        /*if(!self.photosExtrasDetailsObject.isEditable)
        {
            cell.txtVinNo.userInteractionEnabled = NO;
            cell.txtEngineNo.userInteractionEnabled = NO;
            
        }
        else
        {
            cell.txtVinNo.userInteractionEnabled = YES;
            cell.txtEngineNo.userInteractionEnabled = YES;
        }*/

        
        cell.txtRegNo.text=self.photosExtrasDetailsObject.RegNumber;
        cell.txtLocation.text=self.photosExtrasDetailsObject.strLocation;
        cell.txtAddToTender.tag=KTextAddTender;
        
        NSLog(@"internalNoteee1 = %@",self.photosExtrasDetailsObject.internalNote);
        
        cell.txtInternalNote.text=self.photosExtrasDetailsObject.internalNote;
        
        NSLog(@"internalNoteee1 = %@",cell.txtInternalNote.text);
        
        cell.txtTrim.text=self.photosExtrasDetailsObject.strTrim;
        
        cell.btnDontLetOverride.selected = self.photosExtrasDetailsObject.checkBox1;//IgnoreSetting
        cell.btnIgnoreExcludeSetting.selected = self.photosExtrasDetailsObject.checkBox2;// Override
        cell.btnActivateCPA.selected = self.photosExtrasDetailsObject.checkBox3; // ShowErrorDisclaimaer
        cell.btnRemoveVehicle.selected = self.photosExtrasDetailsObject.checkBox4; // CPA error
    
    }
    else if(isUpdateVehicleInformation == YES)
    {
        cell.btnDontLetOverride.selected = self.VINLookupObject.checkBox1;//IgnoreSetting
        cell.btnIgnoreExcludeSetting.selected = self.VINLookupObject.checkBox2;// Override
        cell.btnActivateCPA.selected = self.VINLookupObject.checkBox3; // ShowErrorDisclaimaer
        cell.txtOmeNo.text               =  self.VINLookupObject.oemNo;
        cell.txtLocation.text            =  self.VINLookupObject.strLocation;
        cell.txtCostR.text               =  self.VINLookupObject.costR;
        cell.txtStandInR.text            =  self.VINLookupObject.standR;
        cell.txtEngineNo.text            =  self.VINLookupObject.EngineNo;
        cell.txtInternalNote.text        =  self.VINLookupObject.internalNote;
        cell.txtVinNo.text               =  self.VINLookupObject.VIN;
        cell.txtRegNo.text               =  self.VINLookupObject.Registration;
        cell.txtTrim.text                =  self.VINLookupObject.trim;
        
        
       /* if(!self.VINLookupObject.isEditable)
        {
            cell.txtVinNo.userInteractionEnabled = NO;
            cell.txtEngineNo.userInteractionEnabled = NO;
            
        }
        else
        {
            cell.txtVinNo.userInteractionEnabled = YES;
            cell.txtEngineNo.userInteractionEnabled = YES;
        }*/

    }


    if(isExpandable)
    {
        cell.footerView.hidden=NO;
        [cell.btnAdditionalInfo setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    }
    else
    {
        cell.footerView.hidden=YES;
        [cell.btnAdditionalInfo setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        
    }

    cell.btnRemoveVehicle.tag=indexPath.row;
    cell.btnIgnoreExcludeSetting.tag=indexPath.row;
    cell.btnDontLetOverride.tag=indexPath.row;
    cell.btnActivateCPA.tag=indexPath.row;
    cell.btnAdditionalInfo.tag=indexPath.row;
    
    cell.txtOmeNo.tag=kTextOme;
    cell.txtCostR.tag=kTextCostR;
    cell.txtStandInR.tag=kTextStanInR;
    cell.txtVinNo.tag=kTextVin;
    cell.txtEngineNo.tag=kTextEngibe;
    cell.txtRegNo.tag=kTextReg;
    cell.txtLocation.tag=kTextLocation;
    cell.txtAddToTender.tag=KTextAddTender;
    cell.txtInternalNote.tag=KTextViewInternamNote;
    NSLog(@"internalNoteee2 = %@",cell.txtInternalNote.text);
    cell.txtTrim.tag=KTextTrim;
    
    cell.txtStandInR.toolbarDelegate=self;
    cell.txtStandInR.delegate=self;
    cell.txtCostR.toolbarDelegate=self;
    cell.txtCostR.delegate=self;
    cell.txtOmeNo.toolbarDelegate=self;
    cell.txtOmeNo.delegate=self;
    cell.txtVinNo.toolbarDelegate=self;
    cell.txtVinNo.delegate = self;
    cell.txtEngineNo.toolbarDelegate=self;
    cell.txtEngineNo.delegate = self;
    cell.txtRegNo.toolbarDelegate=self;
    cell.txtRegNo.delegate = self;
    cell.txtLocation.toolbarDelegate=self;
    cell.txtLocation.delegate=self;
    cell.txtAddToTender.delegate=self;
    cell.txtInternalNote.toolbarDelegate=self;
    cell.txtInternalNote.delegate=self;
    cell.txtTrim.toolbarDelegate=self;
    cell.txtTrim.delegate=self;
    
    
    
    [cell.btnAdditionalInfo addTarget:self action:@selector(btnAdditioanlInfoDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnActivateCPA addTarget:self action:@selector(btnActivateCPADidPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDontLetOverride addTarget:self action:@selector(btnDontLetOverrideDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnIgnoreExcludeSetting addTarget:self action:@selector(btnIgnoreExcludeSettingDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnRemoveVehicle addTarget:self action:@selector(btnRemoveVehicleDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [cell setBackgroundColor:[UIColor clearColor]];

    return cell;
}

#define mark - table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==loadVehicleTableView)
    {
        if (isVehicleType == YES)
        {
            SMVehicleTypeObject *objectVehicleListingInCell = (SMVehicleTypeObject *) [vehicleTypeArray objectAtIndex:indexPath.row];
            txtType.text=objectVehicleListingInCell.strType;
            strSlectedTypeId = objectVehicleListingInCell.strTypeId.intValue;
            
        }
        else
        {
            
                SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *)[listAddToTenderArray objectAtIndex:indexPath.row];
                SMAddToStockTableViewCell *cell = (SMAddToStockTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                
                cell.txtAddToTender.text=objectVehicleListingInCell.strMakeName;
                didUserChangeAnything = YES;
            
                strSlectedTenderId = objectVehicleListingInCell.strMakeId.intValue;
                isTender=YES;
                if (isTender == YES)
                {
                    
                    [btnVehicleIsRetail setSelected:NO];
                    [btnVehicleIsTender setSelected:NO];
                }
            

        }
         didUserChangeAnything = YES;
        [self dismissPopup];
        
    }
}





#pragma mark - User Define Functions 
- (IBAction)btnDeleteStockVideosDidClicked:(id)sender1
{
    UIButton *button=(UIButton *)sender1;
    deleteButtonTag = button.tag;
    
    UIBAlertView *alert=[[UIBAlertView alloc] initWithTitle:KLoaderTitle
                                message:KDeleteImageAlert cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    
    [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
        if (didCancel) {
            return;
        }
        switch (selectedIndex)
        {
            case 1:
                [self removeSelectedImage];
                break;
            default:
                break;
        }
    }];
}

-(void) removeSelectedImage
{
    SMClassOfUploadVideos *deleteImageObject = (SMClassOfUploadVideos*)[arrayOfVideos objectAtIndex:deleteButtonTag];
    
    if(deleteImageObject.isVideoFromLocal==NO)
    {
        [[SMGlobalClass sharedInstance].arrayOfVideosToBeDeleted addObject:[arrayOfVideos objectAtIndex:deleteButtonTag]];
    }
    
    
    [arrayOfVideos removeObjectAtIndex:deleteButtonTag];
    [self.videosCollectionView reloadData];
}


-(IBAction)btnDeleteStockImageDidClicked:(id)sender1
{
    UIButton *button=(UIButton *)sender1;
    deleteButtonTag = button.tag;
    UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:KDeleteImageAlert cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes",nil];
    [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
     {
         
         switch (selectedIndex)
         {
             case 1:
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
                 [self.photosCollectionView reloadData];
             }
                 break;
             default:
                 break;
         }
     }];
}


#pragma mark -

- (IBAction)uploadDidClicked:(id)sender
{
}

- (void)uploadProgressPercentage:(float)percentage;
{
    HUD.progress=percentage/100;
}


#pragma mark - User Define web servcie call functions
-(void) updateVehicleInformations
{


    SMAddToStockTableViewCell *cell = (SMAddToStockTableViewCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];


    
    NSMutableURLRequest *requestURL;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    if([txtType.text isEqualToString:@"Used"])
    {
        strSlectedTypeId = 2;
    }
    requestURL = [SMWebServices
                  updateVehicleInfomationIfAlreadyInStock:[SMGlobalClass sharedInstance].hashValue
                  Colour: [self encodeString:txtColour.text]
                  Comments:[self encodeString:txtComment.text]
                  Condition:[self encodeString:txtCondition.text]
                  DeleteReason:@""
                  DepartmentID:strSlectedTypeId
                  EngineNo:[self encodeString:cell.txtEngineNo.text]
                  Extras:[self encodeString:txtExtras.text]
                  FullServiceHistory:false
                  IgnoreImport:cell.btnDontLetOverride.selected == YES ? 1:0
                  InternalNote:[self encodeString:cell.txtInternalNote.text]
                  IsDeleted:cell.btnRemoveVehicle.selected == YES ? 1:0
                  IsProgram:btnVehicleProgram.selected == YES ? 1:0
                  IsRetail:btnVehicleIsRetail.selected == YES ? 1:0
                  IsTender:isTender
                  IsTrade:btnVehicleIsTender.selected  == YES ? 1:0
                  Location:[self encodeString:cell.txtLocation.text]
                  MMCode:self.strMeanCode
                  ManufacturerModelCode:cell.txtOmeNo.text
                  Mileage:[txtMileage.text intValue]
                  OriginalCost:[cell.txtCostR.text doubleValue]
                  Override:cell.btnIgnoreExcludeSetting.selected == YES ? 1:0
                  OverrideReason:@""
                  PlusAccessories:false
                  PlusAdmin:false
                  PlusMileage:[txtMileage.text floatValue]
                  PlusRecon:false
                  Price:[txtPriceRetail.text intValue]
                  ProgramName:[self encodeString:txtProgramName.text]
                  Registration:[self encodeString:cell.txtRegNo.text]
                  ShowErrorDisclaimer:cell.btnActivateCPA.selected == YES ? 1:0
                  Standin:[cell.txtStandInR.text doubleValue]
                  StockCode:[self encodeString:txtStock.text]
                  TouchMethod:@"iPhone App"
                  TradePrice:[txtTrade.text doubleValue]
                  Trim:[self encodeString:cell.txtTrim.text]
                  UsedVehicleStockID:self.iStockID
                  UsedYear:[txtVehicleYear.text intValue]
                  VIN:[self encodeString:cell.txtVinNo.text]];
    
    
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
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];

}

-(void)updateVehicleInfoWhenNotInListModule
{
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    SMAddToStockTableViewCell *cell = (SMAddToStockTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    
    // if price is greater than the 30000 then it only show in photos and extras
    
    NSMutableURLRequest *requestURL=[SMWebServices AddVehicleFoUserhash:
                                     [SMGlobalClass sharedInstance].hashValue
                                                               ClientID:[SMGlobalClass sharedInstance].strClientID.intValue
                                                                 Colour:txtColour.text
                                                               Comments:[self encodeString:txtComment.text]
                                                              Condition:[self encodeString:txtCondition.text]
                                                           DeleteReason:@""
                                                           DepartmentID:strSlectedTypeId
                                                               EngineNo:[self encodeString:cell.txtEngineNo.text]
                                                                 Extras:[self encodeString:txtExtras.text]
                                                     FullServiceHistory:false
                                                           IgnoreImport:cell.btnDontLetOverride.selected == YES ? 1:0
                                                           InternalNote:[self encodeString:cell.txtInternalNote.text]
                                                              IsDeleted:false // by defualt whe we add vehicle its false
                                                              IsProgram:btnVehicleProgram.selected ==YES?1:0
                                                               IsRetail:btnVehicleIsRetail.selected ==YES?1:0
                                                               IsTender:isTender
                                                                IsTrade:btnVehicleIsTender.selected==YES?1:0
                                                               Location:[self encodeString:cell.txtLocation.text]
                                                                 MMCode:self.strMeanCode
                                                  ManufacturerModelCode:cell.txtOmeNo.text
                                                                Mileage:[txtMileage.text intValue]
                                                           OriginalCost:[cell.txtCostR.text doubleValue]
                                                               Override:cell.btnIgnoreExcludeSetting.selected == YES ? 1:0
                                                         OverrideReason:@""
                                                        PlusAccessories:false
                                                              PlusAdmin:false
                                                            PlusMileage:[txtMileage.text floatValue]
                                                              PlusRecon:false
                                                                  Price:[txtPriceRetail.text intValue]
                                                            ProgramName:txtProgramName.text
                                                           Registration:[self encodeString:cell.txtRegNo.text]
                                                    ShowErrorDisclaimer:cell.btnActivateCPA.selected == YES ? 1 :0
                                                                Standin:[cell.txtStandInR.text doubleValue]
                                                              StockCode:[self encodeString:txtStock.text]
                                                            TouchMethod:@"iPhone App"
                                                             TradePrice:[txtTrade.text doubleValue]
                                                                   Trim:[self encodeString:cell.txtTrim.text]
                                                     UsedVehicleStockID:self.iStockID
                                                               UsedYear:[txtVehicleYear.text intValue]
                                                                    VIN:[self encodeString:cell.txtVinNo.text]];
    
    
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
             
             
             xmlParser = [[SMParserForUrlConnection alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
    
}

- (IBAction)btnForUpdatingVariantDidClicked:(id)sender
{
    
    
    SMListUpdateVariantViewController *listDetailObject;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        listDetailObject=[[SMListUpdateVariantViewController alloc]initWithNibName:@"SMListUpdateVariantViewController" bundle:nil];
    }
    else
    {
        listDetailObject=[[SMListUpdateVariantViewController alloc]initWithNibName:@"SMListUpdateVariantViewController_iPad" bundle:nil];
    }
    listDetailObject.vehicleListDelegates = self;
    
    [self.navigationController pushViewController:listDetailObject animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheVariantMeanCode:) name:@"GetTheVariantMeanCode" object:nil];

}


// changes by Liji....

-(void)getLoadVehicleFromServer
{
    NSLog(@"self.photosExtrasObject222 = %@",self.photosExtrasObject.strUsedVehicleStockID);
    
    NSMutableURLRequest *requestURL = [SMWebServices gettingLoadVehiclesImagesListForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:[self.photosExtrasObject.strUsedVehicleStockID intValue]];
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [HUD show:YES];
    HUD.labelText = KLoaderText;

    
    [SMUrlConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
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





-(void) addvehicleInToStock
{

    [HUD show:YES];
    HUD.labelText = KLoaderText;
    SMAddToStockTableViewCell *cell = (SMAddToStockTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    // if price is greater than the 30000 then it only show in photos and extras
    
    NSMutableURLRequest *requestURL=[SMWebServices AddVehicleFoUserhash:
                                [SMGlobalClass sharedInstance].hashValue
                                ClientID:[SMGlobalClass sharedInstance].strClientID.intValue
                                Colour:txtColour.text
                                Comments:[self encodeString:txtComment.text]
                                Condition:[self encodeString:txtCondition.text]
                                DeleteReason:@""
                                DepartmentID:strSlectedTypeId
                                EngineNo:cell.txtEngineNo.text
                                Extras:[self encodeString:txtExtras.text]
                                FullServiceHistory:false
                                IgnoreImport:cell.btnDontLetOverride.selected == YES ? 1:0
                                InternalNote:[self encodeString:cell.txtInternalNote.text]
                                IsDeleted:false // by defualt whe we add vehicle its false
                                IsProgram:btnVehicleProgram.selected ==YES?1:0
                                IsRetail:btnVehicleIsRetail.selected ==YES?1:0
                                IsTender:isTender
                                IsTrade:btnVehicleIsTender.selected==YES?1:0
                                Location:[self encodeString:cell.txtLocation.text]
                                MMCode:self.strMeanCode
                                ManufacturerModelCode:@""
                                Mileage:[txtMileage.text intValue]
                                OriginalCost:[cell.txtCostR.text doubleValue]
                                Override:cell.btnIgnoreExcludeSetting.selected == YES ? 1:0
                                OverrideReason:@""
                                PlusAccessories:false
                                PlusAdmin:false
                                PlusMileage:[txtMileage.text floatValue]
                                PlusRecon:false
                                Price:[txtPriceRetail.text intValue]
                                ProgramName:txtProgramName.text
                                Registration:[self encodeString:cell.txtRegNo.text]
                                ShowErrorDisclaimer:cell.btnActivateCPA.selected == YES ? 1 :0
                                Standin:[cell.txtStandInR.text doubleValue]
                                StockCode:[self encodeString:txtStock.text]
                                TouchMethod:@"iPhone App"
                                TradePrice:[txtTrade.text doubleValue]
                                Trim:[self encodeString:cell.txtTrim.text]
                                UsedVehicleStockID:self.iStockID
                                UsedYear:[txtVehicleYear.text intValue]
                                VIN:[self encodeString:cell.txtVinNo.text]];
   
    // Dr. Ankit: Found a major issue (A BUG); Engine number passes as null.
    // self.VINLookupObject.EngineNo replaced by cell.txtEngineNo.text
    
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
    
             xmlParser = [[SMParserForUrlConnection alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
        }
     }];
}


-(void)getTheVariantMeanCode:(NSNotification *) notification
{
    
    if([SMGlobalClass sharedInstance].isListModule == NO)
        [self.btnEditVariant setHidden:YES];
    else
        [self.btnEditVehicle setHidden:YES];
    
    
    
    self.vehicleObject = [notification object];
        txtVehicleYear.text = self.vehicleObject.strMakeYear;
    
    self.strMeanCode = self.vehicleObject.strMeanCodeNumber;
    
    self.photosExtrasDetailsObject.variantID = self.vehicleObject.strMakeId.intValue;
    
    
    if([SMGlobalClass sharedInstance].isListModule == YES || self.isFromVinLookUpEditPage) // IF FROM LIST MODULE
    {
                
        self.lblMMCode.text = [NSString stringWithFormat:@"M&M : %@",self.vehicleObject.strMeanCodeNumber];
        //self.lblVehicleName.text = [NSString stringWithFormat:@"%@ %@",self.vehicleObject.strMakeYear,self.vehicleObject.strMakeName];
        
        [self setAttributedTextForVehicleDetailsWithFirstText:self.vehicleObject.strMakeYear andWithSecondText:self.vehicleObject.strMakeName forLabel:self.lblVehicleName];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            
            self.lblMMCode.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            self.lblVehicleDetails.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            
            [self.lblVehicleName sizeToFit];
            [self.lblMMCode sizeToFit];
            [self.lblVehicleDetails sizeToFit];
            
            self.lblVehicleName.frame = CGRectMake(self.lblVehicleName.frame.origin.x, 7 , 200, self.lblVehicleName.frame.size.height);
            
            self.lblMMCode.frame = CGRectMake(self.lblMMCode.frame.origin.x, self.lblVehicleName.frame.origin.y + self.lblVehicleName.frame.size.height +2.0, 185, self.lblMMCode.frame.size.height);
            
            self.lblVehicleDetails.frame = CGRectMake(self.lblVehicleDetails.frame.origin.x, self.lblMMCode.frame.origin.y + self.lblMMCode.frame.size.height +2.0, 200, self.lblVehicleDetails.frame.size.height);
        }
        else
        {
            self.lblMMCode.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            self.lblVehicleDetails.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            
            [self.lblVehicleName sizeToFit];
            [self.lblMMCode sizeToFit];
            [self.lblVehicleDetails sizeToFit];
            
            self.lblVehicleName.frame = CGRectMake(self.lblVehicleName.frame.origin.x, 7 , 550, self.lblVehicleName.frame.size.height);
            
            self.lblMMCode.frame = CGRectMake(self.lblMMCode.frame.origin.x, self.lblVehicleName.frame.origin.y + self.lblVehicleName.frame.size.height +2.0, 550, self.lblMMCode.frame.size.height);
            
            self.lblVehicleDetails.frame = CGRectMake(self.lblVehicleDetails.frame.origin.x, self.lblMMCode.frame.origin.y + self.lblMMCode.frame.size.height +2.0, 550, self.lblVehicleDetails.frame.size.height);
        }
        
        [self.headerView addSubview:self.viewHoldingTopHeaderData];
        
        self.viewHoldingBottomHeaderData.frame = CGRectMake(self.viewHoldingBottomHeaderData.frame.origin.x, self.viewHoldingTopHeaderData.frame.origin.y + self.viewHoldingTopHeaderData.frame.size.height +3.0, self.viewHoldingBottomHeaderData.frame.size.width, self.viewHoldingBottomHeaderData.frame.size.height);
    }
    else
    {
        lblMM.text = [NSString stringWithFormat:@"M&M : %@",self.vehicleObject.strMeanCodeNumber];
        lblVehicleName.text = [NSString stringWithFormat:@"%@ %@",self.vehicleObject.strMakeYear,self.vehicleObject.strMakeName];
        

    }
   
}

-(void) getRefreshedVairnatName
{
    [self fetchVariantDetialsWithVariantID:self.photosExtrasDetailsObject.variantID];

}

#pragma mark -



#pragma mark - Calculating Year Custom User Define Function

-(void) gettingYearCustomFunction
{
    
    self.strSlectedVehicleYear = self.strUsedYear;
    yearArray = [[NSMutableArray alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    NSInteger year = [components year];
    yearArray=[[NSMutableArray alloc]init];
    for (int i=year; i>=1990; i--)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    // by default slected year will be arrays first object
    [yearVehiclePickerView reloadAllComponents];
}



-(void) registeringTheNib
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
         [self.tableView registerNib:[UINib nibWithNibName:@"SMAddToStockTableViewCell" bundle:nil]                      forCellReuseIdentifier:@"SMAddToStockTableViewCell"];
         [loadVehicleTableView registerNib:[UINib nibWithNibName:@"SMLoadVehicleTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMLoadVehicleTableViewCell"];
    }
    else
    {
    
      [self.tableView registerNib:[UINib nibWithNibName:@"SMAddToStockTableViewCell_iPad" bundle:nil]                      forCellReuseIdentifier:@"SMAddToStockTableViewCell"];
      [loadVehicleTableView registerNib:[UINib nibWithNibName:@"SMLoadVehicleTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMLoadVehicleTableViewCell"];
    }
    
    [self.photosCollectionView registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImagePV"];
    
    [self.photosCollectionView registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImagePV"];
    
    [self.videosCollectionView registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusVideoPV"];
    
    [self.videosCollectionView registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualVideoPV"];
    
   
    
}
#pragma mark -



#pragma mark - URL encoding/Decoding method

// This method is added By Jignesh k on  - 16 December
// Purpose - this will encode string to CDATA XML
-(NSString *) encodeString:(NSString *) encodeString
{
    encodeString = [NSString stringWithFormat:@"<![CDATA[%@]]>",encodeString];
    return encodeString;
}



-(BOOL) validateStock
{
    isExpandable = NO;
    [self.tableView reloadData];
    
    
    if(txtColour.text.length == 0)
    {
        SMAlert(KLoaderTitle, @"Please enter vehicle color");
        [txtColour becomeFirstResponder];
        return NO;
    }
    else if (txtType.text.length==0)
    {
        SMAlert(KLoaderTitle, @"Please select type");
        [txtTrade becomeFirstResponder];
        return NO;

    }
    else  if (txtMileage.text.length==0)
    {
        SMAlert(KLoaderTitle, @"Please enter mileage");
        [txtMileage becomeFirstResponder];
        return NO;
    }
    else  if (txtStock.text.length==0)
    {
        SMAlert(KLoaderTitle,@"Please enter stock number");
        [txtStock becomeFirstResponder];
        return NO;
    }
    else  if (txtPriceRetail.text.length==0)
    {
        SMAlert(KLoaderTitle,@"Please enter price retail.");
        [txtPriceRetail becomeFirstResponder];
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - Set Attributed Text
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


#pragma mark -

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

- (IBAction)btnPlusImageDidClicked:(id)sender
{
    int RemainingCount;
    
    NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];
    NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
    if ([arrayFiltered count] > 0)
    {
        RemainingCount = arrayOfImages.count-arrayFiltered.count;
    }
    else
        RemainingCount = arrayOfImages.count;
    
    
    
    if(RemainingCount<20)
    {
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
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
                                          RemainingCount = finalFilteredArray.count;
                                  }
                                  else
                                      RemainingCount = arrayOfImages.count;
                                  
                                  [SMGlobalClass sharedInstance].isFromCamera = NO;
                                  
                                  isFromAppGallery = YES;
                                  [self callTheMultiplePhotoSelectionLibraryWithRemainingCount:20 - RemainingCount andFromEditScreen:NO];
                              }
                                  
                              default:
                                  break;
                          }
                          
                          
                      }];
            
        }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select the picture:"
                                                        message:@""
                                                 preferredStyle:UIAlertControllerStyleAlert];
            
        
        UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@"Camera"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
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
                                                              }]; // 2
        UIAlertAction *documentAction = [UIAlertAction actionWithTitle:@"Select from library"
                                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
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
                                                                                 RemainingCount = finalFilteredArray.count;
                                                                         }
                                                                         else
                                                                             RemainingCount = arrayOfImages.count;
                                                                         
                                                                         [SMGlobalClass sharedInstance].isFromCamera = NO;
                                                                         
                                                                         isFromAppGallery = YES;
                                                                         [self callTheMultiplePhotoSelectionLibraryWithRemainingCount:20 - RemainingCount andFromEditScreen:NO];
                                                                     }
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

}

- (IBAction)btnPlusBtnVideosDidClicked:(id)sender
{
    if(canClientUploadVideos)
    {
        NSPredicate *predicateLocalVideos = [NSPredicate predicateWithFormat:@"isVideoFromLocal == %d",YES];
        NSArray *arrayFiltered = [arrayOfVideos filteredArrayUsingPredicate:predicateLocalVideos];

        if(arrayFiltered.count<2)
        {
            actionSheetVideos=[[UIActionSheet alloc]initWithTitle:@"Select The Video" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Select from library", nil];
            actionSheetVideos.tag=222;
            [actionSheetVideos showInView:self.view];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"You are not activated to upload videos. Please contact support@ix.co.za to get setup." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
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
#pragma mark - Videos load

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
            NSDictionary *dictVideoDetailObj = [NSDictionary dictionaryWithObjectsAndKeys:[SMGlobalClass sharedInstance].strClientID,@"ClientID",[SMGlobalClass sharedInstance].strMemberID,@"MemberID",videoObj.videoFullPath,@"VideoFullPath",[NSString stringWithFormat:@"%d",self.iStockID],@"VariantId",videoObj.videoTitle,@"VideoTitle",videoObj.videoDescription,@"VideoDescription",videoObj.videoTags,@"VideoTags",str,@"Searchable",@"2",@"ModuleIdentifier",videoObj.youTubeID,@"YoutubeID", nil];
            
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
