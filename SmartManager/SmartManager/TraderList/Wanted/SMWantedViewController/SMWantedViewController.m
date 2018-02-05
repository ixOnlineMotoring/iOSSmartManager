//
//  SMWantedViewController.m
//  SmartManager
//
//  Created by Ketan Nandha on 23/02/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMWantedViewController.h"
#import "SMWantedTableViewCell.h"
#import "SMVariantTableViewCell.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMConstants.h"
#import "UIBAlertView.h"
#import "SMWantedDetailViewController.h"
#import "SMCustomColor.h"
#import "Fontclass.h"
#import "Constant.h"
const int initialStartYear = 16; // initially Start Year as 2006 and 2006 is at 16 index

@interface SMWantedViewController ()

@end

@implementation SMWantedViewController
@synthesize popupView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addingProgressHUD];
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Wanted"];
    
    [self customTextView];
    
    [self registerNib];
    
    [self getYearArray];
    
    [self webserviceForRegionList];
    [self webserviceForListActiveWantedSearch];

    [self.txtToYear setUserInteractionEnabled:NO];
    [self.txtMake setUserInteractionEnabled:NO];
    [self.txtModel setUserInteractionEnabled:NO];
    [self.txtVariant setUserInteractionEnabled:NO];
    
    cellScrolled = -1;
}

#pragma mark - WebService Methods

- (void)webserviceForWantedMakes
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices getMakeWithUserHash:[SMGlobalClass sharedInstance].hashValue withFromYear:[self.txtFromYear.text intValue] withToYear:[self.txtToYear.text intValue]];
    
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
             arrayMake = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)webserviceForWantedModel
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices getModelWithUserHash:[SMGlobalClass sharedInstance].hashValue withMakeID:makeID withFromYear:[self.txtFromYear.text intValue] withToYear:[self.txtToYear.text intValue]];
    
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
             arrayModel = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)webserviceForWantedVariant
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices getVariantWithUserHash:[SMGlobalClass sharedInstance].hashValue withModelID:modelID withFromYear:[self.txtFromYear.text intValue] withToYear:[self.txtToYear.text intValue]];
    
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
             arrayVariant = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)webserviceForListActiveWantedSearch
{
    NSMutableURLRequest *requestURL = [SMWebServices listActiveWantedSearchWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
    
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
             arrayWantedSearch = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)webserviceForListActiveWantedSearchCount
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices listActiveWantedSearchWithCountXMLWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
    
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
             arrayWantedSearch = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)webserviceForSearchResultCount:(int)iWantedID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices searchResultCountWithUserHash:[SMGlobalClass sharedInstance].hashValue withWantedSearchID:iWantedID];
    
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

- (void)webserviceForRegionList
{
//    [HUD show:YES];
//    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices getRegionListWithUserHash:[SMGlobalClass sharedInstance].hashValue];
    
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
             arrayRegion = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)webserviceForRemoveWanted:(int)iWantedID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices removeWantedWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withWantedSearchID:iWantedID];
    
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

- (void)webserviceForAddToWantedList
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices addToWantedListWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withMakeID:makeID withModelID:modelID withVariantID:strVariant withProvincesID:strRegion withMaxYear:self.txtToYear.text.intValue withMinYear:self.txtFromYear.text.intValue];

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

#pragma mark - UITableView Datasource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.tableWanted)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.tableWanted)
    {
        switch (section)
        {
            case 0:
                return 0;
                break;
                
            case 1:
                return [arrayWantedSearch count];
                break;
        }
    }
    else if (tableView==self.tablePopUp)
    {
        float maxHeigthOfView = [self view].frame.size.height/2+50.0;
        float totalFrameOfView = 0.0f;
        
        switch (selectedIndex)
        {
            case 2:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([arrayMake count]*43) : 60+([arrayMake count]*60);
                break;
                
            case 3:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([arrayModel count]*43) : 60+([arrayModel count]*60);
                break;
        }
        
        if (totalFrameOfView <= maxHeigthOfView)
        {
            //Make View Size smaller, no scrolling
            self.viewTablePopUp.frame = CGRectMake(self.viewTablePopUp.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, self.viewTablePopUp.frame.size.width, totalFrameOfView);
        }
        else
        {
            self.viewTablePopUp.frame = CGRectMake(self.viewTablePopUp.frame.origin.x, maxHeigthOfView/2-22.0, self.viewTablePopUp.frame.size.width, maxHeigthOfView);
        }
        switch (selectedIndex)
        {
            case 2:
                return [arrayMake count];
                break;
                
            case 3:
                return [arrayModel count];
                break;
        }

    }
    else if (tableView==self.tableVariant)
    {
        return [arrayVariant count];
    }
    else if (tableView==self.tableRegion)
    {
        return [arrayRegion count];
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableWanted)
    {
        SMWantedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMWantedTableViewCellIdentifier"];
        
        objectDropDown = arrayWantedSearch[indexPath.row];
        
        [cell.lblVehicleName    setText:[NSString stringWithFormat:@"'%@' %@",[self convertYear:objectDropDown.YearRange],objectDropDown.FriendlyName]];
        [cell.lblRegionDetail   setText:[NSString stringWithFormat:@"Region/s: %@",objectDropDown.Provinces]];
        
        [cell.btnSearch         setTag:indexPath.row];
        [cell.btnSearch         setExclusiveTouch:YES];

        if (objectDropDown.Results!=nil)
        {
            NSAttributedString *searchAttributedString = [[NSAttributedString alloc]initWithString:objectDropDown.Results attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:20.0f]}];
            [cell.btnSearch setAttributedTitle:searchAttributedString forState:UIControlStateNormal];
        }
        else
        {
            [Fontclass ButtonWithAttributedFont:cell.btnSearch iconID:370];
        }
        
        [cell.btnSearch addTarget:self action:@selector(btnSearchDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (arrayWantedSearch.count-1==indexPath.row)
        {
            cell.separatorInset = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? UIEdgeInsetsMake(0.f, 335.f,0.f, 0.f) : UIEdgeInsetsMake(0.f, 783.f, 0.f, 0.f);
        }
        else
        {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            cell.backgroundColor = [UIColor clearColor];
        }
        
        //start of code for swipe to delete
        
        NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc]init];
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:231.0f/255.0f green:0.0f/255.0f blue:18.0f/255.0f alpha:1.0f] title:@"x"];
        
        cell.rightUtilityButtons    = rightUtilityButtons;
        cell.delegate               = self;
        cell.indexPathCell          = indexPath;

        //end of code for swipe to delete

        return cell;
    }
    else if (tableView == self.tablePopUp)
    {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        switch (selectedIndex)
        {
            case 2:
                objectDropDown = arrayMake[indexPath.row];
                break;
                
            case 3:
                objectDropDown = arrayModel[indexPath.row];
                break;
        }
        
        [cell.textLabel setText:objectDropDown.strDropDownValue];

        [cell.textLabel setFont:[UIFont fontWithName:FONT_NAME size:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 15.0f : 20.0f]];
        
        return cell;
    }
    else if (tableView == self.tableVariant)
    {
        SMVariantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMVariantTableViewCellIdentifier"];
        
        objectDropDown = arrayVariant[indexPath.row];
        
        [cell.lblName setText:objectDropDown.strDropDownValue];
        
        if (objectDropDown.isSelected)
        {
            [cell.btnIcon setSelected:YES];
        }
        else
        {
            [cell.btnIcon setSelected:NO];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        
        return cell;
    }
    else if (tableView == self.tableRegion)
    {
        SMVariantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMRegionTableViewCellIdentifier"];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"strDropDownValue" ascending:YES];
        
        NSArray *sortdiscriptor=[[NSArray alloc]initWithObjects:sort, nil];
        [arrayRegion sortUsingDescriptors:sortdiscriptor];

        objectDropDown = arrayRegion[indexPath.row];

        [cell.lblName setText:objectDropDown.strDropDownValue];
        
        if (objectDropDown.isSelected)
        {
            [cell.btnIcon setSelected:YES];
        }
        else
        {
            [cell.btnIcon setSelected:NO];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        
        return cell;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableWanted)
    {
        switch (section)
        {
            case 0:
                [self.btnHeaderFilter setTag:section];
                return self.headerView;
                break;
                
            case 1:
                return self.secondHeaderView;
                break;
        }
    }

    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableWanted)
    {
        switch (section)
        {
            case 0:
                if([self.btnHeaderFilter isSelected])
                {
                    CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
                    
                    UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
                    [self.imgViewArrow setImage:rotatedImage];
                    
                    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 440.0f : 680.0f;
                }
                else
                {
                    CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
                    
                    UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
                    [self.imgViewArrow setImage:rotatedImage];
                    
                    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 40.0f : 50.0f;
                }
                break;
                
            case 1:
                return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 60.0f : 80.0f;
                break;
        }
    }

    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableWanted)
    {
        return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 80 : 100;
    }
    else if (tableView == self.tablePopUp)
    {
        return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 40 : 60;
    }
    else
    {
        return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 30 : 50;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==self.tableVariant)
    {
        objectDropDown = arrayVariant[indexPath.row];
        
        if ([objectDropDown.strDropDownValue isEqualToString:@"All"])
        {
            if (objectDropDown.isSelected==true)
            {
                for (objectDropDown in arrayVariant)
                {
                    objectDropDown.isSelected = false;
                }
            }
            else
            {
                for (objectDropDown in arrayVariant)
                {
                    objectDropDown.isSelected = true;
                }
            }
        }
        else
        {
            
            if (objectDropDown.isSelected==true)
            {
                SMDropDownObject *objDropDown = arrayVariant[0];
                
                objDropDown.isSelected = false;
                objectDropDown.isSelected = false;
            }
            else
            {
                objectDropDown.isSelected = true;
                
                NSArray *fileteredArr = [arrayVariant filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected == true"]];
                
                if((arrayVariant.count - 1) == fileteredArr.count)
                {
                    SMDropDownObject *objDropDown = arrayVariant[0];
                    
                    objDropDown.isSelected = true;
                }
            }
        }
    
        [self.tableVariant reloadData];
    }
    else if (tableView==self.tableRegion)
    {
        objectDropDown = arrayRegion[indexPath.row];

        if ([objectDropDown.strDropDownValue isEqualToString:@"All"])
        {
            if (objectDropDown.isSelected)
            {
                for (objectDropDown in arrayRegion)
                {
                    objectDropDown.isSelected = false;
                }
            }
            else
            {
                for (objectDropDown in arrayRegion)
                {
                    objectDropDown.isSelected = true;
                }
            }
        }
        else
        {
            if (objectDropDown.isSelected==true)
            {
                SMDropDownObject *objDropDown = arrayRegion[0];

                objDropDown.isSelected = false;
                objectDropDown.isSelected = false;
            }
            else
            {
                objectDropDown.isSelected = true;

                NSArray *fileteredArr = [arrayRegion filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected == true"]];
                
                if((arrayRegion.count - 1) == fileteredArr.count)
                {
                    SMDropDownObject *objDropDown = arrayRegion[0];
                    
                    objDropDown.isSelected = true;
                }
            }
        }
        
        [self.tableRegion reloadData];
    }
    else if (tableView==self.tablePopUp)
    {
        switch (selectedIndex)
        {
                case 2:
                {
                    [self.txtModel setUserInteractionEnabled:YES];
                    [self.txtVariant setUserInteractionEnabled:NO];
                    
                    makeID = [((SMDropDownObject*) arrayMake[indexPath.row]).dropDownID intValue];
                
                    if (selectedMakeIndex!=indexPath.row)
                    {
                        selectedMakeIndex = (int)indexPath.row;
                        selectedModelIndex      = -1;
                        [self.txtMake setText:((SMDropDownObject*) arrayMake[indexPath.row]).strDropDownValue];
                        [self.txtModel setText:@""];
                        [arrayModel removeAllObjects];
                        [self.txtVariant setAlpha:1.0f];
                        [self.tableVariant setAlpha:0.0f];
                    }
                }
                break;
                
                case 3:
                {
                    [self.txtVariant setUserInteractionEnabled:YES];

                    modelID = [((SMDropDownObject*) arrayModel[indexPath.row]).dropDownID intValue];

                    if (selectedModelIndex!=indexPath.row)
                    {
                        selectedModelIndex = (int)indexPath.row;
                        [self.txtModel setText:((SMDropDownObject*) arrayModel[indexPath.row]).strDropDownValue];
                        [self.txtVariant setAlpha:1.0f];
                        [self.tableVariant setAlpha:0.0f];
                        selectedIndex = self.txtVariant.tag;
                        [self webserviceForWantedVariant];
                    }
                }
                break;
        }

        [self hidePopUpView];
    }
}

#pragma mark - swipeableTableViewCell Method

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state andIndexpath:(NSIndexPath *)indexpath
{
//    if (state == kCellStateCenter)
//    {
//        cellScrolled=-1;
//        NSLog(@"Center");
//    }
    if (state == kCellStateRight)
    {
        if (cellScrolled==cell.indexPathCell.row)
        {
            NSLog(@"Return");
            return;
        }
        else if (cellScrolled != -1)
        {
            NSLog(@"Swipe Delete");
            NSIndexPath *myIP = [NSIndexPath indexPathForRow:cellScrolled inSection:1] ;
            SMWantedTableViewCell *cellFav = (SMWantedTableViewCell*)[self.tableWanted cellForRowAtIndexPath:myIP];
            
           [cellFav hideUtilityButtonsAnimated:YES];
        }
        
        cellScrolled=(int)cell.indexPathCell.row;
        NSLog(@"Main");
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index andIndexpath:(NSIndexPath*)indexpath
{
    switch (index)
    {
        case 0:
            objectDropDown = [arrayWantedSearch objectAtIndex:indexpath.row];
            
            indexRemoved = indexpath;
            
            
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Are you sure you want to delete this vehicle?" cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
            
            [alert showWithDismissHandler:^(NSInteger selectedIndex1, NSString *selectedTitle, BOOL didCancel)
             {

                 
                 switch (selectedIndex1)
                 {
                     case 1:
                     {
                         [self webserviceForRemoveWanted:objectDropDown.iWantedSearchID];
                          return;
                     }
                         break;
                         
                     default:
                         break;
                 }
                 
             }];
            break;
    }
}

#pragma mark -  UIPickerView Delegate & Datasource

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
    switch (selectedIndex)
    {
        case 0:
            selectedRowFromYear = row;
            break;
            
        case 1:
            selectedRowToYear = row;
            break;
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];

    if (textField == self.txtFromYear)
    {
        selectedIndex = (int)self.txtFromYear.tag;
        
        [self.viewPickerPopUp setHidden:NO];
        [self.viewTablePopUp setHidden:YES];
        
        [self.pickerYear selectRow:selectedRowFromYear inComponent:0 animated:YES];

        if (arrayYears.count>0)
        {
            [self loadPopUpView];
        }

        return NO;
    }
    else if (textField == self.txtToYear)
    {
        selectedIndex = (int)self.txtToYear.tag;

        [self.viewPickerPopUp setHidden:NO];
        [self.viewTablePopUp setHidden:YES];
        
        [self.pickerYear selectRow:selectedRowToYear inComponent:0 animated:YES];
        
        if (arrayYears.count>0)
        {
            [self loadPopUpView];
        }
        
        return NO;
    }
    else if (textField == self.txtMake)
    {
        selectedIndex = (int)self.txtMake.tag;

        [self.viewPickerPopUp setHidden:YES];
        [self.viewTablePopUp setHidden:NO];
        
        if (arrayMake.count>0)
        {
            [self.tablePopUp reloadData];
            [self loadPopUpView];
        }
        else
        {
            [self webserviceForWantedMakes];
        }
        
        return NO;
    }
    else if (textField == self.txtModel)
    {
        selectedIndex = (int)self.txtModel.tag;

        [self.viewPickerPopUp setHidden:YES];
        [self.viewTablePopUp setHidden:NO];
        
        if (arrayModel.count>0)
        {
            [self.tablePopUp reloadData];
            [self loadPopUpView];
        }
        else
        {
            [self webserviceForWantedModel];
        }
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - UIButton Action

-(IBAction)btnHeaderFilterDidClicked:(id)sender
{
    [self.btnHeaderFilter setSelected:!self.btnHeaderFilter.selected];
    [self.tableWanted reloadData];
}

-(IBAction)btnAddToWantedListDidClicked:(id)sender
{
    if ([self validation]==YES)
    {
        strVariant = [[NSMutableString alloc]init];

        for (int i=0; i<[arrayVariant count]; i++)
        {
            objectDropDown = arrayVariant[i];
            
            if (![objectDropDown.strDropDownValue isEqualToString:@"All"])
            {
                if (objectDropDown.isSelected==true)
                {
                    [strVariant appendString:[NSString stringWithFormat:@"<int xmlns=\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\">%@</int>",objectDropDown.dropDownID]];
                }
            }
            else
            {
                if (objectDropDown.isSelected==true)
                {
                    [strVariant appendString:[NSString stringWithFormat:@"<int xmlns=\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\">-1</int>"]];
                    break;
                }
            }
        }

        strRegion = [[NSMutableString alloc]init];

        for (int i=0; i<[arrayRegion count]; i++)
        {
            objectDropDown = arrayRegion[i];
            
            if (![objectDropDown.strDropDownValue isEqualToString:@"All"])
            {
                if (objectDropDown.isSelected==true)
                {
                    [strRegion appendString:[NSString stringWithFormat:@"<int xmlns=\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\">%@</int>",objectDropDown.dropDownID]];
                }
            }
            else
            {
                if (objectDropDown.isSelected==true)
                {
                    [strRegion appendString:[NSString stringWithFormat:@"<int xmlns=\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\">-1</int>"]];
                    break;
                }
            }
        }
        
        if ([strVariant isEqualToString:@""])
        {
            SMAlert(KLoaderTitle, KVariantSelection);
        }
        else if ([strRegion isEqualToString:@""])
        {
            SMAlert(KLoaderTitle, KRegionSelection);
        }
        else
        {
            [self webserviceForAddToWantedList];
        }
    }
}
-(IBAction)btnSearchAllDidClicked:(id)sender
{
    if (arrayWantedSearch.count>0)
    {
        isClicked = YES;
        
        [self webserviceForListActiveWantedSearchCount];
    }
}
-(IBAction)btnCancelDidClicked:(id)sender
{
    [self hidePopUpView];
}
-(IBAction)btnDoneDidClicked:(id)sender
{
    switch (selectedIndex)
    {
        case 0:
            [self.txtToYear     setText:@""];
            [self.txtFromYear   setText:arrayYears[selectedRowFromYear]];
            [self.txtToYear     setUserInteractionEnabled:YES];
            [self.txtMake       setUserInteractionEnabled:NO];
            [self.txtModel      setUserInteractionEnabled:NO];
            [self.txtVariant    setUserInteractionEnabled:NO];

            selectedRowToYear = arrayYears.count-1;
            break;
            
        case 1:
            [self.txtMake       setUserInteractionEnabled:YES];
            [self.txtModel      setUserInteractionEnabled:NO];
            [self.txtVariant    setUserInteractionEnabled:NO];

            if (selectedRowToYear>=selectedRowFromYear)
            {
                [self.txtToYear setText:arrayYears[selectedRowToYear]];
            }
            else
            {
                [self.txtToYear setText:@""];
                selectedRowToYear = arrayYears.count-1;
                
                SMAlert(KLoaderTitle, KProperYear);
            }
            break;
    }
    
    [self.txtMake setText:@""];
    [self.txtModel setText:@""];
    makeID = 0;
    modelID = 0;
    [arrayMake removeAllObjects];
    [arrayModel removeAllObjects];
    [self.tableVariant setAlpha:0.0f];
    [self.txtVariant setAlpha:1.0f];
    [self hidePopUpView];
}

- (void)btnSearchDidClicked:(id)sender
{
    UIButton *btn = (UIButton*)sender;

    objectDropDown = [arrayWantedSearch objectAtIndex:btn.tag];
    
    if (btn.titleLabel.text.intValue!=0)
    {
        SMWantedDetailViewController *detailVC = [[SMWantedDetailViewController alloc]initWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? @"SMWantedDetailViewController" : @"SMWantedDetailViewController_iPad" bundle:nil];
        
        detailVC.navigationItem.titleView = [SMCustomColor setTitle:objectDropDown.FriendlyName];
        detailVC.objectDropDown = objectDropDown;
        detailVC.count = btn.titleLabel.text.intValue;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        if ([objectDropDown.Results isEqualToString:@""] || [objectDropDown.Results rangeOfString:@""].location!=NSNotFound)
        {
            indexRow = btn.tag;
            [self webserviceForSearchResultCount:objectDropDown.iWantedSearchID];
        }
    }
}

#pragma mark - Load/Hide Drop Down For Make, Model And Variants

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

#pragma mark - customTextView

- (void)customTextView
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.lblWantedList                 setFont:[UIFont fontWithName:FONT_NAME_BOLD size:15.0f]];
        [self.lblSwipe                      setFont:[UIFont fontWithName:FONT_NAME      size:13.0f]];
        [self.btnSearchAll.titleLabel       setFont:[UIFont fontWithName:FONT_NAME_BOLD size:15.0f]];
        [self.btnHeaderFilter.titleLabel    setFont:[UIFont fontWithName:FONT_NAME      size:15.0f]];
        [self.btnDone.titleLabel            setFont:[UIFont fontWithName:FONT_NAME      size:15.0f]];
        [self.btnCancel.titleLabel          setFont:[UIFont fontWithName:FONT_NAME      size:15.0f]];
        self.txtVariant.placeholder         = @" Select Variant";
    }
    else
    {
        [self.lblWantedList                 setFont:[UIFont fontWithName:FONT_NAME_BOLD size:25.0f]];
        [self.lblSwipe                      setFont:[UIFont fontWithName:FONT_NAME      size:18.0f]];
        [self.btnSearchAll.titleLabel       setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0f]];
        [self.btnHeaderFilter.titleLabel    setFont:[UIFont fontWithName:FONT_NAME      size:20.0f]];
        [self.btnDone.titleLabel            setFont:[UIFont fontWithName:FONT_NAME      size:20.0f]];
        [self.btnCancel.titleLabel          setFont:[UIFont fontWithName:FONT_NAME      size:20.0f]];
        self.txtVariant.placeholder         = @"Select Variant";
    }
    
    NSAttributedString *lostPasswordAttributedString = [[NSAttributedString alloc]initWithString:@"Search All" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithRed:52.0f/255.0f green:118.0f/255.0f blue:190.0f/255.0f alpha:1.0f]}];
    
    [self.btnSearchAll setAttributedTitle:lostPasswordAttributedString forState:UIControlStateNormal];
    
    self.txtVariant.layer.borderColor   = [[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtVariant.layer.borderWidth   = 0.8f;
    self.txtVariant.placeholderColor    = [UIColor whiteColor];

    self.viewRegion.layer.borderColor    = [[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.viewRegion.layer.borderWidth    = 0.8f;
    
    self.tableVariant.layer.borderColor   = [[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.tableVariant.layer.borderWidth   = 0.8f;
    
    self.viewTablePopUp.layer.cornerRadius  = 10.0;
    self.viewTablePopUp.clipsToBounds       = YES;

    self.viewPickerPopUp.layer.cornerRadius  = 10.0;
    self.viewPickerPopUp.clipsToBounds       = YES;
    
    [self.tableWanted setTableFooterView:[[UIView alloc]init]];
    [self.tablePopUp  setTableFooterView:[[UIView alloc]init]];

    [self.btnHeaderFilter       setSelected:YES];
    
    [self.btnSearchAll          setExclusiveTouch:YES];
    [self.btnAddToWantedList    setExclusiveTouch:YES];

    [self.tableVariant setAlpha:0.0f];
    [self.txtVariant setAlpha:1.0f];
    
    isClicked = NO;
    
    selectedMakeIndex = -1;
    selectedModelIndex = -1;
}

#pragma mark - getYearArray

- (void)getYearArray
{
    formatter       = [[NSDateFormatter alloc] init];
    [formatter         setDateFormat:@"yyyy"];
    currentYear     = [[formatter stringFromDate:[NSDate date]] intValue];
    
    arrayYears = [[NSMutableArray alloc]init];
    
    for (int fromYear = 1990; fromYear<=currentYear; fromYear++)
    {
        [arrayYears addObject:[NSString stringWithFormat:@"%d",fromYear]];
    }
    
    // initially Start Year as 2006 and 2006 is at 16th index
    
    selectedRowFromYear = initialStartYear;
    
    // by default selected year will current year
    
    selectedRowToYear = arrayYears.count-1;
    
    [self.pickerYear reloadAllComponents];
}

#pragma mark - registerNib

- (void)registerNib
{
    [self.tableWanted registerNib:[UINib nibWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? @"SMWantedTableViewCell" : @"SMWantedTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMWantedTableViewCellIdentifier"];
    
    [self.tableVariant registerNib:[UINib nibWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? @"SMVariantTableViewCell" : @"SMVariantTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMVariantTableViewCellIdentifier"];

    [self.tableRegion registerNib:[UINib nibWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? @"SMVariantTableViewCell" : @"SMVariantTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMRegionTableViewCellIdentifier"];
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
#pragma mark - XML Parsing Delegates

// once all fetching is done xml parsing will called

-(void) parser:(NSXMLParser *)    parser
didStartElement:(NSString *)   elementName
  namespaceURI:(NSString *)      namespaceURI
 qualifiedName:(NSString *)     qName
    attributes:(NSDictionary *)    attributeDict
{
    if ([elementName isEqualToString:@"Make"] || [elementName isEqualToString:@"model"] || [elementName isEqualToString:@"Variant"] || [elementName isEqualToString:@"Region"] || [elementName isEqualToString:@"Search"])
    {
        objectDropDown  = [[SMDropDownObject alloc] init];
    }
    if ([elementName isEqualToString:@"AddWantedResult"])
    {
        isWanted = isAddWanted;
    }
    if ([elementName isEqualToString:@"RemoveWantedResult"])
    {
        isWanted = isRemoveWanted;
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *string = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"id"] || [elementName isEqualToString:@"ID"])
    {
        objectDropDown.dropDownID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"name"] || [elementName isEqualToString:@"Name"])
    {
        objectDropDown.strDropDownValue = currentNodeContent;
        objectDropDown.isSelected = false;
    }
    if ([elementName isEqualToString:@"Make"])
    {
        [arrayMake addObject:objectDropDown];
    }
    if ([elementName isEqualToString:@"model"])
    {
        [arrayModel addObject:objectDropDown];
    }
    if ([elementName isEqualToString:@"ListMakesXMLResult"])
    {
        [self.tablePopUp reloadData];
        
        if (arrayMake.count>0)
        {
            [self loadPopUpView];
        }
        else
        {
            SMAlert(KLoaderTitle, KNorecordsFousnt);
        }
    }
    if ([elementName isEqualToString:@"ListModelsXMLResult"])
    {
        [self.tablePopUp reloadData];
        
        if (arrayModel.count>0)
        {
            [self loadPopUpView];
        }
        else
        {
            SMAlert(KLoaderTitle, KNorecordsFousnt);
        }
    }
    
    // for getting all regions
    if ([elementName isEqualToString:@"Region"])
    {
        [arrayRegion addObject:objectDropDown];
    }
    
    // for getting all variants
    if ([elementName isEqualToString:@"Variant"])
    {
        [arrayVariant addObject:objectDropDown];
    }
    
    if ([elementName isEqualToString:@"ListVariantsXMLResult"])
    {
        if (arrayVariant.count>0)
        {
            SMDropDownObject *objDrop = [SMDropDownObject new];
            objDrop.isSelected = false;
            objDrop.strDropDownValue = @"All";
            objDrop.dropDownID = 0;
            
            [arrayVariant insertObject:objDrop atIndex:0];
            [self.tableVariant setAlpha:1.0f];
            [self.txtVariant setAlpha:0.0f];
        }
        else
        {
            [self.tableVariant setAlpha:0.0f];
            [self.txtVariant setAlpha:1.0f];
        }
        
        [self.tableVariant reloadData];
    }
    if ([elementName isEqualToString:@"RegionListResult"])
    {
        if (arrayRegion.count>0)
        {
            SMDropDownObject *objDrop = [SMDropDownObject new];
            objDrop.isSelected = false;
            objDrop.strDropDownValue = @"All";
            objDrop.dropDownID = 0;
            
            [arrayRegion insertObject:objDrop atIndex:0];
        }
        
        [self.tableRegion reloadData];
    }

    // for getting all wanted
    if ([elementName isEqualToString:@"WantedSearchID"])
    {
        objectDropDown.iWantedSearchID = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"VariantID"])
    {
        objectDropDown.iVariantID = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"FriendlyName"])
    {
        objectDropDown.FriendlyName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"YearRange"])
    {
        objectDropDown.YearRange = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Results"])
    {
        objectDropDown.Results = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Provinces"])
    {
        if ([currentNodeContent isEqualToString:@"-1"])
        {
            objectDropDown.Provinces = @"All";
        }
        else
        {
            objectDropDown.Provinces = currentNodeContent;
        }
    }
    if ([elementName isEqualToString:@"Search"])
    {
        [arrayWantedSearch addObject:objectDropDown];
    }
    
    if ([elementName isEqualToString:@"ListActiveWantedSearchXMLResult"] || [elementName isEqualToString:@"ListActiveWantedSearchWithCountXMLResult"])
    {
        [self.tableWanted reloadData];
    }
    
    // for removing wanted
    if ([elementName isEqualToString:@"Status"] || [elementName isEqualToString:@"Error"])
    {
        if (isWanted==isAddWanted)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Wanted added successfully" cancelButtonTitle:@"Ok" otherButtonTitles:nil];

                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
                {
                    if (didCancel)
                    {
                        [self.txtFromYear setText:@""];
                        [self.txtToYear setText:@""];
                        [self.txtMake setText:@""];
                        [self.txtModel setText:@""];
                        
                        makeID = 0;
                        modelID = 0;
                        [self.tableVariant setAlpha:0.0f];
                        [self.txtVariant setAlpha:1.0f];
                        selectedRowFromYear = initialStartYear;
                        selectedRowToYear = arrayYears.count-1;
                        
                        selectedMakeIndex = -1;
                        selectedModelIndex = -1;
                        
                        [self.txtFromYear setUserInteractionEnabled:YES];
                        [self.txtToYear setUserInteractionEnabled:NO];
                        [self.txtMake setUserInteractionEnabled:NO];
                        [self.txtModel setUserInteractionEnabled:NO];
                        [self.txtVariant setUserInteractionEnabled:NO];

                        for (objectDropDown in arrayRegion)
                        {
                           objectDropDown.isSelected = false;
                        }
                        
                        [self.tableRegion reloadData];
                        
                        if (isClicked==YES)
                        {
                            [self webserviceForListActiveWantedSearchCount];
                        }
                        else
                        {
                            [HUD show:YES];
                            [HUD setLabelText:KLoaderText];
                            [self webserviceForListActiveWantedSearch];
                        }
                    
                        return;
                    }
                }];
            });
        }
        else if (isWanted==isRemoveWanted)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Wanted deleted successfully" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
                {
                     if (didCancel)
                     {
                         [arrayWantedSearch removeObjectAtIndex:indexRemoved.row];
                         [self.tableWanted deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexRemoved, nil] withRowAnimation:UITableViewRowAnimationRight];
                         
                         return;
                     }
                 }];
            });
        }
    }
    if ([elementName isEqualToString:@"SearchResultCountResult"])
    {
        objectDropDown = arrayWantedSearch[indexRow];
        
        objectDropDown.Results = currentNodeContent;
        
        [self.tableWanted reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexRow inSection:1], nil] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
}

#pragma mark - validation

-(BOOL)validation
{
    if (self.txtFromYear.text.length==0)
    {
        SMAlert(KLoaderTitle, KStartYearSelection);

        return NO;
    }
    else if (self.txtToYear.text.length==0)
    {
        SMAlert(KLoaderTitle, KEndYearSelection);

        return NO;
    }
    else if (self.txtMake.text.length==0)
    {
        SMAlert(KLoaderTitle, KMakeSelection);
        
        return NO;
    }
    else if (self.txtModel.text.length==0)
    {
        SMAlert(KLoaderTitle, KModelSelection);
       
        return NO;
    }

    else
        return YES;
}

- (NSString*)convertYear:(NSString*)iYear
{
    NSArray *arr = [iYear componentsSeparatedByString:@"-"];
    
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc]init];
    [yearFormatter setDateFormat:@"yy"];
    
    NSString *str1 = [yearFormatter stringFromDate:[yearFormatter dateFromString:arr[0]]];
    NSString *str2 = [yearFormatter stringFromDate:[yearFormatter dateFromString:arr[1]]];

    return [NSString stringWithFormat:@"%@ - %@",str1,str2];
}

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
