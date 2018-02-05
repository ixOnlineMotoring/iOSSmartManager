//
//  SMTradeVehicleListingViewController.m
//  Smart Manager
//
//  Created by Sandeep on 24/11/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMTradeVehicleListingViewController.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMCommonClassMethods.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"




@interface SMTradeVehicleListingViewController ()

@end

@implementation SMTradeVehicleListingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerNib];
    [self addingProgressHUD];
    tradeVechicleListArray = [[NSMutableArray alloc]init];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Trade Vehicles"];

    tradeVechicleTableView.delegate = self;
    tradeVechicleTableView.dataSource = self;
    
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        tradeVechicleTableView.layoutMargins = UIEdgeInsetsZero;
        tradeVechicleTableView.preservesSuperviewLayoutMargins = NO;
    }

    page = 0;
    pageSize=10;
    
     tradeVechicleTableView.tableFooterView = [[UIView alloc]init];

    [self getAvailableToTradePaged];
}

-(void)getAvailableToTradePaged{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices getAvailableToTradePagedWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andPage:page andPageSize:pageSize];

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];

    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
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
- (void)registerNib
{
    [tradeVechicleTableView registerNib:[UINib nibWithNibName:@"SMTraderWinningBidCell" bundle:nil] forCellReuseIdentifier:@"SMTraderWinningBidCell"];
}

#pragma mark - UITableViewDataSource

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tradeVechicleListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"SMTraderWinningBidCell";

    SMTraderWinningBidCell *dynamicCell;

    SMVehiclelisting *objectVehicleListingNew = (SMVehiclelisting *)[tradeVechicleListArray objectAtIndex:indexPath.row];

    UILabel *vehicleName;
    UILabel *lblVehicleDetails1;
    UILabel *lblVehicleDetails2;
    UILabel *lblVehicleDetails3;
    //----------------------------------------------------------------------------------------

    CGFloat heightName = 0.0f;

    NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",objectVehicleListingNew.strVehicleYear,objectVehicleListingNew.strVehicleName];

    heightName = [self heightForText:strVehicleNameHeight];

    //----------------------------------------------------------------------------------------

    CGFloat heightDetails1 = 0.0f;
    NSString *strVehicleDetails1;

    //objectVehicleListingNew.strVehicleRegNo = @"ND 12345";
    strVehicleDetails1 = [NSString stringWithFormat:@"%@ | %@ | %@ ",objectVehicleListingNew.strVehicleRegNo,objectVehicleListingNew.strVehicleColor,objectVehicleListingNew.strStockCode];

    heightDetails1 = [self heightForText:strVehicleDetails1];
    //----------------------------------------------------------------------------------------

    CGFloat heightDetails2 = 0.0f;
    NSString *strVehicleDetails2;

    //objectVehicleListingNew.strVehicleAge = @"162 Days";
    strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@ | %@ ",objectVehicleListingNew.strVehicleType,objectVehicleListingNew.strVehicleMileage,objectVehicleListingNew.strVehicleAge];

    heightDetails2 = [self heightForText:strVehicleDetails2];




    CGFloat heightDetails3 = 0.0f;
    NSString *strVehicleDetails3;
    strVehicleDetails3 = [NSString stringWithFormat:@"%@ | %@ | %@",objectVehicleListingNew.strVehicleType,objectVehicleListingNew.strVehicleMileage,objectVehicleListingNew.strVehicleAge];


    heightDetails3 = [self heightForText:strVehicleDetails3];



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
            lblVehicleDetails3.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];

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
             lblVehicleDetails3.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        }

        vehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
        lblVehicleDetails1.textColor = [UIColor whiteColor];
        lblVehicleDetails2.textColor = [UIColor whiteColor];
        lblVehicleDetails3.textColor = [UIColor whiteColor];

        vehicleName.tag = 101;
        lblVehicleDetails1.tag = 103;
        lblVehicleDetails2.tag = 104;
        lblVehicleDetails3.tag = 105;

        [self setAttributedTextForVehicleDetailsWithFirstText:objectVehicleListingNew.strVehicleYear andWithSecondText:objectVehicleListingNew.strVehicleName forLabel:vehicleName];

        lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@ ",objectVehicleListingNew.strVehicleRegNo,objectVehicleListingNew.strVehicleColor,objectVehicleListingNew.strStockCode];

        lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@ | %@",objectVehicleListingNew.strVehicleType,objectVehicleListingNew.strVehicleMileage,objectVehicleListingNew.strVehicleAge];

        [self setAttributedTextForVehiclePricesWithFirstText:@"Ret." andWithSecondText:objectVehicleListingNew.strOfferAmount andWithThirdText:@"|" andWithFourthText:@"Trd." andWithFifthText:objectVehicleListingNew.strVehicleTradePrice andWithSixthText:@"|" andWithSeventhText:@"Bid." andWithEighthText:objectVehicleListingNew.strTotalHighest forLabel:lblVehicleDetails3];
        

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

    if (tradeVechicleListArray.count-1 == indexPath.row)
    {
        if (tradeVechicleListArray.count != totalRecordCount)
        {
            page++;
            [self getAvailableToTradePaged];
        }
    }
    
    dynamicCell.backgroundColor = [UIColor blackColor];

    return dynamicCell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    {
        SMVehiclelisting *objectVehicleListingNew = (SMVehiclelisting *)[tradeVechicleListArray objectAtIndex:indexPath.row];


        CGFloat finalDynamicHeight = 0.0f;
       
        //----------------------------------------------------------------------------------------

        CGFloat heightName = 0.0f;

        NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",objectVehicleListingNew.strVehicleYear,objectVehicleListingNew.strVehicleName];

        heightName = [self heightForText:strVehicleNameHeight];

        //----------------------------------------------------------------------------------------

        CGFloat heightDetails1 = 0.0f;
        NSString *strVehicleDetails1;

        strVehicleDetails1 = [NSString stringWithFormat:@"%@ | %@ | %@ ",objectVehicleListingNew.strVehicleRegNo,objectVehicleListingNew.strVehicleColor,objectVehicleListingNew.strStockCode];

        heightDetails1 = [self heightForText:strVehicleDetails1];
        //----------------------------------------------------------------------------------------

        CGFloat heightDetails2 = 0.0f;
        NSString *strVehicleDetails2;

        strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@ | %@",objectVehicleListingNew.strVehicleType,objectVehicleListingNew.strVehicleMileage,objectVehicleListingNew.strVehicleAge];
        
        heightDetails2 = [self heightForText:strVehicleDetails2];


        finalDynamicHeight = (heightName + heightDetails1 + heightDetails2 + 21+21+6);
        return finalDynamicHeight;

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     SMVehiclelisting *selectedVehicleObject = (SMVehiclelisting *)[tradeVechicleListArray objectAtIndex:indexPath.row];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        SMActiveTradesViewController *activeTrade = [[SMActiveTradesViewController alloc] initWithNibName:@"SMActiveTradesViewController" bundle:nil];
        
        activeTrade.selectedVehicleObj = selectedVehicleObject;
        activeTrade.listingScreenPageNumber = 3;

        [self.navigationController pushViewController:activeTrade animated:YES];
        

    }
    else{
        SMActiveTradesViewController *activeTrade = [[SMActiveTradesViewController alloc] initWithNibName:@"SMActiveTradesViewController_iPad" bundle:nil];
        
        
        activeTrade.selectedVehicleObj = selectedVehicleObject;
        activeTrade.listingScreenPageNumber = 3;
        [self.navigationController pushViewController:activeTrade animated:YES];
        

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

#pragma mark - NSXMLParser Delegate Methods
- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    if ([elementName isEqualToString:@"Vehicle"])
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
    NSLog(@"elementName %@  currentNodeContent %@",elementName,currentNodeContent);

    if ([elementName isEqualToString:@"UsedVehicleStockID"])
    {
        objectVehicleListing.strUsedVehicleStockID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Type"])
    {
        if([currentNodeContent length] == 0)
            objectVehicleListing.strVehicleType = @"Type?";
        else
             objectVehicleListing.strVehicleType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Age"])
    {
        if([currentNodeContent length] == 0)
            objectVehicleListing.strVehicleAge = @"Age?";
        else
        objectVehicleListing.strVehicleAge = [NSString stringWithFormat:@"%@ Days",currentNodeContent];
    }
    if ([elementName isEqualToString:@"IsTrade"])
    {
    objectVehicleListing.isTrade = [currentNodeContent boolValue];
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
    if ([elementName isEqualToString:@"Registration"])
    {
        if([currentNodeContent length] == 0)
            objectVehicleListing.strVehicleRegNo = @"Reg?";
        else
            objectVehicleListing.strVehicleRegNo = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
        objectVehicleListing.strVehicleMileage = [NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent]];
    }
    if ([elementName isEqualToString:@"Price"])
    {
        objectVehicleListing.strVehicleTradePrice=[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:currentNodeContent];
    }
    if ([elementName isEqualToString:@"RetailPrice"])
    {
        objectVehicleListing.strOfferAmount=[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:currentNodeContent];
    }
    if ([elementName isEqualToString:@"OfferAmount"])
    {
        objectVehicleListing.strTotalHighest=[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:currentNodeContent];
    }
    if ([elementName isEqualToString:@"Location"])
    {
        objectVehicleListing.strLocation = currentNodeContent;
    }
    if ([elementName isEqualToString:@"StockCode"])
    {
        objectVehicleListing.strStockCode = currentNodeContent;
    }
    /*if ([elementName isEqualToString:@"OfferAmount"])
    {
        objectVehicleListing.strOfferAmount=[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:currentNodeContent];
    }*/

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
        objectVehicleListing.strOfferEnd= currentNodeContent;
    }

    if ([elementName isEqualToString:@"Vehicle"])
    {
        [tradeVechicleListArray addObject:objectVehicleListing];
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

}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"reached here...");
    [tradeVechicleTableView reloadData];
    [self hideProgressHUD];
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

-(void)setAttributedTextForVehiclePricesWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText andWithFifthText:(NSString*)fifthText andWithSixthText:(NSString*)sixthText andWithSeventhText:(NSString*)seventhText andWithEighthText:(NSString*)eighthText forLabel:(UILabel*)label
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
    // ret.
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorGreen, NSForegroundColorAttributeName, nil];
    // green value
    
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    // pipe
    
    NSDictionary *FourthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     titleFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    // Trd.
    
    NSDictionary *FifthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorYellow, NSForegroundColorAttributeName, nil];
    
    NSDictionary *SixthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];

    
    
    // yellow vlaue
    
    NSDictionary *SeventhAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    // Bid.
    
    NSDictionary *EighthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                      valueFont, NSFontAttributeName,
                                      foregroundColorViolet, NSForegroundColorAttributeName, nil];
    // violet color
    
    
    
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
    
    NSMutableAttributedString *attributedSixthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",sixthText]
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
#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
