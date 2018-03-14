//
//  SMVehicleAuditedTodayViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 04/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMVehicleAuditedTodayViewController.h"
#import "SMVehicleAuditDetailCell.h"
#import "SMStockAuditDetailObject.h"
#import "SMTradeDetailSlider.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIImageView+WebCache.h"
#import "UIBAlertView.h"
#import "SMAppDelegate.h"
#import "SMCommonClassMethods.h"

@interface SMVehicleAuditedTodayViewController ()

@end

@implementation SMVehicleAuditedTodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addingProgressHUD];

    pageNumberCount=0;
    isLoadMore = NO;
    [self.btnExpandEmailList setSelected:YES];
     [self setTheTitle];
    arrayOfAuditedToday = [[NSMutableArray alloc]init];
    self.tblViewAuditedTodayList.tableFooterView = [[UIView alloc]init];

   // [self populateTheRows];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
        self.btnExpandEmailList.titleEdgeInsets = UIEdgeInsetsMake(0, -655, 0, 0);
    
    self.btnSubmit.layer.cornerRadius = 5.0;
    self.btnSubmit.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:16.0];
    
    [self getTheAuditedTodayList];
    
    //self.tblViewAuditedTodayList.tableHeaderView = self.headerView;
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


#pragma mark - TableView DataSource / Delegate Methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfAuditedToday count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    
    
    SMStockAuditDetailObject *auditTodayObj = [arrayOfAuditedToday objectAtIndex:indexPath.row];
    
    heightGeoAddress = [self heightForText:[NSString stringWithFormat:@"GEO: %@",auditTodayObj.auditGeoAddress]];
    
    heightVehicleDetails1 = [self heightForText:[NSString stringWithFormat:@"%@ | %@ | %@",auditTodayObj.auditVehicleRegNum,auditTodayObj.auditVehicleColor, auditTodayObj.auditStockNo]];
    
    heightVehicleDetails2 = [self heightForText:[NSString stringWithFormat:@"%@ | %@ | %@",auditTodayObj.auditVehicleType, auditTodayObj.auditVehicleMileage, auditTodayObj.auditVehicleDays]];
    
    if (dynamicCell == nil)
    {
        dynamicCell = [[SMVehicleAuditDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        
        
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            lblTime = [[UILabel alloc] initWithFrame:CGRectMake(252,9,63,21)];
            
            
            lblVinNum = [[UILabel alloc] initWithFrame:CGRectMake(8,9,270,21)];
            lblGeoAddress = [[UILabel alloc] initWithFrame:CGRectMake(8,36,304,heightGeoAddress)];
            
            lblVehicleName = [[UILabel alloc] initWithFrame:CGRectMake(8,lblGeoAddress.frame.origin.y + lblGeoAddress.frame.size.height+7.0,304,21)];
            
            lblVehicleDetails1 = [[UILabel alloc] initWithFrame:CGRectMake(8,lblVehicleName.frame.origin.y + lblVehicleName.frame.size.height+7.0,304,heightVehicleDetails1)];
            
            lblVehicleDetails2 = [[UILabel alloc] initWithFrame:CGRectMake(8,lblVehicleDetails1.frame.origin.y+lblVehicleDetails1.frame.size.height+7.0,304,heightVehicleDetails2)];
            
            // ********************* Price labels *******************************
            
            
            lblSubscriptRetail = [[UILabel alloc] initWithFrame:CGRectMake(8, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+7.0+4.0, 24, 16)];
            
            
            
            lblPriceRetail.frame = CGRectMake(lblSubscriptRetail.frame.origin.x + lblSubscriptRetail.frame.size.width +3.0,lblVehicleDetails2.frame.origin.y+lblVehicleDetails2.frame.size.height+7.0,lblPriceRetail.frame.size.width,21);
            
            
            
            lblPriceSeparator = [[UILabel alloc] initWithFrame:CGRectMake(lblPriceRetail.frame.origin.x + lblPriceRetail.frame.size.width, lblPriceRetail.frame.origin.y , 1, 20)];
            
            lblSubscriptTrade = [[UILabel alloc] initWithFrame:CGRectMake(lblPriceSeparator.frame.origin.x + lblPriceSeparator.frame.size.width +5.0, lblSubscriptRetail.frame.origin.y, 22, 16)];
            
            
            lblPriceTrade = [[UILabel alloc] initWithFrame:CGRectMake(lblSubscriptTrade.frame.origin.x + lblSubscriptTrade.frame.size.width +5.0,lblPriceRetail.frame.origin.y,100,21)];
            
            // ********************* End of Price labels *******************************
            
            imgLicenceImage = [[UIImageView alloc]initWithFrame:CGRectMake(8, lblPriceRetail.frame.origin.y+lblPriceRetail.frame.size.height+7.0, 70.0, 52.0)];
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
        
        
        lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",@"ND 12345", @"ruby", @"smtests3-2"];
        
        lblGeoAddress.text = [NSString stringWithFormat:@"GEO: %@",auditTodayObj.auditGeoAddress];
        
        [self setAttributedTextForVehicleNameWithFirstText:auditTodayObj.auditVehicleYear andWithSecondText:auditTodayObj.auditVehicleName forLabel:lblVehicleName];
        
        
        lblVinNum.text = [NSString stringWithFormat:@"VIN: %@",auditTodayObj.auditVinID];
        lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",auditTodayObj.auditVehicleRegNum,auditTodayObj.auditVehicleColor, auditTodayObj.auditStockNo];
        
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
    
    if (arrayOfAuditedToday.count-1 == indexPath.row)
    {
        self.tblViewAuditedTodayList.tableFooterView = [[UIView alloc]init];
        
        
        if (arrayOfAuditedToday.count !=totalMatchedCount)
        {
            ++pageNumberCount;
            isLoadMore=YES;
            [self getTheAuditedTodayList];
            
            
        }
    }
    

    
    
    return dynamicCell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    [self.btnExpandEmailList setTag:section];
    
    return self.headerView;
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if([self.btnExpandEmailList isSelected])
    {
        CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
        
        UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
        
        [self.imgViewRightArrow setImage:rotatedImage];
        self.txtFieldEmailAddress.hidden = NO;
        self.btnSubmit.hidden = NO;
        
        return 92.0;
    }
    else
    {
        CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
        UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
        [self.imgViewRightArrow setImage:rotatedImage];
        self.txtFieldEmailAddress.hidden = YES;
        self.btnSubmit.hidden = YES;
        
        return 40.0;
    }
    
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tblViewAuditedTodayList)
    {
        if (indexPath.section == 0)
        {
            SMStockAuditDetailObject *auditTodayObj = [arrayOfAuditedToday objectAtIndex:indexPath.row];
            
            CGFloat height = 0.0f;
            
            
            height = ([self heightForText:[NSString stringWithFormat:@"GEO: %@",auditTodayObj.auditGeoAddress] ] + [self heightForText:[NSString stringWithFormat:@"%@ %@",auditTodayObj.auditVehicleYear,auditTodayObj.auditVehicleName] ] +[self heightForText: [NSString stringWithFormat:@"%@ | %@ | %@",auditTodayObj.auditVehicleRegNum,auditTodayObj.auditVehicleColor,auditTodayObj.auditStockNo]] + [self heightForText: [NSString stringWithFormat:@"%@ | %@ | %@",auditTodayObj.auditVehicleType,auditTodayObj.auditVehicleMileage,auditTodayObj.auditVehicleDays]] + (21.0+21.0+70.0+7.0));
            
            
            return height+40;
        }
        
    }
    
    return 0;
    
}

#pragma mark - CollectionView Datasource / Delegate methods.

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   SMTradeDetailSlider *sliderCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    sliderCell.backgroundColor = [UIColor lightGrayColor];
    
  SMStockAuditDetailObject *auditedTodayObject = (SMStockAuditDetailObject*) [arrayOfAuditedToday objectAtIndex:indexPath.row];
    
    NSLog(@"auditLicenseURL = %@ at index %ld",auditedTodayObject.auditLicenseURL,(long)indexPath.row);
    NSLog(@"auditVehicleURL = %@ at index %ld",auditedTodayObject.auditVehicleURL,(long)indexPath.row);

    if (indexPath.row == 0)
    {
         [sliderCell.imageVehicle setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",auditedTodayObject.auditLicenseURL]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
    }
    else
    {
         [sliderCell.imageVehicle setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",auditedTodayObject.auditVehicleURL]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        
        
    }
   
    
    [sliderCell.imageVehicle setContentMode:UIViewContentModeScaleAspectFit];
    return sliderCell;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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

    
    [self sendTheAuditItemsViaEmail];
    
}

- (IBAction)btnExpandEmailListDidClicked:(id)sender
{
    
    [self.btnExpandEmailList setSelected:!self.btnExpandEmailList.selected];
    [self.tblViewAuditedTodayList reloadData];
    
}

- (void)setTheTitle
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
    listActiveSpecialsNavigTitle.text = @"Audited Today";
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
    
        
}

-(void)populateTheRows
{
    for(int i=0;i<5;i++)
    {
        SMStockAuditDetailObject *auditTodayObj = [[SMStockAuditDetailObject alloc]init];
        
        auditTodayObj.auditVinID = @"VIN: 1234567890";
        auditTodayObj.auditGeoAddress = @"GEO: 8 Church place, Westville, Durban ";
        auditTodayObj.auditVehicleName = @"Volkswagen Golf 6 GTI";
        auditTodayObj.auditStockNo = @"Stock#: 10LDV12345";
        auditTodayObj.auditTime = @"12h34";
        
        [arrayOfAuditedToday addObject:auditTodayObj];
        
    }
    
    
}

- (CGFloat)heightForText:(NSString *)bodyText
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
        textSize = 300;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
        textSize = 752;
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



#pragma mark - WEbservice integration

-(void)getTheAuditedTodayList
{
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices getTheNecessaryStockAuditListWithUserHash:[SMGlobalClass sharedInstance].hashValue andIsDone:1 andIsUnmatched:0 andIsNotDone:0 andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andPageNumber:pageNumberCount andRecordCount:10];
    
    
    NSLog(@"Request URL = %@",requestURL);
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    isListingDataBeingFetched = YES;

    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         isListingDataBeingFetched = NO;

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
             
             if (!isLoadMore)
             {
                 [arrayOfAuditedToday removeAllObjects];
                 
             }
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
         }
         
         
         
     }];
    
    
    
}

-(void)sendTheAuditItemsViaEmail
{
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *finalDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
     NSMutableURLRequest *requestURL=[SMWebServices sendAuditHistoryItemsCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andDay:finalDateStr andEmailAddress:self.txtFieldEmailAddress.text andAuditedFlag:1 andNotAuditedFlag:0 andNotMatchedFlag:0];
    
    
    
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
    NSLog(@"elementName %@",elementName);
    NSLog(@"currentNodeContent %@",currentNodeContent);
    
    if([elementName isEqualToString:@"Audit"])
    {
        self.auditedTodayObject = [[SMStockAuditDetailObject alloc]init];
    
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
        if([currentNodeContent length] == 0)
        {
            self.auditedTodayObject.auditVehicleColor = @"Color?";
        }
        else
        {
            self.auditedTodayObject.auditVehicleColor = currentNodeContent;
        }
    }
    if([elementName isEqualToString:@"VehicleType"])
    {
        if([currentNodeContent length] == 0)
        {
            self.auditedTodayObject.auditVehicleType = @"Vehicle type?";
        }
        else
        {
            self.auditedTodayObject.auditVehicleType = currentNodeContent;
        }
        
    }
    if([elementName isEqualToString:@"MatchedAudits"])
    {
        totalMatchedCount = currentNodeContent.intValue;
        
    }
    if([elementName isEqualToString:@"Audit"])
    {
        
        [arrayOfAuditedToday addObject:self.auditedTodayObject];
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
    NSLog(@"MainArray count = %lu",(unsigned long)arrayOfAuditedToday.count);

    
    if(arrayOfAuditedToday.count == 0)
    {
        
        
        UIBAlertView *alert;
        alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:KNorecordsFousnt cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
         {
             if (didCancel)
             {
                 [self.navigationController popViewControllerAnimated:YES];
                  return;
             }
         }];
        
    }
    
    
    [self hideProgressHUD];

    [self.tblViewAuditedTodayList reloadData];
    //[imagesCollectionView reloadData];

    //[imagesCollectionView reloadData];
    
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

/*-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}*/
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
  SMStockAuditDetailObject *photoImagePath = (SMStockAuditDetailObject*)[arrayOfAuditedToday objectAtIndex:indexRow];
    
    finalPathLicseImage = photoImagePath.auditLicenseURL;
    finalPathVechImage = photoImagePath.auditVehicleURL;
}

-(void)getLicenscImageURLOnClickOnButton:(NSInteger)indexRow
{
    SMStockAuditDetailObject *photoImagePath = (SMStockAuditDetailObject*)[arrayOfAuditedToday objectAtIndex:indexRow];
    
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



@end
