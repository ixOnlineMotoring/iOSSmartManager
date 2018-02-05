//
//  SMTraderPrivateOffersViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 28/10/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMTraderPrivateOffersViewController.h"
#import "SMTraderWinningBidCell.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMCommonClassMethods.h"
#import "SMMyBidsDetailViewController.h"
#import "SMTraderBuyViewController.h"
#import "UIBAlertView.h"
static int kPageSize=10;

typedef enum : NSUInteger
{
    WinningBidsVC = 0,
    losingBidsVC,
    AutoBidsVC
   
    
}viewControllerType;


@interface SMTraderPrivateOffersViewController ()

@end

@implementation SMTraderPrivateOffersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNib];
     [self addingProgressHUD];
    iWinning = 0;
    iLosing = 0;
    iAutoBid = 0;
    self.arrayLosingBid     = [[NSMutableArray alloc]init];
    self.arrayWinningBid    = [[NSMutableArray alloc]init];
    self.arrayAutoBid       = [[NSMutableArray alloc]init];
    tempDataArray           = [[NSMutableArray alloc]init];

    
    switch (self.viewControllerBidType)
    {
        case WinningBidsVC:
        {
            [self setTheTitleForScreenAs:@"Winning Bids"];
            [self webServiceForWinningBid];
        }
            break;
        case losingBidsVC:
        {
            [self setTheTitleForScreenAs:@"Losing Bids"];
            [self webServiceForLosingBid];
        }
            break;
        case AutoBidsVC:
        {
            [self setTheTitleForScreenAs:@"Automated Bidding"];
            [self webServiceForAutoBid];
        }
        break;
    }
    tblViewMyBids.tableFooterView = [[UIView alloc]init];
}

#pragma mark - UITableViewDataSource

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.viewControllerBidType)
    {
            
        case WinningBidsVC:
        {
            return self.arrayWinningBid.count;
        }
        break;
            
        case losingBidsVC:
        {
            return self.arrayLosingBid.count;
        }
        break;
        case AutoBidsVC:
        {
            return self.arrayAutoBid.count;
        }
        break;
            
        default:
            break;
    }
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"SMTraderWinningBidCell";
    
    SMTraderWinningBidCell *dynamicCell;
    
    switch (self.viewControllerBidType)
    {
            
        case WinningBidsVC:
            objectVehicleListing = [self.arrayWinningBid objectAtIndex:indexPath.row];
            break;
            
        case losingBidsVC:
            objectVehicleListing = [self.arrayLosingBid objectAtIndex:indexPath.row];
            break;
            
        case AutoBidsVC:
            objectVehicleListing = [self.arrayAutoBid objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    UILabel *vehicleName;
    UILabel *lblVehicleDetails1;
    UILabel *lblVehicleDetails2;
    UILabel *lblVehicleDetails3;
    UILabel *lblVehicleDetails4;
    UILabel *lblTempVehicleDetails3;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        lblTempVehicleDetails3 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 311, 21)];
    }
    else
    {
        lblTempVehicleDetails3 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 750, 25)];
        
    }
    
  //----------------------------------------------------------------------------------------
    
    CGFloat heightName = 0.0f;
    
    NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",objectVehicleListing.strVehicleYear,objectVehicleListing.strVehicleName];
    
    heightName = [self heightForText:strVehicleNameHeight];
    
   //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails1 = 0.0f;
    
    NSString *strVehicleDetails1 = [NSString stringWithFormat:@"%@ | %@ | %@",objectVehicleListing.strVehicleRegNo,objectVehicleListing.strVehicleColor, objectVehicleListing.strStockCode];
    
    heightDetails1 = [self heightForText:strVehicleDetails1];
   //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails2 = 0.0f;
    
    NSString *strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@",objectVehicleListing.strVehicleType,objectVehicleListing.strVehicleMileage];
    
    heightDetails2 = [self heightForText:strVehicleDetails2];
 
    
    if (dynamicCell == nil)
    {
        dynamicCell = [[SMTraderWinningBidCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        vehicleName = [[UILabel alloc]init];
        lblVehicleDetails1 = [[UILabel alloc]init];
        lblVehicleDetails2 = [[UILabel alloc]init];
        lblVehicleDetails3 = [[UILabel alloc]init];
        lblVehicleDetails4 = [[UILabel alloc]init];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            
            vehicleName.frame = CGRectMake(6.0, 6.0, 311.0, heightName);
            lblVehicleDetails1.frame = CGRectMake(6.0, vehicleName.frame.origin.y + vehicleName.frame.size.height+4.0, 311.0, heightDetails1);
            lblVehicleDetails2.frame = CGRectMake(6.0, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+4.0, 311.0, heightDetails2);
            lblVehicleDetails3.frame = CGRectMake(6.0, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+4.0, 320.0, 21);
            lblVehicleDetails4.frame = CGRectMake(6.0, lblVehicleDetails3.frame.origin.y + lblVehicleDetails3.frame.size.height+4.0, 311.0, 21);
            
            vehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            lblVehicleDetails3.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
            //lblVehicleDetails3.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            
            
            
            
        }
        else
        {
            vehicleName.frame = CGRectMake(8.0, 8.0, 677.0, heightName);
            lblVehicleDetails1.frame = CGRectMake(8.0, vehicleName.frame.origin.y + vehicleName.frame.size.height+4.0, 677.0, heightDetails1);
            lblVehicleDetails2.frame = CGRectMake(8.0, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+4.0, 677.0, heightDetails2);
            lblVehicleDetails3.frame = CGRectMake(8.0, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+4.0, 677.0, 25);
             lblVehicleDetails4.frame = CGRectMake(6.0, lblVehicleDetails3.frame.origin.y + lblVehicleDetails3.frame.size.height+4.0, 677.0, 25);
            
            vehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            lblVehicleDetails3.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            
        }
        
        vehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
        lblVehicleDetails1.textColor = [UIColor whiteColor];
        lblVehicleDetails2.textColor = [UIColor whiteColor];
        lblVehicleDetails3.textColor = [UIColor whiteColor];
        lblVehicleDetails4.textColor = [UIColor whiteColor];
        
        
        vehicleName.tag = 101;
        lblVehicleDetails1.tag = 103;
        lblVehicleDetails2.tag = 104;
        lblVehicleDetails3.tag = 105;
        
        [self setAttributedTextForVehicleDetailsWithFirstText:objectVehicleListing.strVehicleYear andWithSecondText:objectVehicleListing.strVehicleName forLabel:vehicleName];
        
        lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",objectVehicleListing.strVehicleRegNo,objectVehicleListing.strVehicleColor, objectVehicleListing.strStockCode];
        
         lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@",objectVehicleListing.strVehicleType,objectVehicleListing.strVehicleMileage];
       
        NSString *status;
        UIColor *statusColor;
        switch (self.viewControllerBidType)
        {
                
            case WinningBidsVC:
            {
                status = @"Winning";
                statusColor = [UIColor greenColor];
                [self setAttributedTextForVehicleDetailsWithFirstText:@"Winning Bid" andWithSecondText:[NSString stringWithFormat:@"%@",objectVehicleListing.strWinningBid] andWithThirdText:@"My Bid" andWithFourthText:[NSString stringWithFormat:@"%@",objectVehicleListing.strMyBid] andWithStatusText:status withStatusColor:statusColor forLabel:lblVehicleDetails3];

            }
                break;
                
            case losingBidsVC:
            {
                status = @"Beaten";
                statusColor = [UIColor redColor];
                [self setAttributedTextForVehicleDetailsWithFirstText:@"Winning Bid" andWithSecondText:[NSString stringWithFormat:@"%@",objectVehicleListing.strWinningBid] andWithThirdText:@"My Bid" andWithFourthText:[NSString stringWithFormat:@"%@",objectVehicleListing.strMyBid] andWithStatusText:status withStatusColor:statusColor forLabel:lblVehicleDetails3];

            }
                break;
                
            case AutoBidsVC:
            {
                  [self setAttributedTextForAutoBiddingTextWithFirstText:@"Current." andWithSecondText:objectVehicleListing.priceCurrent andWithThirdText:@" | " andWithFourthText:@"Cap." andWithFifthText:objectVehicleListing.priceCap andWithSixthText:@" | " andWithSeventhText:@"Incr." andWithEigthText:objectVehicleListing.priceIncrement forLabel:lblVehicleDetails3];
                
                lblVehicleDetails4.text = [NSString stringWithFormat:@"Initiated by: %@",objectVehicleListing.strClientName];
                [dynamicCell.contentView addSubview:lblVehicleDetails4];
            }
                break;
                
            default:
                break;
        }
        
        
        
      

        
        [dynamicCell.contentView addSubview:vehicleName];
        [dynamicCell.contentView addSubview:lblVehicleDetails1];
        [dynamicCell.contentView addSubview:lblVehicleDetails2];
        [dynamicCell.contentView addSubview:lblVehicleDetails3];
        
        
    }
    
    
    vehicleName.numberOfLines = 0;
    [vehicleName sizeToFit];
    
    lblVehicleDetails1.numberOfLines = 0;
    [lblVehicleDetails1 sizeToFit];
    
    
    lblVehicleDetails2.numberOfLines = 0;
    [lblVehicleDetails2 sizeToFit];
    
    lblVehicleDetails3.numberOfLines = 0;
    [lblVehicleDetails3 sizeToFit];
    
    
    vehicleName.backgroundColor = [UIColor blackColor];
    lblVehicleDetails1.backgroundColor = [UIColor blackColor];
    lblVehicleDetails2.backgroundColor = [UIColor blackColor];
    lblVehicleDetails3.backgroundColor = [UIColor blackColor];
    
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        dynamicCell.layoutMargins = UIEdgeInsetsZero;
        dynamicCell.preservesSuperviewLayoutMargins = NO;
    }
    dynamicCell.backgroundColor = [UIColor blackColor];
    
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
      
    switch (self.viewControllerBidType)
    {
            
        case WinningBidsVC:
        {
            if (self.arrayWinningBid.count-1 == indexPath.row)
            {
                
                if (self.arrayWinningBid.count !=iTotalWinning)
                {
                    ++iWinning;
                    [self webServiceForWinningBid];
                    
                }
            }

        }
        break;
            
        case losingBidsVC:
        {
            if (self.arrayLosingBid.count-1 == indexPath.row)
            {
                
                if (self.arrayLosingBid.count !=iTotalLosing)
                {
                    ++iLosing;
                    [self webServiceForLosingBid];
                    
                }
            }
        }
        break;
            
        case AutoBidsVC:
        {
            if (self.arrayAutoBid.count-1 == indexPath.row)
            {
                
                if (self.arrayAutoBid.count !=iTotalAutoBid)
                {
                    ++iAutoBid;
                    [self webServiceForAutoBid];
                    
                }
            }
        }
        break;
            
        default:
            break;
    }

    
    return dynamicCell;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    {
        
        CGFloat finalDynamicHeight = 0.0f;
        
        switch (self.viewControllerBidType)
        {
                
            case WinningBidsVC:
                objectVehicleListing = [self.arrayWinningBid objectAtIndex:indexPath.row];
                break;
                
            case losingBidsVC:
                objectVehicleListing = [self.arrayLosingBid objectAtIndex:indexPath.row];
                break;
                
            case AutoBidsVC:
                objectVehicleListing = [self.arrayAutoBid objectAtIndex:indexPath.row];
                break;
                
            default:
                break;
        }
        
        
        //----------------------------------------------------------------------------------------
        
        CGFloat heightName = 0.0f;
        
        NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",objectVehicleListing.strVehicleYear,objectVehicleListing.strVehicleName];
        
        heightName = [self heightForText:strVehicleNameHeight];
        
        //----------------------------------------------------------------------------------------
        
        CGFloat heightDetails1 = 0.0f;
        
        NSString *strVehicleDetails1 = [NSString stringWithFormat:@"%@ | %@ | %@",objectVehicleListing.strVehicleRegNo,objectVehicleListing.strVehicleColor, objectVehicleListing.strStockCode];
        
        heightDetails1 = [self heightForText:strVehicleDetails1];
        //----------------------------------------------------------------------------------------
        
        CGFloat heightDetails2 = 0.0f;
        
        NSString *strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@",objectVehicleListing.strVehicleType,objectVehicleListing.strVehicleMileage];
        
        heightDetails2 = [self heightForText:strVehicleDetails2];
        //----------------------------------------------------------------------------------------
        
        switch (self.viewControllerBidType)
        {
                
            case WinningBidsVC:
            case losingBidsVC:
                finalDynamicHeight = (heightName + heightDetails1 + heightDetails2 + 21+15.0);
                break;
                
            case AutoBidsVC:
                 finalDynamicHeight = (heightName + heightDetails1 + heightDetails2 + 21+21+15.0);
                break;
                
            default:
                break;
        }

       
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        return finalDynamicHeight+8;
        else
           return finalDynamicHeight+18;
        
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
            __block SMTraderBuyViewController *myBidsDetailVC;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                myBidsDetailVC = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
                
                [[SMTraderBuyViewController alloc]initWithNibName:@"SMTraderBuyViewController" bundle:nil] :
                [[SMTraderBuyViewController alloc]initWithNibName:@"SMTraderBuyViewController_iPad" bundle:nil];
                SMVehiclelisting *objectVehicleListingInDidCell;
                myBidsDetailVC.isLabelMinBidHide = YES;

                
                switch (self.viewControllerBidType)
                {
                        
                    case WinningBidsVC:
                    {
                        objectVehicleListingInDidCell = (SMVehiclelisting *) [self.arrayWinningBid objectAtIndex:indexPath.row];
                    }
                        break;
                        
                    case losingBidsVC:
                    {
                        objectVehicleListingInDidCell = (SMVehiclelisting *) [self.arrayLosingBid objectAtIndex:indexPath.row];
                    }
                        break;
                        
                    case AutoBidsVC:
                    {
                        objectVehicleListingInDidCell = (SMVehiclelisting *) [self.arrayAutoBid objectAtIndex:indexPath.row];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                myBidsDetailVC.vehicleObj = objectVehicleListingInDidCell;
                
                myBidsDetailVC.strSelectedVehicleId = objectVehicleListingInDidCell.strUsedVehicleStockID;
                
                [self.navigationController pushViewController:myBidsDetailVC animated:YES];
            });
    

}

#pragma mark - WEb Services

-(void)webServiceForLosingBid
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    
    NSMutableURLRequest *requestURL = [SMWebServices losingBidsPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withPage:iLosing withPageSize:kPageSize];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
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

-(void)webServiceForWinningBid
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    
    NSMutableURLRequest *requestURL = [SMWebServices winningBidsPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue  withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withPage:iWinning withPageSize:kPageSize];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
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
-(void)webServiceForAutoBid
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    
    NSMutableURLRequest *requestURL = [SMWebServices AutomatedBidsPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withPage:iAutoBid withPageSize:kPageSize];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
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

#pragma mark - NSXMLParser Delegate Methods

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    if ([elementName isEqualToString:@"TradeOffer"])
    {
        objectVehicleListing  = [[SMVehiclelisting alloc] init];
    }
        
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"UsedVehicleStockID"])
    {
        objectVehicleListing.strUsedVehicleStockID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Department"])
    {
        objectVehicleListing.strVehicleType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"UsedYear"])
    {
        objectVehicleListing.strVehicleYear = currentNodeContent;
    }
    if ([elementName isEqualToString:@"FriendlyName"])
    {
        objectVehicleListing.strVehicleName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ClientName"])
    {
        objectVehicleListing.strClientName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        objectVehicleListing.strVehicleColor = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
       // objectVehicleListing.strVehicleMileage = [NSString stringWithFormat:@"%@ Km",currentNodeContent];
        
        if ([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"0"])
        {
            objectVehicleListing.strVehicleMileage = @"Mileage?";
        }
        else
        {
            objectVehicleListing.strVehicleMileage= [NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager]mileageConvertEn_AF:currentNodeContent]];
        }

        
    }
    if ([elementName isEqualToString:@"Price"])
    {
        //objectVehicleListing.strVehiclePrice = currentNodeContent;
        objectVehicleListing.strVehiclePrice = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"Location"])
    {
        objectVehicleListing.strLocation = currentNodeContent;
    }
    if ([elementName isEqualToString:@"StockCode"])
    {
        objectVehicleListing.strStockCode = currentNodeContent;
    }
    if ([elementName isEqualToString:@"HeighestBid"])
    {
        //objectVehicleListing.strWinningBid = currentNodeContent.intValue;
         objectVehicleListing.strWinningBid = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        
        objectVehicleListing.priceCurrent = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        objectVehicleListing.strTotalHighest = objectVehicleListing.strWinningBid;
    }
    if ([elementName isEqualToString:@"Cap"])
    {
       objectVehicleListing.priceCap = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"Increment"])
    {
        objectVehicleListing.priceIncrement = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    
    if ([elementName isEqualToString:@"OfferStatus"])
    {
        objectVehicleListing.strOfferStatus = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Source"])
    {
        objectVehicleListing.strSource = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MyHeighestBid"])
    {
        //objectVehicleListing.strMyBid = currentNodeContent.intValue;
        objectVehicleListing.strMyBid = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        objectVehicleListing.strMyHighest = objectVehicleListing.strMyBid;
    }
    if ([elementName isEqualToString:@"SoldDate"])
    {
        objectVehicleListing.strSoldDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"OfferID"])
    {
        objectVehicleListing.strOfferID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Registration"])
    {
        if([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"(null)"])
            objectVehicleListing.strVehicleRegNo = @"Reg?";
        else
            objectVehicleListing.strVehicleRegNo = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TradeOffer"])
    {
        if([objectVehicleListing.strVehicleRegNo length] == 0)
            objectVehicleListing.strVehicleRegNo = @"Reg?";
        [tempDataArray addObject:objectVehicleListing];
    }
    if ([elementName isEqualToString:@"Total"])
    {
        totalRecordCount = [currentNodeContent intValue];
    }
    
    if ([elementName isEqualToString:@"LosingBidsPagedResult"])
    {
        iTotalLosing = totalRecordCount;
        [self.arrayLosingBid addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    
    if ([elementName isEqualToString:@"WinningBidsPagedResult"])
    {
        iTotalWinning = totalRecordCount;
        [self.arrayWinningBid addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    if ([elementName isEqualToString:@"AutoBidsPagedResult"])
    {
        iTotalAutoBid = totalRecordCount;
        [self.arrayAutoBid addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
    switch (self.viewControllerBidType)
    {
            
        case WinningBidsVC:
        {
            if(self.arrayWinningBid.count == 0)
            {
                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:KNorecordsFousnt cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                    if (didCancel)
                    {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        return;
                        
                    }
                    
                }];
            }
        }
            break;
            
        case losingBidsVC:
        {
            if(self.arrayLosingBid.count == 0)
            {
                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:KNorecordsFousnt cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                    if (didCancel)
                    {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        return;
                        
                    }
                    
                }];
            }
        }
            break;
        case AutoBidsVC:
        {
            if(self.arrayAutoBid.count == 0)
            {
                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:KNorecordsFousnt cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                    if (didCancel)
                    {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        return;
                        
                    }
                    
                }];
            }
        }
            break;
            
        default:
            break;
    }

    
    [tblViewMyBids reloadData];
    [self hideProgressHUD];
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
- (void)setTheTitleForScreenAs:(NSString*)titleOfScreen
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
    listActiveSpecialsNavigTitle.text = titleOfScreen;
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
    
    
}

- (void)registerNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [tblViewMyBids registerNib:[UINib nibWithNibName:@"SMTraderWinningBidCell" bundle:nil] forCellReuseIdentifier:@"SMTraderWinningBidCell"];
        
    }
    else
    {
        [tblViewMyBids registerNib:[UINib nibWithNibName:@"SMStockListCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMStockListCell"];
        
    }
}

- (CGFloat)heightForText:(NSString *)bodyText
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
        textSize = 311;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        textSize = 677;
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


-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText andWithStatusText:(NSString*)statusText withStatusColor:(UIColor*)statusColor forLabel:(UILabel*)label
{
    NSLog(@"price1 = %@",secondText);
     NSLog(@"price2 = %@",fourthText);
    
    UIFont *valueFont;
    UIFont *titleFont;
    UIFont *statusFont;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:10.0];
        
        if([statusText isEqualToString:@"Withdrawn"]|| [statusText isEqualToString:@"Cancelled"])
            statusFont = [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
        else
            statusFont = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    }
    
    else
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:16.0];
        
        statusFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorViolet = [UIColor colorWithRed:135.0/255.0 green:67.0/255.0 blue:198.0/255.0 alpha:1.0];
    UIColor *foregroundColorYellow = [UIColor colorWithRed:187.0/255.0 green:140.0/255.0 blue:20.0/255.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorYellow, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FourthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorViolet, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FifthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    statusFont, NSFontAttributeName,
                                    statusColor, NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@:",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    NSMutableAttributedString *attributedFourthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",fourthText]
                                                                                             attributes:FourthAttribute];
    
    NSMutableAttributedString *attributedFifthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",statusText]
                                                                                            attributes:FifthAttribute];
    
    
    
    [attributedFourthText appendAttributedString:attributedFifthText];
    [attributedThirdText appendAttributedString:attributedFourthText];
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

-(void)setAttributedTextForAutoBiddingTextWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText andWithFifthText:(NSString*)fifthText andWithSixthText:(NSString*)sixthText andWithSeventhText:(NSString*)seventhText andWithEigthText:(NSString*)eigthText forLabel:(UILabel*)label
{
    NSLog(@"price1 = %@",secondText);
    NSLog(@"price2 = %@",fourthText);
    
    UIFont *valueFont;
    UIFont *titleFont;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:10.0];
        
    }
    
    else
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:16.0];
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorViolet = [UIColor colorWithRed:135.0/255.0 green:67.0/255.0 blue:198.0/255.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorViolet, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FourthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     titleFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FifthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorViolet, NSForegroundColorAttributeName, nil];
    
    NSDictionary *SixthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *SeventhAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *EigthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorViolet, NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    NSMutableAttributedString *attributedFourthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",fourthText]
                                                                                             attributes:FourthAttribute];
    
    NSMutableAttributedString *attributedFifthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",fifthText]
                                                                                            attributes:FifthAttribute];
    
    NSMutableAttributedString *attributedSixthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",sixthText]
                                                                                            attributes:SixthAttribute];
    
    NSMutableAttributedString *attributedSeventhText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",seventhText]
                                                                                            attributes:SeventhAttribute];
    
    NSMutableAttributedString *attributedEigthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",eigthText]
                                                                                            attributes:EigthAttribute];
    
    
    
    
    
    [attributedSeventhText appendAttributedString:attributedEigthText];
    [attributedSixthText appendAttributedString:attributedSeventhText];
    [attributedFifthText appendAttributedString:attributedSixthText];
    [attributedFourthText appendAttributedString:attributedFifthText];
     [attributedThirdText appendAttributedString:attributedFourthText];
     [attributedSecondText appendAttributedString:attributedThirdText];
     [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
