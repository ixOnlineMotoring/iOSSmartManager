//
//  SMStockListViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 29/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMStockListViewController.h"
#import "SMStockListCell.h"
#import "SMStockVehicleDetailController.h"
#import "MGProgressObject.h"
#import "SMTraderSearchSortByCell.h"
#import "SMVehicleStockDetailViewController.h"
#import "SMLoadVehiclesObject.h"
#import "SMDropDownObject.h"
#import "UIActionSheet+Blocks.h"
#import "SMClassOfBlogImages.h"
#import "SMAppDelegate.h"
#import "SDImageCache.h"
#import "Fontclass.h"
#import "SMCustomButtonGrayColor.h"

///////////////////Monami Declare tableview Height///////////////////////
static int HeightOfTableViewForIphone=320;
static int HeightOfTableViewForIpad=730;
////////////////////////////////////////////////////////////////////////


@interface SMStockListViewController ()
{
    
    SMAppDelegate *appDeleage;
    IBOutlet SMCustomTextField *txtFieldVehiclesDropdownMMV;
    
    
    IBOutlet UIView *viewContainingSortBy;
    
    IBOutlet SMCustomTextFieldForDropDown *txtFieldMakeDropdown;
    
    IBOutlet SMCustomTextFieldForDropDown *txtFieldModelDropdown;
    
    
    __weak IBOutlet UILabel *lblPlaceholderFont;
    
    __weak IBOutlet UILabel *lblPlaceholderFontFullRange;
    
    BOOL isTextFieldSortBy;
    BOOL isNewVehicleFullRangeSelected;
    int selectedMakeID;
    int selectedModelID;
    int totalUsed;
    int totalNew;
    
    NSString *strNewUsedVehicle;
    IBOutlet UIView *HeaderViewWithMakeModel;
    SMLoadVehiclesObject        *loadVehiclesObject;
    SMDropDownObject        *modelObject;
    NSMutableArray *arrmMakes;
    NSMutableArray *arrmModels;
    NSMutableArray *arrmVariants;
    
    NSLayoutConstraint *topConstraint1;
    NSLayoutConstraint *topConstraint2;
    
    /////////////Monami/////////////
    BOOL isReplaced;
    float desired_y_value ;
    NSString *strBase64;
    NSString *strForProfileImage;
    __weak IBOutlet UIView *vwForDivider;
    __weak IBOutlet UIView *vwHeaderVarientForReplace;
    BOOL isListClicked;
    __weak IBOutlet SMCustomButtonGrayColor *btnReplaceForViewVarient;
     __weak IBOutlet UIView *vwForDividerForHeaderViewVarient;
    __weak IBOutlet UILabel *lblNOPhotoAvailable;
    __weak IBOutlet UIImageView *imgvwForUploadForOld;
    ////////////////////////
    
    
    
    
    
}

@end

@implementation SMStockListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addingProgressHUD];
    ///////////// Monami ////////////////////////////////
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        desired_y_value = 165.0;
    }else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        desired_y_value = 195.0;
    }
    /////////////// END //////////////////////////////////
    strForProfileImage = @"";
    
    [Fontclass AttributeStringMethodwithFontWithLabelForLogin:lblPlaceholderFont iconID:573];
    [Fontclass AttributeStringMethodwithFontWithLabelForLogin:lblPlaceholderFontFullRange iconID:573];
    
    self.tblViewStockList.tableFooterView = [[UIView alloc] init];
    arraySortObject = [[NSMutableArray alloc]init];
    arrayVehiclesObject = [[NSMutableArray alloc]init];
    arrmMakes = [[NSMutableArray alloc]init];
    arrmModels = [[NSMutableArray alloc]init];
    arrmVariants = [[NSMutableArray alloc]init];
    
    isNewVehicleFullRangeSelected = NO;
    strNewUsedVehicle = @"used";
    self.bottomConstraintOfHeaderOldToTableView.constant = 0;
    [self setTheTitleForScreen];
    self.segmentControlForChoices.hidden = YES;
    self.lblRetailCnt.hidden = YES;
    self.lblExcludedCnt.hidden = YES;
    isNoRecordsAlertShown = NO;
   // [self getTheClientsCorporateGroup];
    [self registerNib];
    self.lblNoRecords.hidden = YES;
    
    appdelegate=(SMAppDelegate *)[UIApplication sharedApplication].delegate;
    
    photosAndExtrasArray=[[NSMutableArray alloc]init];
    arrayOfGroupStock = [[NSMutableArray alloc]init];
    
    currentNodeContent=[[NSMutableString alloc]init];
    isCompletedLoading=YES;
    isLoadMore=NO;
    appdelegate.isRefreshUI = NO ;
    StatusIDForChoices = 1;
    
    pageNumberCount=0;
    selectedRow = -1;
    selectedRowForVehiclesDropdown = 0;
    isTheAttemtFirst = YES;
    isSearchResult = NO;
    
    self.tblViewStockList.estimatedRowHeight = 66.0;
    self.tblViewStockList.rowHeight = UITableViewAutomaticDimension;
    
    
    arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMReusableSearchTableViewController" owner:self options:nil];
    searchMakeVC = [arrLoadNib objectAtIndex:0];
    
    
    self.viewDropdownFrame.layer.cornerRadius=15.0;
    self.viewDropdownFrame.clipsToBounds      = YES;
    self.viewDropdownFrame.layer.borderWidth=1.5;
    self.viewDropdownFrame.layer.borderColor=[[UIColor blackColor] CGColor];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblNoRecords.font = [UIFont fontWithName:FONT_NAME size:14.0];
        [self.txtFieldSortOption setFont:[UIFont fontWithName:FONT_NAME size:14.0f]];
        [self.txtFieldKeywordSearch setFont:[UIFont fontWithName:FONT_NAME size:14.0f]];
        [self.lblSortBy setFont:[UIFont fontWithName:FONT_NAME size:14.0f]];
        [self.lblVehlcesDropDown setFont:[UIFont fontWithName:FONT_NAME size:14.0f]];
        [self.btnShowFilter.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:14.0f]];
        [self.cancelButton.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:14.0f]];
    }
    else
    {
        self.lblNoRecords.font = [UIFont fontWithName:FONT_NAME size:20.0];
        [self.txtFieldSortOption setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.txtFieldKeywordSearch setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.lblSortBy setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.btnShowFilter.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.cancelButton.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
    }
    
    
    
    CGRect frame= self.segmentControlForChoices.frame;
    CGRect framebtnMyStock= self.btnMyStock.frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [self.segmentControlForChoices setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 33)];
        
        [self.btnMyStock setFrame:CGRectMake(framebtnMyStock.origin.x, framebtnMyStock.origin.y, framebtnMyStock.size.width, 30)];
    }
    else
    {
        [self.segmentControlForChoices setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 35)];
        
        [self.btnMyStock setFrame:CGRectMake(framebtnMyStock.origin.x, framebtnMyStock.origin.y, framebtnMyStock.size.width, 37)];
    }
    
    rowHeight = 102.0;
    self.segmentControlForChoices.tintColor = [UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0];
    
    [self.btnShowFilter setSelected:YES];
    self.lblRetailCnt.textColor = [UIColor whiteColor];
    [self.segmentControlForChoices setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:13.0],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
    self.viewContainingSegment.hidden = NO;
    //self.btnMyStock.hidden = YES;
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
        self.btnShowFilter.titleEdgeInsets = UIEdgeInsetsMake(0, -655, 0, 0);
    
   [self populateTheSortByArray];
     [self populateVehiclesArray];
    
    self.tblViewStockList.delegate = nil;
    self.tblViewStockList.dataSource = nil;
    
     if(!self.isFromEBrochure)
     {
         ////////////////Monami/////////////////////////////
         //For StockList Module View should be hidden
         _vwUpload.hidden = YES;
         _vwReplace.hidden = YES;
         vwForDivider.hidden = YES;
         ////////////////////End/////////////////////////////
         _heightHeaderOLD.constant = 163;
         _heightConstraintProfilePicView.constant = 0;
     }
    else
    {
        isListClicked = NO;
        arrayOfImages = [[NSMutableArray alloc]init];
        self.multipleImagePicker = [[RPMultipleImagePickerViewController alloc] init];
        self.multipleImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        self.multipleImagePicker.photoSelectionDelegate = self;
        [SMGlobalClass sharedInstance].totalImageSelected  = 0;
        [SMGlobalClass sharedInstance].isFromCamera = NO;
        
        [_imgViewProfilePic setImageWithURL:[NSURL URLWithString:[[SMGlobalClass sharedInstance].arrayOfMemberImages objectAtIndex:0]]];
        _imgViewProfilePic.layer.cornerRadius = _imgViewProfilePic.frame.size.height / 2;;
        _imgViewProfilePic.clipsToBounds = YES;
        
        [_imgProfilePicFullRange setImageWithURL:[NSURL URLWithString:[[SMGlobalClass sharedInstance].arrayOfMemberImages objectAtIndex:0]]];
        _imgProfilePicFullRange.layer.cornerRadius = _imgProfilePicFullRange.frame.size.height / 2;;
        _imgProfilePicFullRange.clipsToBounds = YES;
         
        
       /* _heightHeaderOLD.constant = 232;
       _heightConstraintProfilePicView.constant = 74;*/
        
       /* [self.view removeConstraint:self.bottomConstraintOfHeaderOldToTableView];
        [self.headerView layoutIfNeeded];
        [_headerView layoutSubviews];
        _heightHeaderOLD.constant = 275;
        _heightConstraintProfilePicView.constant = 0;
        _heightUploadPicView.constant = 112;
        [self.headerView layoutIfNeeded];
        
        self.tblViewStockList.frame = CGRectMake(self.tblViewStockList.frame.origin.x, self.headerView.frame.origin.y + self.headerView.frame.size.height, self.tblViewStockList.frame.size.width, self.tblViewStockList.frame.size.height);*/
        
      /*  NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.tblViewStockList
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.headerView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1
                                                                constant:0];
        [self.view addConstraint:top];
        //[self.headerView layoutIfNeeded];
        [self.headerView updateConstraints];
        [self.view updateConstraints];
        NSLog(@"%@",self.headerView.constraints);*/
        
        //[self.view addConstraint:self.bottomConstraintOfHeaderOldToTableView];
       // self.bottomConstraintOfHeaderOldToTableView.constant = 0;
        
        
        //////////////////////////////Monami/////////////////////////
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        [SMGlobalClass sharedInstance].isFromEbrochure = YES;
        /// Has Profile Image API Call
        [self CheckAvailabilityOfImage];
        //////////////////////////////////////////////////////////////
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    /////////////////////Monami ////////////////////////////
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        desired_y_value = 165.0;
    }else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        desired_y_value = 195.0;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tblViewStockList.frame = CGRectMake( _tblViewStockList.frame.origin.x, desired_y_value, _tblViewStockList.frame.size.width, HeightOfTableViewForIphone);
        });
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tblViewStockList.frame = CGRectMake( _tblViewStockList.frame.origin.x, desired_y_value, _tblViewStockList.frame.size.width, HeightOfTableViewForIpad);
        });
    }
    ////////////////// END /////////////////////////////////
    [self.view endEditing:YES];
    NSLog(@"isLoadMore = %d",isLoadMore);
    
    
    //isGroupStockSection = NO;
    self.lblNoRecords.hidden = YES;
    if (appdelegate.isRefreshUI)
    {
        pageNumberCount=0;
        oldArrayCount=0;
        
        if([self.txtFieldSortOption.text length]!=0)
        {
            SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
            
            int sortOrder;
            
            if(objectForRow.isAscending)
                sortOrder = 1;
            else
                sortOrder = 2;
            
            if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
            {
                if([self.txtFieldKeywordSearch.text length] != 0)
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
                else
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
            }
            else
            {
                if([self.txtFieldKeywordSearch.text length] != 0)
                    [self getTheGroupStockWithSearchKey_SortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
                else
                    [self getTheGroupStockWithSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
            }
            
        }
        else
        {
            if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
            {
                if([self.txtFieldKeywordSearch.text length] != 0)
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                else
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                
            }
            else
            {
                if([self.txtFieldKeywordSearch.text length] != 0)
                    [self getTheGroupStockWithSearchKey_SortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                else
                    [self getTheGroupStockWithSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
            }
            
        }
        
    }
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [self hideProgressHUD];
    [self.view endEditing:YES];
    [_popUpViewForSort removeFromSuperview];
}

#pragma mark - KeyBoard Hide
/////////////////////Monami///////////////////////////////////
//// Set frame as tableview goes down while dismiss keyboard
- (void)keyboardDidHide: (NSNotification *) notif{
    
    //  [self.txtFieldKeywordSearch resignFirstResponder];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _tblViewStockList.frame = CGRectMake( _tblViewStockList.frame.origin.x, desired_y_value, _tblViewStockList.frame.size.width, HeightOfTableViewForIphone);
    });
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tblViewStockList.frame = CGRectMake( _tblViewStockList.frame.origin.x, desired_y_value, _tblViewStockList.frame.size.width, HeightOfTableViewForIpad);
        });
    }
    
}
//////////////////////////////////END//////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            if(isTextFieldSortBy)
                totalFrameOfView = 32+([arraySortObject count]*43);
            else
                totalFrameOfView = 32+([arrayVehiclesObject count]*43);
        }
        else
        {
            if(isTextFieldSortBy)
                totalFrameOfView = 45+([arraySortObject count]*60);
            else
                totalFrameOfView = 45+([arrayVehiclesObject count]*60);
        }
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        if (totalFrameOfView <= maxHeigthOfView)
        {
            //Make View Size smaller, no scrolling
            self.viewDropdownFrame.frame = CGRectMake(self.viewDropdownFrame.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, self.viewDropdownFrame.frame.size.width, totalFrameOfView);
        }
        else
        {
            self.viewDropdownFrame.frame = CGRectMake(self.viewDropdownFrame.frame.origin.x, maxHeigthOfView/2-22.0, self.viewDropdownFrame.frame.size.width, maxHeigthOfView);
        }
        }else{
            if (totalFrameOfView <= maxHeigthOfView)
            {
                //Make View Size smaller, no scrolling
                self.viewDropdownFrame.frame = CGRectMake(self.viewDropdownFrame.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, 700, totalFrameOfView);
            }
            else
            {
                self.viewDropdownFrame.frame = CGRectMake(self.viewDropdownFrame.frame.origin.x, maxHeigthOfView/2-22.0, 700, maxHeigthOfView);
            }
            
        }
        
         NSLog(@"arraySortObject count = %lu",(unsigned long)arraySortObject.count);
        
        if(isTextFieldSortBy)
            return [arraySortObject count];
        else
            return [arrayVehiclesObject count];
        
    }
    else
    {
        if(!isNewVehicleFullRangeSelected)
        {
           
            if(self.isFromEBrochure)
            {
                if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
                    return [photosAndExtrasArray count] ;
                else
                    return [arrayOfGroupStock count];
            }
            else
            {
                if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
                    return [photosAndExtrasArray count];
                else
                    return [arrayOfGroupStock count];
            }
        }
        else
        {
            if(self.isFromEBrochure)
            {
                return arrmVariants.count;
            }
            else
               return arrmVariants.count;
        }
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView!= self.tableSortItems)
    {
       
        
        static NSString *cellIdentifer1=@"SMStockListCell";
        static NSString *cellIdentifer2= @"SMStockListVariantCell";
        
        
        {
        
        SMStockListCell *cellPhotosExtras = [tableView dequeueReusableCellWithIdentifier:cellIdentifer1 forIndexPath:indexPath];
        
        
        cellPhotosExtras.selectionStyle=UITableViewCellSelectionStyleNone;
        
        if(!isNewVehicleFullRangeSelected)
        {
            SMPhotosAndExtrasObject *photoObject;
            
            if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
            {
                if(self.isFromEBrochure)
                   photoObject=(SMPhotosAndExtrasObject *)[photosAndExtrasArray objectAtIndex:indexPath.row];
                else
                   photoObject=(SMPhotosAndExtrasObject *)[photosAndExtrasArray objectAtIndex:indexPath.row];
            }
            else
            {
                if(self.isFromEBrochure)
                    photoObject=(SMPhotosAndExtrasObject *)[arrayOfGroupStock objectAtIndex:indexPath.row];
                else
                   photoObject=(SMPhotosAndExtrasObject *)[arrayOfGroupStock objectAtIndex:indexPath.row];
                
            }
            
            if(selectedRowForVehiclesDropdown == 1 || selectedRowForVehiclesDropdown == 4 )
            {
            
                [self setAttributedTextForVehicleNameWithFirstText:@"" andWithSecondText:photoObject.strVehicleName forLabel:cellPhotosExtras.lblVehicleName];
                cellPhotosExtras.lbVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@",photoObject.strColour, photoObject.strStockCode];
                
                cellPhotosExtras.lblPriceSeparator.hidden = YES;
                cellPhotosExtras.lblTrdTitle.hidden = YES;
                cellPhotosExtras.lblPriceTrade.text = @"";
                
            }
            else
            {
                [self setAttributedTextForVehicleNameWithFirstText:photoObject.strUsedYear andWithSecondText:photoObject.strVehicleName forLabel:cellPhotosExtras.lblVehicleName];// Change By Ankit
                
                cellPhotosExtras.lbVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",photoObject.strRegistration,photoObject.strColour, photoObject.strStockCode];
                cellPhotosExtras.lblPriceSeparator.hidden = NO;
                cellPhotosExtras.lblTrdTitle.hidden = NO;

                cellPhotosExtras.lblPriceTrade.text = photoObject.strTradePrice;
            
            }
           
            
            if (photoObject.strNotes.length == 0) {
                cellPhotosExtras.lblNotes.hidden = YES;
            }else
            {
                cellPhotosExtras.lblNotes.hidden = NO;
                cellPhotosExtras.lblNotes.text = [NSString stringWithFormat:@"Notes: %@",photoObject.strNotes];
            }
            
            cellPhotosExtras.lblPriceRetail.text = photoObject.strRetailPrice;
            [cellPhotosExtras.lblPriceRetail sizeToFit];
            
            
            if ([photoObject.strMileage hasPrefix:@" "])
            {
                photoObject.strMileage = [photoObject.strMileage stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
            }
            
            
            [self setAttributedTextForVehicleDetailsWithFirstText:photoObject.strVehicleType andWithSecondText:photoObject.strMileage andWithThirdText:photoObject.strDays forLabel:cellPhotosExtras.lbVehicleDetails2];
            
            CGFloat height;
            NSString *str = [NSString stringWithFormat:@"%@ %@",photoObject.strUsedYear,photoObject.strVehicleName];
            height = [self heightForTextForVehicle:str ];
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                cellPhotosExtras.lblVehicleName.frame = CGRectMake(cellPhotosExtras.lblVehicleName.frame.origin.x, cellPhotosExtras.lblVehicleName.frame.origin.y, cellPhotosExtras.lbVehicleDetails1.frame.size.width, height);
                
                cellPhotosExtras.lbVehicleDetails1.frame = CGRectMake(cellPhotosExtras.lbVehicleDetails1.frame.origin.x, cellPhotosExtras.lblVehicleName.frame.origin.y + cellPhotosExtras.lblVehicleName.frame.size.height + 3.0, cellPhotosExtras.lbVehicleDetails1.frame.size.width, cellPhotosExtras.lbVehicleDetails1.frame.size.height);
                
                cellPhotosExtras.lbVehicleDetails2.frame = CGRectMake(cellPhotosExtras.lbVehicleDetails2.frame.origin.x, cellPhotosExtras.lbVehicleDetails1.frame.origin.y + cellPhotosExtras.lbVehicleDetails1.frame.size.height + 5.0, cellPhotosExtras.lbVehicleDetails2.frame.size.width, cellPhotosExtras.lbVehicleDetails2.frame.size.height);
                
                cellPhotosExtras.viewContainingTraderPrice.frame = CGRectMake(cellPhotosExtras.lblPriceRetail.frame.origin.x + cellPhotosExtras.lblPriceRetail.frame.size.width+3.0, cellPhotosExtras.viewContainingTraderPrice.frame.origin.y , cellPhotosExtras.viewContainingTraderPrice.frame.size.width, cellPhotosExtras.viewContainingTraderPrice.frame.size.height);
                
                cellPhotosExtras.viewContainingPrice.frame = CGRectMake(cellPhotosExtras.viewContainingPrice.frame.origin.x, cellPhotosExtras.lbVehicleDetails2.frame.origin.y + cellPhotosExtras.lbVehicleDetails2.frame.size.height + 3.0, cellPhotosExtras.viewContainingPrice.frame.size.width, cellPhotosExtras.viewContainingPrice.frame.size.height);
                
                cellPhotosExtras.viewContainerExtrasComments.frame = CGRectMake(cellPhotosExtras.viewContainerExtrasComments.frame.origin.x, cellPhotosExtras.viewContainingPrice.frame.origin.y + cellPhotosExtras.viewContainingPrice.frame.size.height + 3.0, cellPhotosExtras.viewContainerExtrasComments.frame.size.width, cellPhotosExtras.viewContainerExtrasComments.frame.size.height);
                
                cellPhotosExtras.lblNotes.frame = CGRectMake(cellPhotosExtras.lblNotes.frame.origin.x, cellPhotosExtras.viewContainerExtrasComments.frame.origin.y + cellPhotosExtras.viewContainerExtrasComments.frame.size.height + 3.0, cellPhotosExtras.lblNotes.frame.size.width, cellPhotosExtras.lblNotes.frame.size.height);
            }
            else
            {
                cellPhotosExtras.lblVehicleName.frame = CGRectMake(cellPhotosExtras.lblVehicleName.frame.origin.x, cellPhotosExtras.lblVehicleName.frame.origin.y, cellPhotosExtras.lbVehicleDetails1.frame.size.width, height);
                
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
            
            if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
            {
                if(photosAndExtrasArray.count-1 == indexPath.row)
                    self.tblViewStockList.tableFooterView = [[UIView alloc]init];
            }
            else
            {
                if(arrayOfGroupStock.count-1 == indexPath.row)
                    self.tblViewStockList.tableFooterView = [[UIView alloc]init];
            }
            
            cellPhotosExtras.backgroundColor=[UIColor clearColor];
            
            if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
            {
                if (photosAndExtrasArray.count-1 == indexPath.row)
                {
                    
                    if(photosAndExtrasArray.count-1 >=9)
                    {
                        ++pageNumberCount;
                        isLoadMore=YES;
                        
                        NSLog(@"thiss1111");
                        
                        if([self.txtFieldSortOption.text length]!=0)
                        {
                            SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
                            
                            int sortOrder;
                            
                            if(objectForRow.isAscending)
                                sortOrder = 1;
                            else
                                sortOrder = 2;
                            
                            
                            if([self.txtFieldKeywordSearch.text length] != 0)
                            {
                                if([strNewUsedVehicle isEqualToString:@"new"])
                                    totalMyStockCount = totalNew;
                                else
                                    totalMyStockCount = totalUsed;
                                    
                                if (photosAndExtrasArray.count !=totalMyStockCount)
                                {
                                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
                                }
                            }
                            
                            else
                            {
                                if([strNewUsedVehicle isEqualToString:@"new"])
                                    totalMyStockCount = totalNew;
                                else
                                    totalMyStockCount = totalUsed;
                                
                                NSLog(@"PHOTOSEXTRAS ARRAY CNT 1 = %lu",(unsigned long)photosAndExtrasArray.count);
                                NSLog(@"TOTALSTOCK = %d",totalMyStockCount);
                                
                                if (photosAndExtrasArray.count !=totalMyStockCount)
                                {
                                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
                                }
                            }
                        }
                        else
                        {
                            if([self.txtFieldKeywordSearch.text length] != 0)
                            {
                                if([strNewUsedVehicle isEqualToString:@"new"])
                                    totalMyStockCount = totalNew;
                                else
                                    totalMyStockCount = totalUsed;
                                
                                if (photosAndExtrasArray.count !=totalMyStockCount)
                                {
                                    NSLog(@"PHOTOSEXTRAS ARRAY CNT 2 = %lu",(unsigned long)photosAndExtrasArray.count);
                                    NSLog(@"TOTALSTOCK = %d",totalMyStockCount);
                                    
                                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                                }
                            }
                            else
                            {
                                if([strNewUsedVehicle isEqualToString:@"new"])
                                    totalMyStockCount = totalNew;
                                else
                                    totalMyStockCount = totalUsed;
                                
                                if (photosAndExtrasArray.count !=totalMyStockCount)
                                {
                                    NSLog(@"PHOTOSEXTRAS ARRAY CNT 3 = %lu",(unsigned long)photosAndExtrasArray.count);
                                    NSLog(@"TOTALSTOCK = %d",totalMyStockCount);
                                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                
                
                if (arrayOfGroupStock.count-1 == indexPath.row)
                {
                    if(arrayOfGroupStock.count-1 >=9)
                    {
                        
                        ++pageNumberCount;
                        isLoadMore=YES;
                        if([self.txtFieldSortOption.text length]!=0)
                        {
                            SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
                            
                            int sortOrder;
                            
                            if(objectForRow.isAscending)
                                sortOrder = 1;
                            else
                                sortOrder = 2;
                            
                            
                            
                            if([self.txtFieldKeywordSearch.text length] != 0)
                            {
                                if([strNewUsedVehicle isEqualToString:@"new"])
                                    totalGroupStockCount = totalNew;
                                else
                                    totalGroupStockCount = totalUsed;
                                
                                
                                if (arrayOfGroupStock.count !=totalGroupStockCount)
                                {
                                    NSLog(@"arrayOfGroupStock = %lu",(unsigned long)arrayOfGroupStock.count);
                                    NSLog(@"totalGroupStockCount = %d",totalGroupStockCount);
                                    
                                    [self getTheGroupStockWithSearchKey_SortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
                                }
                            }
                            
                            else
                            {
                                if([strNewUsedVehicle isEqualToString:@"new"])
                                    totalGroupStockCount = totalNew;
                                else
                                    totalGroupStockCount = totalUsed;
                                
                                if (arrayOfGroupStock.count !=totalGroupStockCount)
                                {
                                    [self getTheGroupStockWithSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
                                }
                            }
                        }
                        else
                        {
                            if([self.txtFieldKeywordSearch.text length] != 0)
                            {
                                if([strNewUsedVehicle isEqualToString:@"new"])
                                    totalGroupStockCount = totalNew;
                                else
                                    totalGroupStockCount = totalUsed;
                                
                                if (arrayOfGroupStock.count !=totalGroupStockCount)
                                {
                                    [self getTheGroupStockWithSearchKey_SortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                                }
                            }
                            else
                            {
                                if([strNewUsedVehicle isEqualToString:@"new"])
                                    totalGroupStockCount = totalNew;
                                else
                                    totalGroupStockCount = totalUsed;
                                
                                if (arrayOfGroupStock.count !=totalGroupStockCount)
                                {
                                    
                                    [self getTheGroupStockWithSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                                }
                            }
                        }
                    }
                    
                }
            }
            
            return cellPhotosExtras;
        }
        else
        {
            SMStockListCell *cellVariant = [tableView dequeueReusableCellWithIdentifier:cellIdentifer2 forIndexPath:indexPath];
            SMLoadVehiclesObject *selectTypeObj;
            if(self.isFromEBrochure)
                selectTypeObj = (SMLoadVehiclesObject*)[arrmVariants objectAtIndex:indexPath.row];
            else
               selectTypeObj = (SMLoadVehiclesObject*)[arrmVariants objectAtIndex:indexPath.row];
            cellVariant.lblVariantName.text = selectTypeObj.strMakeName;
            if([selectTypeObj.strPrice isEqualToString:@"R0"])
                selectTypeObj.strPrice = @"R?";
            [self setAttributedTextForVehicleDetailsWithFirstText:@"New" andWithSecondText:selectTypeObj.strMeanCodeNumber andWithThirdText:@"Ret." andWithFourthText:selectTypeObj.strPrice forLabel:cellVariant.lblVariantDetails];
            cellVariant.selectionStyle=UITableViewCellSelectionStyleNone;
            return  cellVariant;
        
        }
       
      }
    }
    else
    {
        static NSString     *CellIdentifier1 = @"SMTraderSearchSortByCell";
        
        SMDropDownObject *objectCellForRow;
        
        SMTraderSearchSortByCell *cell1 = (SMTraderSearchSortByCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        if(isTextFieldSortBy)
        {
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
            
            objectCellForRow = (SMDropDownObject *)[arraySortObject objectAtIndex:indexPath.row];
            [cell1.lblSortText setText:objectCellForRow.strSortText];
            
            return cell1;
        }
        else
        {
             cell1.imgAscDesc.hidden = YES;
            objectCellForRow = (SMDropDownObject *)[arrayVehiclesObject objectAtIndex:indexPath.row];
            [cell1.lblSortText setText:objectCellForRow.strSortText];
            
            return cell1;
        }
        
    }
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

/*-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView != self.tableSortItems)
    {
        if(!isNewVehicleFullRangeSelected)
            return self.headerView;
        return HeaderViewWithMakeModel;
        
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView != self.tableSortItems)
    {
        if(!isNewVehicleFullRangeSelected)
            return _headerView.frame.size.height;
        
            return HeaderViewWithMakeModel.frame.size.height;
        
        /*if([self.btnShowFilter isSelected])
        {
            CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
            
            UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
            
            [self.imgRightArrow setImage:rotatedImage];
            
            {
                self.txtFieldKeywordSearch.hidden = NO;
                return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 154.0: 164.0;
            }
        }
        else
        {
            self.txtFieldKeywordSearch.hidden = YES;

            CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
            UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
            [self.imgRightArrow setImage:rotatedImage];
            return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 40.0 : 40.0;

        }
    }
    return 0;
}*/
- (CGFloat)heightForText:(NSString *)bodyText
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        textSize = 304;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
        textSize = 668;
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
#pragma - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView != self.tableSortItems)
    {
       /* if(self.isFromEBrochure && indexPath.row == 0)
        {
            return 82.0;
        }*/
        if(!isNewVehicleFullRangeSelected)
        {
            SMPhotosAndExtrasObject *photoObject;
            
            if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
            {
                photoObject=(SMPhotosAndExtrasObject *)[photosAndExtrasArray objectAtIndex:indexPath.row];
            }
            else
            {
                photoObject=(SMPhotosAndExtrasObject *)[arrayOfGroupStock objectAtIndex:indexPath.row];
            }
            
            CGFloat height;
            NSString *str = [NSString stringWithFormat:@"%@ %@",photoObject.strUsedYear,photoObject.strVehicleName];
            height = [self heightForTextForVehicle:str ];
            
            
            if (photoObject.strNotes.length == 0) {
                
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
                    return height+105;//101
                }
                else
                {
                    return height+145.0f;//140
                }
            }
            else{
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
                    return height+135.0f;
                    //return 160.0f;//128
                }
                else
                {
                    return height+190.f;
                    //return 222.0f;//186
                }
            }
        }
        else
            return UITableViewAutomaticDimension;
        
    }
    else
    {
        return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 40.0 : 50.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.view endEditing:YES];
    
    if(tableView != self.tableSortItems)
    {
        
        if(self.isFromEBrochure)
        {
            {
                if(!isNewVehicleFullRangeSelected)
                {
                    SMStockVehicleDetailController *vehicleDetailVC = [[SMStockVehicleDetailController alloc] initWithNibName:@"SMStockVehicleDetailController" bundle:nil];
                    if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
                    {
                        vehicleDetailVC.photosExtrasObject = [photosAndExtrasArray objectAtIndex:indexPath.row];
                    }
                    else
                    {
                        vehicleDetailVC.photosExtrasObject = [arrayOfGroupStock objectAtIndex:indexPath.row];
                    }
                    isLoadMore=NO;
                    vehicleDetailVC.isFromVariantList = NO;
                    vehicleDetailVC.selectedVehicleDropdownValue = selectedRowForVehiclesDropdown;
                    [self.navigationController pushViewController:vehicleDetailVC animated:YES];
                }
                else
                {
                    SMStockVehicleDetailController *vehicleDetailVC = [[SMStockVehicleDetailController alloc] initWithNibName:@"SMStockVehicleDetailController" bundle:nil];
                    vehicleDetailVC.objVariantSelected = [arrmVariants objectAtIndex:indexPath.row];
                    
                    isLoadMore=NO;
                    vehicleDetailVC.isFromVariantList = YES;
                    vehicleDetailVC.selectedVehicleDropdownValue = selectedRowForVehiclesDropdown;
                    [self.navigationController pushViewController:vehicleDetailVC animated:YES];
                }
            }
           /* else
            {
                if(!isNewVehicleFullRangeSelected)
                {
                    SMStockVehicleDetailController *vehicleDetailVC = [[SMStockVehicleDetailController alloc] initWithNibName:@"SMStockVehicleDetailControlleriPad" bundle:nil];
                    //vehicleDetailVC.photosExtrasObject = loadPhotosAndExtrasObject;
                    if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
                    {
                        vehicleDetailVC.photosExtrasObject = [photosAndExtrasArray objectAtIndex:indexPath.row];
                    }
                    else
                    {
                        vehicleDetailVC.photosExtrasObject = [arrayOfGroupStock objectAtIndex:indexPath.row];
                    }
                    isLoadMore=NO;
                    [self.navigationController pushViewController:vehicleDetailVC animated:YES];
                }
            }*/
        }
        else
        {
            
            
            
            if(!isNewVehicleFullRangeSelected)
            {
                SMVehicleStockDetailViewController *vehicleDetailVC = [[SMVehicleStockDetailViewController alloc] initWithNibName:@"SMVehicleStockDetailViewController" bundle:nil];
                
                vehicleDetailVC.photosExtrasObject = loadPhotosAndExtrasObject;
                if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
                {
                    vehicleDetailVC.photosExtrasObject = [photosAndExtrasArray objectAtIndex:indexPath.row];
                }
                else
                {
                    vehicleDetailVC.photosExtrasObject = [arrayOfGroupStock objectAtIndex:indexPath.row];
                }
                vehicleDetailVC.isFromVariantList = NO;
                vehicleDetailVC.selectedVehicleIDFromDropdown = selectedRowForVehiclesDropdown;
                isLoadMore=NO;
                [self.navigationController pushViewController:vehicleDetailVC animated:YES];

            }
            else
            {
                SMVehicleStockDetailViewController *vehicleDetailVC = [[SMVehicleStockDetailViewController alloc] initWithNibName:@"SMVehicleStockDetailViewController" bundle:nil];
                
                vehicleDetailVC.objVariantSelected = [arrmVariants objectAtIndex:indexPath.row];
                
                isLoadMore=NO;
                vehicleDetailVC.isFromVariantList = YES;
                vehicleDetailVC.selectedVehicleIDFromDropdown = selectedRowForVehiclesDropdown;
                [self.navigationController pushViewController:vehicleDetailVC animated:YES];
            }
            
            
        }
    }
    else
    {
      
        self.lblNoRecords.hidden = YES;
       
        
        pageNumberCount=0;
        oldArrayCount=0;
        [photosAndExtrasArray removeAllObjects];
        if(arrayOfGroupStock.count > 0)
            [arrayOfGroupStock removeAllObjects];
        
        
        
        SMDropDownObject *objectDidSelectForRow;
        
        if(isTextFieldSortBy)
            objectDidSelectForRow = (SMDropDownObject *)[arraySortObject objectAtIndex:indexPath.row];
        else
            objectDidSelectForRow = (SMDropDownObject *)[arrayVehiclesObject objectAtIndex:indexPath.row];
        
        // below conditions was added by Jignesh K on 13 March
        if (selectedRow == indexPath.row)
        {
            objectDidSelectForRow.isAscending = !objectDidSelectForRow.isAscending;
        }
        else
        {
            objectDidSelectForRow.isAscending = YES;
            
        }
        
        //END -  below conditions was added by Jignesh K on 13 March
        
        
        SMTraderSearchSortByCell *selectedCell = (SMTraderSearchSortByCell*)[self.tableSortItems cellForRowAtIndexPath:indexPath];
        
        SMDropDownObject *objectCellForRow;
        
        if(isTextFieldSortBy)
            objectCellForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:indexPath.row];
        else
            objectCellForRow = (SMDropDownObject*)[arrayVehiclesObject objectAtIndex:indexPath.row];
        
        if(isTextFieldSortBy)
        {
            selectedRow = (int)indexPath.row;
            
            if(objectCellForRow.isAscending)
            {
                selectedCell.imgAscDesc.transform = CGAffineTransformMakeRotation(M_PI);
                if([objectDidSelectForRow.strSortText isEqualToString:@"-- None --"])
                    [self.txtFieldSortOption setText:objectDidSelectForRow.strSortText];
                else
                {
                    [self.txtFieldSortOption setText:[NSString stringWithFormat:@"%@ (Ascending)",objectDidSelectForRow.strSortText]];
                    
                }
            }
            else
            {
                selectedCell.imgAscDesc.transform = CGAffineTransformMakeRotation(0);
                if([objectDidSelectForRow.strSortText isEqualToString:@"-- None --"])
                    [self.txtFieldSortOption setText:objectDidSelectForRow.strSortText];
                else
                    [self.txtFieldSortOption setText:[NSString stringWithFormat:@"%@ (Descending)",objectDidSelectForRow.strSortText]];
                
            }
            
            
           /* SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:indexPath.row];
            
            int sortOrder;
            
            if(objectForRow.isAscending)
                sortOrder = 1;
            else
                sortOrder = 2;
            if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
            {
                if([self.txtFieldKeywordSearch.text length] != 0)
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:(int)indexPath.row andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
                else
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:(int)indexPath.row andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
            }
            else
            {
                if([self.txtFieldKeywordSearch.text length] == 0)
                    [self getTheGroupStockWithSortText:[self sortOptionSelectedWithSortIndex:(int)indexPath.row andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
                else
                    [self getTheGroupStockWithSearchKey_SortText:[self sortOptionSelectedWithSortIndex:(int)indexPath.row andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
                
            }*/
            
        }
        else
        {
            // Vehicles dropdown
           
            self.txtFieldKeywordSearch.text = @"";
            selectedRowForVehiclesDropdown = (int)indexPath.row;
            SMDropDownObject *objectDidSelectForRow;
            
            objectDidSelectForRow = (SMDropDownObject *)[arrayVehiclesObject objectAtIndex:indexPath.row];
            
            if([objectDidSelectForRow.strSortText isEqualToString:@"Used Vehicles in Stock"] )
            {
                
                strNewUsedVehicle = @"used";
                txtFieldMakeDropdown.text = @"";
                txtFieldModelDropdown.text = @"";
                if(arrmVariants.count > 0)
                {
                    [arrmVariants removeAllObjects];
                    [_tblViewStockList reloadData];
                }
                isNewVehicleFullRangeSelected = NO;
                viewContainingSortBy.hidden = NO;
                self.headerView.hidden = NO;
                HeaderViewWithMakeModel.hidden = YES;
                /*CGRect newFrame = _headerView .frame;
                newFrame.size.height = 163;
                _headerView.frame = newFrame;*/
                [self.view addConstraint:self.bottomConstraintOfHeaderOldToTableView];
                ///////////////////////Monami //////////////////////////
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                    desired_y_value = 165.0;
                _heightHeaderOLD.constant = 266;
                }else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    if( isListClicked == YES){
                        desired_y_value = 195.0;
                       _heightConstraintHeaderViewOld.constant = 272;
                    }else{
                        desired_y_value = 238.0;
                        _heightConstraintHeaderViewOld.constant = 350;
                    }
                }
                //////////////////////END //////////////////////////////////
                self.bottomConstraintOfHeaderOldToTableView.constant = 0;
                _heightConstraintForSortFilter.constant = 36;
                self.txtFieldVehiclesDropdown.text = objectDidSelectForRow.strSortText;
                
            }
           
            else if([objectDidSelectForRow.strSortText isEqualToString:@"New Vehicles Full Range"] )
            {
                
                strNewUsedVehicle = @"new";
               isNewVehicleFullRangeSelected = YES;
                self.headerView.hidden = YES;
                _heightHeaderOLD.constant = 0;
                [self.view removeConstraint:self.bottomConstraintOfHeaderOldToTableView];
                HeaderViewWithMakeModel.hidden = NO;
                //////////////////////Monami/////////////////////////////
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                    desired_y_value = 165.0;
                _heightConstraintHeaderVariant.constant = 266;
                }else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    desired_y_value = 285.0;
                
                _heightConstraintHeaderVariant.constant = 277;
                }
                /////////////////////END /////////////////////////////////
                
               // self.bottomConstraintOfHeaderOldToTableView.constant = 36;
               // _heightConstraintForSortFilter.constant = 36;
                
                 //[self.view layoutIfNeeded];
            
                txtFieldVehiclesDropdownMMV.text = objectDidSelectForRow.strSortText;
                
                /////////////////Monami///////////////
                // For StockList Screen ///////////////
                if(!self.isFromEBrochure){
                    dispatch_async(dispatch_get_main_queue(), ^{
                    _vwReplace.hidden = YES;
                    _vwUpload.hidden = YES;
                    vwForDividerForHeaderViewVarient.hidden = YES;
                    vwHeaderVarientForReplace.hidden = YES;
                        });
                    
                }
               ////////// For eBrochure screen///////////
                /// View will be hidden After List click
                else{
                    if(isListClicked == YES){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _vwReplace.hidden = YES;
                            _vwUpload.hidden = YES;
                            vwForDividerForHeaderViewVarient.hidden = YES;
                            vwForDivider.hidden = YES;
                            vwHeaderVarientForReplace.hidden = YES;
                        });
                    }else{
                        if(isReplaced == NO){
                            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                btnReplaceForViewVarient.frame = CGRectMake( btnReplaceForViewVarient.frame.origin.x, 23, btnReplaceForViewVarient.frame.size.width, btnReplaceForViewVarient.frame.size.height);
                                _imgProfilePicFullRange.frame = CGRectMake( _imgProfilePicFullRange.frame.origin.x, 19, _imgProfilePicFullRange.frame.size.width, _imgProfilePicFullRange.frame.size.height);
                                lblPlaceholderFontFullRange.frame = CGRectMake( lblPlaceholderFontFullRange.frame.origin.x, 19, lblPlaceholderFontFullRange.frame.size.width, lblPlaceholderFontFullRange.frame.size.height);
                            });
                            }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    btnReplaceForViewVarient.frame = CGRectMake( btnReplaceForViewVarient.frame.origin.x, 23, btnReplaceForViewVarient.frame.size.width, btnReplaceForViewVarient.frame.size.height);
                                    _imgProfilePicFullRange.frame = CGRectMake( _imgProfilePicFullRange.frame.origin.x, 19, _imgProfilePicFullRange.frame.size.width, _imgProfilePicFullRange.frame.size.height);
                                    lblPlaceholderFontFullRange.frame = CGRectMake( lblPlaceholderFontFullRange.frame.origin.x, 19, lblPlaceholderFontFullRange.frame.size.width, lblPlaceholderFontFullRange.frame.size.height);
                                });
                            }
                        }else{
                        
                            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                btnReplaceForViewVarient.frame = CGRectMake( btnReplaceForViewVarient.frame.origin.x, 5, btnReplaceForViewVarient.frame.size.width, btnReplaceForViewVarient.frame.size.height);
                                _imgProfilePicFullRange.frame = CGRectMake( _imgProfilePicFullRange.frame.origin.x, 3, _imgProfilePicFullRange.frame.size.width, _imgProfilePicFullRange.frame.size.height);
                                 });
                            }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    btnReplaceForViewVarient.frame = CGRectMake( btnReplaceForViewVarient.frame.origin.x, 10, btnReplaceForViewVarient.frame.size.width, btnReplaceForViewVarient.frame.size.height);
                                    _imgProfilePicFullRange.frame = CGRectMake( _imgProfilePicFullRange.frame.origin.x, 25, _imgProfilePicFullRange.frame.size.width, _imgProfilePicFullRange.frame.size.height);
                                });
                            }
                        }

                       
                    }
                
                }
                //////////////////////////END ////////////////////////////////////
            }
            else if([objectDidSelectForRow.strSortText isEqualToString:@"Group Used Vehicles in Stock"] )
            {
                
               strNewUsedVehicle = @"used";
                txtFieldMakeDropdown.text = @"";
                txtFieldModelDropdown.text = @"";
                if(arrmVariants.count > 0)
                {
                    [arrmVariants removeAllObjects];
                    [_tblViewStockList reloadData];
                }
                 isNewVehicleFullRangeSelected = NO;
                viewContainingSortBy.hidden = YES;
                self.headerView.hidden = NO;
                HeaderViewWithMakeModel.hidden = YES;
                
                /*CGRect newFrame = _headerView .frame;
                newFrame.size.height = 125;
                _headerView.frame = newFrame;*/
                [self.view addConstraint:self.bottomConstraintOfHeaderOldToTableView];
                
                /////////////////Monami /////////////////////////////
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                    desired_y_value = 135.0;
                _heightHeaderOLD.constant = 230;
                }else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    desired_y_value = 225.0;
                _heightHeaderOLD.constant = 220;
                }
                ////////////////////////END/////////////////////////////////
                 self.bottomConstraintOfHeaderOldToTableView.constant = 0;
                _heightConstraintForSortFilter.constant = 0;
                self.txtFieldVehiclesDropdown.text = objectDidSelectForRow.strSortText;
               
                
                
            }
            else if([objectDidSelectForRow.strSortText isEqualToString:@"New Vehicles in Stock"] )
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    strNewUsedVehicle = @"new";
                    txtFieldMakeDropdown.text = @"";
                    txtFieldModelDropdown.text = @"";
                    if(arrmVariants.count > 0)
                    {
                        [arrmVariants removeAllObjects];
                        [_tblViewStockList reloadData];
                    }
                    isNewVehicleFullRangeSelected = NO;
                    viewContainingSortBy.hidden = YES;
                    self.headerView.hidden = NO;
                    HeaderViewWithMakeModel.hidden = YES;
                    _heightConstraintForSortFilter.constant = 0;
                    //UIView *headerView = [self.tblViewStockList headerViewForSection:0];
                    /* CGRect newFrame = _headerView .frame;
                     newFrame.size.height = 80;
                     _headerView.frame = newFrame;*/
                    [self.view addConstraint:self.bottomConstraintOfHeaderOldToTableView];
                    //////////////////Monami///////////////////////////
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                        desired_y_value = 135.0;
                    _heightHeaderOLD.constant = 230;
                    }
                    else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                        desired_y_value = 180.0;
                    _heightHeaderOLD.constant = 150;
                    }
                    ////////////////////END////////////////////////////////
                    [_headerView layoutIfNeeded];
                    [_headerView updateConstraints];
                    //self.bottomConstraintOfHeaderOldToTableView.constant = 0;
                    self.txtFieldVehiclesDropdown.text = objectDidSelectForRow.strSortText;
                });
                
                
               
              
            }
            else
            {
                
                strNewUsedVehicle = @"new";
                txtFieldMakeDropdown.text = @"";
                txtFieldModelDropdown.text = @"";
                if(arrmVariants.count > 0)
                {
                    [arrmVariants removeAllObjects];
                    [_tblViewStockList reloadData];
                }
                isNewVehicleFullRangeSelected = NO;
                viewContainingSortBy.hidden = YES;
                self.headerView.hidden = NO;
                HeaderViewWithMakeModel.hidden = YES;
               
                CGRect newFrame = _headerView .frame;
                newFrame.size.height = 130;
                _headerView.frame = newFrame;
                 [self.view addConstraint:self.bottomConstraintOfHeaderOldToTableView];
                //////////////////////////Monami///////////////////////
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
                    desired_y_value = 135.0;
                _heightHeaderOLD.constant = 230;
                }else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    desired_y_value = 225.0;
                _heightHeaderOLD.constant = 220;
                }
                //////////////////END///////////////////////////////
                 self.bottomConstraintOfHeaderOldToTableView.constant = 0;
              
                _heightConstraintForSortFilter.constant = 0;
                self.txtFieldVehiclesDropdown.text = objectDidSelectForRow.strSortText;
                
               
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.tblViewStockList.frame = CGRectMake( self.tblViewStockList.frame.origin.x, desired_y_value,  self.tblViewStockList.frame.size.width, self.tblViewStockList.frame.size.height+30);
        });
        [self.tblViewStockList reloadData];
        [self hidePopUpView];
    }
    
}



- (void)registerNib
{
   // if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tblViewStockList registerNib:[UINib nibWithNibName:@"SMStockListCell" bundle:nil] forCellReuseIdentifier:@"SMStockListCell"];
        
      //  [self.tblViewStockList registerNib:[UINib nibWithNibName:@"SMBrochureProfileCell" bundle:nil] forCellReuseIdentifier:@"SMBrochureProfileCell"];
        
        [self.tblViewStockList registerNib:[UINib nibWithNibName:@"SMStockListVariantCell" bundle:nil] forCellReuseIdentifier:@"SMStockListVariantCell"];
        
       [self.tableSortItems registerNib:[UINib nibWithNibName:@"SMTraderSearchSortByCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMTraderSearchSortByCell"];
    }
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tableSortItems registerNib:[UINib nibWithNibName:@"SMTraderSearchSortByCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMTraderSearchSortByCell"];
        [self.tblViewStockList registerNib:[UINib nibWithNibName:@"SMStockListCell" bundle:nil] forCellReuseIdentifier:@"SMStockListCell"];
    }
    else
    {
        [self.tableSortItems registerNib:[UINib nibWithNibName:@"SMTraderSearchSortByCell_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMTraderSearchSortByCell"];
         [self.tblViewStockList registerNib:[UINib nibWithNibName:@"SMStockListCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMStockListCell"];
    }
    
   /* else
    {
        [self.tblViewStockList registerNib:[UINib nibWithNibName:@"SMStockListCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMStockListCell"];
        
        [self.tblViewStockList registerNib:[UINib nibWithNibName:@"SMStockListVariantCell" bundle:nil] forCellReuseIdentifier:@"SMStockListVariantCell"];
        
        [self.tableSortItems registerNib:[UINib nibWithNibName:@"SMTraderSearchSortByCell_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMTraderSearchSortByCell"];
    }*/
}

- (IBAction)btnShowFilterDidClicked:(id)sender
{
    [self.btnShowFilter setSelected:!self.btnShowFilter.selected];
    [self.tblViewStockList reloadData];
    [self hideProgressHUD];
}
- (IBAction)segmentControlDidClicked:(id)sender
{
     NSLog(@"isLoadMoreSegment = %d",isLoadMore);
    switch (self.segmentControlForChoices.selectedSegmentIndex)
    {
        case 0:
        {
            //isGroupStockSection = NO;
            StatusIDForChoices = 1;
            [self.lblRetailCnt setTextColor:[UIColor whiteColor]];
            [self.lblExcludedCnt setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
            


            
        }
            break;
        case 1:
        {
            //isGroupStockSection = YES;
            StatusIDForChoices = 1;
            [self.lblExcludedCnt   setTextColor:[UIColor whiteColor]];
            [self.lblRetailCnt setTextColor:[UIColor colorWithRed:46.0/255.0 green:81.0/255.0 blue:156.0/255.0 alpha:1.0]];
        }
            break;
    }
    
    pageNumberCount=0;
    oldArrayCount=0;
     NSLog(@"GROUPSTOCK = %d",isGroupStockSection);
    
    if([self.txtFieldSortOption.text length]!=0)
    {
        SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
        
        int sortOrder;
        
        if(objectForRow.isAscending)
            sortOrder = 1;
        else
            sortOrder = 2;
        
        
       NSLog(@"GROUPSTOCK = %d",isGroupStockSection);
        
        if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
        {
            if([self.txtFieldKeywordSearch.text length] != 0)
            [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
            else
            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
        }
        else
        {
            if([self.txtFieldKeywordSearch.text length] == 0)
                [self getTheGroupStockWithSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
            else
                [self getTheGroupStockWithSearchKey_SortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
        
        }
        
    }
    else
    {
        if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
        {
            if([self.txtFieldKeywordSearch.text length] != 0)
            [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
            else
            [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
        }
        else
        {
            if([self.txtFieldKeywordSearch.text length] == 0)
                [self getTheGroupStockWithSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
            else
                [self getTheGroupStockWithSearchKey_SortText:@"price:asc" andNewUsed:strNewUsedVehicle];
        
        }
        
    }
    

    
    [self.segmentControlForChoices setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:13.0],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
}





#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtFieldSortOption)
    {
        isTextFieldSortBy = YES;
       
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        [self.tableSortItems reloadData];
        [self loadPopUpView];
        
        return NO;
    }
    else if(textField == self.txtFieldVehiclesDropdown || textField == txtFieldVehiclesDropdownMMV)
    {
        isTextFieldSortBy = NO;
       
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        [self.tableSortItems reloadData];
        [self loadPopUpView];
        
        return NO;
    }
    else if (textField == txtFieldMakeDropdown)
    {
        if(arrmMakes.count == 0)
        {
            NSMutableURLRequest * requestURL = [SMWebServices listMakesForNewVehicle:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue year:[self returnCurrentYear]];
            [self webserviceCallForMakesModelVariantNewVehiclesWithRequest:requestURL];
        }
        else
        {
            
            {
                [searchMakeVC getTheDropDownData:arrmMakes];
                [self.view addSubview:searchMakeVC];
                [SMReusableSearchTableViewController getTheSelectedSearchDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue) {
                    NSLog(@"selected text = %@",selectedTextValue);
                    NSLog(@"selected ID = %d",selectIDValue);
                    selectedMakeID = selectIDValue;
                    txtFieldMakeDropdown.text = selectedTextValue;
                    txtFieldModelDropdown .text = @"";
                    
                }];
                [self hideProgressHUD];
                
            }
        }
        [self.view endEditing:YES];
        
        return NO;
    }
    else if (textField == txtFieldModelDropdown)
    {
        if (txtFieldMakeDropdown.text.length == 0)
        {
            SMAlert(KLoaderTitle,KMakeSelection);
            return NO;
        }
        else
        {
            
            if(arrmModels.count == 0)
            {
            
             NSMutableURLRequest * requestURL = [SMWebServices listActiveModelsForNewVehicles:[SMGlobalClass sharedInstance].hashValue Year:[self returnCurrentYear] makeId:selectedMakeID];
            [self webserviceCallForMakesModelVariantNewVehiclesWithRequest:requestURL];
            }
            else
            {
                
                /*************  your Request *******************************************************/
                NSArray *arrLoadNib1 = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
                SMCustomPopUpTableView *popUpView = [arrLoadNib1 objectAtIndex:0];
                
                
                [popUpView getTheDropDownData:arrmModels withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view addSubview:popUpView];
                });
                
                
                /*************  your Request *******************************************************/
                
                
                
                /*************  your Response *******************************************************/
                
                [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                    NSLog(@"selected text = %@",selectedTextValue);
                    NSLog(@"selected ID = %d",selectIDValue);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        txtFieldModelDropdown.text = selectedTextValue;
                        
                    });
                    
                    selectedModelID = selectIDValue;
                }];
                
                
                [self hideProgressHUD];
                
            }
        
        [self.view endEditing:YES];
        return NO;
        }
    }
    /*else if (textField == txtFieldVariantDropdown)
    {
        NSMutableURLRequest * requestURL = [SMWebServices listVariantsForNewVehicles:[SMGlobalClass sharedInstance].hashValue Year:[self returnCurrentYear] withModel:selectedModelID];
        [self.view endEditing:YES];
        [self webserviceCallForMakesModelVariantNewVehiclesWithRequest:requestURL];
        return NO;
    }*/
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtFieldKeywordSearch)
    {
        
        [textField resignFirstResponder];
        
        if([self.txtFieldKeywordSearch.text length]!=0)
        {
            isLoadMore = NO;
            [self callTheWebServiceForSearch];
        }
        else
        {
            if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
            {
                [photosAndExtrasArray removeAllObjects];
                [self.tblViewStockList reloadData];
                
                pageNumberCount=0;
                oldArrayCount  =0;
                
                if([SMGlobalClass sharedInstance].isListModule)
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                else
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
            }
            else
            {
                [arrayOfGroupStock removeAllObjects];
                [self.tblViewStockList reloadData];
                
                pageNumberCount=0;
                oldArrayCount  =0;
                
                [self getTheGroupStockWithSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                
            }
            
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



-(void)loadPhotosAndExtrasWSWithStatusID:(int)statusID andSortText:(NSString*)sortText andNewUsed:(NSString*) newUsedVehicle
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingVehiclePhotosAndExtrasList:[SMGlobalClass sharedInstance].hashValue withstatusID:statusID withClientID:[[SMGlobalClass sharedInstance].strClientID intValue] withPageSize:10 withPageNumber:pageNumberCount sort:sortText andNewUsed:newUsedVehicle];
    
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

-(int) returnCurrentYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter  setDateFormat:@"yyyy"];
    NSString *currentYear = [formatter stringFromDate:[NSDate date]];
    return currentYear.intValue;
}

#pragma mark - WEbservice for Image Availability

//////////////////////////////////////Monami////////////////////////

// API CALL FOR UPDATE PROFILE IMAGE //////////////////////////////////

-(void)updateProfileImageApiCall:(NSString *)imageFileName andBase64:(NSString *) Base64Str{
    
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    NSMutableURLRequest * requestURL = [SMWebServices UpdateProfileImageWith:[SMGlobalClass sharedInstance].hashValue andimageFilename:imageFileName andbase64EncodedString:Base64Str];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            if (error!=nil)
                                            {
                                                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                    // Do something...
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        SMAlert(@"Error", error.localizedDescription);
                                                        [self hideProgressHUD];
                                                        return;
                                                    });
                                                });
                                                
                                            }
                                            else
                                            {
                                                
                                                xmlPEParser = [[NSXMLParser alloc] initWithData:data];
                                                [xmlPEParser setDelegate:self];
                                                [xmlPEParser setShouldResolveExternalEntities:YES];
                                                [xmlPEParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
}
//////////////////////////////////////  END   ///////////////////////////////////////////////////


/////////////////////////////Monami/////////////////////////////////////////

///////////////Has Profile Image WS////////////////////////////////////////

-(void)CheckAvailabilityOfImage {
        NSURLSession *dataTaskSession ;
        [HUD show:YES];
        HUD.labelText = KLoaderText;
        
        NSMutableURLRequest * requestURL = [SMWebServices ImageAvailableOrNot:[SMGlobalClass sharedInstance].hashValue];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.HTTPMaximumConnectionsPerHost = 1;
        dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        
        NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                            {
                                                if (error!=nil)
                                                {
                                                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                        // Do something...
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            SMAlert(@"Error", error.localizedDescription);
                                                            [self hideProgressHUD];
                                                            return;
                                                        });
                                                    });
                                                    
                                                }
                                                else
                                                {
                                                    
                                                    xmlPEParser = [[NSXMLParser alloc] initWithData:data];
                                                    [xmlPEParser setDelegate:self];
                                                    [xmlPEParser setShouldResolveExternalEntities:YES];
                                                    [xmlPEParser parse];
                                                }
                                            }];
        
        [uploadTask resume];
        
    

}
///////////////Get Profile Image WS////////////////////////////////////////

-(void)GetProfileImage {
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    NSMutableURLRequest * requestURL = [SMWebServices GetProfileImage:[SMGlobalClass sharedInstance].hashValue];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            if (error!=nil)
                                            {
                                                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                    // Do something...
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        SMAlert(@"Error", error.localizedDescription);
                                                        [self hideProgressHUD];
                                                        return;
                                                    });
                                                });
                                                
                                            }
                                            else
                                            {
                                                
                                                xmlPEParser = [[NSXMLParser alloc] initWithData:data];
                                                [xmlPEParser setDelegate:self];
                                                [xmlPEParser setShouldResolveExternalEntities:YES];
                                                [xmlPEParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
    
    
}


/////////////////////////////////  END //////////////////////////////////////////////////
#pragma mark - WEbservice for Make, Model and Variant

-(void) webserviceCallForMakesModelVariantNewVehiclesWithRequest:(NSMutableURLRequest*) requestURL
{
    [HUD show:YES];
    
    NSURLSession *dataTaskSession ;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            NSLog(@"Response = %@",response.description);
                                            NSLog(@"error = %@",error.description);
                                            if (error!=nil)
                                            {
                                                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                    // Do something...
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        SMAlert(@"Error", error.localizedDescription);
                                                        [self hideProgressHUD];
                                                        return;
                                                    });
                                                });
                                                
                                            }
                                            else
                                            {
                                                xmlPEParser = [[NSXMLParser alloc] initWithData:data];
                                                [xmlPEParser setDelegate:self];
                                                [xmlPEParser setShouldResolveExternalEntities:YES];
                                                
                                                if(arrmVariants.count > 0)
                                                   [arrmVariants removeAllObjects];
                                                
                                                [xmlPEParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
}

-(void)loadPhotosAndExtrasWithSearchWSWithStatusCode:(int)statusCode andSortText:(NSString*)sortText andNewUsed:(NSString*) newUsed
{
    //    [HUD show:YES];
    //    [HUD setLabelText:KLoaderText];
    
    [[MGProgressObject sharedInstance] showProgressHUDWithText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices filterThePhotosNExtrasBasedOnSearchWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andsearchKeyword:self.txtFieldKeywordSearch.text andPageSize:10 andPageNumber:pageNumberCount andStatus:statusCode andSortText:sortText andNewUsed:newUsed];
    
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
            
             
             NSLog(@"isloadMore = %d",isLoadMore);
             
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

-(void)getTheGroupStockWithSortText:(NSString*)sortText andNewUsed:(NSString*) newUsed
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices listGroupStockVehiclesWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andStatus:1 andPageSize:10 andPageNumber:pageNumberCount andSortText:sortText andNewUsed:newUsed];
    
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
                 [arrayOfGroupStock removeAllObjects];
                 
             }
             
             xmlPEParser = [[NSXMLParser alloc] initWithData:data];
             [xmlPEParser setDelegate: self];
             [xmlPEParser setShouldResolveExternalEntities:YES];
             [xmlPEParser parse];
         }
     }];
}

-(void)getTheGroupStockWithSearchKey_SortText:(NSString*)sortText andNewUsed:(NSString*) newUsed
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices listGroupStockVehiclesWithSearch_UserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andSearchKey:self.txtFieldKeywordSearch.text andPageSize:10 andPageNumber:pageNumberCount andStatus:1 andSortText:sortText andNewUsed:newUsed];
    
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
                 [arrayOfGroupStock removeAllObjects];
             }
             xmlPEParser = [[NSXMLParser alloc] initWithData:data];
             [xmlPEParser setDelegate: self];
             [xmlPEParser setShouldResolveExternalEntities:YES];
             [xmlPEParser parse];
         }
     }];
}

-(void)getTheClientsCorporateGroup
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices getClientCorporateGroupsCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andClientId:[[SMGlobalClass sharedInstance].strClientID intValue]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             xmlPEParser = [[NSXMLParser alloc] initWithData:data];
             [xmlPEParser setDelegate: self];
             [xmlPEParser setShouldResolveExternalEntities:YES];
             [xmlPEParser parse];
         }
     }];
}




-(NSString*)sortOptionSelectedWithSortIndex:(int)sortIndex andSortOrder:(int)sortOrder
{
    
    switch (sortIndex)
    {
            
        case 0:
        {
            if(sortOrder == 1)
            {
                return @"price:asc";
            }
            else
            {
                return @"price:desc";
            }
        }
            break;
            
        case 1:
        {
            if(sortOrder == 1)
                return @"price:asc";
            else
                return @"price:desc";
            
        }
            break;
            
        case 2:
        {
            if(sortOrder == 1)
                return @"mileage:asc";
            else
                return @"mileage:desc";
            
        }
            break;
            
        case 3:
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


-(void)callTheWebServiceForSearch
{
    
    pageNumberCount=0;
    oldArrayCount=0;
    
    if([self.txtFieldSortOption.text length]!=0)
    {
        SMDropDownObject *objectForRow = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRow];
        
        int sortOrder;
        
        if(objectForRow.isAscending)
            sortOrder = 1;
        else
            sortOrder = 2;
        
        if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
        {
            if([self.txtFieldKeywordSearch.text length] != 0)
                [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
            else
                [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
        }
        else
        {
            if([self.txtFieldKeywordSearch.text length] != 0)
                [self getTheGroupStockWithSearchKey_SortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
            else
                [self getTheGroupStockWithSortText:[self sortOptionSelectedWithSortIndex:selectedRow andSortOrder:sortOrder] andNewUsed:strNewUsedVehicle];
        
        }
    }
    else
    {
        if(![self.txtFieldVehiclesDropdown.text containsString:@"Group"])
        {
            if([self.txtFieldKeywordSearch.text length] != 0)
            {
                if(![SMGlobalClass sharedInstance].isListModule)
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                else
                    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:StatusIDForChoices andSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
            }
            else
            {
                if(![SMGlobalClass sharedInstance].isListModule)
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                else
                    [self loadPhotosAndExtrasWSWithStatusID:StatusIDForChoices andSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                
            }
        }
        else
        {
            if([self.txtFieldKeywordSearch.text length] != 0)
            {
                
                [self getTheGroupStockWithSearchKey_SortText:@"price:asc" andNewUsed:strNewUsedVehicle];
            }
            else
            {
                
                [self getTheGroupStockWithSortText:@"price:asc" andNewUsed:strNewUsedVehicle];
                
            }

        
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



#pragma mark -
#pragma mark - Load/Hide Drop Down For Make, Model And Variants

-(void)loadPopUpView
{
    
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (vc != self)
        return;
    
    
    [_popUpViewForSort setFrame:[UIScreen mainScreen].bounds];
    [_popUpViewForSort setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [_popUpViewForSort setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popUpViewForSort];
    [_popUpViewForSort setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [_popUpViewForSort setAlpha:0.75];
         [_popUpViewForSort setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [_popUpViewForSort setAlpha:1.0];
              [_popUpViewForSort setTransform:CGAffineTransformIdentity];
              
          }
                          completion:^(BOOL finished)
          {
          }];
         
     }];
}

-(void) hidePopUpView
{
    [_popUpViewForSort setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popUpViewForSort];
    [UIView animateWithDuration:0.1 animations:^{
        [_popUpViewForSort setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [_popUpViewForSort setAlpha:0.3];
              [_popUpViewForSort setTransform:CGAffineTransformMakeScale(0.9,0.9)];
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   [_popUpViewForSort setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [_popUpViewForSort removeFromSuperview];
                   [_popUpViewForSort setTransform:CGAffineTransformIdentity];
               }];
          }];
     }];
}

-(void)populateTheSortByArray
{
    
   // NSArray *arrayOfSortTypes = [[NSArray alloc]initWithObjects:@"-- None --",@"Age",@"Comments",@"Extras",@"Mileage",@"Photos",@"Price",@"Stock#",@"Year", nil];
    
     NSArray *arrayOfSortTypes = [[NSArray alloc]initWithObjects:@"-- None --",@"Price",@"Kilometers",@"Year", nil];
    
    
    for(int i=0;i<[arrayOfSortTypes count];i++)
    {
        SMDropDownObject *sortObject = [[SMDropDownObject alloc]init];
        sortObject.strSortText = [arrayOfSortTypes objectAtIndex:i];
        sortObject.strSortTextID = i;
        sortObject.isAscending = NO;
        [arraySortObject addObject:sortObject];
    }
}

-(void)populateVehiclesArray
{
    
    // NSArray *arrayOfSortTypes = [[NSArray alloc]initWithObjects:@"-- None --",@"Age",@"Comments",@"Extras",@"Mileage",@"Photos",@"Price",@"Stock#",@"Year", nil];
    
    NSArray *arrayOfSortTypes = [[NSArray alloc]initWithObjects:@"Used Vehicles in Stock",@"New Vehicles in Stock",@"New Vehicles Full Range",@"Group Used Vehicles in Stock", @"Group New Vehicles in Stock",nil];
    

    
    for(int i=0;i<[arrayOfSortTypes count];i++)
    {
        SMDropDownObject *sortObject = [[SMDropDownObject alloc]init];
        sortObject.strSortText = [arrayOfSortTypes objectAtIndex:i];
        sortObject.strSortTextID = i;
        [arrayVehiclesObject addObject:sortObject];
    }
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


bool isDataFoundinStockList = NO;




#pragma mark - xmlParserDelegate
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    
    
    
    if ([elementName isEqualToString:@"ListVehiclesByStatusXMLResponse"])
    {
        isDataFoundinStockList = NO;
    }
    
    else if ([elementName isEqualToString:@"stock"])
    {
        loadPhotosAndExtrasObject=[[SMPhotosAndExtrasObject alloc]init];
        isDataFoundinStockList = YES;
    }
    else if ([elementName isEqualToString:@"Make"])
    {
        loadVehiclesObject = [[SMLoadVehiclesObject alloc] init];
    }
    else if ([elementName isEqualToString:@"Model"])
    {
        modelObject = [[SMDropDownObject alloc] init];
    }
    else if ([elementName isEqualToString:@"Variant"])
    {
        loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
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
    
    // Makes...
    
     if ([elementName isEqualToString:@"makeID"])
    {
        loadVehiclesObject.strMakeId = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"makeName"])
    {
        loadVehiclesObject.strMakeName = currentNodeContent;
    }
    else if([elementName isEqualToString:@"Make"])
    {
        [arrmMakes addObject:loadVehiclesObject];
    }
    else if([elementName isEqualToString:@"ListDealerMakesGenericXMLResult"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        if (arrmMakes.count!=0)
        {
                [searchMakeVC getTheDropDownData:arrmMakes];
                [self.view addSubview:searchMakeVC];
                [SMReusableSearchTableViewController getTheSelectedSearchDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue) {
                    NSLog(@"selected text = %@",selectedTextValue);
                    NSLog(@"selected ID = %d",selectIDValue);
                    selectedMakeID = selectIDValue;
                    txtFieldMakeDropdown.text = selectedTextValue;
                    txtFieldModelDropdown .text = @"";
                    
                }];
                [self hideProgressHUD];
            
        }
        });
    }
    
    // Model...
    
    if ([elementName isEqualToString:@"modelID"])
    {
        modelObject.strMakeId = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"modelName"])
    {
        modelObject.strMakeName = currentNodeContent;
    }
    else if([elementName isEqualToString:@"Model"])
    {
        [arrmModels addObject:modelObject];
    }
    else if([elementName isEqualToString:@"ListActiveModelsXMLResult"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        if (arrmModels.count!=0)
        {
            
            
            /*************  your Request *******************************************************/
            NSArray *arrLoadNib1 = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib1 objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:arrmModels withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view addSubview:popUpView];
            });
            
            
            /*************  your Request *******************************************************/
            
            
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    txtFieldModelDropdown.text = selectedTextValue;

                });

                selectedModelID = selectIDValue;
            }];
            
            
                 [self hideProgressHUD];
            
           
        }
        });
    }
    
    else if ([elementName isEqualToString:@"variantID"])
    {
        loadVehiclesObject.strMakeId = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"meadCode"])
    {
        loadVehiclesObject.strMeanCodeNumber = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"friendlyName"])
    {
        loadVehiclesObject.strMakeName = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"price"])
    {
        NSString *trimmedPrice = [currentNodeContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        
         loadVehiclesObject.strPrice = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",trimmedPrice.intValue]];
    }
   /* else if ([elementName isEqualToString:@"EBrochureFlag"])
    {
        loadVehiclesObject.isEBrochureFlag = currentNodeContent.boolValue;
    }*/
    else if ([elementName isEqualToString:@"Variant"])
    {
        [arrmVariants addObject:loadVehiclesObject];
    }
   /* else if ([elementName isEqualToString:@"ListVariantsJSONResult"])
    {
        NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
                loadVehiclesObject.strMakeId            =dictionary[@"variantID"];
                loadVehiclesObject.strMakeName          =dictionary[@"friendlyName"];
                loadVehiclesObject.strMeanCodeNumber    =dictionary[@"meadCode"];
                loadVehiclesObject.strPrice           =dictionary[@"price"];
                loadVehiclesObject.strPrice = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",loadVehiclesObject.strPrice.intValue]];
                [arrmVariants          addObject:loadVehiclesObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
        
    }*/
    else if ([elementName isEqualToString:@"ListVariantsWithFlagXMLResponse"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        if (arrmVariants.count!=0)
        {
            [self.tblViewStockList reloadData];
                [self hideProgressHUD];
           
        }
        });
    }
    else if ([elementName isEqualToString:@"GetClientCorprateGroupsResult"])
    {
         /* if([currentNodeContent length]>0)
          {
              shouldGroupStockBeHidden = NO;
          }
          else
          {
              shouldGroupStockBeHidden = YES;
          }*/
              
    }
    
    else if ([elementName isEqualToString:@"GetClientCorprateGroupsResponse"])
    {
        
       /* UIView *headerView = [self.tblViewStockList headerViewForSection:0];
        //... update your view properties here
        if(shouldGroupStockBeHidden)
        {
            self.segmentControlForChoices.hidden = YES;
            //self.btnMyStock.hidden = NO;
            self.lblExcludedCnt.hidden = YES;
            self.lblRetailCnt.hidden = YES;
        }
        else
        {
            self.segmentControlForChoices.hidden = NO;
           // self.btnMyStock.hidden = YES;
            self.lblExcludedCnt.hidden = NO;
            self.lblRetailCnt.hidden = NO;
        }
            [headerView setNeedsDisplay];
            [headerView setNeedsLayout];*/
       
        
    }
    
    else if ([elementName isEqualToString:@"stockCode1"])
    {
        if ([currentNodeContent length] == 0)
        {
            loadPhotosAndExtrasObject.strStockCode= @"Stock code?";
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
            if([currentNodeContent isEqualToString:@"No Registration"] || [currentNodeContent isEqualToString:@""]|| [currentNodeContent isEqualToString:@"(null)"] || [currentNodeContent isEqualToString:@"0"])
            {
                loadPhotosAndExtrasObject.strRegistration=@"Reg?";//registration
            }
            else
            {
                loadPhotosAndExtrasObject.strRegistration=currentNodeContent;//registration
            }
        }
        
    }
    else if ([elementName isEqualToString:@"vehicleName"])
    {
        if ([currentNodeContent length] == 0)
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
            loadPhotosAndExtrasObject.strMileage=@"Mileage?";
            loadPhotosAndExtrasObject.mileageForSorting = 0;
        }
        else
        {
            loadPhotosAndExtrasObject.strMileage= [[SMCommonClassMethods shareCommonClassManager]mileageConvertEn_AF:currentNodeContent];
        
            loadPhotosAndExtrasObject.strMileage=[NSString stringWithFormat:@"%@ Km",loadPhotosAndExtrasObject.strMileage];
        
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
        loadPhotosAndExtrasObject.strVideosCount=currentNodeContent;
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
    if ([elementName isEqualToString:@"internalNote"])
    {
        loadPhotosAndExtrasObject.strNotes=currentNodeContent;
    }
    else if ([elementName isEqualToString:@"extras"])
    {
        loadPhotosAndExtrasObject.strExtras=currentNodeContent.boolValue;
        loadPhotosAndExtrasObject.extrasForSorting = [currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"makeName"])
    {
        if ([currentNodeContent length] == 0)
        {
            loadPhotosAndExtrasObject.strMakeName=@"Make?";

        }
        else
        {
            loadPhotosAndExtrasObject.strMakeName=currentNodeContent;

        }
    }
    else if ([elementName isEqualToString:@"age"])
    {
        if ([currentNodeContent length] == 0)
        {
           loadPhotosAndExtrasObject.strDays = @"Days?";
        }
        else
        {
            loadPhotosAndExtrasObject.strDays=[NSString stringWithFormat:@"%@ Days",currentNodeContent];
            loadPhotosAndExtrasObject.numOfDaysForSorting = [currentNodeContent intValue];

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
    else if ([elementName isEqualToString:@"total"])
    {
        //iTotalArrayCount = [currentNodeContent intValue];
        totalUsed = currentNodeContent.intValue;
        totalNew = currentNodeContent.intValue;
    }
    /*else if ([elementName isEqualToString:@"totalNew"])
    {
        totalNew = currentNodeContent.intValue;
    }
    else if ([elementName isEqualToString:@"totalUsed"])
    {
        totalUsed = currentNodeContent.intValue;
    }*/
    
    if ([elementName isEqualToString:@"EBrochureFlag"])
    {
        [SMGlobalClass sharedInstance].isBrochureFlag = [currentNodeContent boolValue];
    }
  
    if ([elementName isEqualToString:@"stock"])
    {
        
         if([self.txtFieldVehiclesDropdown.text containsString:@"Group"])
             [arrayOfGroupStock addObject:loadPhotosAndExtrasObject];
         else
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
            dispatch_async(dispatch_get_main_queue(),^
                           {
                               self.lblNoRecords.hidden = YES;
                               
                           });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),^
                           {
                               self.lblNoRecords.hidden = NO;
                               [self hideProgressHUD];
                               
                           });
            
        }

        [self.tblViewStockList reloadData];
        [self hideProgressHUD];
        [[MGProgressObject sharedInstance] hideProgressHUD];
    }
    
    if ([elementName isEqualToString:@"ListGroupVehiclesByStatusXMLResponse"] || [elementName isEqualToString:@"ListGroupVehiclesByKeywordStatusXMLResponse"])
    {
        
        if ([arrayOfGroupStock count]!=0)
        {
            if (oldArrayCount==0)
            {
                oldArrayCount=[arrayOfGroupStock count];
            }
            dispatch_async(dispatch_get_main_queue(),^
                           {
                               self.lblNoRecords.hidden = YES;
                               [self hideProgressHUD];
                               
                           });
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),^
                           {
                                   self.lblNoRecords.hidden = NO;
                                   [self hideProgressHUD];
                               
                           });
            
        }
        [self.tblViewStockList reloadData];
         [self hideProgressHUD];
        [[MGProgressObject sharedInstance] hideProgressHUD];
    }
    else if ([elementName isEqualToString:@"ListVariantsWithFlagXMLResult"])
    {
        dispatch_async(dispatch_get_main_queue(),^
        {
            if(arrmVariants.count == 0)
            {
                self.lblNoRecords.hidden = NO;
                [self hideProgressHUD];
            }
            
        });
    }
    ///////////////////////Monami  Has Profile API Response////////////////////////////
    //// Set view hidden Yes/No
   else if([elementName isEqualToString:@"HasImage"])
    {
        if([currentNodeContent isEqualToString:@"true"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            self.vwReplace.hidden = NO;
            self.vwUpload.hidden = YES;
            vwForDivider.hidden = NO;
            //[self hideProgressHUD];
            isReplaced = YES;
            [btnReplaceForViewVarient setTitle:@"Replace Profile Photo" forState:UIControlStateNormal];
            lblNOPhotoAvailable.hidden = YES;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            btnReplaceForViewVarient.frame = CGRectMake( btnReplaceForViewVarient.frame.origin.x, 8, btnReplaceForViewVarient.frame.size.width, btnReplaceForViewVarient.frame.size.height);
            _imgProfilePicFullRange.frame = CGRectMake( _imgProfilePicFullRange.frame.origin.x, 5, _imgProfilePicFullRange.frame.size.width, _imgProfilePicFullRange.frame.size.height);
                }
                else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            btnReplaceForViewVarient.frame = CGRectMake( btnReplaceForViewVarient.frame.origin.x, 12, btnReplaceForViewVarient.frame.size.width,btnReplaceForViewVarient.frame.size.height);
            _imgProfilePicFullRange.frame = CGRectMake( _imgProfilePicFullRange.frame.origin.x, 15, _imgProfilePicFullRange.frame.size.width, _imgProfilePicFullRange.frame.size.height);
                }
            [self GetProfileImage];
             });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                isReplaced = NO;
                self.vwReplace.hidden = YES;
                self.vwUpload.hidden = NO;
                vwForDivider.hidden = NO;
                [btnReplaceForViewVarient setTitle:@"Upload Profile Photo" forState:UIControlStateNormal];

                lblNOPhotoAvailable.hidden = NO;
                [HUD hide:YES];
            });
            
        }
    }
    ///////////////// Get Profile Image Response /////////////////////
    //////// Set the image after getting response
   else if ([elementName isEqualToString:@"Image"])
   {
        self.strImgName = @"";
       if(![currentNodeContent isEqualToString:@""]){
       self.strImgName = currentNodeContent;
           NSLog(@"%@",self.strImgName);
           [[SDImageCache sharedImageCache] clearMemory];
           [[SDImageCache sharedImageCache] clearDisk];
          // sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.imgViewProfilePic setImageWithURL:[NSURL URLWithString:self.strImgName] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
            
            [self.imgProfilePicFullRange setImageWithURL:[NSURL URLWithString:self.strImgName] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
            lblPlaceholderFontFullRange.hidden = YES;
            [self hideProgressHUD];
            
        });
       }
       else
       {
           dispatch_async(dispatch_get_main_queue(), ^{
               lblPlaceholderFontFullRange.hidden = NO;
             });
       }
       
   }
    //////////////// Update Profile Image  API Response
   else if([elementName isEqualToString:@"Update"])
    {
        if([currentNodeContent isEqualToString:@"Succeeded"])
        {
            NSLog(@"%@",strForProfileImage);
            [self hideProgressHUD];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.vwReplace.hidden = NO;
                isReplaced = YES;
                self.vwUpload.hidden = YES;
                vwForDivider.hidden = NO;
                NSString *str = [NSString stringWithFormat:@"%@.jpg", strForProfileImage];
                NSLog(@"IMAGE %@",str);
                NSString *fullImgName=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
                lblNOPhotoAvailable.hidden = YES;
                lblPlaceholderFontFullRange.hidden = YES;
                [btnReplaceForViewVarient setTitle:@"Replace Profile Photo" forState:UIControlStateNormal];
                [self.imgViewProfilePic setImage:[UIImage imageWithContentsOfFile:fullImgName]];
                [imgvwForUploadForOld setImage:[UIImage imageWithContentsOfFile:fullImgName]];
                [self.imgProfilePicFullRange setImage:[UIImage imageWithContentsOfFile:fullImgName]];

                strForProfileImage = @"";
               
            });
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Image uploaded successfully." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            [self hideProgressHUD];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Failed to upload Image. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
///////////////////////////////  END /////////////////////////////////////
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
         NSLog(@"GroupStock Array Count = %lu",(unsigned long)arrayOfGroupStock.count);
        NSLog(@"photosNExtras Array Count = %lu",(unsigned long)photosAndExtrasArray.count);
}

#pragma mark - Global Alert Function

-(void) showAlert:(NSString *) alertMeassge
{
    dispatch_async(dispatch_get_main_queue(),^
                   {
                       SMAlert(KLoaderTitle, alertMeassge);
                   });
}


#pragma mark - Set Attributed Text

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithFourthText:(NSString*)fourthText forLabel:(UILabel*)label
{
    NSLog(@"price1 = %@",secondText);
    NSLog(@"price2 = %@",fourthText);
    
    UIFont *valueFont;
    UIFont *titleFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:10.0];
        
    }
    
    else
    {
        valueFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        titleFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    
    UIColor *foregroundColorGreen = [UIColor colorWithRed:64.0/255.0 green:198.0/255.0 blue:42.0/255.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    valueFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    titleFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *FourthAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     valueFont, NSFontAttributeName,
                                     foregroundColorGreen, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ |",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ |",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    NSMutableAttributedString *attributedFourthText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",fourthText]
                                                                                             attributes:FourthAttribute];
    
    
    
    [attributedThirdText appendAttributedString:attributedFourthText];
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
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
    
    
    
    NSMutableAttributedString *attributedSecondText;
    
    if(selectedRowForVehiclesDropdown == 1 || selectedRowForVehiclesDropdown == 4)
    {
        attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                      attributes:SecondAttribute];
        
    }
    else
    {
        attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",secondText]
                                                                      attributes:SecondAttribute];
    }
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    [label setAttributedText:attributedFirstText];
    
    
}



- (void)setTheTitleForScreen
{
    
    listActiveSpecialsNavigTitle = [[UILabel alloc] initWithFrame:CGRectZero];
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
    listActiveSpecialsNavigTitle.text = @"Select Vehicle";
    
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
    
    
}

- (IBAction)btnCancelDidClicked:(id)sender
{
   
    [self hidePopUpView];
    
}
- (IBAction)btnListDidClicked:(id)sender {
   
    /////////////////Monami/////////////////
    // After List click image details will be hidden
    dispatch_async(dispatch_get_main_queue(),^
                   {
                       self.lblNoRecords.hidden = YES;
                       
                   });
    isListClicked = YES;
    /////////////////////Monami ////////////////////////
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        desired_y_value = 165.0;
    }else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        desired_y_value = 195.0;
        
    }
    ///////////////////END //////////////////////////////
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tblViewStockList.hidden = NO;
        _vwReplace.hidden = YES;
        _vwUpload.hidden = YES;
        vwForDivider.hidden = YES;
        vwForDividerForHeaderViewVarient.hidden = YES;
        vwHeaderVarientForReplace.hidden = YES;
    });
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tblViewStockList.frame = CGRectMake( _tblViewStockList.frame.origin.x, desired_y_value, _tblViewStockList.frame.size.width, HeightOfTableViewForIphone);
        });
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tblViewStockList.frame = CGRectMake( _tblViewStockList.frame.origin.x, desired_y_value, _tblViewStockList.frame.size.width, HeightOfTableViewForIpad);
        });
    }

   
    /////////////////End//////////////////
    self.tblViewStockList.delegate = self;
    self.tblViewStockList.dataSource = self;
    
    if(arrmVariants.count > 0)
    {
       [arrmVariants removeAllObjects];
        [_tblViewStockList reloadData];
    }
    
    if (txtFieldMakeDropdown.text.length == 0)
    {
        SMAlert(KLoaderTitle,KMakeSelection);
        return;
    }
    else if(txtFieldModelDropdown.text.length == 0)
    {
        SMAlert(KLoaderTitle, KModelSelection);
        return;
    }
    else
    {
               
        NSMutableURLRequest * requestURL = [SMWebServices listVariantsWithFlagForUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andYear:[self returnCurrentYear] andModelID:selectedModelID];
        
        [self.view endEditing:YES];
        [self webserviceCallForMakesModelVariantNewVehiclesWithRequest:requestURL];
    }
}

- (IBAction)btnListUsedVehiclesDidClicked:(id)sender {
   
    ////////////////////Monami/////////////////////////////////////
    ///////////// As Per client comment image details hidden and Add divider/////////////////
    NSLog(@"%f",desired_y_value);
    NSLog(@"%f",_heightHeaderOLD.constant);
    NSLog(@"%f",_heightConstraintHeaderViewOld.constant);
    
    isListClicked = YES;
    dispatch_async(dispatch_get_main_queue(),^
                   {
                       self.lblNoRecords.hidden = YES;
                       _vwUpload.hidden = YES;
                       _vwReplace.hidden = YES;
                       vwForDivider.hidden = YES;
                       _tblViewStockList.hidden = NO;
                       
                   });
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tblViewStockList.frame = CGRectMake( _tblViewStockList.frame.origin.x, desired_y_value, _tblViewStockList.frame.size.width, HeightOfTableViewForIphone);
        });
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tblViewStockList.frame = CGRectMake( _tblViewStockList.frame.origin.x, desired_y_value, _tblViewStockList.frame.size.width, HeightOfTableViewForIpad);
        });
    }

    
    ///////////////////////  END ////////////////////////////////////////
    self.tblViewStockList.delegate = self;
    self.tblViewStockList.dataSource = self;
    
    isLoadMore = NO;
    [self callTheWebServiceForSearch];
}

//////////////////// Monami /////////////////////////

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.txtFieldKeywordSearch resignFirstResponder];
    
    if(scrollView == _tblViewStockList){
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tblViewStockList.frame = CGRectMake( _tblViewStockList.frame.origin.x, desired_y_value, _tblViewStockList.frame.size.width, HeightOfTableViewForIphone);
        });
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _tblViewStockList.frame = CGRectMake( _tblViewStockList.frame.origin.x, desired_y_value, _tblViewStockList.frame.size.width, HeightOfTableViewForIpad);
        });
    }
    }

}
////////////////////////End //////////////////////////
- (IBAction)btnReplaceProfilePicDidClciked:(id)sender {
    
    [UIActionSheet showInView:self.view
                    withTitle:@"Please select the image source"
            cancelButtonTitle:@"Cancel"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"Camera", @"Select from library"]
              didDismissBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                  
                  
                  switch (buttonIndex) {
                      case 0:
                      {
                          
                          if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
                          {
                              self.multipleImagePicker.isFromApp = YES;
                              picker = [[UIImagePickerController alloc] init];
                              picker.delegate = self;
                              [picker setAllowsEditing:NO];
                              picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                              [self presentViewController:picker animated:YES completion:^{}];
                          }
                          else
                          {
                              SMAlert(KLoaderTitle, @"Camera Not Available.");
                              return;
                          }
                      }
                          break;
                      case 1:
                      {
                          
                          [SMGlobalClass sharedInstance].isFromCamera = NO;
                          
                          [self callPhotoUploadForUserImage];
                      }
                          
                      default:
                          break;
                  }
                  
                  
              }];
    
}




#pragma mark - MULTIPLE IMAGE SELECTION

- (void)dismissImagePickerControllerForCancel:(BOOL)cancelled
{
    if (self.presentedViewController)
    {
        
        
        [self dismissViewControllerAnimated:NO completion:
         ^{
             if(!cancelled)
             {
                 
                 RPMultipleImagePickerViewController *selectType;
                 BOOL isViewControllerPresent = NO;
                 for (UINavigationController *view in self.navigationController.viewControllers)
                 {
                     //when found, do the same thing to find the MasterViewController under the nav controller
                     if ([view isKindOfClass:[RPMultipleImagePickerViewController class]])
                     {
                         isViewControllerPresent = YES;
                         selectType = (RPMultipleImagePickerViewController*)view;
                         self.multipleImagePicker = (RPMultipleImagePickerViewController*)view;
                         [self.navigationController popToViewController:selectType animated:YES];
                         
                         
                     }
                     
                     
                 }
                 
                 if(!isViewControllerPresent)
                 {
                     self.multipleImagePicker.isFromStockAuditScreen = NO;
                     self.multipleImagePicker.isFromGridView = YES;
                     [self.navigationController pushViewController:self.multipleImagePicker animated:YES];
                 }
                 
                 
                 
                 
             }
             
             
         }];
    }
    else
    {
        [self.navigationController popToViewController:self animated:YES];
    }
}

-(void)sendTheUpdatedImageArray:(NSMutableArray*)updatedArray
{
    arrayOfImages = updatedArray;
}


#pragma mark - QBImagePickerControllerDelegate


-(void)callPhotoUploadForUserImage
{
    
    if(imagePickerController == nil)
        imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = NO;
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
    
}

-(void)callToSelectImagesFromCameraWithRemainingCount:(int)remainingCount andFromEditScreen:(BOOL)isFromEditScreen
{
    
    
    
    if(remainingCount>0)
    {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            [picker setAllowsEditing:NO];
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{}];
        }
        else
        {
            
            SMAlert(@"Error",KCameraNotAvailable);
            return;
        }
    }
    
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{

    [self dismissImagePickerControllerForCancel:NO];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{

    [self.multipleImagePicker.Originalimages removeAllObjects];// caught here
    
    
    assetsArray = [NSArray arrayWithArray:assets];
    
    
    for(ALAsset *asset in assets)
    {
        @autoreleasepool {
        UIImage *img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"ddHHmmssSSS"];
        
        NSString *dateString=[formatter stringFromDate:[NSDate date]];
        
        NSString *imgName =[NSString stringWithFormat:@"%@_asset",dateString];
        
        [self saveeImage:img :imgName];
        
        [self.multipleImagePicker addOriginalImages:imgName];
        };
    }
    
    __weak typeof(self) weakSelf = self;
    // Done callback
    self.multipleImagePicker.doneCallback = ^(NSArray *images)
    {
        
        SMClassOfBlogImages *imageObject;
        if(arrayOfImages.count>0){
            [arrayOfImages removeAllObjects];
        }
        strForProfileImage = @"";
        for(int i=0;i< images.count;i++)
        {
            
            imageObject = [[SMClassOfBlogImages alloc]init];
            imageObject.imageSelected=[images objectAtIndex:i];
            imageObject.isImageFromLocal = YES;
            //imageObject.imagePriorityIndex=imgCount;
            imageObject.imageLink = [self loadImagePath:[images objectAtIndex:i]];
            imageObject.imageOriginIndex = -2;
            imageObject.isImageFromCamera = YES;
            imageObject.thumbImagePath = fullPathOftheImage;
            
            [arrayOfImages addObject:imageObject];
            
            selectedImage = nil;
            
        }

        
        ////////////////////////////Monami///////////////////////////////////////////
        
        //////////////////////////API Call For Update Profile Image Method Call
        
        strForProfileImage = imageObject.imageSelected;
        
        UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imageObject.imageSelected];
        NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
        
        strBase64 = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
        
        
        [self updateProfileImageApiCall:imageObject.imageLink andBase64:strBase64];
        
        //////////////////////////  END ///////////////////////////////////////
               
        
    };
    
    [self dismissImagePickerControllerForCancel:NO];
    
    
}

- (void)imagePickerControllerDidCancelled:(QBImagePickerController *)imagePickerController
{
    
    [self dismissImagePickerControllerForCancel:YES];
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image  {
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat boundHeight;
    
    boundHeight = bounds.size.height;
    bounds.size.height = bounds.size.width;
    bounds.size.width = boundHeight;
    transform = CGAffineTransformMakeScale(-1.0, 1.0);
    transform = CGAffineTransformRotate(transform, M_PI / 2.0); //use angle/360 *MPI
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
    
}

- (void)saveeImage:(UIImage*)image :(NSString*)imageName
{
    if (documentsDirectory == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        documentsDirectory = [paths objectAtIndex:0];
    }
    
    
    
    imageData = UIImageJPEGRepresentation(image,0.6); //convert image into .jpg format.
    
    fullPathOftheImage = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageName]];
    
    [imageData writeToFile:fullPathOftheImage atomically:NO];
    
    
    imageData = nil;
    
}

- (NSString*)loadImagePath:(NSString*)imageName1 {
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    
    return [NSString stringWithFormat:@"%@.jpg",fullPathOfImage];
    
}

-(void)dismissTheLoader
{
    [imagePickerController dismissTheLoaderAction];
    
    
}

-(void)delegateFunctionForDeselectingTheSelectedPhotos
{
    [imagePickerController deSelectAllTheSelectedPhotosWhenCancelAction];
    
}

-(void)delegateFunctionWithOriginIndex:(int)originIndex
{
    if(![SMGlobalClass sharedInstance].isFromCamera)
        [imagePickerController deleteTheImageFromTheFirstLibraryWithIndex:originIndex];
    
}

-(void)delegateFunction:(UIImage*)imageToBeDeleted
{
    [imagePickerController deleteTheImageFromTheFirstLibrary:imageToBeDeleted];
}

#pragma - mark Selecting Image from Camera and Library

- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImagePickerController *picker2 = picker1;
    
    // Picking Image from Camera/ Library
    [picker2 dismissViewControllerAnimated:NO completion:^{
        picker2.delegate=nil;
        picker2 = nil;
    }];
    
    
    selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    
    
    if (picker1.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [SMGlobalClass sharedInstance].isFromCamera = YES;
    }
    
    
    if (!selectedImage)
    {
        return;
    }
    
    
    if (selectedImage.imageOrientation == UIImageOrientationUp)
    {
        
    }
    else if (selectedImage.imageOrientation == UIImageOrientationLeft || selectedImage.imageOrientation == UIImageOrientationRight)
    {
        selectedImage = [self scaleAndRotateImage:selectedImage];
    }
    
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"ddHHmmssSSS"];
    
    NSString *dateString=[formatter stringFromDate:[NSDate date]];
    
    NSString *imgName =[NSString stringWithFormat:@"%@_asset",dateString];
    
    [self saveeImage:selectedImage :imgName];
    
    [self.multipleImagePicker addOriginalImages:imgName];
    
    
    BOOL isViewControllerPresent = NO;
    
    for (UINavigationController *view in self.navigationController.viewControllers)
    {
        //when found, do the same thing to find the MasterViewController under the nav controller
        if ([view isKindOfClass:[RPMultipleImagePickerViewController class]])
        {
            isViewControllerPresent = YES;
            
            
        }
        
        
    }
    
    
    if(!isViewControllerPresent)
    {
        self.multipleImagePicker.isFromStockAuditScreen = NO;
        self.multipleImagePicker.isFromGridView = YES;
        [self.navigationController pushViewController:self.multipleImagePicker animated:YES];
    }
    
    
    
    
    
    // Done callback
    self.multipleImagePicker.doneCallback = ^(NSArray *images)
    {
        
        SMClassOfBlogImages *imageObject;
        if(arrayOfImages.count>0){
            [arrayOfImages removeAllObjects];
        }
        strForProfileImage = @"";
        for(int i=0;i< images.count;i++)
        {
            
            imageObject = [[SMClassOfBlogImages alloc]init];
            imageObject.imageSelected=[images objectAtIndex:i];
            imageObject.isImageFromLocal = YES;
            //imageObject.imagePriorityIndex=imgCount;
            imageObject.imageLink = [self loadImagePath:[images objectAtIndex:i]];
            imageObject.imageOriginIndex = -2;
            imageObject.isImageFromCamera = YES;
            imageObject.thumbImagePath = fullPathOftheImage;
            
            [arrayOfImages addObject:imageObject];
            
            selectedImage = nil;
            
        }
        
        
        ////////////////////////////Monami///////////////////////////////////////////
        
        //////////////////////////API Call For Update Profile Image Method Call
        
        strForProfileImage = imageObject.imageSelected;
        
        UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imageObject.imageSelected];
        NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
        
        strBase64 = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
        
        
        [self updateProfileImageApiCall:imageObject.imageSelected andBase64:strBase64];
        
        //////////////////////////  END ///////////////////////////////////////
        
        
        
    };
    
    [self dismissImagePickerControllerForCancel:NO];
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1
{
    if([SMGlobalClass sharedInstance].isFromCamera)
        [SMGlobalClass sharedInstance].photoExistingCount--;
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
}



@end
