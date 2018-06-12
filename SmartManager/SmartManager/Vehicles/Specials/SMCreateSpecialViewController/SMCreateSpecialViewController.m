//ANkit
//  SMCreateSpecialViewController.m
//  SmartManager
//
//  Created by Sandeep on 19/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMCreateSpecialViewController.h"
#import "SMLoadSpecialTableViewCell.h"
#import "SMWebServices.h"
#import "UIBAlertView.h"
#import "NSString+SMURLEncoding.h"
#import "SMSpecialsViewController.h"
#import "UIActionSheet+Blocks.h"
#import "SMAppDelegate.h"
#import "SMCustomPopUpSearchTableView.h"
#import "SMDropDownObject.h"

@interface SMCreateSpecialViewController ()
{
    IBOutlet UIView *viewAuthorDetails;
    NSMutableArray *arrmForVehicle;
    NSMutableArray  *arrmForVariant;
    IBOutlet UIImageView *imgArrowDropDownSelectVehicle;
    IBOutlet SMCustomLable *lblAuthorName;
    IBOutlet SMCustomLable *lblPublisherName;
    IBOutlet SMCustomLable *lblPublicherHeader;
    NSString *strSelectedYear;
}
@end

@implementation SMCreateSpecialViewController
@synthesize tblCreateSpecial;
@synthesize selectTypeView;
@synthesize moreInfoView;
@synthesize vehicleDetailView;
@synthesize otherDetailsView;
@synthesize traitCollection;
@synthesize collectionViewSpecialImages;
@synthesize txtSelectType,txtNormalPriceR,txtEndDate,txtStartDate,txtvDescription,txtTitle,txtSpecialPrice,txtSelectVehicle;
@synthesize lblColour,lblMileage,lblPrice,lblType,lblVehicleName,lblYear;
@synthesize popupView,loadSpecialTableView;
@synthesize pickerView,datePickerView;
@synthesize cancelButton,btnSet;
@synthesize iCheckSpecial, activeSpecialObj;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isStatus                    = NO;
    isVehicleisAlreadyInStcok   = NO;
    isVehicleTypeisSelected     = NO;
    arrmForVehicle = [[NSMutableArray alloc] init];
    makeIndex       = -1;
    modelIndex      = -1;
    variantIndex    = -1;
    lastSelected    = -1;
    arrmForVariant = [[NSMutableArray alloc ] init];
    
    [self addingProgressHUD];
    
    arrayCreateSpOfImages   =[[NSMutableArray alloc]init];
    [[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted removeAllObjects];
    [self registerNib];
    
    self.txtvDescription.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtvDescription.layer.borderWidth= 0.8f;
    
    self.collectionInnerView.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.collectionInnerView.layer.borderWidth= 0.8f;
    
    [self setCustomFont];
    
    self.btnSave.layer.cornerRadius=4.0f;
    
    self.btnCorrected.tag=101;
    
    [self cornerRadiusView];
    strSelectedYear = @"0";
    arrayYears = [[NSMutableArray alloc]init];
    
    
    [self.datePickerView setMinimumDate:[NSDate date]];
    [self addKeyBoardToolbar];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter  setDateFormat:@"yyyy"];
    currentYear = [[formatter stringFromDate:[NSDate date]] intValue];
    
    //Create Years Array from 1990 to This year
    for (int fromYear = 1990; fromYear<=currentYear; fromYear++)
    {
        [arrayYears addObject:[NSString stringWithFormat:@"%d",fromYear]];
    }
    
    [self.yearPickerView reloadAllComponents];
    
    self.multipleImagePicker = [[RPMultipleImagePickerViewController alloc] init];
    self.multipleImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.multipleImagePicker.photoSelectionDelegate = self;
    
    [SMGlobalClass sharedInstance].totalImageSelected  = 0;
    [SMGlobalClass sharedInstance].isFromCamera = NO;
    
    if([activeSpecialObj.strSpecialID length] > 0)
        [self getEditData];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self hideProgressHUD];
    [popupView removeFromSuperview];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    NSPredicate *predicateServerImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];// from server
    NSArray *arrayServerFiltered = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateServerImages];
    
    NSPredicate *predicateLocalImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];// from server
    NSArray *arrayLocalFiltered = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateLocalImages];
    
    if ([arrayServerFiltered count] > 0)
    {
        
        if(arrayLocalFiltered.count == 0)
            [SMGlobalClass sharedInstance].totalImageSelected = 0;
        else
            [SMGlobalClass sharedInstance].totalImageSelected = (int)(arrayCreateSpOfImages.count - arrayServerFiltered.count);
        
    }
    else
    {
        [SMGlobalClass sharedInstance].totalImageSelected =(int)( arrayCreateSpOfImages.count);
        
    }
    
}


- (void)cornerRadiusView
{
    self.loadSpecialTableView.layer.cornerRadius=15.0;
    self.loadSpecialTableView.clipsToBounds      = YES;
    self.loadSpecialTableView.layer.borderWidth=1.5;
    self.loadSpecialTableView.layer.borderColor=[[UIColor blackColor] CGColor];
    
    self.pickerView.layer.cornerRadius=15.0;
    self.pickerView.clipsToBounds      = YES;
    self.pickerView.layer.borderWidth=1.5;
    self.pickerView.layer.borderColor=[[UIColor blackColor] CGColor];
    
    self.yearView.layer.cornerRadius=15.0;
    self.yearView.clipsToBounds      = YES;
    self.yearView.layer.borderWidth=1.5;
    self.yearView.layer.borderColor=[[UIColor blackColor] CGColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:NO];
    
    [super viewWillAppear:YES];
    [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                   withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];
    
    switch (iCheckSpecial)
    {
        case 10:
            specialID = activeSpecialObj.strSpecialID.intValue;
            [self getSpecialBySpecialID];
            if(activeSpecialObj.strTypeID.intValue == 1 || activeSpecialObj.strTypeID.intValue == 3){
                  selectedType = 1;
                  self.txtSelectType.text = activeSpecialObj.strType;
                  [self loadSelectVehicle];
            }
            if(activeSpecialObj.strTypeID.intValue == 2 || activeSpecialObj.strTypeID.intValue == 4){
                self.txtSelectVehicle.text = activeSpecialObj.strUsedYear;
                strSelectedYear=activeSpecialObj.strUsedYear;
            }
            if(activeSpecialObj.strTypeID.intValue == 5) {
                self.txtSelectVehicle.text = activeSpecialObj.strItemValue;
            }
            iCheckSpecial = 20;
            viewAuthorDetails.hidden = NO;
            self.navigationItem.titleView = [SMCustomColor setTitle:@"Edit Special"];
            break;
            
        case 20:
            break;
            
        default:
            specialID = 0;
            currentUserID = 0;
            self.navigationItem.titleView = [SMCustomColor setTitle:@"Create Special"];
            [self.btnSave setFrame:CGRectMake(self.btnSave.frame.origin.x, self.lblRequiredFieldsInfo.frame.origin.y+5.0f+self.lblRequiredFieldsInfo.frame.size.height, self.btnSave.frame.size.width, self.btnSave.frame.size.height)];
            viewAuthorDetails.hidden = YES;
            break;
    }
}

- (void)getEditData
{
    [self.txtSpecialPrice setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:activeSpecialObj.strSpecialPrice]];
    
    [self.txtNormalPriceR setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:activeSpecialObj.strNormalPrice]];
    
    [self.txtTitle setText:activeSpecialObj.strTitle];
    [self.txtvDescription setText:activeSpecialObj.strSpecialDetails];
    [self.txtSelectType setText:activeSpecialObj.strType];
    
    if ([activeSpecialObj.strSpecialEndDate rangeOfString:@"1900"].location !=NSNotFound) {
        activeSpecialObj.strSpecialEndDate = @"";
    }
    
    [self.txtEndDate setText:[[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:activeSpecialObj.strSpecialEndDate
                                                                                                   withFormat:1]];
    
    [self.txtStartDate setText:[[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:activeSpecialObj.strSpecialStartDate withFormat:1]];
    
    [self.lblMileage setText:[NSString stringWithFormat:@"%@ Km",([activeSpecialObj.strMileage rangeOfString:@""].location !=NSNotFound) ? @"0" : [[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:activeSpecialObj.strMileage]]];
    
    [self.lblName setText:([activeSpecialObj.strStockCode rangeOfString:@""].location != NSNotFound) ? @"Stock code?" :activeSpecialObj.strStockCode];
    
    [self.lblColour setText:([activeSpecialObj.strColor rangeOfString:@""].location !=NSNotFound) ? @"Colour?" : activeSpecialObj.strColor];
    
    [self.lblYear setText:([activeSpecialObj.strUsedYear rangeOfString:@""].location !=NSNotFound) ? @"0" : activeSpecialObj.strUsedYear];
    NSLog(@"strUsedYear = %@",activeSpecialObj.strUsedYear);
    
    [self.lblPrice setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:activeSpecialObj.strNormalPrice]];
    
    [self.lblType setText:([activeSpecialObj.strType rangeOfString:@""].location !=NSNotFound) ? @"No Vehicle Type Loaded" : activeSpecialObj.strType];
    
    [self.lblVehicleName setText:([activeSpecialObj.stractiveName rangeOfString:@""].location !=NSNotFound) ? @"No Vehicle Name Loaded" : activeSpecialObj.stractiveName];
    
    isStatus = YES;
    
    if ( activeSpecialObj.isCorrected==YES)
    {
        [self.btnCorrected setSelected:YES];
    }
    else
    {
        [self.btnCorrected setSelected:NO];
    }
    specialID = activeSpecialObj.strSpecialID.intValue;
    selectedSpecialTypeID = activeSpecialObj.strTypeID.intValue;
    currentUserID = activeSpecialObj.strCurrenUserID.intValue;
    iMakeID = activeSpecialObj.strMakeID.intValue;
    iModelID = activeSpecialObj.strModelID.intValue;
    iVariantID = activeSpecialObj.strVariantID.intValue;
    itemID = activeSpecialObj.ItemID;
    
    if ([activeSpecialObj.strType rangeOfString:@"(In Stock)"].location != NSNotFound)
    {
        [self.selectTypeView setFrame:CGRectMake(self.selectTypeView.frame.origin.x, self.selectTypeView.frame.origin.y, self.selectTypeView.frame.size.width,UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 80 : 100)];
        [self.txtSelectVehicle setText:activeSpecialObj.stractiveName];
        [self.txtSelectVehicle setTag:1];
        [self.txtSelectVehicle setPlaceholder:@"Select Vehicle"];
        [self.lblVehiclePlace setText:@"Vehicle*"];
        NSLog(@"144454");
        [self.tblCreateSpecial reloadData];
    }
    else if ([activeSpecialObj.strType isEqualToString:@"Service,Spares&Accessories"]){
        [self.selectTypeView setFrame:CGRectMake(self.selectTypeView.frame.origin.x, self.selectTypeView.frame.origin.y, self.selectTypeView.frame.size.width,UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 80 : 100)];
        selectedType = 5;
        iVariantID=0;
        iModelID=0;
        iMakeID=0;
        [self.txtSelectVehicle      setPlaceholder:@"Item"];
        [self.lblVehiclePlace       setText:@"Item"];
        [self.txtSelectVehicle      setText:@""];
        [self.txtSelectVehicle      setTag:786];
        imgArrowDropDownSelectVehicle.hidden = YES;
        //[self loadSelectVehicle];
        NSLog(@"55555");
        [tblCreateSpecial reloadData]; // IT will replace select vhicle by Item

    }
    else
    {
        [self.selectTypeView setFrame:CGRectMake(self.selectTypeView.frame.origin.x, self.selectTypeView.frame.origin.y, self.selectTypeView.frame.size.width,UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 194 :248)];
        [self.txtSelectVehicle setText:activeSpecialObj.strUsedYear];
        [self.txtMake setText:activeSpecialObj.strMakeName];
        [self.txtModel setText:activeSpecialObj.strModelName];
        [self.txtVariant setText:activeSpecialObj.strVariantName];
        [self.txtSelectVehicle setTag:8];
        [self.txtSelectVehicle setPlaceholder:@"Select Year"];
        [self.lblVehiclePlace setText:@"Year*"];
        NSLog(@"76767");
        [self.tblCreateSpecial reloadData];
    }
}

-(void)addKeyBoardToolbar
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *done= [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)];
    [done setTintColor:[UIColor whiteColor]];
    
    
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           done,
                           nil];
    [numberToolbar sizeToFit];
    self.txtNormalPriceR.inputAccessoryView = numberToolbar;
    self.txtSpecialPrice.inputAccessoryView = numberToolbar;
}

-(void) doneWithNumberPad
{
    [self.txtNormalPriceR resignFirstResponder];
    [self.txtSpecialPrice resignFirstResponder];
    
}

- (void)setCustomFont
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.txtvDescription         setFont:[UIFont fontWithName:FONT_NAME size:15.0f]];
        [self.cancelButton.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:15.0f]];
        [self.btnSet.titleLabel       setFont:[UIFont fontWithName:FONT_NAME size:15.0f]];
        [self.btnCancel.titleLabel    setFont:[UIFont fontWithName:FONT_NAME size:15.0f]];
        [self.btnDone.titleLabel      setFont:[UIFont fontWithName:FONT_NAME size:15.0f]];
    }
    else
    {
        [self.txtvDescription         setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.cancelButton.titleLabel setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.btnSet.titleLabel       setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
        [self.btnCancel.titleLabel    setFont:[UIFont fontWithName:FONT_NAME size:15.0f]];
        [self.btnDone.titleLabel      setFont:[UIFont fontWithName:FONT_NAME size:15.0f]];
    }
}

- (void)registerNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.collectionViewSpecialImages registerNib:[UINib nibWithNibName:  @"SMCellOfPlusImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImagePV"];
        
        [self.collectionViewSpecialImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImagePV"];
        
        [self.loadSpecialTableView registerNib:[UINib nibWithNibName:@"SMLoadSpecialTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMLoadSpecialTableViewCellIdentifier"];
        
        [self.loadSpecialTableView registerNib:[UINib nibWithNibName:@"SMVariantSpecial" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
        
        
    }
    else
    {
        [self.collectionViewSpecialImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImageCommentPV_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImagePV"];
        
        [self.collectionViewSpecialImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImageCommentPV_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImagePV"];
        
        [self.loadSpecialTableView registerNib:[UINib nibWithNibName:@"SMLoadSpecialTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMLoadSpecialTableViewCellIdentifier"];
        
        [self.loadSpecialTableView registerNib:[UINib nibWithNibName:@"SMVariantSpecial_iPad" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
    }
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isStatus==NO)
    {
        return tableView == self.tblCreateSpecial ? 3 :1;
    }
    else
    {
        return tableView == self.tblCreateSpecial ? 3 :1;
        //return tableView == self.tblCreateSpecial ? 4 :1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.tblCreateSpecial)
    {
        return 1;
    }
    else
    {
        float maxHeigthOfView = [self view].frame.size.height/2+50.0;
        float totalFrameOfView;
        
        switch (selectedType)
        {
            case 1:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([vehicleArray count]*68) : 43+([vehicleArray count]*70);
                break;
                
            case 4:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([makeArray count]*43) : 43+([makeArray count]*60);
                break;
                
            case 5:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([modelArray count]*43) : 43+([modelArray count]*60);
                break;
                
            case 6:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([variantArray count]*43) : 43+([variantArray count]*60);
                break;
                
            default:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([typeArray count]*43) : 43+([typeArray count]*60);
                break;
        }
        
        if(selectedType!=6)
        {
            
            if (totalFrameOfView <= maxHeigthOfView)
            {
                //Make View Size smaller, no scrolling
                loadSpecialTableView.frame = CGRectMake(loadSpecialTableView.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, loadSpecialTableView.frame.size.width, totalFrameOfView);
            }
            else
            {
                loadSpecialTableView.frame = CGRectMake(loadSpecialTableView.frame.origin.x, maxHeigthOfView/2-22.0, loadSpecialTableView.frame.size.width, maxHeigthOfView);
            }
        }
        else  if(selectedType==6)
        {
            loadSpecialTableView.frame = CGRectMake(loadSpecialTableView.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, loadSpecialTableView.frame.size.width, 300.0);
        }
        
        switch (selectedType)
        {
            case 1:
                return vehicleArray.count;
                break;
                
            case 4:
                return makeArray.count;
                break;
                
            case 5:
                return modelArray.count;
                break;
                
            case 6:
                return variantArray.count;
                break;
                
            default:
                return typeArray.count;
                break;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tblCreateSpecial)
    {
        return 0;
    }
    else
    {
        return 43;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return tableView==self.tblCreateSpecial ? nil : cancelButton;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tblCreateSpecial)
    {
        static NSString *identifierCell=@"createCellIdentifer";
        UITableViewCell *createCell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
        if (createCell==nil)
        {
            createCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
        }
        
        createCell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        switch (indexPath.section)
        {
            case 0:
                [createCell.contentView addSubview:self.selectTypeView];
                break;
            case 1:
                [createCell.contentView addSubview:self.moreInfoView];
                break;
            case 2:
                //(isStatus==NO) ? [createCell.contentView addSubview:self.otherDetailsView] : [createCell.contentView addSubview:self.vehicleDetailView];
                (isStatus==NO) ? [createCell.contentView addSubview:self.otherDetailsView] : [createCell.contentView addSubview:self.otherDetailsView];
                
                break;
            case 3:
                [createCell.contentView addSubview:self.otherDetailsView];
                break;
            default:
                break;
        }
        return createCell;
    }
    else
    {
        static NSString *identifierCell=@"SMLoadSpecialTableViewCellIdentifier";
        static NSString *identifierCellVariant =@"VariantListing";
        
        if(selectedType == 1)
        {
            SMLoadSpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCellVariant];
            
            SMLoadSpecialObject *objectSpecialTypeCell = (SMLoadSpecialObject *) [vehicleArray objectAtIndex:indexPath.row];
            
            [cell.lblSelectType  setText:objectSpecialTypeCell.strSelectName];
            [cell.labelYear      setText:objectSpecialTypeCell.strVehicleUsedYear];
            [cell.labelMeanCode  setText:objectSpecialTypeCell.strVehicleStockCode];
            [cell.labelColor     setText:objectSpecialTypeCell.strVehicleColor];
            return cell;
        }
        else
        {
            SMLoadSpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
            
            SMLoadSpecialObject *objectSpecialTypeCell;
            
            switch (selectedType)
            {
                case 2:
                    break;
                    
                case 4:
                    objectSpecialTypeCell = (SMLoadSpecialObject *) [makeArray objectAtIndex:indexPath.row];
                    break;
                    
                case 5:
                    objectSpecialTypeCell = (SMLoadSpecialObject *) [modelArray objectAtIndex:indexPath.row];
                    break;
                    
                case 6:
                    objectSpecialTypeCell = (SMLoadSpecialObject *) [variantArray objectAtIndex:indexPath.row];
                    break;
                    
                    
                default:
                    objectSpecialTypeCell = (SMLoadSpecialObject *) [typeArray objectAtIndex:indexPath.row];
                    break;
            }
            
            if ([objectSpecialTypeCell.strSelectName  rangeOfString:@""].location != NSNotFound)
            {
                if ([objectSpecialTypeCell.strMakeName  rangeOfString:@""].location != NSNotFound &&  [objectSpecialTypeCell.strModelName  rangeOfString:@""].location != NSNotFound)
                {
                    objectSpecialTypeCell.strSelectName = @"Not Name Found#";
                }
                else
                {
                    objectSpecialTypeCell.strSelectName = [NSString stringWithFormat:@"%@%@",objectSpecialTypeCell.strMakeName,objectSpecialTypeCell.strModelName];
                }
            }
            
            [cell.lblSelectType setText:objectSpecialTypeCell.strSelectName];
            
            return cell;
        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tblCreateSpecial)
    {
        switch (indexPath.section)
        {
            case 0:
                return self.selectTypeView.frame.size.height;
                break;
            case 1:
                return self.moreInfoView.frame.size.height;
                break;
            case 2:
                // return (isStatus==NO) ? self.otherDetailsView.frame.size.height : self.vehicleDetailView.frame.size.height;
                return (isStatus==NO) ? self.otherDetailsView.frame.size.height : self.otherDetailsView.frame.size.height;
                break;
            case 3:
                return self.otherDetailsView.frame.size.height;
                break;
            default:
                return 2.0f;
                break;
        }
    }
    else
    {
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone))
        {
            if (selectedType == 1)
            {
                return 70.0f;
            }
            else
            {
                return 44.0f;
            }
        }
        else
        {
            if (selectedType == 1)
            {
                return 70.0f;
            }
            else
            {
                return 60.f;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMLoadSpecialObject *objectSpecialTypeCell;
    
    if (tableView==self.loadSpecialTableView)
    {
        strSelectedYear = @"0";
        switch (selectedType)
        {
            case 0:
            {   imgArrowDropDownSelectVehicle.hidden = NO;
                objectSpecialTypeCell = (SMLoadSpecialObject *) [typeArray objectAtIndex:indexPath.row];
                [self.txtSelectType setText:objectSpecialTypeCell.strSelectName];
                [lblType setText:objectSpecialTypeCell.strSelectName];
                selectedSpecialTypeID = objectSpecialTypeCell.strSelectId.intValue;
                if (indexPath.row == 0 || indexPath.row == 2)
                {
                    [self.selectTypeView setFrame:CGRectMake(self.selectTypeView.frame.origin.x, self.selectTypeView.frame.origin.y, self.selectTypeView.frame.size.width,UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 80 : 100)];
                    selectedType = 1;
                    [self.txtSelectVehicle      setPlaceholder:@"Select Vehicle"];
                    [self.lblVehiclePlace       setText:@"Vehicle*"];
                    [self.txtSelectVehicle      setText:@""];
                    [self.txtSelectVehicle      setTag:1];
                    [self loadSelectVehicle];
                    NSLog(@"11111");
                    [tblCreateSpecial reloadData]; // IT will show one more section with Information
                    
                }
                
                else if (indexPath.row == 1 || indexPath.row == 3)
                {
                    imgArrowDropDownSelectVehicle.hidden = NO;
                    [self.selectTypeView setFrame:CGRectMake(self.selectTypeView.frame.origin.x, self.selectTypeView.frame.origin.y, self.selectTypeView.frame.size.width,UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 194 :248)];
                    
                    [self.txtSelectVehicle  setPlaceholder:@"Select Year"];
                    [self.lblVehiclePlace   setText:@"Year*"];
                    [self.txtSelectVehicle  setText:@""];
                    [self.txtSelectVehicle  setTag:8];
                    
                    [self.txtMake           setPlaceholder:@"Select Make"];
                    [self.txtMake           setText:@""];
                    
                    [self.txtModel          setPlaceholder:@"Select Model"];
                    [self.txtModel          setText:@""];
                    
                    [self.txtVariant        setPlaceholder:@"Select Variant"];
                    [self.txtVariant        setText:@""];
                    
                    selectedRow = arrayYears.count-1;
                    
                    isStatus = NO;
                    
                    NSLog(@"22222");
                    [tblCreateSpecial reloadData]; // IT will show one more section with Information
                }
                
                else if(indexPath.row == 4){
                    imgArrowDropDownSelectVehicle.hidden = YES;
                    objectSpecialTypeCell = (SMLoadSpecialObject *) [typeArray objectAtIndex:indexPath.row];
                    [self.txtSelectType setText:objectSpecialTypeCell.strSelectName];
                    [lblType setText:objectSpecialTypeCell.strSelectName];
                    selectedSpecialTypeID = objectSpecialTypeCell.strSelectId.intValue;
                    [self.selectTypeView setFrame:CGRectMake(self.selectTypeView.frame.origin.x, self.selectTypeView.frame.origin.y, self.selectTypeView.frame.size.width,UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 80 : 100)];
                        selectedType = 5;
                        iVariantID=0;
                        iModelID=0;
                        iMakeID=0;
                        [self.txtSelectVehicle      setPlaceholder:@"Item"];
                        [self.lblVehiclePlace       setText:@"Item"];
                        [self.txtSelectVehicle      setText:@""];
                        [self.txtSelectVehicle      setTag:786];
                        //[self loadSelectVehicle]; because we have to show the empty text field
                        NSLog(@"55555");
                        [tblCreateSpecial reloadData]; // IT will replace select vehicle by Item
                    
                }
                
                if (lastSelected!=indexPath.row)
                {
                    lastSelected = (int)indexPath.row;
                    
                    [vehicleArray removeAllObjects];
                }
                
                [self dismissPopup];
            }
                break;
                
            case 1:
            {
                objectSpecialTypeCell = (SMLoadSpecialObject *) [vehicleArray objectAtIndex:indexPath.row];
                
                [self.txtSelectVehicle setText:objectSpecialTypeCell.strSelectName];
                
                iModelID = objectSpecialTypeCell.strVehicleModelID.intValue;
                iVariantID = objectSpecialTypeCell.strVehicleVariantID.intValue;
                itemID = objectSpecialTypeCell.strUsedVehicleStockID.intValue;
                NSLog(@"selectedItemID: %d",itemID);
                
                
                isVehicleTypeisSelected = YES;
                
                [self webServiceForLoadVehicleDetailsXML:objectSpecialTypeCell.strUsedVehicleStockID.intValue];
                
                [self dismissPopup];
            }
                break;
                
            case 4:
            {
                objectSpecialTypeCell = (SMLoadSpecialObject *) [makeArray objectAtIndex:indexPath.row];
                
                iMakeID = objectSpecialTypeCell.strVehicleMakeID.intValue;
                [self.txtMake setText:objectSpecialTypeCell.strSelectName];
                
                if (makeIndex!=indexPath.row)
                {
                    makeIndex       = (int)indexPath.row;
                    modelIndex      = -1;
                    variantIndex    = -1;
                    
                    [self.txtModel setText:@""];
                    [self.txtVariant setText:@""];
                    
                    [modelArray     removeAllObjects];
                    [variantArray   removeAllObjects];
                }
                
                [self dismissPopup];
            }
                break;
                
            case 5:
            {
                objectSpecialTypeCell = (SMLoadSpecialObject *) [modelArray objectAtIndex:indexPath.row];
                
                iModelID = objectSpecialTypeCell.strVehicleModelID.intValue;
                [self.txtModel setText:objectSpecialTypeCell.strSelectName];
                
                if (modelIndex!=indexPath.row)
                {
                    modelIndex = (int)indexPath.row;
                    [self.txtVariant setText:@""];
                    
                    [variantArray   removeAllObjects];
                }
                
                [self dismissPopup];
                [self.txtModel setTag:11];
            }
                break;
                
            case 6:
            {
                objectSpecialTypeCell = (SMLoadSpecialObject *) [variantArray objectAtIndex:indexPath.row];
                
                iVariantID = objectSpecialTypeCell.strVehicleVariantID.intValue;
                itemID = 0;
                [self.txtVariant setText:objectSpecialTypeCell.strSelectName];
                [self.txtVariant setTag:12];
                [self dismissPopup];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -

#pragma mark - UICollectionView DataSource & Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [arrayCreateSpOfImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMCellOfPlusImageCommentPV *cellImages;
    
    {
        cellImages =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"SMCellOfActualImagePV" forIndexPath:indexPath];
        cellImages.btnDelete.tag = indexPath.row;
        
        
        [cellImages.btnDelete addTarget:self action:@selector(btnDeleteImageDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        SMPhotosListNSObject *imageObj = (SMPhotosListNSObject*)[arrayCreateSpOfImages objectAtIndex:indexPath.row];
        
        [cellImages.lblImgPriority setHidden: false];
        cellImages.lblImgPriority.layer.masksToBounds = YES;
        cellImages.lblImgPriority.layer.cornerRadius = cellImages.lblImgPriority.frame.size.width/2;
        cellImages.lblImgPriority.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        
        cellImages.webVYouTube.hidden=YES;
        
        if(imageObj.isImageFromLocal)
        {
            NSString *str = [NSString stringWithFormat:@"%@.jpg",imageObj.strimageName];
            
            NSString *fullImgName=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
            
            cellImages.imgActualImage.image = [UIImage imageWithContentsOfFile:fullImgName];
            
        }
        else
        {
            NSLog(@"%@",imageObj.strAUTOSpecialImageID);
            NSLog(@"%@",imageObj.strOriginalFileName);
            NSLog(@"%@",imageObj.strIsSpecials);
            
            if ([imageObj.strIsSpecials isEqualToString:@"0"]) {
              imageObj.imageLink = [NSString stringWithFormat:@"http://netwin.ixstaging.co.za/GetImage?ImageID=%@",imageObj.strAUTOSpecialImageID];
                
               // imageObj.imageLink = [NSString stringWithFormat:@"http://netwin.ix.co.za/GetImage?ImageID=%@",imageObj.strAUTOSpecialImageID];
            }
            else{
             /* imageObj.imageLink = [NSString stringWithFormat:@"http://netwin.ixtest.co.za/GetSpecialsImage.aspx?autoSpecialImageId=%@",imageObj.strAUTOSpecialImageID];*/
                
                imageObj.imageLink = [NSString stringWithFormat:@"http://netwin.ix.co.za/GetSpecialsImage.aspx?autoSpecialImageId=%@",imageObj.strAUTOSpecialImageID];
                
                
            }
            [cellImages.imgActualImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageObj.imageLink]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        }
    }
    
    return cellImages;
}

-(IBAction)btnDeleteImageDidClicked:(id)sender1
{
    UIButton *button=(UIButton *)sender1;
    deleteButtonTag = button.tag;
    
    UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle  message:KSpecialDeltedImage cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
        if (didCancel)
        {
            return;
        }
        switch (selectedIndex)
        {
            case 1:
                [self removeSelectedImage];
                break;
            case 2:
                break;
            default:
                break;
        }
    }];
    
}

// this will called once user slect cross mark to remove image for special
-(void) removeSelectedImage
{

    {
        SMPhotosListNSObject *deleteImageObject = (SMPhotosListNSObject*)[arrayCreateSpOfImages objectAtIndex:deleteButtonTag];
        
        if(deleteImageObject.isImageFromLocal==NO)
        {
            [[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted addObject:[arrayCreateSpOfImages objectAtIndex:deleteButtonTag]];
        }
        
        else
        {
            if (deleteImageObject.imageOriginIndex >= 0)
            {
                
                [SMGlobalClass sharedInstance].isFromCamera = NO;
                
                //Means image from that picker of multiple image selection
                [self delegateFunctionWithOriginIndex:deleteImageObject.imageOriginIndex];
                
                for (int i=(int)deleteButtonTag +1;i<[arrayCreateSpOfImages count];i++)
                {
                    SMPhotosListNSObject *deleteImageObjectTemp = (SMPhotosListNSObject*)[arrayCreateSpOfImages objectAtIndex:i];
                    
                    deleteImageObjectTemp.imageOriginIndex--;
                    
                }
            }
        }
        
        
        isPrioritiesChanged = YES;
        [arrayCreateSpOfImages removeObjectAtIndex:deleteButtonTag];
        [self.collectionViewSpecialImages reloadData];
        
    }
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(94, 78);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([arrayCreateSpOfImages count]==indexPath.row)
    {
        /* actionSheetPhotos = [[UIActionSheet alloc] initWithTitle:@"Select The Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Select From Library", nil];
         actionSheetPhotos.actionSheetStyle = UIActionSheetStyleDefault;
         actionSheetPhotos.tag=101;
         [actionSheetPhotos showInView:self.view];*/
    }
    else
    {
        selectedIndexForImage = indexPath.row;
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        networkGallery.startingIndex = indexPath.row;
        SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate.isPresented =  YES;
        [self.navigationController pushViewController:networkGallery animated:YES];
    }
}

#pragma mark -

#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    
    if(gallery == networkGallery)
    {
        num = (int)[arrayCreateSpOfImages count];
    }
    return num;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    SMPhotosListNSObject *imageObject = (SMPhotosListNSObject *) arrayCreateSpOfImages[index];
    
    if (imageObject.isImageFromLocal == NO)
    {
        return FGalleryPhotoSourceTypeNetwork;
    }
    else
    {
        return FGalleryPhotoSourceTypeLocal;
    }
    
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
    SMPhotosListNSObject *imgObj = (SMPhotosListNSObject*)[arrayCreateSpOfImages objectAtIndex:index];
    
    return  imgObj.imageLink;
}

- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    SMPhotosListNSObject *imgObj = (SMPhotosListNSObject*)[arrayCreateSpOfImages objectAtIndex:index];
    
    return  imgObj.imageLink;
}

#pragma mark - LXReorderableCollectionViewDataSource methods
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    SMPhotosListNSObject *imgObj = (SMPhotosListNSObject*)[arrayCreateSpOfImages objectAtIndex:fromIndexPath.row];
    isPrioritiesChanged = YES;
    
    [arrayCreateSpOfImages removeObjectAtIndex:fromIndexPath.item];
    [arrayCreateSpOfImages insertObject:imgObj atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return YES;
}
#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView reloadData];
}
#pragma mark - UIPickerView Datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;// or the number of vertical "columns" the picker will show...
}

- (NSInteger)pickerView:(UIPickerView *)pickerView1 numberOfRowsInComponent:(NSInteger)component
{
    return [arrayYears count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrayYears objectAtIndex:row];
}

#pragma mark - UIPickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedRow = row;
}

#pragma mark - Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Picking Image from Camera/ Library
    [picker dismissViewControllerAnimated:NO completion:^{
        picker.delegate=nil;
        picker = nil;
    }];
    
    selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (picker1.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [SMGlobalClass sharedInstance].isFromCamera = YES;
    }
    
    
    if (!selectedImage)
    {
        return;
    }
    
    if (selectedImage.imageOrientation == UIImageOrientationLeft || selectedImage.imageOrientation == UIImageOrientationRight)
    {
        selectedImage = [[SMCommonClassMethods shareCommonClassManager] scaleAndRotateImage:selectedImage];
    }
    
    
    
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"ddHHmmssSSS"];
    
    NSString *dateString=[formatter stringFromDate:[NSDate date]];
    
    NSString *imgName =[NSString stringWithFormat:@"%@_asset",dateString];
    
    [self saveImage:selectedImage :imgName];
    
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
        self.multipleImagePicker.isFromGridView = NO;
        [self.navigationController pushViewController:self.multipleImagePicker animated:YES];
    }
    
    
    
    // Done callback
    self.multipleImagePicker.doneCallback = ^(NSArray *images)
    {
        
        
        
        
        for(int i=0;i< images.count;i++)
        {
            
            
            SMPhotosListNSObject *imageObject = [[SMPhotosListNSObject alloc]init];
            
            
            
            imageObject.strimageName=[images objectAtIndex:i];
            imageObject.isImageFromLocal = YES;
            imageObject.imageOriginIndex = -2;
            //imageObject.imagePriorityIndex=imgCount;
            imageObject.imageLink = [self loadImagePath:[images objectAtIndex:i]];
            imageObject.isImageFromCamera = YES;
            
            [arrayCreateSpOfImages addObject:imageObject];
            
            
            
            selectedImage = nil;
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionViewSpecialImages reloadData];
            [self.multipleImagePicker.Originalimages removeAllObjects];
            
            
        });
        
        
        
    };
    
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1
{
    if([SMGlobalClass sharedInstance].isFromCamera)
        [SMGlobalClass sharedInstance].photoExistingCount--;
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
}



#pragma mark - Multiple Image selection and Image Editing


#pragma mark - MULTIPLE IMAGE SELECTION

- (void)dismissImagePickerControllerForCancel:(BOOL)cancelled
{
    if (self.presentedViewController)
    {
        
        
        [self dismissViewControllerAnimated:YES completion:
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
                     self.multipleImagePicker.isFromGridView = NO;
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
    arrayCreateSpOfImages = updatedArray;
}


#pragma mark - QBImagePickerControllerDelegate


-(void)callTheMultiplePhotoSelectionLibraryWithRemainingCount:(int)remainingCount andFromEditScreen:(BOOL)isFromEditScreen;
{
    
    if(isFromEditScreen)
    {
        
        if(imagePickerController == nil)
            imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
    
    else
    {
        //        QBImagePickerController *imagePickerController2 = [[QBImagePickerController alloc] init];
        if(imagePickerController == nil)
            imagePickerController = [[QBImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        
        
        if(remainingCount>20)
        {
            imagePickerController.maximumNumberOfSelection = 0;
        }
        
        else
        {
            if(isFromAppGallery)
            {
                NSPredicate *predicateImages1 = [NSPredicate predicateWithFormat:@"imageOriginIndex >= %d",0];
                NSArray *arrayFiltered1 = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateImages1];
                imagePickerController.maximumNumberOfSelection = remainingCount+[arrayFiltered1 count];
                isFromAppGallery = NO;
            }
            else
            {
                NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];
                NSArray *arrayFiltered = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateImages];
                if ([arrayFiltered count] > 0)
                {
                    imagePickerController.maximumNumberOfSelection = 20;
                }
                else
                {
                    NSPredicate *predicateImages1 = [NSPredicate predicateWithFormat:@"imageOriginIndex >= %d",0];
                    NSArray *arrayFiltered1 = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateImages1];
                    
                    
                    imagePickerController.maximumNumberOfSelection = remainingCount+arrayFiltered1.count;
                }
            }
            
            
        }
        
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
        
        
    }
    
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
            
            SMAlert(@"Error", KCameraNotAvailable);
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
        UIImage *imgThumbnail = [UIImage imageWithCGImage:[asset thumbnail]];
        
       
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"ddHHmmssSSS"];
        
        NSString *dateString=[formatter stringFromDate:[NSDate date]];
        
        NSString *imgName =[NSString stringWithFormat:@"%@_asset",dateString];
        
        [self saveImage:img :imgName];
        
        [self.multipleImagePicker addOriginalImages:imgName];
        };
    }
    
    NSPredicate *predicateServerImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];// from server
    NSArray *arrayServerFiltered = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateServerImages];
    
    NSPredicate *predicateCameraImages = [NSPredicate predicateWithFormat:@"isImageFromCamera == %d",YES];// from server
    NSArray *arrayCameraFiltered = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateCameraImages];
    
    NSArray *finalFilteredArray = [arrayServerFiltered arrayByAddingObjectsFromArray:arrayCameraFiltered];
    
    if ([finalFilteredArray count] > 0)
    {
        [arrayCreateSpOfImages removeAllObjects];
        arrayCreateSpOfImages = [NSMutableArray arrayWithArray:finalFilteredArray];
    }
    else
        [arrayCreateSpOfImages removeAllObjects]; // check here.
    
    
    [self.collectionViewSpecialImages reloadData];
    
    
    
    // Done callback
    self.multipleImagePicker.doneCallback = ^(NSArray *images)
    {
        
        
        
        for(int i=0;i< images.count;i++)
        {
            SMPhotosListNSObject *imageObject = [[SMPhotosListNSObject alloc]init];
            
            imageObject.strimageName=[images objectAtIndex:i];
            imageObject.isImageFromLocal = YES;
            imageObject.imageOriginIndex = i;
            //imageObject.imagePriorityIndex=imgCount;
            imageObject.imageLink = [self loadImagePath:[images objectAtIndex:i]];
            imageObject.isImageFromCamera = NO;
            
            [arrayCreateSpOfImages addObject:imageObject];
            
            selectedImage = nil;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionViewSpecialImages reloadData];
            [self.multipleImagePicker.Originalimages removeAllObjects];
            //[self.multipleImagePicker.ThumbnailImages removeAllObjects];
            
        });
    };
    
    [self dismissImagePickerControllerForCancel:NO];
    
    
}

/////////////// Monami tap on cancel of image gallery, image delete
- (void)imagePickerControllerDidCancelled:(QBImagePickerController *)imagePickerController
{
     [SMGlobalClass sharedInstance].isTapOnCancel = YES;
    
//    if(arrayCreateSpOfImages.count>0)
//    {
//        NSPredicate *predicateServerImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];// from server
//        NSArray *arrayServerFiltered = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateServerImages];
//
//        NSPredicate *predicateCameraImages = [NSPredicate predicateWithFormat:@"isImageFromCamera == %d",YES];// from server
//        NSArray *arrayCameraFiltered = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateCameraImages];
//
//        NSArray *finalFilteredArray = [arrayServerFiltered arrayByAddingObjectsFromArray:arrayCameraFiltered];
//
//        if ([finalFilteredArray count] > 0)
//        {
//            [arrayCreateSpOfImages removeAllObjects];
//            arrayCreateSpOfImages = [NSMutableArray arrayWithArray:finalFilteredArray];
//        }
//        else
//        {
//            [arrayCreateSpOfImages removeAllObjects]; // check here.
//        }
//
//        [self.collectionViewSpecialImages reloadData];
//
//
//    }
    
     [self.collectionViewSpecialImages reloadData];
    [self dismissImagePickerControllerForCancel:YES];
    
    
    
    for (UINavigationController *view in self.navigationController.viewControllers)
    {
        
        if ([view isKindOfClass:[RPMultipleImagePickerViewController class]])
        {
            [self.navigationController popViewControllerAnimated:NO];
            
        }
    }
    
}






#pragma mark - image cropping feature

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// second library..............................

-(void)cropMethod
{
    if(selectedImage != nil)
    {
        ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:selectedImage];
        controller.delegate = self;
        controller.blurredBackground = YES;
        [[self navigationController] pushViewController:controller animated:YES];
    }
}

- (void)ImageCropViewController:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    if (croppedImage.size.width < croppedImage.size.height)
    {
        CGSize newSize;
        
        if ((croppedImage.size.width >= 1200) || (croppedImage.size.height >= 600))
        {
            if (croppedImage.size.width > croppedImage.size.height)
            {
                double factorPercentage = (1200/croppedImage.size.width);
                float valueHeigth = croppedImage.size.height * factorPercentage;
                if(valueHeigth<200)
                    newSize.height = 200;
                else
                    newSize.height = valueHeigth;
                newSize.width = 1200;
            }
            else
            {
                double factorPercentage = (600/croppedImage.size.height);
                float valueWidth = croppedImage.size.width * factorPercentage;
                if(valueWidth<400)
                    newSize.width = 400;
                else
                    newSize.width = valueWidth;
                
                newSize.height = 600;
            }
            lastImage = [self imageWithImage:croppedImage scaledToSize:newSize];
            selectedImage = lastImage;
        }
        else
        {
            lastImage = croppedImage;
            selectedImage = lastImage;
        }
    }
    else
    {
        lastImage = selectedImage;
        CGSize newSize;
        if ((croppedImage.size.width > 1200) || (croppedImage.size.height > 600))
        {
            if (croppedImage.size.width > croppedImage.size.height)
            {
                double factorPercentage = (1200/croppedImage.size.width);
                float valueHeigth = croppedImage.size.height * factorPercentage;
                if(valueHeigth<200)
                    newSize.height = 200;
                else
                    newSize.height = valueHeigth;
                newSize.width = 1200;
            }
            else
            {
                double factorPercentage = (600/croppedImage.size.height);
                float valueWidth = croppedImage.size.width * factorPercentage;
                if(valueWidth<400)
                    newSize.width = 400;
                else
                    newSize.width = valueWidth;
                
                newSize.height = 600;
            }
            lastImage = [self imageWithImage:croppedImage scaledToSize:newSize];
            selectedImage = lastImage;
        }
        else
        {
            lastImage = croppedImage;
            selectedImage = lastImage;
        }
    }
    
    isPrioritiesChanged = YES;
    
    SMPhotosListNSObject *imageObject = [[SMPhotosListNSObject alloc]init];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"ddHHmmssSS"];
    
    NSString *dateString=[formatter stringFromDate:[NSDate date]];
    
    imageObject.strimageName=[NSString stringWithFormat:@"%@_thumbnail",dateString];
    
    [self saveImage:selectedImage :imageObject.strimageName];
    
    imageObject.isImageFromLocal = YES;
    imageObject.imageLink = fullPathOftheImage;
    [arrayCreateSpOfImages addObject:imageObject];
    
    selectedImage = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionViewSpecialImages reloadData];
        
    });
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller
{
    //imageView.image = image;
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)saveImage:(UIImage*)image :(NSString*)imageName
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


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
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
                SMAlert(@"Error", @"Camera Not Available");
                return;
            }
        }
            break;
        case 1:
        {
            picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{}];
        }
            break;
        default:
            break;
    }
}

#pragma mark - ButtonMethods

- (IBAction)corecctedDidClick:(id)sender
{
    UIButton *checkButton=(UIButton *)sender;
    checkButton.selected=!checkButton.selected;
    isChecked = checkButton.selected==YES ? YES :NO;
}

- (IBAction)saveDidClick:(id)sender
{
    if ([self validateSpecial] ==  YES)
    {
        [self createNewSpecial];
    }
}

- (IBAction)btnCancelDidClicked:(id)sender
{
    [self dismissPopup];
}

- (IBAction)btnSetDidClicked:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:self.datePickerView.date]];
    
    NSDate *endDate;
    
    switch (selectedType)
    {
        case 2:
        {
            startDate = self.datePickerView.date;
            
            [self.txtStartDate setText:textDate];
            [self.txtEndDate setText:@""];
        }
            break;
            
        case 3:
        {
            endDate = self.datePickerView.date;
            
            switch ([startDate compare:endDate])
            {
                case NSOrderedAscending:
                    [self.txtEndDate setText:textDate];
                    break;
                    
                case NSOrderedDescending:
                {
                    [self.txtEndDate setText:@""];
                    
                    SMAlert(KLoaderTitle, KStartGreaterEnd);
                }
                    break;
                    
                case NSOrderedSame:
                    [self.txtEndDate setText:textDate];
                    break;
            }
        }
            break;
            
        case 7:
        {
            [self.txtMake setText:@""];
            [self.txtModel setText:@""];
            [self.txtVariant setText:@""];
            
            [makeArray removeAllObjects];
            [modelArray removeAllObjects];
            [variantArray removeAllObjects];
            
            [self.txtSelectVehicle setText:[arrayYears objectAtIndex:selectedRow]];
        }
            break;
    }
    
    [self dismissPopup];
}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:self.tblCreateSpecial];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 1;
    [self.tblCreateSpecial setContentOffset:pt animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    /* CGPoint pt;
     [self.tblCreateSpecial setContentOffset:pt animated:YES];*/
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CGRect frame = [self.tblCreateSpecial convertRect:textField.frame fromView:textField.superview.superview];
    [self.tblCreateSpecial setContentOffset:CGPointMake(0, frame.origin.y)];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0:  // For Select Type
        {
            selectedType = 0;
            [self.loadSpecialTableView setHidden:NO];
            [self.pickerView setHidden:YES];
            [self.yearView setHidden:YES];
            [self.view endEditing:YES];
            
            if (typeArray.count>0)
            {
                NSLog(@"33333");
                [loadSpecialTableView reloadData];
                [self loadPopup];
            }
            else
            {
                [self loadSelectType];
            }
            
            return NO;
        }
            break;
            
            //        case 1: // For Select Vehicle
            //        {
            ////            if (txtSelectType.text.length>0)
            ////            {
            ////                selectedType = 1;
            ////                [self.loadSpecialTableView setHidden:NO];
            ////                [self.pickerView setHidden:YES];
            ////                [self.yearView setHidden:YES];
            ////
            ////                if (vehicleArray.count>0)
            ////                {
            ////                    [loadSpecialTableView reloadData];
            ////                    [self loadPopup];
            ////                }
            ////                else
            ////                {
            ////                    [self loadSelectVehicle];
            ////                }
            ////            }
            ////            else
            ////            {
            ////                [textField resignFirstResponder];
            ////                SMAlert(KLoaderTitle, KSelectType);
            ////            }
            //            return NO;
            //        }
            //            break;
            
        case 6: // For Start Date
        {
            selectedType = 2;
            [self.loadSpecialTableView setHidden:YES];
            [self.pickerView setHidden:NO];
            [self.yearView setHidden:YES];
            [self.view endEditing:YES];
            NSLog(@"**********************************************");
            [self loadPopup];
            
            return NO;
        }
            break;
            
        case 7:  // For End Date
        {
            if (self.txtStartDate.text.length==0)
            {
                SMAlert(KLoaderTitle, KStartDate);
            }
            else
            {
                selectedType = 3;
                [self.loadSpecialTableView setHidden:YES];
                [self.pickerView setHidden:NO];
                [self.yearView setHidden:YES];
                [self.view endEditing:YES];
                [self loadPopup];
            }
            
            return NO;
        }
            break;
            
        case 8:
        {
            selectedType = 7;
            /*[self.view endEditing:YES];
             [self.loadSpecialTableView setHidden:YES];
             [self.pickerView setHidden:YES];
             [self.yearView setHidden:NO];
             [self.yearPickerView selectRow:selectedRow inComponent:0 animated:YES];
             [self loadPopup];*/
            
            [self.view endEditing:YES];
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            [popUpView getTheDropDownData:[SMAttributeStringFormatObject getYear] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:YES]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                textField.text = selectedTextValue;
                strSelectedYear = selectedTextValue;
                selectedRow = selectIDValue;
                //selectedMakeId = selectIDValue;
            }];
            
            
            return NO;
        }
            break;
            
        case 10: // For Make
        {
            selectedType = 4;
            [self.loadSpecialTableView setHidden:NO];
            [self.pickerView setHidden:YES];
            [self.yearView setHidden:YES];
            [self.view endEditing:YES];
            if (makeArray.count>0)
            {
                NSLog(@"4444");
                [loadSpecialTableView reloadData];
                [self loadPopup];
            }
            else
            {
                [self loadAllMakelisting];
            }
            
            return NO;
        }
            break;
            
        case 11: // For Model
        {
            if (self.txtMake.text.length>0)
            {
                [self.view endEditing:YES];
                selectedType = 5;
                [self.loadSpecialTableView setHidden:NO];
                [self.pickerView setHidden:YES];
                [self.yearView setHidden:YES];
                
                if (modelArray.count>0)
                {
                    NSLog(@"55555");
                    [loadSpecialTableView reloadData];
                    [self loadPopup];
                }
                else
                {
                    [self loadAllModelListing];
                }
            }
            else
            {
                [textField resignFirstResponder];
                SMAlert(KLoaderTitle, KMakeSelection);
            }
            
            return NO;
        }
            break;
            
       
                case 12:  // For Variant
        {
            if (self.txtModel.text.length>0)
            {
                selectedType = 6;
                [self.loadSpecialTableView setHidden:NO];
                [self.pickerView setHidden:YES];
                [self.yearView setHidden:YES];
                [self.view endEditing:YES];
                [self loadAllVariant];
                //                if (variantArray.count>0)
                //                {
                //                    NSLog(@"6666");
                //                    [loadSpecialTableView reloadData];
                //                    [self loadPopup];
                //                }
                //                else
                //                {
                //                    [self loadAllVariant];
                //                }
            }
            if (self.txtMake.text.length == 0)
            {
                [textField resignFirstResponder];
                SMAlert(KLoaderTitle, KMakeSelection);
            }
            else if (self.txtModel.text.length == 0)
            {
                [textField resignFirstResponder];
                SMAlert(KLoaderTitle, KModelSelection);
            }
            
            return NO;
        }
            
            
            break;
    }
    
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtNormalPriceR) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 7) ? NO : YES;
    }
    else if (textField == self.txtSpecialPrice) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 7) ? NO : YES;
    }
    else
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 50) ? NO : YES;
    }
}

-(void) getVehicleDropDown{
    
    [arrmForVehicle removeAllObjects];
    
    
    for(int i=0;i<vehicleArray.count;i++)
    {
        SMLoadSpecialObject *objectSpecialTypeCell = (SMLoadSpecialObject *) [vehicleArray objectAtIndex:i];
        SMDropDownObject *objCondition = [[SMDropDownObject alloc] init];
        objCondition.strMakeId = [NSString stringWithFormat:@"%d",i+1];
        objCondition.strMakeName =objectSpecialTypeCell.strSelectName;
        objCondition.strMakeYear =  objectSpecialTypeCell.strVehicleUsedYear;
        objCondition.strMeanCodeNumber = objectSpecialTypeCell.strVehicleStockCode;
        objCondition.strColor = objectSpecialTypeCell.strVehicleColor;
        objCondition.strDropDownValue = objectSpecialTypeCell.strRetailPrice;
        objCondition.strStockId = objectSpecialTypeCell.strUsedVehicleStockID;
        [arrmForVehicle addObject:objCondition];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == self.txtSelectVehicle && textField.tag!=786)//not for Item as not need to to show dropdown
    {
        selectedType = 1;
        if (txtSelectType.text.length>0)
        {
            
            [self.view endEditing:YES];
            /*************  your Request *******************************************************/
            [textField resignFirstResponder];
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpSearchTableView" owner:self options:nil];
            SMCustomPopUpSearchTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            SMDropDownObject *objCondition = [[SMDropDownObject alloc] init];
            [arrmForVehicle addObject:objCondition];
            [popUpView getTheDropDownData:arrmForVehicle withVariant:YES withVehicle:YES isPagination:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpSearchTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int selectedYear,  NSString *strVehicleStockId) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                SMDropDownObject *obj = [[SMDropDownObject alloc] init];
                obj = [arrmForVehicle objectAtIndex:(selectIDValue-1)];
                itemID = obj.strStockId.intValue;
                textField.text = selectedTextValue;
                self.txtNormalPriceR.text = strVehicleStockId;
            }];
            
        }
        else{
            [textField resignFirstResponder];
            SMAlert(KLoaderTitle, KSelectType);
        }
        /*************  your Response *******************************************************/
    }
    
    CGRect frame = [self.tblCreateSpecial convertRect:textField.frame fromView:textField.superview.superview];
    
    [self.tblCreateSpecial setContentOffset:CGPointMake(0, frame.origin.y)];
}

#pragma mark -

- (void)loadSelectType
{
    NSMutableURLRequest *requestURL=[SMWebServices gettingALlSpeacialTypeListing:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    HUD.labelText = KLoaderText;
    [HUD show:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             
             [self hideProgressHUD];
         }
         else
         {
             typeArray = [[NSMutableArray alloc]init];
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
    
}

- (void)loadSelectVehicle
{
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    NSString *vehicleType;
    
    if([self.txtSelectType.text hasPrefix:@"Used"])
    {
        vehicleType = @"Used";
    }
    else
    {
        vehicleType = @"New";
    }
    
    NSMutableURLRequest *requestURL=[SMWebServices getSpecialVehiclesListing:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleType:vehicleType];
    
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
         }
         else
         {
             vehicleArray = [[NSMutableArray alloc]init];
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
    
}

- (void)getSpecialBySpecialID
{
    //checkImage = isEditable; // changes by liji
    
    checkImage = isNone;
    
    // NSMutableURLRequest *requestURL=[SMWebServices GetSpecialBySpecialID:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withSpecialID:specialID];
    
    NSMutableURLRequest *requestURL=[SMWebServices editSpecial:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withSpecialID:activeSpecialObj.strSpecialID.intValue];
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    HUD.labelText = KLoaderText;
    [HUD show:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             
             [self hideProgressHUD];
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

- (void)loadSpecialImagesBySpecialID
{
    checkImage = isImage;
    NSMutableURLRequest *requestURL=[SMWebServices getSpecialImagesBySpecialIDWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withSpecailID:specialID];
    
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

#pragma mark - load popup

- (void)loadPopup
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

#pragma mark - dismiss popup

- (void)dismissPopup
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
              [popupView setTransform:CGAffineTransformMakeScale(0.9    ,0.9)];
              
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

#pragma mark - NSXMLParser Delegate

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"AUTOSpecialType"] || [elementName isEqualToString:@"Vehicle"])
    {
        loadSpecialObject = [[SMLoadSpecialObject alloc] init];
        
       
    }
    
    if([elementName isEqualToString:@"Image"])
    {
         loadImageData = [[SMPhotosListNSObject alloc]init];
    }
    
    if ([elementName isEqualToString:@"Images"]) {
        arrayCreateSpOfImages = [[NSMutableArray alloc] init];
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"FriendlyName"])
    {
        loadSpecialObject.strSelectName = currentNodeContent;
    }
    
    // added by ketan
    
    if ([elementName isEqualToString:@"SpecialID"])
    {
        loadImageData.strSpecialID = currentNodeContent;
        
        activeSpecialObj.strSpecialID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"LinkImagePriority"])
    {
        loadImageData.isLinkImagePriorityD = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"ImageID"])
    {
        loadImageData.imageLink = [NSString stringWithFormat:@"%@%@",[SMWebServices activeSpecailListingImage],currentNodeContent];
        
    }
    if ([elementName isEqualToString:@"SpecialImageID"])
    {
        loadImageData.strSpecialImageID = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"Title"]) {
        activeSpecialObj.strTitle = currentNodeContent;
        self.txtTitle.text = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"itemID"])
    {
        activeSpecialObj.ItemID = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"NormalPrice"])
    {
        activeSpecialObj.strNormalPrice = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SpecialPrice"])
    {
        activeSpecialObj.strSpecialPrice = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Specialstart"])
    {
        activeSpecialObj.strSpecialStartDate= currentNodeContent;
    }
    if ([elementName isEqualToString:@"SpecialEnd"])
    {
        activeSpecialObj.strSpecialEndDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Summary"])
    {
        activeSpecialObj.strSummarySpecial = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Details"])
    {
        activeSpecialObj.strSpecialDetails = currentNodeContent;
    }
    if ([elementName isEqualToString:@"COREMemberName"]) {
        lblAuthorName.text = currentNodeContent;
    }

    if ([elementName isEqualToString:@"PublisherName"]) {
        
        if (currentNodeContent.length == 0) {
            [viewAuthorDetails setFrame:CGRectMake(viewAuthorDetails.frame.origin.x,viewAuthorDetails.frame.origin.y, viewAuthorDetails.frame.size.width, 40.0f)];
            lblPublisherName.hidden = YES;
            lblPublicherHeader.hidden=YES;
            [self.btnSave setFrame:CGRectMake(self.btnSave.frame.origin.x, viewAuthorDetails.frame.origin.y+45.0f+5.0f, self.btnSave.frame.size.width, self.btnSave.frame.size.height)];
        }
        else{
        lblPublisherName.text = currentNodeContent;
        [self.btnSave setFrame:CGRectMake(self.btnSave.frame.origin.x, viewAuthorDetails.frame.origin.y+viewAuthorDetails.frame.size.height+5.0f, self.btnSave.frame.size.width, self.btnSave.frame.size.height)];
            viewAuthorDetails.hidden = NO;
        }
    }
    // Start Of LoadVehicleDetailsXML response
    
    if ([elementName isEqualToString:@"friendlyName"])
    {
        activeSpecialObj.stractiveName = currentNodeContent;
        
        [self.lblVehicleName setText:currentNodeContent];
    }
    if ([elementName isEqualToString:@"stockCode"])
    {
        [self.lblName setText:currentNodeContent];
    }
    if ([elementName isEqualToString:@"year"])
    {
        [self.lblYear setText:currentNodeContent];
    }
    if ([elementName isEqualToString:@"colour"])
    {
        [self.lblColour setText:currentNodeContent];
    }
    if ([elementName isEqualToString:@"mileage"])
    {
        if ([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"0"])
        {
            [self.lblMileage setText:@"0 Km"];
        }
        else
        {
            [self.lblMileage setText:[NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent]]];
        }
    }
    if ([elementName isEqualToString:@"price"])
    {
        [self.lblPrice setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:currentNodeContent]];
    }
    if ([elementName isEqualToString:@"LoadVehicleDetailsXMLResult"])
    {
        isStatus = YES;
        NSLog(@"77777");
        [tblCreateSpecial reloadData]; // IT will show one more section with Information
    }
    // End Of LoadVehicleDetailsXML response
    
    
    if([elementName isEqualToString:@"MakeName"])
    {
        activeSpecialObj.strMakeName = currentNodeContent;
    }
    if([elementName isEqualToString:@"ModelName"])
    {
        activeSpecialObj.strModelName = currentNodeContent;
    }
    if([elementName isEqualToString:@"VariantName"])
    {
        activeSpecialObj.strVariantName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SavePrice"])
    {
        activeSpecialObj.strSavePrice = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"AUTOSpecialTypeID"])
    {
        loadSpecialObject.strSelectId = currentNodeContent;
        
        activeSpecialObj.strTypeID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"UsedYear"])
    {
        loadSpecialObject.strVehicleUsedYear = currentNodeContent;
        
        activeSpecialObj.strUsedYear = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        loadSpecialObject.strVehicleColor = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
        loadSpecialObject.strVehicleMileage = currentNodeContent;
    }
    if([elementName isEqualToString:@"StockCode"])
    {
        loadSpecialObject.strVehicleStockCode = currentNodeContent;
    }
    if ([elementName isEqualToString:@"UsedVehicleStockID"])
    {
        
        loadSpecialObject.strUsedVehicleStockID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"RetailPrice"])
    {
        loadSpecialObject.strRetailPrice = currentNodeContent;
    }
    if([elementName isEqualToString:@"MakeID"])
    {
        loadSpecialObject.strVehicleMakeID = currentNodeContent;
        
        activeSpecialObj.strMakeID = currentNodeContent;
    }
    if([elementName isEqualToString:@"modelID"])
    {
        loadSpecialObject.strVehicleModelID = currentNodeContent;
        
        activeSpecialObj.strModelID = currentNodeContent;
    }
    if([elementName isEqualToString:@"VariantID"])
    {
        loadSpecialObject.strVehicleVariantID = currentNodeContent;
        
        activeSpecialObj.strVariantID = currentNodeContent;
    }
    if([elementName isEqualToString:@"ItemValue"])
    {
       
    }
    if([elementName isEqualToString:@"Name"])
    {
        loadSpecialObject.strSelectName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Images"]) {
      // sort the array using priority
        NSArray *sortedArray;
        sortedArray = [arrayCreateSpOfImages sortedArrayUsingComparator:^NSComparisonResult(SMPhotosListNSObject *a, SMPhotosListNSObject *b) {
            if ( a.strPriority.intValue < b.strPriority.intValue) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if ( a.strPriority.intValue > b.strPriority.intValue) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        [arrayCreateSpOfImages removeAllObjects];
        arrayCreateSpOfImages = sortedArray.mutableCopy;
        
    }
   
    if([elementName isEqualToString:@"Image"])
    {
        loadImageData.isImageFromLocal=NO;
        loadImageData.imageOriginIndex = -1;
        [arrayCreateSpOfImages addObject:loadImageData];
    }
    
    if([elementName isEqualToString:@"AUTOSpecialImageID"])
    {
        loadImageData.strAUTOSpecialImageID = currentNodeContent;
    }
    if([elementName isEqualToString:@"OriginalFileName"])
    {
       loadImageData.strOriginalFileName = currentNodeContent;

    }
    if([elementName isEqualToString:@"Priority"])
    {
        loadImageData.strPriority = currentNodeContent;
    }
    if([elementName isEqualToString:@"IsSpecial"])
    {
        loadImageData.strIsSpecials = currentNodeContent;
    }
    if([elementName isEqualToString:@"AUTOSpecialID"])
    {
        loadImageData.strAUTOSpecialID = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"AUTOSpecialType"] || [elementName isEqualToString:@"Vehicle"])
    {
        
        if (iCheckSpecial == 20) {
            // for edit screen show data
            //NSPredicate *pred = [NSPredicate predicateWithFormat:@"strCatid == %@",objCategory.strCatid];
            //                                                             NSArray *arrSearchedObjects = [arrAllCategories filteredArrayUsingPredicate:pred];

            NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"strUsedVehicleStockID == %@",[NSString stringWithFormat:@"%d",activeSpecialObj.ItemID]];
            NSArray *filteredArray = [vehicleArray filteredArrayUsingPredicate:bPredicate];
            if (filteredArray.count >0 ) {
                SMLoadSpecialObject *obj = [filteredArray objectAtIndex:0];
                self.txtSelectVehicle.text = obj.strSelectName;
            }
        }
        if (checkImage==isImage)
        {
            loadImageData.isImageFromLocal=NO;
            loadImageData.imageOriginIndex = -1;
            
            [arrayCreateSpOfImages addObject:loadImageData];
        }
        else
        {
            if (selectedType==0)
            {
                [typeArray addObject:loadSpecialObject];
            }
            else if (selectedType==1)
            {
                [vehicleArray addObject:loadSpecialObject];
            }
        }
    }
    
    if ([elementName isEqualToString:@"LoadSpecialTypesXMLResult"] ||[elementName isEqualToString:@"ListVehicleByClientXMLResult"])
    {
        NSLog(@"8888");
        [loadSpecialTableView reloadData];
        [collectionViewSpecialImages reloadData];
        
        if (checkImage==isEditable)
        {
            [self loadSpecialImagesBySpecialID];
        }
        else
        {
            if (selectedType==0)
            {
                typeArray.count > 0 ? [self loadPopup] : [self showErrorAlert];
            }
            else if (selectedType==1)
            {
                vehicleArray.count > 0 ? [self getVehicleDropDown] : [self showErrorAlert];
            }
        }
    }
    
    if ([elementName isEqualToString:@"GetSpecialImagesBySpecialIDResponse"])
    {
        checkImage = isNone;
    }
    
    if ([elementName isEqualToString:@"SaveSpecialResult"])
    {
        if ([currentNodeContent isEqualToString:@"0"])
        {
            [self showAlert:@"Failed, Please Try Again."];
        }
        else
        {
            // once specail added then start for image uploading process
            savedSpecialID = currentNodeContent.intValue;
            
            [self performSelector:@selector(uploadingAddStockImagesVideos) withObject:nil afterDelay:0.1];
        }
    }
    
    if ([elementName isEqualToString:@"SaveSpecialsImagePriorityResult"])
    {
        if ([currentNodeContent isEqualToString:@"1"])
        {
            NSLog(@"uploadingHUD.progress = %f",uploadingHUD.progress);
            uploadingHUD.progress+=valueOfProgress;
            
            if (uploadingHUD.progress >= 1.000000)
            {
                [uploadingHUD setHidden:YES];
                [self navigateBackAfterSavedSpecial];
            }

        }
        else{
             [uploadingHUD setHidden:YES];
            SMAlert(kTitle, kSpecialImageUploadFailed);
        }
        
        NSLog(@"uploadingHUD.progress = %f",uploadingHUD.progress);
        
    }
    if ([elementName isEqualToString:@"DeleteSpecialsImageResult"])
    {
        if ([currentNodeContent isEqualToString:@"1"])
        {
            NSLog(@"uploadingHUD.progress = %f",uploadingHUD.progress);
            uploadingHUD.progress+=valueOfProgress;
            
            if (uploadingHUD.progress >= 1.000000)
            {
                [uploadingHUD setHidden:YES];
                if (arrayCreateSpOfImages.count == 0)// because if there are more images that need save functionality so avoid to navigate back and show 2 pops
                {
                    [self navigateBackAfterSavedSpecial];
                }
                
            }
            
        }
        else{
             [uploadingHUD setHidden:YES];
            SMAlert(kTitle, kSpecialImageDeletedFailed);
        }
        
        NSLog(@"uploadingHUD.progress = %f",uploadingHUD.progress);
        
    }

    
    if ([elementName isEqualToString:@"SaveSpecialsImageResponse"]){
       
        
        if ([currentNodeContent isEqualToString:@"1"])
        {
            NSLog(@"uploadingHUD.progress = %f",uploadingHUD.progress);
            uploadingHUD.progress+=valueOfProgress;
            
            if (uploadingHUD.progress >= 1.000000)
            {
            [uploadingHUD setHidden:YES];
            [self navigateBackAfterSavedSpecial];
            }
        }
        else{
            SMAlert(kTitle, kSpecialImageUploadFailed);
        }
        NSLog(@"uploadingHUD.progress = %f",uploadingHUD.progress);
    }
    
    //get Make data
    if ([elementName isEqualToString:@"GetVehicleMakesByYearJSONResult"])
    {
        NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            SMLoadSpecialObject *objectSpecialType;
            
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                objectSpecialType=[[SMLoadSpecialObject alloc]init];
                objectSpecialType.strSelectName   =dictionary[@"makeName"];
                objectSpecialType.strVehicleMakeID  =dictionary[@"makeID"];
                objectSpecialType.strMakeName = dictionary[@"makeName"]; // new added by jigensh
                [makeArray addObject:objectSpecialType];
            }
            NSLog(@"99999");
            [loadSpecialTableView reloadData];
            makeArray.count > 0 ? [self loadPopup] : [self showErrorAlert];
        }
        else
        {
            SMAlert(KLoaderTitle, [jsonObject valueForKey:@"message"]);
        }
    }
    
    //get Model data
    if ([elementName isEqualToString:@"GetVehicleModelsByMakeIdJSONResponse"])
    {
        NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            SMLoadSpecialObject *objectSpecialType;
            
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                objectSpecialType=[[SMLoadSpecialObject alloc]init];
                objectSpecialType.strSelectName      =dictionary[@"modelName"];
                objectSpecialType.strVehicleModelID  =dictionary[@"modelID"];
                objectSpecialType.strModelName       =dictionary[@"modelName"];
                [modelArray addObject:objectSpecialType];
            }
            NSLog(@"10000");
            [loadSpecialTableView reloadData];
            
            modelArray.count > 0 ? [self loadPopup] : [self showErrorAlert];
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
    }
    //
    //    //get varient data
    //    if ([elementName isEqualToString:@"GetVehicleVariantByModelIdJSONResult"])
    //    {
    //        NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
    //        NSDictionary *jsonObject=[NSJSONSerialization
    //                                  JSONObjectWithData:data
    //                                  options:NSJSONReadingMutableLeaves
    //                                  error:nil];
    //
    //        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
    //        {
    //            SMLoadSpecialObject *objectSpecialType;
    //
    //            for (NSDictionary *dictionary in jsonObject[@"data"])
    //            {
    //                objectSpecialType=[[SMLoadSpecialObject alloc]init];
    //                objectSpecialType.strSelectName       =dictionary[@"friendlyName"];
    //                objectSpecialType.strVehicleVariantID =dictionary[@"variantID"];
    //                [variantArray addObject:objectSpecialType];
    //            }
    //            NSLog(@"119999");
    //            [loadSpecialTableView reloadData];
    //
    //            variantArray.count > 0 ? [self loadPopup] : [self showErrorAlert];
    //        }
    //        else
    //        {
    //            SMAlert(KLoaderTitle, [jsonObject valueForKey:@"message"]);
    //        }
    //    }
    
    //get varient data
    if ([elementName isEqualToString:@"GetVehicleVariantByModelIdJSONResult"])
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
                loadVehiclesObject.strMakeName          =dictionary[@"variantName"];
                loadVehiclesObject.strMeanCodeNumber    =dictionary[@"mmCode"];
                
                if ([dictionary[@"startDate"] isKindOfClass:[NSNull class]]) {
                    loadVehiclesObject.strMinYear           =@"0";
                }else{
                     loadVehiclesObject.strMinYear           =[[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:dictionary[@"startDate"] withFormat:4] ;
                }
                
                
                if ([dictionary[@"endDate"] isKindOfClass:[NSNull class]]) {
                    loadVehiclesObject.strMaxYear           =@"0";
                }else{
                    loadVehiclesObject.strMaxYear           =[[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:dictionary[@"endDate"] withFormat:4] ;
                }

               
                [arrmForVariant          addObject:loadVehiclesObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
        
    }
    
    if ([elementName isEqualToString:@"GetVehicleVariantByModelIdJSONResponse"])
    {
        if (arrmForVariant.count!=0)
        {
            //variantArray.count>0 ?[self loadPopup]:SMAlert(KLoaderTitle,KNorecordsFousnt);
            
            /*************  your Request *******************************************************/
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:arrmForVariant withVariant:YES andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                iVariantID = selectIDValue;
                self.txtVariant.text = selectedTextValue;
                
            }];
            
            [self hideProgressHUD];
        }
    }
    
    if ([elementName isEqualToString:@"GetAllListOfNewVehicleInStockResult"])
    {
        [self getVehicleDropDown];
        
        if ([currentNodeContent isEqualToString:@""])
            SMAlert(KLoaderTitle, @"No vehicles found");
    }
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    
    if (checkImage!=isImage)
        [self hideProgressHUD];
    
    [collectionViewSpecialImages reloadData];
}

#pragma mark - didReceiveMemoryWarning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - showErrorAlert

- (void)showErrorAlert
{
    SMAlert(KLoaderTitle, KNorecordsFousnt);
}

#pragma mark -

#pragma mark - MBprogress HUD Methods
-(void) addingProgressHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}

-(void) hideProgressHUD
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
        });
    });
}
#pragma mark -

#pragma mark - Create Special Web Service

-(void) createNewSpecial
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL;
    
    if (self.txtSelectVehicle.tag == 786) {
    requestURL = [SMWebServices createSpecial:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withSpecialTypeID:selectedSpecialTypeID
                             withDateSpecialStart:txtStartDate.text
                                withendSpecialEnd:txtEndDate.text
                                       withItemID:itemID
                                    withvariantID:iVariantID
                                      withModelID:iModelID
                                       withMakeID:iMakeID
                                 withspecialPrice:[[txtSpecialPrice.text stringByReplacingOccurrencesOfString:@"R" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]
                                  withnormalPrice:[[txtNormalPriceR.text stringByReplacingOccurrencesOfString:@"R" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]
                                      withDetails:txtvDescription.text
                                      withSummary:[self encodeString:txtTitle.text]
                                   withallowGroup:false
                                   withcorrection:isChecked
                                    withSpecailID:specialID
                                withItemValue:self.txtSelectVehicle.text
                             withYear:@"0"];//0 because issue of web service crash
    }else{
    requestURL = [SMWebServices createSpecial:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withSpecialTypeID:selectedSpecialTypeID
                                              withDateSpecialStart:txtStartDate.text
                                                 withendSpecialEnd:txtEndDate.text
                                                        withItemID:itemID
                                                     withvariantID:iVariantID
                                                       withModelID:iModelID
                                                        withMakeID:iMakeID
                                                  withspecialPrice:[[txtSpecialPrice.text stringByReplacingOccurrencesOfString:@"R" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]
                                                   withnormalPrice:[[txtNormalPriceR.text stringByReplacingOccurrencesOfString:@"R" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]
                                                       withDetails:txtvDescription.text
                                                       withSummary:[self encodeString:txtTitle.text]
                                                    withallowGroup:false
                                                    withcorrection:isChecked
                                                     withSpecailID:specialID
                                                    withItemValue:@""
                                                    withYear:strSelectedYear];
                  }
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

- (void)webServiceForLoadVehicleDetailsXML:(int)usedStockID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices gettingLoadVehiclesImagesListForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:usedStockID];
    
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

-(BOOL) validateSpecial
{
    if (self.txtSelectVehicle.tag == 786) {
        {
            if (txtSelectType.text.length == 0)
            {
                [self showAlert:@"Select special type"];
                return NO;
            }
            else if(txtNormalPriceR.text.length == 0)
            {
                [self showAlert:@"Enter retail price"];
                return NO;
            }
            else if (txtSpecialPrice.text.length == 0)
            {
                [self showAlert:@"Enter special price"];
                return NO;
            }
            else if (txtTitle.text.length == 0)
            {
                [self showAlert:@"Enter special title"];
                return NO;
            }
            else if(txtStartDate.text.length == 0)
            {
                [self showAlert:@"Select start date"];
                return NO;
            }
            else
            {
                return YES;
            }
        }
    }else{
    if (txtSelectType.text.length == 0)
    {
        [self showAlert:@"Select special type"];
        return NO;
    }
    else if (txtSelectVehicle.text.length == 0 && txtSelectVehicle.tag==8)
    {
        [self showAlert:@"Select year"];
        return NO;
    }
    else if (txtSelectVehicle.text.length == 0 && txtSelectVehicle.tag==1)
    {
        [self showAlert:@"Select vehicle type"];
        return NO;
    }
    else if ([txtSelectType.text rangeOfString:@"(In Stock)"].location==NSNotFound && self.txtMake.text.length==0)
    {
        SMAlert(KLoaderTitle, KMakeSelection);
        return NO;
    }
    else if ([txtSelectType.text rangeOfString:@"(In Stock)"].location==NSNotFound && self.txtModel.text.length==0)
    {
        SMAlert(KLoaderTitle, KModelSelection);
        return NO;
    }
    else if ([txtSelectType.text rangeOfString:@"(In Stock)"].location==NSNotFound && self.txtVariant.text.length == 0)
    {
        SMAlert(KLoaderTitle, KVariantSelection);
        return NO;
    }
    else if(txtNormalPriceR.text.length == 0)
    {
        [self showAlert:@"Enter retail price"];
        return NO;
    }
    else if (txtSpecialPrice.text.length == 0)
    {
        [self showAlert:@"Enter special price"];
        return NO;
    }
    else if (txtTitle.text.length == 0)
    {
        [self showAlert:@"Enter special title"];
        return NO;
    }
    else if (self.txtvDescription.text.length == 0)
    {
        [self showAlert:@"Enter special description"];
        return NO;
    }
    else if(txtStartDate.text.length == 0)
    {
        [self showAlert:@"Select start date"];
        return NO;
    }
    else
    {
        return YES;
    }
    }
}

#pragma mark -

- (IBAction)dismissNumberPad:(id)sender
{
    if ([txtNormalPriceR isFirstResponder])
    {
        [txtNormalPriceR resignFirstResponder];
    }
    else if ([txtSpecialPrice isFirstResponder])
    {
        [txtSpecialPrice resignFirstResponder];
    }
}

-(void) showAlert:(NSString *)alertMeassge
{
    dispatch_async(dispatch_get_main_queue(), ^{
        SMAlert(KLoaderTitle, alertMeassge);
    });
}
#pragma mark -



-(void)uploadingAddStockImagesVideos
{
    
    
    NSPredicate *predicateVideos = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];
    NSArray *arrayFiltered = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateVideos];
    if ([arrayFiltered count] > 0)
    {
        
        isPrioritiesChanged = YES;
    }
    
    if (isPrioritiesChanged == YES)
    {
        uploadingHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //Set determinate mode
        uploadingHUD.mode = MBProgressHUDModeDeterminate;
        uploadingHUD.delegate = self;
        uploadingHUD.labelText = @"\nUploading...";
        
        float arrayCount=(float)[arrayCreateSpOfImages count];
        valueOfProgress=1.0/arrayCount;
        
        // this stuff is for deleting the images from the server
        for(int k=0;k<[[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted count];k++)
        {
            SMPhotosListNSObject *deleteImagesObject = (SMPhotosListNSObject*)[[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted objectAtIndex:k];
            
            [self deleteSpecialImageWithSpecialImageID:deleteImagesObject.strAUTOSpecialImageID.intValue currentUserID:currentUserID];
        }
        
        // this stuff is for adding the new images to the server
        for(int i=0;i<[arrayCreateSpOfImages count];i++)
        {
            SMPhotosListNSObject *imagesObject = (SMPhotosListNSObject*)[arrayCreateSpOfImages objectAtIndex:i];
            
            if(imagesObject.isImageFromLocal==YES)
            {
                UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imagesObject.strimageName];
                NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
                
                base64Str = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
                
                // this stuff is for updating the priorities
                [self updateSpecilaImageWithPriority:i];
            }
            if(imagesObject.isImageFromLocal==NO)
            {
                [self updateCommentTheImagePrioritiesWithPriority:i andImageID:imagesObject.strAUTOSpecialImageID.intValue];
            }
        }
    }
    else
    {
        [self navigateBackAfterSavedSpecial];
    }
}


- (void)deleteSpecialImageWithSpecialImageID:(int)specialImageID currentUserID:(int)cmuserID
{
    NSMutableURLRequest *requestURL=[SMWebServices deleteSpecialImage:[SMGlobalClass sharedInstance].hashValue withSpecialID:specialImageID];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             
             [self hideProgressHUD];
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

-(void)updateSpecilaImageWithPriority:(int)priority
{
    NSMutableURLRequest *requestURL;
    
    requestURL= [SMWebServices SaveSpecialWithImage:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withspecialID:savedSpecialID withoriginalFileName:[NSString stringWithFormat:@"%@.jpg",@"test"] withBaseEncodingString:base64Str];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             
             [self hideProgressHUD];
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

-(void)updateCommentTheImagePrioritiesWithPriority:(int)priority andImageID:(int)imageID
{
    NSMutableURLRequest *requestURL=[SMWebServices updateSpecialImagePriority:[SMGlobalClass sharedInstance].hashValue withSpecialImageID:imageID withLinkImagePriority:priority+1];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             
             [self hideProgressHUD];
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

-(void) navigateBackAfterSavedSpecial
{
    UILabel *lbl = (UILabel *) self.navigationItem.titleView;
    
    NSString *message;
    
    if ([lbl.text isEqualToString:@"Edit Special"])
    {
        message = KspecialUpdated;
    }
    else if ([lbl.text isEqualToString:@"Create Special"])
    {
        message = kspcialSaved;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle  message:message cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
         {
             if (didCancel)
             {
                 for (UIViewController *vc in [self.navigationController viewControllers]) {
                     if ([vc isMemberOfClass:[SMSpecialsViewController class]]) {
                         [self.navigationController popToViewController:vc animated:YES];
                         return;
                     }
                 }
                 return;
             }
         }];
        
    });
}

-(void) loadAllMakelisting
{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllMakevaluesForSpecials:[SMGlobalClass sharedInstance].hashValue Year:self.txtSelectVehicle.text];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             
             [self hideProgressHUD];
         }
         else
         {
             makeArray = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void) loadAllModelListing
{
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllModelsvaluesForSpecials:[SMGlobalClass sharedInstance].hashValue Year:self.txtSelectVehicle.text makeId:iMakeID];
    
    
    
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             
             [self hideProgressHUD];
         }
         else
         {
             modelArray = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void) loadAllVariant
{
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllVarintsvaluesForSpecials:[SMGlobalClass sharedInstance].hashValue Year:self.txtSelectVehicle.text modelId:iModelID];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             
             [self hideProgressHUD];
         }
         else
         {
             arrmForVariant = [[NSMutableArray alloc ] init];
             variantArray = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}


- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// CDATA encoding added by jignesh

-(NSString *) encodeString:(NSString *) encodeString
{
    encodeString = [NSString stringWithFormat:@"<![CDATA[%@]]>",encodeString]; // category method call
    return encodeString;
}


- (IBAction)btnPlusImageDidClicked:(id)sender
{
    int RemainingCount;
    
    NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];
    NSArray *arrayFiltered = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateImages];
    if ([arrayFiltered count] > 0)
    {
        RemainingCount = arrayCreateSpOfImages.count-arrayFiltered.count;
    }
    else
        RemainingCount = arrayCreateSpOfImages.count;
    
    
    
    if(RemainingCount<20)
    {
        
        [UIActionSheet showInView:self.view
                        withTitle:@"Select The Picture"
                cancelButtonTitle:@"Cancel"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"Camera", @"Select From Library"]
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
                              
                              int RemainingCount;
                              
                              NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];
                              NSArray *arrayFiltered = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateImages];
                              if ([arrayFiltered count] > 0)
                              {
                                  NSPredicate *predicateLocalImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d AND isImageFromCamera == %d",YES,NO];// from server
                                  NSArray *arrayLocalFiltered = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateLocalImages];
                                  
                                  NSPredicate *predicateCameraImages = [NSPredicate predicateWithFormat:@"isImageFromCamera == %d",YES];// from server
                                  NSArray *arrayCameraFiltered = [arrayCreateSpOfImages filteredArrayUsingPredicate:predicateCameraImages];
                                  
                                  NSArray *finalFilteredArray = [arrayLocalFiltered arrayByAddingObjectsFromArray:arrayCameraFiltered];
                                  
                                  if(finalFilteredArray.count == 0)
                                      RemainingCount = 0;
                                  else
                                      RemainingCount = finalFilteredArray.count;
                              }
                              else
                                  RemainingCount = arrayCreateSpOfImages.count;
                              
                              [SMGlobalClass sharedInstance].isFromCamera = NO;
                              
                              isFromAppGallery = YES;
                              [self callTheMultiplePhotoSelectionLibraryWithRemainingCount:20 - RemainingCount andFromEditScreen:NO];
                          }
                              
                          default:
                              break;
                      }
                      
                      
                  }];
        
    }
    
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
-(void)delegateFunctionForDeselectingTheSelectedPhotos
{
    [imagePickerController deSelectAllTheSelectedPhotosWhenCancelAction];
    
}

-(void)dismissTheLoader
{
    [imagePickerController dismissTheLoaderAction];
    
    
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



@end
