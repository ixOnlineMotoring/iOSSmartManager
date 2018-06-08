//
//  SMPhotosAndExtrasListViewController.m
//  SmartManager
//
//  Created by Sandeep on 03/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMPhotosAndExtrasListViewController.h"
#import "SMAddToStockViewController.h"
#import "SMTraderSearchSortByCell.h"
#import "MGProgressObject.h"
#import <CoreText/CTStringAttributes.h>
#import <CoreText/CoreText.h>
#import "SMStockListCell.h"

static NSString *cellIdentifier= @"PhotosAndExtrasCellIdentifier";
@interface SMPhotosAndExtrasListViewController ()

@end

@implementation SMPhotosAndExtrasListViewController
@synthesize tblPhotosAndExtras;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    
    if([labelforNavigationTitle.text isEqualToString:@"Edit Stock"])
        [SMGlobalClass sharedInstance].isListModule = YES;
    else
       [SMGlobalClass sharedInstance].isListModule = NO;
        
    
    self.lblNoRecordFound.hidden = YES;
    if (appdelegate.isRefreshUI)
    {
        pageNumberCount=0;
        oldArrayCount=0;
        
        if([self.txtFieldSort.text length]!=0)
        {
            SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
            
            int sortOrder;
            
            if(objectForRow.isAscending)
                sortOrder = 1;
            else
                sortOrder = 2;
            
            if([self.txtFieldSearch.text length] != 0)
                [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
            else
                [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
            
        }
        else
        {
            if([SMGlobalClass sharedInstance].isListModule)
            {
                if([self.txtFieldSearch.text length] != 0)
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"friendlyname"];
                else
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
                
            }
            else
            {
                
                if([self.txtFieldSearch.text length] != 0)
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"photos:asc"];
                else
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"photos:asc"];
                
                self.txtFieldSort.text = @"Photos (Ascending)";
                NSLog(@"arraySortObjecttt = %lu",(unsigned long)arraySortObject.count);
                SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:5];
                 objectForRow.isAscending = YES;
//                CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrow"]CGImage];
//                
//                UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationDown];
//                [self.imageUpDownArrow setImage:rotatedImage];
                
                SMTraderSearchSortByCell *selectedCell = (SMTraderSearchSortByCell*)[self.tableSortItems cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:5]];
                selectedCell.imgAscDesc.transform = CGAffineTransformMakeRotation(M_PI);
                
            }
            
        }
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [self hideProgressHUD];
    [popupView removeFromSuperview];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    [self supportedInterfaceOrientations];
    
    [self addingProgressHUD];
    
    
    
    // Do any additional setup after loading the view from its nib.
    appdelegate=(SMAppDelegate *)[UIApplication sharedApplication].delegate;
    
    photosAndExtrasArray=[[NSMutableArray alloc]init];
    currentNodeContent=[[NSMutableString alloc]init];
    isCompletedLoading=YES;
    isLoadMore=NO;
    appdelegate.isRefreshUI=YES;
    StatusIDForChoices = 1;
    hasUserChangedTheDefaultSortOption = NO;
    pageNumberCount=0;
    selectedRow = -1;
    isTheAttemtFirst = YES;
    isSearchResult = NO;
    
    [self.btnShowFilter setSelected:YES];
    self.tblPhotosAndExtras.tableFooterView = [[UIView alloc]init];
    
    labelforNavigationTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        labelforNavigationTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    }
    else
    {
        labelforNavigationTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    }
    labelforNavigationTitle.backgroundColor = [UIColor clearColor];
    labelforNavigationTitle.textColor = [UIColor whiteColor]; // change this color
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    
    self.segmentControlForStatusChoices.tintColor = [UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0];
    
    objectDropDown = [[SMDropDownObject alloc] init];
    
    if(![SMGlobalClass sharedInstance].isListModule)
        labelforNavigationTitle.text = @"Photos & Extras";
    else
        labelforNavigationTitle.text = @"Edit Stock";
    
    
    self.navigationItem.titleView = labelforNavigationTitle;
    [labelforNavigationTitle sizeToFit];
    
    [self populateTheSortByArray];
    
    self.viewDropdownFrame.layer.cornerRadius=15.0;
    self.viewDropdownFrame.clipsToBounds      = YES;
    self.viewDropdownFrame.layer.borderWidth=1.5;
    self.viewDropdownFrame.layer.borderColor=[[UIColor blackColor] CGColor];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblNoRecordFound.font = [UIFont fontWithName:FONT_NAME size:14.0];
        [self.txtFieldSort setFont:[UIFont fontWithName:FONT_NAME size:14.0f]];
        [self.txtFieldSearch setFont:[UIFont fontWithName:FONT_NAME size:14.0f]];
        [self.lblSortBy setFont:[UIFont fontWithName:FONT_NAME size:14.0f]];
        [self.btnShowFilter.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:14.0f]];
        [self.cancelButton.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:14.0f]];
    }
    else
    {
        self.lblNoRecordFound.font = [UIFont fontWithName:FONT_NAME size:20.0];
        [self.txtFieldSort setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.txtFieldSearch setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.lblSortBy setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.btnShowFilter.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.cancelButton.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
    }
    
    [self registerNib];
    [self.lblNoRetail setTextColor:[UIColor whiteColor]];
    
}

- (void)registerNib
{
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tblPhotosAndExtras registerNib:[UINib nibWithNibName:@"SMPhotosAndExtrasTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        [self.tblPhotosAndExtras registerNib:[UINib nibWithNibName:@"SMStockListCell" bundle:nil] forCellReuseIdentifier:@"SMStockListCell"];
        [self.tableSortItems registerNib:[UINib nibWithNibName:@"SMTraderSearchSortByCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMTraderSearchSortByCell"];
    }
    else
    {
        [self.tblPhotosAndExtras registerNib:[UINib nibWithNibName:@"SMPhotosAndExtrasTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        [self.tblPhotosAndExtras registerNib:[UINib nibWithNibName:@"SMStockListCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMStockListCell"];
        [self.tableSortItems registerNib:[UINib nibWithNibName:@"SMTraderSearchSortByCell_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMTraderSearchSortByCell"];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return ( interfaceOrientation == UIInterfaceOrientationPortrait ) ? YES : NO;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    {
        if ([viewController respondsToSelector:@selector(supportedInterfaceOrientations)])
        {
            [viewController supportedInterfaceOrientations];
        }
    }
}

- (IBAction)btnShowFilterDidClicked:(id)sender
{
    [self.btnShowFilter setSelected:!self.btnShowFilter.selected];
    [self.tblPhotosAndExtras reloadData];
}


-(void)refreshTheVehicleListModule
{
    
    pageNumberCount=0;
    oldArrayCount=0;
    
    [photosAndExtrasArray removeAllObjects];
    if([self.txtFieldSort.text length]!=0)
    {
        SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
        
        int sortOrder;
        
        if(objectForRow.isAscending)
            sortOrder = 1;
        else
            sortOrder = 2;
        
        
        if([self.txtFieldSearch.text length] != 0)
            [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
        else
            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
        
    }
    else
    {
        
        if([self.txtFieldSearch.text length] != 0)
            [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"friendlyname"];
        else
            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
        
    }
    
}




#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtFieldSort)
    {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        [self.tableSortItems reloadData];
        [self loadPopUpView];
        
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtFieldSearch)
    {
        
        [textField resignFirstResponder];
        
        if([self.txtFieldSearch.text length]!=0)
        {
            isLoadMore = NO;
            [self callTheWebServiceForSearch];
        }
        else
        {
            [photosAndExtrasArray removeAllObjects];
            [self.tblPhotosAndExtras reloadData];
            
            pageNumberCount=0;
            oldArrayCount  =0;
            
            if([SMGlobalClass sharedInstance].isListModule)
                [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
            else
                [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"photos|extras"];
            
        }
        return NO;
    }
    return YES;
}

#pragma mark - textField delegate methods

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
             appdelegate.isRefreshUI=NO;
             
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
    //    [HUD show:YES];
    //    [HUD setLabelText:KLoaderText];
    
    [[MGProgressObject sharedInstance] showProgressHUDWithText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices filterThePhotosNExtrasBasedOnSearchWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andsearchKeyword:self.txtFieldSearch.text andPageSize:10 andPageNumber:pageNumberCount andStatus:statusCode andSortText:sortText andNewUsed:@""];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    isListingDataBeingFetched = YES;
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         isListingDataBeingFetched = NO;
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [[MGProgressObject sharedInstance] hideProgressHUD];
             
         }
         else
         {
             // NSLog(@"Resposen is %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
             
             
             appdelegate.isRefreshUI=NO;
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

#pragma mark - UITableViewDataSource

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableSortItems)
    {
        float maxHeigthOfView = [self view].frame.size.height/2+50.0;
        float totalFrameOfView = 0.0f;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            totalFrameOfView = 32+([arraySortObject count]*43);
        }
        else
        {
            totalFrameOfView = 45+([arraySortObject count]*60);
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
        
        return [arraySortObject count];
        
    }
    
    
    
    return [photosAndExtrasArray count];
}


- (CGFloat)heightForTextForVehicle:(NSString *)bodyText
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
        textSize = self.view.frame.size.width -16;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        textSize =  self.view.frame.size.width - 16;
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView!= self.tableSortItems)
    {
        NSLog(@"RowID = %ld", (long)indexPath.row);
        //===========================================================================================================================
        //start
        SMPhotosAndExtrasObject *photoObject=(SMPhotosAndExtrasObject *)[photosAndExtrasArray objectAtIndex:indexPath.row];
        static NSString *cellIdentifer1=@"SMStockListCell";
        SMStockListCell *cellPhotosExtras = [tableView dequeueReusableCellWithIdentifier:cellIdentifer1 forIndexPath:indexPath];
        
        cellPhotosExtras.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //cellPhotosExtras.lblVehicleName.text=[NSString stringWithFormat:@"%@ %@",photoObject.strUsedYear,photoObject.strVehicleName];
        
        [self setAttributedTextForVehicleNameWithFirstText:photoObject.strUsedYear andWithSecondText:photoObject.strVehicleName forLabel:cellPhotosExtras.lblVehicleName];// Change By Ankit
        
        cellPhotosExtras.lbVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",photoObject.strRegistration,photoObject.strColour, photoObject.strStockCode];
        
        cellPhotosExtras.lblPriceRetail.text = photoObject.strRetailPrice;
        [cellPhotosExtras.lblPriceRetail sizeToFit];
        cellPhotosExtras.lblPriceTrade.text = photoObject.strTradePrice;
        
        if (photoObject.strNotes.length == 0) {
            cellPhotosExtras.lblNotes.hidden = YES;
        }else
        {
            cellPhotosExtras.lblNotes.hidden = NO;
            cellPhotosExtras.lblNotes.text = [NSString stringWithFormat:@"Notes: %@",photoObject.strNotes];
        }
        
        // NSLog(@"First label frame size %@",NSStringFromCGRect(cellPhotosExtras.lblVehicleName.frame));
        
        
        
        // [self setAttributedTextForVehicleDetailsWithFirstText:@"R45" andWithSecondText:@"23 000Km" andWithThirdText:@"243 days" forLabel:cell1.lbVehicleDetails2];
        
        
        if ([photoObject.strMileage hasPrefix:@" "])
        {
            photoObject.strMileage = [photoObject.strMileage stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        }
        
        //photoObject.strMileage =[NSString stringWithFormat:@"%@Km",photoObject.strMileage];
        NSString *strValueWithKmDispaly = [NSString stringWithFormat:@"%@ Km",photoObject.strMileage];
        [self setAttributedTextForVehicleDetailsWithFirstText:photoObject.strVehicleType andWithSecondText:strValueWithKmDispaly andWithThirdText:photoObject.strDays forLabel:cellPhotosExtras.lbVehicleDetails2];
        
        CGFloat height;
        NSString *str = [NSString stringWithFormat:@"%@ %@",photoObject.strUsedYear,photoObject.strVehicleName];
        height = [self heightForTextForVehicle:str ];
        cellPhotosExtras.lblVehicleName.frame = CGRectMake(cellPhotosExtras.lblVehicleName.frame.origin.x, cellPhotosExtras.lblVehicleName.frame.origin.y, cellPhotosExtras.lbVehicleDetails1.frame.size.width, height);
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            cellPhotosExtras.lbVehicleDetails1.frame = CGRectMake(cellPhotosExtras.lbVehicleDetails1.frame.origin.x, cellPhotosExtras.lblVehicleName.frame.origin.y + cellPhotosExtras.lblVehicleName.frame.size.height + 3.0, cellPhotosExtras.lbVehicleDetails1.frame.size.width, cellPhotosExtras.lbVehicleDetails1.frame.size.height);
            
            cellPhotosExtras.lbVehicleDetails2.frame = CGRectMake(cellPhotosExtras.lbVehicleDetails2.frame.origin.x, cellPhotosExtras.lbVehicleDetails1.frame.origin.y + cellPhotosExtras.lbVehicleDetails1.frame.size.height + 5.0, cellPhotosExtras.lbVehicleDetails2.frame.size.width, cellPhotosExtras.lbVehicleDetails2.frame.size.height);
            
            cellPhotosExtras.viewContainingTraderPrice.frame = CGRectMake(cellPhotosExtras.lblPriceRetail.frame.origin.x + cellPhotosExtras.lblPriceRetail.frame.size.width+3.0, cellPhotosExtras.viewContainingTraderPrice.frame.origin.y , cellPhotosExtras.viewContainingTraderPrice.frame.size.width, cellPhotosExtras.viewContainingTraderPrice.frame.size.height);
            
            cellPhotosExtras.viewContainingPrice.frame = CGRectMake(cellPhotosExtras.viewContainingPrice.frame.origin.x, cellPhotosExtras.lbVehicleDetails2.frame.origin.y + cellPhotosExtras.lbVehicleDetails2.frame.size.height + 3.0, cellPhotosExtras.viewContainingPrice.frame.size.width, cellPhotosExtras.viewContainingPrice.frame.size.height);
            
            cellPhotosExtras.viewContainerExtrasComments.frame = CGRectMake(cellPhotosExtras.viewContainerExtrasComments.frame.origin.x, cellPhotosExtras.viewContainingPrice.frame.origin.y + cellPhotosExtras.viewContainingPrice.frame.size.height + 3.0, cellPhotosExtras.viewContainerExtrasComments.frame.size.width, cellPhotosExtras.viewContainerExtrasComments.frame.size.height);
            
            cellPhotosExtras.lblNotes.frame = CGRectMake(cellPhotosExtras.lblNotes.frame.origin.x, cellPhotosExtras.viewContainerExtrasComments.frame.origin.y + cellPhotosExtras.viewContainerExtrasComments.frame.size.height + 3.0, cellPhotosExtras.lblNotes.frame.size.width, cellPhotosExtras.lblNotes.frame.size.height);
        }
        else
        {
            cellPhotosExtras.lbVehicleDetails1.frame = CGRectMake(cellPhotosExtras.lbVehicleDetails1.frame.origin.x, cellPhotosExtras.lblVehicleName.frame.origin.y + cellPhotosExtras.lblVehicleName.frame.size.height +1.0, cellPhotosExtras.lbVehicleDetails1.frame.size.width, cellPhotosExtras.lbVehicleDetails1.frame.size.height);
            
            cellPhotosExtras.lbVehicleDetails2.frame = CGRectMake(cellPhotosExtras.lbVehicleDetails2.frame.origin.x, cellPhotosExtras.lbVehicleDetails1.frame.origin.y + cellPhotosExtras.lbVehicleDetails1.frame.size.height + 5.0, cellPhotosExtras.lbVehicleDetails2.frame.size.width, cellPhotosExtras.lbVehicleDetails2.frame.size.height);
            
            
            cellPhotosExtras.viewContainingTraderPrice.frame = CGRectMake(cellPhotosExtras.lblPriceRetail.frame.origin.x + cellPhotosExtras.lblPriceRetail.frame.size.width+5.0, cellPhotosExtras.viewContainingTraderPrice.frame.origin.y , cellPhotosExtras.viewContainingTraderPrice.frame.size.width, cellPhotosExtras.viewContainingTraderPrice.frame.size.height);
            
            cellPhotosExtras.viewContainingPrice.frame = CGRectMake(cellPhotosExtras.viewContainingPrice.frame.origin.x, cellPhotosExtras.lbVehicleDetails2.frame.origin.y + cellPhotosExtras.lbVehicleDetails2.frame.size.height + 5.0, cellPhotosExtras.viewContainingPrice.frame.size.width, cellPhotosExtras.viewContainingPrice.frame.size.height);
            
            cellPhotosExtras.viewContainerExtrasComments.frame = CGRectMake(cellPhotosExtras.viewContainerExtrasComments.frame.origin.x, cellPhotosExtras.viewContainingPrice.frame.origin.y + cellPhotosExtras.viewContainingPrice.frame.size.height + 5.0, cellPhotosExtras.viewContainerExtrasComments.frame.size.width, cellPhotosExtras.viewContainerExtrasComments.frame.size.height);
            
            cellPhotosExtras.lblNotes.frame = CGRectMake(cellPhotosExtras.lblNotes.frame.origin.x, cellPhotosExtras.viewContainerExtrasComments.frame.origin.y + cellPhotosExtras.viewContainerExtrasComments.frame.size.height + 5.0, cellPhotosExtras.lblNotes.frame.size.width, cellPhotosExtras.lblNotes.frame.size.height);
            
        }
        
        
        cellPhotosExtras.lblPhotoCount.text=photoObject.strPhotoCounts;
        cellPhotosExtras.lblVideosImage.text=photoObject.strVideosCount;
        
        if (!photoObject.strExtras)
        {
            [cellPhotosExtras.lblExtrasImage setText:@"x"];
            [cellPhotosExtras.lblExtrasImage setTextColor:[UIColor redColor]];
        }
        else
        {
            [cellPhotosExtras.lblExtrasImage setText:@"\u2713"];
            [cellPhotosExtras.lblExtrasImage setTextColor:[UIColor greenColor]];
        }
        
        if (!photoObject.strComments)
        {
            [cellPhotosExtras.lblCommentsImage setText:@"x"];
            [cellPhotosExtras.lblCommentsImage setTextColor:[UIColor redColor]];
        }
        else
        {
            [cellPhotosExtras.lblCommentsImage setText:@"\u2713"];
            [cellPhotosExtras.lblCommentsImage setTextColor:[UIColor greenColor]];
        }
        
        
        //end
        //===========================================================================================================================
        if([self.txtFieldSort.text isEqualToString:@"Photos (Ascending)"])
            selectedRow = 5;
        
        cellPhotosExtras.backgroundColor=[UIColor clearColor];
        
        if (photosAndExtrasArray.count-1 == indexPath.row)
        {
            ++pageNumberCount;
            isLoadMore=YES;
            
            if([self.txtFieldSort.text length]!=0)
            {
                NSLog(@"arraySortObject = %lu",(unsigned long)arraySortObject.count);
                SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
                
                int sortOrder;
                
                if(objectForRow.isAscending)
                    sortOrder = 1;
                else
                    sortOrder = 2;
                
                if([self.txtFieldSearch.text length] != 0)
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
                if([self.txtFieldSearch.text length] != 0)
                {
                    if (photosAndExtrasArray.count !=iTotalArrayCount)
                    {
                        if(![SMGlobalClass sharedInstance].isListModule)
                            [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"photos|extras"];
                        else
                            [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"friendlyname"];
                    }
                }
                else
                {
                    if (photosAndExtrasArray.count !=iTotalArrayCount)
                    {
                        if(![SMGlobalClass sharedInstance].isListModule)
                            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"photos|extras"];
                        else
                            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
                    }
                }
            }
        }
        
        return cellPhotosExtras;
    }
    else
    {
        static NSString     *CellIdentifier1 = @"SMTraderSearchSortByCell";
        
        SMDropDownObject *objectCellForRow;
        
        SMTraderSearchSortByCell *cell1 = (SMTraderSearchSortByCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        
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
        if(indexPath.row == 0)
            cell1.imgAscDesc.hidden = YES;
        
        //if([self.txtFieldSort.text isEqualToString:@"Photos(Ascending)"])
        //selectedRow = 5;
        
        objectCellForRow = (SMDropDownObject *)[arraySortObject objectAtIndex:indexPath.row];
        [cell1.lblSortText setText:objectCellForRow.strSortText];
        
        cell1.layoutMargins = UIEdgeInsetsZero;
        cell1.preservesSuperviewLayoutMargins = NO;
        
        return cell1;
        
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView != self.tableSortItems)
    {
        [self.btnShowFilter setTag:section];
        
        return self.headerView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView != self.tableSortItems)
    {
        if([self.btnShowFilter isSelected])
        {
            CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
            
            UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
            
            [self.imgRightArrow setImage:rotatedImage];
            
            if(![SMGlobalClass sharedInstance].isListModule)
            {
                self.segmentControlForStatusChoices.hidden = YES;
                return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 118.0 : 160.0;
            }
            else
            {
                self.segmentControlForStatusChoices.hidden = NO;
                return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 169.0: 200.0;
            }
        }
        else
        {
            CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
            UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
            [self.imgRightArrow setImage:rotatedImage];
            return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 34.0 : 50.0;
        }
    }
    return 0;
}

#pragma - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView != self.tableSortItems)
    {
        SMPhotosAndExtrasObject *photoObject=(SMPhotosAndExtrasObject *)[photosAndExtrasArray objectAtIndex:indexPath.row];
        
        CGFloat height;
        NSString *str = [NSString stringWithFormat:@"%@ %@",photoObject.strUsedYear,photoObject.strVehicleName];
        height = [self heightForTextForVehicle:str ];
        
        
        if (photoObject.strNotes.length == 0) {
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
                return height+105;//101
            }
            else
            {
                return height+145.0f+10.0f;//140
            }
            //return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 131.0 : 180.0f+10.0;
        }
        else{
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
                return height+135.0f;
                //return 160.0f;//128
            }
            else
            {
                return height+190.f;
               // return 222.0f;//186
            }
            //return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 160.0f : 222.0f;
        }

    }
    else
    {
        return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 40.0 : 60.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"indexpath.row = %ld",(long)indexPath.row);
    
    hasUserChangedTheDefaultSortOption = YES;
    
    if(tableView != self.tableSortItems)
    {
        if(![labelforNavigationTitle.text isEqualToString: @"Edit Stock"])
        {
            SMCommentVideosPhotosAddViewController *commentPVObject;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                commentPVObject=[[SMCommentVideosPhotosAddViewController alloc]initWithNibName:@"SMCommentVideosPhotosAddViewController" bundle:nil];
            }
            else
            {
                commentPVObject=[[SMCommentVideosPhotosAddViewController alloc]initWithNibName:@"SMCommentVideosPhotosAddViewController_iPad" bundle:nil];
            }
            NSLog(@"%@",[photosAndExtrasArray objectAtIndex:indexPath.row]);
            commentPVObject.photosExtrasObject=[photosAndExtrasArray objectAtIndex:indexPath.row];
            
            isLoadMore=NO;
            [self.navigationController pushViewController:commentPVObject animated:YES];
        }
        else
        {
            SMAddToStockViewController *addToStockObject;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                addToStockObject = [[SMAddToStockViewController alloc] initWithNibName:@"SMAddToStockViewController" bundle:nil];
            }
            else
            {
                addToStockObject = [[SMAddToStockViewController alloc] initWithNibName:@"SMAddToStockViewController_iPad" bundle:nil];
                
            }
            [SMGlobalClass sharedInstance].isListModule = YES;
            addToStockObject.photosExtrasObject=[photosAndExtrasArray objectAtIndex:indexPath.row];
            addToStockObject.isUpdateVehicleInformation = YES;
            addToStockObject.listRefreshDelegate = self;
            [self.navigationController pushViewController:addToStockObject animated:YES];
        }
    }
    else
    {
        
        pageNumberCount=0;
        oldArrayCount=0;
        [photosAndExtrasArray removeAllObjects];
        
        SMDropDownObject *objectDidSelectForRow;
        
        objectDidSelectForRow = (SMDropDownObject *)[arraySortObject objectAtIndex:indexPath.row];
        
        // below conditions was added by Jignesh K on 13 March
        if (selectedRow == indexPath.row)
        {
            objectDidSelectForRow.isAscending = !objectDidSelectForRow.isAscending;
        }
        else
        {
            objectDidSelectForRow.isAscending = YES;
            
        }
        selectedRow = (int)indexPath.row;
        //END -  below conditions was added by Jignesh K on 13 March
        
        
        SMTraderSearchSortByCell *selectedCell = (SMTraderSearchSortByCell*)[self.tableSortItems cellForRowAtIndexPath:indexPath];
        
        SMDropDownObject *objectCellForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
        
        if(objectCellForRow.isAscending)
        {
            selectedCell.imgAscDesc.transform = CGAffineTransformMakeRotation(M_PI);
            if([objectDidSelectForRow.strSortText isEqualToString:@"-- None --"])
                [self.txtFieldSort setText:objectDidSelectForRow.strSortText];
            else
            {
                [self.txtFieldSort setText:[NSString stringWithFormat:@"%@ (Ascending)",objectDidSelectForRow.strSortText]];
                
                /*UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
                [self.imageUpDownArrow setImage:rotatedImage];*/
                
            }
            
        }
        else
        {
            selectedCell.imgAscDesc.transform = CGAffineTransformMakeRotation(0);
            if([objectDidSelectForRow.strSortText isEqualToString:@"-- None --"])
                [self.txtFieldSort setText:objectDidSelectForRow.strSortText];
            else
                
                [self.txtFieldSort setText:[NSString stringWithFormat:@"%@ (Descending)",objectDidSelectForRow.strSortText]];
            
            /*UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationDown];
            [self.imageUpDownArrow setImage:rotatedImage];*/
        }
        
        SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
        
        int sortOrder;
        
        if(objectForRow.isAscending)
            sortOrder = 1;
        else
            sortOrder = 2;
        
        if([self.txtFieldSearch.text length] != 0)
            [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:(int)indexPath.row andSortOrder:sortOrder]];
        else
            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:(int)indexPath.row andSortOrder:sortOrder]];
        
        [self.tblPhotosAndExtras reloadData];
        [self hidePopUpView];
    }
}

bool isDataFound = NO;

#pragma mark - xmlParserDelegate
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"ListVehiclesByStatusXMLResponse"])
    {
        isDataFound = NO;
    }
    
    if ([elementName isEqualToString:@"stock"])
    {
        loadPhotosAndExtrasObject=[[SMPhotosAndExtrasObject alloc]init];
        isDataFound = YES;
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
        if ([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"0"])
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
    if ([elementName isEqualToString:@"internalNote"])
    {
        loadPhotosAndExtrasObject.strNotes=currentNodeContent;
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
            [self.lblNoRetail setText:@"0"];
        else
            [self.lblNoRetail setText:[NSString stringWithFormat:@"(%@)",currentNodeContent]];
    }
    if([elementName isEqualToString:@"totalExcluded"])
    {
        if(currentNodeContent.intValue == 0)
            [self.lblNoExcluded setText:@"0"];
        else
            [self.lblNoExcluded setText:[NSString stringWithFormat:@"(%@)",currentNodeContent]];
    }
    if([elementName isEqualToString:@"totalAll"])
    {
        if(currentNodeContent.intValue == 0)
            [self.lblNoAll setText:@"0"];
        else
            [self.lblNoAll setText:[NSString stringWithFormat:@"(%@)",currentNodeContent]];
    }
    if([elementName isEqualToString:@"totalInvalid"])
    {
        if(currentNodeContent.intValue == 0)
            [self.lblNoInvalid setText:@"0"];
        else
            [self.lblNoInvalid setText:[NSString stringWithFormat:@"(%@)",currentNodeContent]];
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
        
        if(photosAndExtrasArray.count == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"No record(s) found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
        [self.tblPhotosAndExtras reloadData];
        
        
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
    
    [[MGProgressObject sharedInstance] hideProgressHUD];
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
#warning Sandeep - Changing None to -- None --
-(void)populateTheSortByArray
{
    NSArray *arrayOfSortTypes = [[NSArray alloc]initWithObjects:@"-- None --",@"Age",@"Comments",@"Extras",@"Mileage",@"Photos",@"Videos",@"Price",@"Stock #",@"Year", nil];
    
    arraySortObject = [[NSMutableArray alloc]init];
    
    for(int i=0;i<[arrayOfSortTypes count];i++)
    {
        SMDropDownObject *sortObject = [[SMDropDownObject alloc]init];
        sortObject.strSortText = [arrayOfSortTypes objectAtIndex:i];
        sortObject.strSortTextID = i;
        sortObject.isAscending = NO;
        [arraySortObject addObject:sortObject];
    }
}

- (IBAction)segmentControlForStatusDidClicked:(id)sender
{
    [photosAndExtrasArray removeAllObjects];
    
    switch (self.segmentControlForStatusChoices.selectedSegmentIndex)
    {
        case 0:
        {
            StatusIDForChoices = 1;
            [self.lblNoRetail setTextColor:[UIColor whiteColor]];
            [self.lblNoExcluded setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
            [self.lblNoInvalid setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
            [self.lblNoAll setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
        }
            break;
        case 1:
        {
            StatusIDForChoices = 4;
            [self.lblNoExcluded   setTextColor:[UIColor whiteColor]];
            [self.lblNoRetail setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
            [self.lblNoInvalid setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
            [self.lblNoAll setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
        }
            break;
        case 2:
        {
            StatusIDForChoices = 2;
            [self.lblNoInvalid setTextColor:[UIColor whiteColor]];
            [self.lblNoRetail setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
            [self.lblNoAll setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
            [self.lblNoExcluded setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
        }
            break;
        case 3:
        {
            StatusIDForChoices = -1;
            [self.lblNoAll setTextColor:[UIColor whiteColor]];
            [self.lblNoExcluded setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
            [self.lblNoRetail setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
            [self.lblNoInvalid setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
            
        }
            
            break;
            
        default:
            break;
    }
    
    
    pageNumberCount=0;
    oldArrayCount=0;
    
    
    if([self.txtFieldSort.text length]!=0)
    {
        SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
        
        int sortOrder;
        
        if(objectForRow.isAscending)
            sortOrder = 1;
        else
            sortOrder = 2;
        
        if([self.txtFieldSearch.text length] != 0)
            [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
        else
            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
        
    }
    else
    {
        
        if([self.txtFieldSearch.text length] != 0)
            [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"friendlyname"];
        else
            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
        
    }
    
    
}

- (IBAction)buttonCancelDidPressed:(id)sender
{
    [self hidePopUpView];
}


-(void)callTheWebServiceForSearch
{
    
    pageNumberCount=0;
    oldArrayCount=0;
    
    if([self.txtFieldSort.text length]!=0 )
    {
        if(!hasUserChangedTheDefaultSortOption)
        {
            
            if([self.txtFieldSearch.text length] != 0)
            {
                if(![SMGlobalClass sharedInstance].isListModule)
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"photos|extras"];
                else
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"friendlyname"];
            }
            else
            {
                if(![SMGlobalClass sharedInstance].isListModule)
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"photos|extras"];
                else
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
                
            }
            
            
        }
        else
        {
            SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
            
            int sortOrder;
            
            if(objectForRow.isAscending)
                sortOrder = 1;
            else
                sortOrder = 2;
            
            if([self.txtFieldSearch.text length] != 0)
                [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
            else
                [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
        }
        
    }
    else
    {
        
        if([self.txtFieldSearch.text length] != 0)
        {
            if(![SMGlobalClass sharedInstance].isListModule)
                [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"photos|extras"];
            else
                [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"friendlyname"];
        }
        else
        {
            if(![SMGlobalClass sharedInstance].isListModule)
                [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"photos|extras"];
            else
                [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
            
        }
        
        
    }
    
    
    
}

-(BOOL)testIfTheGivenStringIsAlphabetic:(NSString*)inputString
{
    BOOL result;
    
    NSString *regex = @"[a-zA-Z]+";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return result = [test evaluateWithObject:inputString];
    
}

-(void)refreshTheListModule
{
    
    pageNumberCount=0;
    oldArrayCount=0;
    
    if([self.txtFieldSort.text length]!=0)
    {
        SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
        
        int sortOrder;
        
        if(objectForRow.isAscending)
            sortOrder = 1;
        else
            sortOrder = 2;
        
        if([self.txtFieldSearch.text length] != 0)
            [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
        else
            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder]];
        
    }
    else
    {
        
        if([self.txtFieldSearch.text length] != 0)
            [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"friendlyname"];
        else
            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"friendlyname"];
        
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
                if([SMGlobalClass sharedInstance].isListModule)
                    return @"friendlyname";
                else
                    return @"photos|extras";
            }
            else
            {
                if([SMGlobalClass sharedInstance].isListModule)
                    return @"friendlyname";
                else
                    return @"photos|extras";
                
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
                return @"video:asc";
            else
                return @"video:desc";
        }
            break;
            
        case 7:
        {
            if(sortOrder == 1)
                return @"price:asc";
            else
                return @"price:desc";
        }
            break;
            
        case 8:
        {
            if(sortOrder == 1)
                return @"stockcode:asc";
            else
                return @"stockcode:desc";
        }
            break;
            
        case 9:
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

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorGreen = [UIColor colorWithRed:64.0/255.0 green:198.0/255.0 blue:42.0/255.0 alpha:1.0];
    
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorGreen, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    
    
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    [label setAttributedText:attributedFirstText];
    
    
}

#pragma mark - Set Attributed Text

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    // UIColor *foregroundColorGreen = [UIColor colorWithRed:64.0/255.0 green:198.0/255.0 blue:42.0/255.0 alpha:1.0];
    
    
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



#pragma mark - MemoryWarning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
