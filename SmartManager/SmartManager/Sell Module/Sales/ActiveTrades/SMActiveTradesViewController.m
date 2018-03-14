//
//  SMActiveTradesViewController.m
//  Smart Manager
//
//  Created by Jignesh on 03/11/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMActiveTradesViewController.h"
#import "SMActiveCellTableViewCell.h"
#import "SMCellOfPlusImageCommentPV.h"
#import "UIImageView+WebCache.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"
#import "SMCommonClassMethods.h"
#import "SMCustomLabelBold.h"
#import "SMCustomDynamicCell.h"
#import "SMAddToStockViewController.h"
#import "SMPhotosAndExtrasObject.h"



@interface SMActiveTradesViewController ()
{
    IBOutlet UIView *viwBottom, *viwHeader, *viwFooter;
    
    IBOutlet SMCustomLabelBold *lblForExtrasComment;
    
    IBOutlet UILabel *lblBidsCount;
    NSString *strComment;
    NSMutableArray *arrayTradeSliderDetails;
    BOOL isAlreadyHeightdecreased;
}

-(float)heightforLabel:(UILabel*)lbl;

@end

@implementation SMActiveTradesViewController

#pragma mark  ===============
#pragma mark  UIView Lifecycle
#pragma mark  ===============

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     [self addingProgressHUD];
    isAlreadyHeightdecreased = NO;
    isExpiryDateExtended = NO;
     msgActivateTradeFail = @"";
    images_CollectionHeaders = [[NSMutableArray alloc] init];
    arrayOfBids = [[NSMutableArray alloc]init];
    arrayTradeSliderDetails = [[NSMutableArray alloc]init];
    arrayFullImages = [[NSMutableArray alloc]init];
    lblBidsCount.layer.cornerRadius = lblBidsCount.frame.size.width/2;
    lblBidsCount.layer.borderWidth = 2.0;
    lblBidsCount.layer.borderColor = [UIColor whiteColor].CGColor;
    
    label_MessageReceivedCount.layer.cornerRadius = label_MessageReceivedCount.frame.size.width/2;
    label_MessageReceivedCount.layer.borderWidth = 2.0;
    label_MessageReceivedCount.layer.borderColor = [UIColor whiteColor].CGColor;
    
    isFirstSectionExpanded = NO;
    isSecondSectionExpanded = NO;
    isAlreadyHeightdecreased = NO;
    
    NSLog(@"strVehicleYear = %@",self.selectedVehicleObj.strVehicleYear);
    
    lable_VehicleYear.text = [NSString stringWithFormat:@"%@ %@",@"Year?",@"Vehicle?"];
    
    lable_VehicleCode.text = [NSString stringWithFormat:@"%@ | %@ | %@",@"Reg?",@"Colour?",@"StockCode?"];
    
    lable_VehicleDays.text = [NSString stringWithFormat:@"%@ | %@",@"Type?",@"Age?"];
    
   [[SMAttributeStringFormatObject sharedService] setAttributedTextForVehiclePricesWithFirstText:@"Ret." andWithSecondText:self.selectedVehicleObj.strOfferAmount andWithThirdText:@"|" andWithFourthText:@"Trd." andWithFifthText:self.selectedVehicleObj.strVehicleTradePrice andWithSixthText:@"|" andWithSeventhText:@"Bid." andWithEighthText:self.selectedVehicleObj.strTotalHighest forLabel:lblPriceValues];
    
    label_BidRecieved.text = self.selectedVehicleObj.strTotalHighest;
    viwFooter.tag = 1000;
   
    [self registerNibFile];
    
    [self loadingVechicleDetails];
    [self webServiceForBidsList];
   [self webServiceForMessagesList];
    
    
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
    // Create the attributes
    
    NSDictionary *CorrectAttribute;
    NSDictionary *WrongAttribute;
    NSDictionary *SpaceAttribute;
    NSDictionary *PhotosAttribute;
    
    
    CorrectAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                      regularFont, NSFontAttributeName,
                      [UIColor greenColor],NSForegroundColorAttributeName,  nil];
    
    WrongAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                       regularFont, NSFontAttributeName,
                       [UIColor redColor],NSForegroundColorAttributeName, nil];
    
    
    SpaceAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                      regularFont, NSFontAttributeName,
                      [UIColor whiteColor],NSForegroundColorAttributeName, nil];
    
    PhotosAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                      regularFont, NSFontAttributeName,
                       [UIColor colorWithRed:54.0f/255.0f green:113.0f/255.0f blue:208.0f/255.0f alpha:1.0f],NSForegroundColorAttributeName, nil];
    

    NSMutableAttributedString *strmForSpace = [[NSMutableAttributedString alloc] initWithString:@" | " attributes:SpaceAttribute];
    
    NSMutableAttributedString *strmForExtra =[[NSMutableAttributedString alloc] initWithString:@"Extra  "];
    NSMutableAttributedString *strmExtra;
    if([strComment isEqualToString:@"x"])
    {
        strmExtra = [[NSMutableAttributedString alloc] initWithString:@"x" attributes:WrongAttribute];
        
    }
    else{
        strmExtra = [[NSMutableAttributedString alloc] initWithString:@"\u2713" attributes:CorrectAttribute];
        
    }
    
    [strmExtra appendAttributedString:strmForSpace];
    [strmForExtra appendAttributedString:strmExtra];
    
    
    NSMutableAttributedString *strmForComment =[[NSMutableAttributedString alloc] initWithString:@"Comment  "];
    NSMutableAttributedString *strmComment;
    if([strComment isEqualToString:@"x"])
    {
        strmComment = [[NSMutableAttributedString alloc] initWithString:@"x" attributes:WrongAttribute];
        
    }
    else{
        strmComment = [[NSMutableAttributedString alloc] initWithString:@"\u2713" attributes:CorrectAttribute];
    }
    
      [strmComment appendAttributedString:strmForSpace];
      [strmForComment appendAttributedString:strmComment];
      [strmForExtra appendAttributedString:strmForComment];
    
    NSMutableAttributedString *strmForPhotos =[[NSMutableAttributedString alloc] initWithString:@"Photos  "];
    NSMutableAttributedString *strmPhotos = [[NSMutableAttributedString alloc] initWithString:@"123" attributes:PhotosAttribute];
   
    [strmPhotos appendAttributedString:strmForSpace];
    [strmForPhotos appendAttributedString:strmPhotos];
    [strmForExtra appendAttributedString:strmForPhotos];
    
    NSMutableAttributedString *strmForVideos =[[NSMutableAttributedString alloc] initWithString:@"Videos  "];
    NSMutableAttributedString *strmVideos = [[NSMutableAttributedString alloc] initWithString:@"123" attributes:PhotosAttribute];
    
    [strmVideos appendAttributedString:strmForSpace];
    [strmForVideos appendAttributedString:strmVideos];
    [strmForExtra appendAttributedString:strmForVideos];
    
    [lblForExtrasComment setAttributedText:strmForExtra];
   
    

    btnExtend.layer.cornerRadius = 5.0f;
//    table_ActiveTrades.tableFooterView = viwFooter;
    table_ActiveTrades.tableFooterView = messagesReceivedViewFooterHeader;
    
    switch (self.listingScreenPageNumber)
    {
        case 1:
        {
            self.navigationItem.titleView = [SMCustomColor setTitle:@"Action: Bidding Ended"];
        }
            break;
        case 2:
        {
            self.navigationItem.titleView = [SMCustomColor setTitle:@"Active Bids Received"];
        }
            break;
        case 3:
        {
            self.navigationItem.titleView = [SMCustomColor setTitle:@"Trade Vehicles"];
        }
            break;
            
        default:
            break;
    }
}



-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //isAlreadyHeightdecreased = NO;

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  ===============




#pragma mark  ===============
#pragma mark  User Define Functions
#pragma mark  ===============


-(float)heightforLabel:(UILabel*)lbl
{
    NSLog(@"height=%f",lbl.frame.size.width);
    CGSize labelSize = [lbl.text boundingRectWithSize:CGSizeMake(lbl.bounds.size.width, 1000)  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:@{NSFontAttributeName: lbl.font}
                                              context:nil].size;
    
    return labelSize.height;
}

-(void) registerNibFile
{
    
    // for table views
    

    [table_ActiveTrades registerNib:[UINib nibWithNibName:@"SMActiveCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellId"];
    
    
    
    // colection view

    [collectionView_Images registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImagePV"];
    
}

#pragma mark  ===============
#pragma mark  UItable view Functions
#pragma mark  ===============

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    UIView *headerColorView = [[UIView alloc] init];
    UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
    
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
        [sectionLabelBtn setTitle:@"View Bids Received" forState:UIControlStateNormal];
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 70, 0.0, 0.0);
        else
            sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(100.0, 300, 110.0, 0.0);
    }
    else
    {
        [sectionLabelBtn setTitle:@"Messages Received" forState:UIControlStateNormal];
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 70, 2.0, 0.0);
        else
            sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 300, 10.0, 0.0);
        
    }
    
    
    if(isFirstSectionExpanded)
    {
        if(section == 0)
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
    else if(isSecondSectionExpanded)
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
        
        if(section == 0)
            [self setTheLabelCountText:(int)arrayOfBids.count];
        else
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
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 35.0f : 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == table_ActiveTrades)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                if (isFirstSectionExpanded)
                    return 63.0;
                else
                    return 0.0;
            }
                break;
            case 1:
            {
                if (isSecondSectionExpanded)
                {
                    
                    SMVehiclelisting *rowObject = (SMVehiclelisting*)[arrayOfMessages objectAtIndex:indexPath.row];
                    
                    //----------------------------------------------------------------------------------------
                    
                    CGFloat heightMessage = 0.0f;
                    
                    
                    heightMessage = [self heightForTextForMessageSection:rowObject.strMessage andTextWidthForiPhone:180];
                    
                    
                    //----------------------------------------------------------------------------------------
                    
                    CGFloat heightName = 0.0f;
                    
                    
                    heightName = [self heightForTextForMessageSection:rowObject.strClientName andTextWidthForiPhone:120];
                    
                    
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
    return 0;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *mainCell;

    if(indexPath.section == 0)
    {
        static NSString     *CellIdentifier = @"CellId";
        SMActiveCellTableViewCell  *cell = (SMActiveCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        SMVehiclelisting *rowBidObject;
        
        [[cell.contentView viewWithTag:1000]removeFromSuperview];
       
        if(arrayOfBids.count == indexPath.row)
        {
            cell.lblClientName.text = @"";
            cell.lblUserInfo.text = @"";
            cell.lblAmount.text =  @"";
            [cell.contentView addSubview:viwFooter];
             NSLog(@"yes arrayOfBids.count = %lu indexPath.row %ld",(unsigned long)arrayOfBids.count, (long)indexPath.row);
        }
        else
        {
             NSLog(@"no arrayOfBids.count = %lu indexPath.row %ld",(unsigned long)arrayOfBids.count, (long)indexPath.row);
            rowBidObject = (SMVehiclelisting*)[arrayOfBids objectAtIndex:indexPath.row];
            cell.btnCheckBox.selected = rowBidObject.isAnyOneBidSelected;
        }

        
        
        cell.btnCheckBox.tag = indexPath.row;
        
        cell.lblClientName.text = rowBidObject.strClientName;
        cell.lblUserInfo.text = [NSString stringWithFormat:@"%@ | %@",rowBidObject.strUser,rowBidObject.strOfferDate];
        cell.lblAmount.text = rowBidObject.strAmount;
        
        
        [cell.btnCheckBox addTarget:self action:@selector(btnCheckBoxDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.backgroundColor = [UIColor clearColor];
        
        //
        
//        if (indexPath.row == 9 && indexPath.section == 0)
//        {
//            [cell.contentView addSubview:viwFooter];
//        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        mainCell = cell;
        return mainCell;
    }
    else
    {
        
            static NSString *cellIdentifier3= @"SMCustomDynamicCell";
            
            SMCustomDynamicCell     *dynamicCell;
            SMVehiclelisting *rowObject = (SMVehiclelisting*)[arrayOfMessages objectAtIndex:indexPath.row];
            
            UILabel *lblSellerName;
            UILabel *lblMessageTime;
            UILabel *lblMessage;
            
            
            //----------------------------------------------------------------------------------------
            
            CGFloat heightMessage = 0.0f;
            
        
            heightMessage = [self heightForTextForMessageSection:rowObject.strMessage andTextWidthForiPhone:180];
        
            
            //----------------------------------------------------------------------------------------
            
            CGFloat heightName = 0.0f;
            
            
            heightName = [self heightForTextForMessageSection:rowObject.strClientName andTextWidthForiPhone:120];
        
            
            //----------------------------------------------------------------------------------------

            
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
                    lblSellerName = [[UILabel alloc] initWithFrame:CGRectMake(8,5,200,25)];
                    lblMessageTime = [[UILabel alloc] initWithFrame:CGRectMake(8,lblSellerName.frame.origin.y + lblSellerName.frame.size.height + 2.0,lblSellerName.frame.size.width,25)];
                    lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(lblSellerName.frame.origin.x + lblSellerName.frame.size.width + 6.0,lblSellerName.frame.origin.y,550,heightMessage)];
                    
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
            
            lblSellerName.text = rowObject.strClientName;
            lblMessageTime.text = rowObject.strSoldDate;
            lblMessage.text = rowObject.strMessage;
        
            [dynamicCell.contentView addSubview:lblSellerName];
            [dynamicCell.contentView addSubview:lblMessageTime];
            [dynamicCell.contentView addSubview:lblMessage];
            dynamicCell.backgroundColor = [UIColor blackColor];
            
            
            lblMessage.numberOfLines = 0;
            [lblMessage sizeToFit];
            
            lblSellerName.numberOfLines = 0;
            [lblSellerName sizeToFit];
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            mainCell = dynamicCell;
            return mainCell;
            
        }
    
    
    return nil; 
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    {
        switch (section)
        {
            
            case 0:
            {
                if (isFirstSectionExpanded)
                {
                    if(arrayOfBids.count == 0)
                        return 0;
                    else
                        return arrayOfBids.count + 1;
                }
                return 0;
            }
                break;
            case 1:
            {
                if (isSecondSectionExpanded)
                {
                    return arrayOfMessages.count;
                }
                return 0;
            }
                break;
                
            default: return 0;
                break;
        }
    }
    return 0;
}

#pragma mark  ===============





#pragma mark  ===============
#pragma mark  UICollection View
#pragma mark  ===============

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMCellOfPlusImageCommentPV *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMCellOfActualImagePV" forIndexPath:indexPath];
    [cell.btnDelete setHidden:YES];
    [cell.imgActualImage   setImageWithURL:[NSURL URLWithString:[arrayTradeSliderDetails objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(75, 60);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
 return  arrayTradeSliderDetails.count;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        networkGallery.startingIndex = indexPath.row;
        SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate.isPresented =  YES;
        [self.navigationController pushViewController:networkGallery animated:YES];
    });
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



#pragma mark - WEbservice methods

-(void)webServiceForBidsList
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    isLoadVehicleWebservice = NO;
    isDeactivateTradeWebserviceCalled = NO;
    isExpiryDateExtended = NO;

    NSMutableURLRequest *requestURL = [SMWebServices listBidsForTradeVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andVehicleID:self.selectedVehicleObj.strUsedVehicleStockID.intValue];
    
    //  NSMutableURLRequest *requestURL = [SMWebServices listBidsForTradeVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andVehicleID:self.selectedVehicleObj.strUsedVehicleStockID.intValue];
    
    
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
             [xmlParser parse];
         }
     }];
}

-(void)webServiceForMessagesList
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    isLoadVehicleWebservice = NO;
    isDeactivateTradeWebserviceCalled = NO;
    isExpiryDateExtended = NO;

    NSMutableURLRequest *requestURL = [SMWebServices listMessagesForVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockID:self.selectedVehicleObj.strUsedVehicleStockID.intValue];
    
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
             
             NSLog(@"%@",newStr);
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)webServiceExtendBiddingTrade
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
   isLoadVehicleWebservice = NO;
    isDeactivateTradeWebserviceCalled = NO;
    isExpiryDateExtended = NO;

    NSMutableURLRequest *requestURL = [SMWebServices extendBiddingUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleID:self.selectedVehicleObj.strUsedVehicleStockID.intValue];
    
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

- (void)webServiceAcceptBidTrade:(int)vehicleID offerID:(int)offerID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
   isLoadVehicleWebservice = NO;
    isDeactivateTradeWebserviceCalled = NO;
    isExpiryDateExtended = NO;

    NSMutableURLRequest *requestURL = [SMWebServices acceptBidTradeUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleID:vehicleID withBidValue:offerID];
    
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

- (void)webServiceRejectBidTrade:(int)vehicleID offerID:(int)offerID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    isLoadVehicleWebservice = NO;
    isDeactivateTradeWebserviceCalled = NO;
    isExpiryDateExtended = NO;
    NSMutableURLRequest *requestURL = [SMWebServices rejectBidTradeUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleID:vehicleID withBidValue:offerID];
    
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

-(void)webServiceForActivatingVehicleWithStockCode:(int)stockCode andIsTrade:(BOOL)isTrade andTradePrice:(int)traderPrice
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    isDeactivateTradeWebserviceCalled = YES;
    isExpiryDateExtended = NO;
    
    NSMutableURLRequest *requestURL = [SMWebServices activateTheVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andStockID:stockCode andIsTrade:0 andTradePrice:traderPrice];
    
    
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


#pragma mark - WebService Call

-(void)loadingVechicleDetails
{
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    isLoadVehicleWebservice = YES;
    isDeactivateTradeWebserviceCalled = NO;
    isExpiryDateExtended = NO;
    NSMutableURLRequest *requestURL = [SMWebServices gettingDetailsVehicleImages:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleId:self.selectedVehicleObj.strUsedVehicleStockID.intValue];
    
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
         {   [arrayTradeSliderDetails    removeAllObjects];
             [arrayFullImages            removeAllObjects];

             xmlParser = [[NSXMLParser alloc] initWithData: data];
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
    // NSLog(@"StartElementName =%@ ",elementName);
    
    if ([elementName isEqualToString:@"message"])
    {
        messageObject = [[SMVehiclelisting alloc]init];
    }
    if ([elementName isEqualToString:@"offer"])
    {
        bidsObject = [[SMVehiclelisting alloc]init];
    }
    currentNodeContent = [NSMutableString stringWithString:@""];
    
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    
    NSString *string = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
     //NSLog(@"EndElementName =%@  currentNodeContent = %@",elementName,currentNodeContent);
    
    
    if ([elementName isEqualToString:@"Thumb"])
    {
              
        currentNodeContent = (NSMutableString *) [currentNodeContent substringToIndex:currentNodeContent.length-3];
        currentNodeContent = (NSMutableString *)[NSString stringWithFormat:@"%@%@",currentNodeContent,@"180"];
        [arrayTradeSliderDetails addObject:currentNodeContent];
    }
    if ([elementName isEqualToString:@"Full"])
    {
        [arrayFullImages addObject:currentNodeContent];
    }
    if ([elementName isEqualToString:@"id"])
    {
        bidsObject.strOfferID  = currentNodeContent;
    }
    
    
    if ([elementName isEqualToString:@"clientID"])
    {
       bidsObject.intClientID  = currentNodeContent.intValue;
    }
    if ([elementName isEqualToString:@"clientName"])
    {
        bidsObject.strClientName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Date"])
    {
        bidsObject.strOfferDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"amount"])
    {
        bidsObject.strAmount = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        
    }
    if ([elementName isEqualToString:@"user"])
    {
        bidsObject.strUser = currentNodeContent;
    }
    
    if([elementName isEqualToString:@"offer"])
    {
        bidsObject.isAnyOneBidSelected = NO;
        [arrayOfBids addObject:bidsObject];
        
        
    }
    if([elementName isEqualToString:@"ListBidsResult"])
    {
        table_ActiveTrades.dataSource = self;
        table_ActiveTrades.delegate = self;
       // [collectionView_Images reloadData];
        [table_ActiveTrades reloadData];
       

        
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
        if(!isDeactivateTradeWebserviceCalled)
        messageObject.strMessage = currentNodeContent;
        else
            msgActivateTradeFail = currentNodeContent;
        
    }
    if ([elementName isEqualToString:@"message"])
    {
       [arrayOfMessages addObject:messageObject];
    }
    if ([elementName isEqualToString:@"ListMessagesForVehicleResult"])
    {
        table_ActiveTrades.dataSource = self;
        table_ActiveTrades.delegate = self;
       // [collectionView_Images reloadData];
        [table_ActiveTrades reloadData];
    }

    // Load Vehicle parsing
    
    
   
   
    
    if ([elementName isEqualToString:@"Year"])
    {
        strYear  = currentNodeContent;
    }
    if ([elementName isEqualToString:@"FriendlyName"])
    {
        strFriendlyName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
        if ([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"0"])
        {
           strMileage = @"Mileage?";
        }
        else
        {
            
            strMileage = [NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent]];
        }
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        if ([currentNodeContent length] == 0)
        {
            strColor = @"Colour?";
        }
        else
            strColor = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TradePrice"])
    {
       // strTradePrice = currentNodeContent;
    }
    /*if ([elementName isEqualToString:@"Expires"])
    {
        strExpiresDate = currentNodeContent;
    }*/
    if ([elementName isEqualToString:@"MinBid"])
    {
        if ([currentNodeContent length] == 0 || currentNodeContent.intValue == 0)
        {
            strTradePrice = @"R?";
        }
        else
            strTradePrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:currentNodeContent];
        
    }
    
    if ([elementName isEqualToString:@"HightestBid"])
    {
        if ([currentNodeContent length] == 0 || currentNodeContent.intValue == 0)
        {
            strHighestBidReceived = @"R?";
            strBidPrice = @"R?";
        }
        else
        strHighestBidReceived = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:currentNodeContent];
        strBidPrice = strHighestBidReceived;
    }
    if ([elementName isEqualToString:@"StockNumber"])
    {
        if ([currentNodeContent length] == 0)
        {
            strStockCode = @"StockCode?";
        }
        else
            strStockCode = currentNodeContent;
    }
    if ([elementName isEqualToString:@"RegNumber"])
    {
        if ([currentNodeContent length] == 0)
        {
            strRegistration = @"Reg?";
        }
        else
            strRegistration = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Success"] )
    {
        NSString *strExtendBidding = @"Trade period extended";
        
        if(isExpiryDateExtended)
            currentNodeContent = [strExtendBidding mutableCopy];
        
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel)
            {
                return;
                
            }
            
        }];
    
    }
    if ([elementName isEqualToString:@"Expires"])
    {
        strExtendedDate = [currentNodeContent substringToIndex:11];
    }
    if ([elementName isEqualToString:@"Date"])
    {
         NSLog(@"called thisssss");
       strExtendedDate = [currentNodeContent substringToIndex:11];
        isExpiryDateExtended = YES;
        
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
    if ([elementName isEqualToString:@"AcceptBidResponse"])
    {
       [arrayOfBids removeObjectAtIndex:selectedIndex];
        [table_ActiveTrades reloadData];
        
    }
    if ([elementName isEqualToString:@"RejectBidResponse"])
    {
        [arrayOfBids removeObjectAtIndex:selectedIndex];
        [table_ActiveTrades reloadData];
    }
    
    
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"ARRayOfBids = %lu",(unsigned long)arrayOfBids.count);
    
    collectionView_Images.dataSource = self;
    collectionView_Images.delegate = self;
    [collectionView_Images reloadData];
    
   // if(isLoadVehicleWebservice)
    {
           [self setDataAndFrameForTableViewHeader];
       
    }
    [self hideProgressHUD];
}
-(NSString*)returnTheExpectedStringForString:(NSString*)inputString
{
    inputString = [inputString substringToIndex:12];
    return inputString;
}

-(void)setDataAndFrameForTableViewHeader
{
    //Set dynamic heighrs for table header
    
    /*lable_VehicleYear.text = [NSString stringWithFormat:@"%@ %@",self.selectedVehicleObj.strVehicleYear,self.selectedVehicleObj.strVehicleName];
    
    lable_VehicleCode.text = [NSString stringWithFormat:@"%@ | %@ | %@",self.selectedVehicleObj.strVehicleRegNo,self.selectedVehicleObj.strVehicleColor,self.selectedVehicleObj.strStockCode];
    
    lable_VehicleDays.text = [NSString stringWithFormat:@"%@ | %@",self.selectedVehicleObj.strVehicleType,self.selectedVehicleObj.strVehicleAge];*/
    
    if([strRegistration isEqualToString:@"(null)"] || [strRegistration length] == 0)
        strRegistration = @"Reg?";
    
    [self setAttributedTextForVehicleDetailsWithFirstText:self.selectedVehicleObj.strVehicleYear andWithSecondText:self.selectedVehicleObj.strVehicleName forLabel:lable_VehicleYear];
    
    lable_VehicleCode.text = [NSString stringWithFormat:@"%@ | %@ | %@",strRegistration,self.selectedVehicleObj.strVehicleColor,self.selectedVehicleObj.strStockCode];
   
    [self setAttributedTextForDays:self.selectedVehicleObj.strVehicleType withKm:self.selectedVehicleObj.strVehicleMileage withDays:self.selectedVehicleObj.strVehicleAge forLabel:lable_VehicleDays];
    
    lable_VehicleYear.frame = CGRectMake(lable_VehicleYear.frame.origin.x, lable_VehicleYear.frame.origin.y, lable_VehicleYear.frame.size.width, [self heightforLabel:lable_VehicleYear]);
    
    lable_VehicleCode.frame = CGRectMake(lable_VehicleCode.frame.origin.x, lable_VehicleYear.frame.origin.y+lable_VehicleYear.frame.size.height+5, lable_VehicleCode.frame.size.width, [self heightforLabel:lable_VehicleCode]);
    
    lable_VehicleDays.frame = CGRectMake(lable_VehicleDays.frame.origin.x, lable_VehicleCode.frame.origin.y+lable_VehicleCode.frame.size.height+5, lable_VehicleDays.frame.size.width, [self heightforLabel:lable_VehicleDays]);
    
    lblPriceValues.frame = CGRectMake(lblPriceValues.frame.origin.x, lable_VehicleDays.frame.origin.y+lable_VehicleDays.frame.size.height+7, lblPriceValues.frame.size.width, [self heightforLabel:lblPriceValues]);
    
    //Set bottom view frame
    if(arrayTradeSliderDetails.count == 0)
    {
        if(!isAlreadyHeightdecreased) {
                   viwBottom.frame = CGRectMake(viwBottom.frame.origin.x, lable_VehicleDays.frame.origin.y + lable_VehicleDays.frame.size.height+5, viwBottom.frame.size.width, viwBottom.frame.size.height - 70);
            isAlreadyHeightdecreased = YES;
        }
        
    }
    else
    {
        if(isAlreadyHeightdecreased) {
            viwBottom.frame = CGRectMake(viwBottom.frame.origin.x, lable_VehicleDays.frame.origin.y + lable_VehicleDays.frame.size.height+5, viwBottom.frame.size.width, viwBottom.frame.size.height + 70);
            isAlreadyHeightdecreased = NO;

        }
        else{
            viwBottom.frame = CGRectMake(viwBottom.frame.origin.x, lable_VehicleDays.frame.origin.y + lable_VehicleDays.frame.size.height+5, viwBottom.frame.size.width, viwBottom.frame.size.height);
        }
    }
    
      view_TableHeader.frame = CGRectMake(0, 0, view_TableHeader.frame.size.width, viwBottom.frame.origin.y+viwBottom.frame.size.height);
    
    [table_ActiveTrades setTableHeaderView:view_TableHeader];

    //lblRetailPriceValue.text = self.selectedVehicleObj.strOfferAmount;
    //lblTradePriceValue.text = strTradePrice;
    //lblBidPriceValue.text = strBidPrice;
   /* if(!isExpiryDateExtended)
    {
        NSString *expireDate = [self returnTheExpectedStringForString:strExpiresDate];
        lable_ExpireTime.text = expireDate;
    }
    else*/
       lable_ExpireTime.text = strExtendedDate;
    
    
}

#pragma mark  ===============


#pragma mark  ===============
#pragma mark  Attributed Table view cell colours
#pragma mark  ===============

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


-(void)setAttributedTextForDays:(NSString *) strType withKm:(NSString *) strKM  withDays:(NSString *) strDays1 forLabel:(UILabel *)label
{
    
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite       = [UIColor whiteColor];
    UIColor *foregroundColorBlue        = [SMCustomColor setBlueColorThemeButton];
    
    
    
    // Create the attributes
    
    NSDictionary *FirstYear             = [NSDictionary dictionaryWithObjectsAndKeys:
                                           regularFont, NSFontAttributeName,
                                           foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *FirstAttribute        = [NSDictionary dictionaryWithObjectsAndKeys:
                                           regularFont, NSFontAttributeName,
                                           foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *DaysAttribute         = [NSDictionary dictionaryWithObjectsAndKeys:
                                           regularFont, NSFontAttributeName,
                                           foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString *attributedYear= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@    |",strType]attributes:FirstYear];
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@    |",strKM]attributes:FirstAttribute];
    
      NSMutableAttributedString *attributedDays= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strDays1]attributes:DaysAttribute];
    
    [attributedFirstText   appendAttributedString:attributedDays];
    [attributedYear       appendAttributedString:attributedFirstText];
    
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedYear];
    
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

#pragma mark  ===============

- (CGFloat)heightForTextForMessageSection:(NSString *)bodyText andTextWidthForiPhone:(float)textWidth
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
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        textSize = 570;
    }
    CGSize constraintSize = CGSizeMake(textSize, MAXFLOAT);
    //   CGSize labelSize = [bodyText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect textRect = [bodyText boundingRectWithSize:constraintSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:cellFont}
                                             context:nil];
    
    CGSize labelSize = textRect.size;
    CGFloat height = labelSize.height;
    
    return height;
}

- (IBAction)btnCheckBoxDidClicked:(UIButton*)sender
{
    selectedIndex = [sender tag];
    NSLog(@"selectedIndex = %ld",(long)selectedIndex);
    
    for(SMVehiclelisting *selectedObj in arrayOfBids)
    {
        selectedObj.isAnyOneBidSelected = NO;
        
    }
    NSLog(@"arrayOfBids = %@",arrayOfBids);
    SMVehiclelisting *selectedObj = (SMVehiclelisting*)[arrayOfBids objectAtIndex:[sender tag]];
    selectedObj.isAnyOneBidSelected = YES;
    sender.selected = !sender.selected;
   // [collectionView_Images reloadData];
     NSLog(@"arrayOfBids = %@",arrayOfBids);
    [table_ActiveTrades reloadData];
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


-(IBAction)btnSectionTitleDidClicked:(id)sender
{
    [self.view endEditing:YES];
    
    UIButton *btn = (UIButton *) sender;
    
    if(btn.tag == 0)
    {
        isFirstSectionExpanded = !isFirstSectionExpanded;
        
        if(isFirstSectionExpanded)
            isSecondSectionExpanded = NO;
        
    }
    else
    {
        isSecondSectionExpanded = !isSecondSectionExpanded;
        
        if(isSecondSectionExpanded)
            isFirstSectionExpanded = NO;
        
    }
    [collectionView_Images reloadData];

    [table_ActiveTrades reloadData];
    
}


- (IBAction)btnEditVehicleDidClicked:(id)sender
{
    
    NSLog(@" edit with index %ld",(long)[sender tag]);
    
    SMAddToStockViewController *addToStockVC;
    
    addToStockVC = [[SMAddToStockViewController alloc]initWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)? @"SMAddToStockViewController" : @"SMAddToStockViewController_iPad" bundle:nil];
    
    SMPhotosAndExtrasObject *rowObj = [[SMPhotosAndExtrasObject alloc]init];
    
    rowObj.strUsedYear = strYear;
    rowObj.strVehicleName = strFriendlyName;
    rowObj.strRegistration = strRegistration;
    rowObj.strColour = strColor;
    rowObj.strStockCode = strStockCode;
    rowObj.strVehicleType = strVehicleType;
    rowObj.strMileage = strMileage;
    rowObj.strDays = strDays;
    rowObj.strUsedVehicleStockID = self.selectedVehicleObj.strUsedVehicleStockID;
    
    
    
    addToStockVC.photosExtrasObject = rowObj;
    addToStockVC.isUpdateVehicleInformation = YES;
    [SMGlobalClass sharedInstance].isListModule = YES;
    NSLog(@"self.photosExtrasObject = %@",rowObj.strUsedVehicleStockID);

    [self.navigationController pushViewController:addToStockVC animated:YES];
    
}

- (IBAction)btnExtendDidClicked:(id)sender
{
    
    [self webServiceExtendBiddingTrade];
    
}

- (IBAction)btnRejectBidDidClicked:(id)sender
{
    SMVehiclelisting *selectedObj = (SMVehiclelisting*)[arrayOfBids objectAtIndex:selectedIndex];
    
    [self webServiceRejectBidTrade:self.selectedVehicleObj.strUsedVehicleStockID.intValue offerID:selectedObj.strOfferID.intValue];
    
}

- (IBAction)btnAcceptBidDidClicked:(id)sender
{
    
    SMVehiclelisting *selectedObj = (SMVehiclelisting*)[arrayOfBids objectAtIndex:selectedIndex];
    
    
    [self webServiceAcceptBidTrade:self.selectedVehicleObj.strUsedVehicleStockID.intValue offerID:selectedObj.strOfferID.intValue];
    
    
    
    
    
    
    
}

- (IBAction)btnDeactivateTradeDidClciked:(id)sender
{
    NSString *tradePrice = lblTradePriceValue.text;
    
    if([tradePrice hasPrefix:@"R"])
    {
       tradePrice =  [tradePrice substringFromIndex:1];
        tradePrice = [tradePrice stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    NSLog(@"tradePrice = %@",tradePrice);
    
    [self webServiceForActivatingVehicleWithStockCode:self.selectedVehicleObj.strUsedVehicleStockID.intValue andIsTrade:0 andTradePrice:tradePrice.intValue];
    
}
@end
