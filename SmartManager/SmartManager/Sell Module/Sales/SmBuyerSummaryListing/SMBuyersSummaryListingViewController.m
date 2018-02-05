//
//  SMBuyersSummaryListingViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 26/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMBuyersSummaryListingViewController.h"
#import "SMTraderWinningBidCell.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMCommonClassMethods.h"
#import "SMTradeSoldViewController.h"
static int kPageSize=10;

@interface SMBuyersSummaryListingViewController ()

@end

@implementation SMBuyersSummaryListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addingProgressHUD];
    
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        table_BuyersInformation.layoutMargins = UIEdgeInsetsZero;
        table_BuyersInformation.preservesSuperviewLayoutMargins = NO;
    }

    arrayOfBuyers = [[NSMutableArray alloc]init];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Sales"];
    [self registerNibForTableView];
    [self webServiceForListingSales];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) registerNibForTableView
{
    [table_BuyersInformation registerNib:[UINib nibWithNibName:@"SMSalesTableViewCell" bundle:nil]        forCellReuseIdentifier:@"CellID"];
    
    [table_BuyersInformation registerNib:[UINib nibWithNibName:@"SMListSalesTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellList"];
    
    [table_BuyersInformation setTableHeaderView:[UIView new]];
    [table_BuyersInformation setTableFooterView:[UIView new]];
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


#pragma mark -
#pragma mark - UItable view functions
#pragma mark -



-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        static NSString *cellIdentifier=@"SMTraderWinningBidCell";
        
        SMTraderWinningBidCell *dynamicCell;
        
        SMVehiclelisting *rowObject = (SMVehiclelisting*)[arrayOfBuyers objectAtIndex:indexPath.row];
        
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
                
                lblVehicleDetails2.frame = CGRectMake(8.0, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+4.0, 677.0, 21);
                
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
            
            
            [self setAttributedTextForVehicleDetailsWithFirstText:@"Bought by" andWithSecondText:rowObject.strClientName andWithThirdText:@"for " andWithFourthText:rowObject.strVehicleTradePrice forLabel:lblVehicleDetails2];
            
            
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
        
        return dynamicCell;
        
    
}

#define CELL_CONTENT_WIDTH  320.0f
#define CELL_CONTENT_MARGIN 10.0f

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
         CGFloat finalDynamicHeight = 0.0f;
        SMVehiclelisting *rowObject = (SMVehiclelisting*)[arrayOfBuyers objectAtIndex:indexPath.row];
        
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
        
        return finalDynamicHeight+8;
   

    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayOfBuyers.count;
}

     
     

-(void)tableView:(UITableView* )tableView didSelectRowAtIndexPath:(NSIndexPath* )indexPath
{
    
    SMVehiclelisting *selectedRowObject = (SMVehiclelisting*)[arrayOfBuyers objectAtIndex:indexPath.row];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        
        
        SMTradeSoldViewController *vcSMTradeSoldViewController = [[SMTradeSoldViewController alloc]initWithNibName:@"SMTradeSoldViewController" bundle:nil];
        vcSMTradeSoldViewController.vehicleObj = selectedRowObject;
        NSLog(@"sstrWinningBid = %@",vcSMTradeSoldViewController.vehicleObj.strWinningBid);
        [self.navigationController pushViewController:vcSMTradeSoldViewController animated:NO];
        
    }
    else
    {
        SMTradeSoldViewController *vcSMTradeSoldViewController = [[SMTradeSoldViewController alloc]initWithNibName:@"SMTradeSoldViewController_iPad" bundle:nil];
        vcSMTradeSoldViewController.vehicleObj = selectedRowObject;
        [self.navigationController pushViewController:vcSMTradeSoldViewController animated:NO];
        
    }

    
}


 #pragma mark - WEb Services

 -(void)webServiceForListingSales
 {
 [HUD show:YES];
 [HUD setLabelText:KLoaderText];
 NSMutableURLRequest *requestURL;


 requestURL = [SMWebServices listTradeSalesWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:self.strClientId.intValue andDateTimeFrom:@"0" andDateTimeTo:@"0" andPage:0 andPageSize:kPageSize];
 

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

-(NSString*)getOneMonthBackDateFromCurrentDate
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
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@:",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    NSMutableAttributedString *attributedFourthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",fourthText]
                                                                                             attributes:FourthAttribute];
    
    
    
    [attributedThirdText appendAttributedString:attributedFourthText];
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
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
    if ([elementName isEqualToString:@"UserName"])
    {
        objectVehicleListing.strUser = currentNodeContent;
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
            objectVehicleListing.strVehiclePrice = [[SMCommonClassMethods
                                                     
                                                     shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
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
            objectVehicleListing.strOfferAmount = @"R?";
        else
        {
            objectVehicleListing.strOfferAmount = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        }
    }
    if ([elementName isEqualToString:@"LoadDate"])
    {
        objectVehicleListing.strSoldDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ClientName"])
    {
        objectVehicleListing.strClientName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Sales"])
    {
        objectVehicleListing.strSalesCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TradeOffer"])
    {
        [arrayOfBuyers addObject:objectVehicleListing];
    }
    if ([elementName isEqualToString:@"SummeryItem"])
    {
        [arrayOfBuyers addObject:objectVehicleListing];
    }
    if ([elementName isEqualToString:@"ListTradeSalesResult"])
    {
        [table_BuyersInformation reloadData];
    }
    if ([elementName isEqualToString:@"TradeSalesSummaryResult"])
    {
        [table_BuyersInformation reloadData];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
