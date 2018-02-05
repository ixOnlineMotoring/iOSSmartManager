//
//  SMSellDetailsViewController.m
//  SmartManager
//
//  Created by Ketan Nandha on 10/12/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMSellDetailsViewController.h"
#import "SMSellCollectionCell.h"
#import "SMSellTableViewCell.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMCommonClassMethods.h"
#import "SMConstants.h"
#import "UIImageView+WebCache.h"
#import "UIBAlertView.h"
#import "SMAddToStockViewController.h"
#import "SMPhotosAndExtrasObject.h"

@interface SMSellDetailsViewController ()

@end

@implementation SMSellDetailsViewController
@synthesize objectVehicleListing;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.btnAcceptBid          setExclusiveTouch:YES];
    [self.btnRejectBid          setExclusiveTouch:YES];
    [self.btnExtendBidding      setExclusiveTouch:YES];
    [self.btnEditVehiclesDetail setExclusiveTouch:YES];

    checkedIndexPath = nil;
    
    [self addingProgressHUD];
    
    [self.tblViewSellDetails setTableFooterView:[[UIView alloc]init]];

    [self registerNib];
    
    [self.lblVehicle        setText:objectVehicleListing.strStockCode];
    [self.lblStreetName     setText:objectVehicleListing.strOfferClient];
    [self.lblType           setText:[NSString stringWithFormat:@"Type: %@",objectVehicleListing.strVehicleType]];
    [self.lblEnded          setText:@""];

    [self.lblRetailPrice    setText:[NSString stringWithFormat:@"Retail: %@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:objectVehicleListing.strVehiclePrice]]];
    
    if ([objectVehicleListing.strOfferStart rangeOfString:@""].location !=NSNotFound)
    {
        [self.lblFullDate setText:objectVehicleListing.strOfferDate];
    }
    else
    {
        [self.lblFullDate setText:[NSString stringWithFormat:@"%@ to %@",objectVehicleListing.strOfferStart,objectVehicleListing.strOfferEnd]];
    }
    
    [self webServiceListBidsTrade:objectVehicleListing.strUsedVehicleStockID.intValue];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    [self webServiceLoadVehicle];
}

#pragma mark - registerNib

- (void)registerNib
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.collectionSellDetails registerNib:[UINib nibWithNibName:@"SMSellCollectionCell" bundle:nil]            forCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier"];
        
        [self.tblViewSellDetails registerNib:[UINib nibWithNibName:@"SMSellTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMSellTableViewCellIdentifier"];
    }
    else
    {
        [self.collectionSellDetails registerNib:[UINib nibWithNibName:@"SMSellCollectionCell_iPad" bundle:nil]            forCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier"];
        
        [self.tblViewSellDetails registerNib:[UINib nibWithNibName:@"SMSellTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMSellTableViewCellIdentifier"];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (arrayVehicleListing.count==0) ? 2 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [arrayVehicleListing count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            SMSellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMSellTableViewCellIdentifier" forIndexPath:indexPath];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            objectVehicleList = (SMVehiclelisting*)[arrayVehicleListing objectAtIndex:indexPath.row];
            
            [cell.btnRadio setSelected:([checkedIndexPath isEqual:indexPath])];
            
            [cell.lblVehiclePrice setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:objectVehicleList.strAmount]];
            [cell.lblVehicleName setText:objectVehicleList.strClientName];
//            [cell.lblVehicleRejected setText:@"Rejected"];
            [cell.lblVehicleDetail setText:objectVehicleList.strUser];
            [cell.lblVehicleDate setText:objectVehicleList.strBidDate];
            
            if (arrayVehicleListing.count-1==indexPath.row)
            {
                [cell.viewUnderline setHidden:YES];
            }
            else
            {
                [cell.viewUnderline setHidden:NO];
            }
            
            [cell setBackgroundColor:[UIColor blackColor]];
            
            return cell;
        }
            break;
    }
    return nil;
}

#pragma mark - UITableView Delegate

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (arrayVehicleListing.count==0)
    {
        switch (section)
        {
            case 0:
                return self.sectionHeaderExtendBidding;
                break;
                
            case 1:
                return self.sectionHeaderEditVehicles;
                break;
        }
    }
    else
    {
        switch (section)
        {
            case 0:
                return self.sectionHeaderBidReceived;
                break;
                
            case 1:
                return self.sectionHeaderRejectAcceptBid;
                break;
                
            case 2:
                return self.sectionHeaderExtendBidding;
                break;
                
            case 3:
                return self.sectionHeaderEditVehicles;
                break;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (arrayVehicleListing.count==0)
    {
        switch (section)
        {
            case 0:
                return self.sectionHeaderExtendBidding.frame.size.height;
                break;
                
            case 1:
                return self.sectionHeaderEditVehicles.frame.size.height;
                break;
        }
    }
    else
    {
        switch (section)
        {
            case 0:
                return self.sectionHeaderBidReceived.frame.size.height;
                break;
                
            case 1:
                return self.sectionHeaderRejectAcceptBid.frame.size.height;
                break;
                
            case 2:
                return self.sectionHeaderExtendBidding.frame.size.height;
                break;
                
            case 3:
                return self.sectionHeaderEditVehicles.frame.size.height;
                break;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        return 44;
    }
    else
    {
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            checkedIndexPath = indexPath;
            [tableView reloadData];
            break;
            
        default:
            break;
    }
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrayImages count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMSellCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier" forIndexPath:indexPath];
    
    [cell.imageVehicle setImageWithURL:[NSURL URLWithString:[arrayImages objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];

    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        networkGallery.startingIndex = indexPath.row;
        [self.navigationController pushViewController:networkGallery animated:YES];
    });
}

#pragma mark -

#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    if(gallery == networkGallery)
    {
        int num;

        num = (int)[arrayImages count];
        
        return num;
    }
    else
        return 0;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    if( gallery == networkGallery)
    {
        caption = [networkCaptions objectAtIndex:index];
    }
    return caption;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    return [arrayImages objectAtIndex:index];
}

#pragma mark - UIButton Methods

- (IBAction)btnAcceptBidDidClicked:(id)sender
{
    if (checkedIndexPath==nil)
    {
        SMAlert(KLoaderTitle,KAcceptBid);
    }
    else
    {
        objectVehicleList = (SMVehiclelisting*)[arrayVehicleListing objectAtIndex:checkedIndexPath.row];
        
        [self webServiceAcceptBidTrade:objectVehicleListing.strUsedVehicleStockID.intValue offerID:objectVehicleList.strOfferID.intValue];
    }
}
- (IBAction)btnRejectBidDidClicked:(id)sender
{
    if (checkedIndexPath==nil)
    {
       SMAlert(KLoaderTitle, KRejectBid);
    }
    else
    {
        objectVehicleList = (SMVehiclelisting*)[arrayVehicleListing objectAtIndex:checkedIndexPath.row];

        [self webServiceRejectBidTrade:objectVehicleListing.strUsedVehicleStockID.intValue offerID:objectVehicleList.strOfferID.intValue];
    }
}
- (IBAction)btnExtendBiddingDidClicked:(id)sender
{
    [self webServiceExtendBiddingTrade:objectVehicleListing.strUsedVehicleStockID.intValue];
}
- (IBAction)btnEditVehiclesDetailDidClicked:(id)sender
{
    SMAddToStockViewController *addToStockVC;
    
    addToStockVC = [[SMAddToStockViewController alloc]initWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)? @"SMAddToStockViewController" : @"SMAddToStockViewController_iPad" bundle:nil];
    
    SMPhotosAndExtrasObject *photosExtrasObj = [[SMPhotosAndExtrasObject alloc]init];
    photosExtrasObj.strUsedVehicleStockID = objectVehicleListing.strUsedVehicleStockID;
    photosExtrasObj.strColour = objectVehicleListing.strVehicleColor;
    photosExtrasObj.strMileage = objectVehicleListing.strVehicleMileage;
    photosExtrasObj.strStockCode = objectVehicleListing.strStockCode;
    photosExtrasObj.strUsedYear = objectVehicleListing.strVehicleYear;
    photosExtrasObj.strVehicleName = objectVehicleListing.strVehicleName;
    
    addToStockVC.photosExtrasObject = photosExtrasObj;
    addToStockVC.isUpdateVehicleInformation = YES;
    
    [SMGlobalClass sharedInstance].isListModule = YES;
    
    [self.navigationController pushViewController:addToStockVC animated:YES];
}

#pragma mark - WebService Method

- (void)webServiceListBidsTrade:(int)vehicleID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices listBidsWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleID:vehicleID];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             [self hideProgressHUD];

             SMAlert(@"Error", connectionError.localizedDescription);
         }
         else
         {
             arrayVehicleListing = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)webServiceAcceptBidTrade:(int)vehicleID offerID:(int)offerID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL = [SMWebServices acceptBidTradeUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleID:vehicleID withBidValue:offerID];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             [self hideProgressHUD];

             SMAlert(@"Error", connectionError.localizedDescription);
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

- (void)webServiceRejectBidTrade:(int)vehicleID offerID:(int)offerID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL = [SMWebServices rejectBidTradeUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleID:vehicleID withBidValue:offerID];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             [self hideProgressHUD];

             SMAlert(@"Error", connectionError.localizedDescription);
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

- (void)webServiceExtendBiddingTrade:(int)VehicleID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL = [SMWebServices extendBiddingUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleID:VehicleID];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             [self hideProgressHUD];

             SMAlert(@"Error", connectionError.localizedDescription);
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

-(void)webServiceLoadVehicle
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices gettingDetailsVehicleImages:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleId:objectVehicleListing.strUsedVehicleStockID.intValue];
    
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
             arrayImages = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
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
    if ([elementName isEqualToString:@"offer"])
    {
        objectVehicleList = [[SMVehiclelisting alloc]init];
        
        objectVehicleList.strOfferID = attributeDict[@"id"];
    }
    if ([elementName isEqualToString:@"AcceptBidResponse"])
    {
        checkFlag = acceptBidTrade;
    }
    if ([elementName isEqualToString:@"RejectBidResponse"])
    {
        checkFlag = rejectBidTrade;
    }
    if ([elementName isEqualToString:@"ExtendBiddingResponse"])
    {
        checkFlag = extendBidTrade;
    }

    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *string = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"clientID"])
    {
        objectVehicleList.intClientID = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"clientName"])
    {
        objectVehicleList.strClientName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"amount"])
    {
        objectVehicleList.strAmount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"user"])
    {
        objectVehicleList.strUser = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Date"])
    {
        objectVehicleList.strBidDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Age"])
    {
        [self.lblDays setText:[NSString stringWithFormat:@"%@ days",currentNodeContent]];
    }
    if ([elementName isEqualToString:@"offer"])
    {
        [arrayVehicleListing addObject:objectVehicleList];
    }
    if ([elementName isEqualToString:@"Full"])
    {
        [arrayImages addObject:currentNodeContent];
    }
    if ([elementName isEqualToString:@"Success"] || [elementName isEqualToString:@"Error"])
    {
        NSString *messgae = nil;
        
        if (checkFlag == acceptBidTrade)
        {
            messgae = currentNodeContent;
        }
        else if (checkFlag == rejectBidTrade)
        {
            messgae = currentNodeContent;
        }
        else if ( checkFlag == extendBidTrade)
        {
            messgae = currentNodeContent;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:@"Smart Manager" message:messgae cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 if (didCancel)
                 {
                     [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];

                     return;
                 }
             }];
        });
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideProgressHUD];
            [self.tblViewSellDetails reloadData];
            [self.collectionSellDetails reloadData];
        
            if (arrayImages.count==0)
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    [self.headerViewForLabel setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
                    [self.headerViewSellDetails setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
                }
                else
                {
                    [self.headerViewForLabel setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
                    [self.headerViewSellDetails setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
                }
            }
            else
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    [self.headerViewForLabel setFrame:CGRectMake(0, 70, self.view.bounds.size.width, 70)];
                    [self.headerViewSellDetails setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 140)];
                }
                else
                {
                    [self.headerViewForLabel setFrame:CGRectMake(0, 95, self.view.bounds.size.width, 100)];
                    [self.headerViewSellDetails setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 195)];
                }
            }
            
            [self.tblViewSellDetails setTableHeaderView:self.headerViewSellDetails];

            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        });
    });
}

#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
}

-(void) hideProgressHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUD hide:YES];
    });
}

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
