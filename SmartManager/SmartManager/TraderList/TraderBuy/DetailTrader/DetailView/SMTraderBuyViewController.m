//
//  SMTraderBuyViewController.m
//  SmartManager
//
//  Created by Ketan Nandha on 23/03/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMTraderBuyViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMCustomColor.h"
#import "SMTradeDetailSlider.h"
#import "UIImageView+WebCache.h"
#import "SMDetailTableViewCell.h"
#import "SMCommonClassMethods.h"
#import "UIBAlertView.h"
#import "SMAppDelegate.h"
#import "SMCustomDynamicCell.h"
#import "UIBAlertView.h"


@interface SMTraderBuyViewController ()

@end

@implementation SMTraderBuyViewController
@synthesize vehicleListDelegates,strSelectedVehicleId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addingProgressHUD];
    [self addKeyBoardToolbar];
    [self registerNib];
    appdelegate=(SMAppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isRefreshUI=NO;
    self.tableBuy.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     self.tableVehicleListing.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableBuy.separatorStyle = UITableViewCellSeparatorStyleNone;
    isSectionFirstExpanded = NO;
    isSectionSecondExpanded = NO;
    isSectionThirdExpanded = NO;
    isQuestionsMainTagEntered = NO;
     self.viewHoldingCommentTextField.tag = 1000;
    [self.buttonPlaceBid                setExclusiveTouch:YES];
    [self.buttonBuyNow                  setExclusiveTouch:YES];
    [self.buttonAutomatedBidding        setExclusiveTouch:YES];
    [self.btnCancelForExpandableView    setExclusiveTouch:YES];
    [self.btnActivateForExpandableView  setExclusiveTouch:YES];
    
    arrayVehicleListing     = [[NSMutableArray alloc]init];
    arrayVehicleDetail      = [[NSMutableArray alloc]init];
    arrayTradeSliderDetails = [[NSMutableArray alloc]init];
    arrayFullImages         = [[NSMutableArray alloc]init];
    arrayVehicleImages      = [[NSMutableArray alloc]init];
    arrayOfMessages = [[NSMutableArray alloc]init];
#warning Sandeep - Remove Expiry?
    if([self.vehicleObj.strVehicleTeadeTimeLeft length] == 0)
//        self.vehicleObj.strVehicleTeadeTimeLeft = @"Expiry?";
        self.vehicleObj.strVehicleTeadeTimeLeft = @"";

    if([self.vehicleObj.strLocation length] == 0)
        self.vehicleObj.strLocation = @"Location?";
    
    [self loadingAllDetails];
    
    self.textFieldPlaceBid.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.textFieldPlaceBid.layer.borderWidth= 1.0f;
   // self.textFieldPlaceBid.layer.bor
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                   withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];
}


#pragma mark - UITablewView Datasource Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==self.tableBuy)
    {
        switch (section)
        {
            case 0:
            {
                
                if (self.buttonAutomatedBidding.selected)
                {
                    return 7;
                }
                else
                {
                    return 6;
                }
 
            }
            break;
            case 1:
            {
                if (isSectionSecondExpanded)
                {
                    return arrayOfMessages.count + 1;
                }
                return 0;
            }
                break;
            case 2:
            {
                if (isSectionThirdExpanded)
                {
                    if(totalSellerReviews > 0)
                        return 1;
                    else
                        return 0;
                }
                return 0;
            }
                break;
                
            default:
                break;
        }
    }
    else if (tableView==self.tableVehicleListing && section == 0)
    {
        switch (section)
        {
            case 0:
            {
                return arrayVehicleListing.count;
            }
                break;
                
            default:
                break;
        }
        
    }
    
    return 0;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *mainCell;
    if (tableView==self.tableBuy)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                static NSString *cellIdentifier = @"Cell";
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if (!cell)
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                else
                {
                    for (UIView *viw in cell.contentView.subviews)
                    {
                        [viw removeFromSuperview];
                    }
                }
                
                switch (indexPath.row)
                {
                    case 0:
                    {
                        [self cellForFirstRow:cell];
                       
                        
                    }
                        break;
                        
                    case 1:
                        if (arrayTradeSliderDetails.count!=0)
                        {
                            [cell.contentView addSubview:self.viewCollection];
                        }
                        break;
                        
                    case 2:
                        if (self.strBidValue.intValue!=0)
                        {
                            [cell.contentView addSubview:self.viewPlacedBid];
                        }
                        break;
                        
                    case 3:
                        if (self.strBidValue.intValue!=0)
                        {
                            [cell.contentView addSubview:self.viewAutomatedBidding];
                        }
                        break;
                        
                    case 4:
                        if (self.buttonAutomatedBidding.selected)
                        {
                            [cell.contentView addSubview:self.viewAutomatedExpanded];
                        }
                        else
                        {
                            if (self.strBuyNowValue.intValue!=0)
                            {
                                [cell.contentView addSubview:self.viewBuyNow];
                            }
                        }
                        break;
                        
                    case 5:
                        if (self.buttonAutomatedBidding.selected)
                        {
                            if (self.strBuyNowValue.intValue!=0)
                            {
                                [cell.contentView addSubview:self.viewBuyNow];
                            }
                        }
                        else
                        {
                            [self.tableVehicleListing removeFromSuperview];
                            [cell.contentView addSubview:self.tableVehicleListing];
                        }
                        break;
                        
                    case 6:
                    {
                        [self.tableVehicleListing removeFromSuperview];
                        [cell.contentView addSubview:self.tableVehicleListing];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                mainCell = cell;

            }
            break;
                
            case 1:
            {
                
                
                static NSString *cellIdentifier3= @"SMCustomDynamicCell";
                
                SMCustomDynamicCell     *dynamicCell;
                UILabel *lblSellerName;
                UILabel *lblMessageTime;
                UILabel *lblMessage;
                CGFloat heightMessage = 0.0f;
                CGFloat heightName = 0.0f;

                if(arrayOfMessages.count != indexPath.row)
                {
                
                SMVehiclelisting *rowObject = (SMVehiclelisting*)[arrayOfMessages objectAtIndex:indexPath.row];
                
               
                //----------------------------------------------------------------------------------------
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    heightMessage = [self heightForTextForSecondSection:rowObject.strMessage andTextWidthForiPhone:180];
                }
                else
                {
                    heightMessage = [self heightForTextForSecondSection:rowObject.strMessage andTextWidthForiPhone:570];
                }
                
                
                //----------------------------------------------------------------------------------------
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    heightName = [self heightForTextForSecondSection:rowObject.strClientName andTextWidthForiPhone:120];
                }
                else
                {
                    heightName = [self heightForTextForSecondSection:rowObject.strClientName andTextWidthForiPhone:200];
                }
                
                //----------------------------------------------------------------------------------------

                rowObject = nil;
                }
                
                if (dynamicCell == nil)
                {
                    dynamicCell = [[SMCustomDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
                    
                    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        lblSellerName = [[UILabel alloc] initWithFrame:CGRectMake(8,5,120,heightName)];
                        
                        lblMessageTime = [[UILabel alloc] initWithFrame:CGRectMake(8,lblSellerName.frame.origin.y + lblSellerName.frame.size.height + 1.0,lblSellerName.frame.size.width,21)];
                        
                        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(lblSellerName.frame.origin.x + lblSellerName.frame.size.width + 6.0,lblSellerName.frame.origin.y,180,heightMessage)];
                        
                        lblSellerName.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
                        lblMessageTime.font = [UIFont fontWithName:FONT_NAME_BOLD size:10];
                        lblMessage.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
                        
                    }
                    else
                    {
                        lblSellerName = [[UILabel alloc] initWithFrame:CGRectMake(8,5,200,heightName)];
                        lblMessageTime = [[UILabel alloc] initWithFrame:CGRectMake(8,lblSellerName.frame.origin.y + lblSellerName.frame.size.height + 2.0,lblSellerName.frame.size.width,25)];
                        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(lblSellerName.frame.origin.x + lblSellerName.frame.size.width + 6.0,lblSellerName.frame.origin.y,570,heightMessage)];
                        
                        lblSellerName.font = [UIFont fontWithName:FONT_NAME_BOLD size:18];
                        lblMessageTime.font = [UIFont fontWithName:FONT_NAME_BOLD size:15];
                        lblMessage.font = [UIFont fontWithName:FONT_NAME_BOLD size:18];
                        
                    }
                    
                    
                    lblMessage.textColor = [UIColor whiteColor];
                    lblSellerName.textColor = [UIColor colorWithRed:43.0/255 green:133.0/255 blue:199.0/255 alpha:1.0];
                    lblMessageTime.textColor = [UIColor whiteColor];
                    
                    
                    lblSellerName.tag = 101;
                    lblMessageTime.tag = 102;
                    lblMessage.tag = 103;
                }
                else
                {
                    lblSellerName = (UILabel *)[dynamicCell.contentView viewWithTag:101];
                    lblMessageTime = (UILabel *)[dynamicCell.contentView viewWithTag:102];
                    lblMessage = (UILabel *)[dynamicCell.contentView viewWithTag:103];
                }
                
                SMVehiclelisting *rowMessageObject;
                
                [[dynamicCell.contentView viewWithTag:1000]removeFromSuperview];
                
                if(arrayOfMessages.count == indexPath.row)
                {
                    lblSellerName.text = @"";
                    lblMessage.text = @"";
                    lblMessageTime.text = @"";
                    
                    [dynamicCell.contentView addSubview:self.viewHoldingCommentTextField];
                }
                else
                {
                     rowMessageObject = (SMVehiclelisting*)[arrayOfMessages objectAtIndex:indexPath.row];
                    
                    lblSellerName.text = rowMessageObject.strClientName;
                    lblMessage.text = rowMessageObject.strMessage;
                    lblMessageTime.text = rowMessageObject.strSoldDate;
                    
                  
                    
                }
                
               
                
                
                [dynamicCell.contentView addSubview:lblSellerName];
                [dynamicCell.contentView addSubview:lblMessageTime];
                [dynamicCell.contentView addSubview:lblMessage];
                dynamicCell.backgroundColor = [UIColor blackColor];
                
                lblMessage.numberOfLines = 0;
                [lblMessage sizeToFit];
                
                lblSellerName.numberOfLines = 0;
                [lblSellerName sizeToFit];
                
                mainCell = dynamicCell;
                

            }
            break;
                
             case 2:
            {
                static NSString *cellIdentifier = @"Cell";
                
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if (!cell)
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                else
                {
                    for (UIView *viw in cell.contentView.subviews)
                    {
                        [viw removeFromSuperview];
                    }
                }
                
                if(indexPath.row == 0)
                {
                     if(totalSellerReviews > 0)
                     {
                         self.lblReviewsCount.text = [NSString stringWithFormat:@"%d Reviews", totalSellerReviews];
                        
                         for(int i = 0; i<arrayOfRateQuestions.count; i++)
                         {
                             switch (i)
                             {
                                 case 0:
                                 {
                                     SMRateBuyerObject *rateObject = (SMRateBuyerObject*)[arrayOfRateQuestions objectAtIndex:i];
                                     
                                     lblFirstQuestion.text = rateObject.strRateBuyerQuestion;
                                     self.lblPriceChange.text = [NSString stringWithFormat:@"%@ / 12",rateObject.strRateBuyerRatting];
                                 }
                                break;
                                 case 1:
                                 {
                                     SMRateBuyerObject *rateObject = (SMRateBuyerObject*)[arrayOfRateQuestions objectAtIndex:i];
                                     
                                     lblSecondQuestion.text = rateObject.strRateBuyerQuestion;
                                     self.lblVehicleDescribed.text = [NSString stringWithFormat:@"%@ / 12",rateObject.strRateBuyerRatting];

                                     
                                 }
                                break;
                                 case 2:
                                 {
                                     SMRateBuyerObject *rateObject = (SMRateBuyerObject*)[arrayOfRateQuestions objectAtIndex:i];
                                     
                                     lblThirdQuestion.text = rateObject.strRateBuyerQuestion;
                                     self.lblVehicleDispatched.text = [NSString stringWithFormat:@"%@ / 12",rateObject.strRateBuyerRatting];

                                 }
                                break;
                                     
                                 default:
                                     break;
                             }
                         
                         }
                         
                         
                         
                         [cell.contentView addSubview:self.viewHoldingRatingValues];
                     }
                    
                    mainCell = cell;
                }
                else
                    return nil;
            }
                break;
                
             default:
                break;
        }
        
               //return cell;
    }
    else if(tableView==self.tableVehicleListing)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                static NSString  *CellIdentifier = @"Cell";
                
                SMDetailTableViewCell  *cell = (SMDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                SMDetailTrade *objectInCellForRow = (SMDetailTrade *) [arrayVehicleListing objectAtIndex:indexPath.row];
                
                objectInCellForRow.strValue = [[objectInCellForRow.strValue componentsSeparatedByString:@"."] objectAtIndex:0];
                [cell.labelVehicleValue setText:objectInCellForRow.strValue];
                
                [cell.labelVehicleKey   setText:objectInCellForRow.strKey];
                if([cell.labelVehicleKey.text isEqualToString:@"Highest Bid So Far"])
                {
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        cell.labelVehicleKey.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                        cell.labelVehicleValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                    }
                    else
                    {
                        cell.labelVehicleKey.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                        cell.labelVehicleValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                    }
                }
                
                cell.backgroundColor  = [UIColor clearColor];
                
                mainCell = cell;
            }
                break;
                
            default:
                break;
        }
        
    }
    mainCell.backgroundColor = [UIColor blackColor];
    return mainCell;
    
}

-(void)cellForFirstRow:(UITableViewCell*)dynamicCell
{
    
    UILabel *lblVehicleName;
    UILabel *lblVehicleDetails1;
    UILabel *lblVehicleDetails2;
    
    UILabel *lblMyBidValue;
    UILabel *lblWinBeatValue;
    
    UIImageView *imgViewVehicle;
    UIButton *btnVehicleBigImage;
    UIImageView *imgViewBuyNow;
    
    UILabel *lblMinBidPrice;
    
    CGFloat heightName = 0.0f;
    
    NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",self.vehicleObj.strVehicleYear,self.vehicleObj.strVehicleName];
    
    heightName = [self heightForText:strVehicleNameHeight];
    
    CGFloat heightDetails1 = 0.0f;
    
    if(![self.vehicleObj.strVehicleMileage containsString:@"Km"])
    {
        self.vehicleObj.strVehicleMileage = [NSString stringWithFormat:@"%@%@",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:self.vehicleObj.strVehicleMileage],@"Km"];
    }
   
    NSLog(@"Mileageee = %@",self.vehicleObj.strVehicleMileage);
    
    NSString *strDetails1Height = [NSString stringWithFormat:@"%@ | %@",self.vehicleObj.strVehicleMileage,self.vehicleObj.strVehicleColor];
    
    heightDetails1 = [self heightForText:strDetails1Height];
    
    CGFloat heightDetails2 = 0.0f;
    
    NSString *strDetails2Height = [NSString stringWithFormat:@"%@ | %@",self.vehicleObj.strLocation,[NSString stringWithFormat:@"Exp. %@",self.vehicleObj.strVehicleTeadeTimeLeft]];
    
    heightDetails2 = [self heightForText:strDetails2Height];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        imgViewVehicle = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10.0, 120.0, 110.0)];
         [imgViewVehicle setContentMode:UIViewContentModeScaleAspectFill];
         imgViewVehicle.clipsToBounds = YES;
        btnVehicleBigImage = [[UIButton alloc] initWithFrame:CGRectMake(5.0, 10.0, 120.0, 110.0)];
       [btnVehicleBigImage addTarget:self action:@selector(buttonImageClickableDidPressed:) forControlEvents:UIControlEventTouchUpInside];
        lblMinBidPrice = [[UILabel alloc]initWithFrame:CGRectMake(imgViewVehicle.frame.origin.x, imgViewVehicle.frame.origin.y + imgViewVehicle.frame.size.height + 1.0, 120, 21)];
        imgViewBuyNow = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 38.0, 36.0)];
        
        
        lblVehicleName = [[UILabel alloc] initWithFrame:CGRectMake(132,5,187,heightName)];
        lblVehicleDetails1 = [[UILabel alloc] initWithFrame:CGRectMake(129,lblVehicleName.frame.origin.y + lblVehicleName.frame.size.height + 2.0,187,heightDetails1)];
        lblVehicleDetails2 = [[UILabel alloc] initWithFrame:CGRectMake(132,lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height + 2.0,187,heightDetails2)];
        
        lblMyBidValue = [[UILabel alloc] initWithFrame:CGRectMake(132,lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height + 2.0,187,21)];
        
        lblWinBeatValue = [[UILabel alloc] initWithFrame:CGRectMake(132,lblMyBidValue.frame.origin.y + lblMyBidValue.frame.size.height + 2.0,187,21)];
        
        
        
        lblVehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
        lblVehicleDetails1.textColor = [UIColor whiteColor];
        lblVehicleDetails2.textColor = [UIColor whiteColor];
        lblWinBeatValue.textColor = [UIColor whiteColor];
        //lblMyBidValue.textColor = [UIColor whiteColor];
        
        lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        lblMyBidValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        lblWinBeatValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        
        
        
    }
    else
    {
        imgViewVehicle = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 6.0, 180.0, 135.0)];
        [imgViewVehicle setContentMode:UIViewContentModeScaleAspectFill];
         imgViewVehicle.clipsToBounds = YES;
         btnVehicleBigImage = [[UIButton alloc] initWithFrame:CGRectMake(2.0, 6.0, 180.0, 135.0)];
        [btnVehicleBigImage addTarget:self action:@selector(buttonImageClickableDidPressed:) forControlEvents:UIControlEventTouchUpInside];
        imgViewBuyNow = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 6.0, 65.0, 65.0)];
        
         lblMinBidPrice = [[UILabel alloc]initWithFrame:CGRectMake(imgViewVehicle.frame.origin.x, imgViewVehicle.frame.origin.y + imgViewVehicle.frame.size.height + 5.0, 350, 25)];
        
        lblVehicleName = [[UILabel alloc] initWithFrame:CGRectMake(195,2,570,heightName)];
        lblVehicleDetails1 = [[UILabel alloc] initWithFrame:CGRectMake(195,lblVehicleName.frame.origin.y + lblVehicleName.frame.size.height + 5.0,570,heightDetails1)];
        lblVehicleDetails2 = [[UILabel alloc] initWithFrame:CGRectMake(195,lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height + 5.0,570,heightDetails2)];
        
        lblMyBidValue = [[UILabel alloc] initWithFrame:CGRectMake(195,lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height + 3.0,250,25)];
        lblWinBeatValue = [[UILabel alloc] initWithFrame:CGRectMake(lblMyBidValue.frame.origin.x + lblMyBidValue.frame.size.width + 6.0,lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height + 3.0,250,25)];
        
        
        lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        lblMyBidValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        lblWinBeatValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        
    }
    lblMinBidPrice.hidden = NO;
   // lblMinBidPrice.backgroundColor = [UIColor redColor];
    lblVehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
    lblVehicleDetails1.textColor = [UIColor whiteColor];
    lblVehicleDetails2.textColor = [UIColor whiteColor];
    lblWinBeatValue.textColor = [UIColor whiteColor];
    //lblMyBidValue.textColor = [UIColor whiteColor];
    
    imgViewVehicle.tag = 101;
    lblVehicleName.tag = 102;
    lblVehicleDetails1.tag = 103;
    lblVehicleDetails2.tag = 104;
    lblMyBidValue.tag = 106;
    lblWinBeatValue.tag = 107;
    imgViewBuyNow.tag = 108;
    
    
    
    //[lblVehicleName      setText:[NSString stringWithFormat:@"%@ %@",self.vehicleObj.strVehicleYear,self.vehicleObj.strVehicleName]];
    if([self.vehicleObj.strVehicleYear length]>0  )
    {
        [self setAttributedTextForVehicleDetailsWithFirstText:[NSString stringWithFormat:@"%@ ",self.vehicleObj.strVehicleYear] andWithSecondText:self.vehicleObj.strVehicleName forLabel:lblVehicleName];
    }
    
    self.vehicleObj.strVehicleMileageType = [NSString stringWithFormat:@"%@%@",[[self.vehicleObj.strVehicleMileageType substringToIndex:[self.vehicleObj.strVehicleMileageType length] - (self.vehicleObj.strVehicleMileageType >0)]capitalizedString],[[self.vehicleObj.strVehicleMileageType substringFromIndex:[self.vehicleObj.strVehicleMileageType length] -1] lowercaseString]];
    
    // setting mileage with its type
    
    
    
   //self.vehicleObj.strVehicleMileage = [NSString stringWithFormat:@"%@%@",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:self.vehicleObj.strVehicleMileage],@"Km"];
    
    if([self.vehicleObj.strVehicleMileage length]>0 && [self.vehicleObj.strVehicleColor length]>0)
    {
        lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@",self.vehicleObj.strVehicleMileage,self.vehicleObj.strVehicleColor];
    }
    else if([self.vehicleObj.strVehicleMileage length] == 0 && [self.vehicleObj.strVehicleColor length] == 0)
    {
    }
    else if([self.vehicleObj.strVehicleMileage length] == 0)
    {
        lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ ",self.vehicleObj.strVehicleColor];
    }
    else if ([self.vehicleObj.strVehicleColor length] == 0)
    {
        lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ ",self.vehicleObj.strVehicleMileage];
    }
    
    //lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@",self.vehicleObj.strLocation,[NSString stringWithFormat:@"Exp. %@",self.vehicleObj.strVehicleTeadeTimeLeft]];
    
    
    [self setAttributedTextWithFirstText:[NSString stringWithFormat:@"%@ | ",self.vehicleObj.strLocation] andWithSecondText:[NSString stringWithFormat:@"Exp. %@",self.vehicleObj.strVehicleTeadeTimeLeft] andWithFirstColor:[UIColor whiteColor] andWithSecondColor:[UIColor colorWithRed:201.0/255.0 green:24.0/255.0 blue:36.0/255.0 alpha:1.0] withSmallFont:NO forLabel:lblVehicleDetails2];
    
    
    
    //self.vehicleObj.strMyHighest = @"50000";
    // self.vehicleObj.strTotalHighest = @"45000000";
    
    
    // if MyHighestBid is equal to zero then it is N/A
    
    if([self.vehicleObj.strMyHighest hasPrefix:@"R"])
        self.vehicleObj.strMyHighest = [self.vehicleObj.strMyHighest substringFromIndex:1];
    
    if (self.vehicleObj.strMyHighest.intValue==0)
    {
        [lblWinBeatValue setHidden:YES];
        isLabelWinBeatValueHidden = YES;
        [lblMyBidValue setText:@"My Bid: None Yet"];
        
        lblMyBidValue.textColor = [UIColor whiteColor];
        
    }
    else
    {
        
        [lblWinBeatValue setHidden:NO];
        isLabelWinBeatValueHidden = NO;
        
        
        lblMyBidValue.text = [NSString stringWithFormat:@"My Bid: R%@",self.vehicleObj.strMyHighest];
        
     //   lblMyBidValue.text = [NSString stringWithFormat:@"My Bid: %@",[NSString stringWithFormat:@"R %d",self.vehicleObj.strMyHighest.intValue]];
        
        lblMyBidValue.textColor = [UIColor colorWithRed:135.0/255.0 green:67.0/255.0 blue:198.0/255.0 alpha:1.0];
        
        if([lblMyBidValue.text length]>0)
        {

        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:lblMyBidValue.text];
        NSRange fullRange = NSMakeRange(0, 6);
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:fullRange];
        [lblMyBidValue setAttributedText:string];
        
        }
        
        
    }
    
    NSString *strPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.vehicleObj.strVehicleTradePrice];
    
    //UIColor *color1 = [UIColor whiteColor];
    
    // UIColor *color2 = [UIColor colorWithRed:148.0/255.0 green:109.0/255.0 blue:17.0/255.0 alpha:1.0];
    
    if([self.vehicleObj.strVehicleTradePrice length] == 0 )
    {
        lblMinBidPrice.hidden = NO;
    }
    else
    {
        lblMinBidPrice.hidden = NO;
        
        if(self.strBidValue.intValue == 0)
        {
             [self setAttributedTextWithFirstText:@"Min Bid: " andWithSecondText:strPrice andWithFirstColor:[UIColor whiteColor] andWithSecondColor:[UIColor colorWithRed:163.0/255.0 green:125.0/255.0 blue:0.0/255.0 alpha:1.0] withSmallFont:YES forLabel:lblMinBidPrice];
        }
        else
        {
            [self setAttributedTextWithFirstText:@"Min Bid: " andWithSecondText:minBidPriceUpdated andWithFirstColor:[UIColor whiteColor] andWithSecondColor:[UIColor colorWithRed:163.0/255.0 green:125.0/255.0 blue:0.0/255.0 alpha:1.0] withSmallFont:YES forLabel:lblMinBidPrice];
           
        }
        
    }

    
    
    
    // if MyHighestBid is greater than or eqaul to HightestBid then it should be winning or elase it should be beaten
    
    if([self.vehicleObj.strTotalHighest hasPrefix:@"R"])
        self.vehicleObj.strTotalHighest = [self.vehicleObj.strTotalHighest substringFromIndex:1];
    
    NSString *validString1 = self.vehicleObj.strMyHighest;
    NSString *validString2 = self.vehicleObj.strTotalHighest;
  validString1 =  [validString1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    validString2 =  [validString2 stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (validString1.intValue>=validString2.intValue)
    {
        [lblWinBeatValue setText:@"Winning"];
        if(lblWinBeatValue.hidden == NO)
            lblMinBidPrice.hidden = YES;
        
        [lblWinBeatValue setTextColor:[UIColor colorWithRed:64.0f/255.0f green:198.0f/255.0f blue:42.0f/255.0f alpha:1.0f]];
    }
    else
    {
        lblMinBidPrice.hidden = NO;
        if(![lblMyBidValue.text isEqualToString:@"My Bid: None Yet"])
        {
        lblWinBeatValue.hidden = NO;
            isLabelWinBeatValueHidden = NO;
        [lblWinBeatValue setText:@"Beaten"];
        [lblWinBeatValue setTextColor:[UIColor colorWithRed:212.0f/255.0f green:46.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
        }
    }
    
    validString1 = nil;
    validString1 = nil;
    // making thumb image big by replacing
    
    if ([arrayVehicleImages count]>0)
    {
        self.vehicleObj.strVehicleImageURL = [NSString stringWithFormat:@"%@%@",[[arrayVehicleImages objectAtIndex:0]  substringToIndex:[[arrayVehicleImages objectAtIndex:0] length] -3],@"200"];
    }
    
    
    [imgViewVehicle setImageWithURL:[NSURL URLWithString:self.vehicleObj.strVehicleImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
    
    // showing BuyItNow Banner image if vehcile is having buyItNow
    
    self.vehicleObj.isBuyItNow == YES ?[imgViewBuyNow setHidden:NO]:[imgViewBuyNow setHidden:YES];
    
    imgViewBuyNow.image = [UIImage imageNamed:@"buynow"];
    
    
    [dynamicCell.contentView addSubview:imgViewVehicle];
    [dynamicCell.contentView addSubview:btnVehicleBigImage];
    [dynamicCell.contentView addSubview:lblVehicleName];
    [dynamicCell.contentView addSubview:lblVehicleDetails1];
    [dynamicCell.contentView addSubview:lblVehicleDetails2];
    [dynamicCell.contentView addSubview:lblMyBidValue];
    [dynamicCell.contentView addSubview:lblWinBeatValue];
    [dynamicCell.contentView addSubview:imgViewBuyNow];
    if(!self.isLabelMinBidHide)
    {
        [dynamicCell.contentView addSubview:lblMinBidPrice];
        
    }

    
    lblVehicleName.numberOfLines = 0;
    [lblVehicleName sizeToFit];
    
    lblVehicleDetails1.numberOfLines = 0;
    [lblVehicleDetails1 sizeToFit];
    
    
    lblVehicleDetails2.numberOfLines = 0;
    
    
    lblVehicleName.backgroundColor = [UIColor blackColor];
    lblVehicleDetails1.backgroundColor = [UIColor blackColor];
    lblVehicleDetails2.backgroundColor = [UIColor blackColor];
    lblMinBidPrice.backgroundColor = [UIColor blackColor];
    lblMyBidValue.backgroundColor = [UIColor blackColor];
    lblWinBeatValue.backgroundColor = [UIColor blackColor];
    
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        dynamicCell.layoutMargins = UIEdgeInsetsZero;
        dynamicCell.preservesSuperviewLayoutMargins = NO;
    }
    dynamicCell.backgroundColor = [UIColor blackColor];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.tableBuy)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                switch (indexPath.row)
                {
                    case 0:
                        
                        return [self returnTheHeightForFirstCell];
                        break;
                        
                    case 1:
                        if (arrayTradeSliderDetails.count!=0)
                        {
                            return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 80.0f : 119.0f;
                        }
                        else
                        {
                            return 0.0f;
                        }
                        break;
                        
                    case 2:
                        if (self.strBidValue.intValue!=0)
                        {
                            return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 40.0f : 50.0f;
                        }
                        else
                        {
                            return 0.0f;
                        }
                        break;
                        
                    case 3:
                        if (self.strBidValue.intValue!=0)
                        {
                            return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 40.0f : 50.0f;
                        }
                        else
                        {
                            return 0.0f;
                        }
                        break;
                        
                    case 4:
                        if (self.buttonAutomatedBidding.selected)
                        {
                           
                            CGFloat finalHeight = (self.lblTitle.frame.size.height + self.textFieldLimitBidAmount.frame.size.height + self.btnCancelForExpandableView.frame.size.height + 25.0 );
                            
                             if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                             {
                                 if(finalHeight < 150)
                                     finalHeight = 150;
                             }
                            else
                            {
                                if(finalHeight < 160)
                                    finalHeight = 168;
                            }
                            
                            return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? finalHeight : finalHeight;
                        }
                        else
                        {
                            [self.viewAutomatedExpanded removeFromSuperview];
                            if (self.strBuyNowValue.intValue!=0)
                            {
                                return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 40.0f : 50.0f;
                            }
                            else
                            {
                                return 0.0f;
                            }
                        }
                        break;
                        
                    case 5:
                        if (self.buttonAutomatedBidding.selected)
                        {
                            if (self.strBuyNowValue.intValue!=0)
                            {
                                return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 40.0f : 50.0f;
                            }
                        }
                        else
                        {
                            [self.tableVehicleListing setFrame:CGRectMake(0, 0, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ?320 : 768, listingHeight)];
                            return listingHeight;
                        }
                        break;
                        
                    case 6:
                    {
                        [self.tableVehicleListing setFrame:CGRectMake(0, 0, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ?320 : 768, listingHeight)];
                        return listingHeight;
                    }
                        break;
                        
                    default:
                        break;
                }

            }
            break;
            case 1:
            {
                if (isSectionSecondExpanded)
                {
                    
                    if(arrayOfMessages.count != indexPath.row)
                    {
                        SMVehiclelisting *rowObject = (SMVehiclelisting*)[arrayOfMessages objectAtIndex:indexPath.row];
                        
                        //----------------------------------------------------------------------------------------
                        
                        CGFloat heightMessage = 0.0f;
                        CGFloat heightName = 0.0f;
                        
                        //----------------------------------------------------------------------------------------
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                        {
                            heightMessage = [self heightForTextForSecondSection:rowObject.strMessage andTextWidthForiPhone:180];
                        }
                        else
                        {
                            heightMessage = [self heightForTextForSecondSection:rowObject.strMessage andTextWidthForiPhone:570];
                        }
                        
                        
                        //----------------------------------------------------------------------------------------
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                        {
                            heightName = [self heightForTextForSecondSection:rowObject.strClientName andTextWidthForiPhone:120];
                        }
                        else
                        {
                            heightName = [self heightForTextForSecondSection:rowObject.strClientName andTextWidthForiPhone:200];
                        }
                        
                        //----------------------------------------------------------------------------------------
                        
                        
                        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                        {
                            if(heightMessage <= 20)
                               return heightMessage + 35.0;
                            else
                               return heightMessage + 15.0;
                        }
                        else
                        {
                            return heightMessage + 35.0;
                        }
                    }
                    else if(arrayOfMessages.count == indexPath.row)
                        return 125.0;
                }
                else
                {
                    return 0;
                }
            }
                break;
            case 2:
            {
                if(isSectionThirdExpanded)
                {
                    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                        return 116.0;
                    else
                        return 154.0;
                }
                else
                {
                    return 0;
                }
                    
            }
            break;
                
            default:
                break;
        }
        
        
    }
    else if (tableView==self.tableVehicleListing)
    {
        if(indexPath.section == 0)
        {
            SMDetailTrade *objectInCellForRow = (SMDetailTrade *) [arrayVehicleListing objectAtIndex:indexPath.row];
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                if ((self.strBuyNowValue.intValue==0            && [objectInCellForRow.strKey isEqualToString:@"Buy Now Price"]) ||
                    (objectInCellForRow.strValue.intValue==0    && [objectInCellForRow.strKey isEqualToString:@"Bid Closes On"]) ||
                    (self.strBidValue.intValue==0               && [objectInCellForRow.strKey isEqualToString:@"Min Bid"]))
                {
                    return 0.0f;
                }
                else
                {
                    return 25.0f;
                }
            }
            else
            {
                if ((self.strBuyNowValue.intValue==0            && [objectInCellForRow.strKey isEqualToString:@"Buy Now Price"]) ||
                    (objectInCellForRow.strValue.intValue==0    && [objectInCellForRow.strKey isEqualToString:@"Bid Closes On"]) ||
                    (self.strBidValue.intValue==0               && [objectInCellForRow.strKey isEqualToString:@"Min Bid"]))
                {
                    return 0.0f;
                }
                else
                {
                    return 30.0f;
                }
            }
            
        }
        else
        {
            return 0;
        }
        
    }
    
    
    
    return 0;
}

#pragma Header Views

/*-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 
 if(section == 1)
 return @"Message Seller";
 else
 return @"";
 }*/

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableBuy)
    {
        if(section != 0)
        {
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                return 40.0f;
            }
            else
            {
                return 60.0f;
            }
        }
        return 0;
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.tableBuy)
    {
        if(section != 0)
        {
            UIView *headerView = [[UIView alloc] init];
            UIView *headerColorView = [[UIView alloc] init];
            UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
            UILabel *labelReviews = [[UILabel alloc]init];
           
            
            
            imageViewArrowForsection = [[UIImageView alloc]init];
            
            imageViewArrowForsection.contentMode = UIViewContentModeScaleAspectFit;
            
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                [headerView setFrame:CGRectMake(5, 2, 310, 30)];
                [headerColorView setFrame:CGRectMake(5, 2, 310, 30)];
                sectionLabelBtn.frame = CGRectMake(5, 0, tableView.bounds.size.width,30);
                sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
                [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-37,5,20,20)];
                //[labelReviews setFrame:CGRectMake(180, 3, 100, 25)];
            }
            else
            {
                [headerView setFrame:CGRectMake(5, 5, 758, 40)];
                [headerColorView setFrame:CGRectMake(5, 5, 758, 40)];
                sectionLabelBtn.frame = CGRectMake(7, 5, 758,40);
                sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
                [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-34,10,20,20)];
                //[labelReviews setFrame:CGRectMake(728, 3, 200, 25)];
            }
            
            if(section == 1)
            {
                [sectionLabelBtn setTitle:@"Message Seller" forState:UIControlStateNormal];
                
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                    sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 100, 0.0, 0.0);
                else
                   sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(100.0, 300, 110.0, 0.0);
            }
            else
            {
                [sectionLabelBtn setTitle:@"Seller Rating" forState:UIControlStateNormal];
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                    sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 50, 2.0, 0.0);
                else
                    sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 300, 10.0, 0.0);
               
            }
            
           
            
            if(isSectionSecondExpanded)
            {
                if(section == 1)
                {
                
                [UIView animateWithDuration:2 animations:^
                 {
                     {
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                     }
                 }
                                 completion:nil];
                }
            }
            else if(isSectionThirdExpanded)
            {
                if(section == 2)
                {

                [UIView animateWithDuration:2 animations:^
                 {
                     {
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                     }
                 }
                                 completion:nil];
                }
            }
            
            UIImage *image = [UIImage imageNamed:@"side_Arrow.png"];
            [imageViewArrowForsection setImage:image];
            
            
            [headerColorView addSubview:imageViewArrowForsection];
            
            headerView.backgroundColor = [UIColor clearColor];
            
            

            
            
            if(section == 1)
            {
                countLbl = [[UILabel alloc]initWithFrame:CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-45,5, 20, 20)];
                
                countLbl.textColor = [UIColor whiteColor];
                countLbl.textAlignment = NSTextAlignmentCenter;
                countLbl.layer.borderColor = [UIColor whiteColor].CGColor;
                countLbl.layer.borderWidth = 1.0;
                countLbl.layer.masksToBounds = YES;
               
                
                //countLbl.text = [NSString stringWithFormat:@"%d",sectionObject.arrayOfInnerObjects.count];
                
                countLbl.layer.cornerRadius = countLbl.frame.size.width/2;
                
                [self setTheLabelCountText:(int)arrayOfMessages.count];
                
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width,5, countLbl.frame.size.width, 20);
                     countLbl.font = [UIFont fontWithName:FONT_NAME size:15.0f];
                }
                else
                {
                    countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width-10,10, countLbl.frame.size.width, 20);
                     countLbl.font = [UIFont fontWithName:FONT_NAME size:17.0f];
                }
                
                [headerColorView addSubview:countLbl];
                
            }
            
            if(section == 1)
            {
                headerColorView.backgroundColor=[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
                [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               
                labelReviews.hidden = YES;
                
            }
            else
            {
                
                  if(totalSellerReviews > 0)
                  {
                      // For Rating View
                      headerColorView.backgroundColor=[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
                      [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                      
                      [headerColorView addSubview:[self returnViewForRatingWithRateStarValue:sellerRatingStarValue]];
                      
                  }
                  else
                  {
                      // For non rating view
                      headerColorView.backgroundColor=[UIColor whiteColor];
                      [sectionLabelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                      
                      [headerColorView addSubview:[self returnViewForNoRating]];
                      
                  }
                              
            }
            
            
            [sectionLabelBtn addTarget:self action:@selector(btnSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [sectionLabelBtn setTag:section];
            sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            headerColorView.layer.cornerRadius = 5.0;
            [headerColorView addSubview:sectionLabelBtn];
            [headerView addSubview:headerColorView];
            headerView.layer.cornerRadius = 5.0;
            //headerView.clipsToBounds = YES;
            
            return headerView;
        }
        return nil;
    }
    else
        return nil;
    
}

-(UIView*)returnViewForNoRating
{
    UILabel *labelReviews = [[UILabel alloc]init];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [labelReviews setFrame:CGRectMake(180, 2, 100, 25)];
        labelReviews.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    }
    else
    {
        [labelReviews setFrame:CGRectMake(580, 6, 250, 25)];
        labelReviews.font = [UIFont fontWithName:FONT_NAME_BOLD size:18.0];
    }
    
    labelReviews.hidden = NO;
    labelReviews.textColor=[UIColor colorWithRed:101.0/255 green:142.0/255 blue:15.0/255 alpha:1.0];
    labelReviews.text = @"No Reviews Yet";
    
    
    return labelReviews;
}


-(UIView*)returnViewForRatingWithRateStarValue:(float)rateStarValue;
{
    HCSStarRatingView *starRatingView;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(190, 3, 90, 22)];
    else
        starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(570, 5, 150, 25)];
        
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
   // starRatingView.spacing = 2;
    // starRatingView.value = 0;
    starRatingView.allowsHalfStars = YES;
    starRatingView.value = rateStarValue;
    starRatingView.accurateHalfStars = YES;
    starRatingView.tintColor = [UIColor colorWithRed:203.0/255 green:219.0/255 blue:37.0/255 alpha:1.0];
    starRatingView.backgroundColor = [UIColor clearColor];
    return starRatingView;
}


#pragma mark -  UICollectionView Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  arrayTradeSliderDetails.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMTradeDetailSlider *sliderCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    [sliderCell.imageVehicle   setImageWithURL:[NSURL URLWithString:[arrayTradeSliderDetails objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
    
    return sliderCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        networkGallery.startingIndex = indexPath.row+1;
        SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate.isPresented =  YES;
        [self.navigationController pushViewController:networkGallery animated:YES];
    });
}

#pragma mark - UITextField Delegate Method

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.txtFieldComment)
    {
        
        //for shifting the scroll view up  of the keypad when the textfield is edited.
        
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:self.tableBuy];
        pt = rc.origin;
        pt.x = 0;
        
        pt.y -= 98;
        [self.tableBuy setContentOffset:pt animated:YES];
        
        
    }
    else
    {
        if (IS_IPHONE_4_OR_LESS)
        {
            
        }
        else
        {
            CGRect frame = [self.tableBuy convertRect:textField.frame fromView:textField.superview.superview];
            [self.tableBuy setContentOffset:CGPointMake(0, frame.origin.y) animated:YES];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        if ([self.textFieldLimitBidAmount isFirstResponder] || [self.textFieldPlaceBid isFirstResponder])
        {
            NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
            return [string isEqualToString:filtered];
        }
        else
        {
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            return (newLength > 200) ? NO : YES;
        }
    }
    else
        return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)addKeyBoardToolbar
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *done= [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    [done setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *cancel= [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    [cancel setTintColor:[UIColor whiteColor]];
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           cancel,
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           done,
                           nil];
    [numberToolbar sizeToFit];
    self.textFieldPlaceBid.inputAccessoryView = numberToolbar;
    self.textFieldLimitBidAmount.inputAccessoryView = numberToolbar;
}

-(void)doneWithNumberPad
{
    [self.textFieldPlaceBid resignFirstResponder];
    [self.textFieldLimitBidAmount resignFirstResponder];
}

#pragma mark -

- (IBAction)buttonPlaceBidDidClicked:(id)sender
{
    [self.textFieldPlaceBid resignFirstResponder];
    UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Do you want to bid on this vehicle with your bid amount?" cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    
    [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
        
        
        switch (selectedIndex) {
            case 1:
                [self placeBidWithBidValue];
                break;
            default:
                break;
        }
        
    }];
}

- (IBAction)buttonBuyNowDidClicked:(id)sender
{
    UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:[NSString stringWithFormat:@"%@ %@", @"Do you want to purchase this vehicle at the buy now price of",buyNowPrice] cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    
    [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
        
        switch (selectedIndex) {
            case 1:
                [self buyNowWebServiceCall];
                break;
                
            default:
                break;
        }
        
        
    }];
}

- (IBAction)buttonAutomatedBiddingDidClicked:(id)sender
{
    self.buttonAutomatedBidding.selected = !self.buttonAutomatedBidding.selected;
    
    if (AutoBidAmount!=0)
    {
        [self.textFieldLimitBidAmount setText:[NSString stringWithFormat:@"%d",AutoBidAmount]];
    }
    
    if (AutoBidAmount==0)
    {
        [self.lblMaximumBid setHidden:NO];
        [self.textFieldLimitBidAmount setHidden:NO];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            [self.lblTitle setFrame:CGRectMake(24, 5, 262, 45)];
        }
        else
        {
            [self.lblTitle setFrame:CGRectMake(24, 5, 720, 45)];
        }
        [self.lblTitle setNumberOfLines:2];
        self.lblTitle.text = [NSString stringWithFormat:@"Start Automated Bidding at %@ with Increment of %@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.strBidValue],[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.strIncrementValue]];
    }
    else
    {
       // [self.lblMaximumBid setHidden:YES];
        //[self.textFieldLimitBidAmount setHidden:YES];
        
        [self.lblTitle setNumberOfLines:4];
        self.lblTitle.text = [NSString stringWithFormat:@"Automated Bidding Active: Started at %@ with Increment of %@. Max Bid %@. Current Bid %@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.strBidValue],[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.strIncrementValue],[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",AutoBidAmount]],[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",self.strBidValue.intValue]]];
        
        if([self.lblTitle.text length]>0)
        {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.lblTitle.text];
            NSRange fullRange = NSMakeRange(0, 25);
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                [self.lblTitle setFrame:CGRectMake(24, 5, 262, 85)];
                [string addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:15.0f]} range:fullRange];
            }
            else
            {
                [self.lblTitle setFrame:CGRectMake(24, 5, 720, 85)];
                [string addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:20.0f]} range:fullRange];
            }
            [self.lblTitle setAttributedText:string];
            
            [self.lblMaximumBid setFrame:CGRectMake(self.lblMaximumBid.frame.origin.x, self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height,self.lblMaximumBid.frame.size.width, self.lblMaximumBid.frame.size.height)];
            
            [self.textFieldLimitBidAmount setFrame:CGRectMake(self.lblMaximumBid.frame.origin.x + self.lblMaximumBid.frame.size.width + 10.0, self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height,self.textFieldLimitBidAmount.frame.size.width, self.textFieldLimitBidAmount.frame.size.height)];
            
            [self.btnCancelForExpandableView setFrame:CGRectMake(self.btnCancelForExpandableView.frame.origin.x, self.textFieldLimitBidAmount.frame.origin.y + self.textFieldLimitBidAmount.frame.size.height + 10.0,self.btnCancelForExpandableView.frame.size.width, self.btnCancelForExpandableView.frame.size.height)];
            
            [self.btnActivateForExpandableView setFrame:CGRectMake(self.btnCancelForExpandableView.frame.origin.x + self.btnCancelForExpandableView.frame.size.width + 40.0 , self.btnCancelForExpandableView.frame.origin.y,self.btnActivateForExpandableView.frame.size.width, self.btnActivateForExpandableView.frame.size.height)];
        }
    }
    
    [self.tableBuy reloadData];
    //    [self.tableVehicleListing reloadData];
}
- (IBAction)btnCancelForExpandableViewDidClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    if ([btn.titleLabel.text isEqualToString:@"Disable"])
    {
        [self removeAutoBid];
    }
    else
    {
        self.buttonAutomatedBidding.selected = !self.buttonAutomatedBidding.selected;
        
        [self.tableBuy reloadData];
        //        [self.tableVehicleListing reloadData];
    }
}
- (IBAction)btnActivateForExpandableViewDidClicked:(id)sender
{
    [self.textFieldLimitBidAmount resignFirstResponder];
    if (self.textFieldLimitBidAmount.text.length == 0 || self.textFieldLimitBidAmount.text.intValue==0)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:@"Please enter bid limit." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorAlert show];
    }
    else
    {
        [self.textFieldPlaceBid resignFirstResponder];
        if([self.btnActivateForExpandableView.titleLabel.text isEqualToString:@"Activate"])
        {
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Do you want to set auto bid?" cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            
            
            switch (selectedIndex) {
                case 1:
                     [self activateAutoBidWithAmount];
                    break;
                default:
                    break;
            }
            
        }];
        }
        else
        {
             [self activateAutoBidWithAmount];
        }
        
        
    }
    
}



#pragma mark - WebService Call

-(void)loadingAllDetails
{
    [arrayVehicleListing        removeAllObjects];
    [arrayVehicleDetail         removeAllObjects];
    [arrayFullImages            removeAllObjects];
    [arrayTradeSliderDetails    removeAllObjects];
    [arrayVehicleImages         removeAllObjects];
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices gettingDetailsVehicleImages:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleId:self.strSelectedVehicleId.intValue];
    
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
             return;
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)removeAutoBid
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices removingAutoBidCapWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleID:self.strSelectedVehicleId.intValue];
    
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
             return;
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)buyNowWebServiceCall
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices buyVehicle:[SMGlobalClass sharedInstance].hashValue withClientId:[SMGlobalClass sharedInstance].strClientID.intValue withUserID:[SMGlobalClass sharedInstance].strMemberID.intValue withVehicleID:self.strSelectedVehicleId.intValue strAmount:self.strBuyNowValue];
    
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
             return;
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)placeBidWithBidValue
{
    isDetailServiceCalled = NO;
    
    if (!self.textFieldPlaceBid.text.length == 0)
    {
        self.strBidValue = self.textFieldPlaceBid.text;
        self.strBidValue = [self.strBidValue stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.strBidValue = [self.strBidValue stringByReplacingOccurrencesOfString:@"R" withString:@""];
    }
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices placeBid:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withUserID:[SMGlobalClass sharedInstance].strMemberID.intValue withVehicleID:self.strSelectedVehicleId.intValue withAmount:self.strBidValue];
    
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
             return;
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)activateAutoBidWithAmount
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    bidAmountWithIncrement      = self.strBidValue.intValue;
    int limitAmount             = self.textFieldLimitBidAmount.text.intValue;
    
    NSMutableURLRequest *requestURL=[SMWebServices placeAutomatedBidding:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withUserID:[SMGlobalClass sharedInstance].strMemberID.intValue withVehicleID:self.strSelectedVehicleId.intValue withAmount:bidAmountWithIncrement withBidLimit:limitAmount];
    
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
             return;
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)getSellerRating
{
    //[HUD show:YES];
   // [HUD setLabelText:KLoaderText];
    
     NSMutableURLRequest *requestURL = [SMWebServices GetRatingForSellerWithUserHash:[SMGlobalClass sharedInstance].hashValue andSellerClientID:sellerClientID];
    
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
             return;
         }
         else
         {
             arrayOfRateQuestions = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)webServiceForMessagesList
{
    //[HUD show:YES];
   // [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices listMessagesForVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockID:self.strSelectedVehicleId.intValue];
    
    // NSMutableURLRequest *requestURL = [SMWebServices listMessagesForVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockID:self.selectedVehicleObj.strUsedVehicleStockID.intValue];
    
    
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
             arrayOfMessages = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)webServiceForAddingMessage
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices addMessageToVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockID:self.strSelectedVehicleId.intValue andMessage:self.txtFieldComment.text];
    
    // NSMutableURLRequest *requestURL = [SMWebServices listMessagesForVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockID:self.selectedVehicleObj.strUsedVehicleStockID.intValue];
    
    
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
             NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}


#pragma mark - FGalleryViewController Delegate Method

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    if(gallery == networkGallery)
    {
        int num;
        
        num = (int)[arrayFullImages count];
        
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
    if( gallery == networkGallery )
    {
        caption = [networkCaptions objectAtIndex:index];
    }
    return caption;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    return [arrayFullImages objectAtIndex:index];
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

#pragma mark - Xml Parsing Methods

-(void) parser:(NSXMLParser *)          parser
didStartElement:(NSString *)            elementName
  namespaceURI:(NSString *)             namespaceURI
 qualifiedName:(NSString *)             qName
    attributes:(NSDictionary *)         attributeDict
{
    if([elementName isEqualToString:@"BuyNowResponse"])
    {
        checkStatus = iBuyNow;
    }
    if ([elementName isEqualToString:@"AutoBidResponse"])
    {
        checkStatus = iAutomatedBid;
    }
    if([elementName isEqualToString:@"BidResponse"])
    {
        checkStatus = iPlacingBid;
    }
    if ([elementName isEqualToString:@"RemoveAutoBidsResponse"])
    {
        checkStatus = iRemoveAutoBid;
    }
    if([elementName isEqualToString:@"question"])
    {
        rateSellerObject = [[SMRateBuyerObject alloc]init];
    }
    if([elementName isEqualToString:@"Questions"])
    {
        isQuestionsMainTagEntered = YES;
    }
    if ([elementName isEqualToString:@"message"])
    {
        messageObject = [[SMVehiclelisting alloc]init];
    }
    currentNodeContent = [NSMutableString stringWithString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"OwnerName"])
    {
        if ([currentNodeContent isEqualToString:@""])
        {
            currentNodeContent = (NSMutableString *)@"No Owner";
        }
        
        self.strOwnerName =  currentNodeContent;
    }
    if ([elementName isEqualToString:@"OwnerID"])
    {
        sellerClientID = currentNodeContent.intValue;
    }
    if ([elementName isEqualToString:@"Year"])
    {
        [self.labelVehicleName setText:currentNodeContent];
    }
    if ([elementName isEqualToString:@"Location"])
    {
        if([currentNodeContent length] != 0)
            self.vehicleObj.strLocation = currentNodeContent;
        else
            self.vehicleObj.strLocation = @"Location?";
    }
    if ([elementName isEqualToString:@"FriendlyName"])
    {
        self.navigationItem.titleView = [SMCustomColor setTitle:currentNodeContent];
        
        [self.labelVehicleName      setText:[NSString stringWithFormat:@"%@ %@ \n",self.labelVehicleName.text,currentNodeContent]];
        
        if([self.labelVehicleName.text length]>0)
        {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.labelVehicleName.text];
        NSRange fullRange = NSMakeRange(0, 4);
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:fullRange];
        [self.labelVehicleName setAttributedText:string];
        }
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
        if ([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"0"])
        {
            self.labelVehicleMileage.text = @"Mileage?";
        }
        else
        {
            [self.labelVehicleMileage   setText:[NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent]]];
        }
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        if ([currentNodeContent isEqualToString:@""] || [currentNodeContent isEqualToString:@"No colour #"])
        {
            [self.labelVehicleColor    setText:@"Colour?"];
        }
        else
        {
            [self.labelVehicleColor    setText:currentNodeContent];
        }
    }
    if([elementName isEqualToString:@"Location"])
    {
        if (currentNodeContent.length == 0)
        {
            [self.labelVehicleLocation setText:@"Suburb/City"];
        }
        else
        {
            [self.labelVehicleLocation setText:currentNodeContent];
        }
        
        [self.lblOwnerName setText:[NSString stringWithFormat:@"Seller: %@, %@",self.strOwnerName,self.vehicleObj.strLocation]];
    }
    if ([elementName isEqualToString:@"TradePrice"]) // trade price will be asking price
    {
        strTradeCost                       = currentNodeContent;
        [self.labelVehicleCost      setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:strTradeCost]];
        
        objectTradeDeatilsVehicle          = [[SMDetailTrade alloc] init];
       // objectTradeDeatilsVehicle.strValue = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:currentNodeContent];
        //objectTradeDeatilsVehicle.strKey   = @"Asking Price";
        
       // listingHeight = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 25 : 30;
        
        //[arrayVehicleListing addObject:objectTradeDeatilsVehicle];
    }
    if([elementName isEqualToString:@"Expires"])
    {
        objectTradeDeatilsVehicle           = [[SMDetailTrade alloc] init];
        objectTradeDeatilsVehicle.strValue  = currentNodeContent;
        objectTradeDeatilsVehicle.strKey    = @"Bid Closes On";
        
        if (objectTradeDeatilsVehicle.strValue.intValue!=0 &&(arrayVehicleListing.count < 3) && !isDetailServiceCalled)
        {
            listingHeight += (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 25 : 30;
        }
         if(arrayVehicleListing.count < 3)
            [arrayVehicleListing addObject:objectTradeDeatilsVehicle];
        
    }
    if ([elementName isEqualToString:@"TimeLeft"])
    {
        NSArray *arrayWithTwoStrings = [currentNodeContent componentsSeparatedByString:@"."];
        NSArray *hoursmint = [[arrayWithTwoStrings objectAtIndex:0]componentsSeparatedByString:@":"];
        
        if (hoursmint.count>1)
        {
            [self.labelTradeTimeLeft   setText:[NSString stringWithFormat:@"%@h %@m",[hoursmint objectAtIndex:0],[hoursmint objectAtIndex:1]]];
        }
    }
    if ([elementName isEqualToString:@"BuyNow"])
    {
        if ([currentNodeContent intValue] == 0)
        {
            [self.imageViewBuyItNow setHidden:YES];
        }
        else
        {
            [self.imageViewBuyItNow setHidden:NO];
        }
        
        objectTradeDeatilsVehicle = [[SMDetailTrade alloc] init];
        self.strBuyNowValue                = (NSMutableString *) currentNodeContent;
        objectTradeDeatilsVehicle.strKey   = @"Buy Now Price";
        objectTradeDeatilsVehicle.strValue = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:currentNodeContent];// setting Currency Format for buy now price
        
        if (self.strBuyNowValue.intValue!=0 )
        {
        }
        
        
        buyNowPrice = objectTradeDeatilsVehicle.strValue;
        
        [self.buttonBuyNow setTitle:[NSString stringWithFormat:@"Buy Now For %@",objectTradeDeatilsVehicle.strValue] forState:UIControlStateNormal]; // Set button title for buy now o1ffer
    }
    if([elementName isEqualToString:@"MinBid"])
    {
        objectTradeDeatilsVehicle           = [[SMDetailTrade alloc] init];
        
        self.strBidValue = currentNodeContent;
      
        
        NSString *tempStr = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:currentNodeContent];
        minBidPriceUpdated = tempStr;
        
        //[self.textFieldPlaceBid setPlaceholder:[[objectTradeDeatilsVehicle.strValue componentsSeparatedByString:@"."] objectAtIndex:0]];
        [self.textFieldPlaceBid setText:[[tempStr componentsSeparatedByString:@"."] objectAtIndex:0]];
        
        //[arrayVehicleListing addObject:objectTradeDeatilsVehicle];
    }
    if ([elementName isEqualToString:@"MyHighestBid"])
    {
        strMyHighest = currentNodeContent;
        self.vehicleObj.strMyHighest = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:strMyHighest];
    }
    if ([elementName isEqualToString:@"HightestBid"]) // Best Offer
    {
        strHighestBid  = currentNodeContent;
        
        // if highest bid is greater than the trade price then we need to populate trade price as hignest bid
        if (strHighestBid.intValue >strTradeCost.intValue)
        {
            [self.labelVehicleCost      setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:strHighestBid]];
        }
        
        objectTradeDeatilsVehicle = [[SMDetailTrade alloc] init];
        
        if([strHighestBid intValue]==0)
            objectTradeDeatilsVehicle.strValue = @"None";
        else
            objectTradeDeatilsVehicle.strValue  = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:currentNodeContent];
        
        objectTradeDeatilsVehicle.strKey = @"Highest Bid So Far";
        
        if(arrayVehicleListing.count < 3 && !isDetailServiceCalled)
        {
          listingHeight += (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 25 : 30;
            NSLog(@"Enterd 2");
        }
          if(arrayVehicleListing.count < 3)
            [arrayVehicleListing addObject:objectTradeDeatilsVehicle];
        
    }
    if([elementName isEqualToString:@"Increment"])
    {
        self.strIncrementValue             = currentNodeContent;
        
        objectTradeDeatilsVehicle          = [[SMDetailTrade alloc] init];
        objectTradeDeatilsVehicle.strValue = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:currentNodeContent];
        objectTradeDeatilsVehicle.strKey   = @"Min Bid Increment";
        
       if(arrayVehicleListing.count < 3 && !isDetailServiceCalled)
       {
        listingHeight += (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 25 : 30;
           NSLog(@"Enterd 3");
       }
        
        if(arrayVehicleListing.count < 3)
        [arrayVehicleListing addObject:objectTradeDeatilsVehicle];
       
    }
    if ([elementName isEqualToString:@"StockNumber"])
    {
        [self.labelStockNumber      setText:currentNodeContent];
    }
    if ([elementName isEqualToString:@"RegNumber"])
    {
        if ([currentNodeContent  isEqualToString:@"(null)"] || [currentNodeContent  isEqualToString:@""])
        {
            [self.labelRegisterNumber   setText:@"Reg?"];
        }
        else
        {
            [self.labelRegisterNumber   setText:currentNodeContent];
        }
    }
    if ([elementName isEqualToString:@"VIN"])
    {
        if([currentNodeContent isEqualToString:@""] || [currentNodeContent  isEqualToString:@"(null)"])
        {
            [self.labelVinNumber setText:@"VIN?"];
        }
        else
        {
            [self.labelVinNumber setText:currentNodeContent];
        }
    }
    if ([elementName isEqualToString:@"Comments"])
    {
        if ([currentNodeContent isEqualToString:@""])
        {
            [self.labelComment setText:@"No Comment(s) Loaded"];
        }
        else
        {
            [self.labelComment setText:currentNodeContent];
        }
        
        // setting dynamic height for footer for comments
        [self.labelComment setFrame:CGRectMake(self.labelComment.frame.origin.x, self.labelComment.frame.origin.y, self.labelComment.frame.size.width, [self heightOfTextForString:self.labelComment.text andFont:self.labelComment.font maxSize:CGSizeMake(self.labelComment.frame.size.width, 500.0f)])];
    }
    if ([elementName isEqualToString:@"Extras"])
    {
        if ([currentNodeContent isEqualToString:@""])
        {
            [self.labelExtras setText:@"No Extra(s) Loaded."];
        }
        else
        {
            [self.labelExtras setText:currentNodeContent];
        }
        
        // setting dynamic height for footer for extra things label
        
        [self.labelExtrasHeading setFrame:CGRectMake(self.labelExtrasHeading.frame.origin.x,self.labelComment.frame.size.height+25,self.labelExtrasHeading.frame.size.width,[self heightOfTextForString:self.labelExtrasHeading.text andFont:self.labelExtrasHeading.font maxSize:CGSizeMake(self.labelExtrasHeading.frame.size.width, 500.0f)])];
        
        [self.labelExtras setFrame:CGRectMake(self.labelExtras.frame.origin.x,self.labelComment.frame.size.height+50,self.labelExtras.frame.size.width,[self heightOfTextForString:self.labelExtras.text andFont:self.labelExtras.font maxSize:CGSizeMake(self.labelExtras.frame.size.width, 500.0f)])];
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            [self setTableVehicleListTableFooterView:self.labelExtras.frame.size.height + self.labelComment.frame.size.height + 150];
        }
        else
        {
            [self setTableVehicleListTableFooterView:self.labelExtras.frame.size.height + self.labelComment.frame.size.height + 180];
        }
    }
    if ([elementName isEqualToString:@"AutobidCap"])
    {
        AutoBidAmount = [currentNodeContent intValue];
        
        if (AutoBidAmount==0)
        {
            [self.btnActivateForExpandableView setTitle:@"Activate" forState:UIControlStateNormal];
            [self.btnCancelForExpandableView setTitle:@"Cancel" forState:UIControlStateNormal];
        }
        else
        {
            [self.btnActivateForExpandableView setTitle:@"Amend" forState:UIControlStateNormal];
            [self.btnCancelForExpandableView setTitle:@"Disable" forState:UIControlStateNormal];
            [self.btnCancelForExpandableView setTitleColor:[UIColor colorWithRed:212.0f/255.0f green:46.0f/255.0f blue:48.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        }
        
    }
    // adding vehicle images
    
    if ([elementName isEqualToString:@"Thumb"])
    {
        [arrayVehicleImages addObject:currentNodeContent];
        
        currentNodeContent = (NSMutableString *) [currentNodeContent substringToIndex:currentNodeContent.length-3];
        currentNodeContent = (NSMutableString *)[NSString stringWithFormat:@"%@%@",currentNodeContent,@"180"];
        [arrayTradeSliderDetails addObject:currentNodeContent];
    }
    if ([elementName isEqualToString:@"Full"])
    {
        [arrayFullImages addObject:currentNodeContent];
    }
    if ([elementName isEqualToString:@"LoadVehicleResponse"])
    {
        [self getSellerRating];
        
        if (arrayTradeSliderDetails.count>0)
        {
            [arrayTradeSliderDetails removeObjectAtIndex:0];
        }
        
        NSString *imageURL;
        
        if ([arrayVehicleImages count]>0)
        {
            imageURL = [NSString stringWithFormat:@"%@%@",[[arrayVehicleImages objectAtIndex:0] substringToIndex:[[arrayVehicleImages objectAtIndex:0] length]-3],@"200"];
        }
        
        [self.imageVehicle setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        
        NSString *validString1 = strMyHighest;
        NSString *validString2 = strHighestBid;
        validString1 =  [validString1 stringByReplacingOccurrencesOfString:@" " withString:@""];
        validString2 =  [validString2 stringByReplacingOccurrencesOfString:@" " withString:@""];

        
        if (strMyHighest.intValue>=strHighestBid.intValue)
        {
            [self.lblWinningBeaten setText:@"Winning"];
            [self.lblWinningBeaten setTextColor:[UIColor colorWithRed:64.0f/255.0f green:198.0f/255.0f blue:42.0f/255.0f alpha:1.0f]];
        }
        else
        {
            [self.lblWinningBeaten setText:@"Beaten"];
            [self.lblWinningBeaten setTextColor:[UIColor colorWithRed:212.0f/255.0f green:46.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
        }
        
        // if MyHighestBid is equal to zero then it is N/A
        if (strMyHighest.intValue==0)
        {
            [self.lblWinningBeaten setHidden:YES];
            [self.labelMyBidValue setText:@"My Bid: N/A"];
        }
        else
        {
            [self.lblWinningBeaten setHidden:NO];
            [self.labelMyBidValue setText:[NSString stringWithFormat:@"My Bid: %@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:strMyHighest]]];
        }
        
        [self.collectionDetail reloadData];
        
    }
    if ([elementName isEqualToString:@"Status"])
    {
        if (checkStatus==iPlacingBid)
        {
            if ([currentNodeContent isEqualToString:@"Ok"])
            {
                currentNodeContent = [NSMutableString stringWithString:@"Your bid is successful"];
               
                
                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                    
                    if (didCancel)
                    {
                        
                         [self hideProgressHUD];
                        
                    }
                }];

                checkStatus = iClear;
                [self.textFieldPlaceBid setPlaceholder:[[[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.strBidValue] componentsSeparatedByString:@"."] objectAtIndex:0]];
                [self.textFieldPlaceBid setText:[[[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.strBidValue] componentsSeparatedByString:@"."] objectAtIndex:0]];
                
                 [self refreshVehicleDetailPage]; // refresh detail page
                 appdelegate.isRefreshUI=YES;
                 //[vehicleListDelegates getRefreshedVehicleListing];// refresh list page
                
                isPlaceBidFailed = NO;
            }
            else if([currentNodeContent isEqualToString:@"Failure"])
            {
                isPlaceBidFailed = YES;
            }
            else if([currentNodeContent containsString:@"You are already the highest bidder"])
            {
                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                    
                    if (didCancel)
                    {
                        
                        [self hideProgressHUD];
                        
                    }
                }];
            }
           
            
           
        }
        if (checkStatus==iBuyNow)
        {
            if([currentNodeContent isEqualToString:@"Failure"])
            {
                isBuyNowBidFailed = YES;
            
            }
            else
            {
                currentNodeContent = [NSMutableString stringWithString:@"You have purchased this vehicle."];
                
           //[vehicleListDelegates getRefreshedVehicleListing];// refresh list page
            appdelegate.isRefreshUI=YES;
                
            checkStatus = iClear;
            
                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                    
                    if (didCancel)
                    {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                     }];
                
                
            }
        }
        if (checkStatus==iAutomatedBid)
        {
            if ([currentNodeContent isEqualToString:@"Ok"])
            {
                currentNodeContent = [NSMutableString stringWithString:@"Your bid limit set successfully"];
                [self refreshVehicleDetailPage]; // refresh detail page
                //[vehicleListDelegates getRefreshedVehicleListing];// refresh list page
                 appdelegate.isRefreshUI=YES;
                [self.textFieldPlaceBid setPlaceholder:[[[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.strBidValue] componentsSeparatedByString:@"."] objectAtIndex:0]];
                
                [self.textFieldPlaceBid setText:[[[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.strBidValue] componentsSeparatedByString:@"."] objectAtIndex:0]];
                 checkStatus = iClear;
                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                    
                    if (didCancel)
                    {
                        NSString *secondString = [NSString stringWithFormat:@"Max Bid %@. Current Bid %@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.textFieldLimitBidAmount.text],[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",bidAmountWithIncrement]]];
                        
                        self.lblTitle.text = [NSString stringWithFormat:@"Automated Bidding Active: %@. %@",[NSString stringWithFormat:@"Started at %@ with Increment of %@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.strBidValue],[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.strIncrementValue]],secondString];
                        
                        if([self.lblTitle.text length]>0)
                        {
                            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.lblTitle.text];
                            NSRange fullRange = NSMakeRange(0, 25);
                            
                            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                            {
                                [string addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:15.0f]} range:fullRange];
                            }
                            else
                            {
                                [string addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:20.0f]} range:fullRange];
                            }
                            
                            [self.lblTitle setAttributedText:string];
                        }
                        
                        [self.btnActivateForExpandableView setTitle:@"Amend" forState:UIControlStateNormal];
                        [self.btnCancelForExpandableView setTitle:@"Disable" forState:UIControlStateNormal];
                        [self.btnCancelForExpandableView setTitleColor:[UIColor colorWithRed:212.0f/255.0f green:46.0f/255.0f blue:48.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                        
                        self.buttonAutomatedBidding.selected = !self.buttonAutomatedBidding.selected;
                        [self.tableBuy reloadData];
                    }
                }];

            }
            else if([currentNodeContent isEqualToString:@"Failure"])
            {
                isAutomatedBidFailed = YES;
            }
            
        }
        if (checkStatus==iRemoveAutoBid)
        {
            if ([currentNodeContent isEqualToString:@"OK"])
            {
                AutoBidAmount = 0;
                currentNodeContent = [NSMutableString stringWithString:@"Your automated bidding is disabled"];
                
                [self.btnCancelForExpandableView setTitle:@"Cancel" forState:UIControlStateNormal];
                [self.btnActivateForExpandableView setTitle:@"Activate" forState:UIControlStateNormal];
                [self.btnCancelForExpandableView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    [self.lblTitle setFrame:CGRectMake(24, 5, 262, 45)];
                }
                else
                {
                    [self.lblTitle setFrame:CGRectMake(24, 5, 720, 45)];
                }
                [self.lblMaximumBid setFrame:CGRectMake(self.lblMaximumBid.frame.origin.x, self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height + 10.0,self.lblMaximumBid.frame.size.width, self.lblMaximumBid.frame.size.height)];
                
                [self.textFieldLimitBidAmount setFrame:CGRectMake(self.lblMaximumBid.frame.origin.x + self.lblMaximumBid.frame.size.width + 10.0, self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height + 10.0,self.textFieldLimitBidAmount.frame.size.width, self.textFieldLimitBidAmount.frame.size.height)];
                
                [self.btnCancelForExpandableView setFrame:CGRectMake(self.btnCancelForExpandableView.frame.origin.x, self.textFieldLimitBidAmount.frame.origin.y + self.textFieldLimitBidAmount.frame.size.height + 19.0,self.btnCancelForExpandableView.frame.size.width, self.btnCancelForExpandableView.frame.size.height)];
                
                [self.btnActivateForExpandableView setFrame:CGRectMake(self.btnCancelForExpandableView.frame.origin.x + self.btnCancelForExpandableView.frame.size.width + 40.0 , self.btnCancelForExpandableView.frame.origin.y,self.btnActivateForExpandableView.frame.size.width, self.btnActivateForExpandableView.frame.size.height)];
                [self.lblMaximumBid setHidden:NO];
                [self.textFieldLimitBidAmount setText:@""];
                [self.textFieldLimitBidAmount setHidden:NO];
            }
            UIAlertView *placeBidSuccess  = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            checkStatus = iClear;
            
            [placeBidSuccess show];
            
            self.buttonAutomatedBidding.selected = !self.buttonAutomatedBidding.selected;
        }
    }
    if([elementName isEqualToString:@"Reason"])
    {
        if([currentNodeContent isEqualToString:@"Unknown Error"])
        {
            lblCustomPopupMessage.text = @"Your offer did not go through. Please try again. If this issue persists:";
            [self loadPopup];
        }
        
        
        if(isPlaceBidFailed)
        {
             if([currentNodeContent isEqualToString:@"You are not authorised to access this."] || [currentNodeContent isEqualToString:@"You are not authorized to bid on vehicles"])
             {
                 checkStatus = iClear;
                 [self loadPopup];
             
             }
              else
              {
                  UIAlertView *placeBidFail  = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                   [placeBidFail show];
                  
              }
            isPlaceBidFailed = NO;
        }
        
       else if(isAutomatedBidFailed)
       {
           if([currentNodeContent isEqualToString:@"You are not authorised to access this."] || [currentNodeContent isEqualToString:@"You are not authorized to bid on vehicles"])
           {
               lblCustomPopupMessage.text = currentNodeContent;
               checkStatus = iClear;
               [self loadPopup];
               
           }
           else
           {
               if([currentNodeContent isEqualToString:@"You are not authorised to access this."] || [currentNodeContent isEqualToString:@"You are not authorized to bid on vehicles"])
               {
                   [self.textFieldLimitBidAmount setText:@""];
                   lblCustomPopupMessage.text = currentNodeContent;
               }
               UIAlertView *placeBidFail  = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
               [placeBidFail show];
               
           }
           isAutomatedBidFailed = NO;
       }
        else if(isBuyNowBidFailed)
        {
            if([currentNodeContent isEqualToString:@"You are not authorised to access this."])
            {
                checkStatus = iClear;
                lblCustomPopupMessage.text = currentNodeContent;
                [self loadPopup];
                
            }
            else
            {
                UIAlertView *placeBidFail  = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [placeBidFail show];
                
            }
            isBuyNowBidFailed = NO;
        }
    }
    if([elementName isEqualToString:@"Error"])
    {
        if([currentNodeContent isEqualToString:@"You are not set up to see this vehicle"])
        {
            cantViewVehicleDetails = YES;
            lblCustomPopupMessage.text = currentNodeContent;
            checkStatus = iClear;
            [self loadPopup];
        }
        else
        {
            //[vehicleListDelegates getRefreshedVehicleListing];
             appdelegate.isRefreshUI=YES;
        }
    }
    
    // Seller Rating parsing
    
    
    if([elementName isEqualToString:@"Value"])
    {
         if(!isQuestionsMainTagEntered)
         {
             sellerRatingStarValue = currentNodeContent.floatValue;
         }
        else
        {
            rateSellerObject.strRateBuyerRatting = currentNodeContent;
        }
    }
    if([elementName isEqualToString:@"Reviews"])
    {
        totalSellerReviews = currentNodeContent.intValue;
    }
    if([elementName isEqualToString:@"Name"])
    {
        rateSellerObject.strRateBuyerQuestion = currentNodeContent;
    }
    if([elementName isEqualToString:@"question"])
    {
        [arrayOfRateQuestions addObject:rateSellerObject];
    }
    if([elementName isEqualToString:@"GetRatingForSellerResult"])
    {
        
        [self hideProgressHUD];
        [self webServiceForMessagesList];
    }
    
    // Message service parsing :
    
    if ([elementName isEqualToString:@"Name"])
    {
        messageObject.strClientName  = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Date"])
    {
        messageObject.strSoldDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Message"])
    {
        messageObject.strMessage = currentNodeContent;
    }
    if ([elementName isEqualToString:@"message"])
    {
        [arrayOfMessages addObject:messageObject];
    }

    
    // Add message service parsing
    
    if ([elementName isEqualToString:@"SUCCESS"])
    {
        
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Message submitted successfully" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel)
            {
                 [self hideProgressHUD];
               
                SMVehiclelisting *addedMessageObject = [[SMVehiclelisting alloc]init];
                addedMessageObject.strMessage = self.txtFieldComment.text;
                addedMessageObject.strSoldDate = @"Just now";
                addedMessageObject.strClientName = [SMGlobalClass sharedInstance].strName;
                [arrayOfMessages addObject:addedMessageObject];
                [self.tableBuy reloadData];
                 [self.txtFieldComment setText:@""];
                return;
                
            }
            
        }];

    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
    [self.tableBuy reloadData];
    [self.tableVehicleListing reloadData];
    
}

#pragma mark - Calculate Label Height

-(CGFloat)heightOfTextForString:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize
{
    // iOS7
    
   // if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    
        CGSize sizeOfText = [aString boundingRectWithSize: aSize
                                                  options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes: [NSDictionary dictionaryWithObject:aFont
                                                                                       forKey:NSFontAttributeName]
                                                  context: nil].size;
        
        return ceilf(sizeOfText.height);
    
   
}

#pragma mark - TableVehicleListTableFooterView

-(void) setTableVehicleListTableFooterView:(CGFloat) newHeight
{
    // setting footer height
    CGRect FooterFrame                       = self.tableBuy.tableFooterView.frame;
    FooterFrame.size.height                  = newHeight;
    self.viewTableFooter.frame              = FooterFrame;
    self.tableBuy.tableFooterView           = self.viewTableFooter;
}

#pragma mark - registerNib

-(void) registerNib
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.collectionDetail registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil]           forCellWithReuseIdentifier:@"Cell"];
        
        [self.tableVehicleListing registerNib:[UINib nibWithNibName:@"SMDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    }
    else
    {
        [self.collectionDetail registerNib:[UINib nibWithNibName:@"CollectionCell_iPad" bundle:nil]           forCellWithReuseIdentifier:@"Cell"];
        
        [self.tableVehicleListing registerNib:[UINib nibWithNibName:@"SMDetailTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"Cell"];
    }
    
    [self.tableBuy setTableFooterView:self.viewTableFooter];
}

#pragma mark - Custom Delegate Method

-(void) refreshVehicleDetailPage
{
    isDetailServiceCalled = YES;
    [self loadingAllDetails];
}

- (CGFloat)heightForText:(NSString *)bodyText
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        textSize = 187;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:18];
        textSize = 570;
    }
    CGSize constraintSize = CGSizeMake(textSize, MAXFLOAT);
    CGRect textRect = [bodyText boundingRectWithSize:constraintSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:cellFont}
                                             context:nil];
    
    CGSize labelSize = textRect.size;
    CGFloat height = labelSize.height;
    
    return height;}

- (CGFloat)heightForTextForSecondSection:(NSString *)bodyText andTextWidthForiPhone:(float)textWidth
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        textSize = textWidth;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:18];
        textSize = textWidth;
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


-(void)setAttributedTextWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithFirstColor:(UIColor*)colorFirst andWithSecondColor:(UIColor*)colorSecond withSmallFont:(BOOL) isSmallFontNeeded forLabel:(UILabel*)label
{
    
    UIFont *regularFont;
    UIFont *smallFont;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        
        smallFont = [UIFont fontWithName:FONT_NAME_BOLD size:11.0];
        
    }
    else
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        smallFont = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        
    }
    
    // Create the attributes
    NSDictionary *FirstAttribute;
    NSDictionary *SecondAttribute;
    
    if(isSmallFontNeeded)
    {
        FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                          smallFont, NSFontAttributeName,
                          colorFirst, NSForegroundColorAttributeName, nil];
        
        SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                           regularFont, NSFontAttributeName,
                           colorSecond, NSForegroundColorAttributeName, nil];
        
        
        
    }
    else
    {
        FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                          regularFont, NSFontAttributeName,
                          colorFirst, NSForegroundColorAttributeName, nil];
        
        SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                           regularFont, NSFontAttributeName,
                           colorSecond, NSForegroundColorAttributeName, nil];
        
        
        
        
    }
    
    
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:firstText
                                                                                           attributes:FirstAttribute];
    
    if([secondText length] == 0)
    {
        secondText = @"Checkit";
    }
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:secondText
                                                                                             attributes:SecondAttribute];
    
    
    
    
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    
    UIFont *regularFont;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        
    }
    else
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    
    UIColor *foregroundColorBlue = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
    
    
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:firstText
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:secondText
                                                                                             attributes:SecondAttribute];
    
    
    
    
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

-(CGFloat)returnTheHeightForFirstCell
{
    CGFloat finalDynamicHeight = 0.0f;
    
    
    CGFloat heightName = 0.0f;
    
    NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",self.vehicleObj.strVehicleYear,self.vehicleObj.strVehicleName];
    
    heightName = [self heightForText:strVehicleNameHeight];
    
   // NSLog(@"Name height = %f",heightName);
    
    CGFloat heightDetails1 = 0.0f;
    
      
    
    NSString *strDetails1Height = [NSString stringWithFormat:@"%@ | %@",self.vehicleObj.strVehicleMileage,self.vehicleObj.strVehicleColor];
    
    heightDetails1 = [self heightForText:strDetails1Height];
    
    CGFloat heightDetails2 = 0.0f;
    
    NSString *strDetails2Height = [NSString stringWithFormat:@"%@ | %@",self.vehicleObj.strLocation,[NSString stringWithFormat:@"Exp. %@",self.vehicleObj.strVehicleTeadeTimeLeft]];
    
    heightDetails2 = [self heightForText:strDetails2Height];
    
    //finalDynamicHeight = (110.0+ 21.0); // 110 is height of the image
    
    finalDynamicHeight = heightName+heightDetails1+heightDetails2+21.0+21.0;
    
   if(!self.isLabelMinBidHide && finalDynamicHeight<=131.0)
    {
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            if(finalDynamicHeight+25 < 135)
                finalDynamicHeight = 115;
            
            return finalDynamicHeight+29;
        }
        else
        {
            return finalDynamicHeight+45;
        }
  
    }
    else
    {
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            if(isLabelWinBeatValueHidden)
            {
                if(arrayTradeSliderDetails.count == 0)
                {
                    return finalDynamicHeight  + 10.0;
                }
                else
                {
                    return (finalDynamicHeight -21.0) + 10.0;

                }
            }
            else
            {
                 if(!self.isLabelMinBidHide)
                 {
                     
                     if(arrayTradeSliderDetails.count == 0)
                     {
                         return finalDynamicHeight+ 45;
                     }
                     else
                     {
                        return finalDynamicHeight+ 15;
                     }
                 }
                else
                {
                   return finalDynamicHeight+10;
                }
            }
        }
        else
        {
            return finalDynamicHeight+28;
        }
    }
    
    
}

-(void)setTheLabelCountText:(int)lblCount
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
- (BOOL)validate
{
    if (!self.txtFieldComment.text.length>0)
    {
        SMAlert(KLoaderTitle, @"Please enter a comment");
        
        return NO;
    }
    else
        return YES;
}

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(IBAction)btnSectionTitleDidClicked:(id)sender
{
    [self.view endEditing:YES];
    
    UIButton *btn = (UIButton *) sender;
  
    if(btn.tag == 1)
    {
        isSectionSecondExpanded = !isSectionSecondExpanded;
        
        if(isSectionSecondExpanded)
           isSectionThirdExpanded = NO;
        
    }
    else
    {
        isSectionThirdExpanded = !isSectionThirdExpanded;
        
        if(isSectionThirdExpanded)
            isSectionSecondExpanded = NO;
        
    }
    
    [self.tableBuy reloadData];
    
}



- (IBAction)btnSubmitCommentDidClicked:(id)sender
{
    [self.txtFieldComment resignFirstResponder];
    
    if([self validate])
        [self webServiceForAddingMessage];
    
    
}
- (IBAction)buttonImageClickableDidPressed:(id)sender
{
    if ([arrayFullImages count]>0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            networkGallery               = [[FGalleryViewController alloc] initWithPhotoSource:self];
            networkGallery.startingIndex = [sender tag];
            SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
            appdelegate.isPresented =  YES;
            [self.navigationController pushViewController:networkGallery animated:YES];
        });
    }
}

#pragma mark - Custom AlertView

#pragma mark- load popup
-(void)loadPopup
{
    
    [popUpView setFrame:[UIScreen mainScreen].bounds];
    [popUpView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.50]];
    [popUpView setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popUpView];
    [popUpView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [popUpView setAlpha:0.75];
         [popUpView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [popUpView setAlpha:1.0];
              
              [popUpView setTransform:CGAffineTransformIdentity];
          }
                          completion:^(BOOL finished)
          {
          }];
         
     }];
}

#pragma mark - dismiss popup
-(void)dismissPopup
{
    [popUpView setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popUpView];
    [UIView animateWithDuration:0.1 animations:^{
        [popUpView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [popUpView setAlpha:0.3];
              [popUpView setTransform:CGAffineTransformMakeScale(0.9    ,0.9)];
              
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   
                   [popUpView setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [popUpView removeFromSuperview];
                   [popUpView setTransform:CGAffineTransformIdentity];
                   
                   
               }];
              
          }];
         
     }];
    
}


#pragma mark -

- (IBAction)btnCancelCustomAlertDidClicked:(id)sender
{
    [self dismissPopup];
    if(cantViewVehicleDetails)
    {
        [self.navigationController popViewControllerAnimated:YES];
        cantViewVehicleDetails = NO;
    }
}


- (IBAction)btnEmailDidClicked:(id)sender
{
    [self dismissPopup];
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setToRecipients:@[@"support@ix.co.za"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:mail animated:YES completion:NULL];
            
        });
    }
    else
    {
        UIAlertView *alertInternal = [[UIAlertView alloc]
                                      initWithTitle: NSLocalizedString(@"Notification", @"")
                                      message: NSLocalizedString(@"You have not configured your e-mail client.", @"")
                                      delegate: nil
                                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                      otherButtonTitles:nil];
        [alertInternal show];
    }
    
    
    
}

- (IBAction)btnPhoneDidClicked:(id)sender
{
    [self dismissPopup];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0861292999"]];
}
#pragma mark


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultSent:
            [self showAlert:@"You Sent The Email."];
            break;
        case MFMailComposeResultSaved:
            [self showAlert:@"You Saved A Draft Of This Email."];
            break;
        case MFMailComposeResultCancelled:
            [self showAlert:@"You Cancelled Sending This Email."];
            break;
        case MFMailComposeResultFailed:
            [self showAlert:@"An Error Occurred When Trying To Compose This Email."];
            break;
        default:
            [self showAlert:@"An Error Occurred When Trying To Compose This Email"];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showAlert:(NSString*)message
{
    SMAlert(KLoaderTitle, message);
}




@end
