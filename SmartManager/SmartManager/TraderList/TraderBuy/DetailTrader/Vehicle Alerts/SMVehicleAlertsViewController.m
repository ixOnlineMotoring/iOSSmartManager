//
//  SMVehicleAlertsViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 17/09/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMVehicleAlertsViewController.h"
#import "SMCustomDynamicCell.h"
#import "SMViewOfStaticData.h"
#import "SMCommonClassMethods.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"
static int kPageSize=10;

typedef enum : NSUInteger
{
    missingPriceVC = 0,
    activateRetailVC,
    missingInfoVC
    
    
}viewControllerType;


@interface SMVehicleAlertsViewController ()

@end

@implementation SMVehicleAlertsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addingProgressHUD];
    msgActivateTradeFail = @"";
    arrayOfViewObject = [[NSMutableArray alloc]init];
    self.tblViewVehicleAlerts.tableHeaderView = viewTableHeader;
    
    switch (self.viewControllerVehicleAlertType)
    {
        case missingPriceVC:
        {
            [self setTheTitleForScreenAs:@"Missing Price"];
            
            arrayOfMissingPrice = [[NSMutableArray alloc]init];
            [self webServiceForTradeMissingPrice];
        }
            break;
        case activateRetailVC:
        {
            [self setTheTitleForScreenAs:@"Activate Retail"];
            arrayOfActivateTrade = [[NSMutableArray alloc]init];
            [self webServiceForTradeActivateRetail];
        }
            break;
        case missingInfoVC:
        {
            [self setTheTitleForScreenAs:@"Missing Info"];
            arrayOfMissingInfo = [[NSMutableArray alloc]init];
            [self webServiceForTradeMissingInfo];
        }
            break;
    }
    
    self.tblViewVehicleAlerts.tableFooterView = [[UIView alloc]init];

}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

-(void)refreshTheVehicleListModule
{
    [self addingProgressHUD];
    msgActivateTradeFail = @"";
    arrayOfViewObject = [[NSMutableArray alloc]init];
    switch (self.viewControllerVehicleAlertType)
    {
        case missingPriceVC:
        {
            [self setTheTitleForScreenAs:@"Missing Price"];
            
            arrayOfMissingPrice = [[NSMutableArray alloc]init];
            [self webServiceForTradeMissingPrice];
        }
            break;
        case activateRetailVC:
        {
            [self setTheTitleForScreenAs:@"Activate Trade"];
            arrayOfActivateTrade = [[NSMutableArray alloc]init];
            [self webServiceForTradeActivateRetail];
        }
            break;
        case missingInfoVC:
        {
            [self setTheTitleForScreenAs:@"Missing Info"];
            arrayOfMissingInfo = [[NSMutableArray alloc]init];
            [self webServiceForTradeMissingInfo];
        }
            break;
    }
    
    self.tblViewVehicleAlerts.tableFooterView = [[UIView alloc]init];
 
}

#pragma mark - UIKeyboard Notification

- (void)keyboardWasShown:(NSNotification*)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.tblViewVehicleAlerts.frame = CGRectMake(self.tblViewVehicleAlerts.frame.origin.x, self.tblViewVehicleAlerts.frame.origin.y, self.tblViewVehicleAlerts.frame.size.width, [self view].bounds.size.height - (keyboardSize.height+2.0));
    
}

- (void)keyboardWasHidden:(NSNotification*)notification
{
    self.tblViewVehicleAlerts.frame = CGRectMake(self.tblViewVehicleAlerts.frame.origin.x, self.tblViewVehicleAlerts.frame.origin.y, self.tblViewVehicleAlerts.frame.size.width, [self view].bounds.size.height);
    
}

#pragma mark - textField delegate

-(BOOL)textFieldShouldReturn:(SMCustomTextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UITableViewDataSource

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.viewControllerVehicleAlertType)
    {
        case missingPriceVC:
        {
        return arrayOfMissingPrice.count;
        }
        case activateRetailVC:
        {
            return arrayOfActivateTrade.count;
        }
            break;
        case missingInfoVC:
        {
            return arrayOfMissingInfo.count;
        }
        break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier=@"SMCustomDynamicCell";
    
    SMCustomDynamicCell *dynamicCell;
    
    
    UILabel *vehicleName;
    UILabel *lblVehicleDetails1;
    UILabel *lblVehicleDetails2;
    UILabel *lblVehicleDetails3;
    
    SMViewOfStaticData *objProfileHeaderView;
    
    SMPhotosAndExtrasObject *rowObj;
    
    switch (self.viewControllerVehicleAlertType)
    {
        case missingPriceVC:
        {
         rowObj = (SMPhotosAndExtrasObject*)[arrayOfMissingPrice objectAtIndex:indexPath.row];
        }
            break;
        case activateRetailVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfActivateTrade objectAtIndex:indexPath.row];
        }
            break;
        case missingInfoVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfMissingInfo objectAtIndex:indexPath.row];
        }
            break;
    }

    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightName = 0.0f;
    
    NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",rowObj.strUsedYear,rowObj.strVehicleName];
    
    heightName = [self heightForText:strVehicleNameHeight];
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails1 = 0.0f;
   
    if([rowObj.strRegistration length] == 0 || [rowObj.strRegistration isKindOfClass:[NSNull class]])
    {
        rowObj.strRegistration = @"Reg?";
    }
    NSString  *strVehicleDetails1 = [NSString stringWithFormat:@"%@ | %@ | %@",rowObj.strRegistration,rowObj.strColour,rowObj.strStockCode];
    
    heightDetails1 = [self heightForText:strVehicleDetails1];
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails2 = 0.0f;
    
       NSString  *strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@",rowObj.strVehicleType,rowObj.strMileage];
    
    heightDetails2 = [self heightForText:strVehicleDetails2];
    
     //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails3 = 0.0f;
    UILabel *tempLabel = [[UILabel alloc]init];
    
    if(rowObj.strTradePrice.length == 0 || [rowObj.strTradePrice isEqualToString:@"R0"])
        rowObj.strTradePrice = @"R?";
    NSLog(@"TradePrice = %@",rowObj.strTradePrice);
    [self setAttributedTextForVehicleDetailsWithFirstText:@"Ret." andWithSecondText:rowObj.strRetailPrice andWithThirdText:@" | " andWithFourthText:@"Trd." andWithFifthText:rowObj.strTradePrice forLabel:tempLabel];
    
    heightDetails3 = [self heightForText:tempLabel.text];
    tempLabel = nil;
    
    //----------------------------------------------------------------------------------------

    
    if (dynamicCell == nil)
    {
        dynamicCell = [[SMCustomDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        vehicleName = [[UILabel alloc]init];
        lblVehicleDetails1 = [[UILabel alloc]init];
        lblVehicleDetails2 = [[UILabel alloc]init];
        lblVehicleDetails3 = [[UILabel alloc]init];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            
            vehicleName.frame = CGRectMake(8.0, 6.0, 311.0, heightName);
            lblVehicleDetails1.frame = CGRectMake(6.0, vehicleName.frame.origin.y + vehicleName.frame.size.height+4.0, 311.0, heightDetails1);
            lblVehicleDetails2.frame = CGRectMake(8.0, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+4.0, 311.0, heightDetails2);
            lblVehicleDetails3.frame = CGRectMake(8.0, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+4.0, 311.0, heightDetails3);
            
          
            
            switch (self.viewControllerVehicleAlertType)
            {
                case missingPriceVC:
                    
                case activateRetailVC:
                {
                    
                    
                    objProfileHeaderView  = (SMViewOfStaticData *)[arrayOfViewObject objectAtIndex:indexPath.row];
                    
                    int tempValue;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                        tempValue = 155;
                    else
                        tempValue = 168;
                    objProfileHeaderView.btnEdit.layer.cornerRadius = 4.0;
                    objProfileHeaderView.btnActivateTrade.layer.cornerRadius = 4.0;
                    objProfileHeaderView.frame = CGRectMake(0.0, lblVehicleDetails3.frame.origin.y + lblVehicleDetails3.frame.size.height+1.0, 320, tempValue);
                    objProfileHeaderView.backgroundColor = [UIColor clearColor];
                    
                    objProfileHeaderView.checkBoxIsActive.tag = indexPath.row;
                    [objProfileHeaderView.checkBoxIsActive addTarget:self action:@selector(checkBoxIsActiveDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    objProfileHeaderView.btnEdit.tag = indexPath.row;
                    [objProfileHeaderView.btnEdit addTarget:self action:@selector(btnEditDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    objProfileHeaderView.btnActivateTrade.tag = indexPath.row;
                    [objProfileHeaderView.btnActivateTrade addTarget:self action:@selector(btnActivateTradeDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    objProfileHeaderView.txtFieldTradePrice.delegate = self;
                    
                    
                    [self setTheExtrasCommmentsPhotoswithExtrasObject:objProfileHeaderView andRowObject:rowObj];

                }
                    break;
                case missingInfoVC:
                {
                    NSArray *arrProfileHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SMViewOfStaticDataForMissingInfo" owner:self options:nil];
                    
                    objProfileHeaderView  = (SMViewOfStaticData *)[arrProfileHeaderView objectAtIndex:0];
                    
                    objProfileHeaderView.btnEdit_MissingInfo.layer.cornerRadius = 4.0;
                    objProfileHeaderView.btnEdit_MissingInfo.tag = indexPath.row;
                    [objProfileHeaderView.btnEdit_MissingInfo addTarget:self action:@selector(btnEditDidClicked:) forControlEvents:UIControlEventTouchUpInside];

                    int tempValue;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                        tempValue = 80;
                    else
                        tempValue = 95;
                    objProfileHeaderView.frame = CGRectMake(0.0, lblVehicleDetails3.frame.origin.y + lblVehicleDetails3.frame.size.height+1.0, 320, tempValue);
                    objProfileHeaderView.backgroundColor = [UIColor clearColor];
                    
                    [self setTheExtrasCommmentsPhotoswithExtrasObject:objProfileHeaderView andRowObject:rowObj];
                   
                }
                    break;
            }
            
            
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
            
        
            
            switch (self.viewControllerVehicleAlertType)
            {
                case missingPriceVC:
                    
                case activateRetailVC:
                {
                    NSArray *arrProfileHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SMViewOfStaticData_iPad" owner:self options:nil];
                    
                    objProfileHeaderView  = (SMViewOfStaticData *)[arrProfileHeaderView objectAtIndex:0];
                    
                    objProfileHeaderView.btnEdit.layer.cornerRadius = 4.0;
                    objProfileHeaderView.btnActivateTrade.layer.cornerRadius = 4.0;
                    objProfileHeaderView.frame = CGRectMake(0.0, lblVehicleDetails3.frame.origin.y + lblVehicleDetails3.frame.size.height+1.0, 320, 155);
                    objProfileHeaderView.backgroundColor = [UIColor clearColor];
                    
                    objProfileHeaderView.checkBoxIsActive.tag = indexPath.row;
                    [objProfileHeaderView.checkBoxIsActive addTarget:self action:@selector(checkBoxIsActiveDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    objProfileHeaderView.btnEdit.tag = indexPath.row;
                    [objProfileHeaderView.btnEdit addTarget:self action:@selector(btnEditDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    objProfileHeaderView.btnActivateTrade.tag = indexPath.row;
                    [objProfileHeaderView.btnActivateTrade addTarget:self action:@selector(btnActivateTradeDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    objProfileHeaderView.txtFieldTradePrice.delegate = self;
                    
                    [self setTheExtrasCommmentsPhotoswithExtrasObject:objProfileHeaderView andRowObject:rowObj];
                    
                    
                }
                    break;
                case missingInfoVC:
                {
                    NSArray *arrProfileHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SMViewOfStaticDataForMissingInfo_iPad" owner:self options:nil];
                    
                    objProfileHeaderView  = (SMViewOfStaticData *)[arrProfileHeaderView objectAtIndex:0];
                    NSLog(@"executed thissssss.");
                    objProfileHeaderView.btnEditMisingInfo.tag = indexPath.row;
                    [objProfileHeaderView.btnEditMisingInfo addTarget:self action:@selector(btnEditMissingInfoDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    objProfileHeaderView.frame = CGRectMake(0.0, lblVehicleDetails3.frame.origin.y + lblVehicleDetails3.frame.size.height+1.0, 768, 100);
                    objProfileHeaderView.backgroundColor = [UIColor clearColor];
                    [self setTheExtrasCommmentsPhotoswithExtrasObject:objProfileHeaderView andRowObject:rowObj];
                    
                }
                    break;
            }
            

            
            
            
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
        
        [self setAttributedTextForVehicleDetailsWithFirstText:rowObj.strUsedYear andWithSecondText:rowObj.strVehicleName forLabel:vehicleName];
       
        if([rowObj.strRegistration length] == 0 || [rowObj.strRegistration isKindOfClass:[NSNull class]])
        {
            rowObj.strRegistration = @"Reg?";
        }

       lblVehicleDetails1.text =  [NSString stringWithFormat:@"%@ | %@ | %@",rowObj.strRegistration,rowObj.strColour,rowObj.strStockCode];
        
        lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@",rowObj.strVehicleType,rowObj.strMileage];
        
        if(rowObj.strTradePrice.length == 0 || [rowObj.strTradePrice isEqualToString:@"0"])
            rowObj.strTradePrice = @"R?";
        NSLog(@"TradePrice = %@",rowObj.strTradePrice);
        [self setAttributedTextForVehicleDetailsWithFirstText:@"Ret." andWithSecondText:rowObj.strRetailPrice andWithThirdText:@" | " andWithFourthText:@"Trd." andWithFifthText:rowObj.strTradePrice forLabel:lblVehicleDetails3];

       
        
        [dynamicCell.contentView addSubview:vehicleName];
        [dynamicCell.contentView addSubview:lblVehicleDetails1];
        [dynamicCell.contentView addSubview:lblVehicleDetails2];
        [dynamicCell.contentView addSubview:lblVehicleDetails3];
        [dynamicCell.contentView addSubview:objProfileHeaderView];
        
       
    }
    
   // NSLog(@"objProfileHeaderView.viewInnerView = %@", NSStringFromCGRect(objProfileHeaderView.viewInnerView.frame));
    vehicleName.numberOfLines = 0;
    [vehicleName sizeToFit];
    
    lblVehicleDetails1.numberOfLines = 0;
    [lblVehicleDetails1 sizeToFit];
    
    
    lblVehicleDetails2.numberOfLines = 0;
    [lblVehicleDetails2 sizeToFit];
    
    lblVehicleDetails3.numberOfLines = 0;
    [lblVehicleDetails3 sizeToFit];
    
    lblVehicleDetails1.textColor = [UIColor whiteColor];
    lblVehicleDetails2.textColor = [UIColor whiteColor];
    vehicleName.backgroundColor = [UIColor blackColor];
    
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        dynamicCell.layoutMargins = UIEdgeInsetsZero;
        dynamicCell.preservesSuperviewLayoutMargins = NO;
    }
    dynamicCell.backgroundColor = [UIColor blackColor];
    
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    switch (self.viewControllerVehicleAlertType)
    {
            
        case missingPriceVC:
        {
            if (arrayOfMissingPrice.count-1 == indexPath.row)
            {
                
                if (arrayOfMissingPrice.count !=iTotalMissingPrice)
                {
                    ++iMissingPrice;
                    [self webServiceForTradeMissingPrice];
                    
                }
            }
            
        }
            break;
            
        case activateRetailVC:
        {
            if (arrayOfActivateTrade.count-1 == indexPath.row)
            {
                
                if (arrayOfActivateTrade.count !=iTotalActivateRetail)
                {
                    ++iActivateRetail;
                    [self webServiceForTradeActivateRetail];
                    
                }
            }
        }
            break;
            
        case missingInfoVC:
        {
            if (arrayOfMissingInfo.count-1 == indexPath.row)
            {
                if (arrayOfMissingInfo.count !=iTotalMissingInfo)
                {
                    ++iMissingInfo;
                    [self webServiceForTradeMissingInfo];
                    
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
    CGFloat finalDynamicHeight = 0.0f;
    
    SMPhotosAndExtrasObject *rowObj;
    
    switch (self.viewControllerVehicleAlertType)
    {
        case missingPriceVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfMissingPrice objectAtIndex:indexPath.row];
        }
        case activateRetailVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfActivateTrade objectAtIndex:indexPath.row];
        }
            break;
        case missingInfoVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfMissingInfo objectAtIndex:indexPath.row];
        }
            break;
    }
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightName = 0.0f;
    
    NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",rowObj.strUsedYear,rowObj.strVehicleName];
    
    heightName = [self heightForText:strVehicleNameHeight];
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails1 = 0.0f;
    
    if([rowObj.strRegistration length] == 0 || [rowObj.strRegistration isKindOfClass:[NSNull class]])
    {
        rowObj.strRegistration = @"Reg?";
    }

    NSString  *strVehicleDetails1 = [NSString stringWithFormat:@"%@ | %@ | %@",rowObj.strRegistration,rowObj.strColour,rowObj.strStockCode];
    
    heightDetails1 = [self heightForText:strVehicleDetails1];
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails2 = 0.0f;
    
    NSString  *strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@",rowObj.strVehicleType,rowObj.strMileage];
    
    heightDetails2 = [self heightForText:strVehicleDetails2];
    
    //----------------------------------------------------------------------------------------
    
    CGFloat heightDetails3 = 0.0f;
    UILabel *tempLabel = [[UILabel alloc]init];
    
    if(rowObj.strTradePrice.length == 0 || [rowObj.strTradePrice isEqualToString:@"0"])
        rowObj.strTradePrice = @"R?";
    
    NSLog(@"TradePrice = %@",rowObj.strTradePrice);
    
    [self setAttributedTextForVehicleDetailsWithFirstText:@"Ret." andWithSecondText:rowObj.strRetailPrice andWithThirdText:@" | " andWithFourthText:@"Trd." andWithFifthText:rowObj.strTradePrice forLabel:tempLabel];
    
    heightDetails3 = [self heightForText:tempLabel.text];
    tempLabel = nil;
    
    //----------------------------------------------------------------------------------------
    

    
    int tempValue=0;
    
    switch (self.viewControllerVehicleAlertType)
    {
        case missingPriceVC:
        
        case activateRetailVC:
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            tempValue = 155;
            else
            tempValue = 168;
        }
        break;
        case missingInfoVC:
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                tempValue = 80;
            else
                tempValue = 95;
        }
            break;
    }

    NSLog(@"tempValue = %d",tempValue);
    finalDynamicHeight = (heightName + heightDetails1 + heightDetails2 +heightDetails3+ tempValue + 15.0);
    
        return finalDynamicHeight+8;
  
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

#pragma mark - Custom Methods

- (IBAction)checkBoxIsActiveDidClicked:(UIButton*)sender
{
    sender.selected = !sender.selected;
}
- (IBAction)btnEditDidClicked:(UIButton*)sender
{
    NSLog(@" edit with index %ld",(long)[sender tag]);
    
    SMAddToStockViewController *addToStockVC;
    
    addToStockVC = [[SMAddToStockViewController alloc]initWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)? @"SMAddToStockViewController" : @"SMAddToStockViewController_iPad" bundle:nil];
    
    SMPhotosAndExtrasObject *rowObj;
    
    switch (self.viewControllerVehicleAlertType)
    {
        case missingPriceVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfMissingPrice objectAtIndex:sender.tag];
        }
            break;
        case activateRetailVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfActivateTrade objectAtIndex:sender.tag];
        }
            break;
        case missingInfoVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfMissingInfo objectAtIndex:sender.tag];
        }
            break;
    }
    
    addToStockVC.photosExtrasObject = rowObj;
    addToStockVC.isUpdateVehicleInformation = YES;
    addToStockVC.listRefreshDelegate = self;
    [SMGlobalClass sharedInstance].isListModule = YES;
    
    [self.navigationController pushViewController:addToStockVC animated:YES];

}
- (IBAction)btnEditMissingInfoDidClicked:(UIButton*)sender
{
    NSLog(@" edit with index %ld",(long)[sender tag]);
    
    SMAddToStockViewController *addToStockVC;
    
    addToStockVC = [[SMAddToStockViewController alloc]initWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)? @"SMAddToStockViewController" : @"SMAddToStockViewController_iPad" bundle:nil];
    
    SMPhotosAndExtrasObject *rowObj;
    
    switch (self.viewControllerVehicleAlertType)
    {
        case missingPriceVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfMissingPrice objectAtIndex:sender.tag];
        }
            break;
        case activateRetailVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfActivateTrade objectAtIndex:sender.tag];
        }
            break;
        case missingInfoVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfMissingInfo objectAtIndex:sender.tag];
        }
            break;
    }
    
    addToStockVC.photosExtrasObject = rowObj;
    addToStockVC.isUpdateVehicleInformation = YES;
    addToStockVC.listRefreshDelegate = self;
    [SMGlobalClass sharedInstance].isListModule = YES;
    
    [self.navigationController pushViewController:addToStockVC animated:YES];
    
}

- (IBAction)btnActivateTradeDidClicked:(UIButton*)sender
{
    
    SMViewOfStaticData *obj = (SMViewOfStaticData *)[arrayOfViewObject objectAtIndex:sender.tag];
    
    if (![obj.txtFieldTradePrice.text length]>0)
    {
        SMAlert(KLoaderTitle, KTradePrice);
        return ;
    }
    
    NSLog(@"%@",obj.txtFieldTradePrice);
    SMPhotosAndExtrasObject *rowObj;
    
    switch (self.viewControllerVehicleAlertType)
    {
        case missingPriceVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfMissingPrice objectAtIndex:sender.tag];
        }
            break;
        case activateRetailVC:
        {
            rowObj = (SMPhotosAndExtrasObject*)[arrayOfActivateTrade objectAtIndex:sender.tag];
        }
            break;
    }
    
    BOOL isTrade;
    
    if(obj.checkBoxIsActive.selected)
    {
        isTrade = 1;
    }
    else
    {
         isTrade = 0;
    }
    
    
    [self webServiceForActivatingVehicleWithStockCode:rowObj.strUsedVehicleStockID.intValue andIsTrade:isTrade andTradePrice:obj.txtFieldTradePrice.text.intValue];
    
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


-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText andWithFifthText:(NSString*)fifthText forLabel:(UILabel*)label
{
    NSLog(@"price1 = %@",secondText);
    NSLog(@"price2 = %@",fourthText);

    UIFont *valueFont;
    UIFont *titleFont;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:10.0];
        
    }
    
    else
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorGreen = [UIColor colorWithRed:64.0/255.0 green:198.0/255.0 blue:42.0/255.0 alpha:1.0];
    UIColor *foregroundColorYellow = [UIColor colorWithRed:187.0/255.0 green:140.0/255.0 blue:20.0/255.0 alpha:1.0];
    
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
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    NSMutableAttributedString *attributedFourthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",fourthText]
                                                                                             attributes:FourthAttribute];
    
    NSMutableAttributedString *attributedFifthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",fifthText]
                                                                                            attributes:FifthAttribute];
    
    
    
    [attributedFourthText appendAttributedString:attributedFifthText];
    [attributedThirdText appendAttributedString:attributedFourthText];
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
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



-(void)setTheExtrasCommmentsPhotoswithExtrasObject:(SMViewOfStaticData*)extrasObject andRowObject:(SMPhotosAndExtrasObject*)rowObject
{
    extrasObject.lblPhotosCount.text=rowObject.strPhotoCounts;
    extrasObject.lblVideosCount.text=rowObject.strVideosCount;
    
    if (!rowObject.strExtras)
    {
        [extrasObject.lblExtrasValue setText:@"x"];
        [extrasObject.lblExtrasValue setTextColor:[UIColor redColor]];
    }
    else
    {
        [extrasObject.lblExtrasValue setText:@"\u2713"];
        [extrasObject.lblExtrasValue setTextColor:[UIColor greenColor]];
    }
    
    if (!rowObject.strComments)
    {
        [extrasObject.lblCommentValue setText:@"x"];
        [extrasObject.lblCommentValue setTextColor:[UIColor redColor]];
    }
    else
    {
        [extrasObject.lblCommentValue setText:@"\u2713"];
        [extrasObject.lblCommentValue setTextColor:[UIColor greenColor]];
    }
    
    if (rowObject.VideosFlag==0)
    {
        [extrasObject.lblExtrasValue setText:@"x"];
        [extrasObject.lblExtrasValue setTextColor:[UIColor redColor]];
    }
    else
    {
        [extrasObject.lblExtrasValue setText:@"\u2713"];
        [extrasObject.lblExtrasValue setTextColor:[UIColor greenColor]];
        
    }

}

#pragma mark - WEb Services

-(void)webServiceForTradeMissingPrice
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
      NSMutableURLRequest *requestURL = [SMWebServices listTheTradeMissingPriceWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andPageNumber:iMissingPrice andPageSize:kPageSize];
    
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
-(void)webServiceForTradeMissingInfo
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
    NSMutableURLRequest *requestURL = [SMWebServices listTheTradeMissingInfoWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andPageNumber:iMissingInfo andPageSize:kPageSize];
    
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

-(void)webServiceForTradeActivateRetail
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
    NSMutableURLRequest *requestURL = [SMWebServices listTheTradeActivateRetailWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andPageNumber:iActivateRetail andPageSize:kPageSize];
    
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

-(void)webServiceForActivatingVehicleWithStockCode:(int)stockCode andIsTrade:(BOOL)isTrade andTradePrice:(int)traderPrice
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
    NSMutableURLRequest *requestURL = [SMWebServices activateTheVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andStockID:stockCode andIsTrade:isTrade andTradePrice:traderPrice];
    
    
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
    if ([elementName isEqualToString:@"TradeVehicleObject"])
    {
        photosAndExtrasObject  = [[SMPhotosAndExtrasObject alloc] init];
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
        photosAndExtrasObject.strUsedVehicleStockID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"StockCode"])
    {
        photosAndExtrasObject.strStockCode = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Department"])
    {
        photosAndExtrasObject.strVehicleType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"UsedYear"])
    {
        photosAndExtrasObject.strUsedYear = currentNodeContent;
    }
    if ([elementName isEqualToString:@"FriendlyName"])
    {
        photosAndExtrasObject.strVehicleName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        photosAndExtrasObject.strColour = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
        
        photosAndExtrasObject.strMileage = [NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent]];
    }
    if ([elementName isEqualToString:@"RetailPrice"])
    {
        if([currentNodeContent isEqualToString:@"0"] || currentNodeContent.length == 0)
            photosAndExtrasObject.strRetailPrice = @"R?";
        else
        {
            photosAndExtrasObject.strRetailPrice = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        }
    }
    if ([elementName isEqualToString:@"TradePrice"])
    {
        NSLog(@"Tradeeee = %@",currentNodeContent);
        if([currentNodeContent isEqualToString:@"0"] || currentNodeContent.length == 0 || [currentNodeContent isEqualToString:@"0.0000"])
            photosAndExtrasObject.strTradePrice = @"R?";
        else
        {
            photosAndExtrasObject.strTradePrice = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        }
    }
    if ([elementName isEqualToString:@"LoadDate"])
    {
        photosAndExtrasObject.strDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ImageCount"])
    {
        photosAndExtrasObject.strPhotoCounts = currentNodeContent;
    }
    if ([elementName isEqualToString:@"VideoCount"])
    {
        photosAndExtrasObject.strVideosCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Extras"])
    {
        photosAndExtrasObject.strExtras = currentNodeContent.boolValue;
    }
    if ([elementName isEqualToString:@"Comments"])
    {
        photosAndExtrasObject.strComments = currentNodeContent.boolValue;
    }
    if ([elementName isEqualToString:@"Registration"])
    {
        if([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"(null)"])
            photosAndExtrasObject.strRegistration = @"Reg?";
        else
        photosAndExtrasObject.strRegistration = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Message"])
    {
        msgActivateTradeFail = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TradeVehicleObject"])
    {
        switch (self.viewControllerVehicleAlertType)
        {
            case missingPriceVC:
            {
                [arrayOfMissingPrice addObject:photosAndExtrasObject];
                
                NSArray *arrProfileHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SMViewOfStaticData" owner:self options:nil];
                
                SMViewOfStaticData *objProfileHeaderView  = (SMViewOfStaticData *)[arrProfileHeaderView objectAtIndex:0];

                [arrayOfViewObject addObject:objProfileHeaderView];
            }
                break;
            case activateRetailVC:
            {
                [arrayOfActivateTrade addObject:photosAndExtrasObject];
                NSArray *arrProfileHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SMViewOfStaticData" owner:self options:nil];
                
                SMViewOfStaticData *objProfileHeaderView  = (SMViewOfStaticData *)[arrProfileHeaderView objectAtIndex:0];
                
                [arrayOfViewObject addObject:objProfileHeaderView];

            }
                break;
            case missingInfoVC:
            {
               [arrayOfMissingInfo addObject:photosAndExtrasObject];
                NSArray *arrProfileHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SMViewOfStaticData" owner:self options:nil];
                
                SMViewOfStaticData *objProfileHeaderView  = (SMViewOfStaticData *)[arrProfileHeaderView objectAtIndex:0];
                
                [arrayOfViewObject addObject:objProfileHeaderView];

                
            }
                break;
        }

        
    }
    if ([elementName isEqualToString:@"GetTradeVehiclesMissingPriceResult"])
    {
        iTotalMissingPrice = totalRecordCount;
        self.tblViewVehicleAlerts.dataSource = self;
        self.tblViewVehicleAlerts.delegate = self;
        
        if(arrayOfMissingPrice.count == 0)
        {
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"No record(s) found." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                if (didCancel)
                {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    return;
                    
                }
                
            }];
        }
        else
        {
            [self.tblViewVehicleAlerts reloadData];
        }
    }
    if ([elementName isEqualToString:@"GetRetailVehiclesNotActivatedResult"])
    {
        iTotalActivateRetail = totalRecordCount;
        self.tblViewVehicleAlerts.dataSource = self;
        self.tblViewVehicleAlerts.delegate = self;
        if(arrayOfActivateTrade.count == 0)
        {
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"No record(s) found." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                if (didCancel)
                {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    return;
                    
                }
                
            }];
        }
        else
        {
            [self.tblViewVehicleAlerts reloadData];
        }
    }
    if ([elementName isEqualToString:@"GetVehiclesMissingInfoResult"] )
    {
        iTotalMissingInfo = totalRecordCount;
        self.tblViewVehicleAlerts.dataSource = self;
        self.tblViewVehicleAlerts.delegate = self;
        if(arrayOfMissingInfo.count == 0)
        {
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"No record(s) found." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                if (didCancel)
                {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    return;
                    
                }
                
            }];
        }
        else
        {
            [self.tblViewVehicleAlerts reloadData];
        }

    }
   
    if ([elementName isEqualToString:@"ActivateVehicleResult"])
    {
        
         if([msgActivateTradeFail length] !=0)
         {
             UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                 if (didCancel)
                 {
                     
                     [self.navigationController popViewControllerAnimated:YES];
                     
                     return;
                     
                 }
                 
             }];
         }
    }
    if ([elementName isEqualToString:@"Total"])
    {
        totalRecordCount = [currentNodeContent intValue];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)checkBoxIsTradeDidClicked:(id)sender {
}
@end
