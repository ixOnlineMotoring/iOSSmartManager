//
//  SMVehicleStockListViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 09/02/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMVehicleStockListViewController.h"
#import "CustomListingTableViewCell.h"
#import "SMCustomTextField.h"
#import "SMCustomPopUpTableView.h"
#import "SMDropDownObject.h"
#import "SMVehicleStockDetailViewController.h"
#import "SMCommonClassMethods.h"
#import "UIBAlertView.h"
@interface SMVehicleStockListViewController ()
{
    
    IBOutlet UIImageView *imgviwArrow;
    IBOutlet UITableView *tblVehicleStockList;
    IBOutlet UIView *viewTableHeader;
    
    IBOutlet SMCustomTextField *txtKeywordSearch;
    IBOutlet SMCustomTextField *txtSort;
    NSMutableArray *arrmForSort;
    NSArray *arrSort;
    IBOutlet UISegmentedControl *segmentcontrolForStaus;
    
    

    IBOutlet UILabel *lblRetail;
    IBOutlet UILabel *lblExcluded;
    IBOutlet UILabel *lblInvalid;
    IBOutlet UILabel *lblAll;
    
    UILabel *lblReference;
}

- (IBAction)btnShowHideDidClicked:(id)sender;
- (IBAction)segmentcontrolForStausDidClicked:(id)sender;

@end

@implementation SMVehicleStockListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addingProgressHUD];
    hasUserChangedTheDefaultSortOption = NO;
    isTheAttemtFirst = YES;
    imgSortOderIcon.hidden = YES;
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Stock List"];
    arrmForSort = [[NSMutableArray alloc] init];
#warning Sandeep - Changing  None to -- None --
    arrSort = [[NSArray alloc] initWithObjects:@"-- None --",@"Age",@"Comments",@"Extras",@"Milage",@"Photos",@"Price",@"stock#",@"Year" ,nil];
    
    [self getSortDropDown];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [self setLabel:lblRetail];
    tblVehicleStockList.estimatedRowHeight = 135.0f;
    tblVehicleStockList.rowHeight = UITableViewAutomaticDimension;
   // tblVehicleStockList.tableHeaderView = viewTableHeader;
    tblVehicleStockList.tableFooterView = [[UIView alloc]init];
    
    [tblVehicleStockList registerNib:[UINib nibWithNibName:@"CustomListingTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomListingTableViewCell"];
    
    isCompletedLoading=YES;
    isLoadMore=NO;
    StatusIDForChoices = 1;
    hasUserChangedTheDefaultSortOption = NO;
    selectedRow = -1;
    isSearchResult = NO;
    btnShowFilter.selected = NO;
    photosAndExtrasArray = [[NSMutableArray alloc]init];
   segmentcontrolForStaus.tintColor = [UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0];
    {
        pageNumberCount=0;
        oldArrayCount=0;
        
        if([txtSort.text length]!=0)
        {
            SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
            
            int sortOrder;
            
            if(objectForRow.isAscending)
                sortOrder = 1;
            else
                sortOrder = 2;
            
            if([txtKeywordSearch.text length] != 0)
                [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
            else
                [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
            
        }
        else
        {
            
                if([txtKeywordSearch.text length] != 0)
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"friendlyname"];
                else
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
            
        }
        
    }

    imgviwArrow.image = [UIImage imageNamed:@"down_arrowSelected"];
    CGRect newFrame = viewTableHeader.frame;
    btnShowFilter.selected = YES;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        newFrame.size.height = 145.0f;
    }
    else
    {
        newFrame.size.height = 200.0f;
    }
    
    viewTableHeader.frame = newFrame;
    [tblVehicleStockList setTableHeaderView:viewTableHeader];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [self headerview];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}
-(void) headerview{
    
    UIView *headerView = tblVehicleStockList.tableHeaderView;
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    CGFloat height;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
     height= 38.0f;
    }
    else
    {
      height=   45.0f;
    }
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    tblVehicleStockList.tableHeaderView = headerView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) getSortDropDown
{
    
    for(int i=0;i<arrSort.count;i++)
    {
        SMDropDownObject *objCondition = [[SMDropDownObject alloc] init];
        objCondition.strMakeId = [NSString stringWithFormat:@"%d",i+1];
        objCondition.strSortText = [arrSort objectAtIndex:i];
        objCondition.strMakeName = [arrSort objectAtIndex:i];
        objCondition.isAscending = NO;
        [arrmForSort addObject:objCondition];
    }
    
}
#pragma mark - Table View Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return photosAndExtrasArray.count;
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomListingTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"CustomListingTableViewCell"];
    
    SMPhotosAndExtrasObject *photoObject=(SMPhotosAndExtrasObject *)[photosAndExtrasArray objectAtIndex:indexPath.row];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.lblDetailFirst setAttributedText:[self setAttributeForFirstDetailfirstText:photoObject.strUsedYear secondText:photoObject.strVehicleName color:[UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0]]];
    
    [cell.lblDetailSecond setAttributedText:[self setAttributeForSecondDetailfirstText:photoObject.strRegistration secondText:photoObject.strColour thirdText:photoObject.strStockCode withColor:[UIColor whiteColor]]];
    
     [cell.lblDetailThird setAttributedText:[self setAttributeForSecondDetailfirstText:photoObject.strVehicleType secondText:[NSString stringWithFormat:@"%@ Km",photoObject.strMileage] thirdText:photoObject.strDays withColor:[UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0]]];
    
    [cell.lblDetailFourth setAttributedText: [self setAttributeForFourthDetailfirstText:@"Ret." secondText:photoObject.strRetailPrice colorFirst:[UIColor greenColor] thirdText:@"Trd." fourthText:photoObject.strTradePrice colorSecond:[UIColor colorWithRed:187.0f/255.0f green:140.0f/255.0f blue:20.0f/255.0f alpha:1.0]]];
    
    
    [cell.lblDetailFifth setAttributedText:[self setAttributeForFirstDetailfirstText:(photoObject.strExtras) ? @"abc" : @"" secondText:(photoObject.strComments) ? @"abc" : @"" thirdText:photoObject.strPhotoCounts fourthText:photoObject.strVideosCount]];
    
    if (photosAndExtrasArray.count-1 == indexPath.row)
    {
        ++pageNumberCount;
        isLoadMore=YES;
        
        if([txtSort.text length]!=0)
        {
            SMDropDownObject *objectForRow = (SMDropDownObject*)[arrmForSort objectAtIndex:selectedRow];
            
            int sortOrder;
            
            if(objectForRow.isAscending)
                sortOrder = 1;
            else
                sortOrder = 2;
            
            
            
            if([txtKeywordSearch.text length] != 0)
            {
                if (photosAndExtrasArray.count !=iTotalArrayCount)
                {
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
                }
            }
            
            else
            {
                if (photosAndExtrasArray.count !=iTotalArrayCount)
                {
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
                }
            }
        }
        else
        {
            if([txtKeywordSearch.text length] != 0)
            {
                if (photosAndExtrasArray.count !=iTotalArrayCount)
                {
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"friendlyname"];
                }
            }
            else
            {
                if (photosAndExtrasArray.count !=iTotalArrayCount)
                {
                    
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
                }
            }
        }
    }
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     SMPhotosAndExtrasObject *selectedPhotoObject = (SMPhotosAndExtrasObject *)[photosAndExtrasArray objectAtIndex:indexPath.row];
    
    SMVehicleStockDetailViewController *vehicleStockViewController = [[SMVehicleStockDetailViewController alloc]initWithNibName:@"SMVehicleStockDetailViewController" bundle:nil];
    vehicleStockViewController.photosExtrasObject = selectedPhotoObject;
   
    [self.navigationController pushViewController:vehicleStockViewController animated:YES];
}

#pragma mark - TextField Delegate
- (void)textFieldDidBeginEditing:(SMCustomTextField *)textField
{
    
    if(textField.tag == 10)
    {
        
        
        [self.view endEditing:YES];
        /*************  your Request *******************************************************/
        [textField resignFirstResponder];
        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
        SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
        
         if(isTheAttemtFirst)
         {
             isTheAttemtFirst = NO;
             [popUpView getTheDropDownData:arrmForSort withVariant:NO andIsPagination:NO ifSort:YES andIsFirstTimeSort:YES]; // array to be passed for custom popup dropdown
         }
         else
         {
             [popUpView getTheDropDownData:arrmForSort withVariant:NO andIsPagination:NO ifSort:YES andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
         }
        
        [self.view addSubview:popUpView];
        
        /*************  your Request *******************************************************/
        /*************  your Response *******************************************************/
        
        [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear)
        {
            NSLog(@"selected text = %@",selectedTextValue);
            NSLog(@"selected ID = %d",selectIDValue);
            
            if(selectIDValue != 1)
            {
                imgSortOderIcon.hidden = NO;
                if(minYear == 1)
                {
                    textField.text = [NSString stringWithFormat:@"%@ (Ascending)",selectedTextValue];
                    CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrow"]CGImage];
                    
                    UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationDown];
                    [imgSortOderIcon setImage:rotatedImage];
                }
                else
                {
                    textField.text = [NSString stringWithFormat:@"%@ (Descending)",selectedTextValue];
                    CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrow"]CGImage];
                    
                    UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
                    [imgSortOderIcon setImage:rotatedImage];
                }
            }
            else
            {
                textField.text = selectedTextValue;
                imgSortOderIcon.hidden = YES;
            }
            
            selectedRow = selectIDValue-1;
            hasUserChangedTheDefaultSortOption = YES;
            
            {
                
                pageNumberCount=0;
                oldArrayCount=0;
                [photosAndExtrasArray removeAllObjects];
               
                
               /* SMDropDownObject *objectCellForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
                
                
                if(objectCellForRow.isAscending)
                {
                    selectedCell.imgAscDesc.transform = CGAffineTransformMakeRotation(M_PI);
                    if([objectDidSelectForRow.strSortText isEqualToString:@"None"])
                        [self.txtFieldSort setText:objectDidSelectForRow.strSortText];
                    else
                    {
                        [self.txtFieldSort setText:[NSString stringWithFormat:@"%@ (Ascending)",objectDidSelectForRow.strSortText]];
                
                        CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrow"]CGImage];
                        
                        UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationDown];
                        [self.imageUpDownArrow setImage:rotatedImage];
                        
                    }
                    
                }
                else
                {
                    selectedCell.imgAscDesc.transform = CGAffineTransformMakeRotation(0);
                    if([objectDidSelectForRow.strSortText isEqualToString:@"None"])
                        [self.txtFieldSort setText:objectDidSelectForRow.strSortText];
                    else
                        [self.txtFieldSort setText:[NSString stringWithFormat:@"%@ (Descending)",objectDidSelectForRow.strSortText]];
                    CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrow"]CGImage];
                    
                    UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
                    [self.imageUpDownArrow setImage:rotatedImage];
                }*/
                
                SMDropDownObject *objectForRow = (SMDropDownObject*)[arrmForSort objectAtIndex:selectIDValue-1];
                
                int sortOrder;
                
                if(minYear == 1)
                    sortOrder = 1;
                else
                    sortOrder = 2;
                
                if([txtKeywordSearch.text length] != 0)
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectIDValue-1 andSortOrder:sortOrder]];
                else
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectIDValue-1 andSortOrder:sortOrder]];
                
                [tblVehicleStockList reloadData];
                
            }
            
            
        }];
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtKeywordSearch)
    {
        
        [textField resignFirstResponder];
        
        if([txtKeywordSearch.text length]!=0)
        {
            isLoadMore = NO;
            [self callTheWebServiceForSearch];
        }
        else
        {
            [photosAndExtrasArray removeAllObjects];
            [tblVehicleStockList reloadData];
            
            pageNumberCount=0;
            oldArrayCount  =0;
            
            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
           
        }
        return NO;
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [downloadingQueue cancelAllOperations];
    return YES;
}

-(void)loadPhotosAndExtrasWSWithStatusID:(int)statusID andSortText:(NSString*)sortText
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingVehiclePhotosAndExtrasList:[SMGlobalClass sharedInstance].hashValue withstatusID:statusID withClientID:[[SMGlobalClass sharedInstance].strClientID intValue] withPageSize:10 withPageNumber:pageNumberCount sort:sortText andNewUsed:@""];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    isListingDataBeingFetched = YES;
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         isListingDataBeingFetched = NO;
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             
             if (!isLoadMore)
             {
                 [photosAndExtrasArray removeAllObjects];
                 
             }
             
             
             xmlPEParser = [[NSXMLParser alloc] initWithData:data];
             [xmlPEParser setDelegate: self];
             [xmlPEParser setShouldResolveExternalEntities:YES];
             [xmlPEParser parse];
         }
     }];
}

-(void)loadPhotosAndExtrasWithSearchWSWithStatusCode:(int)statusCode andSortText:(NSString*)sortText
{
        [HUD show:YES];
       [HUD setLabelText:KLoaderText];
    
    //[[MGProgressObject sharedInstance] showProgressHUDWithText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices filterThePhotosNExtrasBasedOnSearchWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andsearchKeyword:txtKeywordSearch.text andPageSize:10 andPageNumber:pageNumberCount andStatus:statusCode andSortText:sortText andNewUsed:@""];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    isListingDataBeingFetched = YES;
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         isListingDataBeingFetched = NO;
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             //[[MGProgressObject sharedInstance] hideProgressHUD];
             [HUD hide:YES];
             
         }
         else
         {
            // NSLog(@"Resposen is %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
             
             
             if (!isLoadMore)
             {
                 [photosAndExtrasArray removeAllObjects];
             }
             xmlPEParser = [[NSXMLParser alloc] initWithData:data];
             [xmlPEParser setDelegate: self];
             [xmlPEParser setShouldResolveExternalEntities:YES];
             [xmlPEParser parse];
         }
     }];
}

-(void)callTheWebServiceForSearch
{
    
    pageNumberCount=0;
    oldArrayCount=0;
    
    if([txtSort.text length]!=0 )
    {
        if(!hasUserChangedTheDefaultSortOption)
        {
            
            if([txtKeywordSearch.text length] != 0)
            {
                
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"friendlyname"];
            }
            else
            {
                [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
                
            }
            
            
        }
        else
        {
            SMDropDownObject *objectForRow = (SMDropDownObject*)[arrmForSort objectAtIndex:selectedRow];
            
            int sortOrder;
            
            if(objectForRow.isAscending)
                sortOrder = 1;
            else
                sortOrder = 2;
            
            if([txtKeywordSearch.text length] != 0)
                [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
            else
                [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
        }
        
    }
    else
    {
        
        if([txtKeywordSearch.text length] != 0)
        {
            
                [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"friendlyname"];
        }
        else
        {
            
            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
            
        }
        
        
    }
    
    
    
}
-(NSString*)sortOptionSelectedWithSortIndex:(int)sortIndex andSortOrder:(int)sortOrder
{
    
    switch (sortIndex)
    {
            
        case 0:
        {
            if(sortOrder == 1)
            {
                return @"friendlyname";
               
            }
            else
            {
               
                return @"friendlyname";
                
            }
            
            
        }
            break;
            
            
            
        case 1:
        {
            if(sortOrder == 1)
                return @"age:asc";
            else
                return @"age:desc";
            
        }
            break;
            
        case 2:
        {
            if(sortOrder == 1)
                return @"comments:asc";
            else
                return @"comments:desc";
            
        }
            break;
            
        case 3:
        {
            if(sortOrder == 1)
                return @"extras:asc";
            else
                return @"extras:desc";
        }
            break;
            
        case 4:
        {
            if(sortOrder == 1)
                return @"mileage:asc";
            else
                return @"mileage:desc";
        }
            break;
            
        case 5:
        {
            if(sortOrder == 1)
                return @"photos:asc";
            else
                return @"photos:desc";
        }
            break;
            
        case 6:
        {
            if(sortOrder == 1)
                return @"price:asc";
            else
                return @"price:desc";
        }
            break;
            
        case 7:
        {
            if(sortOrder == 1)
                return @"stockcode:asc";
            else
                return @"stockcode:desc";
        }
            break;
            
        case 8:
        {
            if(sortOrder == 1)
                return @"usedyear:asc";
            else
                return @"usedyear:desc";
        }
            break;
        default:
            break;
            
    }
    
    return @"";
}

#pragma mark - xmlParserDelegate
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"ListVehiclesByStatusXMLResponse"])
    {
    }
    
    if ([elementName isEqualToString:@"stock"])
    {
        loadPhotosAndExtrasObject=[[SMPhotosAndExtrasObject alloc]init];
    }
    currentNodeContent = [NSMutableString stringWithString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *str = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    
    
    if ([elementName isEqualToString:@"stockCode1"])
    {
        if([currentNodeContent length] == 0)
        {
            loadPhotosAndExtrasObject.strStockCode=@"Stock code?";
            loadPhotosAndExtrasObject.stockIDForSorting = 0;
        }
        else
        {
            loadPhotosAndExtrasObject.strStockCode=[[SMCommonClassMethods shareCommonClassManager]flattenHTML:currentNodeContent];
            loadPhotosAndExtrasObject.stockIDForSorting = [currentNodeContent intValue];
        }
        
    }
    else if ([elementName isEqualToString:@"registration"])
    {
        {
            if([currentNodeContent isEqualToString:@"(null)"] || [currentNodeContent isEqualToString:@""] || [currentNodeContent isEqualToString:@"No Registration"] || [currentNodeContent isEqualToString:@"0"])
            {
                loadPhotosAndExtrasObject.strRegistration=@"Reg?";//registration
            }
            else
            {
                loadPhotosAndExtrasObject.strRegistration=currentNodeContent;//registration
            }
        }
        
    }
    else if ([elementName isEqualToString:@"department"])
    {
        if ([currentNodeContent isEqualToString:@""])
        {
            loadPhotosAndExtrasObject.strVehicleType = @"Type?";
        }
        else
        {
            loadPhotosAndExtrasObject.strVehicleType = currentNodeContent;
        }
        
    }
    else if ([elementName isEqualToString:@"vehicleName"])
    {
        if ([currentNodeContent isEqualToString:@""])
        {
            loadPhotosAndExtrasObject.strVehicleName=@"Name?";
        }
        else
        {
            loadPhotosAndExtrasObject.strVehicleName=currentNodeContent;
        }
    }
    else if ([elementName isEqualToString:@"usedYear"])
    {
        loadPhotosAndExtrasObject.strUsedYear=currentNodeContent;
    }
    else if ([elementName isEqualToString:@"colour"])
    {
        
        if ([currentNodeContent isEqualToString:@""] || [currentNodeContent isEqualToString:@"No colour #"])
        {
            loadPhotosAndExtrasObject.strColour=@"Colour?";
        }
        else
        {
            loadPhotosAndExtrasObject.strColour=currentNodeContent;
        }
    }
    else if ([elementName isEqualToString:@"mileage"])
    {
        if ([currentNodeContent length] == 0)
        {
            loadPhotosAndExtrasObject.strMileage = @"Mileage?";
            loadPhotosAndExtrasObject.mileageForSorting = 0;
        }
        else
        {
            loadPhotosAndExtrasObject.strMileage= [[SMCommonClassMethods shareCommonClassManager]mileageConvertEn_AF:currentNodeContent];
            loadPhotosAndExtrasObject.mileageForSorting = [currentNodeContent intValue];
        }
        
        
    }
    else if ([elementName isEqualToString:@"photos"])
    {
        loadPhotosAndExtrasObject.strPhotoCounts=currentNodeContent;
        loadPhotosAndExtrasObject.photosForSorting = [currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"videos"])
    {
        loadPhotosAndExtrasObject.strVideosCount =currentNodeContent;
        
    }
    else if ([elementName isEqualToString:@"imageLink"])
    {
        loadPhotosAndExtrasObject.strImageLink=currentNodeContent;
    }
    else if ([elementName isEqualToString:@"comments"])
    {
        loadPhotosAndExtrasObject.strComments=currentNodeContent.boolValue;
        loadPhotosAndExtrasObject.commentsForSorting = [currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"extras"])
    {
        loadPhotosAndExtrasObject.strExtras=currentNodeContent.boolValue;
        loadPhotosAndExtrasObject.extrasForSorting = [currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"makeName"])
    {
        loadPhotosAndExtrasObject.strMakeName=currentNodeContent;
    }
    else if ([elementName isEqualToString:@"age"])
    {
        loadPhotosAndExtrasObject.strDays=[NSString stringWithFormat:@"%@ Days",currentNodeContent];
        loadPhotosAndExtrasObject.numOfDaysForSorting = [currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"price"])
    {
        if([currentNodeContent length] == 0 || [currentNodeContent intValue] == 0)
        {
            loadPhotosAndExtrasObject.strRetailPrice=@"R?";
            loadPhotosAndExtrasObject.priceForSorting = 0;
        }
        else
        {
            loadPhotosAndExtrasObject.strRetailPrice=[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:currentNodeContent];
            loadPhotosAndExtrasObject.priceForSorting = [currentNodeContent intValue];
        }
    }
    else if ([elementName isEqualToString:@"tradePrice"])
    {
        if([currentNodeContent length] == 0 || [currentNodeContent intValue] == 0)
        {
            loadPhotosAndExtrasObject.strTradePrice=@"R?";
            
        }
        else
        {
            loadPhotosAndExtrasObject.strTradePrice=[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:currentNodeContent];
            
        }
    }
    else if ([elementName isEqualToString:@"usedVehicleStockID"])
    {
        loadPhotosAndExtrasObject.strUsedVehicleStockID=currentNodeContent;
    }
    if ([elementName isEqualToString:@"total"])
    {
        iTotalArrayCount = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"totalActive"])
    {
        if(currentNodeContent.intValue == 0)
            [lblRetail setText:@"0"];
        else
            [lblRetail setText:[NSString stringWithFormat:@"(%@)",currentNodeContent]];
    }
    if([elementName isEqualToString:@"totalExcluded"])
    {
        if(currentNodeContent.intValue == 0)
            [lblExcluded setText:@"0"];
        else
            [lblExcluded setText:[NSString stringWithFormat:@"(%@)",currentNodeContent]];
    }
    if([elementName isEqualToString:@"totalAll"])
    {
        if(currentNodeContent.intValue == 0)
            [lblAll setText:@"0"];
        else
            [lblAll setText:[NSString stringWithFormat:@"(%@)",currentNodeContent]];
    }
    if([elementName isEqualToString:@"totalInvalid"])
    {
        if(currentNodeContent.intValue == 0)
            [lblInvalid setText:@"0"];
        else
            [lblInvalid setText:[NSString stringWithFormat:@"(%@)",currentNodeContent]];
    }
    if ([elementName isEqualToString:@"stock"])
    {
        [photosAndExtrasArray addObject:loadPhotosAndExtrasObject];
    }
    if ([elementName isEqualToString:@"ListVehiclesByStatusXMLResponse"] || [elementName isEqualToString:@"ListVehiclesByKeywordStatusXMLResponse"])
    {
        
        if ([photosAndExtrasArray count]!=0)
        {
            if (oldArrayCount==0)
            {
                oldArrayCount=[photosAndExtrasArray count];
            }
            
        }
        else
        {
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:KNorecordsFousnt cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                
            }];
        
        }
        [tblVehicleStockList reloadData];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    tblVehicleStockList.dataSource = self;
    tblVehicleStockList.delegate = self;
    [self hideProgressHUD];
    [HUD hide:YES];
    //[[MGProgressObject sharedInstance] hideProgressHUD];
}


#pragma mark - Button Methods
- (IBAction)btnShowHideDidClicked:(UIButton *)sender {
    
    NSLog(@"isSelected = %d",sender.isSelected);
    sender.selected = !sender.selected;
    NSLog(@"isSelected = %d",sender.isSelected);
    if(sender.selected)
    {
        imgviwArrow.image = [UIImage imageNamed:@"down_arrowSelected"];
        CGRect newFrame = viewTableHeader.frame;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
           newFrame.size.height = 169.0f;
        }
        else
        {
           newFrame.size.height = 200.0f;
        }
        
        viewTableHeader.frame = newFrame;
        [tblVehicleStockList setTableHeaderView:viewTableHeader];
        [tblVehicleStockList reloadData];
    }
    else{
        imgviwArrow.image = [UIImage imageNamed:@"down_arrowT"];
        CGRect newFrame = viewTableHeader.frame;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
              newFrame.size.height = 38.0f;        }
        else
        {
              newFrame.size.height = 45.0f;
        }
     
        viewTableHeader.frame = newFrame;
        [tblVehicleStockList setTableHeaderView:viewTableHeader];
        [tblVehicleStockList reloadData];
    }
    
}


-(void) setLabel:(UILabel*) lable{
    
    [lblReference setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
    [lable setTextColor:[UIColor whiteColor]];
    [lable.superview bringSubviewToFront:lable];
    lblReference = lable;
}
- (IBAction)segmentcontrolForStausDidClicked:(id)sender
{
    
    {
        [photosAndExtrasArray removeAllObjects];
        
        switch (segmentcontrolForStaus.selectedSegmentIndex)
        {
            case 0:
            {
                StatusIDForChoices = 1;
                [self setLabel:lblRetail];
            }
                break;
            case 1:
            {
                StatusIDForChoices = 4;
                [self setLabel:lblExcluded];
            }
                break;
            case 2:
            {
                StatusIDForChoices = 2;
                [self setLabel:lblInvalid];
               
            }
                break;
            case 3:
            {
                 StatusIDForChoices = -1;
                [self setLabel:lblAll];
                
            }
               
                break;
                
            default:
                break;
        }
        
        
        pageNumberCount=0;
        oldArrayCount=0;
        
        
        if([txtSort.text length]!=0)
        {
            SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
            
            int sortOrder;
            
            if(objectForRow.isAscending)
                sortOrder = 1;
            else
                sortOrder = 2;
            
            if([txtKeywordSearch.text length] != 0)
                [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
            else
                [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
            
        }
        else
        {
            
            if([txtKeywordSearch.text length] != 0)
                [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"friendlyname"];
            else
                [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
            
        }
        
        
    }
    
    
    
   ////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
}


#pragma mark - String Attributed Methods
-(NSMutableAttributedString *) setAttributeForFirstDetailfirstText:(NSString *)strfirst secondText:(NSString *)strSecond color:(UIColor *)color {
    
    
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
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     color , NSForegroundColorAttributeName, nil];
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:strfirst
                                                                                           attributes:FirstAttribute];
    
    NSMutableAttributedString *attributedSeparatorText= [[NSMutableAttributedString alloc] initWithString:@" "
                                                                                               attributes:FirstAttribute];
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:strSecond
                                                                                             attributes:SecondAttribute];
    
    
    [attributedFirstText appendAttributedString:attributedSeparatorText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    
    return attributedFirstText;
    
}

-(NSMutableAttributedString *) setAttributeForSecondDetailfirstText:(NSString *)strfirst secondText:(NSString *)strSecond thirdText:(NSString *)strThird withColor:(UIColor *)color{
    
    UIFont *regularFont;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:15];
        
    }
    else
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    
    // Create the attributes
    NSDictionary *Attribute = [NSDictionary dictionaryWithObjectsAndKeys:
                               regularFont, NSFontAttributeName,
                               foregroundColorWhite, NSForegroundColorAttributeName, nil];

    NSDictionary *AttributeForThirdText = [NSDictionary dictionaryWithObjectsAndKeys:
                               regularFont, NSFontAttributeName,
                               color, NSForegroundColorAttributeName, nil];
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:strfirst
                                                                                           attributes:Attribute];
    
    NSMutableAttributedString *attributedSeparatorText= [[NSMutableAttributedString alloc] initWithString:@" | "
                                                                                               attributes:Attribute];
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:strSecond
                                                                                             attributes:Attribute];
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:strThird
                                                                                            attributes:AttributeForThirdText];
    
    
    [attributedFirstText appendAttributedString:attributedSeparatorText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    [attributedFirstText appendAttributedString:attributedSeparatorText];
    [attributedFirstText appendAttributedString:attributedThirdText];
    
    return attributedFirstText;
    
}


-(NSMutableAttributedString *) setAttributeForFourthDetailfirstText:(NSString *)strfirst secondText:(NSString *)strSecond colorFirst:(UIColor *)colorFirst thirdText:(NSString *)strThird fourthText:(NSString *)strFourth colorSecond:(UIColor *)colorSecond{
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
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    
    
    NSDictionary *Attribute = [NSDictionary dictionaryWithObjectsAndKeys:
                               smallFont, NSFontAttributeName,
                               foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     colorFirst , NSForegroundColorAttributeName, nil];
    
    NSDictionary *FourthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     colorSecond , NSForegroundColorAttributeName, nil];
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:strfirst
                                                                                           attributes:Attribute];
    
    NSMutableAttributedString *attributedSeparatorText= [[NSMutableAttributedString alloc] initWithString:@" | "
                                                                                               attributes:Attribute];
    
    NSMutableAttributedString *attributedSpaceText= [[NSMutableAttributedString alloc] initWithString:@" "
                                                                                           attributes:Attribute];
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:strSecond
                                                                                             attributes:SecondAttribute];
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:strThird
                                                                                            attributes:Attribute];
    
    NSMutableAttributedString *attributedFourthText = [[NSMutableAttributedString alloc] initWithString:strFourth
                                                                                             attributes:FourthAttribute];
    
    
    [attributedFirstText appendAttributedString:attributedSpaceText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    [attributedFirstText appendAttributedString:attributedSeparatorText];
    [attributedFirstText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSpaceText];
    [attributedFirstText appendAttributedString:attributedFourthText];
    
    return attributedFirstText;
    
}

-(NSMutableAttributedString *) setAttributeForFirstDetailfirstText:(NSString *)strfirst secondText:(NSString *)strSecond thirdText:(NSString *)strThird fourthText:(NSString *)strfourth{
    
    UIFont *regularFont;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        regularFont = [UIFont fontWithName:FONT_NAME size:12];
        
    }
    else
    {
        regularFont = [UIFont fontWithName:FONT_NAME size:16];
        
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    UIColor *foregroundColorGreen = [UIColor greenColor];
    UIColor *foregroundColorRed = [UIColor redColor];

    
    NSMutableAttributedString *attributedFirstText,*attributedSecondText;
    
    NSDictionary *Attribute = [NSDictionary dictionaryWithObjectsAndKeys:
                               regularFont, NSFontAttributeName,
                               foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *AttributeGreen = [NSDictionary dictionaryWithObjectsAndKeys:
                               regularFont, NSFontAttributeName,
                               foregroundColorGreen, NSForegroundColorAttributeName, nil];
    
    NSDictionary *AttributeRed = [NSDictionary dictionaryWithObjectsAndKeys:
                               regularFont, NSFontAttributeName,
                               foregroundColorRed, NSForegroundColorAttributeName, nil];
    
    NSDictionary *AttributeForThirdText = [NSDictionary dictionaryWithObjectsAndKeys:
                                           regularFont, NSFontAttributeName,
                                           foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    NSMutableAttributedString *attributedExtrasText= [[NSMutableAttributedString alloc] initWithString:@"Extras"
                                                                                           attributes:Attribute];
    NSMutableAttributedString *attributedCommentsText= [[NSMutableAttributedString alloc] initWithString:@"Comments"
                                                                                            attributes:Attribute];
    NSMutableAttributedString *attributedPhotosText= [[NSMutableAttributedString alloc] initWithString:@"Photos"
                                                                                            attributes:Attribute];
    NSMutableAttributedString *attributedVideosText= [[NSMutableAttributedString alloc] initWithString:@"Videos"
                                                                                            attributes:Attribute];


    NSMutableAttributedString *attributedSpaceText= [[NSMutableAttributedString alloc] initWithString:@" "
                                                                                           attributes:Attribute];

    if([strfirst isEqualToString:@""])
    {
        attributedFirstText= [[NSMutableAttributedString alloc] initWithString:@"\u2718"
                                                                    attributes:AttributeRed];
    }
    else
    {
     attributedFirstText = [[NSMutableAttributedString alloc] initWithString:@"\u2713"                                                                                        attributes:AttributeGreen];
    }
    
    if([strSecond isEqualToString:@""])
    {
        attributedSecondText= [[NSMutableAttributedString alloc] initWithString:@"\u2718"
                                                                    attributes:AttributeRed];
    }
    else
    {
        attributedSecondText = [[NSMutableAttributedString alloc] initWithString:@"\u2713"                                                                                        attributes:AttributeGreen];
    }

    NSMutableAttributedString *attributedThirdText= [[NSMutableAttributedString alloc] initWithString:strThird
                                                                                           attributes:AttributeForThirdText];

    NSMutableAttributedString *attributedFourthText= [[NSMutableAttributedString alloc] initWithString:strfourth
                                                                                           attributes:AttributeForThirdText];

    NSMutableAttributedString *attributedSeparatorText= [[NSMutableAttributedString alloc] initWithString:@" | "
                                                                                               attributes:Attribute];

    [attributedExtrasText appendAttributedString:attributedSpaceText];
    [attributedExtrasText appendAttributedString:attributedFirstText];
    [attributedExtrasText appendAttributedString:attributedSpaceText];
    [attributedExtrasText appendAttributedString:attributedSeparatorText];

    [attributedExtrasText appendAttributedString:attributedCommentsText];
    [attributedExtrasText appendAttributedString:attributedSpaceText];
    [attributedExtrasText appendAttributedString:attributedSecondText];
    [attributedExtrasText appendAttributedString:attributedSpaceText];
    [attributedExtrasText appendAttributedString:attributedSeparatorText];
    
   
    [attributedExtrasText appendAttributedString:attributedPhotosText];
    [attributedExtrasText appendAttributedString:attributedSpaceText];
    [attributedExtrasText appendAttributedString:attributedThirdText];
    [attributedExtrasText appendAttributedString:attributedSpaceText];
    [attributedExtrasText appendAttributedString:attributedSeparatorText];
    
    [attributedExtrasText appendAttributedString:attributedVideosText];
    [attributedExtrasText appendAttributedString:attributedSpaceText];
    [attributedExtrasText appendAttributedString:attributedFourthText];
    
    return attributedExtrasText;
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


@end
