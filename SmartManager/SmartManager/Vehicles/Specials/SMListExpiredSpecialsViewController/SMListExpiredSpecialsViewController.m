//
//  SMListExpiredSpecialsViewController.m
//  SmartManager
//
//  Created by Sandeep on 20/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMListExpiredSpecialsViewController.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIImageView+WebCache.h"
#import "UIBAlertView.h"
#import "SMCreateSpecialViewController.h"
#import "SMPhotosListNSObject.h"
@interface SMListExpiredSpecialsViewController ()
{
    SMPhotosListNSObject        *loadImageData;
    
}
@end

@implementation SMListExpiredSpecialsViewController
@synthesize tblListExpiredSpecials;

static NSString *cellIdentifier= @"listExpiredSpecialsCellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addingProgressHUD];
    
    arrayExpiredSpecial = [[NSMutableArray alloc]init];
    
    [self registerNib];

   

    startIndex = 0;
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    if(self.isFromUnPublished)
    {
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Specials Awaiting Publish"];
        [self webServiceForListUnPublishedSpecial:startIndex];
    }
    else
    {
         self.navigationItem.titleView = [SMCustomColor setTitle:@"Expired Specials"];
        [self webServiceForListExpiredSpecial:startIndex];
    }
}

- (void)registerNib
{
    
        [self.tblListExpiredSpecials registerNib:[UINib nibWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? @"SMListActiveSpecialsCell" : @"SMListActiveSpecialsCell_iPad" bundle:nil] forCellReuseIdentifier:cellIdentifier];
   
}

#pragma mark - webService

- (void)webServiceForListExpiredSpecial:(int)startAt
{
    NSMutableURLRequest *requestURL = [SMWebServices gettingAllExpiredSpecialListing:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withStartAt:startAt withTake:10];
    
    
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

- (void)webServiceForListUnPublishedSpecial:(int)startAt
{
    NSMutableURLRequest *requestURL = [SMWebServices gettingAllUnPublishedSpecialListing:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withStartAt:startAt withTake:10];
    
    
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

- (void)webServiceForPublishSpecialwithSpecialID:(int)specailID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices  publishSpecial:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withSpecialID:specailID];
    
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

#pragma mark - NSXMLParser Delegate Methods

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    if ([elementName isEqualToString:@"AUTOSpecial"])
    {
        specialObject  = [[SMActiveSpecial alloc] init];
    }
    if ([elementName isEqualToString:@"DocumentElement"])
    {
        isDocument = YES;
    }
    
    if ([elementName isEqualToString:@"Images"]) {
        specialObject.arrmForImage = [[NSMutableArray alloc] init];
    }
    if([elementName isEqualToString:@"Image"])
    {
        loadImageData = [[SMPhotosListNSObject alloc]init];
    }

    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"FriendlyName"])
    {
        specialObject.stractiveName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Type"])
    {
        specialObject.strType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SpecialTypeID"])
    {
        specialObject.strTypeID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"UsedVehicleStockID"])// Dr. Change to UsedVehicleStockID
    {
        specialObject.ItemID = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"AllowGroup"])
    {
        specialObject.isAllowGroup = [currentNodeContent boolValue];
    }
    if ([elementName isEqualToString:@"Deleted"])
    {
        specialObject.isDeleted = [currentNodeContent boolValue];
    }
    if ([elementName isEqualToString:@"LinkImagePriority"])
    {
        specialObject.strImagePriority = currentNodeContent;
    }
    if ([elementName isEqualToString:@"StockCode"])
    {
        specialObject.strStockCode = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SpecialID"])
    {
        specialObject.strSpecialID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"cmUserID"])
    {
        specialObject.strCurrenUserID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SpecialPrice"])
    {
        specialObject.strSpecialPrice = currentNodeContent;
    }
    if ([elementName isEqualToString:@"NormalPrice"])
    {
        specialObject.strNormalPrice = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SavePrice"])
    {
        specialObject.strSavePrice = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Title"])
    {
        specialObject.strSummarySpecial = [self stringByStrippingHTML:currentNodeContent];
    }
    if ([elementName isEqualToString:@"SpecialStart"])
    {
        specialObject.strSpecialStartDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SpecialEnd"])
    {
        specialObject.strSpecialEndDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SpecialCreated"])
    {
        specialObject.strSpecialCreatedDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Details"])
    {
        specialObject.strSpecialDetails = [self stringByStrippingHTML:currentNodeContent];
    }
    if ([elementName isEqualToString:@"Correction"])
    {
        specialObject.isCorrected = [currentNodeContent boolValue];
    }
    if ([elementName isEqualToString:@"ImageID"])
    {
        specialObject.strSpecailImageURL = [NSString stringWithFormat:@"%@%@",[SMWebServices activeSpecailListingImage], currentNodeContent];
    }
    if ([elementName isEqualToString:@"MakeId"])
    {
        specialObject.strMakeID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ItemValue"])
    {
        specialObject.strItemValue = currentNodeContent;
    }
    if([elementName isEqualToString:@"UsedYear"])
    {
        specialObject.strUsedYear = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ModelID"])
    {
        specialObject.strModelID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"VariantID"])
    {
        specialObject.strVariantID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        specialObject.strColor = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
        specialObject.strMileage = currentNodeContent;
    }
    if ([elementName isEqualToString:@"IsExpired"])
    {
        specialObject.isExpired = currentNodeContent.boolValue;
    }
    if ([elementName isEqualToString:@"CanPublish"])
    {
        specialObject.canPublish = currentNodeContent.boolValue;
    }
    if ([elementName isEqualToString:@"DeleteSpecialResult"])
    {
        if ([currentNodeContent boolValue] == true)
        {
            UIBAlertView *alert;
            alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:kSpecialDeleted cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 if (didCancel)
                 {
                     [arrayExpiredSpecial removeAllObjects];
                     [self webServiceForListExpiredSpecial:0];

                     return;
                 }
             }];
        }
        else
        {
            [self showAlrt:@"Please try again"];
        }
    }
    if ([elementName isEqualToString:@"PublishSpecialResult"])
    {
        if ([currentNodeContent boolValue] == true)
        {
            UIBAlertView *alert;
            alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:kSpecialPublished cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 if (didCancel)
                 {
                     return ;
                 }
             }];
        }
        
    }
    
    if ([elementName isEqualToString:@"AUTOSpecial"])
    {
       // if (isDocument==YES)
        {
            [arrayExpiredSpecial addObject:specialObject];
        }
    }
    if ([elementName isEqualToString:@"TotalCount"])
    {
        totalRecord = [currentNodeContent intValue];
    }
    
    if ([elementName isEqualToString:@"MakeName"])
    {
        specialObject.strMakeName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ModelName"])
    {
        specialObject.strModelName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"VariantName"])
    {
        specialObject.strVariantName = currentNodeContent;
    }
    
    //====================================================
    
    if ([elementName isEqualToString:@"Images"]) {
        // sort the array using priority
        NSArray *sortedArray;
        sortedArray = [specialObject.arrmForImage sortedArrayUsingComparator:^NSComparisonResult(SMPhotosListNSObject *a, SMPhotosListNSObject *b) {
            if ( a.strPriority.intValue < b.strPriority.intValue) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if ( a.strPriority.intValue > b.strPriority.intValue) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        [specialObject.arrmForImage removeAllObjects];
        specialObject.arrmForImage = sortedArray.mutableCopy;
        
    }
    
    if([elementName isEqualToString:@"Image"])
    {
        loadImageData.isImageFromLocal=NO;
        loadImageData.imageOriginIndex = -1;
        [specialObject.arrmForImage addObject:loadImageData];
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
    
    if (arrayExpiredSpecial.count == 0)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
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
                [self.tblListExpiredSpecials reloadData];
            });
        });
    }
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

#pragma mark - UITableView DataSource

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayExpiredSpecial count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMListActiveSpecialsCell *cellListExpiredSp = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cellListExpiredSp.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if(self.isFromUnPublished)
    {
        [cellListExpiredSp.btnEdit setTitle: @"Activate" forState: UIControlStateNormal];
        [cellListExpiredSp.btnEnd setTitle: @"Edit/View" forState: UIControlStateNormal];
    }
    
    SMActiveSpecial *expiredSpecial = (SMActiveSpecial*)arrayExpiredSpecial[indexPath.row];

    [cellListExpiredSp.lblDaysRemaning setText:[NSString stringWithFormat:@"%d",expiredSpecial.isExpired]];

    if([expiredSpecial.stractiveName length] == 0)
        expiredSpecial.stractiveName = @"VehicleName?";
    
   // expiredSpecial.stractiveName = @"Nissan GT-R Black Editionnnnnnnn";
    
    [[SMAttributeStringFormatObject sharedService] setAttributedTextForVehicleDetailsWithFirstText:expiredSpecial.strUsedYear andWithSecondText:expiredSpecial.stractiveName forLabel:cellListExpiredSp.lblVehicleName];
    
    
    
    // [cellListExpiredSp.lblVehicleName sizeToFit];
    
    
    // [cellListExpiredSp.lblVehicleDetail setText:([activeSpecial.strUsedYear rangeOfString:@""].location !=NSNotFound) ? activeSpecial.strSummarySpecial : [NSString stringWithFormat:@"%@ %@",activeSpecial.strUsedYear,activeSpecial.strSummarySpecial]];
    
    [cellListExpiredSp.lblVehicleDetail setText:([expiredSpecial.strTypeID rangeOfString:@""].location != NSNotFound) ? @"Type?" : expiredSpecial.strType];
    
    //[cellListExpiredSp.lblVehicleDetail sizeToFit];
    
    expiredSpecial.strColor =  [expiredSpecial.strColor length]== 0 ? @"Colour?" : expiredSpecial.strColor;
    expiredSpecial.strStockCode =  [expiredSpecial.strStockCode length]== 0 ? @"stock code?" : expiredSpecial.strStockCode;
    expiredSpecial.strMileage =  [expiredSpecial.strMileage length]== 0 ? @"Mileage?" : expiredSpecial.strMileage;
    
    cellListExpiredSp.lblVehicleDetails.text = [NSString stringWithFormat:@"%@ | %@ | %@",expiredSpecial.strColor,expiredSpecial.strStockCode,expiredSpecial.strMileage];
    
    // [cellListExpiredSp.lblVehicleDetails sizeToFit];
    
    
    [cellListExpiredSp.lblNormalPrice setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:expiredSpecial.strNormalPrice]];
    
    [cellListExpiredSp.lblSpecialPrice setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:expiredSpecial.strSpecialPrice]];
    
    [cellListExpiredSp.lblSavePrice setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:expiredSpecial.strSavePrice]];
    
    [cellListExpiredSp.lblCreatedDate setText:[[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:expiredSpecial.strSpecialCreatedDate withFormat:2]];
    
    [cellListExpiredSp.lblFromDate    setText:[[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:expiredSpecial.strSpecialStartDate withFormat:1]];
    
    [cellListExpiredSp.lblToDate      setText: [[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:expiredSpecial.strSpecialEndDate withFormat:1]];
    
    CGFloat height;
    
    height= [self heightForTextForMessageSection:cellListExpiredSp.lblVehicleName.text andTextWidthForiPhone:self.view.frame.size.width - 131];
    
    cellListExpiredSp.lblVehicleName.frame = CGRectMake(cellListExpiredSp.lblVehicleName.frame.origin.x, cellListExpiredSp.lblVehicleName.frame.origin.y, cellListExpiredSp.lblVehicleName.frame.size.width,height);
    
    
    height= [self heightForTextForMessageSection:expiredSpecial.strType andTextWidthForiPhone:self.view.frame.size.width - 131];
    
    cellListExpiredSp.lblVehicleDetail.frame = CGRectMake(cellListExpiredSp.lblVehicleDetail.frame.origin.x, cellListExpiredSp.lblVehicleName.frame.origin.y + cellListExpiredSp.lblVehicleName.frame.size.height + 5.0, cellListExpiredSp.lblVehicleDetail.frame.size.width,height);
    
    
    
    height= [self heightForTextForMessageSection:
             cellListExpiredSp.lblVehicleDetails.text andTextWidthForiPhone:self.view.frame.size.width - 131];
    
    cellListExpiredSp.lblVehicleDetails.frame = CGRectMake(cellListExpiredSp.lblVehicleDetails.frame.origin.x, cellListExpiredSp.lblVehicleDetail.frame.origin.y + cellListExpiredSp.lblVehicleDetail.frame.size.height + 5.0, cellListExpiredSp.lblVehicleDetails.frame.size.width, height);
    
    cellListExpiredSp.lblDaysRemaning.frame = CGRectMake(cellListExpiredSp.lblDaysRemaning.frame.origin.x, cellListExpiredSp.lblVehicleDetails.frame.origin.y + cellListExpiredSp.lblVehicleDetails.frame.size.height + 5.0, cellListExpiredSp.lblDaysRemaning.frame.size.width, cellListExpiredSp.lblDaysRemaning.frame.size.height);
    
    cellListExpiredSp.viewBottomDetails.frame = CGRectMake(cellListExpiredSp.viewBottomDetails.frame.origin.x, cellListExpiredSp.lblDaysRemaning.frame.origin.y + cellListExpiredSp.lblDaysRemaning.frame.size.height + 5.0, cellListExpiredSp.viewBottomDetails.frame.size.width, cellListExpiredSp.viewBottomDetails.frame.size.height);
    
    NSLog(@"image count +>>>>> %lu",(unsigned long)expiredSpecial.arrmForImage.count);
    
    if (expiredSpecial.arrmForImage.count>0) {
        SMPhotosListNSObject *imageObj = (SMPhotosListNSObject*)[expiredSpecial.arrmForImage objectAtIndex:0];
        
        NSLog(@"%@",imageObj.strAUTOSpecialImageID);
        NSLog(@"%@",imageObj.strOriginalFileName);
        NSLog(@"%@",imageObj.strIsSpecials);
        
        if ([imageObj.strIsSpecials isEqualToString:@"0"]) {
            imageObj.imageLink = [NSString stringWithFormat:@"http://netwin.ixstaging.co.za/GetImage?ImageID=%@",imageObj.strAUTOSpecialImageID];
            
             //imageObj.imageLink = [NSString stringWithFormat:@"http://netwin.ix.co.za/GetImage?ImageID=%@",imageObj.strAUTOSpecialImageID];
        }
        else{
            //imageObj.imageLink = [NSString stringWithFormat:@"http://netwin.ixtest.co.za/GetSpecialsImage.aspx?autoSpecialImageId=%@",imageObj.strAUTOSpecialImageID];
            
             imageObj.imageLink = [NSString stringWithFormat:@"http://netwin.ix.co.za/GetSpecialsImage.aspx?autoSpecialImageId=%@",imageObj.strAUTOSpecialImageID];
        }
        [cellListExpiredSp.imgViewActive setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageObj.imageLink]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
 
    }else
    {
        cellListExpiredSp.imgViewActive.image = [UIImage imageNamed:@"placeholder.jpeg"];
    }
    // [cellListExpiredSp.imgViewActive setImageWithURL:[NSURL URLWithString:expiredSpecial.strSpecailImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
     
    [cellListExpiredSp setBackgroundColor:[UIColor clearColor]];

    // For Deleting Special // END button
    [cellListExpiredSp.btnEnd setTag:indexPath.row];
    [cellListExpiredSp.btnEnd addTarget:self action:@selector(buttonEndDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // For Editing Special // EDIT button
    [cellListExpiredSp.btnEdit setTag:indexPath.row];
    [cellListExpiredSp.btnEdit addTarget:self action:@selector(buttonEditDidPressed:) forControlEvents:UIControlEventTouchUpInside];

    if (arrayExpiredSpecial.count-1 == indexPath.row)
    {
        [cellListExpiredSp.viewUnderline setHidden:YES];
        if (arrayExpiredSpecial.count != totalRecord)
        {
            startIndex+=10;
            
            if(self.isFromUnPublished)
            {
                [self webServiceForListUnPublishedSpecial:startIndex];
            }else{
            [self webServiceForListExpiredSpecial:startIndex];
            }
        }
    }
    else
    {
        [cellListExpiredSp.viewUnderline setHidden:NO];
    }
    
    return cellListExpiredSp;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMActiveSpecial *activeSpecial = (SMActiveSpecial *) [ arrayExpiredSpecial objectAtIndex:indexPath.row];
    
    CGFloat heightName = 0.0f;
    
    // activeSpecial.stractiveName = @"rrtrtrt serwerwe rwe rwer wer wer werwerwerw rew rwe rw er werwrewr" ;
    
    // activeSpecial.strType = @"rrtiopopo rtrt serwerwe rwe rwer wer wer werwerwerw rew rwe rw er werwrewr" ;
    
   // activeSpecial.stractiveName = @"Nissan GT-R Black Editionnnnnnnn";
    
    UILabel *lbl = [[UILabel alloc]init];
    
    [[SMAttributeStringFormatObject sharedService] setAttributedTextForVehicleDetailsWithFirstText:activeSpecial.strUsedYear andWithSecondText:activeSpecial.stractiveName forLabel:lbl];
    
    heightName = [self heightForTextForMessageSection:lbl.text andTextWidthForiPhone:self.view.frame.size.width - 131];
    
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails1 = 0.0f;
    
    
    heightDetails1 = [self heightForTextForMessageSection:activeSpecial.strType andTextWidthForiPhone:self.view.frame.size.width - 131];
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails2 = 0.0f;
    
    activeSpecial.strColor =  [activeSpecial.strColor length]== 0 ? @"Colour?" : activeSpecial.strColor;
    activeSpecial.strStockCode =  [activeSpecial.strStockCode length]== 0 ? @"stock code?" : activeSpecial.strStockCode;
    activeSpecial.strMileage =  [activeSpecial.strMileage length]== 0 ? @"Mileage?" : activeSpecial.strMileage;
    
    NSString *finalStr = [NSString stringWithFormat:@"%@ | %@ | %@",activeSpecial.strColor,activeSpecial.strStockCode,activeSpecial.strMileage ];
    
    heightDetails2 = [self heightForTextForMessageSection:finalStr andTextWidthForiPhone:self.view.frame.size.width - 131];
    
    
    
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? (heightName + heightDetails1 + heightDetails2 + 21 + 162+23) : 375.0f;
}

-(void) buttonEndDidPressed:(id) sender
{
    if(self.isFromUnPublished)
    {
        SMActiveSpecial *objectInCell = (SMActiveSpecial *) [arrayExpiredSpecial objectAtIndex:[sender tag]];
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
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            dispatch_async(dispatch_get_main_queue(), ^{
                UIBAlertView *alert;
                if (alert == nil)
                {
                    alert  = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:KSpecialDeltedPermission cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes",nil];
                }
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
                 {
                     if (didCancel)
                     {
                         return;
                     }
                     switch (selectedIndex)
                     {
                         case 0:
                             break;
                         case 1:
                         {
                             activeObjectOnButtonDetails = (SMActiveSpecial *)[arrayExpiredSpecial objectAtIndex:[sender tag]];
                             [self webServiceForDeleteSpecialwithSpecialID:activeObjectOnButtonDetails.strSpecialID.intValue withIsExpired:activeObjectOnButtonDetails.isExpired];
                             
                         }
                             break;
                         default:
                             break;
                     }
                 }];
                
                
                
            });
        });
    }
}
- (void)buttonEditDidPressed:(id)sender
{
    SMActiveSpecial *objectInCell = (SMActiveSpecial *) [arrayExpiredSpecial objectAtIndex:[sender tag]];
    if(self.isFromUnPublished)
    {
        if(objectInCell.canPublish)
        {
            [self webServiceForPublishSpecialwithSpecialID:objectInCell.strSpecialID.intValue];
        }
        else
        {
            UIBAlertView *alert;
            alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"To publish this special it needs to be reviewed by a user other than the creator" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 if (didCancel)
                 {
                     return ;
                 }
             }];
        }
    }
    else
    {
        
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
}

-(void) showAlrt:(NSString *)alertMeassge
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

-(NSString *) stringByStrippingHTML:(NSString *) htmlString {
    NSRange r;
    while ((r = [htmlString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        htmlString = [htmlString stringByReplacingCharactersInRange:r withString:@""];
    return htmlString;
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



@end
