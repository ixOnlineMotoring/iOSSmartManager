//
//  SMSalesViewController.m
//  Smart Manager
//
//  Created by Jignesh on 27/10/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMSalesViewController.h"
#import "SMSalesTableViewCell.h"
#import "SMCustomColor.h"
#import "SMListSalesTableViewCell.h"
#import "SMTraderWinningBidCell.h"
#import "SMCommonClassMethods.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMTradeSoldViewController.h"
#import "SMBuyersSummaryListingViewController.h"

static int kPageSize=10;

@interface SMSalesViewController ()

@end

@implementation SMSalesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addingProgressHUD];
    iSalesPageCount = 0;
   self.navigationItem.titleView = [SMCustomColor setTitle:@"Sales"];
   
    [self registerNibForTableView];
    arrayOfSales = [[NSMutableArray alloc]init];
   // buttonSeller.titleLabel.font = [UIFont fontWithName:FONT_NAME size:14.0];
    buttonSeller.layer.cornerRadius = 04.0;
    [buttonSeller setClipsToBounds:YES];
    
    [buttonBuyer setBackgroundColor:[SMCustomColor setGrayColorThemeButton]];
   // buttonBuyer.titleLabel.font = [UIFont fontWithName:FONT_NAME size:14.0];
    buttonBuyer.layer.cornerRadius = 04.0;
    [buttonBuyer setClipsToBounds:YES];
    
    dateView.layer.cornerRadius =15.0;
    dateView.clipsToBounds      = YES;
    
    [textField_StartRange setTextColor:[UIColor whiteColor]];
    [textField_EndRange setTextColor:[UIColor whiteColor]];
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        table_SalesInformation.layoutMargins = UIEdgeInsetsZero;
        table_SalesInformation.preservesSuperviewLayoutMargins = NO;
    }
    
    if([textField_StartRange.text length]== 0 && [textField_EndRange.text length]== 0)
    {
        NSString *outPutDate =  [self getOneMonthBackDateFromCurrentDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
        
        textField_StartRange.text = outPutDate;
        textField_EndRange.text = textDate;
        
    }
    lable_salesNote.text = [NSString stringWithFormat:@"Sales List for the period %@ to %@",textField_StartRange.text, textField_EndRange.text];

    selectedTypeForTable =1;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
    lblRedNote.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0f];
    }
    else{
        lblRedNote.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];

    }
    
    lblRedNote.text = @"Click on vehicles to view details.";
    isSearchTrue = NO;
    [self webServiceForListingSales];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0:  // For Select Type
        {
            selectedType = 0;
            
            [textField resignFirstResponder];
            [self loadPopUpView];

            return NO;
        }
        case 1:
        {
            selectedType = 1;
            
            [textField resignFirstResponder];
            [self loadPopUpView];
            return NO;
            
        }
    }
    
    return YES;
    
}
#pragma mark -


#pragma mark - 
#pragma mark - UItable view functions
#pragma mark -

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (selectedTypeForTable == 1)
    {
        
        static NSString *cellIdentifier=@"SMTraderWinningBidCell";
        
        SMTraderWinningBidCell *dynamicCell;
        
        SMVehiclelisting *rowObject = (SMVehiclelisting*)[arrayOfSales objectAtIndex:indexPath.row];
        
        UILabel *vehicleName;
        UILabel *lblVehicleDetails1;
        UILabel *lblVehicleDetails2;
        
        //--------------------------------------------------------------------------------------------
        
        CGFloat heightName = 0.0f;
        
        NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",rowObject.strVehicleYear,rowObject.strVehicleName];
        
        heightName = [self heightForText:strVehicleNameHeight];
        
        //-------------------------------------------------------------------------------------------
        
        CGFloat heightDetails1 = 0.0f;
        
        NSString *strVehicleDetails1 = [NSString stringWithFormat:@"%@ | %@ | %@",rowObject.strVehicleMileage,rowObject.strVehicleColor,rowObject.strStockCode];
        
        heightDetails1 = [self heightForText:strVehicleDetails1];
        //----------------------------------------------------------------------------------------
        
        
        
        if (dynamicCell == nil)
        {
            dynamicCell = [[SMTraderWinningBidCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            vehicleName = [[UILabel alloc]init];
            lblVehicleDetails1 = [[UILabel alloc]init];
            lblVehicleDetails2 = [[UILabel alloc]init];
            
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                
                vehicleName.frame = CGRectMake(6.0, 6.0, 311.0, heightName);
                lblVehicleDetails1.frame = CGRectMake(6.0, vehicleName.frame.origin.y + vehicleName.frame.size.height+4.0, 311.0, heightDetails1);
                lblVehicleDetails2.frame = CGRectMake(6.0, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+4.0, 311.0, 21);
                
                vehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                
            }
            else
            {
                vehicleName.frame = CGRectMake(8.0, 8.0, 677.0, heightName);
                
                lblVehicleDetails1.frame = CGRectMake(8.0, vehicleName.frame.origin.y + vehicleName.frame.size.height+4.0, 677.0, heightDetails1);
                
                lblVehicleDetails2.frame = CGRectMake(8.0, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+4.0, 677.0, 21 );
                
                vehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                
            }
            
            vehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
            lblVehicleDetails1.textColor = [UIColor whiteColor];
            lblVehicleDetails2.textColor = [UIColor whiteColor];
            
            
            
            vehicleName.tag = 101;
            lblVehicleDetails1.tag = 103;
            lblVehicleDetails2.tag = 104;
            
            [self setAttributedTextForVehicleDetailsWithFirstText:rowObject.strVehicleYear andWithSecondText:rowObject.strVehicleName forLabel:vehicleName];
            
            lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",rowObject.strVehicleMileage,rowObject.strVehicleColor,rowObject.strStockCode];
            
            
            [self setAttributedTextForVehicleDetailsWithFirstText:@"Bought by" andWithSecondText:rowObject.strClientName andWithThirdText:@"for" andWithFourthText:rowObject.strVehicleTradePrice forLabel:lblVehicleDetails2];
            
            
            [dynamicCell.contentView addSubview:vehicleName];
            [dynamicCell.contentView addSubview:lblVehicleDetails1];
            [dynamicCell.contentView addSubview:lblVehicleDetails2];
            
            
        }
        
        
        vehicleName.numberOfLines = 0;
        [vehicleName sizeToFit];
        
        lblVehicleDetails1.numberOfLines = 0;
        [lblVehicleDetails1 sizeToFit];
        
        
        lblVehicleDetails2.numberOfLines = 0;
        [lblVehicleDetails2 sizeToFit];
        
        vehicleName.backgroundColor = [UIColor blackColor];
        lblVehicleDetails1.backgroundColor = [UIColor blackColor];
        lblVehicleDetails2.backgroundColor = [UIColor blackColor];
        
        if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
        {
            dynamicCell.layoutMargins = UIEdgeInsetsZero;
            dynamicCell.preservesSuperviewLayoutMargins = NO;
        }
        dynamicCell.backgroundColor = [UIColor blackColor];
        
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (arrayOfSales.count-1 == indexPath.row)
        {
            if (arrayOfSales.count != totalSalesRecordsCount)
            {
                iSalesPageCount++;
                if([textField_StartRange.text length]>0)
                {
                    if ( [self validate]==YES)
                    {
                        isSearchTrue = YES;
                        [self webServiceForListingSales];
                    }
                }
                else
                {
                    isSearchTrue = NO;
                    [self webServiceForListingSales];
                }
            }
        }
        
        
        return dynamicCell;

    }
    else
    {
    
        static NSString         *CellIdentifier = @"CellList";
        SMListSalesTableViewCell  *cell = (SMListSalesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        SMVehiclelisting *rowObject = (SMVehiclelisting*)[arrayOfSales objectAtIndex:indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
        [cell.label_SaleCarName setText:rowObject.strClientName];
        [cell.label_SaleCarCount setText:rowObject.strSalesCount];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }
    
    return 0;
}

#define CELL_CONTENT_WIDTH  320.0f
#define CELL_CONTENT_MARGIN 10.0f

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedTypeForTable == 1)
    {
        CGFloat finalDynamicHeight = 0.0f;
        SMVehiclelisting *rowObject = (SMVehiclelisting*)[arrayOfSales objectAtIndex:indexPath.row];

        //--------------------------------------------------------------------------------------------
        
        CGFloat heightName = 0.0f;
        
        NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",rowObject.strVehicleYear,rowObject.strVehicleName];
        
        heightName = [self heightForText:strVehicleNameHeight];
        
        //-------------------------------------------------------------------------------------------
        
        CGFloat heightDetails1 = 0.0f;
        
        NSString *strVehicleDetails1 = [NSString stringWithFormat:@"%@ | %@ | %@",rowObject.strVehicleMileage,rowObject.strVehicleColor,rowObject.strStockCode];
        
        heightDetails1 = [self heightForText:strVehicleDetails1];
        //----------------------------------------------------------------------------------------

        
        finalDynamicHeight = (heightName + heightDetails1 + 21 +15.0);
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        return finalDynamicHeight+8;
        else
         return finalDynamicHeight+18;
    }
    else
    {
        return 45;
    }
    
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayOfSales.count;
}


-(void)tableView:(UITableView* )tableView didSelectRowAtIndexPath:(NSIndexPath* )indexPath
{
    if(selectedTypeForTable == 2)
    {
        SMVehiclelisting *rowObject = (SMVehiclelisting*)[arrayOfSales objectAtIndex:indexPath.row];
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            
            SMBuyersSummaryListingViewController *vcSMBuyersSummaryListingViewController = [[SMBuyersSummaryListingViewController alloc]initWithNibName:@"SMBuyersSummaryListingViewController" bundle:nil];
        
            vcSMBuyersSummaryListingViewController.strClientId = rowObject.strClientIdForBuyerSummary;
            [self.navigationController pushViewController:vcSMBuyersSummaryListingViewController animated:NO];
        }
        else
        {
            SMBuyersSummaryListingViewController *vcSMBuyersSummaryListingViewController = [[SMBuyersSummaryListingViewController alloc]initWithNibName:@"SMBuyersSummaryListingViewController_iPad" bundle:nil];
            
            vcSMBuyersSummaryListingViewController.strClientId = rowObject.strClientIdForBuyerSummary;
            [self.navigationController pushViewController:vcSMBuyersSummaryListingViewController animated:NO];
        }
        

    }
    
    
    else
    {
        SMVehiclelisting *selectedRowObject = (SMVehiclelisting*)[arrayOfSales objectAtIndex:indexPath.row];
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
           
            
            SMTradeSoldViewController *vcSMTradeSoldViewController = [[SMTradeSoldViewController alloc]initWithNibName:@"SMTradeSoldViewController" bundle:nil];
            vcSMTradeSoldViewController.vehicleObj = selectedRowObject;
             NSLog(@"strVehicleType = %@",vcSMTradeSoldViewController.vehicleObj.strVehicleType);
            [self.navigationController pushViewController:vcSMTradeSoldViewController animated:NO];
            
        }
        else
        {
            SMTradeSoldViewController *vcSMTradeSoldViewController = [[SMTradeSoldViewController alloc]initWithNibName:@"SMTradeSoldViewController_iPad" bundle:nil];
             vcSMTradeSoldViewController.vehicleObj = selectedRowObject;
            [self.navigationController pushViewController:vcSMTradeSoldViewController animated:NO];
            
        }

    }
}



/*#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==textField_StartRange)
    {
        //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        //        [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
        //        [self.datePicker setDate:[dateFormatter dateFromString:self.txtStartDate.text] animated:YES];
        
        selectedType = 0;
        [textField resignFirstResponder];
        [self loadPopUpView];
    }
    if (textField==textField_EndRange)
    {
        //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        //        [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
        //        [self.datePicker setDate:[dateFormatter dateFromString:self.txtEndDate.text] animated:YES];
        
        selectedType = 1;
        if (txtStartDate.text.length == 0)
        {
            SMAlert(KLoaderTitle, KStartDate);
            
            [txtStartDate resignFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
            [self loadPopUpView];
        }
    }
    
    return NO;
}

*/

#pragma mark - WEb Services

-(void)webServiceForListingSales
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    NSMutableURLRequest *requestURL;
    if(!isSearchTrue)
    {
        NSString *fromDate =  [self getOneMonthBackDateFromCurrentDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        
        NSString *toDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
        
        requestURL = [SMWebServices listTradeSalesWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andDateTimeFrom:fromDate andDateTimeTo:toDate andPage:iSalesPageCount andPageSize:kPageSize];
    }
    else
    {
        requestURL = [SMWebServices listTradeSalesWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andDateTimeFrom:textField_StartRange.text andDateTimeTo:textField_EndRange.text andPage:iSalesPageCount andPageSize:kPageSize];
        
    }
   
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
             [HUD hide:YES];
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

-(void)webServiceForListingSalesSummary
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    NSMutableURLRequest *requestURL;
    if(!isSearchTrue)
    {
        NSString *fromDate =  [self getOneMonthBackDateFromCurrentDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        
        NSString *toDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
        
        requestURL = [SMWebServices listTradeSalesSummaryWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andDateTimeFrom:fromDate andDateTimeTo:toDate];
    }
    else
    {
        requestURL = [SMWebServices listTradeSalesSummaryWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andDateTimeFrom:textField_StartRange.text andDateTimeTo:textField_EndRange.text];
        
    }
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
             [HUD hide:YES];
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
    if ([elementName isEqualToString:@"SummeryItem"])
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
    
    if ([elementName isEqualToString:@"ID"])
    {
        objectVehicleListing.strOfferID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"UsedVehicleStockID"])
    {
        objectVehicleListing.strUsedVehicleStockID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"StockCode"])
    {
        objectVehicleListing.strStockCode = currentNodeContent;
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
    if ([elementName isEqualToString:@"Colour"])
    {
        objectVehicleListing.strVehicleColor = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
        objectVehicleListing.strVehicleMileage = [NSString stringWithFormat:@"%@ Km",currentNodeContent];
    }
    if ([elementName isEqualToString:@"RetailPrice"])
    {
        if([currentNodeContent isEqualToString:@"0"] || currentNodeContent.length == 0)
            objectVehicleListing.strVehiclePrice = @"R?";
        else
        {
            objectVehicleListing.strVehiclePrice = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        }
    }
    if ([elementName isEqualToString:@"TradePrice"])
    {
        if([currentNodeContent isEqualToString:@"0"] || currentNodeContent.length == 0 || [currentNodeContent isEqualToString:@"0.0000"])
            objectVehicleListing.strVehicleTradePrice = @"R?";
        else
        {
            objectVehicleListing.strVehicleTradePrice = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        }
    }
    if ([elementName isEqualToString:@"HeighestBid"])
    {
        if([currentNodeContent isEqualToString:@"0"] || currentNodeContent.length == 0 || [currentNodeContent isEqualToString:@"0.0000"])
            objectVehicleListing.strOfferAmount = @"R0";
        else
        {
            objectVehicleListing.strOfferAmount = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        }
    }
    if ([elementName isEqualToString:@"LoadDate"])
    {
        objectVehicleListing.strSoldDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Amount"])
    {
        objectVehicleListing.strWinningBid = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"ClientID"])
    {
        objectVehicleListing.intClientID = currentNodeContent.intValue;
    }
    if ([elementName isEqualToString:@"ClientName"])
    {
        objectVehicleListing.strClientName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"UserName"])
    {
        objectVehicleListing.strUser = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Sales"])
    {
        objectVehicleListing.strSalesCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Count"])
    {
        totalCount = currentNodeContent.intValue;
    }
    if ([elementName isEqualToString:@"TradeOffer"])
    {
        if([objectVehicleListing.strStockCode length] == 0)
         objectVehicleListing.strStockCode = @"Stock code?";
            
        [arrayOfSales addObject:objectVehicleListing];
    }
    if ([elementName isEqualToString:@"SummeryItem"])
    {
        if([objectVehicleListing.strStockCode length] == 0)
            objectVehicleListing.strStockCode = @"Stock code?";

        [arrayOfSales addObject:objectVehicleListing];
    }
    if ([elementName isEqualToString:@"ListTradeSalesResult"])
    {
        totalSalesRecordsCount = totalCount;
        [table_SalesInformation reloadData];
    }
    if ([elementName isEqualToString:@"TradeSalesSummaryResult"])
    {
        [table_SalesInformation reloadData];
    }
    if ([elementName isEqualToString:@"ClientID"])
    {
        objectVehicleListing.strClientIdForBuyerSummary = currentNodeContent;
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"reached here...");
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


-(void)setAttributedTextForName:(NSString *) strYear withName:(NSString *) strName forLabel:(UILabel *)label
{

    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite       = [UIColor whiteColor];
    UIColor *foregroundColorBlue        = [SMCustomColor setBlueColorThemeButton];
    
    
    
    // Create the attributes
    
    NSDictionary *FirstYear = [NSDictionary dictionaryWithObjectsAndKeys:
                               regularFont, NSFontAttributeName,
                               foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString *attributedYear= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",@"2000"]attributes:FirstYear];
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",strName]attributes:FirstAttribute];
    
    
    [attributedYear       appendAttributedString:attributedFirstText];
    
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedYear];

}


-(void)setAttributedTextForKiloMeter:(NSString *) strKM withName:(NSString *) strColor withNo:(NSString *) strNo forLabel:(UILabel *)label
{
    
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite       = [UIColor whiteColor];
    
    
    
    // Create the attributes
    
    NSDictionary *FirstYear = [NSDictionary dictionaryWithObjectsAndKeys:
                               regularFont, NSFontAttributeName,
                               foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    NSDictionary *LastAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString *attributedYear= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",@"23000Km"]attributes:FirstYear];
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"       |%@",@"Red"]attributes:FirstAttribute];
    
    NSMutableAttributedString *attributedLastText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"       |%@",strNo]attributes:LastAttribute];
    
    [attributedFirstText appendAttributedString:attributedLastText];
    [attributedYear       appendAttributedString:attributedFirstText];
    
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedYear];
    
}

-(void)setAttributedTextForCosting:(NSString *) strName withCost:(NSString *) strCost forLabel:(UILabel *)label
{
    
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite       = [UIColor whiteColor];
    UIColor *foregroundColorBlue        = [SMCustomColor setColorYellowishOrange];
    
    
    
    // Create the attributes
    
    NSDictionary *FirstYear = [NSDictionary dictionaryWithObjectsAndKeys:
                               regularFont, NSFontAttributeName,
                               foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString *attributedYear= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",strName]attributes:FirstYear];
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",strCost]attributes:FirstAttribute];
    
    
    [attributedYear       appendAttributedString:attributedFirstText];
    
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedYear];
    
}



-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite       = [UIColor whiteColor];
    UIColor *foregroundColorBlue        = [SMCustomColor setBlueColorThemeButton];
    UIColor *foregroundColorYellowish   = [SMCustomColor setColorYellowishOrange];

    
    
    // Create the attributes
    
    NSDictionary *FirstYear         = [NSDictionary dictionaryWithObjectsAndKeys:
                                       regularFont, NSFontAttributeName,
                                       foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *FirstAttribute    = [NSDictionary dictionaryWithObjectsAndKeys:
                                       regularFont, NSFontAttributeName,
                                       foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute   = [NSDictionary dictionaryWithObjectsAndKeys:
                                       regularFont, NSFontAttributeName,
                                       foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute    = [NSDictionary dictionaryWithObjectsAndKeys:
                                       regularFont, NSFontAttributeName,
                                       foregroundColorWhite, NSForegroundColorAttributeName, nil];
    NSDictionary *CostAttributes    = [NSDictionary dictionaryWithObjectsAndKeys:
                                       regularFont, NSFontAttributeName,
                                       foregroundColorYellowish, NSForegroundColorAttributeName, nil];
    
    
    
    NSMutableAttributedString *attributedYear= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",@"2000"]
                                                                                           attributes:FirstYear];
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" | %@ |",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    NSMutableAttributedString *attributedCost = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",@"R14233"]
                                                                                            attributes:CostAttributes];
    
    
    [attributedThirdText  appendAttributedString:attributedCost];
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText  appendAttributedString:attributedSecondText];
    [attributedYear       appendAttributedString:attributedFirstText];

    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedYear];
    
    
}

-(NSString*)getOneMonthBackDateFromCurrentDate
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:newDate]];
    return textDate;
}

#pragma mark -


#pragma mark -
#pragma mark - User Define Functions
-(void) registerNibForTableView
{
    [table_SalesInformation registerNib:[UINib nibWithNibName:@"SMSalesTableViewCell" bundle:nil]        forCellReuseIdentifier:@"CellID"];
    
    [table_SalesInformation registerNib:[UINib nibWithNibName:@"SMListSalesTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellList"];
    
    [table_SalesInformation setTableHeaderView:[UIView new]];
    [table_SalesInformation setTableFooterView:[UIView new]];
}
#pragma mark -


#pragma mark -
#pragma mark - Load/Hide Drop Down For Start & End Date

-(void)loadPopUpView
{
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

-(void) hidePopUpView
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
              [popupView setTransform:CGAffineTransformMakeScale(0.9,0.9)];
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

- (BOOL)validate
{
    if (textField_StartRange.text.length == 0)
    {
        SMAlert(KLoaderTitle, KDateStart);
        
        return NO;
    }
    else if (textField_EndRange.text.length == 0)
    {
        SMAlert(KLoaderTitle, KDateEnd);
        
        return NO;
    }
    else
        return YES;
}



#pragma mark -

-(IBAction)buttonCancelDidPressed:(id)sender
{

    [self hidePopUpView];
}

-(IBAction)buttonDoneDidPrssed:(id) sender
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datePickerForTime.date]];
    

    switch (selectedType)
    {
        case 0:
        {
        
            [textField_StartRange setText:textDate];
            
        }
            break;
        case 1:
        {
        
            [textField_EndRange   setText:textDate];
        }
            break;
        default:
            break;
    }
    [self hidePopUpView];
    
    switch (selectedTypeForTable) {
        case 1:
        {
            if(arrayOfSales.count > 0)
                [arrayOfSales removeAllObjects];
            
            [table_SalesInformation reloadData];
            
            if([textField_StartRange.text length]>0)
            {
                if ( [self validate]==YES)
                {
                    isSearchTrue = YES;
                    [self webServiceForListingSales];
                }
            }
            else
            {
                isSearchTrue = NO;
                [self webServiceForListingSales];
            }

        
        }
        break;
        
        case 2:
        {
            if(arrayOfSales.count > 0)
                [arrayOfSales removeAllObjects];
            
            [table_SalesInformation reloadData];
            
            if([textField_StartRange.text length]>0)
            {
                if ( [self validate]==YES)
                {
                    isSearchTrue = YES;
                    NSLog(@"thisss1");
                    [self webServiceForListingSalesSummary];
                }
            }
            else
            {
                isSearchTrue = NO;
                 NSLog(@"thisss2");
                [self webServiceForListingSalesSummary];
            }
        }
        break;
            
        default:
            break;
    }
    
}

-(IBAction)buttonActionListSalesDidPressed:(id)sender
{
    [buttonSeller setBackgroundColor:[SMCustomColor setBlueColorThemeButton]];
    [buttonBuyer setBackgroundColor:[SMCustomColor setGrayColorThemeButton]];
    
    selectedTypeForTable =1;
    lable_salesNote.text = [NSString stringWithFormat:@"Sales List for the period %@ to %@",textField_StartRange.text, textField_EndRange.text];
    
    lblRedNote.text = @"Click on vehicles to view details.";
    if(arrayOfSales.count > 0)
        [arrayOfSales removeAllObjects];
    
    [table_SalesInformation reloadData];
    
    if([textField_StartRange.text length]>0)
    {
        if ( [self validate]==YES)
        {
            isSearchTrue = YES;
            [self webServiceForListingSales];
        }
    }
    else
    {
        isSearchTrue = NO;
        [self webServiceForListingSales];
    }
}
-(IBAction)buttonBuyerSelleDidPrssed:(id)sender
{
    [buttonBuyer setBackgroundColor:[SMCustomColor setBlueColorThemeButton]];
    [buttonSeller setBackgroundColor:[SMCustomColor setGrayColorThemeButton]];
    
    
    selectedTypeForTable = 2;
     lable_salesNote.text = [NSString stringWithFormat:@"Buyer Summary for the period %@ to %@",textField_StartRange.text, textField_EndRange.text];
    lblRedNote.text = @"Click on sales count to view a list of sales";
    
    if(arrayOfSales.count > 0)
        [arrayOfSales removeAllObjects];
    
    [table_SalesInformation reloadData];
    
    if([textField_StartRange.text length]>0)
    {
        if ( [self validate]==YES)
        {
            isSearchTrue = YES;
             NSLog(@"thisss3");
            [self webServiceForListingSalesSummary];
        }
    }
    else
    {
        isSearchTrue = NO;
         NSLog(@"thisss4");
         [self webServiceForListingSalesSummary];
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

/*-(NSString*)getOneMonthBackDateFromCurrentDate
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:newDate]];
    return textDate;
}
*/

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

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText forLabel:(UILabel*)label
{
    
    
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
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    
    UIColor *foregroundColorYellow = [UIColor colorWithRed:187.0/255.0 green:140.0/255.0 blue:20.0/255.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FourthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorYellow, NSForegroundColorAttributeName, nil];
    
   
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@ ",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    NSMutableAttributedString *attributedFourthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",fourthText]
                                                                                             attributes:FourthAttribute];
    
    
    
    [attributedThirdText appendAttributedString:attributedFourthText];
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

@end
