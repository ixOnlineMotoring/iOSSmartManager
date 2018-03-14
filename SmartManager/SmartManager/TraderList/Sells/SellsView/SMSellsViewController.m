//
//  SMSellsViewController.m
//  SmartManager
//
//  Created by Ketan Nandha on 10/12/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMSellsViewController.h"
#import "SMSellDetailsViewController.h"
#import "SMSellCustomCell.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMSellListDetailsViewController.h"
#import "SMCustomColor.h"
#import "UIImageView+WebCache.h"
#import "SMCommonClassMethods.h"
#import "SMConstants.h"

static int kPageSize=10;

@interface SMSellsViewController ()

@end

@implementation SMSellsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    previousIndex = -1;
    currentIndex = 0;
    
    self.arrayBidEnded             = [[NSMutableArray alloc]init];
    self.arrayBidReceived          = [[NSMutableArray alloc]init];
    self.arrayAvailbaleTrader      = [[NSMutableArray alloc]init];
    self.arrayNotAvailbaleTrader   = [[NSMutableArray alloc]init];
    tempDataArray                  = [[NSMutableArray alloc]init];
    
    // used for setting Navigation Title
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Sell"];
    
    arrayForSections = [[NSMutableArray alloc]init];

    [self populateTheSectionsArray];
    
    [self.tblViewSells setBackgroundColor:[UIColor clearColor]];

    [self registerNib];
    
    iActiveBids = 0;
    iBidEnded = 0;
    iAvailable = 0;
    iNotAvailable = 0;
    
    [self webServiceGetSellCount];
    
    [self webServiceTradePeriodEnded];
    [self webServiceListActiveBids];
    [self webServiceAvailableToTrade];
    [self webServiceNotAvailableToTrade];
}

#pragma mark - registerNib

- (void)registerNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tblViewSells registerNib:[UINib nibWithNibName:@"SMSellCustomCell" bundle:nil] forCellReuseIdentifier:@"SMSellCustomCellIdentifier"];
    }
    else
    {
        [self.tblViewSells registerNib:[UINib nibWithNibName:@"SMSellCustomCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMSellCustomCellIdentifier"];
    }
}

#pragma mark - populateTheSectionsArray

- (void)populateTheSectionsArray
{
    NSArray *arrayOfSectionNames = [[NSArray alloc]initWithObjects:@"Action: Bidding Ended",@"Active Bids Received",@"Available To Trader",@"Not Available To Trader", nil];
    
    for(int i=0;i<[arrayOfSectionNames count];i++)
    {
        sectionObject = [[SMClassForToDoObjects alloc]init];
        sectionObject.strSectionName = [arrayOfSectionNames objectAtIndex:i];
        [arrayForSections addObject:sectionObject];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [arrayForSections count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return ((SMClassForToDoObjects*)[arrayForSections objectAtIndex:section]).strSectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (((SMClassForToDoObjects*)[arrayForSections objectAtIndex:section]).isExpanded)
    {
        switch (section) {
                
            case 0:
                return self.arrayBidEnded.count;
                break;
                
            case 1:
                return self.arrayBidReceived.count;
                break;
                
            case 2:
                return self.arrayAvailbaleTrader.count;
                break;
                
            case 3:
                return self.arrayNotAvailbaleTrader.count;
                break;
                
            default:
                break;
        }
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSellCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMSellCustomCellIdentifier"];
    
    switch (indexPath.section)
    {
        case 0:
            objectVehicleListing = [self.arrayBidEnded objectAtIndex:indexPath.row];
            break;
            
        case 1:
            objectVehicleListing = [self.arrayBidReceived objectAtIndex:indexPath.row];
            break;
            
        case 2:
            objectVehicleListing = [self.arrayAvailbaleTrader objectAtIndex:indexPath.row];
            break;
            
        case 3:
            objectVehicleListing = [self.arrayNotAvailbaleTrader objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    cell.lblVehicleName.text = [NSString stringWithFormat:@"%@ %@",objectVehicleListing.strVehicleYear, objectVehicleListing.strVehicleName];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cell.lblVehicleName.text];
    NSRange fullRange = NSMakeRange(0, 4);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:fullRange];
    [cell.lblVehicleName setAttributedText:string];
    
    [cell.lblVehicleAmount setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:objectVehicleListing.strVehiclePrice]];
    
    cell.lblVehicleMileage.text   = [NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:objectVehicleListing.strVehicleMileage]];
    cell.lblVehicleColour.text    = objectVehicleListing.strVehicleColor;
    cell.lblVehicleLocation.text  = objectVehicleListing.strLocation;
    cell.lblVehicleTime.text      = objectVehicleListing.strBiddingClosed;
    
    cell.backgroundColor = [UIColor blackColor];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    switch (indexPath.section)
    {
        case 0:
            if (self.arrayBidEnded.count-1 == indexPath.row)
            {
                [cell.lblUnderline setHidden:YES];
                if (self.arrayBidEnded.count != iTotalBidEnded)
                {
                    iBidEnded++;
                    [self webServiceTradePeriodEnded];
                }
            }
            else
            {
                [cell.lblUnderline setHidden:NO];
            }
            break;
            
        case 1:
            if (self.arrayBidReceived.count-1 == indexPath.row)
            {
                [cell.lblUnderline setHidden:YES];
                if (self.arrayBidReceived.count != iTotalActiveBids)
                {
                    iActiveBids++;
                    [self webServiceListActiveBids];
                }
            }
            else
            {
                [cell.lblUnderline setHidden:NO];
            }
            break;
            
        case 2:
            if (self.arrayAvailbaleTrader.count-1 == indexPath.row)
            {
                [cell.lblUnderline setHidden:YES];
                if (self.arrayAvailbaleTrader.count != iTotalAvailable)
                {
                    iAvailable++;
                    [self webServiceAvailableToTrade];
                }
            }
            else
            {
                [cell.lblUnderline setHidden:NO];
            }
            break;
            
        case 3:
            if (self.arrayNotAvailbaleTrader.count-1 == indexPath.row)
            {
                [cell.lblUnderline setHidden:YES];
                if (self.arrayNotAvailbaleTrader.count != iTotalNotAvailable)
                {
                    iNotAvailable++;
                    [self webServiceNotAvailableToTrade];
                }
            }
            else
            {
                [cell.lblUnderline setHidden:NO];
            }
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *headerColorView = [[UIView alloc] init];
    UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
    [sectionLabelBtn setExclusiveTouch:YES];

    imageViewArrowForsection = [[UIImageView alloc]init];
    imageViewArrowForsection.contentMode = UIViewContentModeScaleAspectFit;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
        [headerColorView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 38)];
        sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,40);
        sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
        [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-25,10,20,20)];
    }
    else
    {
        [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
        [headerColorView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 56)];
        sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,60);
        sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-25,20,20,20)];
    }
    if(((SMClassForToDoObjects*)[arrayForSections objectAtIndex:section]).isExpanded)
    {
        [UIView animateWithDuration:2 animations:^
        {
             switch (section)
             {
                 case 0:
                     if (self.arrayBidEnded.count>0)
                     {
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                     }
                     break;
                     
                 case 1:
                     if (self.arrayBidReceived.count>0)
                     {
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                     }
                     break;
                     
                 case 2:
                     if (self.arrayAvailbaleTrader.count>0)
                     {
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                     }
                     break;
                     
                 case 3:
                     if (self.arrayNotAvailbaleTrader.count>0)
                     {
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                     }
                     break;
             }
        }
        completion:nil];
    }
    UIImage *image = [UIImage imageNamed:@"side_Arrow.png"];
    [imageViewArrowForsection setImage:image];
    
    countLbl = [[UILabel alloc]initWithFrame:CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-45,8, 20, 20)];
    
    countLbl.textColor = [UIColor whiteColor];
    countLbl.textAlignment = NSTextAlignmentCenter;
    countLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    countLbl.layer.borderWidth = 1.0;
    countLbl.clipsToBounds = YES;
    countLbl.font = [UIFont fontWithName:FONT_NAME size:15.0f];
    
    countLbl.layer.cornerRadius = countLbl.frame.size.width/2;

    if (self.arrayGetCount.count>0)
    {
        objCustomSell = [self.arrayGetCount objectAtIndex:0];
        
        switch (section)
        {
            case 0:
                [self setTheLabelCountText:objCustomSell.biddingEnded];
                break;
                
            case 1:
                [self setTheLabelCountText:objCustomSell.activeBid];
                break;

            case 2:
                [self setTheLabelCountText:objCustomSell.availableToTrade];
                break;

            case 3:
                [self setTheLabelCountText:objCustomSell.notAvailableToTrade];
                break;
        }
    }
    else
    {
        [self setTheLabelCountText:0];
    }
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width,9, countLbl.frame.size.width, 20);
    }
    else
    {
        countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width,20, countLbl.frame.size.width, 20);
    }
    
    [headerColorView addSubview:countLbl];
    [headerColorView addSubview:imageViewArrowForsection];
    
    if([((SMClassForToDoObjects*)[arrayForSections objectAtIndex:section]).strSectionName isEqualToString:@"Action: Bidding Ended"])
    {
        headerColorView.backgroundColor = [UIColor colorWithRed:52.0/255 green:118.0/255 blue:190.0/255 alpha:1.0];
    }
    else
    {
        headerColorView.backgroundColor = [UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
    }
    
    [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sectionLabelBtn addTarget:self action:@selector(btnSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sectionLabelBtn setTag:section];
    sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [sectionLabelBtn setTitle: ((SMClassForToDoObjects*)[arrayForSections objectAtIndex:section]).strSectionName forState:UIControlStateNormal];
    
    [headerColorView addSubview:sectionLabelBtn];
    [headerView addSubview:headerColorView];
    headerView.clipsToBounds = YES;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 40.0f : 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 92.0f : 115.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            objectVehicleListing = self.arrayBidEnded[indexPath.row];
            break;
            
        case 1:
            objectVehicleListing = self.arrayBidReceived[indexPath.row];
            break;
            
        case 2:
            objectVehicleListing = self.arrayAvailbaleTrader[indexPath.row];
            break;
            
        case 3:
            objectVehicleListing = self.arrayNotAvailbaleTrader[indexPath.row];
            break;
    }
    
    if (indexPath.section==0 || indexPath.section==1)
    {
        __block SMSellDetailsViewController *sellDetailVC;
        
        dispatch_async(dispatch_get_main_queue(), ^{

            sellDetailVC = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
        
            [[SMSellDetailsViewController alloc]initWithNibName:@"SMSellDetailsViewController" bundle:nil] :
            [[SMSellDetailsViewController alloc]initWithNibName:@"SMSellDetailsViewController_iPad" bundle:nil];
            
            sellDetailVC.navigationItem.titleView = [SMCustomColor setTitle:(indexPath.section == 0) ? @"Action: Bidding Ended" : @"Active Bids Received"];

            sellDetailVC.objectVehicleListing = objectVehicleListing;
            
            [self.navigationController pushViewController:sellDetailVC animated:YES];
        });
    }
    else
    {
        __block SMSellListDetailsViewController *sellListVC;
        
        dispatch_async(dispatch_get_main_queue(), ^{

            sellListVC = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
        
            [[SMSellListDetailsViewController alloc]initWithNibName:@"SMSellListDetailsViewController" bundle:nil] :
       
            [[SMSellListDetailsViewController alloc]initWithNibName:@"SMSellListDetailsViewController_iPad" bundle:nil];
       
            sellListVC.objectVehicleListing = objectVehicleListing;
            
            [self.navigationController pushViewController:sellListVC animated:YES];
        });
    }
}

#pragma mark - btnSectionTitleDidClicked

- (void)btnSectionTitleDidClicked:(id)sender
{
    currentIndex = [sender tag];
    
    if (currentIndex==previousIndex)
    {
        sectionObject = [arrayForSections objectAtIndex:currentIndex];
        sectionObject.isExpanded = !sectionObject.isExpanded;
    }
    else
    {
        if (previousIndex>-1)
        {
            sectionObject = [arrayForSections objectAtIndex:previousIndex];
            
            if (sectionObject.isExpanded)
            {
                sectionObject.isExpanded = !sectionObject.isExpanded;
            }
        }

        sectionObject = [arrayForSections objectAtIndex:currentIndex];
        sectionObject.isExpanded = !sectionObject.isExpanded;
        
        previousIndex = currentIndex;
    }
    
    if (self.arrayGetCount.count>0)
    {
        objCustomSell = [self.arrayGetCount objectAtIndex:0];

        switch (currentIndex)
        {
            case 0:
                iBidEnded = 0;
                /*
                if (sectionObject.isExpanded)
                {
                    if (objCustomSell.biddingEnded>0 && self.arrayBidEnded.count==0)
                    {
                        [self.arrayBidEnded removeAllObjects];
                        [self webServiceTradePeriodEnded];
                    }
                    else
                        nil;
                }
                else
                    nil;
                */
                break;
                
            case 1:
                iActiveBids = 0;
                /*
                if (sectionObject.isExpanded)
                {
                    if (objCustomSell.activeBid>0 && self.arrayBidReceived.count==0)
                    {
                        [self.arrayBidReceived removeAllObjects];
                        [self webServiceListActiveBids];
                    }
                    else
                        nil;
                }
                else
                    nil;
                */
                break;
                
            case 2:
                iAvailable = 0;
                /*
                if (sectionObject.isExpanded)
                {
                    if (objCustomSell.availableToTrade>0 && self.arrayAvailbaleTrader.count==0)
                    {
                        [self.arrayAvailbaleTrader removeAllObjects];
                        [self webServiceAvailableToTrade];
                    }
                    else
                        nil;
                }
                else
                    nil;
                */
                break;
                
            case 3:
                iNotAvailable = 0;
                /*
                if (sectionObject.isExpanded)
                {
                    if (objCustomSell.notAvailableToTrade>0 && self.arrayNotAvailbaleTrader.count==0)
                    {
                        [self.arrayNotAvailbaleTrader removeAllObjects];
                        [self webServiceNotAvailableToTrade];
                    }
                    else
                        nil;
                }
                else
                    nil;
                */
                break;
                
            default:
                break;
        }
        
        [self.tblViewSells reloadData];
    }
}

#pragma mark - setTheLabelCountText

- (void)setTheLabelCountText:(int)lblCount
{
    if (lblCount<=0)
    {
        [countLbl setText:@"0"];
    }
    else
    {
        [countLbl setText:[NSString stringWithFormat:@"%d",lblCount]];
        
    }
    [countLbl sizeToFit];
    
    float widthWithPadding = countLbl.frame.size.width + 10.0;
    
    [countLbl setFrame:CGRectMake(countLbl.frame.origin.x, countLbl.frame.origin.y, widthWithPadding, countLbl.frame.size.height)];
}

#pragma mark - WebService For Getting Sells Count

- (void)webServiceGetSellCount
{
    NSMutableURLRequest *requestURL = [SMWebServices getCountsWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
    
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
             self.arrayGetCount = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

#pragma mark - WebService For Getting TradePeriodEnded Data

- (void)webServiceTradePeriodEnded
{
    NSMutableURLRequest *requestURL = [SMWebServices tradePeriodEndedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withPage:iBidEnded withPageSize:kPageSize];
    
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

#pragma mark - WebService For Getting ListActiveBids Data

- (void)webServiceListActiveBids
{
    NSMutableURLRequest *requestURL = [SMWebServices listActiveBidsWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withPage:iActiveBids withPageSize:kPageSize];
    
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

#pragma mark - WebService For Getting AvailableToTrade Data

- (void)webServiceAvailableToTrade
{
    NSMutableURLRequest *requestURL = [SMWebServices availableToTradeUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withPage:iAvailable withPageSize:kPageSize];
    
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

#pragma mark - WebService For Getting NotAvailableToTrade Data

- (void)webServiceNotAvailableToTrade
{
    NSMutableURLRequest *requestURL = [SMWebServices notAvailableToTradeUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withPage:iNotAvailable withPageSize:kPageSize];
    
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
    if ([elementName isEqualToString:@"Vehicle"])
    {
        objectVehicleListing  = [[SMVehiclelisting alloc] init];
    }
    if ([elementName isEqualToString:@"GetCountsResult"])
    {
        objCustomSell = [[SMCustomSellObject alloc]init];
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
    if ([elementName isEqualToString:@"AskingPrice"] || [elementName isEqualToString:@"Price"])
    {
        objectVehicleListing.strVehiclePrice = currentNodeContent;
    }
    if ([elementName isEqualToString:@"BiddingClosed"])
    {
        NSArray *arrayWithTwoStrings = [currentNodeContent componentsSeparatedByString:@" "];
        
        NSArray *hoursmint = [[arrayWithTwoStrings objectAtIndex:3]componentsSeparatedByString:@":"];
        
        objectVehicleListing.strBiddingClosed = [NSString stringWithFormat:@"%@h %@m",[hoursmint objectAtIndex:0],[hoursmint objectAtIndex:1]];
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        objectVehicleListing.strVehicleColor = currentNodeContent;
    }
    if ([elementName isEqualToString:@"HighestBid"])
    {
       // objectVehicleListing.strWinningBid = currentNodeContent.intValue;
         objectVehicleListing.strWinningBid = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"Location"])
    {
        objectVehicleListing.strLocation = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Name"] || [elementName isEqualToString:@"FriendlyName"])
    {
        objectVehicleListing.strVehicleName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Year"] || [elementName isEqualToString:@"UsedYear"])
    {
        objectVehicleListing.strVehicleYear = currentNodeContent;
    }
    if ([elementName isEqualToString:@"StockCode"])
    {
        objectVehicleListing.strStockCode = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Type"])
    {
        objectVehicleListing.strVehicleType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"IsTrade"])
    {
        objectVehicleListing.isTrade = [currentNodeContent boolValue];
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
        objectVehicleListing.strVehicleMileage = [NSString stringWithFormat:@"%@ Km",currentNodeContent];
    }
    if ([elementName isEqualToString:@"OfferAmount"])
    {
        objectVehicleListing.strOfferAmount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"OfferClient"])
    {
        objectVehicleListing.strOfferClient = currentNodeContent;
    }
    if ([elementName isEqualToString:@"OfferMember"])
    {
        objectVehicleListing.strOfferMember = currentNodeContent;
    }
    if ([elementName isEqualToString:@"OfferDate"])
    {
        objectVehicleListing.strOfferDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"OfferID"])
    {
        objectVehicleListing.strOfferID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"StatusWhen"])
    {
        objectVehicleListing.strStatusWhen = currentNodeContent;
    }
    if ([elementName isEqualToString:@"StatusWho"])
    {
        objectVehicleListing.strStatusWho = currentNodeContent;
    }
    if ([elementName isEqualToString:@"HasOffers"])
    {
        objectVehicleListing.hasOffers = [currentNodeContent boolValue];
    }
    if ([elementName isEqualToString:@"OfferStart"])
    {
        objectVehicleListing.strOfferStart = currentNodeContent;
    }
    if ([elementName isEqualToString:@"OfferEnd"])
    {
        objectVehicleListing.strOfferEnd = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Thumb"])
    {
        objectVehicleListing.strVehicleImageURL = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"Vehicle"])
    {
        [tempDataArray addObject:objectVehicleListing];
    }
    if ([elementName isEqualToString:@"Total"])
    {
        totalRecordCount = [currentNodeContent intValue];
    }
    
    if ([elementName isEqualToString:@"TradePeriodEndedPagedResult"])
    {
        iTotalBidEnded = totalRecordCount;
        [self.arrayBidEnded addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    if ([elementName isEqualToString:@"ListActiveBidsPagedResult"])
    {
        iTotalActiveBids = totalRecordCount;
        [self.arrayBidReceived addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    if ([elementName isEqualToString:@"AvailableToTradePagedResult"])
    {
        iTotalAvailable =totalRecordCount;
        [self.arrayAvailbaleTrader addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    if ([elementName isEqualToString:@"NotAvailableToTradePagedResult"])
    {
        iTotalNotAvailable = totalRecordCount;
        [self.arrayNotAvailbaleTrader addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }

    if ([elementName isEqualToString:@"ActiveBids"])
    {
        objCustomSell.activeBid = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"AvailableToTrade"])
    {
        objCustomSell.availableToTrade = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"NotAvailableToTrade"])
    {
        objCustomSell.notAvailableToTrade = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"BiddingEnded"])
    {
        objCustomSell.biddingEnded = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"GetCountsResult"])
    {
        [self.arrayGetCount addObject:objCustomSell];
    }
    
    /*
    if ([elementName isEqualToString:@"Vehicle"])
    {
        switch (currentIndex)
        {
            case 0:
                [self.arrayBidEnded addObject:objectVehicleListing];
                break;
                
            case 1:
                [self.arrayBidReceived addObject:objectVehicleListing];
                break;
                
            case 2:
                [self.arrayAvailbaleTrader addObject:objectVehicleListing];
                break;
                
            case 3:
                [self.arrayNotAvailbaleTrader addObject:objectVehicleListing];
                break;
        }
    }
    if ([elementName isEqualToString:@"Total"])
    {
        switch (currentIndex)
        {
            case 0:
                iTotalBidEnded = [currentNodeContent intValue];
                break;
                
            case 1:
                iTotalActiveBids = [currentNodeContent intValue];
                break;
                
            case 2:
                iTotalAvailable = [currentNodeContent intValue];
                break;
                
            case 3:
                iTotalNotAvailable = [currentNodeContent intValue];
                break;
        }
    }
     */
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tblViewSells reloadData];
}

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
