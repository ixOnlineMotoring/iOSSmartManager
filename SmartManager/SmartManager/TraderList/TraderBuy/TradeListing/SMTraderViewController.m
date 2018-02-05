//
//  SMTraderViewController.m
//  SmartManager
//
//  Created by Jignesh on 07/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMTraderViewController.h"
#import "UIImageView+WebCache.h"
#import "SMTraderViewTableViewCell.h"
#import "SMSearchTraderTableViewCell.h"
#import "SMPreviewImageCell.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMTraderSearchSortByCell.h"
#import "SMCustomColor.h"
#import "SMCommonClassMethods.h"
#import "SMTraderBuyViewController.h"
#import "SMReusableSearchTableViewController.h"


const int Page_S = 10;
const int initiallyStartYear = 16; // initially Start Year as 2006 and 2006 is at 16 index

@interface SMTraderViewController ()
{
    SMReusableSearchTableViewController *searchMakeVC;
    NSArray *arrLoadNib;
}

@end

@implementation SMTraderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        arrayYears              = [[NSMutableArray alloc] init];
        arrayVehicleListing     = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.btnClear      setExclusiveTouch:YES];
    [buttonSearch       setExclusiveTouch:YES];
    [buttonHeaderFilter setExclusiveTouch:YES];
    
    isSearch = NO;
    appdelegate=(SMAppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isRefreshUI = NO;
    [self checkBoxAllDidClicked:checkBoxAll];
    
    sortingText = @"mileage:asc";
    
    [self addingProgressHUD];
    
    [self registerNib];
    
    // used for setting Navigation Title
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Search Trade"];
    
    [self.tableSearch setTableFooterView:[[UIView alloc]init]];
    
    selectedRow = 0;
    
    isTheAttemtFirst = YES;
    
    isPaginationCompleted = YES;
    
    self.viewYearFrame.layer.cornerRadius = 10.0;
    self.viewYearFrame.clipsToBounds      = YES;
    
    self.viewDropdownFrame.layer.cornerRadius = 10.0;
    self.viewDropdownFrame.clipsToBounds      = YES;
    
    [buttonHeaderFilter setSelected:YES];
    
    selectedMakeIndex       = -1;
    selectedModelIndex      = -1;
    selectedVariantsIndex   = -1;
    
    // by Default id will be -1
    
    selectedMakeId          = -1;
    selectedModelId         = -1;
    selectedVariantId       = -1;
    
    // by default years
    
    selectedFromYear        = @"2006";
    
    //Get Current Year into Current Year
    formatter       = [[NSDateFormatter alloc] init];
    [formatter         setDateFormat:@"yyyy"];
    currentYear     = [[formatter stringFromDate:[NSDate date]] intValue];
    
    selectedToYear  = [NSString stringWithFormat:@"%d",currentYear];
    
    [self.txtYearTo setText:selectedToYear];
    [self.txtYearFrom setText:selectedFromYear];

    //[self.labelNoSearchResult setHidden:YES];
    
    [self setCustomFont];
    
    [self populateTheSortByArray];
    
    //Create Years Array from 1990 to This year
    for (int fromYear = 1990; fromYear<=currentYear; fromYear++)
    {
        [arrayYears addObject:[NSString stringWithFormat:@"%d",fromYear]];
    }
    
    // initially Start Year as 2006 and 2006 is at 16th index
    
    selectedRowFromYear = initiallyStartYear;
    
    // by default selected year will current year

    selectedRowToYear = arrayYears.count-1;

    [yearPicker reloadAllComponents];
    
    [self.txtModel      setUserInteractionEnabled:NO];
    [self.txtVariants   setUserInteractionEnabled:NO];
    
    self.tableTrader.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMReusableSearchTableViewController" owner:self options:nil];
    searchMakeVC = [arrLoadNib objectAtIndex:0];

}

-(void)viewWillAppear:(BOOL)animated
{
    if(appdelegate.isRefreshUI)
    {
        
        [self getRefreshedVehicleListing];
    }

}

- (void)setCustomFont
{
    UIFont *customFontLight = [UIFont fontWithName:FONT_NAME size:14.0f];
    UIFont *customFontLightIpad = [UIFont fontWithName:FONT_NAME size:20.0f];

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        buttonHeaderFilter.titleLabel.font = customFontLight;
        
        self.cancelButton.titleLabel.font       = customFontLight;
        self.clearBtn.titleLabel.font           = customFontLight;
        self.pickerBtnCancel.titleLabel.font    = customFontLight;
        self.pickerBtnDone.titleLabel.font      = customFontLight;
        
        self.txtYearFrom.font       = customFontLight;
        self.txtYearTo.font         = customFontLight;
        self.txtMake.font           = customFontLight;
        self.txtModel.font          = customFontLight;
        self.txtVariants.font       = customFontLight;
        self.txtFieldSortBy.font    = customFontLight;
    }
    else
    {
        buttonHeaderFilter.titleLabel.font = customFontLightIpad;
        
        self.cancelButton.titleLabel.font       = customFontLightIpad;
        self.clearBtn.titleLabel.font           = customFontLightIpad;
        self.pickerBtnCancel.titleLabel.font    = customFontLightIpad;
        self.pickerBtnDone.titleLabel.font      = customFontLightIpad;
        
        self.txtYearFrom.font       = customFontLightIpad;
        self.txtYearTo.font         = customFontLightIpad;
        self.txtMake.font           = customFontLightIpad;
        self.txtModel.font          = customFontLightIpad;
        self.txtVariants.font       = customFontLightIpad;
        self.txtFieldSortBy.font    = customFontLightIpad;
    }
}

#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Begin TextField

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.txtFieldSortBy)
    {
        [self.clearBtn setHidden:YES];
        [textField resignFirstResponder];
        selectedDropdown = 10;
        [self.tableSearch reloadData];
        [self loadPopUpView];
    }
    
    if ([self.txtYearFrom isFirstResponder])
    {
//        [self.clearBtn setHidden:YES];
//        [self.txtYearFrom setTag:1];
//        [self.txtYearFrom resignFirstResponder];
//        [yearPicker selectRow:selectedRowFromYear inComponent:0 animated:YES];
//        [self loadPopUpViewForYears];
        
        [self.view endEditing:YES];
        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
        SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
        
        [popUpView getTheDropDownData:[SMAttributeStringFormatObject getYear] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:YES]; // array to be passed for custom popup dropdown
        
        [self.view addSubview:popUpView];
        
        [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
            NSLog(@"selected text = %@",selectedTextValue);
            NSLog(@"selected ID = %d",selectIDValue);
            textField.text = selectedTextValue;
            selectedRowFromYear = selectIDValue;
            selectedFromYear = selectedTextValue;
            //selectedMakeId = selectIDValue;
        }];
    }
    else if ([self.txtYearTo isFirstResponder])
    {
//        [self.clearBtn setHidden:YES];
//        [self.txtYearTo setTag:2];
//        [self.txtYearTo setText:selectedToYear];
//        [self.txtYearTo resignFirstResponder];
//        [yearPicker selectRow:selectedRowToYear inComponent:0 animated:YES];
//        [self loadPopUpViewForYears];
       
        [self.view endEditing:YES];
        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
        SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
        
        [popUpView getTheDropDownData:[SMAttributeStringFormatObject getYear] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:YES]; // array to be passed for custom popup dropdown
        
        [self.view addSubview:popUpView];
        
        [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
           
            
            NSLog(@"selected text = %@",selectedTextValue);
            NSLog(@"selected ID = %d",selectIDValue);
            textField.text = selectedTextValue;
            selectedRowFromYear = selectIDValue;
            selectedToYear = selectedTextValue;
            //selectedMakeId = selectIDValue;
        }];

    }
    else if([self.txtMake isFirstResponder])
    {
        [self.clearBtn setHidden:NO];
        selectedDropdown = 1;
        [textField resignFirstResponder];
        
        if (arrayMake.count>0)
        {
            //[self loadPopup];
            //[loadVehicleTableView reloadData];
            
            
            [searchMakeVC getTheDropDownData:arrayMake];
            [self.view addSubview:searchMakeVC];
            
            [SMReusableSearchTableViewController getTheSelectedSearchDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                
                
                    [self.txtMake setText:selectedTextValue];
                    selectedMakeId = selectIDValue;
                
                        [self.txtModel setText:@""];
                        [self.txtVariants setText:@""];
                        
                        [self.txtModel         setUserInteractionEnabled:YES];
                        [self.txtVariants      setUserInteractionEnabled:NO];
                        
                        [arrayModel removeAllObjects];
                        [arrayVariant removeAllObjects];
                
                
            }];
            
            [self hideProgressHUD];
            
        }
        else
        {
            [self loadingAllMakeListing];
        }
    }
    else if ([self.txtModel isFirstResponder])
    {
        [self.clearBtn setHidden:NO];
        selectedDropdown = 2;
        
        [textField resignFirstResponder];
        
        if (arrayModel.count>0)
        {
            [self.tableSearch reloadData];
            [self loadPopUpView];
        }
        else
        {
            [self loadingAllModelValues];
        }
    }
    else if ([self.txtVariants isFirstResponder])
    {
        [self.clearBtn setHidden:NO];
        selectedDropdown = 3;
        
        [textField resignFirstResponder];
            
        if (arrayVariant.count>0)
        {
            [self.tableSearch reloadData];
            [self loadPopUpView];
        }
        else
        {
            [self loadingAllVarinats];
        }
    }
}

#pragma mark -
#pragma mark - UITableView Datasource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableTrader) // Table Vehicle Listing
    {
        if (arrayVehicleListing.count > 0)
        {
            return arrayVehicleListing.count;
        }
    }
    else if (tableView == self.tableSearch) // Make and Model and varinats
    {
        float maxHeigthOfView = [self view].frame.size.height/2+50.0;
        float totalFrameOfView = 0.0f;
        
        switch (selectedDropdown)
        {
            case 10:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([arraySortObject count]*43) : 60+([arraySortObject count]*60);
                break;
                
            case 1:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([arrayMake count]*43) : 60+([arrayMake count]*60);
                break;
                
            case 2:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([arrayModel count]*43) : 60+([arrayModel count]*60);
                break;
                
            case 3:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([arrayVariant count]*43) : 60+([arrayVariant count]*60);
                break;
        }
        
        if (totalFrameOfView <= maxHeigthOfView)
        {
            //Make View Size smaller, no scrolling
            self.viewDropdownFrame.frame = CGRectMake(self.viewDropdownFrame.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, self.viewDropdownFrame.frame.size.width, totalFrameOfView);
        }
        else
        {
            self.viewDropdownFrame.frame = CGRectMake(self.viewDropdownFrame.frame.origin.x, maxHeigthOfView/2-22.0, self.viewDropdownFrame.frame.size.width, maxHeigthOfView);
        }

        switch (selectedDropdown)
        {
            case 10:
                return [arraySortObject count];
                break;
                
            case 1:
                return arrayMake.count;
                break;
                
            case 2:
                return arrayModel.count;
                break;
                
            case 3:
                return arrayVariant.count;
                break;
        }
    }
    
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableTrader)
    {
        static NSString     *CellIdentifier = @"Cell";
        
        SMTraderViewTableViewCell  *dynamicCell ;
        
        SMVehiclelisting *objectVehicleListingInCell = (SMVehiclelisting *) [arrayVehicleListing objectAtIndex:indexPath.row];
        
        //CGFloat hh = [tableView rectForRowAtIndexPath:indexPath].size.height;
        
        
        
        UILabel *lblVehicleName;
        UILabel *lblVehicleDetails1;
        UILabel *lblVehicleDetails2;
       
        UILabel *lblMyBidValue;
        UILabel *lblWinBeatValue;
        UIView *rowSeparator;

        UIImageView *imgViewVehicle;
        UIImageView *imgViewBuyNow;
        
         UILabel *lblMinBidPrice;
        
        CGFloat heightName = 0.0f;
        
        NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",objectVehicleListingInCell.strVehicleYear,objectVehicleListingInCell.strVehicleName];
        
         heightName = [self heightForText:strVehicleNameHeight];
        
        CGFloat heightDetails1 = 0.0f;
        
        NSString *mileageStr = [NSString stringWithFormat:@"%@%@",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:objectVehicleListingInCell.strVehicleMileage],objectVehicleListingInCell.strVehicleMileageType];
        
        
        NSString *strDetails1Height = [NSString stringWithFormat:@"%@ | %@",mileageStr,objectVehicleListingInCell.strVehicleColor];
        
        heightDetails1 = [self heightForText:strDetails1Height];
        
        CGFloat heightDetails2 = 0.0f;
        
         NSString *strDetails2Height = [NSString stringWithFormat:@"%@ | %@",objectVehicleListingInCell.strLocation,[NSString stringWithFormat:@"Exp. %@",objectVehicleListingInCell.strVehicleTeadeTimeLeft]];
        
         heightDetails2 = [self heightForText:strDetails2Height];
        
        
        
        if (dynamicCell == nil)
        {
            dynamicCell = [[SMTraderViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                imgViewVehicle = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10.0, 120.0, 110.0)];
                [imgViewVehicle setContentMode:UIViewContentModeScaleAspectFill];
                 imgViewVehicle.clipsToBounds = YES;
                lblMinBidPrice = [[UILabel alloc]initWithFrame:CGRectMake(imgViewVehicle.frame.origin.x, imgViewVehicle.frame.origin.y + imgViewVehicle.frame.size.height + 1.0, 120, 21)];
                imgViewBuyNow = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 38.0, 36.0)];
                
               // NSLog(@"LblVehicleName height  = %f, %ld",heightName,(long)indexPath.row);
                lblVehicleName = [[UILabel alloc] initWithFrame:CGRectMake(132,5,187,heightName)];
                lblVehicleDetails1 = [[UILabel alloc] initWithFrame:CGRectMake(129,lblVehicleName.frame.origin.y + lblVehicleName.frame.size.height + 2.0,187,heightDetails1)];
                lblVehicleDetails2 = [[UILabel alloc] initWithFrame:CGRectMake(132,lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height + 2.0,187,heightDetails2)];
                
                lblMyBidValue = [[UILabel alloc] initWithFrame:CGRectMake(132,lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height + 2.0,187,21)];
                
                lblWinBeatValue = [[UILabel alloc] initWithFrame:CGRectMake(132,lblMyBidValue.frame.origin.y + lblMyBidValue.frame.size.height - 4.0,187,21)];
                
                rowSeparator = [[UIView alloc] initWithFrame:CGRectMake(0,lblWinBeatValue.frame.origin.y + lblWinBeatValue.frame.size.height + 4.0,320,1)];
                
                
                lblVehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
                 lblVehicleDetails1.textColor = [UIColor whiteColor];
                 lblVehicleDetails2.textColor = [UIColor whiteColor];
                lblWinBeatValue.textColor = [UIColor whiteColor];
                //lblMyBidValue.textColor = [UIColor whiteColor];
                rowSeparator.backgroundColor = [UIColor lightGrayColor];
                
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
                lblMinBidPrice = [[UILabel alloc]initWithFrame:CGRectMake(imgViewVehicle.frame.origin.x, imgViewVehicle.frame.origin.y + imgViewVehicle.frame.size.height + 5.0, 350, 25)];

                imgViewBuyNow = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 6.0, 65.0, 65.0)];
                
                lblVehicleName = [[UILabel alloc] initWithFrame:CGRectMake(195,2,570,heightName)];
                lblVehicleDetails1 = [[UILabel alloc] initWithFrame:CGRectMake(187,lblVehicleName.frame.origin.y + lblVehicleName.frame.size.height + 5.0,570,heightDetails1)];
                lblVehicleDetails2 = [[UILabel alloc] initWithFrame:CGRectMake(195,lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height + 5.0,570,heightDetails2)];
                
                lblMyBidValue = [[UILabel alloc] initWithFrame:CGRectMake(195,lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height + 5.0,250,25)];
                lblWinBeatValue = [[UILabel alloc] initWithFrame:CGRectMake(390,lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height + 5.0,250,25)];

                
                lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblMinBidPrice.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblMyBidValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblWinBeatValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];

            }
            lblMinBidPrice.hidden = NO;
            lblVehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
            lblVehicleDetails1.textColor = [UIColor whiteColor];
            lblVehicleDetails2.textColor = [UIColor whiteColor];
            lblWinBeatValue.textColor = [UIColor whiteColor];
            //lblMyBidValue.textColor = [UIColor whiteColor];
            rowSeparator.backgroundColor = [UIColor lightGrayColor];
            
            imgViewVehicle.tag = 101;
            lblVehicleName.tag = 102;
            lblVehicleDetails1.tag = 103;
            lblVehicleDetails2.tag = 104;
            lblMyBidValue.tag = 106;
            lblWinBeatValue.tag = 107;
            imgViewBuyNow.tag = 108;

            
            
            //[lblVehicleName      setText:[NSString stringWithFormat:@"%@ %@",objectVehicleListingInCell.strVehicleYear,objectVehicleListingInCell.strVehicleName]];
            if([objectVehicleListingInCell.strVehicleYear length]>0 && [objectVehicleListingInCell.strVehicleName length] )
            {
                [self setAttributedTextForVehicleDetailsWithFirstText:[NSString stringWithFormat:@"%@ ",objectVehicleListingInCell.strVehicleYear] andWithSecondText:objectVehicleListingInCell.strVehicleName forLabel:lblVehicleName];
            }
            
            objectVehicleListingInCell.strVehicleMileageType = [NSString stringWithFormat:@"%@%@",[[objectVehicleListingInCell.strVehicleMileageType substringToIndex:[objectVehicleListingInCell.strVehicleMileageType length] - (objectVehicleListingInCell.strVehicleMileageType >0)]capitalizedString],[[objectVehicleListingInCell.strVehicleMileageType substringFromIndex:[objectVehicleListingInCell.strVehicleMileageType length] -1] lowercaseString]];
            
            // setting mileage with its type
            
            
            NSString *mileageStr = [NSString stringWithFormat:@"%@%@",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:objectVehicleListingInCell.strVehicleMileage],objectVehicleListingInCell.strVehicleMileageType];
            
            
            if([mileageStr length]>0 && [objectVehicleListingInCell.strVehicleColor length]>0)
            {
                lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@",mileageStr,objectVehicleListingInCell.strVehicleColor];
            }
            else if([mileageStr length] == 0 && [objectVehicleListingInCell.strVehicleColor length] == 0)
            {
            }
            else if([mileageStr length] == 0)
            {
                lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ ",objectVehicleListingInCell.strVehicleColor];
            }
            else if ([objectVehicleListingInCell.strVehicleColor length] == 0)
            {
                lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ ",mileageStr];
            }
           
            //lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@",objectVehicleListingInCell.strLocation,[NSString stringWithFormat:@"Exp. %@",objectVehicleListingInCell.strVehicleTeadeTimeLeft]];
            
           // if([objectVehicleListingInCell.strVehicleTeadeTimeLeft length] == 0)
               // objectVehicleListingInCell.strVehicleTeadeTimeLeft = @"Expiry?";
            
            
            [self setAttributedTextWithFirstText:[NSString stringWithFormat:@"%@ | ",objectVehicleListingInCell.strLocation] andWithSecondText:[NSString stringWithFormat:@"Exp. %@",objectVehicleListingInCell.strVehicleTeadeTimeLeft] andWithFirstColor:[UIColor whiteColor] andWithSecondColor:[UIColor colorWithRed:201.0/255.0 green:24.0/255.0 blue:36.0/255.0 alpha:1.0] withSmallFont:NO forLabel:lblVehicleDetails2];
            
            NSString *strPrice;
            
            int tempMinBidValue = [objectVehicleListingInCell.strMinBid intValue];
            if(tempMinBidValue == 0)
            {
                strPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:objectVehicleListingInCell.strVehicleTradePrice];
            }
            else
            {
                 strPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:objectVehicleListingInCell.strMinBid];
            }
           
            
            //UIColor *color1 = [UIColor whiteColor];
            
            // UIColor *color2 = [UIColor colorWithRed:148.0/255.0 green:109.0/255.0 blue:17.0/255.0 alpha:1.0];
            
            if([objectVehicleListingInCell.strVehicleTradePrice length] == 0 )
            {
                lblMinBidPrice.hidden = NO;
            }
            else
            {
                lblMinBidPrice.hidden = NO;
                
                
                [self setAttributedTextWithFirstText:@"Min Bid: " andWithSecondText:strPrice andWithFirstColor:[UIColor whiteColor] andWithSecondColor:[UIColor colorWithRed:163.0/255.0 green:125.0/255.0 blue:0.0/255.0 alpha:1.0] withSmallFont:YES forLabel:lblMinBidPrice];
            
            }
            
            //objectVehicleListingInCell.strMyHighest = @"50000";
           // objectVehicleListingInCell.strTotalHighest = @"45000000";

            
            // if MyHighestBid is equal to zero then it is N/A
            if (objectVehicleListingInCell.strMyHighest.intValue==0)
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
                NSString *validString = objectVehicleListingInCell.strMyHighest;
                
                validString =  [validString stringByReplacingOccurrencesOfString:@" " withString:@""];

                
                lblMyBidValue.text = [NSString stringWithFormat:@"My Bid: %@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:validString]];
                validString = nil;
                
                 lblMyBidValue.textColor = [UIColor colorWithRed:135.0/255.0 green:67.0/255.0 blue:198.0/255.0 alpha:1.0];
                
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:lblMyBidValue.text];
                NSRange fullRange = NSMakeRange(0, 6);
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:fullRange];
                [lblMyBidValue setAttributedText:string];
            }

            
            // if MyHighestBid is greater than or eqaul to HightestBid then it should be winning or elase it should be beaten
            NSString *validString = objectVehicleListingInCell.strMyHighest;
            
            validString =  [validString stringByReplacingOccurrencesOfString:@" " withString:@""];

            
            if (validString.intValue>=objectVehicleListingInCell.strTotalHighest.intValue)
            {
                [lblWinBeatValue setText:@"Winning"];
                if(lblWinBeatValue.hidden == NO)
                   lblMinBidPrice.hidden = YES;
                
                [lblWinBeatValue setTextColor:[UIColor colorWithRed:64.0f/255.0f green:198.0f/255.0f blue:42.0f/255.0f alpha:1.0f]];
            }
            else
            {
                 lblMinBidPrice.hidden = NO;
                [lblWinBeatValue setText:@"Beaten"];
                [lblWinBeatValue setTextColor:[UIColor colorWithRed:212.0f/255.0f green:46.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
            }

            // making thumb image big by replacing
            
            if ([objectVehicleListingInCell.arrayVehicleImages count]>0)
            {
                objectVehicleListingInCell.strVehicleImageURL = [NSString stringWithFormat:@"%@%@",[[objectVehicleListingInCell.arrayVehicleImages objectAtIndex:0]  substringToIndex:[[objectVehicleListingInCell.arrayVehicleImages objectAtIndex:0] length] -3],@"200"];
            }
            
            
            [imgViewVehicle setImageWithURL:[NSURL URLWithString:objectVehicleListingInCell.strVehicleImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
            
            // showing BuyItNow Banner image if vehcile is having buyItNow
            
            objectVehicleListingInCell.isBuyItNow == YES ?[imgViewBuyNow setHidden:NO]:[imgViewBuyNow setHidden:YES];
            
            
            imgViewBuyNow.image = [UIImage imageNamed:@"buynow"];
            
            [dynamicCell.contentView addSubview:imgViewVehicle];
            
            [dynamicCell.contentView addSubview:lblVehicleName];
            [dynamicCell.contentView addSubview:lblVehicleDetails1];
            [dynamicCell.contentView addSubview:lblVehicleDetails2];
            [dynamicCell.contentView addSubview:lblMinBidPrice];
            [dynamicCell.contentView addSubview:lblMyBidValue];
            [dynamicCell.contentView addSubview:lblWinBeatValue];
            [dynamicCell.contentView addSubview:imgViewBuyNow];
           // [dynamicCell.contentView addSubview:rowSeparator];
            
           

        }
        
        
        lblVehicleName.numberOfLines = 0;
        [lblVehicleName sizeToFit];
        
        lblVehicleDetails1.numberOfLines = 0;
        [lblVehicleDetails1 sizeToFit];
        
        
        lblVehicleDetails2.numberOfLines = 0;
        //[lblVehicleDetails2 sizeToFit];
        
        
        
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

        
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if (arrayVehicleListing.count-1 == indexPath.row)
        {
            if (arrayVehicleListing.count != paginationEndCount.intValue)
            {
                startIndex++;
                [HUD show:YES];
                [HUD setLabelText:KLoaderText];
                [self loadingAllSearchedVehicle:sortingText];
            }
        }

        
        
        
    return dynamicCell;
  // ******************************************************************************************
        
    }
    else if (tableView == self.tableSearch)
    {
        static NSString     *CellIdentifier = @"Cell";
        static NSString     *CellIdentifier1 = @"SMTraderSearchSortByCell";
        
        switch (selectedDropdown)
        {
           /* case 1:
            {
                SMSearchTraderTableViewCell  *cell = (SMSearchTraderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                cell.backgroundColor = [UIColor clearColor];
                
                SMLoadVehiclesObject *objectCellForRow;
                
                objectCellForRow = (SMLoadVehiclesObject *)[arrayMake objectAtIndex:indexPath.row];
                [cell.labelSearchResultName setText:objectCellForRow.strDropDownValue];
                
                cell.layoutMargins = UIEdgeInsetsZero;
                cell.preservesSuperviewLayoutMargins = NO;

                return cell;
            }
                break;*/
                
            case 2:
            {
                SMSearchTraderTableViewCell  *cell = (SMSearchTraderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                cell.backgroundColor = [UIColor clearColor];
                
                SMDropDownObject *objectCellForRow;
                
                objectCellForRow = (SMDropDownObject *)[arrayModel objectAtIndex:indexPath.row];
                [cell.labelSearchResultName setText:objectCellForRow.strDropDownValue];
                
                cell.layoutMargins = UIEdgeInsetsZero;
                cell.preservesSuperviewLayoutMargins = NO;

                return cell;
            }
                break;
                
            case 3:
            {
                SMSearchTraderTableViewCell  *cell = (SMSearchTraderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                cell.backgroundColor = [UIColor clearColor];
                
                SMDropDownObject *objectCellForRow;
                
                objectCellForRow = (SMDropDownObject *)[arrayVariant objectAtIndex:indexPath.row];
                [cell.labelSearchResultName setText:objectCellForRow.strDropDownValue];
                
                cell.layoutMargins = UIEdgeInsetsZero;
                cell.preservesSuperviewLayoutMargins = NO;

                return cell;
            }
                break;
                
            default:
            {
                SMDropDownObject *objectCellForRow;
                
                SMTraderSearchSortByCell *cell1 = (SMTraderSearchSortByCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
                
                if(selectedRow == indexPath.row)
                {
                    cell1.imgAscDesc.hidden = NO;
                }
                else
                {
                    cell1.imgAscDesc.hidden = YES;
                }
                
                if(isTheAttemtFirst)
                {
                    isTheAttemtFirst = NO;
                    cell1.imgAscDesc.hidden = NO;
                }
                
                objectCellForRow = (SMDropDownObject *)[arraySortObject objectAtIndex:indexPath.row];
                [cell1.lblSortText setText:objectCellForRow.strSortText];
                
                return cell1;
            }
                break;
        }
    }
    return 0;
}

#pragma mark -
#pragma mark - UITableView Delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableTrader)
    {
        [buttonHeaderFilter setTag:section];
        return self.viewHeader;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableTrader)
    {
        if([buttonHeaderFilter isSelected])
        {
            CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
            UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
            [imageView setImage:rotatedImage];
            imgViewArrow1.hidden = NO;
            imgViewArrow2.hidden = NO;
            imgViewArrow3.hidden = NO;
            self.lblDefaultYear.hidden = NO;
            self.lblDefaultTo.hidden = NO;
            self.lblDefaultMake.hidden = NO;
            self.txtMake.hidden = NO;
            self.txtYearFrom.hidden = NO;
            self.txtYearTo.hidden = NO;
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                [self.viewVehicleFound setFrame:CGRectMake(0, 510, 320, 76)];
                return (isSearch==YES) ? 510 : 450.0f;//Change by Dr. Ankit
            }
            else
                [self.viewVehicleFound setFrame:CGRectMake(0, 567, 768, 40)];
            return (isSearch==YES) ? 515.0f : 515.0f;

        }
        else
        {
            CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
            
            UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
            [imageView setImage:rotatedImage];
            
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                [self.viewVehicleFound setFrame:CGRectMake(0, 40, 320, 76)];
                 [lblVehicleCountSeparator setFrame:CGRectMake(0, self.lblVehicleFound.frame.origin.y+self.lblVehicleFound.frame.size.height ,lblVehicleCountSeparator.frame.size.width,lblVehicleCountSeparator.frame.size.height)];
                 if(isSearch)
                 {
                     imgViewArrow1.hidden = YES;
                     imgViewArrow2.hidden = YES;
                     imgViewArrow3.hidden = YES;
                     self.lblDefaultYear.hidden = YES;
                     self.lblDefaultTo.hidden = YES;
                     self.lblDefaultMake.hidden = YES;
                     self.txtMake.hidden = YES;
                     self.txtYearFrom.hidden = YES;
                     self.txtYearTo.hidden = YES;
                     
                     return 116.0f;
                 
                 }
                else
                {
                    imgViewArrow1.hidden = NO;
                    imgViewArrow2.hidden = NO;
                    imgViewArrow3.hidden = NO;
                    self.lblDefaultYear.hidden = NO;
                    self.lblDefaultTo.hidden = NO;
                    self.lblDefaultMake.hidden = NO;
                    self.txtMake.hidden = NO;
                    self.txtYearFrom.hidden = NO;
                    self.txtYearTo.hidden = NO;
                    
                    return 40.0f;
                }
            }
            else
            {
                [self.viewVehicleFound setFrame:CGRectMake(0, 52, 752, 80)];
                [lblVehicleCountSeparator setFrame:CGRectMake(0, self.lblVehicleFound.frame.origin.y+self.lblVehicleFound.frame.size.height ,lblVehicleCountSeparator.frame.size.width,lblVehicleCountSeparator.frame.size.height)];
                
                if(isSearch)
                {
                    imgViewArrow1.hidden = YES;
                    imgViewArrow2.hidden = YES;
                    imgViewArrow3.hidden = YES;
                    imgViewSelectMakeDownArrow.hidden = YES;
                    self.lblDefaultYear.hidden = YES;
                    self.lblDefaultTo.hidden = YES;
                    self.lblDefaultMake.hidden = YES;
                    self.txtMake.hidden = YES;
                    self.txtYearFrom.hidden = YES;
                    self.txtYearTo.hidden = YES;
                    
                    return 130.0f;
                    
                }
                else
                {
                    imgViewArrow1.hidden = NO;
                    imgViewArrow2.hidden = NO;
                    imgViewArrow3.hidden = NO;
                    imgViewSelectMakeDownArrow.hidden = NO;
                    self.lblDefaultYear.hidden = NO;
                    self.lblDefaultTo.hidden = NO;
                    self.lblDefaultMake.hidden = NO;
                    self.txtMake.hidden = NO;
                    self.txtYearFrom.hidden = NO;
                    self.txtYearTo.hidden = NO;
                    
                    return 50.0f;
                }

            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.tableTrader)
    {
     CGFloat finalDynamicHeight = 0.0f;
    
    SMVehiclelisting *objectVehicleListingInCell = (SMVehiclelisting *) [arrayVehicleListing objectAtIndex:indexPath.row];

    
    CGFloat heightName = 0.0f;
    
    NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",objectVehicleListingInCell.strVehicleYear,objectVehicleListingInCell.strVehicleName];
    
    heightName = [self heightForText:strVehicleNameHeight];
        
       // NSLog(@"Name height = %f",heightName);
    
    CGFloat heightDetails1 = 0.0f;
    
    NSString *mileageStr = [NSString stringWithFormat:@"%@%@",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:objectVehicleListingInCell.strVehicleMileage],objectVehicleListingInCell.strVehicleMileageType];
    
    
    NSString *strDetails1Height = [NSString stringWithFormat:@"%@ | %@",mileageStr,objectVehicleListingInCell.strVehicleColor];
    
    heightDetails1 = [self heightForText:strDetails1Height];
    
        CGFloat heightDetails2 = 0.0f;
        
        NSString *strDetails2Height = [NSString stringWithFormat:@"%@ | %@",objectVehicleListingInCell.strLocation,[NSString stringWithFormat:@"Exp. %@",objectVehicleListingInCell.strVehicleTeadeTimeLeft]];
        
        heightDetails2 = [self heightForText:strDetails2Height];
    
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
           // finalDynamicHeight = (110.0+ 21.0); // 110 is height of the image
            if(isLabelWinBeatValueHidden)
            finalDynamicHeight = heightName + heightDetails1 + heightDetails2 + 21.0+19.0;
            else
               finalDynamicHeight = heightName + heightDetails1 + heightDetails2 + 21.0+21.0;
            
        }
        else
           finalDynamicHeight = (110.0+ 45.0); // 110 is height of the image

        if(finalDynamicHeight+25 < 135)
            finalDynamicHeight = 115;
        
        if((int)finalDynamicHeight == 137)
            return finalDynamicHeight + 5.0;
        else
            return finalDynamicHeight+29;

    }
    else
        return 44.0;

}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableSearch)
    {
        SMDropDownObject *objectDidSelectForRow;
        switch (selectedDropdown)
        {
           /* case 1:
            {
                objectDidSelectForRow = (SMDropDownObject *)[arrayMake objectAtIndex:indexPath.row];

                [self.txtMake setText:objectDidSelectForRow.strDropDownValue];
                selectedMakeId = (int)objectDidSelectForRow.dropDownID.integerValue;
                if (selectedMakeIndex!=indexPath.row)
                {
                    selectedMakeIndex = (int)indexPath.row;
                    selectedModelIndex      = -1;
                    selectedVariantsIndex   = -1;
                    
                    [self.txtModel setText:@""];
                    [self.txtVariants setText:@""];
                    
                    [self.txtModel         setUserInteractionEnabled:YES];
                    [self.txtVariants      setUserInteractionEnabled:NO];

                    [arrayModel removeAllObjects];
                    [arrayVariant removeAllObjects];
                }
                [self hidePopUpView];
            }
                break;*/
                
            case 2:
            {
                objectDidSelectForRow = (SMDropDownObject *)[arrayModel objectAtIndex:indexPath.row];

                [self.txtModel setText:objectDidSelectForRow.strDropDownValue];
                selectedModelId = objectDidSelectForRow.dropDownID.intValue;
                if (selectedModelIndex != indexPath.row)
                {
                    selectedModelIndex      = (int)indexPath.row;
                    self.txtVariants.text   = @"";
                    
                    [self.txtVariants   setUserInteractionEnabled:YES];
                    [arrayVariant removeAllObjects];
                }
                [self hidePopUpView];
            }
                break;
                
            case 3:
            {
                objectDidSelectForRow = (SMDropDownObject *)[arrayVariant objectAtIndex:indexPath.row];

                [self.txtVariants     setText:objectDidSelectForRow.strDropDownValue];
                selectedVariantId     = objectDidSelectForRow.dropDownID.intValue;
                [self hidePopUpView];
            }
                break;
                
            case 10:
            {
                objectDidSelectForRow = (SMDropDownObject *)[arraySortObject objectAtIndex:indexPath.row];
                
                //Start for :- changed By Jignesh K on 13 march for adding ascending sorting oprtion by default as per client feedback
                
                if (selectedRow == 0)
                {
                    objectDidSelectForRow.isAscending = YES;

                }
                else if (selectedRow == indexPath.row)
                {
                    objectDidSelectForRow.isAscending = !objectDidSelectForRow.isAscending;
                }
                else
                {
                    objectDidSelectForRow.isAscending = YES;
                    
                }
                selectedRow = (int)indexPath.row;
                
                // END for -: changed By Jignesh K on 13 march for adding ascending sorting oprtion by default as per client feedback
                
                
                SMTraderSearchSortByCell *selectedCell = (SMTraderSearchSortByCell*)[self.tableSearch cellForRowAtIndexPath:indexPath];
                
                SMDropDownObject *objectCellForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
                
                if(objectCellForRow.isAscending)
                {
                    selectedCell.imgAscDesc.transform = CGAffineTransformMakeRotation(M_PI);
                    if (selectedRow == 0)
                    {
                    
                        [self.txtFieldSortBy setText:[NSString stringWithFormat:@"%@",objectDidSelectForRow.strSortText]];
                    }
                    else
                    {
                        [self.txtFieldSortBy setText:[NSString stringWithFormat:@"%@ (Ascending)",objectDidSelectForRow.strSortText]];
                    }
                    
                }
                else
                {
                    selectedCell.imgAscDesc.transform = CGAffineTransformMakeRotation(0);
                 
                    
                    [self.txtFieldSortBy setText:[NSString stringWithFormat:@"%@ (Descending)",objectDidSelectForRow.strSortText]];
                }

                int sortOrder;

                if(objectDidSelectForRow.isAscending)
                    sortOrder = 1;
                else
                    sortOrder = 2;
               
                sortingText = [self sortOptionSelectedWithSortIndex:(int)indexPath.row andSortOrder:sortOrder];
                
                [HUD show:YES];
                [HUD setLabelText:KLoaderText];
                [self loadingAllSearchedVehicle:sortingText];
                
                [self.tableTrader reloadData];
                [self hidePopUpView];
            }
                break;

            default:
                break;
        }
        
    }
    else if (tableView == self.tableTrader)
    {
        __block SMTraderBuyViewController *traderBuy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            traderBuy = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
            [[SMTraderBuyViewController alloc] initWithNibName:@"SMTraderBuyViewController" bundle:nil] :
            [[SMTraderBuyViewController alloc] initWithNibName:@"SMTraderBuyViewController_iPad" bundle:nil];
            
            SMVehiclelisting *objectVehicleListingInDidCell = (SMVehiclelisting *) [arrayVehicleListing objectAtIndex:indexPath.row];
            
            traderBuy.vehicleObj = objectVehicleListingInDidCell;
            
            traderBuy.strSelectedVehicleId = objectVehicleListingInDidCell.strVehicleID;
            
            traderBuy.vehicleListDelegates = self;
            traderBuy.isLabelMinBidHide = NO;

            
            [self.navigationController pushViewController:traderBuy animated:YES];
        });
    }
}

#pragma mark -
#pragma mark - Web service calling for loading all makes

-(void)loadingAllMakeListing
{
    refreshClassFilterData = [[SMRefreshFilterData alloc]init];
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices getMakeWithUserHash:[SMGlobalClass sharedInstance].hashValue withFromYear:[self.txtYearFrom.text intValue] withToYear:[self.txtYearTo.text intValue]];
    
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
             arrayMake       = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

// this will load all model values based on selected make

-(void)loadingAllModelValues
{
    refreshClassFilterData    = [[SMRefreshFilterData alloc]init];
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices getModelWithUserHash:[SMGlobalClass sharedInstance].hashValue withMakeID:selectedMakeId withFromYear:[self.txtYearFrom.text intValue] withToYear:[self.txtYearTo.text intValue]];
    
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
             arrayModel     = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

// this will load all varinats based on make and model

-(void)loadingAllVarinats
{
    refreshClassFilterData = [[SMRefreshFilterData alloc]init];
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices getVariantWithUserHash:[SMGlobalClass sharedInstance].hashValue withModelID:selectedModelId withFromYear:[self.txtYearFrom.text intValue] withToYear:[self.txtYearTo.text intValue]];
    
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
             arrayVariant     = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

// This will load all search vehicle

-(void)loadingAllSearchedVehicle:(NSString*)sortString
{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingSearchListingVehicle:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withMinYear:selectedFromYear.intValue withMaxYear:selectedToYear.intValue  withMakeId:selectedMakeId withModelID:selectedModelId withVariant:selectedVariantId withCount:Page_S withPage:startIndex withIsTrade:checkBoxTrade.isSelected isTender:checkBoxTenders.isSelected isPrivate:checkBoxPrivate.isSelected isFactory:checkBoxFactory.isSelected andSortText:sortString];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
             [self hideProgressHUD];
             return;
         }
         
         xmlParser = [[NSXMLParser alloc] initWithData:data];
         [xmlParser setDelegate: self];
         [xmlParser setShouldResolveExternalEntities:YES];
         selectedDropdown = 5;
         isPaginationCompleted = NO;
         [xmlParser parse];
     }];
}

#pragma mark -
#pragma mark - Custom Button Actions

// This will call after user pressed search button
-(IBAction)buttonSearchDidClicked:(id)sender
{
    isSearch = YES;
    
//    if (selectedFromYear.intValue > selectedToYear.intValue)
//    {
//        [self showAlert:@"Please select your year properly"];
//        return;
//    }
    if( self.txtYearFrom.text.intValue > self.txtYearTo.text.intValue)
    {
                [self showAlert:@"Please select a valid year range"];
                return;
    }
    // loading all vehicle listing data
    [arrayVehicleListing removeAllObjects];
    startIndex           = 0;
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    //NSLog(@"thisaa 1");
    [self loadingAllSearchedVehicle:sortingText];
}

-(IBAction)buttonFilterDidPressed:(id)sender
{
   /* if (buttonHeaderFilter.isSelected)
    {
        [self.labelNoSearchResult setHidden:YES];
    }
    else
    {
        if (self.labelNoSearchResult.hidden==YES)
        {
            [self.labelNoSearchResult setHidden:YES];
        }
        else
        {
            [self.labelNoSearchResult setHidden:NO];
            
            [self showAlert:KNorecordsFousnt];
        }
    }*/
    
    if(!buttonHeaderFilter.selected)
    {
        if (UI_USER_INTERFACE_IDIOM()!=UIUserInterfaceIdiomPhone)
        {
            //[buttonHeaderFilter setContentEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        }
    }
    else
    {
        //[buttonHeaderFilter setContentEdgeInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)];
        
    }
    
    [buttonHeaderFilter setSelected:!buttonHeaderFilter.selected];
    
    buttonHeaderFilter.selected == YES ? ([self.imgDownArrowYearFrom setHidden:NO]) : (self.imgDownArrowYearFrom.hidden = YES);
    
    

    [self.tableTrader reloadData];
}

-(IBAction)buttonCancelDidPressed:(id)sender
{
    [self hidePopUpView];
}
- (IBAction)clearBtnClicked:(id)sender
{
    switch (selectedDropdown)
    {
        case 1:
            selectedMakeId = -1;
            selectedModelId = -1;
            selectedVariantId = -1;
            [self.txtMake setText:@""];
            [self.txtModel setText:@""];
            [self.txtVariants setText:@""];
            
            [self.txtModel setUserInteractionEnabled:NO];
            [self.txtVariants setUserInteractionEnabled:NO];
        
            [arrayModel removeAllObjects];
            [arrayVariant removeAllObjects];
            
            break;
            
        case 2:
            selectedModelId = -1;
            selectedVariantId = -1;
            
            [self.txtModel setText:@""];
            [self.txtVariants setText:@""];
            
            [self.txtVariants setUserInteractionEnabled:NO];
            
            [arrayVariant removeAllObjects];

            break;
            
        case 3:
            selectedVariantId = -1;
            [self.txtVariants setText:@""];
            break;
    }
    
    
    [self hidePopUpView];
}

-(IBAction)buttonCancelDatePicker:(id)sender
{
    [self hidePopUpViewForYears];
}

-(IBAction)buttonSetFromDate:(id)sender
{
    if (self.txtYearFrom.tag == 1)
    {
        selectedFromYear = [arrayYears objectAtIndex:selectedRowFromYear];
        [self.txtYearFrom   setText:selectedFromYear];
        self.txtYearFrom.tag = 0;
    }
    else if(self.txtYearTo.tag == 2)
    {
        selectedToYear = [arrayYears objectAtIndex:selectedRowToYear];
        [self.txtYearTo     setText:selectedToYear];
        self.txtYearTo.tag= 0;
    }
    
    [self.txtMake setText:@""];
    [self.txtModel setText:@""];
    [self.txtVariants setText:@""];
    
    //[self.txtModel      setUserInteractionEnabled:NO];
   // [self.txtVariants   setUserInteractionEnabled:NO];

    [arrayMake removeAllObjects];
    [arrayModel removeAllObjects];
    [arrayVariant removeAllObjects];
    
    selectedMakeId = -1;
    selectedModelId = -1;
    selectedVariantId = -1;
    
    [self hidePopUpViewForYears];
}

- (IBAction)btnClearDidClicked:(id)sender
{
    selectedMakeId = -1;
    selectedModelId = -1;
    selectedVariantId = -1;
    selectedFromYear = @"2006";
    selectedRowFromYear = 16;
    selectedRowToYear = arrayYears.count-1;
    selectedToYear = [NSString stringWithFormat:@"%d",currentYear];
    [self.txtModel      setText:@""];
    [self.txtMake       setText:@""];
    [self.txtVariants   setText:@""];
    [self.txtYearFrom   setText:selectedFromYear];
    [self.txtYearTo     setText:selectedToYear];
    
   // [self.txtModel      setUserInteractionEnabled:NO];
   // [self.txtVariants   setUserInteractionEnabled:NO];
    
    checkBoxAll.selected = NO;
    checkBoxFactory.selected = NO;
    checkBoxPrivate.selected = NO;
    checkBoxTenders.selected = NO;
    checkBoxTrade.selected = NO;
    
}

#pragma mark -
#pragma mark - User Define Functions

-(void)registerNib
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.tableTrader registerNib:[UINib nibWithNibName:@"SMTraderViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        
        [self.tableSearch registerNib:[UINib nibWithNibName:@"SMSearchTraderTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        
        [self.tableSearch registerNib:[UINib nibWithNibName:@"SMTraderSearchSortByCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMTraderSearchSortByCell"];
    }
    else
    {
        [self.tableTrader registerNib:[UINib nibWithNibName:@"SMTraderViewTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"Cell"];
        
        [self.tableSearch registerNib:[UINib nibWithNibName:@"SMSearchTraderTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"Cell"];
        
        [self.tableSearch registerNib:[UINib nibWithNibName:@"SMTraderSearchSortByCell_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMTraderSearchSortByCell"];
    }

    [self.tableTrader setBackgroundColor:[UIColor clearColor]];
}

#pragma mark -
#pragma mark - XML Parsing Delegates

// once all fetching is done xml parsing will called

-(void) parser:(NSXMLParser *)    parser
didStartElement:(NSString *)   elementName
  namespaceURI:(NSString *)      namespaceURI
 qualifiedName:(NSString *)     qName
    attributes:(NSDictionary *)    attributeDict
{
    
    if ([elementName isEqualToString:@"model"] || [elementName isEqualToString:@"Variant"])
    {
        objectDropDown  = [[SMDropDownObject alloc] init];
    }
    if ([elementName isEqualToString:@"Make"])
    {
        objectForMakes  = [[SMLoadVehiclesObject alloc] init];
    }
    
    if ([elementName isEqualToString:@"Vehicle"])
    {
        objectVehicleListing  = [[SMVehiclelisting alloc] init];
    }
        currentNodeContent = [NSMutableString stringWithString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([string isEqualToString:@"0"])
    {
        return;
    }
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *string = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    
    if ([string isEqualToString:@"0"])
    {
        return;
    }
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    // make model and variants
    if([elementName isEqualToString:@"id"] || [elementName isEqualToString:@"ID"])
    {
        objectDropDown.dropDownID = currentNodeContent;
        objectForMakes.strMakeId = currentNodeContent;
    }
    if ([elementName isEqualToString:@"name"] || [elementName isEqualToString:@"Name"])
    {
        objectDropDown.strDropDownValue = currentNodeContent;
        objectForMakes.strMakeName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"AutobidCap"])
    {
        objectVehicleListing.intAutobidCap = [currentNodeContent intValue];
    }
    //Search Listing for vehicle
    if ([elementName isEqualToString:@"Year"])
    {
        if([currentNodeContent length] == 0)
        {
            objectVehicleListing.strVehicleYear = @"Year?";
        }
        else
        {
            objectVehicleListing.strVehicleYear = currentNodeContent;
        }
    }
    if ([elementName isEqualToString:@"FriendlyName"])
    {
        objectVehicleListing.strVehicleName = currentNodeContent;
       
    }
    if ([elementName isEqualToString:@"MileageType"])
    {
        if ([currentNodeContent isEqualToString:@""])
        {
            objectVehicleListing.strVehicleMileageType = @"Km";
        }
        else
        {
            objectVehicleListing.strVehicleMileageType = currentNodeContent;
        }
    }
    if ([elementName isEqualToString:@"Age"])
    {
        objectVehicleListing.strVehicleAge = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
        if ([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"0"])
        {
            objectVehicleListing.strVehicleMileage = @"Mileage?";
        }
        else
        {
            objectVehicleListing.strVehicleMileage = currentNodeContent;
           
        }
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        if ([currentNodeContent isEqualToString:@""] || [currentNodeContent isEqualToString:@"No colour #"])
        {
            objectVehicleListing.strVehicleColor = @"Colour?";
        }
        else
        {
            objectVehicleListing.strVehicleColor = currentNodeContent;
           
        }
    }
    if ([elementName isEqualToString:@"Location"])
    {
        if (currentNodeContent.length == 0)
        {
            objectVehicleListing.strLocation = @"Suburb/City";
        }
        else
            objectVehicleListing.strLocation = currentNodeContent;
        

    }
    if ([elementName isEqualToString:@"TradePrice"])
    {
        if([currentNodeContent length] == 0)
        {
            objectVehicleListing.strVehicleTradePrice = @"Price?";
        }
        else
        {
            objectVehicleListing.strVehicleTradePrice = currentNodeContent;
        }
    }
    if ([elementName isEqualToString:@"BuyNow"])
    {
        if ([currentNodeContent intValue] == 0)
        {
            objectVehicleListing.isBuyItNow = NO;
        }
        else
        {
            objectVehicleListing.isBuyItNow = YES;
        }
    }
    if ([elementName isEqualToString:@"HightestBid"])
    {
        objectVehicleListing.strVehicleCurrentBid  = currentNodeContent;
        objectVehicleListing.strTotalHighest = currentNodeContent;
        
        // if highest bid is greater than the trade price then we need to populate trade price as hignest bid
        if (objectVehicleListing.strVehicleCurrentBid.intValue >objectVehicleListing.strVehicleTradePrice.intValue)
        {
            objectVehicleListing.strVehicleTradePrice = objectVehicleListing.strVehicleCurrentBid;
        }

    }
    if ([elementName isEqualToString:@"MinBid"])
    {
        
        objectVehicleListing.strVehicleTradePrice = currentNodeContent;
         minBidValue = currentNodeContent.intValue;
    }
    if ([elementName isEqualToString:@"MyHighestBid"])
    {
        objectVehicleListing.strMyHighest = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TimeLeft"])
    {
       /* NSLog(@"TimeLefttt = %@",currentNodeContent);
        if([currentNodeContent length] == 0)
            objectVehicleListing.strVehicleTeadeTimeLeft = @"Expiry?";
        else
        {
            
            NSArray *arrayWithTwoStrings = [currentNodeContent componentsSeparatedByString:@"."];
            NSArray *hoursmint = [[arrayWithTwoStrings objectAtIndex:0]componentsSeparatedByString:@":"];
            NSLog(@"hoursmint = %lu",(unsigned long)hoursmint.count);
            if (hoursmint.count>1)
            {
                objectVehicleListing.strVehicleTeadeTimeLeft = [NSString stringWithFormat:@"%@h %@m",[hoursmint objectAtIndex:0],[hoursmint objectAtIndex:1]];
            }
            else
            {
                objectVehicleListing.strVehicleTeadeTimeLeft = @"?";
            }
        }*/
    }
    if ([elementName isEqualToString:@"Expires"])
    {
          if([currentNodeContent length] !=0)
          {
              objectVehicleListing.strVehicleTeadeTimeLeft = [currentNodeContent substringToIndex:11];
          }
          else
          {
               objectVehicleListing.strVehicleTeadeTimeLeft = @"Expiry?";
          }
    }
    
    if ([elementName isEqualToString:@"ID"])
    {
        objectVehicleListing.strVehicleID =  currentNodeContent;
    }
    if ([elementName isEqualToString:@"Thumb"])
    {
        objectVehicleListing.strVehicleImageURL = currentNodeContent;
        [objectVehicleListing.arrayVehicleImages addObject:objectVehicleListing.strVehicleImageURL];
    }
    
    
    if ([elementName isEqualToString:@"Make"])
    {
        [arrayMake addObject:objectForMakes];
    }
    if ([elementName isEqualToString:@"model"])
    {
        [arrayModel addObject:objectDropDown];
    }
    if ([elementName isEqualToString:@"Variant"])
    {
        [arrayVariant addObject:objectDropDown];
    }
    if ([elementName isEqualToString:@"ListMakesXMLResult"])
    {
        [self.tableSearch reloadData];
        if(arrayMake.count > 0)
        {
            searchMakeVC = [arrLoadNib objectAtIndex:0];
            [searchMakeVC getTheDropDownData:arrayMake];
            [self.view addSubview:searchMakeVC];
            [SMReusableSearchTableViewController getTheSelectedSearchDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                
                [self.txtMake setText:selectedTextValue];
                selectedMakeId = selectIDValue;
                
                [self.txtModel setText:@""];
                [self.txtVariants setText:@""];
                
                [self.txtModel         setUserInteractionEnabled:YES];
                [self.txtVariants      setUserInteractionEnabled:NO];
                
                [arrayModel removeAllObjects];
                [arrayVariant removeAllObjects];

                
                
            }];

            [self hideProgressHUD];
        }
    }
    if ([elementName isEqualToString:@"ListModelsXMLResult"])
    {
        [self.tableSearch reloadData];
        arrayModel.count>0 ? [self loadPopUpView] : [self showAlert:@"No record(s) found."];
    }
    if ([elementName isEqualToString:@"ListVariantsXMLResult"])
    {
        [self.tableSearch reloadData];
        arrayVariant.count>0 ? [self loadPopUpView] : [self showAlert:@"No record(s) found."];
    }
    
    if ([elementName isEqualToString:@"Vehicle"])
    {
        if (selectedDropdown == 5)
        {
            [arrayVehicleListing addObject:objectVehicleListing];
        }
    }

    if ([elementName isEqualToString:@"Total"]) // It will give you total count that will need to check once pagination over
    {
        paginationEndCount = currentNodeContent;
        
        [self.lblVehicleFound setText:[NSString stringWithFormat:@"Vehicles Found: %d",[currentNodeContent intValue]]];
        
        if([currentNodeContent isEqualToString:@"0"])
        {
            //[self.labelNoSearchResult setHidden:NO];
            [self showAlert:KNorecordsFousnt];
            [self.tableTrader setUserInteractionEnabled:YES];
        }
        
    }
    
    if ([elementName isEqualToString:@"SearchResponse"])
    {
        if (selectedDropdown == 5)
        {
            if (arrayVehicleListing.count == 0)
            {
               // [self.labelNoSearchResult setHidden:NO];
                [self showAlert:KNorecordsFousnt];
                [self.tableTrader setUserInteractionEnabled:YES];
                
            }
            else if (arrayVehicleListing.count == paginationEndCount.intValue) // here pagination will
            {
               // [self.labelNoSearchResult setHidden:YES];
                [self.tableTrader setUserInteractionEnabled:YES];

            }
            else
            {
               // [self.labelNoSearchResult setHidden:YES];
                [self.tableTrader setUserInteractionEnabled:YES];

            }
            [buttonHeaderFilter setTitle:@"Show Search" forState:UIControlStateNormal];
            self.navigationItem.titleView = [SMCustomColor setTitle:@"Search Trade"];
            if (UI_USER_INTERFACE_IDIOM()!=UIUserInterfaceIdiomPhone)
            {
                //[buttonHeaderFilter setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -610.0, 0.0, 0.0)];
                //[buttonHeaderFilter setContentEdgeInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 0.0)];
            }
            
            [buttonHeaderFilter setSelected:NO];
            self.imgDownArrowYearFrom.hidden = YES;
            [self.tableTrader reloadData];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
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

#pragma mark -
#pragma mark -  UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrayYears count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrayYears objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.txtYearFrom.tag == 1)
    {
        selectedRowFromYear = row;
//        selectedFromYear = [arrayYears objectAtIndex:row];
    }
    else if(self.txtYearTo.tag == 2)
    {
        selectedRowToYear = row;
//        selectedToYear = [arrayYears objectAtIndex:row];
    }
}

#pragma mark -
#pragma mark - Global UIAlertView

-(void) showAlert:(NSString *) strMessage
{
    UIAlertView *alert;
    if (alert == nil)
    {
        alert  = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    [alert setMessage:strMessage];
    [alert show];
}

- (int)lineCountForLabel:(UILabel *)label {
    CGSize constrain = CGSizeMake(label.bounds.size.width, FLT_MAX);
   /* CGSize size = [label.text sizeWithFont:label.font constrainedToSize:constrain lineBreakMode:NSLineBreakByWordWrapping];*/
    label.lineBreakMode = NSLineBreakByWordWrapping;
      CGRect textRect = [label.text boundingRectWithSize:constrain
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:label.font
                                                       }
                                             context:nil];
    
    CGSize size = textRect.size;
    
 return ceil(size.height / label.font.lineHeight);
}

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
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
    
    UIColor *foregroundColorRed = [UIColor colorWithRed:212.0/255.0 green:46.0/255.0 blue:48.0/255.0 alpha:1.0];
    UIColor *foregroundColorGreen = [UIColor colorWithRed:64.0/255.0 green:198.0/255.0 blue:42.0/255.0 alpha:1.0];
    
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorGreen, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorRed, NSForegroundColorAttributeName, nil];
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:firstText
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:secondText
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:thirdText
                                                                                            attributes:ThirdAttribute];
    
    
    
    [attributedSecondText appendAttributedString:attributedThirdText];
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
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:secondText
                                                                                             attributes:SecondAttribute];
    
    
    
    
    
    
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
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        textSize = 187;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
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



#pragma mark -
#pragma mark - Load/Hide Drop Down For Make, Model And Variants

-(void)loadPopUpView
{
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (vc != self)
        return;
    
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
    
    [self.view addSubview:popupView];
    [self.view bringSubviewToFront:popupView];

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

-(void) loadPopUpViewForYears
{
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (vc != self)
        return;
    
    [viewDropDownYears setFrame:[UIScreen mainScreen].bounds];
    [viewDropDownYears setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [viewDropDownYears setAlpha:0.0];
    
    [[[UIApplication sharedApplication]keyWindow]addSubview:viewDropDownYears];
    [viewDropDownYears setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [viewDropDownYears setAlpha:0.75];
         [viewDropDownYears setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [viewDropDownYears setAlpha:1.0];
              [viewDropDownYears setTransform:CGAffineTransformIdentity];
          }
                          completion:^(BOOL finished)
          {
              
          }];
     }];
}

-(void) hidePopUpViewForYears
{
    [viewDropDownYears setAlpha:1.0];
    
    [self.view addSubview:viewDropDownYears];
    [self.view bringSubviewToFront:viewDropDownYears];

    [[[UIApplication sharedApplication]keyWindow]addSubview:viewDropDownYears];
    [UIView animateWithDuration:0.1 animations:^{
        [viewDropDownYears setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [viewDropDownYears setAlpha:0.3];
              [viewDropDownYears setTransform:CGAffineTransformMakeScale(0.9,0.9)];
              
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   [viewDropDownYears setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [viewDropDownYears removeFromSuperview];
                   [viewDropDownYears setTransform:CGAffineTransformIdentity];
               }];
          }];
     }];
}

#pragma mark -
#pragma mark - Custom Delegate Method

// this will refresh vehicle listing
-(void)getRefreshedVehicleListing
{
    // loading all vehicle listing data
    [arrayVehicleListing removeAllObjects];
    startIndex           = 0;
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    [self loadingAllSearchedVehicle:sortingText];
}

- (IBAction)checkBoxAllDidClicked:(id)sender
{
    [checkBoxAll setSelected:!checkBoxAll.selected];
    if(checkBoxAll.isSelected)
    {
        [checkBoxTrade setSelected:YES];
        [checkBoxFactory setSelected:YES];
        [checkBoxTenders setSelected:YES];
        [checkBoxPrivate setSelected:YES];
    }
    else
    {
        [checkBoxTrade setSelected:NO];
        [checkBoxFactory setSelected:NO];
        [checkBoxTenders setSelected:NO];
        [checkBoxPrivate setSelected:NO];
    
    }
}

- (IBAction)checkBoxTradeDidClicked:(id)sender
{
    [checkBoxTrade setSelected:!checkBoxTrade.selected];
    
     if(!checkBoxTrade.isSelected)
         checkBoxAll.selected = NO;
}

- (IBAction)checkBoxFactoryDidClicked:(id)sender
{
    [checkBoxFactory setSelected:!checkBoxFactory.selected];
    
    if(!checkBoxFactory.isSelected)
        checkBoxAll.selected = NO;
}

- (IBAction)checkBoxTenderDidClicked:(id)sender
{
    [checkBoxTenders setSelected:!checkBoxTenders.selected];
    if(!checkBoxTenders.isSelected)
        checkBoxAll.selected = NO;
}

- (IBAction)checkBoxPrivateDidClicked:(id)sender
{
    [checkBoxPrivate setSelected:!checkBoxPrivate.selected];
    if(!checkBoxPrivate.isSelected)
        checkBoxAll.selected = NO;
}

-(void)populateTheSortByArray
{
#warning Sandeep - chamnge text None to --None--
    NSArray *arrayOfSortTypes = [[NSArray alloc]initWithObjects:@"-- None --",@"Mileage",@"Price",@"Time Left",@"Year", nil];
    arraySortObject = [[NSMutableArray alloc]init];
    
    for(int i=0;i<[arrayOfSortTypes count];i++)
    {
        SMDropDownObject *sortObject = [[SMDropDownObject alloc]init];
        sortObject.strSortText = [arrayOfSortTypes objectAtIndex:i];
        sortObject.strSortTextID = i;
        if (i==0)
        {
            sortObject.isAscending = YES;
        }
        else
        {
            sortObject.isAscending = NO;
        }
        [arraySortObject addObject:sortObject];
    }
}

-(NSString*)sortOptionSelectedWithSortIndex:(int)sortIndex andSortOrder:(int)sortOrder
{
    startIndex = 0;
    [arrayVehicleListing removeAllObjects];
    switch (sortIndex)
    {
       
        case 1:
        {
            if(sortOrder == 1)
                return @"mileage:asc";
            else
                return @"mileage:desc";
        }
            break;
            
        case 2:
        {
            if(sortOrder == 1)
                return @"price:asc";
            else
                return @"price:desc";
        }
            break;
            
        case 3:
        {
            if(sortOrder == 1)
                return @"time:asc";
            else
                return @"time:desc";
        }
            break;
            
        case 4:
        {
            if(sortOrder == 1)
                return @"year:asc";
            else
                return @"year:desc";
        }
            break;
            
        default:
            break;
    }
    return @"";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    
    [self hideProgressHUD];
    [popupView removeFromSuperview];
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

