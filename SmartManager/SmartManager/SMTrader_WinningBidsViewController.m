//
//  SMTrader_WinningBidsViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 27/10/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMTrader_WinningBidsViewController.h"
#import "SMTraderWinningBidCell.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMCommonClassMethods.h"
#import "SMTradeSoldViewController.h"
#import "SMTraderBuyViewController.h"
#import "SMSellListDetailsViewController.h"
#include "UIBAlertView.h"
static int kPageSize=10;

typedef enum : NSUInteger
{
    wonVC = 0,
    lostVC,
    CancelledBidsVC,
    WithDrawnBidsVC,
    privateOfersVC

}viewControllerType;


@interface SMTrader_WinningBidsViewController ()

@end

@implementation SMTrader_WinningBidsViewController
@synthesize viewControllerBidType;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNib];
    [self addingProgressHUD];
    iCancelled = 0;
    iWithdrawn = 0;
    iPrivate = 0;
    iLost    = 0;
    iWon     = 0;
    isDefaultList = YES;
    
    self.arrayCancelledBids     = [[NSMutableArray alloc]init];
    self.arrayWithdrawnBids    = [[NSMutableArray alloc]init];
    self.arrayPrivateBids    = [[NSMutableArray alloc]init];
    self.arrayWon           = [[NSMutableArray alloc]init];
    self.arrayLost          = [[NSMutableArray alloc]init];
    tempDataArray           = [[NSMutableArray alloc]init];

    if([txtStartDate.text length]== 0 && [txtEndDate.text length]== 0)
    {
        NSString *outPutDate =  [self getOneMonthBackDateFromCurrentDateWithTime:NO];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
        
        txtStartDate.text = outPutDate;
        txtEndDate.text = textDate;
    }
    switch (self.viewControllerBidType)
    {
        case CancelledBidsVC:
        {
            [self setTheTitleForScreenAs:@"Bids Cancelled"];
            [self webServiceForCancelled];
        }
        break;
        case WithDrawnBidsVC:
        {
           [self setTheTitleForScreenAs:@"Bids Withdrawn"];
            [self webServiceForWithdrawn];
        }
        break;
        case wonVC:
        {
            [self setTheTitleForScreenAs:@"Won"];
            [self webServiceForWon];
        }
            break;
        case lostVC:
        {
            [self setTheTitleForScreenAs:@"Lost"];
            [self webServiceForLost];
        }
        break;
        case privateOfersVC:
        {
            [self setTheTitleForScreenAs:@"Private Offers"];
            [self webServiceForPrivate];
        }
            break;

            
        default:
            break;
    }
    
    tblViewMyBids.tableFooterView = [[UIView alloc]init];
    
    // Do any additional setup after loading the view from its nib.
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
       
        case wonVC:
        {
            return self.arrayWon.count;
        }
        break;
        case lostVC:
        {
            return self.arrayLost.count;
        }
        break;
        case CancelledBidsVC:
        {
          return self.arrayCancelledBids.count;
           
        }
            break;
        case WithDrawnBidsVC:
        {
           return self.arrayWithdrawnBids.count;
            
        }
            break;
        case privateOfersVC:
        {
            return self.arrayPrivateBids.count;
            
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
            
        case wonVC:
            objectVehicleListing = [self.arrayWon objectAtIndex:indexPath.row];
        break;
            
        case lostVC:
            objectVehicleListing = [self.arrayLost objectAtIndex:indexPath.row];
        break;
        case CancelledBidsVC:
        {
            objectVehicleListing = [self.arrayCancelledBids objectAtIndex:indexPath.row];
        }
        break;
        case WithDrawnBidsVC:
        {
            objectVehicleListing = [self.arrayWithdrawnBids objectAtIndex:indexPath.row];
            
        }
        break;
        case privateOfersVC:
        {
            objectVehicleListing = [self.arrayPrivateBids objectAtIndex:indexPath.row];
            
        }
            break;
        
            
        default:
            break;
    }
    
    UILabel *vehicleName;
    UILabel *lblVehicleDetails1;
    UILabel *lblVehicleDetails2;
    UILabel *lblVehicleDetails3;
    UILabel *lblSellerInfo;
    UIButton *btnPhoneNumberCall;
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightName = 0.0f;
    
    NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",objectVehicleListing.strVehicleYear,objectVehicleListing.strVehicleName];
    
    heightName = [self heightForText:strVehicleNameHeight];
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails1 = 0.0f;
    NSString *strVehicleDetails1;
    
    if([objectVehicleListing.strVehicleColor length] == 0 )
    {
        objectVehicleListing.strVehicleColor = @"Color?";
    }
    if(self.viewControllerBidType == 4)
    {
      strVehicleDetails1 = [NSString stringWithFormat:@"Private Seller: %@",objectVehicleListing.strClientName];
    }
    else
    {
        strVehicleDetails1 = [NSString stringWithFormat:@"%@ | %@ | %@",objectVehicleListing.strVehicleRegNo,objectVehicleListing.strVehicleColor, objectVehicleListing.strStockCode];
    }
    
    heightDetails1 = [self heightForText:strVehicleDetails1];
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails2 = 0.0f;
    NSString *strVehicleDetails2;
    if(self.viewControllerBidType == 4)
    {
        strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@ | %@",objectVehicleListing.strLocation,objectVehicleListing.strVehicleColor,objectVehicleListing.strVehicleMileage];
    }
    else
    {
        strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@",objectVehicleListing.strVehicleType,objectVehicleListing.strVehicleMileage];
    }
    
    heightDetails2 = [self heightForText:strVehicleDetails2];
    
    if (dynamicCell == nil)
    {
        dynamicCell = [[SMTraderWinningBidCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        vehicleName = [[UILabel alloc]init];
        lblVehicleDetails1 = [[UILabel alloc]init];
        lblVehicleDetails2 = [[UILabel alloc]init];
        lblVehicleDetails3 = [[UILabel alloc]init];
        lblSellerInfo = [[UILabel alloc]init];
         btnPhoneNumberCall = [[UIButton alloc]init];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            
            vehicleName.frame = CGRectMake(9.0, 6.0, 311.0, heightName);
            lblVehicleDetails1.frame = CGRectMake(9.0, vehicleName.frame.origin.y + vehicleName.frame.size.height+4.0, 311.0, heightDetails1);
            lblVehicleDetails2.frame = CGRectMake(9.0, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+4.0, 311.0, heightDetails2);
            lblVehicleDetails3.frame = CGRectMake(9.0, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+4.0, 311.0, 21);
            lblSellerInfo.frame = CGRectMake(9.0, lblVehicleDetails3.frame.origin.y + lblVehicleDetails3.frame.size.height+4.0, 200, 21);
            
            btnPhoneNumberCall.frame = CGRectMake(lblSellerInfo.frame.origin.x + lblSellerInfo.frame.size.width+4.0, lblSellerInfo.frame.origin.y , 120, 21);
            
            [btnPhoneNumberCall addTarget:self action:@selector(btnPhoneDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            vehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            lblSellerInfo.font = [UIFont fontWithName:FONT_NAME_BOLD size:13];
             btnPhoneNumberCall.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            
            
            
        }
        else
        {
            vehicleName.frame = CGRectMake(8.0, 8.0, 677.0, heightName);
            lblVehicleDetails1.frame = CGRectMake(8.0, vehicleName.frame.origin.y + vehicleName.frame.size.height+4.0, 677.0, heightDetails1);
            lblVehicleDetails2.frame = CGRectMake(8.0, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+4.0, 677.0, heightDetails2);
            lblVehicleDetails3.frame = CGRectMake(8.0, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+4.0, 677.0, 25);
            lblSellerInfo.frame = CGRectMake(8.0, lblVehicleDetails3.frame.origin.y + lblVehicleDetails3.frame.size.height+4.0, 677.0, 25);
            
            btnPhoneNumberCall.frame = CGRectMake(lblSellerInfo.frame.origin.x + lblSellerInfo.frame.size.width+4.0, lblSellerInfo.frame.origin.y , 400, 25);
            [btnPhoneNumberCall addTarget:self action:@selector(btnPhoneNumberDidClicked) forControlEvents:UIControlEventTouchUpInside];
            vehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            lblSellerInfo.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
             btnPhoneNumberCall.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            
        }
        
        vehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
        lblVehicleDetails1.textColor = [UIColor whiteColor];
        lblVehicleDetails2.textColor = [UIColor whiteColor];
        lblVehicleDetails3.textColor = [UIColor whiteColor];
        
        
        
        vehicleName.tag = 101;
        lblVehicleDetails1.tag = 103;
        lblVehicleDetails2.tag = 104;
        lblVehicleDetails3.tag = 105;
        
        [self setAttributedTextForVehicleDetailsWithFirstText:objectVehicleListing.strVehicleYear andWithSecondText:objectVehicleListing.strVehicleName forLabel:vehicleName];
        
        if(self.viewControllerBidType == 4)
        {
            lblVehicleDetails1.text = [NSString stringWithFormat:@"Private Seller: %@",objectVehicleListing.strClientName];
        }
        else
        {
            lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",objectVehicleListing.strVehicleRegNo,objectVehicleListing.strVehicleColor, objectVehicleListing.strStockCode];
        }
        
        
        if(self.viewControllerBidType == 4)
        {
            lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@ | %@",objectVehicleListing.strLocation,objectVehicleListing.strVehicleColor,objectVehicleListing.strVehicleMileage];
        }
        else
        {
            lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@",objectVehicleListing.strVehicleType,objectVehicleListing.strVehicleMileage];
        }
        
        
        NSString *status;
        UIColor *statusColor;
        switch (self.viewControllerBidType)
        {
                objectVehicleListing.strWinningBid=[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:objectVehicleListing.strWinningBid];
                
                objectVehicleListing.strMyBid=[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:objectVehicleListing.strWinningBid];
                
                objectVehicleListing.strAskingPrice=[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:objectVehicleListing.strWinningBid];
                
                objectVehicleListing.strOfferedPrice=[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:objectVehicleListing.strWinningBid];
                
            case wonVC:
            {
                status = @"Won";
                statusColor = [UIColor greenColor];
                
                [self setAttributedTextForVehicleDetailsWithFirstText:@"Sold to me for" andWithSecondText:objectVehicleListing.strOfferAmount andWithThirdText:@"" andWithFourthText:@"" andWithStatusText:status withStatusColor:statusColor forLabel:lblVehicleDetails3 withIsWonPage:YES];
            }
                break;
                
            case lostVC:
            {
                status = @"Lost";
                statusColor = [UIColor redColor];
                
               
                
                [self setAttributedTextForVehicleDetailsWithFirstText:@"Sold for" andWithSecondText:objectVehicleListing.strWinningBid andWithThirdText:@"My Bid" andWithFourthText:objectVehicleListing.strOfferAmount andWithStatusText:status withStatusColor:statusColor forLabel:lblVehicleDetails3 withIsWonPage:NO];
            }
            break;
            case CancelledBidsVC:
            {
                status = @"Cancelled";
                statusColor = [UIColor redColor];
                
                [self setAttributedTextForVehicleDetailsWithFirstText:@"Winning Bid" andWithSecondText:objectVehicleListing.strWinningBid andWithThirdText:@" My Bid" andWithFourthText:@"" andWithStatusText:status withStatusColor:statusColor forLabel:lblVehicleDetails3 withIsWonPage:NO];
            }
            break;
            case WithDrawnBidsVC:
            {
                status = @"Withdrawn";
                statusColor = [UIColor redColor];
                
                [self setAttributedTextForVehicleDetailsWithFirstText:@"Winning Bid" andWithSecondText:objectVehicleListing.strWinningBid andWithThirdText:@" My Bid" andWithFourthText:@"" andWithStatusText:status withStatusColor:statusColor forLabel:lblVehicleDetails3 withIsWonPage:NO];
            }
            break;
            case privateOfersVC:
            {
                [self setAttributedTextForVehicleDetailsWithFirstText:@"Asking" andWithSecondText:objectVehicleListing.strAskingPrice andWithThirdText:@" Offered" andWithFourthText:objectVehicleListing.strOfferedPrice andWithStatusText:@"" withStatusColor:nil forLabel:lblVehicleDetails3 withIsWonPage:NO];
            }
                break;

                
            default:
                break;
        }
        
       
        
        [dynamicCell.contentView addSubview:vehicleName];
        [dynamicCell.contentView addSubview:lblVehicleDetails1];
        [dynamicCell.contentView addSubview:lblVehicleDetails2];
        [dynamicCell.contentView addSubview:lblVehicleDetails3];
        if(self.viewControllerBidType == 0 || self.viewControllerBidType == 1)
        {
            if([objectVehicleListing.strClientName length] == 0)
               objectVehicleListing.strClientName = @"Seller?";
                
           lblSellerInfo.text = [NSString stringWithFormat:@"Seller: %@ | ",objectVehicleListing.strClientName];
            [lblSellerInfo sizeToFit];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
             btnPhoneNumberCall.frame = CGRectMake(lblSellerInfo.frame.origin.x + lblSellerInfo.frame.size.width, lblSellerInfo.frame.origin.y , 120, 21);
            }
            else
            {
                btnPhoneNumberCall.frame = CGRectMake(lblSellerInfo.frame.origin.x + lblSellerInfo.frame.size.width, lblSellerInfo.frame.origin.y , 250, 25);
            }
            [btnPhoneNumberCall setTitle:objectVehicleListing.strClientPhoneNumber forState:UIControlStateNormal];
            [btnPhoneNumberCall setTitleColor:[UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0] forState:UIControlStateNormal];
            lblSellerInfo.textColor = [UIColor whiteColor];
           
            btnPhoneNumberCall.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
           // btnPhoneNumberCall.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            [dynamicCell.contentView addSubview:lblSellerInfo];
            [dynamicCell.contentView addSubview:btnPhoneNumberCall];
        }
        else if (self.viewControllerBidType == 4)
        {
             lblSellerInfo.text = [NSString stringWithFormat:@"%@  %@",objectVehicleListing.strUser,objectVehicleListing.strOfferDate];
        }
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
            
        case wonVC:
        {
            if (self.arrayWon.count-1 == indexPath.row)
            {
               
                if (self.arrayWon.count != iTotalWon)
                {
                    ++iWon;
                    [self webServiceForWon];
                }
            }
        }
        break;
            
        case lostVC:
        {
            if (self.arrayLost.count-1 == indexPath.row)
            {
                if (self.arrayLost.count != iTotalLost)
                {
                    iLost++;
                    [self webServiceForLost];
                }
            }
        }
            
            break;
            
        case CancelledBidsVC:
        {
            if (self.arrayCancelledBids.count-1 == indexPath.row)
            {
                if (self.arrayCancelledBids.count != iTotalCancelled)
                {
                    iCancelled++;
                    [self webServiceForCancelled];
                }
            }
        }
           break;
        case WithDrawnBidsVC:
        {
            if (self.arrayWithdrawnBids.count-1 == indexPath.row)
            {
                if (self.arrayWithdrawnBids.count != iTotalWithdrawn)
                {
                    iWithdrawn++;
                    [self webServiceForWithdrawn];
                }
            }
        }
        break;
        case privateOfersVC:
        {
            if (self.arrayPrivateBids.count-1 == indexPath.row)
            {
                if (self.arrayPrivateBids.count != iTotalPrivateOffers)
                {
                    iPrivate++;
                    [self webServiceForPrivate];
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
                
            case wonVC:
                objectVehicleListing = [self.arrayWon objectAtIndex:indexPath.row];
                break;
                
            case lostVC:
                objectVehicleListing = [self.arrayLost objectAtIndex:indexPath.row];
                break;
                
            case WithDrawnBidsVC:
                objectVehicleListing = [self.arrayWithdrawnBids objectAtIndex:indexPath.row];
                break;
                
            case CancelledBidsVC:
                objectVehicleListing = [self.arrayCancelledBids objectAtIndex:indexPath.row];
                break;
                
            case privateOfersVC:
                objectVehicleListing = [self.arrayPrivateBids objectAtIndex:indexPath.row];
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
        NSString *strVehicleDetails1;
        
        if(self.viewControllerBidType == 4)
        {
            strVehicleDetails1 = [NSString stringWithFormat:@"Private Seller: %@",objectVehicleListing.strClientName];
        }
        else
        {
            strVehicleDetails1 = [NSString stringWithFormat:@"%@ | %@ | %@",objectVehicleListing.strVehicleRegNo,objectVehicleListing.strVehicleColor, objectVehicleListing.strStockCode];
        }
        
        heightDetails1 = [self heightForText:strVehicleDetails1];
        //----------------------------------------------------------------------------------------
        
        CGFloat heightDetails2 = 0.0f;
        NSString *strVehicleDetails2;
        if(self.viewControllerBidType == 4)
        {
            strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@ | %@",objectVehicleListing.strLocation,objectVehicleListing.strVehicleColor,objectVehicleListing.strVehicleMileage];
        }
        else
        {
            strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@",objectVehicleListing.strVehicleType,objectVehicleListing.strVehicleMileage];
        }
        
        heightDetails2 = [self heightForText:strVehicleDetails2];
        
        if( self.viewControllerBidType == 4)
        {
            finalDynamicHeight = (heightName + heightDetails1 + heightDetails2 + 21+21+19.0);
        }
        else if(self.viewControllerBidType == 0 || self.viewControllerBidType == 1) // won
        {
            finalDynamicHeight = (heightName + heightDetails1 + heightDetails2 + 21+21+30.0);
        }
        else
        {
            finalDynamicHeight = (heightName + heightDetails1 + heightDetails2 + 21+15.0);

        }
        
        return finalDynamicHeight+8;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath* )indexPath
{
    
    switch (self.viewControllerBidType)
    {
            
        case wonVC:
            objectVehicleListing = [self.arrayWon objectAtIndex:indexPath.row];
            break;
            
        case lostVC:
            objectVehicleListing = [self.arrayLost objectAtIndex:indexPath.row];
            break;
        case CancelledBidsVC:
        {
            objectVehicleListing = [self.arrayCancelledBids objectAtIndex:indexPath.row];
        }
            break;
        case WithDrawnBidsVC:
        {
            objectVehicleListing = [self.arrayWithdrawnBids objectAtIndex:indexPath.row];
            
        }
            break;
        case privateOfersVC:
        {
            objectVehicleListing = [self.arrayPrivateBids objectAtIndex:indexPath.row];
            
        }
            break;
            
            
        default:
            break;
    }

    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        if(self.viewControllerBidType == 0) // won
        {
            SMTradeSoldViewController *vcSMTradeSoldViewController = [[SMTradeSoldViewController alloc]initWithNibName:@"SMTradeSoldViewController" bundle:nil];
          vcSMTradeSoldViewController.strFromWhichScreen = @"SMTrader_WinningBidsViewController";
            vcSMTradeSoldViewController.vehicleObj = objectVehicleListing;
            [self.navigationController pushViewController:vcSMTradeSoldViewController animated:NO];
        }
        else if(self.viewControllerBidType == 1)
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
        else
        {
        
            __block SMTraderBuyViewController *myBidsDetailVC;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                myBidsDetailVC = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
                
                [[SMTraderBuyViewController alloc]initWithNibName:@"SMTraderBuyViewController" bundle:nil] :
                [[SMTraderBuyViewController alloc]initWithNibName:@"SMTraderBuyViewController_iPad" bundle:nil];
                myBidsDetailVC.isLabelMinBidHide = YES;
                myBidsDetailVC.vehicleObj = objectVehicleListing;
                
                myBidsDetailVC.strSelectedVehicleId = objectVehicleListing.strUsedVehicleStockID;
                
                [self.navigationController pushViewController:myBidsDetailVC animated:YES];
            });

            
        }
        
    }
    else
    {
        if(self.viewControllerBidType == 0)
        {
            SMTradeSoldViewController *vcSMTradeSoldViewController = [[SMTradeSoldViewController alloc]initWithNibName:@"SMTradeSoldViewController_iPad" bundle:nil];
             vcSMTradeSoldViewController.vehicleObj = objectVehicleListing;
            vcSMTradeSoldViewController.strFromWhichScreen = @"SMTrader_WinningBidsViewController";
            [self.navigationController pushViewController:vcSMTradeSoldViewController animated:NO];
        }
        else if(self.viewControllerBidType == 1)
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
        else
        {
            
            __block SMTraderBuyViewController *myBidsDetailVC;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                myBidsDetailVC = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
                
                [[SMTraderBuyViewController alloc]initWithNibName:@"SMTraderBuyViewController" bundle:nil] :
                [[SMTraderBuyViewController alloc]initWithNibName:@"SMTraderBuyViewController_iPad" bundle:nil];
                myBidsDetailVC.isLabelMinBidHide = YES;
                myBidsDetailVC.vehicleObj = objectVehicleListing;
                
                myBidsDetailVC.strSelectedVehicleId = objectVehicleListing.strUsedVehicleStockID;
                
                [self.navigationController pushViewController:myBidsDetailVC animated:YES];
            });
            
            
        }

        
    }
    

}

/*-(void)webServiceForWinningBid
{
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
*/
#pragma mark - WEb Services


-(void)webServiceForWon
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    
    NSMutableURLRequest *requestURL;
    if(isDefaultList)
    {
        NSString *outPutDate =  [self getOneMonthBackDateFromCurrentDateWithTime:YES];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
        
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
        NSLog(@"this is getting called111");
         requestURL = [SMWebServices bidsWonPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withFrom:outPutDate withTo:textDate withPage:iWon withPageSize:kPageSize];
        isDefaultList = NO;
    }
    else
    {
        
        
        NSLog(@"this is getting called222");
        requestURL = [SMWebServices bidsWonPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withFrom:txtStartDate.text withTo:txtEndDate.text withPage:iWon withPageSize:kPageSize];
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

-(void)webServiceForLost
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

     NSMutableURLRequest *requestURL;
    
    if(isDefaultList)
    {
        NSString *outPutDate =  [self getOneMonthBackDateFromCurrentDateWithTime:YES];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
        
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
   requestURL = [SMWebServices bidsLostPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withFrom:outPutDate withTo:textDate withPage:iLost withPageSize:kPageSize];
    }
    else
    {
        
        
        requestURL = [SMWebServices bidsLostPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withFrom:txtStartDate.text withTo:txtEndDate.text withPage:iLost withPageSize:kPageSize];

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
-(void)webServiceForCancelled
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    
    NSMutableURLRequest *requestURL;
    
    if(isDefaultList)
    {
        NSString *outPutDate =  [self getOneMonthBackDateFromCurrentDateWithTime:YES];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
        
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
         requestURL = [SMWebServices bidsCancelledPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withFrom:outPutDate withTo:textDate withPage:iCancelled withPageSize:kPageSize];
    
    }
    else
    {
        
        requestURL = [SMWebServices bidsCancelledPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withFrom:txtStartDate.text withTo:txtEndDate.text withPage:iCancelled withPageSize:kPageSize];
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
-(void)webServiceForWithdrawn
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    
    NSMutableURLRequest *requestURL;
    
    if(isDefaultList)
    {
        NSString *outPutDate =  [self getOneMonthBackDateFromCurrentDateWithTime:YES];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
        
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
        requestURL  = [SMWebServices bidsWithdrawnPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withFrom:outPutDate withTo:textDate withPage:iWithdrawn withPageSize:kPageSize];
    }
    else
    {
        
        requestURL  = [SMWebServices bidsWithdrawnPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withFrom:txtStartDate.text withTo:txtEndDate.text withPage:iWithdrawn withPageSize:kPageSize];
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
-(void)webServiceForPrivate
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices bidsPrivatePagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withFrom:txtStartDate.text withTo:txtEndDate.text withPage:iPrivate withPageSize:kPageSize];
    
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
    if ([elementName isEqualToString:@"Vehicle"])
    {
        objectVehicleListing  = [[SMVehiclelisting alloc] init];
    }
    if ([elementName isEqualToString:@"TradeOffer"])
    {
        objectVehicleListing  = [[SMVehiclelisting alloc] init];
    }
    if ([elementName isEqualToString:@"GetBuyingCountsResult"])
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
    if ([elementName isEqualToString:@"Department"])
    {
        objectVehicleListing.strVehicleType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Type"])
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
        //objectVehicleListing.strVehicleMileage = [NSString stringWithFormat:@"%@ Km",currentNodeContent];
        
        if ([currentNodeContent length] == 0 )
        {
            objectVehicleListing.strVehicleMileage = @"Mileage?";
        }
        else
        {
            NSString *strTemp = [NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager]mileageConvertEn_AF:currentNodeContent]];
            
            NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
            strTemp = [strTemp stringByTrimmingCharactersInSet:whitespace];
            
            objectVehicleListing.strVehicleMileage= strTemp;
        }

    }
    if ([elementName isEqualToString:@"Price"])
    {
        //objectVehicleListing.strVehiclePrice = currentNodeContent;
        objectVehicleListing.strVehiclePrice=[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:currentNodeContent];
        
        
    }
    if ([elementName isEqualToString:@"Location"])
    {
        objectVehicleListing.strLocation = currentNodeContent;
    }
    if ([elementName isEqualToString:@"StockCode"])
    {
        objectVehicleListing.strStockCode = currentNodeContent;
    }
    if ([elementName isEqualToString:@"OfferAmount"])
    {
        NSLog(@"1OfferAmount = %@",currentNodeContent);
         objectVehicleListing.strOfferAmount=[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:currentNodeContent];
         NSLog(@"2OfferAmount = %@",objectVehicleListing.strOfferAmount);
    }
    if ([elementName isEqualToString:@"UserName"])
    {
        objectVehicleListing.strUser = currentNodeContent;
    }
    if ([elementName isEqualToString:@"OfferStatus"])
    {
        objectVehicleListing.strOfferStatus = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Source"])
    {
        objectVehicleListing.strSource = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Highest"])
    {
         if(self.viewControllerBidType == 1)
             
        objectVehicleListing.strWinningBid = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"HeighestBid"])
    {
       // objectVehicleListing.strWinningBid = currentNodeContent.intValue;
       objectVehicleListing.strWinningBid = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
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
        if([currentNodeContent length] !=0 || ![currentNodeContent isEqualToString:@"(null)"])
            objectVehicleListing.strVehicleRegNo = currentNodeContent;
        else
           objectVehicleListing.strVehicleRegNo = @"Reg?";
    }
    if ([elementName isEqualToString:@"ClientName"])
    {
        objectVehicleListing.strClientName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ClientPhone"])
    {
        objectVehicleListing.strClientPhoneNumber = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TradePrice"])
    {
        //objectVehicleListing.strAskingPrice = currentNodeContent.intValue;
         objectVehicleListing.strAskingPrice = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"Amount"])
    {
        //objectVehicleListing.strOfferedPrice = currentNodeContent.intValue;
        objectVehicleListing.strOfferedPrice = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"Date"])
    {
        objectVehicleListing.strOfferDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Vehicle"])
    {
        if([objectVehicleListing.strVehicleRegNo length] == 0)
            objectVehicleListing.strVehicleRegNo = @"Reg?";
        [tempDataArray addObject:objectVehicleListing];
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
       /* if(totalRecordCount == 0)
        {
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"No record(s) found.." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel)
            {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                return;
                
            }
            
        }];
        }*/
    }
    
    if ([elementName isEqualToString:@"PrivateBidsPagedResult"])
    {
        [HUD hide:YES];
        iTotalPrivateOffers = totalRecordCount;
        [self.arrayPrivateBids addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    
    if ([elementName isEqualToString:@"CancelledBidsPagedResult"])
    {
        [HUD hide:YES];
        iTotalCancelled = totalRecordCount;
        [self.arrayCancelledBids addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    if ([elementName isEqualToString:@"WithdrawnBidsPagedResult"])
    {
        [HUD hide:YES];
        iTotalWithdrawn = totalRecordCount;
        [self.arrayWithdrawnBids addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }

    if ([elementName isEqualToString:@"BidsWonPagedResult"])
    {
        [HUD hide:YES];
        iTotalWon = totalRecordCount;
        [self.arrayWon addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    
    if ([elementName isEqualToString:@"BidsLostPagedResult"])
    {
        [HUD hide:YES];
        iTotalLost = totalRecordCount;
        [self.arrayLost addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if([objectVehicleListing.strWinningBid length] == 0 )
    {
         objectVehicleListing.strWinningBid = @"R?";
    }
    else if([objectVehicleListing.strOfferAmount length] == 0)
    {
       objectVehicleListing.strMyBid = @"R?";
    }
     [self hideProgressHUD];
    switch (self.viewControllerBidType)
    {
         
       
        case wonVC:
        {
            if(self.arrayWon.count == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Manager" message:@"No record(s) found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }
            break;
            
        case lostVC:
        {
            if(self.arrayLost.count == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Manager" message:@"No record(s) found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }
            break;
        case CancelledBidsVC:
        {
            if(self.arrayCancelledBids.count == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Manager" message:@"No record(s) found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }
            break;
        case WithDrawnBidsVC:
        {
            if(self.arrayWithdrawnBids.count == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Manager" message:@"No record(s) found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }
            break;
        case privateOfersVC:
        {
            if(self.arrayPrivateBids.count == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Manager" message:@"No record(s) found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
            }
        }
            break;
            
        default:
            break;
    }
    [tblViewMyBids reloadData];
   
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


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==txtStartDate)
    {
        //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        //        [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
        //        [self.datePicker setDate:[dateFormatter dateFromString:self.txtStartDate.text] animated:YES];
        
        selectedType = 0;
        [textField resignFirstResponder];
        [self loadPopUpView];
    }
    if (textField==txtEndDate)
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


#pragma mark - Button Actions

-(IBAction)btnSearchDidClicked:(id)sender
{
     if(self.arrayWon.count > 0)
         [self.arrayWon removeAllObjects];
    
    if(self.arrayLost.count > 0)
        [self.arrayLost removeAllObjects];
    
    if(self.arrayCancelledBids.count > 0)
        [self.arrayCancelledBids removeAllObjects];
    
    if(self.arrayWithdrawnBids.count > 0)
        [self.arrayWithdrawnBids removeAllObjects];
    
    [tblViewMyBids reloadData];
    
    if ( [self validate]==YES)
    {
        switch (self.viewControllerBidType)
        {
                
            case wonVC:
            {
                isDefaultList = NO;
                [self webServiceForWon];
            }
                break;
                
            case lostVC:
            {
                 isDefaultList = NO;
                [self webServiceForLost];
            }
                break;
            case CancelledBidsVC:
            {
                [self webServiceForCancelled];
            }
                break;
            case WithDrawnBidsVC:
            {
                [self webServiceForWithdrawn];
            }
                break;
            case privateOfersVC:
            {
                [self webServiceForPrivate];
            }
                break;
    
                
            default:
                break;
        }

    }
}
-(IBAction)btnCancelDidClicked:(id)sender
{
    [self hidePopUpView];
}

-(IBAction)btnDoneDidClicked:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datePicker.date]];
    
    if (selectedType==0)
    {
        startDate = datePicker.date;
        
        switch ([startDate compare:endDate])
        {
            case NSOrderedAscending:
            {
                [txtStartDate setText:textDate];
            }
                break;
                
            case NSOrderedDescending:
                [txtEndDate setText:@""];
                break;
                
            case NSOrderedSame:
                [txtStartDate setText:textDate];
                break;
        }
    }
    else if (selectedType==1)
    {
        endDate = datePicker.date;
        
        switch ([startDate compare:endDate])
        {
            case NSOrderedAscending:
                [txtEndDate setText:textDate];
                break;
                
            case NSOrderedDescending:
                [txtEndDate setText:@""];
                
                SMAlert(KLoaderTitle, KStartGreaterEnd);
                
                break;
                
            case NSOrderedSame:
                [txtEndDate setText:textDate];
                break;
        }
    }
    
    [self hidePopUpView];
}

- (IBAction)btnPhoneDidClicked:(id)sender
{
     //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",objectVehicleListing.strClientPhoneNumber]]];
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",@"9850739691"]]];
}

- (BOOL)validate
{
    if (!txtStartDate.text.length>0)
    {
        SMAlert(KLoaderTitle, KDateStart);
        
        return NO;
    }
    else if (!txtEndDate.text.length>0)
    {
        SMAlert(KLoaderTitle, KDateEnd);
        
        return NO;
    }
    else
        return YES;
}

-(NSString*)getOneMonthBackDateFromCurrentDateWithTime:(BOOL)timeNeeded
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if(timeNeeded)
      [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
    else
       [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:newDate]];
    return textDate;
}

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


-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText andWithStatusText:(NSString*)statusText withStatusColor:(UIColor*)statusColor forLabel:(UILabel*)label withIsWonPage:(BOOL)isWonPage;
{
    
    if([secondText length] == 0 || [secondText isEqualToString:@"(null)"])
    {
        secondText = @"";
    }
    if([fourthText length] == 0 || [fourthText isEqualToString:@"(null)"])
    {
        fourthText = @"";
    }
    
    
    UIFont *valueFont;
    UIFont *titleFont;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
       valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        if(isWonPage)
        {
            titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
        }
        else
         titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:10.0];   
   
    }
    
    else
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        
        if(isWonPage)
            titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        else
            titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorViolet = [UIColor colorWithRed:135.0/255.0 green:67.0/255.0 blue:198.0/255.0 alpha:1.0];
    UIColor *foregroundColorYellow = [UIColor colorWithRed:187.0/255.0 green:140.0/255.0 blue:20.0/255.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *SecondAttribute;
    
    if(isWonPage)
    {
        SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                           valueFont, NSFontAttributeName,
                           foregroundColorViolet, NSForegroundColorAttributeName, nil];
    }
    else
    {
        SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                           valueFont, NSFontAttributeName,
                           foregroundColorYellow, NSForegroundColorAttributeName, nil];
    }
    
   
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FourthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorViolet, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FifthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    statusColor, NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    NSMutableAttributedString *attributedFourthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",fourthText]
                                                                                            attributes:FourthAttribute];
    
    NSMutableAttributedString *attributedFifthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",statusText]
                                                                                            attributes:FifthAttribute];
    
    
    
    [attributedFourthText appendAttributedString:attributedFifthText];
    [attributedThirdText appendAttributedString:attributedFourthText];
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
