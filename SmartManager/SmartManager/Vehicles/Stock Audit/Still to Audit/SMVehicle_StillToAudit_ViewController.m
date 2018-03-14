//
//  SMVehicle_StillToAudit_ViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 04/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMVehicle_StillToAudit_ViewController.h"
#import "SMClassForToDoObjects.h"
#import "SMStockAuditDetailObject.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIImageView+WebCache.h"
#import "UIBAlertView.h"
#import "SMCustomerDLScanViewController.h"
#import "SMCommonClassMethods.h"
#import "SMDonePlannerButton.h"

@interface SMVehicle_StillToAudit_ViewController ()

@end

@implementation SMVehicle_StillToAudit_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addingProgressHUD];
    isSectionFirstOpened =  NO;
    isSectionSecondOpened = NO;
    pageNumberUnMatchedCount = 0;
    pageNumberUnScannedCount = 0;

    totalAuditsCount = 0;
    totalNotScannedVehicles = 0;
    totalUnMatchedCount = 0;
    
    arrayOfSections = [[NSMutableArray alloc]init];
    arrayForFirstSection = [[NSMutableArray alloc]init];
    arrayForSecondSection = [[NSMutableArray alloc]init];
    [self populateTheSectionsArray];
    [self registerNib];
    //[self populateTheFirstSectionRows];
    //[self populateTheSecondSectionRows];
    self.btnExpandEmailList.tag = 1;
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
        self.btnExpandEmailList.titleEdgeInsets = UIEdgeInsetsMake(0, -655, 0, 0);
    
    self.btnSubmit.layer.cornerRadius = 5.0;
    self.btnSubmit.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    
    [self.headerView setNeedsLayout];
    [self.headerView layoutIfNeeded];
    CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
    
    UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
    [self.imgRightArrowTH setImage:rotatedImage];
    self.tblViewStillToAuditList.tableHeaderView = self.headerView;
    self.tblViewStillToAuditList.tableFooterView = [[UIView alloc]init];
    
    [self getStillToAuditListFromServerWithUnMatchedFlag:1 andUnScannedFlag:0];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                   withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - tableView delegate methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView == self.tblViewStillToAuditList)
        return  [arrayOfSections count];
    else
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.tblViewStillToAuditList)
    {
        
        
        SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayOfSections objectAtIndex:section];
        
        if (sectionObject.isExpanded)
        {
            if(section == 0)
                return arrayForFirstSection.count;
            
            return arrayForSecondSection.count;
            
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tblViewStillToAuditList)
    {
       
            if(indexPath.section == 0)
            {
            SMStockAuditDetailObject *auditTodayObj = [arrayForFirstSection objectAtIndex:indexPath.row];
            
            CGFloat height = 0.0f;
            
            height = ([self heightForText:[NSString stringWithFormat:@"GEO: %@",auditTodayObj.auditGeoAddress]]+ [self heightForText:[NSString stringWithFormat:@"%@ %@",auditTodayObj.auditVehicleYear,auditTodayObj.auditVehicleName] ]+[self heightForText:[NSString stringWithFormat:@"%@ | %@ | %@",auditTodayObj.auditVehicleRegNum,auditTodayObj.auditVehicleColor,auditTodayObj.auditStockNo]] +[self heightForText:[NSString stringWithFormat:@"%@ | %@ | %@",auditTodayObj.auditVehicleType,auditTodayObj.auditVehicleMileage,auditTodayObj.auditVehicleDays]]+ (21.0+21.0+70.0+7.0));
                
                
            
            return height+40;
            }
            else
            {
                return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 111.0 : 156.0+10.0;

            }
        }
        else
        {
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
             return 131.0 ;
            else
                return 128.0;
            
        }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.tblViewStillToAuditList)
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (tableView == self.tblViewStillToAuditList)
    {
        if(section == 0)
        {
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayOfSections objectAtIndex:section];
                
                if (sectionObject.isExpanded)
                {
                    return 44.0f;
                }
                else
                    return 0.0;
                
                
                
            }
            else
            {
                SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayOfSections objectAtIndex:section];
                
                if (sectionObject.isExpanded)
                {
                    return 60.0f;
                }
                else
                    return 0.0;
            }
        }
        
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer2=@"SMStockListCell";
    
    if(indexPath.section == 0)
    {
        static NSString *cellIdentifier= @"SMVehicleAuditDetailCell";
        
        SMVehicleAuditDetailCell     *dynamicCell;
        
        CGFloat heightGeoAddress = 0.0f;
        CGFloat heightVehicleDetails1 = 0.0f;
        CGFloat heightVehicleDetails2 = 0.0f;
        
        
        UILabel *lblVinNum;
        UILabel *lblGeoAddress;
        UILabel *lblVehicleName;
        UILabel *lblVehicleDetails1;
        UILabel *lblVehicleDetails2;
        UILabel *lblPriceRetail = [[UILabel alloc]init];
        lblPriceRetail.text = @"R45 0000";
        [lblPriceRetail sizeToFit];
        UILabel *lblPriceTrade;
        UILabel *lblPriceSeparator;
        UILabel *lblTime;
        
        UILabel *lblSubscriptRetail;
        UILabel *lblSubscriptTrade;
        
        UIImageView *imgLicenceImage;
        UIImageView *imgVehicleImage;
        
        SMDonePlannerButton *btnLicenceImage;
        SMDonePlannerButton *btnVehicleImage;
        
        
        
        SMStockAuditDetailObject *auditTodayObj = [arrayForFirstSection objectAtIndex:indexPath.row];
        
        heightGeoAddress = [self heightForText:[NSString stringWithFormat:@"GEO: %@",auditTodayObj.auditGeoAddress]];
        
        heightVehicleDetails1 = [self heightForText:[NSString stringWithFormat:@"%@ | %@ | %@",auditTodayObj.auditVehicleRegNum, auditTodayObj.auditVehicleColor, auditTodayObj.auditStockNo]];
        
        heightVehicleDetails2 = [self heightForText:[NSString stringWithFormat:@"%@ | %@ | %@",auditTodayObj.auditVehicleType, auditTodayObj.auditVehicleMileage,auditTodayObj.auditVehicleDays]];
        
        if (dynamicCell == nil)
        {
            dynamicCell = [[SMVehicleAuditDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            
            
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                lblTime = [[UILabel alloc] initWithFrame:CGRectMake(252,9,63,21)];
                
                
                lblVinNum = [[UILabel alloc] initWithFrame:CGRectMake(8,9,270,21)];
                lblGeoAddress = [[UILabel alloc] initWithFrame:CGRectMake(8,36,304,heightGeoAddress)];
                
                lblVehicleName = [[UILabel alloc] initWithFrame:CGRectMake(8,lblGeoAddress.frame.origin.y + lblGeoAddress.frame.size.height+6.0,304,21)];
                
                lblVehicleDetails1 = [[UILabel alloc] initWithFrame:CGRectMake(8,lblVehicleName.frame.origin.y + lblVehicleName.frame.size.height+5.0,304,heightVehicleDetails1)];
                
                lblVehicleDetails2 = [[UILabel alloc] initWithFrame:CGRectMake(8,lblVehicleDetails1.frame.origin.y+lblVehicleDetails1.frame.size.height+5.0,304,heightVehicleDetails2)];
                
                // ********************* Price labels *******************************
                
                
                lblSubscriptRetail = [[UILabel alloc] initWithFrame:CGRectMake(8, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+5.0+4.0, 24, 16)];
                
                
                
                lblPriceRetail.frame = CGRectMake(lblSubscriptRetail.frame.origin.x + lblSubscriptRetail.frame.size.width +3.0,lblVehicleDetails2.frame.origin.y+lblVehicleDetails2.frame.size.height+5.0,lblPriceRetail.frame.size.width,21);
                
                
                
                lblPriceSeparator = [[UILabel alloc] initWithFrame:CGRectMake(lblPriceRetail.frame.origin.x + lblPriceRetail.frame.size.width, lblPriceRetail.frame.origin.y , 1, 20)];
                
                lblSubscriptTrade = [[UILabel alloc] initWithFrame:CGRectMake(lblPriceSeparator.frame.origin.x + lblPriceSeparator.frame.size.width +5.0, lblSubscriptRetail.frame.origin.y, 22, 16)];
                
                
                lblPriceTrade = [[UILabel alloc] initWithFrame:CGRectMake(lblSubscriptTrade.frame.origin.x + lblSubscriptTrade.frame.size.width +5.0,lblPriceRetail.frame.origin.y,100,21)];
                
                // ********************* End of Price labels *******************************
                
                imgLicenceImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, lblPriceRetail.frame.origin.y+lblPriceRetail.frame.size.height+10.0, 70.0, 52.0)];
                imgVehicleImage = [[UIImageView alloc]initWithFrame:CGRectMake(imgLicenceImage.frame.origin.x+imgLicenceImage.frame.size.width+10.0, imgLicenceImage.frame.origin.y, 70.0, 52.0)];
                
                btnLicenceImage = [[SMDonePlannerButton alloc]initWithFrame:CGRectMake(8, lblPriceRetail.frame.origin.y+lblPriceRetail.frame.size.height+10.0, 70.0, 52.0)];
                btnVehicleImage = [[SMDonePlannerButton alloc]initWithFrame:CGRectMake(imgLicenceImage.frame.origin.x+imgLicenceImage.frame.size.width+10.0, imgLicenceImage.frame.origin.y, 70.0, 52.0)];
                
                [btnLicenceImage addTarget:self action:@selector(btnLicenscImageClicked:) forControlEvents:UIControlEventTouchUpInside];
                [btnVehicleImage addTarget:self action:@selector(btnVehicleImageClicked:) forControlEvents:UIControlEventTouchUpInside];
                btnVehicleImage.backgroundColor = [UIColor clearColor];
                btnLicenceImage.backgroundColor = [UIColor clearColor];
                
                
                btnLicenceImage.indexPath = indexPath;
                btnLicenceImage.buttonindexPathRow = 0;
                
                btnVehicleImage.indexPath = indexPath;
                btnVehicleImage.buttonindexPathRow = 1;
                
                
                [imgLicenceImage setContentMode:UIViewContentModeScaleAspectFit];
                [imgLicenceImage setContentMode:UIViewContentModeScaleAspectFit];
                
                lblVinNum.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblGeoAddress.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblPriceRetail.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblPriceTrade.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblSubscriptRetail.font = [UIFont fontWithName:FONT_NAME_BOLD size:12];
                lblSubscriptTrade.font = [UIFont fontWithName:FONT_NAME_BOLD size:12];
                lblTime.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                
            }
            else
            {
                // implement for iPad
                
                lblTime = [[UILabel alloc] initWithFrame:CGRectMake(665,9,90,21)];
                
                lblVinNum = [[UILabel alloc] initWithFrame:CGRectMake(7,9,605,21)];
                lblGeoAddress = [[UILabel alloc] initWithFrame:CGRectMake(8,lblVinNum.frame.origin.y+lblVinNum.frame.size.height+7.0,730,heightGeoAddress)];
                lblVehicleName = [[UILabel alloc] initWithFrame:CGRectMake(8,lblGeoAddress.frame.origin.y+ lblGeoAddress.frame.size.height+5.0,752,21)];
                lblVehicleDetails1 = [[UILabel alloc] initWithFrame:CGRectMake(8,lblVehicleName.frame.origin.y+lblVehicleName.frame.size.height+7.0,712,21)];
                
                lblVehicleDetails2 = [[UILabel alloc] initWithFrame:CGRectMake(8,lblVehicleDetails1.frame.origin.y+lblVehicleDetails1.frame.size.height+7.0,712,21)];
                
                // ********************* Price labels *******************************
                
                
                lblSubscriptRetail = [[UILabel alloc] initWithFrame:CGRectMake(8, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+7.0+4.0, 29, 19)];
                
                
                
                lblPriceRetail.frame = CGRectMake(lblSubscriptRetail.frame.origin.x + lblSubscriptRetail.frame.size.width +3.0,lblVehicleDetails2.frame.origin.y+lblVehicleDetails2.frame.size.height+7.0,lblPriceRetail.frame.size.width+25,25);
                
                
                
                lblPriceSeparator = [[UILabel alloc] initWithFrame:CGRectMake(lblPriceRetail.frame.origin.x + lblPriceRetail.frame.size.width, lblPriceRetail.frame.origin.y + 6.0 , 1, 18)];
                
                lblSubscriptTrade = [[UILabel alloc] initWithFrame:CGRectMake(lblPriceSeparator.frame.origin.x + lblPriceSeparator.frame.size.width +9.0, lblSubscriptRetail.frame.origin.y, 29, 19)];
                
                
                lblPriceTrade = [[UILabel alloc] initWithFrame:CGRectMake(lblSubscriptTrade.frame.origin.x + lblSubscriptTrade.frame.size.width +4.0,lblPriceRetail.frame.origin.y,400,25)];
                
                // ********************* End of Price labels *******************************
                
                
                imgLicenceImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, lblPriceRetail.frame.origin.y+lblPriceRetail.frame.size.height+11.0, 70.0, 52.0)];
                imgVehicleImage = [[UIImageView alloc]initWithFrame:CGRectMake(imgLicenceImage.frame.origin.x+imgLicenceImage.frame.size.width+7.0, imgLicenceImage.frame.origin.y, 70.0, 52.0)];
                
                btnLicenceImage = [[SMDonePlannerButton alloc]initWithFrame:CGRectMake(8, lblPriceRetail.frame.origin.y+lblPriceRetail.frame.size.height+7.0, 70.0, 52.0)];
                btnVehicleImage = [[SMDonePlannerButton alloc]initWithFrame:CGRectMake(imgLicenceImage.frame.origin.x+imgLicenceImage.frame.size.width+7.0, imgLicenceImage.frame.origin.y, 70.0, 52.0)];
                
                [btnLicenceImage addTarget:self action:@selector(btnLicenscImageClicked:) forControlEvents:UIControlEventTouchUpInside];
                [btnVehicleImage addTarget:self action:@selector(btnVehicleImageClicked:) forControlEvents:UIControlEventTouchUpInside];
                btnVehicleImage.backgroundColor = [UIColor clearColor];
                btnLicenceImage.backgroundColor = [UIColor clearColor];
                
                
                btnLicenceImage.indexPath = indexPath;
                btnLicenceImage.buttonindexPathRow = 0;
                
                btnVehicleImage.indexPath = indexPath;
                btnVehicleImage.buttonindexPathRow = 1;
                
                
                [imgLicenceImage setContentMode:UIViewContentModeScaleAspectFit];
                [imgLicenceImage setContentMode:UIViewContentModeScaleAspectFit];
                
                
                
                lblVinNum.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblGeoAddress.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblPriceRetail.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblPriceTrade.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblSubscriptRetail.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
                lblSubscriptTrade.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
                lblTime.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblPriceSeparator.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                
            }
            
            lblVinNum.tag = 101;
            lblGeoAddress.tag = 102;
            lblVehicleName.tag = 103;
            lblVehicleDetails1.tag = 104;
            lblVehicleDetails2.tag = 105;
            lblPriceRetail.tag = 105;
            lblTime.tag = 106;
            
            
           // lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",@"ND 12345", @"ruby", @"Stock code?"];
            
            lblGeoAddress.text = [NSString stringWithFormat:@"GEO: %@",auditTodayObj.auditGeoAddress];
            
            [self setAttributedTextForVehicleNameWithFirstText:auditTodayObj.auditVehicleYear andWithSecondText:auditTodayObj.auditVehicleName forLabel:lblVehicleName];
            
            lblVinNum.text = [NSString stringWithFormat:@"VIN: %@",auditTodayObj.auditVinID];
            lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",auditTodayObj.auditVehicleRegNum, auditTodayObj.auditVehicleColor, auditTodayObj.auditStockNo];
            
            [self setAttributedTextForVehicleDetailsWithFirstText:auditTodayObj.auditVehicleType andWithSecondText:auditTodayObj.auditVehicleMileage andWithThirdText:auditTodayObj.auditVehicleDays forLabel:lblVehicleDetails2];
            
            lblSubscriptRetail.text = @"Ret.";
            // Do not set Retail price text here.. Assign it before you set the frame for it.
            lblSubscriptTrade.text = @"Trd.";
            lblPriceRetail.text = auditTodayObj.auditVehiclePriceRetail;
            lblPriceTrade.text = auditTodayObj.auditVehiclePriceTrade;
            lblPriceSeparator.text = @"|";
            [imgLicenceImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",auditTodayObj.auditLicenseURL]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
            [imgVehicleImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",auditTodayObj.auditVehicleURL]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
            
            
            
            
            
            [dynamicCell.contentView addSubview:lblTime];
            [dynamicCell.contentView addSubview:lblVinNum];
            [dynamicCell .contentView addSubview:lblGeoAddress];
            [dynamicCell.contentView addSubview:lblVehicleName];
            [dynamicCell.contentView addSubview:lblVehicleDetails1];
            [dynamicCell .contentView addSubview:lblVehicleDetails2];
            [dynamicCell .contentView addSubview:lblPriceRetail];
            [dynamicCell .contentView addSubview:lblPriceTrade];
            [dynamicCell .contentView addSubview:lblSubscriptRetail];
            [dynamicCell .contentView addSubview:lblSubscriptTrade];
            [dynamicCell .contentView addSubview:lblPriceSeparator];
            [dynamicCell.contentView addSubview:imgVehicleImage];
            [dynamicCell.contentView addSubview:imgLicenceImage];
            [dynamicCell.contentView addSubview:btnVehicleImage];
            [dynamicCell.contentView addSubview:btnLicenceImage];
            
            
        }
        else
        {
            //lblVinNum = (UILabel *)[cel.contentView viewWithTag:1001];
            //lblValue = (UILabel *)[cell.contentView viewWithTag:1002];
            
        }
        
        
        NSArray *strSeprated=[auditTodayObj.auditTime componentsSeparatedByString:@":"];
        
        lblTime.text = [NSString stringWithFormat:@"%@h%@m",[strSeprated objectAtIndex:0],[strSeprated objectAtIndex:1]];
        
        
        
        lblVinNum.numberOfLines = 0;
        [lblVinNum sizeToFit];
        
        lblGeoAddress.numberOfLines = 0;
        [lblGeoAddress sizeToFit];
        
        lblVehicleName.numberOfLines = 0;
        [lblVehicleName sizeToFit];
        
        lblVehicleDetails1.numberOfLines = 0;
        [lblVehicleDetails1 sizeToFit];
        
        lblVehicleDetails2.numberOfLines = 0;
        [lblVehicleDetails2 sizeToFit];
        
        dynamicCell.selectionStyle  = UITableViewCellSelectionStyleNone;
        dynamicCell.textLabel.textColor = [UIColor whiteColor];
        dynamicCell.backgroundColor = [UIColor blackColor];
        
        
        lblVinNum.textColor = [UIColor whiteColor];
        lblGeoAddress.textColor = [UIColor whiteColor];
        //lblVehicleName.textColor = [UIColor whiteColor];
        lblVehicleDetails1.textColor = [UIColor whiteColor];
        //lblVehicleDetails2.textColor = [UIColor whiteColor];
        lblPriceRetail.textColor = [UIColor colorWithRed:64.0/255 green:198.0/255 blue:42.0/255 alpha:1.0];
        lblPriceTrade.textColor = [UIColor colorWithRed:187.0/255 green:140.0/255 blue:20.0/255 alpha:1.0];
        lblSubscriptRetail.textColor = [UIColor whiteColor];
        lblSubscriptTrade.textColor = [UIColor whiteColor];
        lblPriceSeparator.backgroundColor = [UIColor whiteColor];
        lblTime.textColor = [UIColor whiteColor];
        
        dynamicCell.backgroundColor = [UIColor blackColor];
        if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
        {
            dynamicCell.layoutMargins = UIEdgeInsetsZero;
            dynamicCell.preservesSuperviewLayoutMargins = NO;
        }
        
        if (arrayForFirstSection.count-1 == indexPath.row)
        {
            
            if (arrayForFirstSection.count !=totalUnMatchedCount)
            {
                
                ++pageNumberUnMatchedCount;
                [self getStillToAuditListFromServerWithUnMatchedFlag:1 andUnScannedFlag:0];
            }
            
        }
        
        return dynamicCell;
        
    }
    else
    {

        SMStockListCell *cellPhotosExtras = [tableView dequeueReusableCellWithIdentifier:cellIdentifer2 forIndexPath:indexPath];
        cellPhotosExtras.viewContainerExtrasComments.hidden = YES;
        SMStockAuditDetailObject *auditObj2 = (SMStockAuditDetailObject*)[arrayForSecondSection objectAtIndex:indexPath.row];
        
        
        cellPhotosExtras.lblNotes.hidden = YES;
       
        
        [self setAttributedTextForVehicleNameWithFirstText:auditObj2.auditVehicleYear andWithSecondText:auditObj2.auditVehicleName forLabel:cellPhotosExtras.lblVehicleName]; //Change by Ankit
        
//        cellPhotosExtras.lblVehicleName.text=[NSString stringWithFormat:@"%@ %@",auditObj2.auditVehicleYear,auditObj2.auditVehicleName];
        
        
        cellPhotosExtras.lbVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",auditObj2.auditVehicleRegNum,auditObj2.auditVehicleColor, auditObj2.auditStockNo];
        
        cellPhotosExtras.lblPriceRetail.text =auditObj2.auditVehiclePriceRetail;
        [cellPhotosExtras.lblPriceRetail sizeToFit];
        cellPhotosExtras.lblPriceTrade.text = auditObj2.auditVehiclePriceTrade;
        
        [self setAttributedTextForVehicleDetailsWithFirstText:auditObj2.auditVehicleType andWithSecondText:auditObj2.auditVehicleMileage andWithThirdText:auditObj2.auditVehicleDays forLabel:cellPhotosExtras.lbVehicleDetails2];
        
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            cellPhotosExtras.lbVehicleDetails1.frame = CGRectMake(cellPhotosExtras.lbVehicleDetails1.frame.origin.x, cellPhotosExtras.lblVehicleName.frame.origin.y + cellPhotosExtras.lblVehicleName.frame.size.height + 3.0, cellPhotosExtras.lbVehicleDetails1.frame.size.width, cellPhotosExtras.lbVehicleDetails1.frame.size.height);
            
            cellPhotosExtras.lbVehicleDetails2.frame = CGRectMake(cellPhotosExtras.lbVehicleDetails2.frame.origin.x, cellPhotosExtras.lbVehicleDetails1.frame.origin.y + cellPhotosExtras.lbVehicleDetails1.frame.size.height + 5.0, cellPhotosExtras.lbVehicleDetails2.frame.size.width, cellPhotosExtras.lbVehicleDetails2.frame.size.height);
            
            cellPhotosExtras.viewContainingTraderPrice.frame = CGRectMake(cellPhotosExtras.lblPriceRetail.frame.origin.x + cellPhotosExtras.lblPriceRetail.frame.size.width+3.0, cellPhotosExtras.viewContainingTraderPrice.frame.origin.y , cellPhotosExtras.viewContainingTraderPrice.frame.size.width, cellPhotosExtras.viewContainingTraderPrice.frame.size.height);
            
            cellPhotosExtras.viewContainingPrice.frame = CGRectMake(cellPhotosExtras.viewContainingPrice.frame.origin.x, cellPhotosExtras.lbVehicleDetails2.frame.origin.y + cellPhotosExtras.lbVehicleDetails2.frame.size.height + 3.0, cellPhotosExtras.viewContainingPrice.frame.size.width, cellPhotosExtras.viewContainingPrice.frame.size.height);
            
            cellPhotosExtras.viewContainerExtrasComments.frame = CGRectMake(cellPhotosExtras.viewContainerExtrasComments.frame.origin.x, cellPhotosExtras.viewContainingPrice.frame.origin.y + cellPhotosExtras.viewContainingPrice.frame.size.height + 3.0, cellPhotosExtras.viewContainerExtrasComments.frame.size.width, cellPhotosExtras.viewContainerExtrasComments.frame.size.height);
        }
        else
        {
            cellPhotosExtras.lbVehicleDetails1.frame = CGRectMake(cellPhotosExtras.lbVehicleDetails1.frame.origin.x, cellPhotosExtras.lblVehicleName.frame.origin.y + cellPhotosExtras.lblVehicleName.frame.size.height +1.0, cellPhotosExtras.lbVehicleDetails1.frame.size.width, cellPhotosExtras.lbVehicleDetails1.frame.size.height);
            
            cellPhotosExtras.lbVehicleDetails2.frame = CGRectMake(cellPhotosExtras.lbVehicleDetails2.frame.origin.x, cellPhotosExtras.lbVehicleDetails1.frame.origin.y + cellPhotosExtras.lbVehicleDetails1.frame.size.height + 5.0, cellPhotosExtras.lbVehicleDetails2.frame.size.width, cellPhotosExtras.lbVehicleDetails2.frame.size.height);
            
            
            cellPhotosExtras.viewContainingTraderPrice.frame = CGRectMake(cellPhotosExtras.lblPriceRetail.frame.origin.x + cellPhotosExtras.lblPriceRetail.frame.size.width+5.0, cellPhotosExtras.viewContainingTraderPrice.frame.origin.y , cellPhotosExtras.viewContainingTraderPrice.frame.size.width, cellPhotosExtras.viewContainingTraderPrice.frame.size.height);
            
            cellPhotosExtras.viewContainingPrice.frame = CGRectMake(cellPhotosExtras.viewContainingPrice.frame.origin.x, cellPhotosExtras.lbVehicleDetails2.frame.origin.y + cellPhotosExtras.lbVehicleDetails2.frame.size.height + 5.0, cellPhotosExtras.viewContainingPrice.frame.size.width, cellPhotosExtras.viewContainingPrice.frame.size.height);
            
            cellPhotosExtras.viewContainerExtrasComments.frame = CGRectMake(cellPhotosExtras.viewContainerExtrasComments.frame.origin.x, cellPhotosExtras.viewContainingPrice.frame.origin.y + cellPhotosExtras.viewContainingPrice.frame.size.height + 5.0, cellPhotosExtras.viewContainerExtrasComments.frame.size.width, cellPhotosExtras.viewContainerExtrasComments.frame.size.height);
        }
        
        
        cellPhotosExtras.backgroundColor=[UIColor clearColor];
        cellPhotosExtras.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if (arrayForSecondSection.count-1 == indexPath.row)
        {
            NSLog(@"NotScannedVehicleCount = %d",totalNotScannedVehicles);
            NSLog(@"arrayForSecondSection count = %lu",(unsigned long)arrayForSecondSection.count);
            if (arrayForSecondSection.count !=totalNotScannedVehicles)
            {
                ++pageNumberUnScannedCount;
                [self getStillToAuditListFromServerWithUnMatchedFlag:0 andUnScannedFlag:1];
                
            }
        }

        return cellPhotosExtras;
        
    }
    
    return nil;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMCustomerDLScanViewController *scanObject = [[SMCustomerDLScanViewController alloc] initWithNibName:@"SMCustomerDLScanViewController" bundle:nil];
    
    scanObject.isComingFromStockAudit = YES;
    scanObject.isComingFromSynopsis = NO;
    //[self presentViewController:scanObject animated:NO completion:nil];
    [self.navigationController pushViewController:scanObject animated:YES];


}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.tblViewStillToAuditList)
    {
        UIView *headerView = [[UIView alloc] init];
        UIView *headerColorView = [[UIView alloc] init];
        UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
        
        SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayOfSections objectAtIndex:section];
        
        imageViewArrowForsection = [[UIImageView alloc]init];
        
        imageViewArrowForsection.contentMode = UIViewContentModeScaleAspectFit;
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            [headerView setFrame:CGRectMake(5, 0, tableView.bounds.size.width - 10.0, 30)];
            [headerColorView setFrame:CGRectMake(5, 0, tableView.bounds.size.width - 10.0, 30)];
            sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,30);
            sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0f];
            [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-35,5,20,20)];
        }
        else
        {
            [headerView setFrame:CGRectMake(5, 0, tableView.bounds.size.width - 10.0, 40)];
            [headerColorView setFrame:CGRectMake(5, 0, tableView.bounds.size.width - 10.0, 40)];
            sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,40);
            sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
            [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-35,10,20,20)];
        }
        
        
        if(sectionObject.isExpanded)
        {
            [UIView animateWithDuration:2 animations:^
             {
                 if(section == 0)
                 {
                     
                     if (arrayForFirstSection.count>0)
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                     
                 }
                 else
                 {
                     
                        if (arrayForSecondSection.count>0)
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                     
                 }
                 
             }
                             completion:nil];
        }
        
        
        UIImage *image = [UIImage imageNamed:@"side_Arrow.png"];
        [imageViewArrowForsection setImage:image];
        
        countLbl = [[UILabel alloc]initWithFrame:CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-45,5, 20, 20)];
        
        countLbl.textColor = [UIColor whiteColor];
        countLbl.textAlignment = NSTextAlignmentCenter;
        countLbl.layer.borderColor = [UIColor whiteColor].CGColor;
        countLbl.layer.borderWidth = 1.0;
        countLbl.layer.masksToBounds = YES;
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            countLbl.font = [UIFont fontWithName:FONT_NAME size:15.0f];
        else
            countLbl.font = [UIFont fontWithName:FONT_NAME size:17.0f];

        countLbl.layer.cornerRadius = countLbl.frame.size.width/2;
        
        if (![sectionObject.strSectionName isEqualToString:@"Audited today but no matching VIN"])
        {
            [self setTheLabelCountText:totalNotScannedVehicles];
        }
        else
        {
            [self setTheLabelCountText:totalUnMatchedCount];
            
            
        }
        
        
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width,5, countLbl.frame.size.width, 20);
        }
        else
        {
            countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width-20,10, countLbl.frame.size.width, 20);
        }
        
        [headerColorView addSubview:countLbl];
        
        [headerColorView addSubview:imageViewArrowForsection];
        
        headerView.backgroundColor = [UIColor clearColor];
        
        
        headerColorView.backgroundColor=[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
        
        [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [sectionLabelBtn addTarget:self action:@selector(btnSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [sectionLabelBtn setTag:section];// set the tag for each section
        sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        NSLog(@"sectionLabelBtn.tag %d",(int)sectionLabelBtn.tag);
        [sectionLabelBtn setTitle:sectionObject.strSectionName forState:UIControlStateNormal];
        //[sectionLabelBtn.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:12.0]];
        headerColorView.layer.cornerRadius = 5.0;
        headerView.layer.cornerRadius = 5.0;
        [headerColorView addSubview:sectionLabelBtn];
        [headerView addSubview:headerColorView];
        headerView.clipsToBounds = YES;
        
        return headerView;
    }
    
    return 0;
    
}

/*- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    UIView *headerColorView = [[UIView alloc] init];
    UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
    
     SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayOfSections objectAtIndex:section];
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
    
    if(section == 0)
    {
        [sectionLabelBtn setTitle:@"Audited today but no matching VIN" forState:UIControlStateNormal];
        
        [self setTheLabelCountText:totalNotScannedVehicles];
    }
    else
    {
        [sectionLabelBtn setTitle:@"These vehicles requires a VIN scan" forState:UIControlStateNormal];
        
        [self setTheLabelCountText:totalUnMatchedCount];
        
    }
    
    
    
    if(sectionObject.isExpanded)
    {
        [UIView animateWithDuration:2 animations:^
         {
             if(section == 0)
             {
                 
                 if (arrayForFirstSection.count>0)
                     imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                 
             }
             else
             {
                 
                 if (arrayForSecondSection.count>0)
                     imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                 
             }
             
         }
                         completion:nil];
    }
    
    UIImage *image = [UIImage imageNamed:@"side_Arrow.png"];
    [imageViewArrowForsection setImage:image];
    
    
    [headerColorView addSubview:imageViewArrowForsection];
    
    headerView.backgroundColor = [UIColor clearColor];
    
    
    
    
    
    {
        countLbl = [[UILabel alloc]initWithFrame:CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-45,5, 20, 20)];
        
        countLbl.textColor = [UIColor whiteColor];
        countLbl.textAlignment = NSTextAlignmentCenter;
        countLbl.layer.borderColor = [UIColor whiteColor].CGColor;
        countLbl.layer.borderWidth = 1.0;
        countLbl.layer.masksToBounds = YES;
        
        
        countLbl.layer.cornerRadius = countLbl.frame.size.width/2;
        
        
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
    
    headerColorView.backgroundColor=[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
    [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [sectionLabelBtn addTarget:self action:@selector(btnSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sectionLabelBtn setTag:section];
    sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    headerColorView.layer.cornerRadius = 5.0;
    [headerColorView addSubview:sectionLabelBtn];
    [headerView addSubview:headerColorView];
    headerView.layer.cornerRadius = 5.0;
    
    return headerView;
    
}*/

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        
        self.sectionfooterView.backgroundColor = [UIColor blackColor];
        self.lblSectionFooter.textColor = [UIColor whiteColor];
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
          self.lblSectionFooter.font = [UIFont fontWithName:FONT_NAME size:11.0];
        else
            self.lblSectionFooterIPad.font = [UIFont fontWithName:FONT_NAME size:17.0];
        
        SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayOfSections objectAtIndex:section];
        
        if (sectionObject.isExpanded)
        {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
              return self.sectionfooterView;
            else
                  return self.sectionFooterViewIpad;
        }
        else
            return nil;
        
    }
    return nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)populateTheSectionsArray
{
    
    NSArray *arrayOfSectionNames = [[NSArray alloc]initWithObjects:@"Audited today but no matching VIN",@"These vehicles requires a VIN scan", nil];
    
    for(int i=0;i<2;i++)
    {
        SMClassForToDoObjects *sectionObject = [[SMClassForToDoObjects alloc]init];
        sectionObject.strSectionID = i+1;
        sectionObject.strSectionName = [arrayOfSectionNames objectAtIndex:i];
        sectionObject.isExpanded = NO;
        [arrayOfSections addObject:sectionObject];
        
    }
    
    
}


- (IBAction)btnExpandEmailListDidClicked:(id)sender
{
       if(self.btnExpandEmailList.tag == 1)
           self.btnExpandEmailList.tag = 0;
        else
            self.btnExpandEmailList.tag = 1;

    
    if(self.btnExpandEmailList.tag == 0)
    {
        CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
        UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
        [self.imgRightArrowTH setImage:rotatedImage];
        self.txtFieldEmailAddress.hidden = YES;
        self.btnSubmit.hidden = YES;

        
       self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, 40.0);
    }
    else
    {
        CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
        
        UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
        [self.imgRightArrowTH setImage:rotatedImage];
        self.txtFieldEmailAddress.hidden = NO;
        self.btnSubmit.hidden = NO;
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, 92.0);
    }
    
    self.tblViewStillToAuditList.tableHeaderView = self.headerView;
    
}

- (void)registerNib
{
    
    UILabel *listActiveSpecialsNavigTitle = [[UILabel alloc] initWithFrame:CGRectZero];
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
    listActiveSpecialsNavigTitle.text = @"Still to audit";
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
    
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tblViewStillToAuditList registerNib:[UINib nibWithNibName:@"SMStockListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMStockListCell"];
        
        
        [self.tblViewStillToAuditList registerNib:[UINib nibWithNibName:@"SMVehicleNameVinNoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMVehicleNameVinNoCell"];
        

        
               
    }
    else
    {
        [self.tblViewStillToAuditList registerNib:[UINib nibWithNibName:@"SMStockListCell_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMStockListCell"];
        
        [self.tblViewStillToAuditList registerNib:[UINib nibWithNibName:@"SMVehicleNameVinNoCell-iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMVehicleNameVinNoCell"];
        

        
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




- (IBAction)btnSubmitDidClicked:(id)sender
{
    
    [self.txtFieldEmailAddress resignFirstResponder];
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regExpred =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringCheck = [regExpred evaluateWithObject:self.txtFieldEmailAddress.text];
    
    if(!myStringCheck)
    {
        SMAlert(KLoaderTitle,kEnterValidEmail);
        return;
    }

    
    if(isSectionFirstOpened)
        [self sendTheAuditItemsViaEmailWithUnMatchedFlag:1 andNotAuditedFlag:0];
    else if (isSectionSecondOpened)
        [self sendTheAuditItemsViaEmailWithUnMatchedFlag:0 andNotAuditedFlag:1];
    
}

-(void)populateTheSecondSectionRows
{
    for(int i=0;i<5;i++)
    {
        SMStockAuditDetailObject *auditTodayObj = [[SMStockAuditDetailObject alloc]init];
        
        auditTodayObj.auditVinID = @"VIN: 1234567890";
        auditTodayObj.auditVehicleName = @"Volkswagen Golf 6 GTI";
        auditTodayObj.auditVehicleDetails = @"2013 | White | 23 000Km";
        auditTodayObj.auditStockNo = @"Stock#: 10LDV12345";
        auditTodayObj.auditTime = @"12h34";
        auditTodayObj.auditStockType = @"New";
        
        [arrayForSecondSection addObject:auditTodayObj];
        
    }
    
    
}

-(void)populateTheFirstSectionRows
{
    for(int i=0;i<5;i++)
    {
        SMStockAuditDetailObject *auditTodayObj = [[SMStockAuditDetailObject alloc]init];
        
        auditTodayObj.auditVinID = @"VIN: 1234567890";
        auditTodayObj.auditVehicleName = @"Volkswagen Golf 6 GTI";
        auditTodayObj.auditTime = @"12h54";
       
        [arrayForFirstSection addObject:auditTodayObj];
        
    }
    
    
}

-(IBAction)btnSectionTitleDidClicked:(id)sender
{
    self.btnExpandEmailList.tag = 1;
    [self btnExpandEmailListDidClicked:self.btnExpandEmailList];
    
    
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"[sender tag] %d",(int)button.tag);
    
    if (button.tag ==  0)
    {
        
       SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayOfSections objectAtIndex:button.tag];
        sectionObject.isExpanded = !sectionObject.isExpanded;
        
        SMClassForToDoObjects *sectionObject1 = (SMClassForToDoObjects*)[arrayOfSections objectAtIndex:1];
        sectionObject1.isExpanded = NO;
        
        [self.tblViewStillToAuditList reloadData];
        
        isSectionFirstOpened =  YES;
        isSectionSecondOpened = NO;

    }
    else
    {
        
        SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayOfSections objectAtIndex:button.tag];
        sectionObject.isExpanded = !sectionObject.isExpanded;
        
        SMClassForToDoObjects *sectionObject1 = (SMClassForToDoObjects*)[arrayOfSections objectAtIndex:0];
        sectionObject1.isExpanded = NO;
        
        [self.tblViewStillToAuditList reloadData];
        
        isSectionFirstOpened =  NO;
        isSectionSecondOpened = YES;

        
    }
}

#pragma mark - WEbservice integration

-(void)getStillToAuditListFromServerWithUnMatchedFlag:(int)unMatchedFlag andUnScannedFlag:(int)unScannedFlag
{
    
    if(unMatchedFlag == 1)
        isUnmatchedSectionClicked = YES;
    else
        isUnmatchedSectionClicked = NO;
    
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL;
    
    NSLog(@"Flag received in the webservice = %d",isUnmatchedSectionClicked);
    
    if(isUnmatchedSectionClicked)
        requestURL=[SMWebServices getTheNecessaryStockAuditListWithUserHash:[SMGlobalClass sharedInstance].hashValue andIsDone:0 andIsUnmatched:unMatchedFlag andIsNotDone:unScannedFlag andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andPageNumber:pageNumberUnMatchedCount andRecordCount:10];
    else
        requestURL=[SMWebServices getTheNecessaryStockAuditListWithUserHash:[SMGlobalClass sharedInstance].hashValue andIsDone:0 andIsUnmatched:unMatchedFlag andIsNotDone:unScannedFlag andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andPageNumber:pageNumberUnScannedCount andRecordCount:10];
    
    
    NSLog(@"Request URL = %@",requestURL);
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    //isListingDataBeingFetched = YES;
    
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         //isListingDataBeingFetched = NO;
         
         if (error!=nil)
         {
             
             [self hideProgressHUD];
             
             
             [[[UIAlertView alloc]initWithTitle:@"Error"
                                        message:[error.localizedDescription capitalizedString]
                                       delegate:self cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil]
              show];
             
         }
         else
         {
             
             /*if (!isLoadMore)
             {
                 [arrayOfAuditedToday removeAllObjects];
                 
             }*/
             
             
             
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
         }
         
         
         
     }];
    
    
    
}


-(void)sendTheAuditItemsViaEmailWithUnMatchedFlag:(int)unMatchedFlag andNotAuditedFlag:(int)notAuditedFlag
{
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *finalDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSMutableURLRequest *requestURL=[SMWebServices sendAuditHistoryItemsCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andDay:finalDateStr andEmailAddress:self.txtFieldEmailAddress.text andAuditedFlag:0 andNotAuditedFlag:notAuditedFlag andNotMatchedFlag:unMatchedFlag];
    
    
    
    NSLog(@"Request URL = %@",requestURL);
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         
         if (error!=nil)
         {
             
             [self hideProgressHUD];
             
             
             [[[UIAlertView alloc]initWithTitle:@"Error"
                                        message:[error.localizedDescription capitalizedString]
                                       delegate:self cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil]
              show];
             
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




#pragma mark - Parsing delegate methods

// The first method to implement is parser:didStartElement:namespaceURI:qualifiedName:attributes:, which is fired when the start tag of an element is found:

//---when the start of an element is found---

-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict
{
    if([elementName isEqualToString:@"Audit"])
    {
        self.auditedTodayObject = [[SMStockAuditDetailObject alloc]init];
        
    }
    if([elementName isEqualToString:@"Counts"])
    {
        isCountSection = YES;
        
    }

    
    currentNodeContent = [NSMutableString stringWithString:@""];
    
}

//The next method to implement is parser:foundCharacters:, which gets fired when the parser finds the text of an element:

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
    
    
}


//Finally, when the parser encounters the end of an element, it fires the parser:didEndElement:namespaceURI:qualifiedName: method:

//---when the end of element is found---

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    [self hideProgressHUD];
    
   /* if([currentNodeContent length] == 0 || [currentNodeContent.lowercaseString isEqualToString:@"unknown"])
    {
        currentNodeContent = [NSMutableString stringWithFormat:@"No %@",elementName.capitalizedString];
    }*/
    
       
    if([elementName isEqualToString:@"Time"])
    {
        self.auditedTodayObject.auditTime = currentNodeContent;
    }
    if([elementName isEqualToString:@"VIN"])
    {
        if([currentNodeContent length] == 0)
        {
            self.auditedTodayObject.auditVinID = @"VIN?";
        }
        else
        {
            self.auditedTodayObject.auditVinID = currentNodeContent;
        }
        
    }
    if([elementName isEqualToString:@"GEO"])
    {
        self.auditedTodayObject.auditGeoAddress = currentNodeContent;
    }
    if([elementName isEqualToString:@"Make"])
    {
        self.auditedTodayObject.auditVehicleName = currentNodeContent;
    }
    if([elementName isEqualToString:@"Model"])
    {
        self.auditedTodayObject.auditVehicleName = [NSString stringWithFormat:@"%@ %@",self.auditedTodayObject.auditVehicleName,currentNodeContent];
    }
    if([elementName isEqualToString:@"Year"])
    {
        if([currentNodeContent length] == 0)
        {
            self.auditedTodayObject.auditVehicleYear = @"Year?";
        }
        else
        {
            self.auditedTodayObject.auditVehicleYear = currentNodeContent;

        }
    }
    if([elementName isEqualToString:@"Mileage"])
    {
        if([currentNodeContent length] == 0)
        {
            self.auditedTodayObject.auditVehicleMileage = @"Mileage?";
        }
        else
        {
            self.auditedTodayObject.auditVehicleMileage= [[SMCommonClassMethods shareCommonClassManager]mileageConvertEn_AF:currentNodeContent];
            
             self.auditedTodayObject.auditVehicleMileage=[NSString stringWithFormat:@"%@ Km",self.auditedTodayObject.auditVehicleMileage];
            
        }
    }
    if([elementName isEqualToString:@"Colour"])
    {
        if([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"No colour #"])
        {
             self.auditedTodayObject.auditVehicleColor = @"Colour?";
        }
        else
        {
            self.auditedTodayObject.auditVehicleColor = currentNodeContent;
        }
    }
    if([elementName isEqualToString:@"Registration"])
    {
        self.auditedTodayObject.auditVehicleRegNum = currentNodeContent;
    }
    if([elementName isEqualToString:@"RetailPrice"])
    {
        if([currentNodeContent length] == 0 || currentNodeContent.intValue == 0)
            self.auditedTodayObject.auditVehiclePriceRetail = @"R?";
        else
            self.auditedTodayObject.auditVehiclePriceRetail = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if([elementName isEqualToString:@"TradePrice"])
    {
        if([currentNodeContent length] == 0 || currentNodeContent.intValue == 0)
            self.auditedTodayObject.auditVehiclePriceTrade = @"R?";
        else
            self.auditedTodayObject.auditVehiclePriceTrade = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if([elementName isEqualToString:@"Age"])
    {
         self.auditedTodayObject.auditVehicleDays = [NSString stringWithFormat:@"%@ Days",currentNodeContent];
    }
    
    if([elementName isEqualToString:@"StockNumber"])
    {
        if([currentNodeContent length] == 0)
        {
             self.auditedTodayObject.auditStockNo = @"Stock code?";
        }
        else
        {
            self.auditedTodayObject.auditStockNo = currentNodeContent;
        }
    }
    if([elementName isEqualToString:@"LicenseImage"])
    {
        self.auditedTodayObject.auditLicenseURL = currentNodeContent;
    }
    if([elementName isEqualToString:@"VehicleImage"])
    {
        self.auditedTodayObject.auditVehicleURL = currentNodeContent;
    }
    if([elementName isEqualToString:@"UnmatchedAudits"])
    {
        totalUnMatchedCount = currentNodeContent.intValue;
        
    }
    if([elementName isEqualToString:@"NotAudited"])
    {
        totalNotScannedVehicles = currentNodeContent.intValue;
        
    }
    if([elementName isEqualToString:@"VehicleType"])
    {
        if([currentNodeContent length] == 0)
        {
            self.auditedTodayObject.auditVehicleType = @"Type?";
        }
        else
        {
            self.auditedTodayObject.auditVehicleType = currentNodeContent;
        }
        
    }

    if([elementName isEqualToString:@"Audit"])
    {
        NSLog(@"isUnMatchedSectionClicked = %d",isUnmatchedSectionClicked);
        
        if([self.auditedTodayObject.auditVehicleRegNum length] == 0)
           self.auditedTodayObject.auditVehicleRegNum = @"Reg?";
        
        if(isUnmatchedSectionClicked)
           [arrayForFirstSection addObject:self.auditedTodayObject];
        else
            [arrayForSecondSection addObject:self.auditedTodayObject];

    }
    
    if ([elementName isEqualToString:@"ListAuditsResult"] )
    {
        NSLog(@"isSectionFirstOpened = %d",isSectionFirstOpened);
        NSLog(@"isSectionSecondOpened = %d",isSectionSecondOpened);
        
        if (isSectionFirstOpened == NO && isSectionSecondOpened == NO)
        {
            isSectionFirstOpened = YES;
            isSectionSecondOpened = YES;
            [self getStillToAuditListFromServerWithUnMatchedFlag:0 andUnScannedFlag:1];
        }
        
    }
    
    if([elementName isEqualToString:@"SendAuditHistoryItemsResult"])
    {
        if([currentNodeContent isEqualToString:@"Audit History Sent"])
        {
            
            UIBAlertView *alert;
            alert = [[UIBAlertView alloc] initWithTitle:@"Smart Manager" message:@"Stock audit sent" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 
                 if (didCancel)
                 {
                     [self.navigationController popViewControllerAnimated:YES];
                     
                     return;
                 }
             }];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"First section count = %lu",(unsigned long)arrayForFirstSection.count);
    NSLog(@"Second section count = %lu",(unsigned long)arrayForSecondSection.count);

  
    
    if(isSectionFirstOpened)
    {
        if(isUnmatchedSectionClicked == YES)
        {
            self.tblViewStillToAuditList.indicatorStyle = UIScrollViewIndicatorStyleWhite;
            [self.tblViewStillToAuditList reloadData];
        }
    }
    
    
    if(isUnmatchedSectionClicked == NO)
    {
        self.tblViewStillToAuditList.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [self.tblViewStillToAuditList reloadData];
    }
    
    [self hideProgressHUD];
    
    
    
}



#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
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


-(void)pushTheViewControllerForEnlargedImageWithObject:(FGalleryViewController*)galleyPhotoObject
{
   SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
    appdelegate.isPresented =  YES;

    [self.navigationController pushViewController:galleyPhotoObject animated:YES];
}

#pragma mark - Set Attributed Text

-(void)setAttributedTextForVehicleNameWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
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
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    [label setAttributedText:attributedFirstText];
    
    
}

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    UIColor *foregroundColorGreen = [UIColor colorWithRed:64.0/255.0 green:198.0/255.0 blue:42.0/255.0 alpha:1.0];
    
    
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
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" |%@ |",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    
    
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
        textSize = 304;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        textSize = 730;
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

- (IBAction)btnLicenscImageClicked:(id)sender
{
    SMDonePlannerButton *button = (SMDonePlannerButton *)sender;
    
    networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    networkGallery.startingIndex = button.buttonindexPathRow;
    buttonIndex = button.buttonindexPathRow;
    
    [self getLicenscImageURLOnClickOnButton:button.indexPath.row];
    SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
    appdelegate.isPresented =  YES;
    [self.navigationController pushViewController:networkGallery animated:YES];
}
- (IBAction)btnVehicleImageClicked:(id)sender
{
    SMDonePlannerButton *button = (SMDonePlannerButton *)sender;
    
    networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    networkGallery.startingIndex = button.buttonindexPathRow;
    buttonIndex = button.buttonindexPathRow;
    
    
    [self getVehicleImageURLOnClickOnButton:button.indexPath.row];
    SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
    appdelegate.isPresented =  YES;
    [self.navigationController pushViewController:networkGallery animated:YES];
}

-(void)getVehicleImageURLOnClickOnButton:(NSInteger)indexRow
{
    SMStockAuditDetailObject *photoImagePath = (SMStockAuditDetailObject*)[arrayForFirstSection objectAtIndex:indexRow];
    
    finalPathLicseImage = photoImagePath.auditLicenseURL;
    finalPathVechImage = photoImagePath.auditVehicleURL;
}

-(void)getLicenscImageURLOnClickOnButton:(NSInteger)indexRow
{
    SMStockAuditDetailObject *photoImagePath = (SMStockAuditDetailObject*)[arrayForFirstSection objectAtIndex:indexRow];
    
    finalPathLicseImage = photoImagePath.auditLicenseURL;
    finalPathVechImage = photoImagePath.auditVehicleURL;
}

#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    
    if(gallery == networkGallery)
    {
        num = 2;
    }
    return num;
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
        NSLog(@"buttonIndex %lu",(unsigned long)buttonIndex);
        caption = [networkCaptions objectAtIndex:buttonIndex];
    }
    return caption;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    if (index == 0)
    {
        return finalPathLicseImage;
    }
    
    return finalPathVechImage;
    
}



@end
