//
//  SMMyBidsViewController.m
//  SmartManager
//
//  Created by Ketan Nandha on 10/12/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMMyBidsViewController.h"
#import "SMTraderViewTableViewCell.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMCustomColor.h"
#import "SMSellCustomCell.h"
#import "UIImageView+WebCache.h"
#import "SMConstants.h"
#import "SMMyBidsDetailViewController.h"
#import "SMCommonClassMethods.h"

static int kPageSize=10;

@interface SMMyBidsViewController ()

@end

@implementation SMMyBidsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.btnSearch setExclusiveTouch:YES];
    
    previousIndex   = -1;
    currentIndex    = 0;
    
    self.arrayLosingBid     = [[NSMutableArray alloc]init];
    self.arrayWinningBid    = [[NSMutableArray alloc]init];
    self.arrayWon           = [[NSMutableArray alloc]init];
    self.arrayLost          = [[NSMutableArray alloc]init];
    tempDataArray           = [[NSMutableArray alloc]init];
    
    // used for setting Navigation Title
    self.navigationItem.titleView = [SMCustomColor setTitle:@"My Bids"];

    NSString*(^getDateToLastMonthDate)(void) = ^NSString*(void){
        
        NSDate *now = [NSDate date];
        
        endDate = [NSDate date];
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                         fromDate:now];
        comps.month            -= 1;
        
        NSDate *lastMonthDate = [cal dateFromComponents:comps];
        
        startDate = lastMonthDate;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd MMM yyyy HH:mm"];
        
        NSString *newDate = [formatter stringFromDate:lastMonthDate];
        
        NSString *currentDate = [formatter stringFromDate:[NSDate date]];
        
        return [NSString stringWithFormat:@"%@&%@",newDate,currentDate];
    };
    
    NSArray *getDateArray =  [getDateToLastMonthDate() componentsSeparatedByString:@"&"];
    
    [self.txtStartDate setText:getDateArray[0]];
    [self.txtEndDate setText:getDateArray[1]];
    
    arrayForSections = [[NSMutableArray alloc]init];

    [self populateTheSectionsArray];

    [self registerNib];
    
    self.viewDatePicker.layer.cornerRadius = 10.0;
    self.viewDatePicker.clipsToBounds      = YES;

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.btnCancel.titleLabel.font    = [UIFont fontWithName:FONT_NAME size:15.0f];
        self.btnDone.titleLabel.font      = [UIFont fontWithName:FONT_NAME size:15.0f];
    }
    else
    {
        self.btnCancel.titleLabel.font    = [UIFont fontWithName:FONT_NAME size:20.0f];
        self.btnDone.titleLabel.font      = [UIFont fontWithName:FONT_NAME size:20.0f];
    }
    
    [self.tblViewMyBids setBackgroundColor:[UIColor clearColor]];

    iLoosing = 0;
    iWinning = 0;
    iLost = 0;
    iWon = 0;
    
    [self webServiceGetMybidsCount];
    
    [self webServiceForLosingBid];
    [self webServiceForWinningBid];
    [self webServiceForWon];
    [self webServiceForLost];
}

#pragma mark - registerNib

- (void)registerNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tblViewMyBids registerNib:[UINib nibWithNibName:@"SMSellCustomCell" bundle:nil] forCellReuseIdentifier:@"SMSellCustomCellIdentifier"];
    }
    else
    {
        [self.tblViewMyBids registerNib:[UINib nibWithNibName:@"SMSellCustomCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMSellCustomCellIdentifier"];
    }
}

#pragma mark - populateTheSectionsArray

- (void)populateTheSectionsArray
{
    NSArray *arrayOfSectionNames = [[NSArray alloc]initWithObjects:@"Losing Bids",@"Winning Bids",@"Won",@"Lost", nil];
    
    for(int i=0;i<[arrayOfSectionNames count];i++)
    {
        sectionObject = [[SMClassForToDoObjects alloc]init];
        sectionObject.strSectionID = i+1;
        sectionObject.strSectionName = [arrayOfSectionNames objectAtIndex:i];
        [arrayForSections addObject:sectionObject];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [arrayForSections count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return ((SMClassForToDoObjects*)[arrayForSections objectAtIndex:section]).strSectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (((SMClassForToDoObjects*)[arrayForSections objectAtIndex:section]).isExpanded)
    {
        switch (section) {
                
            case 0:
                return self.arrayLosingBid.count;
                break;
                
            case 1:
                return self.arrayWinningBid.count;
                break;
                
            case 2:
                return self.arrayWon.count;
                break;
                
            case 3:
                return self.arrayLost.count;
                break;
                
            default:
                break;
        }
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSellCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMSellCustomCellIdentifier"];
    
    switch (indexPath.section)
    {
        case 0:
            objectVehicleListing = [self.arrayLosingBid objectAtIndex:indexPath.row];
            break;
            
        case 1:
            objectVehicleListing = [self.arrayWinningBid objectAtIndex:indexPath.row];
            break;
            
        case 2:
            objectVehicleListing = [self.arrayWon objectAtIndex:indexPath.row];
            break;
            
        case 3:
            objectVehicleListing = [self.arrayLost objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    cell.lblVehicleName.text = [NSString stringWithFormat:@"%@ %@",objectVehicleListing.strVehicleYear, objectVehicleListing.strVehicleName];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cell.lblVehicleName.text];
    NSRange fullRange = NSMakeRange(0, 4);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:fullRange];
    [cell.lblVehicleName setAttributedText:string];
    
    [cell.lblVehicleAmount setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:objectVehicleListing.strVehiclePrice]];
    
    cell.lblVehicleMileage.text   = [NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:objectVehicleListing.strVehicleMileage]];
    cell.lblVehicleColour.text    = objectVehicleListing.strVehicleColor;
    cell.lblVehicleLocation.text  = objectVehicleListing.strLocation;
    
    cell.backgroundColor = [UIColor blackColor];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    switch (indexPath.section)
    {
        case 0:
            if (self.arrayLosingBid.count-1 == indexPath.row)
            {
                if (self.arrayLosingBid.count != iTotalLoosing)
                {
                    iLoosing++;
                    [self webServiceForLosingBid];
                }
            }
            break;
            
        case 1:
            if (self.arrayWinningBid.count-1 == indexPath.row)
            {
                if (self.arrayWinningBid.count != iTotalWinning)
                {
                    iWinning++;
                    [self webServiceForWinningBid];
                }
            }
            break;
            
        case 2:
            if (self.arrayWon.count-1 == indexPath.row)
            {
                if (self.arrayWon.count != iTotalWon)
                {
                    iWon++;
                    [self webServiceForWon];
                }
            }
            
            break;
            
        case 3:
            if (self.arrayLost.count-1 == indexPath.row)
            {
                if (self.arrayLost.count != iTotalLost)
                {
                    iLost++;
                    [self webServiceForLost];
                }
            }
            break;
    }

    return cell;
}

#pragma mark - UITableView Delegate

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *headerColorView = [[UIView alloc] init];
    UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
    
    [sectionLabelBtn setExclusiveTouch:YES];

    imageViewArrowForsection = [[UIImageView alloc]init];
    imageViewArrowForsection.contentMode = UIViewContentModeScaleAspectFit;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
        [headerColorView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 38)];
        sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,40);
        sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
        [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-25,10,20,20)];
    }
    else
    {
        [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
        [headerColorView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 56)];
        sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,60);
        sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-25,20,20,20)];
    }
    
    if(((SMClassForToDoObjects*)[arrayForSections objectAtIndex:section]).isExpanded)
    {
        [UIView animateWithDuration:2 animations:^
         {
             switch (section)
             {
                 case 0:
                     if (self.arrayLosingBid.count>0)
                     {
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                     }
                     break;
                     
                 case 1:
                     if (self.arrayWinningBid.count>0)
                     {
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                     }
                     break;
                     
                 case 2:
                     if (self.arrayWon.count>0)
                     {
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                     }
                     break;
                     
                 case 3:
                     if (self.arrayLost.count>0)
                     {
                         imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                     }
                     break;
             }
         }
         completion:nil];
    }
    UIImage *image = [UIImage imageNamed:@"side_Arrow.png"];
    [imageViewArrowForsection setImage:image];
    
    countLbl = [[UILabel alloc]initWithFrame:CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-45,8, 20, 20)];
    countLbl.textColor = [UIColor whiteColor];
    countLbl.textAlignment = NSTextAlignmentCenter;
    countLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    countLbl.layer.borderWidth = 1.0;
    countLbl.layer.masksToBounds = YES;
    countLbl.font = [UIFont fontWithName:FONT_NAME size:15.0f];
    
    countLbl.layer.cornerRadius = countLbl.frame.size.width/2;

    if (self.arrayGetCount.count>0)
    {
        objCustomSell = [self.arrayGetCount objectAtIndex:0];
        
        switch (section)
        {
            case 0:
                [self setTheLabelCountText:objCustomSell.loosingBid];
                break;
                
            case 1:
                [self setTheLabelCountText:objCustomSell.winningBid];
                break;
                
            case 2:
                [self setTheLabelCountText:objCustomSell.wonBid];
                break;
                
            case 3:
                [self setTheLabelCountText:objCustomSell.lostBid];
                break;
        }
    }
    else
    {
        [self setTheLabelCountText:0];
    }
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width,9, countLbl.frame.size.width, 20);
    }
    else
    {
        countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width,20, countLbl.frame.size.width, 20);
    }
    
    [headerColorView addSubview:countLbl];
    [headerColorView addSubview:imageViewArrowForsection];
    
    if([((SMClassForToDoObjects*)[arrayForSections objectAtIndex:section]).strSectionName isEqualToString:@"Losing Bids"])
    {
        headerColorView.backgroundColor=[UIColor colorWithRed:52.0/255 green:118.0/255 blue:190.0/255 alpha:1.0];
    }
    else
    {
        headerColorView.backgroundColor=[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
    }
    
    [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sectionLabelBtn addTarget:self action:@selector(btnSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sectionLabelBtn setTag:section];
    sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [sectionLabelBtn setTitle:((SMClassForToDoObjects*)[arrayForSections objectAtIndex:section]).strSectionName forState:UIControlStateNormal];
    
    [headerColorView addSubview:sectionLabelBtn];
    [headerView addSubview:headerColorView];
    headerView.clipsToBounds = YES;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ?40.0f : 60.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 92.0f : 115.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            objectVehicleListing = self.arrayLosingBid[indexPath.row];
            break;
            
        case 1:
            objectVehicleListing = self.arrayWinningBid[indexPath.row];
            break;
            
        case 2:
            objectVehicleListing = self.arrayWon[indexPath.row];
            break;
            
        case 3:
            objectVehicleListing = self.arrayLost[indexPath.row];
            break;
    }

    __block SMMyBidsDetailViewController *myBidsDetailVC;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        myBidsDetailVC = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
            
        [[SMMyBidsDetailViewController alloc]initWithNibName:@"SMMyBidsDetailViewController" bundle:nil] :
            [[SMMyBidsDetailViewController alloc]initWithNibName:@"SMMyBidsDetailViewController_iPad" bundle:nil];

        myBidsDetailVC.objectVehicleListing = objectVehicleListing;
        
        [self.navigationController pushViewController:myBidsDetailVC animated:YES];
    });
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.txtStartDate)
    {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
//        [self.datePicker setDate:[dateFormatter dateFromString:self.txtStartDate.text] animated:YES];
        
        selectedType = 0;
        [textField resignFirstResponder];
        [self loadPopUpView];
    }
    if (textField==self.txtEndDate)
    {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
//        [self.datePicker setDate:[dateFormatter dateFromString:self.txtEndDate.text] animated:YES];
        
        selectedType = 1;
        if (self.txtStartDate.text.length == 0)
        {
            SMAlert(KLoaderTitle, KStartDate);

            [self.txtStartDate resignFirstResponder];
        }
        else
        {
            [textField resignFirstResponder];
            [self loadPopUpView];
        }
    }
    
    return NO;
}

#pragma mark - btnSearchDidClicked

-(IBAction)btnSearchDidClicked:(id)sender
{
    if ( [self validate]==YES)
    {
        [self webServiceGetMybidsCount];
    }
}
-(IBAction)btnCancelDidClicked:(id)sender
{
    [self hidePopUpView];
}

-(IBAction)btnDoneDidClicked:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:self.datePicker.date]];
    
    if (selectedType==0)
    {
        startDate = self.datePicker.date;
        
        switch ([startDate compare:endDate])
        {
            case NSOrderedAscending:
            {
                [self.txtStartDate setText:textDate];
            }
                break;
                
            case NSOrderedDescending:
                [self.txtEndDate setText:@""];
                break;
                
            case NSOrderedSame:
                [self.txtStartDate setText:textDate];
                break;
        }
    }
    else if (selectedType==1)
    {
        endDate = self.datePicker.date;
        
        switch ([startDate compare:endDate])
        {
            case NSOrderedAscending:
                [self.txtEndDate setText:textDate];
                break;
                
            case NSOrderedDescending:
                [self.txtEndDate setText:@""];
                
                SMAlert(KLoaderTitle, KStartGreaterEnd);
                
                break;
                
            case NSOrderedSame:
                [self.txtEndDate setText:textDate];
                break;
        }
    }
    
    [self hidePopUpView];
}

- (BOOL)validate
{
    if (!self.txtStartDate.text.length>0)
    {
        SMAlert(KLoaderTitle, KDateStart);
        
        return NO;
    }
    else if (!self.txtEndDate.text.length>0)
    {
        SMAlert(KLoaderTitle, KDateEnd);
        
        return NO;
    }
    else
        return YES;
}

#pragma mark - btnSectionTitleDidClicked

- (void)btnSectionTitleDidClicked:(id)sender
{
    currentIndex = [sender tag];

    if (currentIndex==previousIndex)
    {
        sectionObject = [arrayForSections objectAtIndex:previousIndex];
        sectionObject.isExpanded = !sectionObject.isExpanded;
    }
    else
    {
        if (previousIndex>-1)
        {
            sectionObject = [arrayForSections objectAtIndex:previousIndex];
            if (sectionObject.isExpanded)
            {
                sectionObject.isExpanded = !sectionObject.isExpanded;
            }
        }
        
        sectionObject = [arrayForSections objectAtIndex:currentIndex];
        sectionObject.isExpanded = !sectionObject.isExpanded;
        
        previousIndex = currentIndex;
    }
    
    if (self.arrayGetCount.count>0)
    {
        objCustomSell = [self.arrayGetCount objectAtIndex:0];
        
        switch (currentIndex)
        {
            case 0:
                iLoosing = 0;
                
                if (sectionObject.isExpanded)
                {
                    if (objCustomSell.loosingBid>0 && self.arrayLosingBid.count==0)
                    {
                        [self webServiceForLosingBid];
                    }
                    else
                        nil;
                }
                else
                    nil;
                
                break;
                
            case 1:
                iWinning = 0;
                
                if (sectionObject.isExpanded)
                {
                    if (objCustomSell.winningBid>0 && self.arrayWinningBid.count==0)
                    {
                        [self webServiceForWinningBid];
                    }
                    else
                        nil;
                }
                else
                    nil;
                
                break;
                
            case 2:
                iWon = 0;
                
                if (sectionObject.isExpanded)
                {
                    if (objCustomSell.wonBid>0 && self.arrayWon.count==0)
                    {
                        [self webServiceForWon];
                    }
                    else
                        nil;
                }
                else
                    nil;
                
                break;
                
            case 3:
                iLost = 0;
                
                if (sectionObject.isExpanded)
                {
                    if (objCustomSell.lostBid>0 && self.arrayLost.count==0)
                    {
                        [self webServiceForLost];
                    }
                    else
                        nil;
                }
                else
                    nil;
                
                break;
                
            default:
                break;
        }
        
        [self.tblViewMyBids reloadData];
    }
}

#pragma mark - setTheLabelCountText

- (void)setTheLabelCountText:(int)lblCount
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

#pragma mark - WebService Methods

- (void)webServiceGetMybidsCount
{
    NSMutableURLRequest *requestURL = [SMWebServices getBuyingCountsWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withFrom:self.txtStartDate.text withTo:self.txtEndDate.text];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
         }
         else
         {
             self.arrayGetCount = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)webServiceForLosingBid
{
    NSMutableURLRequest *requestURL = [SMWebServices losingBidsPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withPage:iLoosing withPageSize:kPageSize];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
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

-(void)webServiceForWinningBid
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

-(void)webServiceForWon
{
    NSMutableURLRequest *requestURL = [SMWebServices bidsWonPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withFrom:self.txtStartDate.text withTo:self.txtEndDate.text withPage:iWon withPageSize:kPageSize];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
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
    NSMutableURLRequest *requestURL = [SMWebServices bidsLostPagedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withFrom:self.txtStartDate.text withTo:self.txtEndDate.text withPage:iLost withPageSize:kPageSize];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
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
    NSLog(@"elementName %@",elementName);
    
    if ([elementName isEqualToString:@"UsedVehicleStockID"])
    {
        objectVehicleListing.strUsedVehicleStockID = currentNodeContent;
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
        objectVehicleListing.strVehicleMileage = [NSString stringWithFormat:@"%@Km",currentNodeContent];
    }
    if ([elementName isEqualToString:@"Price"])
    {
        objectVehicleListing.strVehiclePrice = currentNodeContent;
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
        objectVehicleListing.strOfferAmount = currentNodeContent;
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
        objectVehicleListing.strMyHighest = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SoldDate"])
    {
        objectVehicleListing.strSoldDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"OfferID"])
    {
        objectVehicleListing.strOfferID = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"Vehicle"])
    {
        [tempDataArray addObject:objectVehicleListing];
    }
    if ([elementName isEqualToString:@"Total"])
    {
        totalRecordCount = [currentNodeContent intValue];
    }
    
    if ([elementName isEqualToString:@"LosingBidsPagedResult"])
    {
        iTotalLoosing = totalRecordCount;
        [self.arrayLosingBid addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    
    if ([elementName isEqualToString:@"WinningBidsPagedResult"])
    {
        iTotalWinning = totalRecordCount;
        [self.arrayWinningBid addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    
    if ([elementName isEqualToString:@"BidsWonPagedResult"])
    {
        iTotalWon = totalRecordCount;
        [self.arrayWon addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    
    if ([elementName isEqualToString:@"BidsLostPagedResult"])
    {
        iTotalLost = totalRecordCount;
        [self.arrayLost addObjectsFromArray:tempDataArray];
        [tempDataArray removeAllObjects];
    }
    
    if ([elementName isEqualToString:@"LosingBids"])
    {
        objCustomSell.loosingBid = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"WinningBids"])
    {
        objCustomSell.winningBid = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"BidsWon"])
    {
        objCustomSell.wonBid = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"BidsLost"])
    {
        objCustomSell.lostBid = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"GetBuyingCountsResult"])
    {
        [self.arrayGetCount addObject:objCustomSell];
    }
/*
    if ([elementName isEqualToString:@"Vehicle"])
    {
        switch (currentIndex)
        {
            case 0:
                [self.arrayLosingBid addObject:objectVehicleListing];
                break;
                
            case 1:
                [self.arrayWinningBid addObject:objectVehicleListing];
                break;
                
            case 2:
                [self.arrayWon addObject:objectVehicleListing];
                break;
                
            case 3:
                [self.arrayLost addObject:objectVehicleListing];
                break;
        }
    }
    if ([elementName isEqualToString:@"Total"])
    {
        switch (currentIndex)
        {
            case 0:
                iTotalLoosing = [currentNodeContent intValue];
                break;
                
            case 1:
                iTotalWinning = [currentNodeContent intValue];
                break;
                
            case 2:
                iTotalWon = [currentNodeContent intValue];
                break;
                
            case 3:
                iTotalLost = [currentNodeContent intValue];
                break;
        }
    }
     */
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tblViewMyBids reloadData];
}

#pragma mark -
#pragma mark - Load/Hide Drop Down For Start & End Date

-(void)loadPopUpView
{
    [self.popupView setFrame:[UIScreen mainScreen].bounds];
    [self.popupView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [self.popupView setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self.popupView];
    [self.popupView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [self.popupView setAlpha:0.75];
         [self.popupView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [self.popupView setAlpha:1.0];
              
              [self.popupView setTransform:CGAffineTransformIdentity];
              
          }
          completion:^(BOOL finished)
          {
          }];
         
     }];
}

-(void) hidePopUpView
{
    [self.popupView setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self.popupView];
    [UIView animateWithDuration:0.1 animations:^{
        [self.popupView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [self.popupView setAlpha:0.3];
              [self.popupView setTransform:CGAffineTransformMakeScale(0.9,0.9)];
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   
                   [self.popupView setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [self.popupView removeFromSuperview];
                   [self.popupView setTransform:CGAffineTransformIdentity];
               }];
          }];
     }];
}

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
