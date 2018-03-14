//
//  SMTraderDetailViewController.m
//  SmartManager
//
//  Created by Jignesh on 13/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMTraderDetailViewController.h"
#import "SMTradeDetailSlider.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMDetailTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "SMCustomColor.h"
#import "SMCommonClassMethods.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)

@interface SMTraderDetailViewController ()

@end

@implementation SMTraderDetailViewController
@synthesize strSelectedVehicleId, objectVehicleList;
@synthesize vehicleListDelegates;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationController.navigationBar.topItem.title = @"Back";
        
        // Custom initialization
        arrayTradeSliderDetails         = [[NSMutableArray alloc] init];
        arrayFullImages                 = [[NSMutableArray alloc] init];
        arrayVehicleListing             = [[NSMutableArray alloc] init];
        arrayVehicleDetail              = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -  View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.buttonPlaceBid                setExclusiveTouch:YES];
    [buttonBuyNow                       setExclusiveTouch:YES];
    [buttonAutomatedBidding             setExclusiveTouch:YES];
    [self.btnCancelForExpandableView    setExclusiveTouch:YES];
    [self.btnActivateForExpandableView  setExclusiveTouch:YES];

    [self addingProgressHUD];
    [self addKeyBoardToolbar];

    [self registerNibTable];
    [self setTextFieldBidLimit];
    [self loadingAllDetails];
    
    [self setcustomFont];
}

- (void)setcustomFont
{
    self.btnActivateForExpandableView.layer.cornerRadius    = 4.0;
    self.btnCancelForExpandableView.layer.cornerRadius      = 4.0;

    buttonAutomatedBidding.layer.cornerRadius               = 5;
    buttonAutomatedBidding.clipsToBounds                    = YES;

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.textFieldPlaceBid     setFont:[UIFont fontWithName:FONT_NAME size:14.0f]];
        
        [self.btnActivateForExpandableView.titleLabel   setFont:[UIFont fontWithName:FONT_NAME_BOLD size:15.0f]];
        [self.btnCancelForExpandableView.titleLabel     setFont:[UIFont fontWithName:FONT_NAME_BOLD size:15.0f]];
        [buttonAutomatedBidding.titleLabel              setFont:[UIFont fontWithName:FONT_NAME_BOLD size:15.0f]];
    }
    else
    {
        self.textFieldPlaceBid.font = [UIFont fontWithName:FONT_NAME size:20.0f];
        self.btnActivateForExpandableView.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.btnCancelForExpandableView.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        buttonAutomatedBidding.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];

    buttonBuyNow.enabled = YES;
    
    if (isTheViewExpandedInHeader==YES)
    {
        isTheViewExpandedInHeader = YES;
        self.viewToBeExpanded.hidden = NO;
    }
    else
    {
        isTheViewExpandedInHeader = NO;
        self.viewToBeExpanded.hidden = YES;
    }
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (IS_IPHONE_4_OR_LESS)
    {
        
    }
    else
    {
        CGRect frame = [self.tableVehicleListing convertRect:textField.frame fromView:textField.superview.superview];
        [self.tableVehicleListing setContentOffset:CGPointMake(0, frame.origin.y) animated:YES];
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -  UICollectionView Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (arrayTradeSliderDetails.count==0  )
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            self.viewAdjust.frame = CGRectMake(0, 120, self.viewAdjust.frame.size.width, self.viewAdjust.frame.size.height+145);
        }
        else
        {
            self.viewAdjust.frame = CGRectMake(0, 155, self.viewAdjust.frame.size.width, self.viewAdjust.frame.size.height+165);
        }
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            self.viewAdjust.frame = CGRectMake(0, 187, self.viewAdjust.frame.size.width, self.viewAdjust.frame.size.height+145);
        }
        else
        {
            self.viewAdjust.frame = CGRectMake(0, 222, self.viewAdjust.frame.size.width, self.viewAdjust.frame.size.height+165);
        }
    }
    return  arrayTradeSliderDetails.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMTradeDetailSlider *sliderCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    [sliderCell.imageVehicle   setImageWithURL:[NSURL URLWithString:[arrayTradeSliderDetails objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"] success:^(UIImage *image, BOOL cached)
     {
         
     }
     failure:^(NSError *error)
     {
         
     }];
    
    return sliderCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        networkGallery.startingIndex = indexPath.row+1;
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

#pragma mark - UITablewView Datasource Method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.tableVehicleListing) ? arrayVehicleListing.count : arrayVehicleDetail.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableViewHeader)
    {
        static NSString     *CellIdentifier = @"Cell";
        
        SMTraderViewTableViewCell  *cell = (SMTraderViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell.viewBaseLine setHidden:YES];
        
        objectVehicleList = (SMVehiclelisting *) [arrayVehicleDetail objectAtIndex:indexPath.row];

        [cell.labelVehicleName      setText:[NSString stringWithFormat:@"%@ %@ \n",objectVehicleList.strVehicleYear,objectVehicleList.strVehicleName]];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cell.labelVehicleName.text];
        NSRange fullRange = NSMakeRange(0, 4);
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:fullRange];
        [cell.labelVehicleName setAttributedText:string];

        [cell.labelVehicleColor    setText:objectVehicleList.strVehicleColor];
        [cell.labelVehicleLocation setText:objectVehicleList.strLocation];
        [cell.labelTradeTimeLeft   setText:objectVehicleList.strVehicleTeadeTimeLeft];
        
        [cell.labelVehicleCost      setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:objectVehicleList.strVehicleTradePrice]];
        
        // if MyHighestBid is greater than or eqaul to HightestBid then it should be winning or elase it should be beaten
        if (objectVehicleList.strMyHighest.intValue>=objectVehicleList.strTotalHighest.intValue)
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
        if (objectVehicleList.strMyHighest.intValue==0)
        {
            [cell.lblWinningBeaten setHidden:YES];
            [cell.labelMyBidValue setText:@"My Bid: N/A"];
        }
        else
        {
            [cell.lblWinningBeaten setHidden:NO];
            [cell.labelMyBidValue setText:[NSString stringWithFormat:@"My Bid: %@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:objectVehicleList.strMyHighest]]];
        }
        
        AutoBidAmount = objectVehicleList.intAutobidCap;
        
        if (objectVehicleList.intAutobidCap==0)
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

        // making mileage type as small (Km)
        
        objectVehicleList.strVehicleMileageType = [NSString stringWithFormat:@"%@%@",[[objectVehicleList.strVehicleMileageType substringToIndex:[objectVehicleList.strVehicleMileageType length] - (objectVehicleList.strVehicleMileageType >0)]capitalizedString],[[objectVehicleList.strVehicleMileageType substringFromIndex:[objectVehicleList.strVehicleMileageType length] -1] lowercaseString]];
        
        objectVehicleList.isBuyItNow == YES ?[cell.imageViewBuyItNow setHidden:NO]:[cell.imageViewBuyItNow setHidden:YES];
        
        // setting mileage with its type
        [cell.labelVehicleMileage   setText:[NSString stringWithFormat:@"%@%@",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:objectVehicleList.strVehicleMileage],objectVehicleList.strVehicleMileageType]];
        
        if ([objectVehicleList.arrayVehicleImages count]>0)
        {
            objectVehicleList.strVehicleImageURL = [NSString stringWithFormat:@"%@%@",[[objectVehicleList.arrayVehicleImages objectAtIndex:0] substringToIndex:[[objectVehicleList.arrayVehicleImages objectAtIndex:0] length]-3],@"200"];
        }
        
        [cell.imageVehicle setImageWithURL:[NSURL URLWithString:objectVehicleList.strVehicleImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        
        cell.backgroundColor = [UIColor clearColor];
        
        // make image view into large view on button click
        
        [cell.buttonImageClickable setTag:indexPath.row];
        [cell.buttonImageClickable addTarget:self action:@selector(buttonImageClickableDidPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    else if (tableView == self.tableVehicleListing)
    {
        static NSString  *CellIdentifier = @"Cell";
        
        SMDetailTableViewCell  *cell = (SMDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        SMDetailTrade *objectInCellForRow = (SMDetailTrade *) [arrayVehicleListing objectAtIndex:indexPath.row];
        
        objectInCellForRow.strValue = [[objectInCellForRow.strValue componentsSeparatedByString:@"."] objectAtIndex:0];
        [cell.labelVehicleValue setText:objectInCellForRow.strValue];
        
        [cell.labelVehicleKey   setText:objectInCellForRow.strKey];
        cell.backgroundColor  = [UIColor clearColor];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableVehicleListing)
    {
        SMDetailTrade *objectInCellForRow = (SMDetailTrade *) [arrayVehicleListing objectAtIndex:indexPath.row];

        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            if (objectInCellForRow.strValue.intValue==0 && [objectInCellForRow.strKey isEqualToString:@"Buy Now Price"])
            {
                return 0.0f;
            }
            else if (objectInCellForRow.strValue.intValue==0 && [objectInCellForRow.strKey isEqualToString:@"Bid Closes On"])
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
            if (objectInCellForRow.strValue.intValue==0 && [objectInCellForRow.strKey isEqualToString:@"Buy Now Price"])
            {
                return 0.0f;
            }
            else if (objectInCellForRow.strValue.intValue==0 && [objectInCellForRow.strKey isEqualToString:@"Bid Closes On"])
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
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            return 115.0f;
        }
        else
        {
            return 150.0f;
        }
    }
}

#pragma mark - Make Image to large on header cell button click

-(void)buttonImageClickableDidPressed:(id) sender
{
    if ([arrayFullImages count]>0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            networkGallery               = [[FGalleryViewController alloc] initWithPhotoSource:self];
            networkGallery.startingIndex = [sender tag];
            [self.navigationController pushViewController:networkGallery animated:YES];
        });
    }
}

#pragma mark - Web service Integration

// call in viewdidload. This will load

-(void)loadingAllDetails
{
    [arrayVehicleListing     removeAllObjects];
    [arrayTradeSliderDetails removeAllObjects];
    [arrayFullImages         removeAllObjects];
    [arrayVehicleDetail     removeAllObjects];
    
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
             [HUD hide:YES];
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

// for buy now button pressed web service call for buy now vehicle

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
             [HUD hide:YES];
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

// For placing bid on place bid button web service call

-(void)placeBidWithBidValue
{
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
             [HUD hide:YES];
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

#pragma mark - Xml Parsing Methods

// once all fetching is done xml parsing will called

-(void) parser:(NSXMLParser *)          parser
didStartElement:(NSString *)            elementName
  namespaceURI:(NSString *)             namespaceURI
 qualifiedName:(NSString *)             qName
    attributes:(NSDictionary *)         attributeDict
{
    if([elementName isEqualToString:@"BuyNowResponse"])
    {
        checkStatus = isBuyNow;
    }
    if ([elementName isEqualToString:@"AutoBidResponse"])
    {
        checkStatus = isAutomatedBid;
    }
    if([elementName isEqualToString:@"BidResponse"])
    {
        checkStatus = isPlacingBid;
    }
    if ([elementName isEqualToString:@"RemoveAutoBidsResponse"])
    {
        checkStatus = isRemoveAutoBid;
    }
    if ([elementName isEqualToString:@"Vehicle"])
    {
        objectVehicleList  = [[SMVehiclelisting alloc] init];
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
    if ([elementName isEqualToString:@"AutobidCap"])
    {
        objectVehicleList.intAutobidCap = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"Year"])
    {
        objectVehicleList.strVehicleYear = currentNodeContent;
    }
    if ([elementName isEqualToString:@"FriendlyName"])
    {
        objectVehicleList.strVehicleName = currentNodeContent;
        self.navigationItem.titleView = [SMCustomColor setTitle:currentNodeContent];
    }
    if ([elementName isEqualToString:@"MileageType"])
    {
        if ([currentNodeContent isEqualToString:@""])
        {
            objectVehicleList.strVehicleMileageType = @"Km";
        }
        else
        {
            objectVehicleList.strVehicleMileageType = currentNodeContent;
        }
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
        if ([currentNodeContent isEqualToString:@""])
        {
            objectVehicleList.strVehicleMileage = @"0";
        }
        else
        {
            objectVehicleList.strVehicleMileage = currentNodeContent;
            objectVehicleList.mileageForSoring = [currentNodeContent intValue];
        }
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        if ([currentNodeContent isEqualToString:@""])
        {
            objectVehicleList.strVehicleColor = @"No Colour #";
        }
        else
        {
            objectVehicleList.strVehicleColor = currentNodeContent;
        }
    }
    if ([elementName isEqualToString:@"TimeLeft"])
    {
        @try
        {
            NSArray *arrayWithTwoStrings = [currentNodeContent componentsSeparatedByString:@"."];
            NSArray *hoursmint = [[arrayWithTwoStrings objectAtIndex:0]componentsSeparatedByString:@":"];
            
            objectVehicleList.strVehicleTeadeTimeLeft = [NSString stringWithFormat:@"%@h %@m",[hoursmint objectAtIndex:0],[hoursmint objectAtIndex:1]];
            
            objectVehicleList.timeLeftForSorting = [[NSString stringWithFormat:@"%@%@%@",[hoursmint objectAtIndex:0],[hoursmint objectAtIndex:1],[hoursmint objectAtIndex:2]] intValue];
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
        objectVehicleList.strVehicleID =  currentNodeContent;
    }
    if ([elementName isEqualToString:@"MyHighestBid"])
    {
        objectVehicleList.strMyHighest = currentNodeContent;
    }
    /*
    if ([elementName isEqualToString:@"MyHighestBid"])
    {
        if ([currentNodeContent isEqualToString:@"0.00"])
        {
            [self.btnActivateForExpandableView setTitle:@"Activate" forState:UIControlStateNormal];
            [self.btnCancelForExpandableView setTitle:@"Cancel" forState:UIControlStateNormal];
            [self.btnCancelForExpandableView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            [self.btnActivateForExpandableView setTitle:@"Amend" forState:UIControlStateNormal];
            [self.btnCancelForExpandableView setTitle:@"Disable" forState:UIControlStateNormal];
            [self.btnCancelForExpandableView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
     */
    
    if ([elementName isEqualToString:@"BuyNow"])
    {
        if ([currentNodeContent intValue] == 0)
        {
            objectVehicleList.isBuyItNow = NO;
        }
        else
        {
            objectVehicleList.isBuyItNow = YES;
        }
        
        objectTradeDeatilsVehicle = [[SMDetailTrade alloc] init];
        self.strBuyNowValue                = (NSMutableString *) currentNodeContent;
        objectTradeDeatilsVehicle.strKey   = @"Buy Now Price";
        objectTradeDeatilsVehicle.strValue = [self currencyFormator:currentNodeContent];// setting Currency Format for buy now price
         buyNowPrice = [self currencyFormator:currentNodeContent];
        [buttonBuyNow setTitle:[NSString stringWithFormat:@"Buy Now For %@",objectTradeDeatilsVehicle.strValue]forState:UIControlStateNormal]; // Set button title for buy now o1ffer
        
        [arrayVehicleListing addObject:objectTradeDeatilsVehicle];
    }
    if ([elementName isEqualToString:@"TradePrice"]) // trade price will be asking price
    {
        objectVehicleList.strVehicleTradePrice = currentNodeContent;
        objectVehicleList.priceForSorting = [currentNodeContent intValue];
        
        strTradeCost                       = currentNodeContent;
        objectTradeDeatilsVehicle          = [[SMDetailTrade alloc] init];
        objectTradeDeatilsVehicle.strValue = [self currencyFormator:currentNodeContent];
        objectTradeDeatilsVehicle.strKey   = @"Asking Price";
        [arrayVehicleListing addObject:objectTradeDeatilsVehicle];
    }
    if([elementName isEqualToString:@"Increment"])
    {
        objectTradeDeatilsVehicle          = [[SMDetailTrade alloc] init];
        self.strIncrementValue             = currentNodeContent;
        objectTradeDeatilsVehicle.strValue = [self currencyFormator:currentNodeContent];
        objectTradeDeatilsVehicle.strKey   = @"Min Bid Increment";
        [arrayVehicleListing addObject:objectTradeDeatilsVehicle];
    }
    if([elementName isEqualToString:@"Expires"])
    {
        objectTradeDeatilsVehicle           = [[SMDetailTrade alloc] init];
        objectTradeDeatilsVehicle.strValue  = currentNodeContent;
        objectTradeDeatilsVehicle.strKey    = @"Bid Closes On";
        [arrayVehicleListing addObject:objectTradeDeatilsVehicle];
    }
    if ([elementName isEqualToString:@"HightestBid"]) // Best Offer
    {
        objectVehicleList.strVehicleCurrentBid  = currentNodeContent;
        objectVehicleList.strTotalHighest = currentNodeContent;
        
        // if highest bid is greater than the trade price then we need to populate trade price as hignest bid
        if (objectVehicleList.strVehicleCurrentBid.intValue >objectVehicleList.strVehicleTradePrice.intValue)
        {
            objectVehicleList.strVehicleTradePrice = objectVehicleList.strVehicleCurrentBid;
        }

        strHighestBid  = currentNodeContent;
        objectTradeDeatilsVehicle           = [[SMDetailTrade alloc] init];
        // added by liji
        if([strHighestBid intValue]==0)
        {
           objectTradeDeatilsVehicle.strValue = @"None";
        }
        else
        {
            objectTradeDeatilsVehicle.strValue  = [self currencyFormator:currentNodeContent];
        }
        
        objectTradeDeatilsVehicle.strKey    = @"Best Offer So Far";
        
        // added by liji
        if([strHighestBid intValue]==0)
        {}
        
        if (strHighestBid.intValue  > strTradeCost.intValue)
        {
            objectVehicleList.strVehicleTradePrice = strHighestBid;
            [self.tableViewHeader reloadData];
        }
        [arrayVehicleListing addObject:objectTradeDeatilsVehicle];
    }
    if ([elementName isEqualToString:@"StockNumber"])
    {
        objectTradeDeatilsVehicle.strStockNumber = currentNodeContent;
        [self.lableStockNumber      setText:objectTradeDeatilsVehicle.strStockNumber];
    }
    if ([elementName isEqualToString:@"RegNumber"])
    {
        objectTradeDeatilsVehicle.strRegisterNumber = currentNodeContent;
        
        if ([objectTradeDeatilsVehicle.strRegisterNumber  isEqualToString:@"(null)"] || [objectTradeDeatilsVehicle.strRegisterNumber  isEqualToString:@""])
        {
            objectTradeDeatilsVehicle.strRegisterNumber = @"No Register #";
        }
        
        [self.labelRegisterNumber   setText:objectTradeDeatilsVehicle.strRegisterNumber];
    }
    if ([elementName isEqualToString:@"VIN"])
    {
        objectTradeDeatilsVehicle.strVinNumber = currentNodeContent;
        if([objectTradeDeatilsVehicle.strVinNumber isEqualToString:@""] || [objectTradeDeatilsVehicle.strVinNumber  isEqualToString:@"(null)"])
        {
            objectTradeDeatilsVehicle.strVinNumber = @"No VIN #";
        }
        
        [self.labelVinNumber setText:objectTradeDeatilsVehicle.strVinNumber];
    }
    if ([elementName isEqualToString:@"Comments"])
    {
        objectTradeDeatilsVehicle.strComments = currentNodeContent;
        if ([objectTradeDeatilsVehicle.strComments isEqualToString:@""])
        {
            objectTradeDeatilsVehicle.strComments = @"No Comment(s) Loaded";
        }
        
        [self.labelComment setText:objectTradeDeatilsVehicle.strComments];
        
        // setting dynamic height for footer for comments
        [self.labelComment setFrame:CGRectMake(self.labelComment.frame.origin.x, self.labelComment.frame.origin.y, self.labelComment.frame.size.width, [self heightOfTextForString:self.labelComment.text andFont:self.labelComment.font maxSize:CGSizeMake(self.labelComment.frame.size.width, 500.0f)])];
    }
    if ([elementName isEqualToString:@"Extras"])
    {
        objectTradeDeatilsVehicle.strExtras =  currentNodeContent;
        if ([objectTradeDeatilsVehicle.strExtras isEqualToString:@""])
        {
            objectTradeDeatilsVehicle.strExtras = @"No Extra(s) Loaded.";
        }
        [self.labelExtras setText:objectTradeDeatilsVehicle.strExtras];
        
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
    if ([elementName isEqualToString:@"OwnerName"])
    {
        objectTradeDeatilsVehicle              = [[SMDetailTrade alloc] init];
        objectTradeDeatilsVehicle.strOwnerName = currentNodeContent;
        if ([objectTradeDeatilsVehicle.strOwnerName isEqualToString:@""])
        {
            objectTradeDeatilsVehicle.strOwnerName = @"No Owner";
        }
        self.strOwnerLocation =  objectTradeDeatilsVehicle.strOwnerName;
    }
    if([elementName isEqualToString:@"Location"])
    {
        objectVehicleList.strLocation = currentNodeContent;
        if (objectVehicleList.strLocation.length == 0)
        {
            objectVehicleList.strLocation = @"Suburb/City";
        }
    
        objectTradeDeatilsVehicle = [[SMDetailTrade alloc] init];
        
        objectTradeDeatilsVehicle.strLocation =  currentNodeContent;
        
        if ([objectTradeDeatilsVehicle.strLocation isEqualToString:@""])
        {
            objectTradeDeatilsVehicle.strLocation = @"Suburb/City";
        }
        
        [self.labelOwnerName setText:[NSString stringWithFormat:@"Seller: %@, %@",self.strOwnerLocation, objectTradeDeatilsVehicle.strLocation]];
    }
    
    // adding vehicle images
    
    if ([elementName isEqualToString:@"Thumb"])
    {
        objectVehicleList.strVehicleImageURL = currentNodeContent;
        
        [objectVehicleList.arrayVehicleImages addObject:objectVehicleList.strVehicleImageURL];
        
        currentNodeContent = (NSMutableString *) [currentNodeContent substringToIndex:currentNodeContent.length-3];
        currentNodeContent = (NSMutableString *)[NSString stringWithFormat:@"%@%@",currentNodeContent,@"180"];
        [arrayTradeSliderDetails addObject:currentNodeContent];
    }
    if ([elementName isEqualToString:@"Full"])
    {
        [arrayFullImages addObject:currentNodeContent];
    }
    if ([elementName isEqualToString:@"Vehicle"])
    {
        [arrayVehicleDetail addObject:objectVehicleList];
    }
    if ([elementName isEqualToString:@"LoadVehicleResponse"])
    {
        if (arrayTradeSliderDetails.count>0)
        {
            [arrayTradeSliderDetails removeObjectAtIndex:0];
        }
        
        if (arrayTradeSliderDetails.count == 0  )
        {
            [sliderCollection               setHidden:YES];
            
            if(isTheViewExpandedInHeader)
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:198+145];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:233+145];
                    }
                }
                else
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:253+165];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:303+165];
                    }
                }
            }
            else
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:198];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:233];
                    }
                }
                else
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:253];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:303];
                    }
                }
            }
            
            [self.tableViewHeader setUserInteractionEnabled:YES];
        }
        else
        {
            [sliderCollection setHidden:NO];
            [sliderCollection reloadData];
        }
        
        // setting dynamic footer height so that comments and extra things will show
        [self.tableViewHeader reloadData];
        [self.tableVehicleListing reloadData];
    }
    if([elementName isEqualToString:@"MinBid"])
    {
        objectTradeDeatilsVehicle           = [[SMDetailTrade alloc] init];
        
        self.strBidValue     = currentNodeContent;
        objectTradeDeatilsVehicle.strValue = [self currencyFormator:currentNodeContent];
        objectTradeDeatilsVehicle.strKey    = @"Min Bid";
        
        [self.textFieldPlaceBid setPlaceholder:[[objectTradeDeatilsVehicle.strValue componentsSeparatedByString:@"."] objectAtIndex:0]];
        [self.textFieldPlaceBid setText:[[objectTradeDeatilsVehicle.strValue componentsSeparatedByString:@"."] objectAtIndex:0]];
        
        if ([objectTradeDeatilsVehicle.strValue isEqualToString:@"0.00"]) // IF min BID is 0 then hiding buttons
        {
            [self.buttonPlaceBid        setHidden:YES];
            [self.textFieldPlaceBid     setHidden:YES];
            [buttonAutomatedBidding     setHidden:YES];
            
            // setting header frame
            
            //[self setTableVehicleListTableHeaderView:300];
            
            if(isTheViewExpandedInHeader)
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:265+145];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:300+145];
                    }
                }
                else
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:320+165];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:370+165];
                    }
                }
            }
            else
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:265];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:300];
                    }
                }
                else
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:320];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:370];
                    }
                }
            }
        }
        else
        {
            [self.buttonPlaceBid    setHidden:NO];
            [self.textFieldPlaceBid setHidden:NO];
            [buttonAutomatedBidding setHidden:NO];
           // [self setTableVehicleListTableHeaderView:330];
            
            if(isTheViewExpandedInHeader)
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:265+145];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:300+145];
                    }
                }
                else
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:320+165];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:370+165];
                    }
                }
            }
            else
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:265];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:300];
                    }
                }
                else
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:320];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:370];
                    }
                }
            }

            // [self.textFieldPlaceBid setText:objectTradeDeatilsVehicle.strValue];
        }
        
        [arrayVehicleListing addObject:objectTradeDeatilsVehicle];
    }
    if ([elementName isEqualToString:@"Status"])
    {
        if (checkStatus==isPlacingBid)
        {
            if ([currentNodeContent isEqualToString:@"Ok"])
            {
                currentNodeContent = [NSMutableString stringWithString:@"Your bid is successful"];
            }
            UIAlertView *placeBidSuccess  = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            checkStatus = isClear;

            if ([currentNodeContent isEqualToString:@"You have purchased this vehicle"])
            {
                [vehicleListDelegates getRefreshedVehicleListing];
            }
            else if ([currentNodeContent isEqualToString:@"Your offer has already been beaten"] || [currentNodeContent isEqualToString:@"This vehicle is no longer available"])
            {
//                NSLog(@"CurrentNODE %@",currentNodeContent);
            }
            else
            {
                [self.textFieldPlaceBid setPlaceholder:[[[self currencyFormator:self.strBidValue] componentsSeparatedByString:@"."] objectAtIndex:0]];
                [self.textFieldPlaceBid setText:[[[self currencyFormator:self.strBidValue] componentsSeparatedByString:@"."] objectAtIndex:0]];
                [self refreshVehicleDetailPage]; // refrsh page
            }
            [placeBidSuccess show];
        }
        if (checkStatus==isBuyNow)
        {
            UIAlertView *buyNowSuccess  = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            checkStatus = isClear;

            buttonBuyNow.enabled = NO;
            [self.btnActivateForExpandableView setUserInteractionEnabled:NO];
            [self.btnCancelForExpandableView setUserInteractionEnabled:NO];
            [self.buttonPlaceBid setUserInteractionEnabled:NO];
            buttonAutomatedBidding.enabled = NO;
            [self.textFieldLimitBidAmount setUserInteractionEnabled:NO];
            [self.textFieldPlaceBid setUserInteractionEnabled:NO];

            // added by liji.
            
            // calling delegate method that will refresh the vehicle listing so that buy now vehicle will rfresh its listing
            [vehicleListDelegates getRefreshedVehicleListing];
            [buyNowSuccess show];
        }
        if (checkStatus==isAutomatedBid)
        {
            if ([currentNodeContent isEqualToString:@"Ok"])
            {
                currentNodeContent = [NSMutableString stringWithString:@"Your bid limit set successfully"];
            }
           
            UIAlertView *automatedBid  = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            checkStatus = isClear;
            
            if ([currentNodeContent isEqualToString:@"You have purchased this vehicle"])
            {
                [vehicleListDelegates getRefreshedVehicleListing];
            }
            else if ([currentNodeContent isEqualToString:@"You are already the highest bidder."])
            {
                [self.textFieldLimitBidAmount setText:@""];
            }
            else
            {
                [automatedBid setTag:100];
                
                [self.textFieldPlaceBid setPlaceholder:[[[self currencyFormator:self.strBidValue] componentsSeparatedByString:@"."] objectAtIndex:0]];
                
                [self.textFieldPlaceBid setText:[[[self currencyFormator:self.strBidValue] componentsSeparatedByString:@"."] objectAtIndex:0]];
                
//                NSNumberFormatter *DformatterMinBID;
//                if (DformatterMinBID == nil)
//                {
//                    DformatterMinBID = [[NSNumberFormatter alloc] init];
//                }
//                DformatterMinBID.currencyCode = @"R";
//                DformatterMinBID.numberStyle = NSNumberFormatterCurrencyStyle;
//                DformatterMinBID.locale = [NSLocale localeWithLocaleIdentifier:@"en_AF"];
//                
//                NSString *bidText = (NSMutableString *)[[[[[DformatterMinBID stringFromNumber:[NSNumber numberWithInt:bidAmountWithIncrement]] componentsSeparatedByString:@"."] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@" "] stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                if ([currentNodeContent isEqualToString:@"Your bid limit set successfully"])
                {
                    [self refreshVehicleDetailPage];
                }
            }
            [automatedBid show];
        }
        if (checkStatus==isRemoveAutoBid)
        {
            if ([currentNodeContent isEqualToString:@"OK"])
            {
                AutoBidAmount = 0;
                currentNodeContent = [NSMutableString stringWithString:@"Your automated bidding is disable"];
                
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

                [self.lblMaximumBid setHidden:NO];
                [self.textFieldLimitBidAmount setText:@""];
                [self.textFieldLimitBidAmount setHidden:NO];
            }
            UIAlertView *placeBidSuccess  = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            checkStatus = isClear;
            
            [placeBidSuccess show];
        }
    }
    
    if([elementName isEqualToString:@"Error"])
    {
        [vehicleListDelegates getRefreshedVehicleListing];
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

#pragma mark - IBAction Functions

-(IBAction)buttonAutomatedDidPressed:(id)sender
{
    if(!isTheViewExpandedInHeader)
    {
        isTheViewExpandedInHeader = YES;
        
        if (arrayTradeSliderDetails.count==0  )
        {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                if (objectVehicleList.isBuyItNow==NO)
                {
                    [self setTableVehicleListTableHeaderView:335];
                }
                else
                {
                    [self setTableVehicleListTableHeaderView:370];
                }
            }
            else
            {
                if (objectVehicleList.isBuyItNow==NO)
                {
                    [self setTableVehicleListTableHeaderView:405];
                }
                else
                {
                    [self setTableVehicleListTableHeaderView:455];
                }
            }

            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                self.viewAdjust.frame = CGRectMake(0, 120, self.viewAdjust.frame.size.width, self.viewAdjust.frame.size.height+145);
            }
            else
            {
                self.viewAdjust.frame = CGRectMake(0, 155, self.viewAdjust.frame.size.width, self.viewAdjust.frame.size.height+165);
            }
        }
        else
        {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                if (objectVehicleList.isBuyItNow==NO)
                {
                    [self setTableVehicleListTableHeaderView:402];
                }
                else
                {
                    [self setTableVehicleListTableHeaderView:437];
                }
            }
            else
            {
                if (objectVehicleList.isBuyItNow==NO)
                {
                    [self setTableVehicleListTableHeaderView:472];
                }
                else
                {
                    [self setTableVehicleListTableHeaderView:522];
                }
            }

            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                self.viewAdjust.frame = CGRectMake(0, 187, self.viewAdjust.frame.size.width, self.viewAdjust.frame.size.height+145);
            }
            else
            {
                self.viewAdjust.frame = CGRectMake(0, 222, self.viewAdjust.frame.size.width, self.viewAdjust.frame.size.height+165);
            }
        }
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            self.viewToBeExpanded.frame = CGRectMake(5.0, 72, self.viewToBeExpanded.frame.size.width, self.viewToBeExpanded.frame.size.height);
        }
        else
        {
            self.viewToBeExpanded.frame = CGRectMake(5.0, 92, self.viewToBeExpanded.frame.size.width, self.viewToBeExpanded.frame.size.height);
        }
        
        buttonBuyNow.frame = CGRectMake(5.0, self.viewToBeExpanded.frame.origin.y +self.viewToBeExpanded.frame.size.height, buttonBuyNow.frame.size.width, buttonBuyNow.frame.size.height);
        
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
            self.lblTitle.text = [NSString stringWithFormat:@"Start Automated Bidding at %@ with Increments of %@",[self currencyFormator:self.strBidValue],[self currencyFormator:self.strIncrementValue]];
        }
        else
        {
            [self.lblMaximumBid setHidden:YES];
            [self.textFieldLimitBidAmount setHidden:YES];
            
            [self.lblTitle setNumberOfLines:4];
            self.lblTitle.text = [NSString stringWithFormat:@"Automated Bidding Active: Started at %@ with Increments of %@. Max Bid %@. Current Bid %@",[self currencyFormator:self.strBidValue],[self currencyFormator:self.strIncrementValue],[self currencyFormator:[NSString stringWithFormat:@"%d",objectVehicleList.intAutobidCap]],[self currencyFormator:[NSString stringWithFormat:@"%d",self.strBidValue.intValue]]];
            
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
        }
        
        self.viewToBeExpanded.hidden = NO;
    }
    else
    {
        self.viewToBeExpanded.hidden =YES;
        isTheViewExpandedInHeader = NO;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            buttonBuyNow.frame = CGRectMake(5.0, 80.0, buttonBuyNow.frame.size.width, buttonBuyNow.frame.size.height);
        }
        else
        {
            buttonBuyNow.frame = CGRectMake(5.0, 100.0, buttonBuyNow.frame.size.width, buttonBuyNow.frame.size.height);
        }
        
        if (arrayTradeSliderDetails.count==0  )
        {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                if (objectVehicleList.isBuyItNow==NO)
                {
                    [self setTableVehicleListTableHeaderView:198];
                }
                else
                {
                    [self setTableVehicleListTableHeaderView:233];
                }
            }
            else
            {
                if (objectVehicleList.isBuyItNow==NO)
                {
                    [self setTableVehicleListTableHeaderView:253];
                }
                else
                {
                    [self setTableVehicleListTableHeaderView:303];
                }
            }
        }
        else
        {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                if (objectVehicleList.isBuyItNow==NO)
                {
                    // added by ketan
                    [self setTableVehicleListTableHeaderView:265];
                }
                else
                {
                    [self setTableVehicleListTableHeaderView:300];
                }
            }
            else
            {
                if (objectVehicleList.isBuyItNow==NO)
                {
                    [self setTableVehicleListTableHeaderView:320];
                }
                else
                {
                    [self setTableVehicleListTableHeaderView:370];
                }
            }
        }
    }
}

-(IBAction)buttonPlaceBid:(id)sender
{
    [self.textFieldPlaceBid resignFirstResponder];
    UIAlertView *alertForPlaceBid= [[UIAlertView alloc] initWithTitle:KLoaderTitle message:@"Do you want to bid on this vehicle with your bid amount?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
    [alertForPlaceBid setTag:102];
    [alertForPlaceBid show];
    
}

-(IBAction)buttonBuyNowDidPressed:(id)sender
{
    UIAlertView *buyNowPopUp = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:[NSString stringWithFormat:@"%@ %@", @"Do you want to purchase this vehicle at the buy now price of",buyNowPrice] delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
    [buyNowPopUp setTag:101];
    [buyNowPopUp show];
    
}

#pragma mark - Automated bid on submit limit

-(IBAction)submitLimitWithBidAmount:(id)sender
{
    [self.textFieldLimitBidAmount resignFirstResponder];

    if (self.textFieldLimitBidAmount.hidden==YES)
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            [self.lblTitle setFrame:CGRectMake(24, 5, 262, 45)];
        }
        else
        {
            [self.lblTitle setFrame:CGRectMake(24, 5, 720, 45)];
        }

        [self.lblMaximumBid setHidden:NO];
        [self.textFieldLimitBidAmount setHidden:NO];
        [self.lblTitle setNumberOfLines:2];
        self.lblTitle.text = [NSString stringWithFormat:@"Start Automated Bidding at %@ with Increments of %@",[self currencyFormator:self.strBidValue],[self currencyFormator:self.strIncrementValue]];
    }
    else
    {
        if (self.textFieldLimitBidAmount.text.length == 0 || self.textFieldLimitBidAmount.text.intValue==0)
        {
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:@"Please enter bid limit." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];
        }
        else
        {
            [self activateAutoBidWithAmount];
        }
    }
}

#pragma mark - cancel Automated bid on limit

- (IBAction)cancelLimitWithBidAmount:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    self.viewToBeExpanded.hidden =YES;
    isTheViewExpandedInHeader = NO;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        buttonBuyNow.frame = CGRectMake(5.0, 80.0, buttonBuyNow.frame.size.width, buttonBuyNow.frame.size.height);
    }
    else
    {
        buttonBuyNow.frame = CGRectMake(5.0, 100.0, buttonBuyNow.frame.size.width, buttonBuyNow.frame.size.height);
    }
    
    if (arrayTradeSliderDetails.count==0  )
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            if (objectVehicleList.isBuyItNow==NO)
            {
                // added by ketan
                [self setTableVehicleListTableHeaderView:198];
            }
            else
            {
                [self setTableVehicleListTableHeaderView:233];
            }
        }
        else
        {
            if (objectVehicleList.isBuyItNow==NO)
            {
                [self setTableVehicleListTableHeaderView:253];
            }
            else
            {
                [self setTableVehicleListTableHeaderView:303];
            }
        }
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            if (objectVehicleList.isBuyItNow==NO)
            {
                // added by ketan
                [self setTableVehicleListTableHeaderView:265];
            }
            else
            {
                [self setTableVehicleListTableHeaderView:300];
            }
        }
        else
        {
            if (objectVehicleList.isBuyItNow==NO)
            {
                [self setTableVehicleListTableHeaderView:320];
            }
            else
            {
                [self setTableVehicleListTableHeaderView:370];
            }
        }
    }

    if ([btn.titleLabel.text isEqualToString:@"Disable"])
    {
        [self removeAutoBid];
    }
}

#pragma mark - activateAutoBidWithAmount

- (void)activateAutoBidWithAmount
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

//    bidAmountWithIncrement      = self.strBidValue.intValue + self.strIncrementValue.intValue;
    bidAmountWithIncrement      = self.strBidValue.intValue;
    int limitAmount             = self.textFieldLimitBidAmount.text.intValue;
    
    NSMutableURLRequest *requestURL=[SMWebServices placeAutomatedBidding:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withUserID:[SMGlobalClass sharedInstance].strMemberID.intValue withVehicleID:self.strSelectedVehicleId.intValue withAmount:bidAmountWithIncrement withBidLimit:limitAmount];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
//    [SVProgressHUD showWithStatus:@"Please wait" maskType:SVProgressHUDMaskTypeGradient];
    
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
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

#pragma mark - removeAutoBid

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
             [HUD hide:YES];
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

#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 100)
    {
        if (buttonIndex == 0)
        {
           
            NSString *secondString = [NSString stringWithFormat:@"Max Bid %@. Current Bid %@",[self currencyFormator:self.textFieldLimitBidAmount.text],[self currencyFormator:[NSString stringWithFormat:@"%d",bidAmountWithIncrement]]];
            
            self.lblTitle.text = [NSString stringWithFormat:@"Automated Bidding Active: %@. %@",[NSString stringWithFormat:@"Started at %@ with Increments of %@",[self currencyFormator:self.strBidValue],[self currencyFormator:self.strIncrementValue]],secondString];
            
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

            [self.btnActivateForExpandableView setTitle:@"Amend" forState:UIControlStateNormal];
            [self.btnCancelForExpandableView setTitle:@"Disable" forState:UIControlStateNormal];
            [self.btnCancelForExpandableView setTitleColor:[UIColor colorWithRed:212.0f/255.0f green:46.0f/255.0f blue:48.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            
            self.viewToBeExpanded.hidden =YES;
            isTheViewExpandedInHeader = NO;
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                buttonBuyNow.frame = CGRectMake(5.0, 80.0, buttonBuyNow.frame.size.width, buttonBuyNow.frame.size.height);
            }
            else
            {
                buttonBuyNow.frame = CGRectMake(5.0, 100.0, buttonBuyNow.frame.size.width, buttonBuyNow.frame.size.height);
            }
            
            if (arrayTradeSliderDetails.count==0  )
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        // added by ketan
                        [self setTableVehicleListTableHeaderView:198];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:233];
                    }
                }
                else
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:253];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:303];
                    }
                }
            }
            else
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        // added by ketan
                        [self setTableVehicleListTableHeaderView:265];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:300];
                    }
                }
                else
                {
                    if (objectVehicleList.isBuyItNow==NO)
                    {
                        [self setTableVehicleListTableHeaderView:320];
                    }
                    else
                    {
                        [self setTableVehicleListTableHeaderView:370];
                    }
                }
            }
        }
    }
    
    else if (alertView.tag == 101)
    {
        if (buttonIndex == 0)
        {
            [self buyNowWebServiceCall];
        }
    }
    else if (alertView.tag == 102)
    {
        if (buttonIndex == 0)
        {
            [self placeBidWithBidValue];
        }
    }
}

#pragma mark - Calculate Label Height

-(CGFloat)heightOfTextForString:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize
{
    // iOS7
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGSize sizeOfText = [aString boundingRectWithSize: aSize
                                                  options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes: [NSDictionary dictionaryWithObject:aFont
                                                                                       forKey:NSFontAttributeName]
                                                  context: nil].size;
        
        return ceilf(sizeOfText.height);
    }
    
    // iOS6
    CGSize textSize = [aString sizeWithFont:aFont
                          constrainedToSize:aSize
                              lineBreakMode:NSLineBreakByWordWrapping];
    return ceilf(textSize.height);
}

#pragma mark -  User Define Functions

-(void) registerNibTable
{
    // Registering Nib for table anbd collection view
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.tableViewHeader registerNib:[UINib nibWithNibName:@"SMTraderViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        
        [self.tableVehicleListing registerNib:[UINib nibWithNibName:@"SMDetailTableViewCell" bundle:nil]     forCellReuseIdentifier:@"Cell"];
        
        [sliderCollection         registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil]            forCellWithReuseIdentifier:@"Cell"];
    }
    else
    {
        [self.tableViewHeader registerNib:[UINib nibWithNibName:@"SMTraderViewTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"Cell"];
        
        [self.tableVehicleListing registerNib:[UINib nibWithNibName:@"SMDetailTableViewCell_iPad" bundle:nil]     forCellReuseIdentifier:@"Cell"];
        
        [sliderCollection         registerNib:[UINib nibWithNibName:@"CollectionCell_iPad" bundle:nil]            forCellWithReuseIdentifier:@"Cell"];
    }
    
    // Setting Background color , clear color, etc
    
    [self.tableViewHeader     setBackgroundColor:[UIColor clearColor]];
    [self.tableVehicleListing setBackgroundColor:[UIColor clearColor]];
    [self.tableViewHeader     setTableFooterView:[[UIView alloc] init]];
    [self.tableViewHeader     setTableHeaderView:[[UIView alloc] init]];
    
    // table header and footer etc
    
    [self.tableVehicleListing setTableFooterView:viewTableFooterForVehicleStock];
    [self.tableVehicleListing setTableHeaderView:viewHeaderForVehcileStock];
}

-(void) setTableVehicleListTableFooterView:(CGFloat) newHeight
{
    // setting footer height
    CGRect FooterFrame                       = self.tableVehicleListing.tableFooterView.frame;
    FooterFrame.size.height                  = newHeight;
    viewTableFooterForVehicleStock.frame     = FooterFrame;
    self.tableVehicleListing.tableFooterView = viewTableFooterForVehicleStock;
}

-(void) setTableVehicleListTableHeaderView:(CGFloat) newHeightHeader
{
    CGRect headerFrame                         = self.tableVehicleListing.tableHeaderView.frame;
    headerFrame.size.height                    = newHeightHeader;
    viewHeaderForVehcileStock.frame            = headerFrame;
    self.tableVehicleListing.tableHeaderView   = viewHeaderForVehcileStock;
    
}

-(void)setEnabledAutomatedBidding
{
    NSMutableAttributedString * string =
    [[NSMutableAttributedString alloc] initWithString:@"Automated Bidding"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,6)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(7,17)];
    
    [buttonAutomatedBidding setAttributedTitle:string forState:UIControlStateNormal];
}

-(void) setTextFieldBidLimit
{
    self.textFieldLimitBidAmount.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.textFieldLimitBidAmount.layer.borderWidth= 0.8f;
    [self.textFieldLimitBidAmount setLeftViewMode:UITextFieldViewModeAlways];
    [self.textFieldLimitBidAmount setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)]];
    [self.textFieldLimitBidAmount setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.textFieldLimitBidAmount.font = [UIFont fontWithName:FONT_NAME size:14.0];
    }
    else
    {
        self.textFieldLimitBidAmount.font = [UIFont fontWithName:FONT_NAME size:20.0];
    }
}

-(void) refreshVehicleDetailPage
{
    [self loadingAllDetails];
}

#pragma mark - Global Alert

-(void) showAlert:(NSString *) strMessage
{
    UIAlertView *alert;
    if (alert == nil)
    {
        alert  = [[UIAlertView alloc] initWithTitle:@"Smart Manager" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    [alert setMessage:strMessage];
    [alert show];
}

#pragma mark - Currency Formattor

-(NSString *) currencyFormator:(NSString *) strCurrencyDate
{
    NSString *strFormattedCurrency;
    NSNumberFormatter *DformatterMinBID;
    if (DformatterMinBID == nil)
    {
        DformatterMinBID = [[NSNumberFormatter alloc] init];
    }
    DformatterMinBID.currencyCode = @"R";
    DformatterMinBID.numberStyle = NSNumberFormatterCurrencyStyle;
    DformatterMinBID.locale = [NSLocale localeWithLocaleIdentifier:@"en_AF"];
    
    strFormattedCurrency = (NSMutableString *)[[[[[DformatterMinBID stringFromNumber:[NSNumber numberWithFloat:strCurrencyDate.floatValue]] componentsSeparatedByString:@"."] objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@" "] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return strFormattedCurrency;
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
