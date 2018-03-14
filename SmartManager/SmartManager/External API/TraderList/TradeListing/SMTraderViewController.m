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

const int Page_S = 10;
const int initiallyStartYear = 16; // initially Start Year as 2006 and 2006 is at 16 index

@interface SMTraderViewController ()

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
    
    sortingText = @"age:asc";
    
    [self addingProgressHUD];
    
    [self registerNib];
    
    // used for setting Navigation Title
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Buy"];
    
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

    [self.labelNoSearchResult setHidden:YES];
    
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
        [self.clearBtn setHidden:YES];
        [self.txtYearFrom setTag:1];
        [self.txtYearFrom resignFirstResponder];
        [yearPicker selectRow:selectedRowFromYear inComponent:0 animated:YES];
        [self loadPopUpViewForYears];
    }
    else if ([self.txtYearTo isFirstResponder])
    {
        [self.clearBtn setHidden:YES];
        [self.txtYearTo setTag:2];
        [self.txtYearTo setText:selectedToYear];
        [self.txtYearTo resignFirstResponder];
        [yearPicker selectRow:selectedRowToYear inComponent:0 animated:YES];
        [self loadPopUpViewForYears];
    }
    else if([self.txtMake isFirstResponder])
    {
        [self.clearBtn setHidden:NO];
        selectedDropdown = 1;
        [textField resignFirstResponder];
        
        if (arrayMake.count>0)
        {
            [self.tableSearch reloadData];
            [self loadPopUpView];
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
        
        SMTraderViewTableViewCell  *cell = (SMTraderViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        SMVehiclelisting *objectVehicleListingInCell = (SMVehiclelisting *) [arrayVehicleListing objectAtIndex:indexPath.row];
        
        [cell.labelVehicleName      setText:[NSString stringWithFormat:@"%@ %@",objectVehicleListingInCell.strVehicleYear,objectVehicleListingInCell.strVehicleName]];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cell.labelVehicleName.text];
        NSRange fullRange = NSMakeRange(0, 4);
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:fullRange];
        [cell.labelVehicleName setAttributedText:string];
        
        [cell.labelVehicleCost setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:objectVehicleListingInCell.strVehicleTradePrice]];

        // if MyHighestBid is greater than or eqaul to HightestBid then it should be winning or elase it should be beaten
        if (objectVehicleListingInCell.strMyHighest.intValue>=objectVehicleListingInCell.strTotalHighest.intValue)
        {
            [cell.lblWinningBeaten setText:@"Winning"];
            [cell.lblWinningBeaten setTextColor:[UIColor colorWithRed:64.0f/255.0f green:198.0f/255.0f blue:42.0f/255.0f alpha:1.0f]];
        }
        else
        {
            [cell.lblWinningBeaten setText:@"Beaten"];
            [cell.lblWinningBeaten setTextColor:[UIColor colorWithRed:212.0f/255.0f green:46.0f/255.0f blue:48.0f/255.0f alpha:1.0f]];
        }
        
        // if MyHighestBid is equal to zero then it is N/A
        if (objectVehicleListingInCell.strMyHighest.intValue==0)
        {
            [cell.lblWinningBeaten setHidden:YES];
            [cell.labelMyBidValue setText:@"My Bid: N/A"];
        }
        else
        {
            [cell.lblWinningBeaten setHidden:NO];
            
            [cell.labelMyBidValue setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:objectVehicleListingInCell.strMyHighest]];
        }
    
        // making mileage type as small (Km)
        
        objectVehicleListingInCell.strVehicleMileageType = [NSString stringWithFormat:@"%@%@",[[objectVehicleListingInCell.strVehicleMileageType substringToIndex:[objectVehicleListingInCell.strVehicleMileageType length] - (objectVehicleListingInCell.strVehicleMileageType >0)]capitalizedString],[[objectVehicleListingInCell.strVehicleMileageType substringFromIndex:[objectVehicleListingInCell.strVehicleMileageType length] -1] lowercaseString]];
        
        // setting mileage with its type
        [cell.labelVehicleMileage   setText:[NSString stringWithFormat:@"%@%@",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:objectVehicleListingInCell.strVehicleMileage],objectVehicleListingInCell.strVehicleMileageType]];
        
        [cell.labelVehicleColor     setText:objectVehicleListingInCell.strVehicleColor];
        [cell.labelVehicleLocation  setText:objectVehicleListingInCell.strLocation];
        [cell.labelTradeTimeLeft    setText:objectVehicleListingInCell.strVehicleTeadeTimeLeft];
        
        // making thumb image big by replacing
        
        if ([objectVehicleListingInCell.arrayVehicleImages count]>0)
        {
            objectVehicleListingInCell.strVehicleImageURL = [NSString stringWithFormat:@"%@%@",[[objectVehicleListingInCell.arrayVehicleImages objectAtIndex:0]  substringToIndex:[[objectVehicleListingInCell.arrayVehicleImages objectAtIndex:0] length] -3],@"200"];
        }
    
        
        [cell.imageVehicle setImageWithURL:[NSURL URLWithString:objectVehicleListingInCell.strVehicleImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        
        // showing BuyItNow Banner image if vehcile is having buyItNow
        
        objectVehicleListingInCell.isBuyItNow == YES ?[cell.imageViewBuyItNow setHidden:NO]:[cell.imageViewBuyItNow setHidden:YES];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.buttonImageClickable setHidden:YES];
        if (arrayVehicleListing.count-1 == indexPath.row)
        {
            if (arrayVehicleListing.count != paginationEndCount.intValue)
            {
                startIndex++;
                [self loadingAllSearchedVehicle:sortingText];
            }
        }
        return cell;
    }
    else if (tableView == self.tableSearch)
    {
        static NSString     *CellIdentifier = @"Cell";
        static NSString     *CellIdentifier1 = @"SMTraderSearchSortByCell";
        
        switch (selectedDropdown)
        {
            case 1:
            {
                SMSearchTraderTableViewCell  *cell = (SMSearchTraderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                cell.backgroundColor = [UIColor clearColor];
                
                SMDropDownObject *objectCellForRow;
                
                objectCellForRow = (SMDropDownObject *)[arrayMake objectAtIndex:indexPath.row];
                [cell.labelSearchResultName setText:objectCellForRow.strDropDownValue];
                
                return cell;
            }
                break;
                
            case 2:
            {
                SMSearchTraderTableViewCell  *cell = (SMSearchTraderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                cell.backgroundColor = [UIColor clearColor];
                
                SMDropDownObject *objectCellForRow;
                
                objectCellForRow = (SMDropDownObject *)[arrayModel objectAtIndex:indexPath.row];
                [cell.labelSearchResultName setText:objectCellForRow.strDropDownValue];
                
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
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                [self.viewVehicleFound setFrame:CGRectMake(0, 296, 320, 25)];
                return (isSearch==YES) ? 322.0f : 255.0f;
            }
            else
                [self.viewVehicleFound setFrame:CGRectMake(0, 370, 768, 40)];
               return (isSearch==YES) ? 410.0f : 320.0f;
        }
        else
        {
            CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
            
            UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
            [imageView setImage:rotatedImage];
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                [self.viewVehicleFound setFrame:CGRectMake(0, 40, 320, 25)];
                return (isSearch==YES) ? 65.0f : 40.0f;
            }
            else
                [self.viewVehicleFound setFrame:CGRectMake(0, 50, 768, 40)];
                return (isSearch==YES) ? 90.0f : 50.0f;
        }
    }
    return 0;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableSearch)
    {
        SMDropDownObject *objectDidSelectForRow;
        switch (selectedDropdown)
        {
            case 1:
            {
                objectDidSelectForRow = (SMDropDownObject *)[arrayMake objectAtIndex:indexPath.row];

                [self.txtMake setText:objectDidSelectForRow.strDropDownValue];
                selectedMakeId = objectDidSelectForRow.dropDownID.integerValue;
                if (selectedMakeIndex!=indexPath.row)
                {
                    selectedMakeIndex = (int)indexPath.row;
                    selectedModelIndex      = -1;
                    selectedVariantsIndex   = -1;
                    
                    [self.txtModel setText:@""];
                    [self.txtVariants setText:@""];
                    
                    [arrayModel removeAllObjects];
                    [arrayVariant removeAllObjects];
                }

                [self.txtModel         setUserInteractionEnabled:YES];
                [self.txtVariants      setUserInteractionEnabled:NO];

                [self hidePopUpView];
            }
                break;
                
            case 2:
            {
                objectDidSelectForRow = (SMDropDownObject *)[arrayModel objectAtIndex:indexPath.row];

                [self.txtModel setText:objectDidSelectForRow.strDropDownValue];
                selectedModelId = objectDidSelectForRow.dropDownID.integerValue;
                if (selectedModelIndex != indexPath.row)
                {
                    selectedModelIndex      = (int)indexPath.row;
                    self.txtVariants.text   = @"";
                }

                [self.txtVariants   setUserInteractionEnabled:YES];
                [arrayVariant removeAllObjects];
                [self hidePopUpView];
            }
                break;
                
            case 3:
            {
                objectDidSelectForRow = (SMDropDownObject *)[arrayVariant objectAtIndex:indexPath.row];

                [self.txtVariants     setText:objectDidSelectForRow.strDropDownValue];
                selectedVariantId     = objectDidSelectForRow.dropDownID.integerValue;
                [self hidePopUpView];
            }
                break;
                
            case 10:
            {
                objectDidSelectForRow = (SMDropDownObject *)[arraySortObject objectAtIndex:indexPath.row];
                
                //Start for :- changed By Jignesh K on 13 march for adding ascending sorting oprtion by default as per client feedback
                if (selectedRow == indexPath.row)
                {
                    objectDidSelectForRow.isAscending = !objectDidSelectForRow.isAscending;
                }
                else
                {
                    objectDidSelectForRow.isAscending = YES;
                    
                }
                selectedRow = indexPath.row;
                
                // END for -: changed By Jignesh K on 13 march for adding ascending sorting oprtion by default as per client feedback
                
                
                SMTraderSearchSortByCell *selectedCell = (SMTraderSearchSortByCell*)[self.tableSearch cellForRowAtIndexPath:indexPath];
                
                SMDropDownObject *objectCellForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
                
                if(objectCellForRow.isAscending)
                {
                    selectedCell.imgAscDesc.transform = CGAffineTransformMakeRotation(M_PI);
                    [self.txtFieldSortBy setText:[NSString stringWithFormat:@"%@ (Ascending)",objectDidSelectForRow.strSortText]];
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
               
                sortingText = [self sortOptionSelectedWithSortIndex:indexPath.row andSortOrder:sortOrder];
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
        __block SMTraderDetailViewController *objectTradeDetails;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            objectTradeDetails = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
            [[SMTraderDetailViewController alloc] initWithNibName:@"SMTraderDetailViewController" bundle:nil] :
           [[SMTraderDetailViewController alloc] initWithNibName:@"SMTraderDetailViewController_iPad" bundle:nil];
            
            SMVehiclelisting *objectVehicleListingInDidCell = (SMVehiclelisting *) [arrayVehicleListing objectAtIndex:indexPath.row];
            
            objectTradeDetails.strSelectedVehicleId = objectVehicleListingInDidCell.strVehicleID;
           
            objectTradeDetails.vehicleListDelegates = self;

            [self.navigationController pushViewController:objectTradeDetails animated:YES];
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
             [HUD hide:YES];
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
             [HUD hide:YES];
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
             [HUD hide:YES];
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
    NSMutableURLRequest *requestURL=[SMWebServices gettingSearchListingVehicle:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withMinYear:selectedFromYear.intValue withMaxYear:selectedToYear.intValue  withMakeId:selectedMakeId withModelID:selectedModelId withVariant:selectedVariantId withCount:Page_S withPage:startIndex withSepareateTotal:1 withSortString:sortString];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             [[[UIAlertView alloc]initWithTitle:@"Error"
                                        message:connectionError.localizedDescription
                                       delegate:self cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil]
              show];
             [HUD hide:YES];
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
    
    if (selectedFromYear.intValue > selectedToYear.intValue)
    {
        [self showAlert:@"Please select your year properly"];
        return;
    }
    
    // loading all vehicle listing data
    [arrayVehicleListing removeAllObjects];
    startIndex           = 0;
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    [self loadingAllSearchedVehicle:sortingText];
}

-(IBAction)buttonFilterDidPressed:(id)sender
{
    if (buttonHeaderFilter.isSelected)
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
        }
    }
    [buttonHeaderFilter setSelected:!buttonHeaderFilter.selected];
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
    
    [self.txtModel      setUserInteractionEnabled:NO];
    [self.txtVariants   setUserInteractionEnabled:NO];

    [arrayMake removeAllObjects];
    [arrayModel removeAllObjects];
    [arrayVariant removeAllObjects];
    
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
    
    [self.txtModel      setUserInteractionEnabled:NO];
    [self.txtVariants   setUserInteractionEnabled:NO];
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
//    if ([elementName isEqualToString:@"Table1"])
//    {
//        objectVehicleListing  = [[SMVehiclelisting alloc] init];
//        objectDropDown        = [[SMDropDownObject alloc] init];
//    }
//    if ([elementName isEqualToString:@"ListMakesXMLResult"])
//    {
//        objectVehicleListing  = [[SMVehiclelisting alloc] init];
//        objectDropDown        = [[SMDropDownObject alloc] init];
//    }
    
    if ([elementName isEqualToString:@"Make"] || [elementName isEqualToString:@"model"] || [elementName isEqualToString:@"Variant"])
    {
        objectDropDown  = [[SMDropDownObject alloc] init];
    }
    
    
    
    if ([elementName isEqualToString:@"Vehicle"])
    {
        objectVehicleListing  = [[SMVehiclelisting alloc] init];
    }
    if ([elementName isEqualToString:@"BuyNow"])
    {
        
    }
    if ([elementName isEqualToString:@"TimeLeft"])
    {
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
    }
    if ([elementName isEqualToString:@"name"] || [elementName isEqualToString:@"Name"])
    {
        objectDropDown.strDropDownValue = currentNodeContent;
    }
    if ([elementName isEqualToString:@"AutobidCap"])
    {
        objectVehicleListing.intAutobidCap = [currentNodeContent intValue];
    }
    //Search Listing for vehicle
    if ([elementName isEqualToString:@"Year"])
    {
        objectVehicleListing.strVehicleYear = currentNodeContent;
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
        if ([currentNodeContent isEqualToString:@""])
        {
            objectVehicleListing.strVehicleMileage = @"0";
        }
        else
        {
            objectVehicleListing.strVehicleMileage = currentNodeContent;
        }
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        if ([currentNodeContent isEqualToString:@""])
        {
            objectVehicleListing.strVehicleColor = @"No Colour #";
        }
        else
        {
            objectVehicleListing.strVehicleColor = currentNodeContent;
        }
    }
    if ([elementName isEqualToString:@"Location"])
    {
        objectVehicleListing.strLocation = currentNodeContent;
        if (objectVehicleListing.strLocation.length == 0)
        {
            objectVehicleListing.strLocation = @"Suburb/City";
        }
    }
    if ([elementName isEqualToString:@"TradePrice"])
    {
        
        objectVehicleListing.strVehicleTradePrice = currentNodeContent;
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
    if ([elementName isEqualToString:@"MyHighestBid"])
    {
        objectVehicleListing.strMyHighest = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TimeLeft"])
    {
        @try
        {
            NSArray *arrayWithTwoStrings = [currentNodeContent componentsSeparatedByString:@"."];
            NSArray *hoursmint = [[arrayWithTwoStrings objectAtIndex:0]componentsSeparatedByString:@":"];
            
            objectVehicleListing.strVehicleTeadeTimeLeft = [NSString stringWithFormat:@"%@h %@m",[hoursmint objectAtIndex:0],[hoursmint objectAtIndex:1]];
        }
        @catch (NSException *exception)
        {
            
        }
        @finally
        {
            
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
        [arrayMake addObject:objectDropDown];
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
        arrayMake.count>0 ? [self loadPopUpView] : [self showAlert:@"No records found"];
    }
    if ([elementName isEqualToString:@"ListModelsXMLResult"])
    {
        [self.tableSearch reloadData];
        arrayModel.count>0 ? [self loadPopUpView] : [self showAlert:@"No records found"];
    }
    if ([elementName isEqualToString:@"ListVariantsXMLResult"])
    {
        [self.tableSearch reloadData];
        arrayVariant.count>0 ? [self loadPopUpView] : [self showAlert:@"No records found"];
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
        
        [self.lblVehicleFound setText:[NSString stringWithFormat:@"Vehicles Found   %d",[currentNodeContent intValue]]];
    }
    
    if ([elementName isEqualToString:@"SortSearchXMLResponse"])
    {
        if (selectedDropdown == 5)
        {
            if (arrayVehicleListing.count == 0)
            {
                [self.labelNoSearchResult setHidden:NO];
            }
            else if (arrayVehicleListing.count == paginationEndCount.intValue) // here pagination will
            {
                [self.labelNoSearchResult setHidden:YES];
            }
            else
            {
                [self.labelNoSearchResult setHidden:YES];
            }
            
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
    [self loadingAllSearchedVehicle:sortingText];
}

-(void)populateTheSortByArray
{
    NSArray *arrayOfSortTypes = [[NSArray alloc]initWithObjects:@"Age",@"Mileage",@"Price",@"Time Left",@"Year", nil];
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
        case 0:
        {
            if(sortOrder == 1)
                return @"age:asc";
            else
                return @"age:desc";
        }
            break;
            
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

