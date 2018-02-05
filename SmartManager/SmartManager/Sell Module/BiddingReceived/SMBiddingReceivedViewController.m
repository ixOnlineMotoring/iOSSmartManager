//
//  SMBiddingReceivedViewController.m
//  Smart Manager
//
//  Created by Jignesh on 02/11/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMBiddingReceivedViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMSellCustomCell.h"
#import "SMCustomColor.h"
#import "SMCommonClassMethods.h"
#import "UIBAlertView.h"
#import "SMActiveTradesViewController.h"
#import "SMTraderWinningBidCell.h"
static int kPageSize=10;

@interface SMBiddingReceivedViewController ()

@end

@implementation SMBiddingReceivedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addingProgressHUD];
    
    array_ActibeBids = [[NSMutableArray alloc] init];
    
    [self registerNib];
    iActiveBids = 0;

    array_ActibeBids = [[NSMutableArray alloc] init];

    [self webServiceListActiveBids];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setTitle:@"Active Bids Received"];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView)
    {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Franchise-Bold" size:15];
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}


-(void) addingProgressHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) registerNib
{

    [table_ReceivedBidding registerNib:[UINib nibWithNibName:@"SMSellCustomCell" bundle:nil] forCellReuseIdentifier:@"CellId"];
    
    [table_ReceivedBidding setTableFooterView:[[UIView alloc] init]];
    [table_ReceivedBidding setTableHeaderView:[[UIView alloc] init]];
    
    [table_ReceivedBidding setBackgroundColor:[UIColor clearColor]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - User Define Functions
- (void)webServiceListActiveBids
{
    
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    NSMutableURLRequest *requestURL = [SMWebServices listActiveBidsWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withPage:iActiveBids withPageSize:kPageSize];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             [HUD hide:YES];
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
#pragma mark -

#pragma mark - Table view Functions

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"SMTraderWinningBidCell";
    SMTraderWinningBidCell *dynamicCell;
    
    SMVehiclelisting *rowObject = (SMVehiclelisting*)[array_ActibeBids objectAtIndex:indexPath.row];
    
    UILabel *vehicleName;
    UILabel *lblVehicleDetails1;
    UILabel *lblVehicleDetails2;
    UILabel *lblVehicleDetails3;
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightName = 0.0f;
    
    NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",rowObject.strVehicleYear,rowObject.strVehicleName];
    
    heightName = [self heightForText:strVehicleNameHeight];
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails1 = 0.0f;
    NSString *strVehicleDetails1;
    
    if(rowObject.strVehicleRegNo.length == 0)
        rowObject.strVehicleRegNo = @"Reg?";
        
    strVehicleDetails1 = [NSString stringWithFormat:@"%@ | %@ | %@",rowObject.strVehicleRegNo,rowObject.strVehicleColor, rowObject.strStockCode];
    
    
    heightDetails1 = [self heightForText:strVehicleDetails1];
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails2 = 0.0f;
    NSString *strVehicleDetails2;
   
        strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@ | %@",rowObject.strVehicleType,rowObject.strVehicleMileage,rowObject.strVehicleAge];
   
    
    heightDetails2 = [self heightForText:strVehicleDetails2];
    
     //----------------------------------------------------------------------------------------
    
    if (dynamicCell == nil)
    {
        dynamicCell = [[SMTraderWinningBidCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        vehicleName = [[UILabel alloc]init];
        lblVehicleDetails1 = [[UILabel alloc]init];
        lblVehicleDetails2 = [[UILabel alloc]init];
        lblVehicleDetails3 = [[UILabel alloc]init];
      
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            
            vehicleName.frame = CGRectMake(6.0, 6.0, 311.0, heightName);
            lblVehicleDetails1.frame = CGRectMake(6.0, vehicleName.frame.origin.y + vehicleName.frame.size.height+4.0, 311.0, heightDetails1);
            lblVehicleDetails2.frame = CGRectMake(6.0, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+4.0, 311.0, heightDetails2);
            lblVehicleDetails3.frame = CGRectMake(6.0, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+4.0, 311.0, 21);
           
            
            vehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            
            
            
            
        }
        else
        {
            vehicleName.frame = CGRectMake(8.0, 8.0, 677.0, heightName);
            lblVehicleDetails1.frame = CGRectMake(8.0, vehicleName.frame.origin.y + vehicleName.frame.size.height+4.0, 677.0, heightDetails1);
            lblVehicleDetails2.frame = CGRectMake(8.0, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+4.0, 677.0, heightDetails2);
            lblVehicleDetails3.frame = CGRectMake(8.0, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+4.0, 677.0, 25);
            
            vehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            
        }
        
        vehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
        lblVehicleDetails1.textColor = [UIColor whiteColor];
        lblVehicleDetails2.textColor = [UIColor whiteColor];
        lblVehicleDetails3.textColor = [UIColor whiteColor];
        
        
        
        vehicleName.tag = 101;
        lblVehicleDetails1.tag = 103;
        lblVehicleDetails2.tag = 104;
        lblVehicleDetails3.tag = 105;
        
        [self setAttributedTextForVehicleDetailsWithFirstText:rowObject.strVehicleYear andWithSecondText:rowObject.strVehicleName forLabel:vehicleName];
           
        lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",rowObject.strVehicleRegNo,rowObject.strVehicleColor, rowObject.strStockCode];
       
           // lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@ | %@",rowObject.strVehicleType,rowObject.strVehicleMileage,rowObject.strVehicleAge];
        
        [self setAttributedTextForVehicleDetailsWithFirstText:rowObject.strVehicleType andWithSecondText:rowObject.strVehicleMileage andWithThirdText:rowObject.strVehicleAge forLabel:lblVehicleDetails2];
       
       
        
        [self setAttributedTextForVehiclePricesWithFirstText:@"Ret." andWithSecondText:rowObject.strOfferAmount andWithThirdText:@"|" andWithFourthText:@"Trd." andWithFifthText:rowObject.strVehicleTradePrice andWithSixthText:@"|" andWithSeventhText:@"Bid." andWithEighthText:rowObject.strTotalHighest forLabel:lblVehicleDetails3];
        
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
    
    if (array_ActibeBids.count-1 == indexPath.row)
    {
        if (array_ActibeBids.count != totalRecordCount)
        {
            iActiveBids++;
            [self webServiceListActiveBids];
        }
    }
    
    return dynamicCell;

}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [array_ActibeBids count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat finalDynamicHeight = 0.0f;
     SMVehiclelisting *selectedRowObject = (SMVehiclelisting*)[array_ActibeBids objectAtIndex:indexPath.row];
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightName = 0.0f;
    
    NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",selectedRowObject.strVehicleYear,selectedRowObject.strVehicleName];
    
    heightName = [self heightForText:strVehicleNameHeight];
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails1 = 0.0f;
    NSString *strVehicleDetails1;
    
    if(selectedRowObject.strVehicleRegNo.length == 0)
        selectedRowObject.strVehicleRegNo = @"Reg?";

    strVehicleDetails1 = [NSString stringWithFormat:@"%@ | %@ | %@",selectedRowObject.strVehicleRegNo,selectedRowObject.strVehicleColor, selectedRowObject.strStockCode];
    
    
    heightDetails1 = [self heightForText:strVehicleDetails1];
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails2 = 0.0f;
    NSString *strVehicleDetails2;
    
    strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@ | %@",selectedRowObject.strVehicleType,selectedRowObject.strVehicleMileage,selectedRowObject.strVehicleAge];
    
    
    heightDetails2 = [self heightForText:strVehicleDetails2];

    
    finalDynamicHeight = (heightName + heightDetails1 + heightDetails2 + 21+15.0);

    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        return finalDynamicHeight+8;
    else
        return finalDynamicHeight+15;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMVehiclelisting *selectedRowObject = (SMVehiclelisting*)[array_ActibeBids objectAtIndex:indexPath.row];
    
    __block SMActiveTradesViewController *sellDetailVC;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        sellDetailVC = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
        
        [[SMActiveTradesViewController alloc]initWithNibName:@"SMActiveTradesViewController" bundle:nil] :
        [[SMActiveTradesViewController alloc]initWithNibName:@"SMActiveTradesViewController_iPad" bundle:nil];
        
        sellDetailVC.navigationItem.titleView = [SMCustomColor setTitle:(indexPath.section == 0) ? @"Action: Bidding Ended" : @"Active Bids Received"];
        
        sellDetailVC.selectedVehicleObj = selectedRowObject;
        sellDetailVC.listingScreenPageNumber = 2;

        [self.navigationController pushViewController:sellDetailVC animated:YES];
    });
}



#pragma mark -



#pragma mark - XML parsing

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
    if ([elementName isEqualToString:@"Amount"])
    {
         objectVehicleListing.strVehiclePrice = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"OfferEnd"])
    {
        NSArray *arrayWithTwoStrings = [currentNodeContent componentsSeparatedByString:@" "];
        
        NSArray *hoursmint = [[arrayWithTwoStrings objectAtIndex:3]componentsSeparatedByString:@":"];
        
        objectVehicleListing.strBiddingClosed = [NSString stringWithFormat:@"%@h %@m",[hoursmint objectAtIndex:0],[hoursmint objectAtIndex:1]];
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        objectVehicleListing.strVehicleColor = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"MyHeighestBid"])
    {
        objectVehicleListing.strMyHighest = currentNodeContent;
    }
    if ([elementName isEqualToString:@"HeighestBid"])
    {
        objectVehicleListing.strTotalHighest = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"Department"])
    {
        objectVehicleListing.strVehicleType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Age"])
    {
        objectVehicleListing.strVehicleAge = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Registration"])
    {
        if([currentNodeContent length]==0 || [currentNodeContent isEqualToString:@"(null)"])
         objectVehicleListing.strVehicleRegNo = @"Reg?";
        else
        objectVehicleListing.strVehicleRegNo = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Location"])
    {
        objectVehicleListing.strLocation = currentNodeContent;
    }
    if ([elementName isEqualToString:@"FriendlyName"])
    {
        objectVehicleListing.strVehicleName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"UsedYear"])
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
    if ([elementName isEqualToString:@"RetailPrice"])
    {
        objectVehicleListing.strOfferAmount = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"TradePrice"])
    {
        /*if(currentNodeContent.intValue == 0)
            objectVehicleListing.strVehicleTradePrice = @"R?";
        else*/
        
         objectVehicleListing.strVehicleTradePrice = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    
    if ([elementName isEqualToString:@"IsTrade"])
    {
        objectVehicleListing.isTrade = [currentNodeContent boolValue];
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
         objectVehicleListing.strVehicleMileage = [NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent]];
    }
    if ([elementName isEqualToString:@"OfferAmount"])
    {
        objectVehicleListing.strOfferAmount = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
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
    if ([elementName isEqualToString:@"Total"])
    {
        totalRecordCount = [currentNodeContent intValue];
        if (totalRecordCount == 0)
        {
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:@"Smart Manager" message:@"No record(s) found." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            
                if (didCancel) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            
        }
    }
    if ([elementName isEqualToString:@"TradeOffer"])
    {
        [array_ActibeBids  addObject:objectVehicleListing];
    }
    
  
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [HUD hide:YES];
    [table_ReceivedBidding reloadData];
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

#pragma mark - Set Attributed Text

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    // UIColor *foregroundColorGreen = [UIColor colorWithRed:64.0/255.0 green:198.0/255.0 blue:42.0/255.0 alpha:1.0];
    
    
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
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" | %@ |",secondText]
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

-(void)setAttributedTextForVehiclePricesWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText andWithFifthText:(NSString*)fifthText andWithSixthText:(NSString*)sixthText andWithSeventhText:(NSString*)seventhText andWithEighthText:(NSString*) eighthText forLabel:(UILabel*)label
{
    UIFont *valueFont;
    UIFont *titleFont;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:11.0];
        
    }
    else
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorGreen = [UIColor colorWithRed:62.0/255.0 green:211.0/255.0 blue:22.0/255.0 alpha:1.0];
    UIColor *foregroundColorYellow = [UIColor colorWithRed:187.0/255.0 green:140.0/255.0 blue:20.0/255.0 alpha:1.0];
    UIColor *foregroundColorViolet = [UIColor colorWithRed:135.0/255.0 green:67.0/255.0 blue:198.0/255.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorGreen, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FourthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     titleFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FifthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorYellow, NSForegroundColorAttributeName, nil];
    
    NSDictionary *SixthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *SeventhAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                      titleFont, NSFontAttributeName,
                                      foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *EighthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorViolet, NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    NSMutableAttributedString *attributedFourthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",fourthText]
                                                                                             attributes:FourthAttribute];
    
    NSMutableAttributedString *attributedFifthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",fifthText]
                                                                                            attributes:FifthAttribute];
    
    NSMutableAttributedString *attributedSixthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",sixthText]
                                                                                            attributes:SixthAttribute];
    
    NSMutableAttributedString *attributedSeventhText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",seventhText]
                                                                                              attributes:SeventhAttribute];
    
    NSMutableAttributedString *attributedEighthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",eighthText]
                                                                                             attributes:EighthAttribute];
    
    
    [attributedSeventhText appendAttributedString:attributedEighthText];
    [attributedSixthText appendAttributedString:attributedSeventhText];
    [attributedFifthText appendAttributedString:attributedSixthText];
    [attributedFourthText appendAttributedString:attributedFifthText];
    [attributedThirdText appendAttributedString:attributedFourthText];
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

@end
