//
//  SMWantedDetailViewController.m
//  SmartManager
//
//  Created by Ketan Nandha on 02/03/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMWantedDetailViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMSellCollectionCell.h"
#import "SMWantedDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SMCommonClassMethods.h"
#import "SMTraderDetailViewController.h"

@interface SMWantedDetailViewController ()

@end

@implementation SMWantedDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addingProgressHUD];
    
    [self registerNib];
    
    [self webserviceForWantedSearchResult:self.objectDropDown.iWantedSearchID withCount:self.count];
}

- (void)registerNib
{
    [self.tableWantedDetail registerNib:[UINib nibWithNibName:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? @"SMWantedDetailTableViewCell" : @"SMWantedDetailTableViewCell_iPad"  bundle:nil] forCellReuseIdentifier:@"SMWantedDetailTableViewCellIdentifier"];
    
    [self.tableWantedDetail setTableFooterView:[[UIView alloc] init]];
}

- (void)webserviceForWantedSearchResult:(int)iWantedID withCount:(int)count
{
//    [HUD show:YES];
//    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices wantedSearchResultXMLWithUserHash:[SMGlobalClass sharedInstance].hashValue withWantedSearchID:iWantedID withPageNo:pageNo withCountNo:count];
    
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
             arrayVehicle = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayVehicle count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMWantedDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMWantedDetailTableViewCellIdentifier"];
    
    objectVehicleListing = arrayVehicle[indexPath.row];
    
    [cell.imageVehicle   setImageWithURL:[NSURL URLWithString:objectVehicleListing.strImageID] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];

    [cell.lblVehicleName      setText:[NSString stringWithFormat:@"%@ %@",objectVehicleListing.strVehicleYear,objectVehicleListing.strVehicleName]];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cell.lblVehicleName.text];
    NSRange fullRange = NSMakeRange(0, 4);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:fullRange];
    [cell.lblVehicleName setAttributedText:string];

    [cell.lblVehicleColour      setText:objectVehicleListing.strVehicleColor];
    [cell.lblVehicleLocation    setText:objectVehicleListing.strLocation];
    
    [cell.lblVehicleMileage     setText:[NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:objectVehicleListing.strVehicleMileage]]];
    
    [cell.lblVehicleAmount      setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:objectVehicleListing.strVehicleTradePrice]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (arrayVehicle.count-1 == indexPath.row)
    {
        if (arrayVehicle.count != self.count)
        {
            pageNo++;
            [self webserviceForWantedSearchResult:self.objectDropDown.iWantedSearchID withCount:self.count];
        }
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __block SMTraderDetailViewController *objectTradeDetails;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        objectTradeDetails = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
        [[SMTraderDetailViewController alloc] initWithNibName:@"SMTraderDetailViewController" bundle:nil] :
        [[SMTraderDetailViewController alloc] initWithNibName:@"SMTraderDetailViewController_iPad" bundle:nil];
        
        SMVehiclelisting *objectVehicleListingInDidCell = (SMVehiclelisting *) [arrayVehicle objectAtIndex:indexPath.row];
        
        objectTradeDetails.strSelectedVehicleId = objectVehicleListingInDidCell.strUsedVehicleStockID;
        
        [self.navigationController pushViewController:objectTradeDetails animated:YES];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 100.0f : 130.0f;
}

#pragma mark - XML Parsing Delegates

-(void) parser:(NSXMLParser *)    parser
didStartElement:(NSString *)   elementName
  namespaceURI:(NSString *)      namespaceURI
 qualifiedName:(NSString *)     qName
    attributes:(NSDictionary *)    attributeDict
{
    if ([elementName isEqualToString:@"result"])
    {
        objectVehicleListing  = [[SMVehiclelisting alloc] init];
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *string = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"UsedVehicleStockID"])
    {
        objectVehicleListing.strUsedVehicleStockID = currentNodeContent;
    }
    if([elementName isEqualToString:@"FriendlyName"])
    {
        objectVehicleListing.strVehicleName = currentNodeContent;
    }
    if([elementName isEqualToString:@"VariantID"])
    {
        NSLog(@"%@",currentNodeContent);
    }
    if([elementName isEqualToString:@"ModelID"])
    {
        NSLog(@"%@",currentNodeContent);
    }
    if([elementName isEqualToString:@"Year"])
    {
        objectVehicleListing.strVehicleYear = currentNodeContent;
    }
    if([elementName isEqualToString:@"Province"])
    {
        objectVehicleListing.strProvince = currentNodeContent;
    }
    if([elementName isEqualToString:@"Location"])
    {
        objectVehicleListing.strLocation = currentNodeContent;
        
        if (objectVehicleListing.strLocation.length == 0)
        {
            objectVehicleListing.strLocation = @"Suburb/City";
        }
    }
    if([elementName isEqualToString:@"DealershipID"])
    {
        objectVehicleListing.strDealershipID = currentNodeContent;
    }
    if([elementName isEqualToString:@"Mileage"])
    {
        objectVehicleListing.strVehicleMileage = currentNodeContent;
    }
    if([elementName isEqualToString:@"Price"])
    {
        objectVehicleListing.strVehiclePrice = currentNodeContent;
    }
    if([elementName isEqualToString:@"TradePrice"])
    {
        objectVehicleListing.strVehicleTradePrice = currentNodeContent;
    }
    if([elementName isEqualToString:@"StockCode"])
    {
        objectVehicleListing.strStockCode = currentNodeContent;
    }
    if([elementName isEqualToString:@"Colour"])
    {
        objectVehicleListing.strVehicleColor = currentNodeContent;
    }
    if([elementName isEqualToString:@"MDC"])
    {
        objectVehicleListing.strMDC = currentNodeContent;
    }
    if([elementName isEqualToString:@"ImageID"])
    {
        objectVehicleListing.strImageID = [NSString stringWithFormat:@"%@%@",[SMWebServices activeSpecailListingImage],currentNodeContent];
    }
    if([elementName isEqualToString:@"BidClose"])
    {
        objectVehicleListing.strBiddingClosed = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TradeClose"])
    {
        objectVehicleListing.strTradeClosed = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"result"])
    {
        [arrayVehicle addObject:objectVehicleListing];
    }
    if ([elementName isEqualToString:@"WantedSearchResultXMLResult"])
    {
        [self.tableWantedDetail reloadData];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
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

#pragma mark - Memort warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
