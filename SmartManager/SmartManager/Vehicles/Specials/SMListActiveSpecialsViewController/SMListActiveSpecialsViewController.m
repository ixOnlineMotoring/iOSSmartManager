//
//  SMListActiveSpecialsViewController.m
//  SmartManager
//
//  Created by Sandeep on 20/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMListActiveSpecialsViewController.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIImageView+WebCache.h"
#import "SMCreateSpecialViewController.h"
#import "UIBAlertView.h"
#import "SMCommonClassMethods.h"
#import "SMPhotosListNSObject.h"
//#import "SMAttributeStringFormatObject"

#define SPECIAL_DELETED_ALERT @"Special Deleted Successfully"

static int KTakeCountPagination = 10;
@interface SMListActiveSpecialsViewController ()
{
    SMPhotosListNSObject        *loadImageData;
}
@end

@implementation SMListActiveSpecialsViewController
@synthesize tblListActiveSpecials;

static NSString *cellIdentifier= @"listActiveSpecialsCellIdentifier";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        arrayActiveSpecial = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self registerNib];
    
    startIndex = 0;
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Active Specials"];
    
    [self addingProgressHUD];
    
    HUD.labelText = KLoaderText;
    [HUD show:YES];
    
    [self loadAllActiveSpecials:startIndex];
}

#pragma mark - UITableViewDataSource

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayActiveSpecial count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMListActiveSpecialsCell *cellListActiveSp = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    SMActiveSpecial *activeSpecial = (SMActiveSpecial *) [ arrayActiveSpecial objectAtIndex:indexPath.row];
    
    
    //[cellListActiveSp.lblVehicleName        setText:[activeSpecial.stractiveName length]== 0 ? @"VehicleName?" : activeSpecial.stractiveName];
    
    if([activeSpecial.stractiveName length] == 0)
        activeSpecial.stractiveName = @"VehicleName?";
    
    [[SMAttributeStringFormatObject sharedService] setAttributedTextForVehicleDetailsWithFirstText:activeSpecial.strUsedYear andWithSecondText:activeSpecial.stractiveName forLabel:cellListActiveSp.lblVehicleName];
    
    
    
   // [cellListActiveSp.lblVehicleName sizeToFit];

    [cellListActiveSp.lblDaysRemaning setText:[NSString stringWithFormat:@"%d",activeSpecial.isExpired]];
    
   // [cellListActiveSp.lblVehicleDetail setText:([activeSpecial.strUsedYear rangeOfString:@""].location !=NSNotFound) ? activeSpecial.strSummarySpecial : [NSString stringWithFormat:@"%@ %@",activeSpecial.strUsedYear,activeSpecial.strSummarySpecial]];
    
    [cellListActiveSp.lblVehicleDetail setText:([activeSpecial.strTitle rangeOfString:@""].location != NSNotFound) ? @"Title?" : activeSpecial.strTitle];
    
    //[cellListActiveSp.lblVehicleDetail sizeToFit];
    
   activeSpecial.strColor =  [activeSpecial.strColor length]== 0 ? @"Colour?" : activeSpecial.strColor;
   activeSpecial.strStockCode =  [activeSpecial.strStockCode length]== 0 ? @"stock code?" : activeSpecial.strStockCode;
   activeSpecial.strMileage =  [activeSpecial.strMileage length]== 0 ? @"Mileage?" : activeSpecial.strMileage;
    
    cellListActiveSp.lblVehicleDetails.text = [NSString stringWithFormat:@"%@ | %@ | %@",activeSpecial.strColor,activeSpecial.strStockCode,activeSpecial.strMileage];
    
   // [cellListActiveSp.lblVehicleDetails sizeToFit];
    
    
    [cellListActiveSp.lblNormalPrice setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:activeSpecial.strNormalPrice]];

    [cellListActiveSp.lblSpecialPrice setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:activeSpecial.strSpecialPrice]];

    [cellListActiveSp.lblSavePrice setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:activeSpecial.strSavePrice]];

    [cellListActiveSp.lblCreatedDate setText:[[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:activeSpecial.strSpecialCreatedDate withFormat:2]];
    
    [cellListActiveSp.lblFromDate    setText:[[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:activeSpecial.strSpecialStartDate withFormat:1]];
    
    [cellListActiveSp.lblToDate      setText: [[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:activeSpecial.strSpecialEndDate withFormat:1]];
    
    CGFloat height;
    
    height= [self heightForTextForMessageSection:activeSpecial.stractiveName andTextWidthForiPhone:self.view.frame.size.width - 131];
    
    cellListActiveSp.lblVehicleName.frame = CGRectMake(cellListActiveSp.lblVehicleName.frame.origin.x, cellListActiveSp.lblVehicleName.frame.origin.y, cellListActiveSp.lblVehicleName.frame.size.width,height);

    
    height= [self heightForTextForMessageSection:activeSpecial.strTitle andTextWidthForiPhone:self.view.frame.size.width - 131];
    
    cellListActiveSp.lblVehicleDetail.frame = CGRectMake(cellListActiveSp.lblVehicleDetail.frame.origin.x, cellListActiveSp.lblVehicleName.frame.origin.y + cellListActiveSp.lblVehicleName.frame.size.height + 5.0, cellListActiveSp.lblVehicleDetail.frame.size.width,height);
    
    
    
    height= [self heightForTextForMessageSection:
             cellListActiveSp.lblVehicleDetails.text andTextWidthForiPhone:self.view.frame.size.width - 131];
    
    cellListActiveSp.lblVehicleDetails.frame = CGRectMake(cellListActiveSp.lblVehicleDetails.frame.origin.x, cellListActiveSp.lblVehicleDetail.frame.origin.y + cellListActiveSp.lblVehicleDetail.frame.size.height + 5.0, cellListActiveSp.lblVehicleDetails.frame.size.width, height);
    
    cellListActiveSp.lblDaysRemaning.frame = CGRectMake(cellListActiveSp.lblDaysRemaning.frame.origin.x, cellListActiveSp.lblVehicleDetails.frame.origin.y + cellListActiveSp.lblVehicleDetails.frame.size.height + 5.0, cellListActiveSp.lblDaysRemaning.frame.size.width, cellListActiveSp.lblDaysRemaning.frame.size.height);
    
    cellListActiveSp.viewBottomDetails.frame = CGRectMake(cellListActiveSp.viewBottomDetails.frame.origin.x, cellListActiveSp.lblDaysRemaning.frame.origin.y + cellListActiveSp.lblDaysRemaning.frame.size.height + 5.0, cellListActiveSp.viewBottomDetails.frame.size.width, cellListActiveSp.viewBottomDetails.frame.size.height);
    
    
    // setting image for special vehicle
    
    
    NSLog(@"image count +>>>>> %lu",(unsigned long)activeSpecial.arrmForImage.count);
    
    if (activeSpecial.arrmForImage.count>0) {
        SMPhotosListNSObject *imageObj = (SMPhotosListNSObject*)[activeSpecial.arrmForImage objectAtIndex:0];
        
        NSLog(@"%@",imageObj.strAUTOSpecialImageID);
        NSLog(@"%@",imageObj.strOriginalFileName);
        NSLog(@"%@",imageObj.strIsSpecials);
        
        if ([imageObj.strIsSpecials isEqualToString:@"0"]) {
            imageObj.imageLink = [NSString stringWithFormat:@"http://netwin.ixstaging.co.za/GetImage?ImageID=%@",imageObj.strAUTOSpecialImageID];
            
            //imageObj.imageLink = [NSString stringWithFormat:@"http://netwin.ix.co.za/GetImage?ImageID=%@",imageObj.strAUTOSpecialImageID];
        }
        else{
          //  imageObj.imageLink = [NSString stringWithFormat:@"http://netwin.ixtest.co.za/GetSpecialsImage.aspx?autoSpecialImageId=%@",imageObj.strAUTOSpecialImageID];
            imageObj.imageLink = [NSString stringWithFormat:@"http://netwin.ix.co.za/GetSpecialsImage.aspx?autoSpecialImageId=%@",imageObj.strAUTOSpecialImageID];
        }
        [cellListActiveSp.imgViewActive setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageObj.imageLink]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        
    }else
    {
        cellListActiveSp.imgViewActive.image = [UIImage imageNamed:@"placeholder.jpeg"];
    }

    //[cellListActiveSp.imgViewActive setImageWithURL:[NSURL URLWithString:activeSpecial.strSpecailImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
    
    cellListActiveSp.selectionStyle=UITableViewCellSelectionStyleNone;
    [cellListActiveSp setBackgroundColor:[UIColor clearColor]];
    
    // For Deleting Special // END button
    [cellListActiveSp.btnEnd setTag:indexPath.row];
    [cellListActiveSp.btnEnd addTarget:self action:@selector(buttonEndDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // For Editing Special // EDIT button
    [cellListActiveSp.btnEdit setTag:indexPath.row];
    [cellListActiveSp.btnEdit addTarget:self action:@selector(buttonEditDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (arrayActiveSpecial.count-1 == indexPath.row)
    {
        [cellListActiveSp.viewUnderline setHidden:YES];
        if (arrayActiveSpecial.count != totalRecord)
        {
            startIndex+=10;
            
            [self loadAllActiveSpecials:startIndex];
        }
    }
    else
    {
        [cellListActiveSp.viewUnderline setHidden:NO];
    }

    return cellListActiveSp;
}

#pragma - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   SMActiveSpecial *activeSpecial = (SMActiveSpecial *) [ arrayActiveSpecial objectAtIndex:indexPath.row];
    
    CGFloat heightName = 0.0f;
    
   // activeSpecial.stractiveName = @"rrtrtrt serwerwe rwe rwer wer wer werwerwerw rew rwe rw er werwrewr" ;
    
   // activeSpecial.strType = @"rrtiopopo rtrt serwerwe rwe rwer wer wer werwerwerw rew rwe rw er werwrewr" ;

    
    heightName = [self heightForTextForMessageSection:activeSpecial.stractiveName andTextWidthForiPhone:self.view.frame.size.width - 131];
    
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails1 = 0.0f;
    
    
    heightDetails1 = [self heightForTextForMessageSection:activeSpecial.strTitle andTextWidthForiPhone:self.view.frame.size.width - 131];
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails2 = 0.0f;
    
    activeSpecial.strColor =  [activeSpecial.strColor length]== 0 ? @"Colour?" : activeSpecial.strColor;
    activeSpecial.strStockCode =  [activeSpecial.strStockCode length]== 0 ? @"stock code?" : activeSpecial.strStockCode;
    activeSpecial.strMileage =  [activeSpecial.strMileage length]== 0 ? @"Mileage?" : activeSpecial.strMileage;
    
    NSString *finalStr = [NSString stringWithFormat:@"%@ | %@ | %@",activeSpecial.strColor,activeSpecial.strStockCode,activeSpecial.strMileage ];
    
    heightDetails2 = [self heightForTextForMessageSection:finalStr andTextWidthForiPhone:self.view.frame.size.width - 131];
    
    
    
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? (heightName + heightDetails1 + heightDetails2 + 21 + 162+23) : 375.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - User Define Functions
- (void)registerNib
{
    [self.tblListActiveSpecials registerNib:[UINib nibWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? @"SMListActiveSpecialsCell" : @"SMListActiveSpecialsCell_iPad" bundle:nil] forCellReuseIdentifier:cellIdentifier];
}

-(void)loadAllActiveSpecials:(int)startAt
{
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllActiveSpecialListing:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withStartAt:startAt withTake:KTakeCountPagination];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             
             [self hideProgressHUD];
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

#pragma mark -


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
#pragma mark -


#pragma mark - NSxml Parser Delegates
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"AUTOSpecial"])
    {
        objectActiveSpecial = [SMActiveSpecial new];
    }
    
    if ([elementName isEqualToString:@"DocumentElement"])
    {
        isDocument = YES;
    }
    
    if ([elementName isEqualToString:@"Images"]) {
        objectActiveSpecial.arrmForImage = [[NSMutableArray alloc] init];
    }
    if([elementName isEqualToString:@"Image"])
    {
        loadImageData = [[SMPhotosListNSObject alloc]init];
    }

    currentNodeContent = [NSMutableString stringWithString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
   [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"SpecialID"])
    {
        objectActiveSpecial.strSpecialID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"UsedVehicleStockID"])
    {
        objectActiveSpecial.ItemID = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"StockCode"])
    {
        if([currentNodeContent length] == 0)
            objectActiveSpecial.strStockCode = @"stock code?";
            
        objectActiveSpecial.strStockCode = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"cmUserID"])
    {
        objectActiveSpecial.strCurrenUserID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SpecialCreated"])
    {
        objectActiveSpecial.strSpecialCreatedDate = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"AllowGroup"])
    {
        objectActiveSpecial.isAllowGroup = [currentNodeContent boolValue];
    }
    if ([elementName isEqualToString:@"Deleted"])
    {
        objectActiveSpecial.isDeleted = [currentNodeContent boolValue];
    }
    if ([elementName isEqualToString:@"LinkImagePriority"])
    {
        objectActiveSpecial.strImagePriority = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ItemValue"])
    {
        objectActiveSpecial.strItemValue = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Correction"])
    {
        objectActiveSpecial.isCorrected = [currentNodeContent boolValue];
    }
    if ([elementName isEqualToString:@"FriendlyName"])
    {
        objectActiveSpecial.stractiveName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        if([currentNodeContent length] == 0)
            objectActiveSpecial.strColor = @"Color?";
        
        objectActiveSpecial.strColor = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Title"])
    {
        objectActiveSpecial.strTitle = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Type"])
    {
        objectActiveSpecial.strType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SpecialTypeID"])
    {
        objectActiveSpecial.strTypeID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
        if([currentNodeContent length] == 0)
            objectActiveSpecial.strMileage = @"Mileage?";

        objectActiveSpecial.strMileage = currentNodeContent;
    }
    if([elementName isEqualToString:@"UsedYear"])
    {
        objectActiveSpecial.strUsedYear = currentNodeContent;
    }
    if (([elementName isEqualToString:@"NormalPrice"]))
    {
        objectActiveSpecial.strNormalPrice = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SpecialPrice"])
    {
        objectActiveSpecial.strSpecialPrice = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SavePrice"])
    {
        objectActiveSpecial.strSavePrice = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Details"])
    {
        objectActiveSpecial.strSpecialDetails = [self stringByStrippingHTML:currentNodeContent];
    }
    if ([elementName isEqualToString:@"SpecialStart"])
    {
        objectActiveSpecial.strSpecialStartDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Summary"])
    {
        objectActiveSpecial.strSummarySpecial = [self stringByStrippingHTML:currentNodeContent];
    }
    if ([elementName isEqualToString:@"SpecialEnd"])
    {
        objectActiveSpecial.strSpecialEndDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ImageID"])
    {
        objectActiveSpecial.strSpecailImageURL = [NSString stringWithFormat:@"%@%@",[SMWebServices activeSpecailListingImage],currentNodeContent];
    }
    if ([elementName isEqualToString:@"MakeId"])
    {
        objectActiveSpecial.strMakeID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ModelID"])
    {
        objectActiveSpecial.strModelID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"VariantID"])
    {
        objectActiveSpecial.strVariantID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"IsExpired"])
    {
        objectActiveSpecial.isExpired = currentNodeContent.boolValue;
    }
    
    if ([elementName isEqualToString:@"AUTOSpecial"])
    {
       // if (isDocument==YES)
        {
            [arrayActiveSpecial addObject:objectActiveSpecial];
        }
    }
    
    if ([elementName isEqualToString:@"TotalCount"])
    {
        totalRecord = [currentNodeContent intValue];
    }
    
    if ([elementName isEqualToString:@"SaveSpecialResult"])
    {
        if ([currentNodeContent isEqualToString:@"0"])
        {
            [self showAlert:@"Failed, Please Try Again."];
        }
        else
        {
            [self navigateBackAfterSavedSpecial];
        }
    }
    if ([elementName isEqualToString:@"DeleteSpecialResult"])
    {
        if ([currentNodeContent boolValue] == true)
        {
            UIBAlertView *alert;
            alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:kSpecialExpired cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 if (didCancel)
                 {
                     [arrayActiveSpecial removeAllObjects];
                     [self loadAllActiveSpecials:0];
                     
                     return;
                 }
             }];
        }
        else
        {
            [self showAlert:@"Please try again"];
        }
    }
    
    
    //====================================================
    
    if ([elementName isEqualToString:@"Images"]) {
        // sort the array using priority
        NSArray *sortedArray;
        sortedArray = [objectActiveSpecial.arrmForImage sortedArrayUsingComparator:^NSComparisonResult(SMPhotosListNSObject *a, SMPhotosListNSObject *b) {
            if ( a.strPriority.intValue < b.strPriority.intValue) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if ( a.strPriority.intValue > b.strPriority.intValue) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        [objectActiveSpecial.arrmForImage removeAllObjects];
        objectActiveSpecial.arrmForImage = sortedArray.mutableCopy;
        
    }
    
    if([elementName isEqualToString:@"Image"])
    {
        loadImageData.isImageFromLocal=NO;
        loadImageData.imageOriginIndex = -1;
        [objectActiveSpecial.arrmForImage addObject:loadImageData];
    }
    
    if([elementName isEqualToString:@"AUTOSpecialImageID"])
    {
        loadImageData.strAUTOSpecialImageID = currentNodeContent;
    }
    if([elementName isEqualToString:@"OriginalFileName"])
    {
        loadImageData.strOriginalFileName = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"Priority"])
    {
        loadImageData.strPriority = currentNodeContent;
    }
    if([elementName isEqualToString:@"IsSpecial"])
    {
        loadImageData.strIsSpecials = currentNodeContent;
    }
    if([elementName isEqualToString:@"AUTOSpecialID"])
    {
        loadImageData.strAUTOSpecialID = currentNodeContent;
    }
    
    
    //====================================================
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
    
    if (arrayActiveSpecial.count == 0)
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                UIBAlertView *alert;
                alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:KNorecordsFousnt cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
                 {
                     if (didCancel)
                     {
                         [self.navigationController popViewControllerAnimated:YES];
                         return;
                     }
                 }];
            });
        });
    }
    else
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tblListActiveSpecials reloadData];
            });
        });
    }
}
-(void) showAlert:(NSString *)alertMeassge
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert;
            if (alert == nil)
            {
                alert  = [[UIAlertView alloc]initWithTitle:KLoaderTitle  message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            }
            
            [alert setMessage:alertMeassge];
            [alert show];
        });
    });
}

-(void) navigateBackAfterSavedSpecial
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle  message:KSPecilaMoved cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
         {
             if (didCancel)
             {
                 [self.navigationController popViewControllerAnimated:YES];
                 return;
             }
         }];
    });
}
- (CGFloat)heightForTextForMessageSection:(NSString *)bodyText andTextWidthForiPhone:(float)textWidth
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:15];
        textSize = textWidth;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        textSize = 570;
    }
    CGSize constraintSize = CGSizeMake(textSize, MAXFLOAT);
    //   CGSize labelSize = [bodyText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect textRect = [bodyText boundingRectWithSize:constraintSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:cellFont}
                                             context:nil];
    
    CGSize labelSize = textRect.size;
    CGFloat height = labelSize.height;
    
    return height;
}



#pragma mark -

#pragma mark - User Define Functions

-(void) buttonEndDidPressed:(id) sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            UIBAlertView *alert;
            if (alert == nil)
            {
                alert  = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:KspecialMovedPermission cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes",nil];
            }
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
            {
                if (didCancel)
                {
                    return;
                }
                switch (selectedIndex)
                {
                    case 1:
                    {
                        activeObjectOnDeleteButton = (SMActiveSpecial *)[arrayActiveSpecial objectAtIndex:[sender tag]];
                        [self webServiceForDeleteSpecialwithSpecialID:activeObjectOnDeleteButton.strSpecialID.intValue withIsExpired:activeObjectOnDeleteButton.isExpired];

                    }
                        break;
                }
            }];
        });
    });
}

- (void)webServiceForDeleteSpecialwithSpecialID:(int)specailID withIsExpired:(BOOL)isExpired
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
    
    NSMutableURLRequest *requestURL = [SMWebServices  deleteSpecial:[SMGlobalClass sharedInstance].hashValue withSpecialID:specailID withIsExpired:isExpired];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
             
             [self hideProgressHUD];
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



- (void)webServiceForEditSpecialwithSpecialID:(NSString*)specailID withCurrentUserID:(NSString*)currentUserID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    activeObjectOnDeleteButton.strSpecialDetails = [self stringByStrippingHTML:activeObjectOnDeleteButton.strSpecialDetails];
    
    NSMutableURLRequest *requestURL = [SMWebServices createSpecial:[SMGlobalClass sharedInstance].hashValue
        withClientID:[SMGlobalClass sharedInstance].strClientID.intValue
        withSpecialTypeID:activeObjectOnDeleteButton.strTypeID.intValue
        withDateSpecialStart:[self checkDate]
        withendSpecialEnd:[self getDateToLastMonthDate]
                                       
        withItemID:activeObjectOnDeleteButton.ItemID
        withvariantID:activeObjectOnDeleteButton.strVariantID.intValue
        withModelID:activeObjectOnDeleteButton.strModelID.intValue
        withMakeID:activeObjectOnDeleteButton.strMakeID.intValue
        withspecialPrice:[NSString stringWithFormat:@"%0.0f",activeObjectOnDeleteButton.strSpecialPrice.floatValue]
        withnormalPrice:[NSString stringWithFormat:@"%0.0f",activeObjectOnDeleteButton.strNormalPrice.floatValue]
        withDetails:activeObjectOnDeleteButton.strSpecialDetails
        withSummary:activeObjectOnDeleteButton.strSummarySpecial
        withallowGroup:false
        withcorrection:activeObjectOnDeleteButton.isCorrected
       // withcurrentUserID:activeObjectOnDeleteButton.strCurrenUserID.intValue
        withSpecailID:activeObjectOnDeleteButton.strSpecialID.intValue
                                       withItemValue:@""
                                       withYear:activeObjectOnDeleteButton.strUsedYear];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
             
             [self hideProgressHUD];
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

- (void)buttonEditDidPressed:(id)sender
{
    SMActiveSpecial *objectInCell = (SMActiveSpecial *) [arrayActiveSpecial objectAtIndex:[sender tag]];
    
    __block SMCreateSpecialViewController *createSpecialObj;

    dispatch_async(dispatch_get_main_queue(), ^{
        
        createSpecialObj = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
        [[SMCreateSpecialViewController alloc]initWithNibName:@"SMCreateSpecialViewController" bundle:nil] :
        [[SMCreateSpecialViewController alloc]initWithNibName:@"SMCreateSpecialViewController_iPad" bundle:nil];
        
        createSpecialObj.activeSpecialObj = objectInCell;
        createSpecialObj.iCheckSpecial = 10;
        [self.navigationController pushViewController:createSpecialObj animated:YES];
    });
}


#pragma mark - Global Class Alert

void(^showAlert)(NSString *) =^void(NSString *alertMeassge)
{
    __unsafe_unretained SMListActiveSpecialsViewController *dp; // OK for iOS 6.x and up

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert;
            if (alert == nil)
            {
                alert  = [[UIAlertView alloc]initWithTitle:KLoaderTitle  message:@"" delegate:dp cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            }
            
            [alert setMessage:alertMeassge];
            [alert show];
        });
    });
};

#pragma mark -

#pragma mark -
// added by ketan
// this function will minus current date to and will return the yesterdays date

- (NSString*)getDateToLastMonthDate
{
    NSDate *now = [NSDate date];
    
    NSDate *lastMonthDate = [now dateByAddingTimeInterval:-1*24*60*60];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    
    NSString *newDate = [formatter stringFromDate:lastMonthDate];
    
    return [NSString stringWithFormat:@"%@",newDate];
}

#pragma mark -

// added by ketan
// this function will check that wheteher the start date is equal to or greater than current date

- (NSString*)checkDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    
    NSDate *currentDate = [formatter dateFromString:[formatter stringFromDate:[NSDate date]]];
    
    NSDate *newDate = [formatter dateFromString:[[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:activeObjectOnDeleteButton.strSpecialStartDate withFormat:1]];
    
    switch ([currentDate compare:newDate])
    {
        case NSOrderedAscending:
            return [self getDateToLastMonthDate];
            break;
            
        case NSOrderedDescending:
            return [formatter stringFromDate:newDate];
            break;
            
        case NSOrderedSame:
            return [self getDateToLastMonthDate];
            break;
    }
}

-(NSString *) stringByStrippingHTML:(NSString *) htmlString {
    NSRange r;
    while ((r = [htmlString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        htmlString = [htmlString stringByReplacingCharactersInRange:r withString:@""];
    return htmlString;
}

@end
