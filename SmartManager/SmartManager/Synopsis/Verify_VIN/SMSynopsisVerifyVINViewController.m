//
//  SMSynopsisVerifyVINViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 19/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//


#define kAddedSections 2
#define kIndexForChangeVehicle 90
#define kTotalRow0Section 8

#import "SMSynopsisVerifyVINViewController.h"
#import "SMVerifyVIN_ModelVariantCell.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMDropDownObject.h"
#import "SMLoadVehiclesObject.h"
#import "SMCustomPopUpTableView.h"
#import "SMCustomPopUpPickerView.h"
#import "SMWSforSummaryDetails.h"
#import "SMSynopsisSummaryViewController.h"
#import "SMWSFullVerification.h"
#import "SMFullVerificationObjectXML.h"
#import "SMObjectVerificationDetailType.h"
#import "SMObjectVerificationDetailAttribute.h"
#import "SMWSVINVerification.h"
#import "SMVINVerificationXml.h"

@interface SMSynopsisVerifyVINViewController ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView *tblVerifyVIN;
    IBOutlet UIView *viewHeaderTable;
    IBOutlet UIView *viewHeaderChangeVehicle;
    
    IBOutlet UIView *viewHeaderFullVerification;
    IBOutlet UIView *viewFooterTable;
    
    
        MBProgressHUD *HUD;
        
        NSArray *arrConditionData;
        NSMutableArray *arrmForYear;
        NSMutableArray *arrmForMake;
        NSMutableArray *arrmForModel;
        NSMutableArray *arrmForVariant;
        NSMutableArray *arrmForCondition;
        
        SMDropDownObject *ObjectDropDownObject;
        SMLoadVehiclesObject        *loadVehiclesObject;
  
        SMFullVerificationObjectXML *objSMFullVerificationObjectXML;
        SMVINVerificationXml *objSMVINVerificationXml;
}
@end

@implementation SMSynopsisVerifyVINViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Verify VIN"];
    [self addingProgressHUD];
    txtVinNumber.delegate = self;
    self.txtRegNo.delegate = self;
    isChangeModelVariantButtonExpanded = NO;
    isVINVerificationButtonExpanded = NO;
    isFullVerificationButtonExpanded = NO;
    [self registerNibFile];
    btnFullVerification.layer.cornerRadius = 5.0;
    tblVerifyVIN.estimatedRowHeight =  44.0f;
   
    tblVerifyVIN.tableFooterView = [[UIView alloc]init];
    if(self.previousPageNumber != 1)
       tblVerifyVIN.tableFooterView = viewFooterTable;
    
    tblVerifyVIN.rowHeight = UITableViewAutomaticDimension;
    tblVerifyVIN.estimatedSectionHeaderHeight =  50.0f;
    tblVerifyVIN.sectionHeaderHeight = UITableViewAutomaticDimension;
    //tblVerifyVIN.estimatedSectionHeaderHeight = 80.0f;
    heightConstraintForVINVerification.constant = 0;
    heightConstraintForFullVerification.constant = 0;
    isBlueButtonClicked = NO;
    isYellowButtonClicked = NO;
    selectedYear = @"";
    [self gettingAllYearsForPickerView];
    
    [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstText:self.strMainVehicleYear andWithSecondText:self.strMainVehicleName forLabel: self.lblMainVehicleName];
    
    [viewHeaderTable setNeedsLayout];
    [viewHeaderTable layoutIfNeeded];
    
    
    if(self.lblMainVehicleName.frame.size.height <30)
    {
        CGRect frameUpdated = viewHeaderTable.frame;
        ifIphone{
        frameUpdated.size.height = 210.0;
        }
        viewHeaderTable.frame = frameUpdated;
        tblVerifyVIN.tableHeaderView = viewHeaderTable;
    }
    
    tblVerifyVIN.tableHeaderView = viewHeaderTable;
    NSLog(@"VehicleNameHeight = %f",self.lblMainVehicleName.frame.size.height);
    txtVinNumber.text = self.strSelectedVINNumber;

    if ([txtVinNumber.text isEqualToString:@"No VIN loaded"]) {
        txtVinNumber.text=@"";
    }
    if ([txtVinNumber.text isEqualToString:@"No Registration"]) {
        self.txtRegNo.text=@"";
    }
    self.txtRegNo.text =  self.strSelectedRegNo;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
  //  [self sizeHeaderToFit];

}

-(void)sizeHeaderToFit
{
    UIView *updatedHeaderView = tblVerifyVIN.tableHeaderView;
    [updatedHeaderView setNeedsLayout];
    [updatedHeaderView layoutIfNeeded];
    
    float heightUpdated = [updatedHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frameUpdated = updatedHeaderView.frame;
    frameUpdated.size.height = heightUpdated;
    updatedHeaderView.frame = frameUpdated;
    tblVerifyVIN.tableHeaderView = updatedHeaderView;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table View Delegates and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(isFullVerificationButtonExpanded)
        return objSMFullVerificationObjectXML.arrmFullVerification.count+kAddedSections;// Full Verification Section Header (Titles) count ....
    else
        return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0: {
            return viewHeaderChangeVehicle;
        }
        break;
            
        case 1: {
            return viewHeaderFullVerification;
        }
         break;    
            
        default:
        {
            if (isFullVerificationButtonExpanded) {
                UIView *headerView = [[UIView alloc] init];
                UIView *headerColorView = [[UIView alloc] init];
                UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
                [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    [headerView setFrame:CGRectMake(0, 0, 320, 25)];
                    [headerColorView setFrame:CGRectMake(0, 0, 320, 25)];
                    sectionLabelBtn.frame = CGRectMake(0, 0, tableView.bounds.size.width,25);
                    sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:17.0f];
                }
                else
                {
                    [headerView setFrame:CGRectMake(5, 5, 758, 35)];
                    [headerColorView setFrame:CGRectMake(5, 5, 758, 35)];
                    sectionLabelBtn.frame = CGRectMake(0, 5, 758,35);
                    sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
                }
                
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                    sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(10.0, 5.0, 0.0, 0.0);
                else
                    sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0);
                
                headerView.backgroundColor = [UIColor clearColor];
                
                
                headerColorView.backgroundColor=[UIColor blackColor];
                [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                
                [sectionLabelBtn addTarget:self action:@selector(btnSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                [sectionLabelBtn setTag:section];
                sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                
                headerColorView.layer.cornerRadius = 5.0;
                [headerColorView addSubview:sectionLabelBtn];
                [headerView addSubview:headerColorView];
                headerView.layer.cornerRadius = 5.0;
                
                SMObjectVerificationDetailType *objVerficationtype = [objSMFullVerificationObjectXML.arrmFullVerification objectAtIndex:section-kAddedSections];
                [sectionLabelBtn setTitle:objVerficationtype.strTitle forState:UIControlStateNormal];
                
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0f,headerView.frame.origin.y,self.view.frame.size.width,1.0f)];
                view.backgroundColor = [UIColor whiteColor];
                [headerView addSubview:view];
                return headerView;
            }
            else
                return 0;
        }
            break;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                if(isBlueButtonClicked)
                return 94.0;
                return 50.0;
            }
            else
            {
                if(isBlueButtonClicked)
                return 107.0;
                return 60.0;
            }
        
        }
            break;
        case 1:
        {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                if(isYellowButtonClicked)
                    return 94.0;
                return 50.0;
            }
            else
            {
                if(isYellowButtonClicked)
                    return 107.0;
                return 60.0;
            }

        }
            break;
        default:{
            ifIphone{
                return 25.0f;
            }
            return 35.0f;
        }
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            if(isVINVerificationButtonExpanded)
            return kTotalRow0Section;
            else
            return 0;
        }
        case 1:
        {
            return 0;
        }
        break;
        default:
        {
            if (isFullVerificationButtonExpanded) {
                SMObjectVerificationDetailType *objVerficationtype = [objSMFullVerificationObjectXML.arrmFullVerification objectAtIndex:section-kAddedSections];
                return objVerficationtype.arrmType.count;
            }
           else
               return 0;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if(indexPath.row == kIndexForChangeVehicle)
            {
                if(isChangeModelVariantButtonExpanded)
                {
                    return 275.0;
                }
                else
                {
                    return 55.0;
                }
            }
            
            else
                return UITableViewAutomaticDimension;
        }
            break;
            
        default:
        {
            return UITableViewAutomaticDimension;
        }
            break;
       
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier1=@"SMVerifyVIN_ModelVariantCell";
    static NSString *cellIdentifier2= @"SMVerifyVIN_ColumnCell";
    static NSString *cellIdentifier3= @"SMVerifyVIN_BottomCell";
     static NSString *cellIdentifier4= @"FullVerificationCell";
    
    UITableViewCell *finalCell;
    
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == kIndexForChangeVehicle)
            {
//                
//                SMVerifyVIN_ModelVariantCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
//                cell.selectionStyle=UITableViewCellSelectionStyleNone;
//                
//                [cell.btnChangeModelVariant addTarget:self action:@selector(btnChangeModelVariantDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//                
//                [cell.btnClearDidClicked addTarget:self action:@selector(btnClearDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.btnUpdateDidClicked addTarget:self action:@selector(btnUpdateDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//                
//                cell.txtFieldYear.delegate = self;
//                cell.txtFieldMake.delegate = self;
//                cell.txtFieldModel.delegate = self;
//                cell.txtFieldVariant.delegate = self;
//                
//                if(isChangeModelVariantButtonExpanded)
//                {
//                    [cell.imgViewArrow setImage:[UIImage imageNamed:@"down_arrowSelected"]];
//                    
//                    cell.viewContainingModelVariantTextfields.hidden = NO;
//                    
//                   /* if([selectedYear length] == 0)
//                    {
//                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                        [formatter  setDateFormat:@"yyyy"];
//                        NSString  *currentYear = [formatter stringFromDate:[NSDate date]];
//                        selectedYear = currentYear;
//                        cell.txtFieldYear.text = selectedYear;
//                    }*/
//                    
//                }
//                else
//                {
//                    [cell.imgViewArrow setImage:[UIImage imageNamed:@"down_arrowT"]];
//                    cell.viewContainingModelVariantTextfields.hidden = YES;
//                }
//                
//                finalCell = cell;
//                finalCell.backgroundColor = [UIColor blackColor];
//
//                return finalCell;
            }
            else
            {
                SMVerifyVIN_ModelVariantCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                if(indexPath.row !=0)
                {
                    cell.heightConstraintForColumn.constant = 0;
                    cell.viewContainingColumn.hidden = YES;
                    
                    switch (indexPath.row)
                    {
                       
                        case 1:
                        { [cell.lblVerified setTextColor:[UIColor whiteColor]];
                            cell.lblLeftTitle.text = @"Manufacturer";
                            cell.lblVerified.text=objSMVINVerificationXml.strMatchManufacturer;
                        }
                            break;
                        case 2:
                        { [cell.lblVerified setTextColor:[UIColor whiteColor]];
                            cell.lblLeftTitle.text = @"Model & Variant";
                            cell.lblVerified.text=objSMVINVerificationXml.strMatchModel;
                        }
                            break;
                        case 3:
                        {
                            cell.lblLeftTitle.text = @"VIN or Chassis No";
                            if ([objSMVINVerificationXml.strMatchVinorChassis isEqualToString:@"Match"]) {
                                [cell.lblVerified setText:@"\u2713"];
                                [cell.lblVerified setTextColor:[UIColor greenColor]];
                            }
                            else{
                                [cell.lblVerified setText:@"x"];
                                [cell.lblVerified setTextColor:[UIColor redColor]];
                            }

                           
                        }
                            break;
                        case 4:
                        {
                            cell.lblLeftTitle.text = @"Engine No";
                            if ([objSMVINVerificationXml.strMatchEngineNumber isEqualToString:@"Match"]) {
                                [cell.lblVerified setText:@"\u2713"];
                                [cell.lblVerified setTextColor:[UIColor greenColor]];
                            }
                            else{
                                [cell.lblVerified setText:@"x"];
                                [cell.lblVerified setTextColor:[UIColor redColor]];
                            }
                        }
                            break;
                        case 5:
                        {
                            [cell.lblVerified setTextColor:[UIColor whiteColor]];
                            cell.lblLeftTitle.text = @"Registration No";
                            cell.lblVerified.text=objSMVINVerificationXml.strMatchVehicleRegistration;
                        }
                            break;
                        case 6:
                        {
                             [cell.lblVerified setTextColor:[UIColor whiteColor]];
                            cell.lblLeftTitle.text = @"Colour";
                            cell.lblVerified.text=objSMVINVerificationXml.strMatchColour;
                        }
                            break;
                        case 7:
                        { [cell.lblVerified setTextColor:[UIColor whiteColor]];
                           cell.lblLeftTitle.text = @"Year of manufacture";
                            cell.lblVerified.text=objSMVINVerificationXml.strMatchYear;
                        }
                            break;
                        case 8:
                        { [cell.lblVerified setTextColor:[UIColor whiteColor]];
                            cell.lblLeftTitle.text = @"Year 1st licensed";
                            cell.lblVerified.text=objSMVINVerificationXml.str1YearLicenced;
                        }
                            break;
                        case 9:
                        { [cell.lblVerified setTextColor:[UIColor whiteColor]];
                            cell.lblLeftTitle.text = @"Warranty reg year";
                            cell.lblVerified.text=objSMVINVerificationXml.strWarrantyYear;
                        }
                        break;
                        case 10:
                        {
                            cell.lblLeftTitle.text = @"Lic Expiry";
                            cell.lblVerified.text=objSMVINVerificationXml.strLicenceExpiry;
                        }
                            break;
                        default:
                            break;
                    }
                    
                    //cell.backgroundColor = [UIColor redColor];
                }
                else
                {
                    cell.heightConstraintForColumn.constant = 33;
                    cell.viewContainingColumn.hidden = NO;
                    cell.lblLeftTitle.text=@"Verification #";
                    cell.lblVerified.text=objSMVINVerificationXml.strHPINumber;
                    [cell.lblVerified setTextColor:[UIColor whiteColor]];
                }
                
                finalCell = cell;
                finalCell.backgroundColor = [UIColor blackColor];
                return finalCell;
            }
        }
        break;
       
        default:
        {
            SMVerifyVIN_ModelVariantCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier4];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.heightConstraintForColumn.constant = 0;
            cell.viewContainingColumn.hidden = YES;
            cell.viewContainingTwoLabels.hidden = YES;
            cell.lblDescription.hidden = YES;
            SMObjectVerificationDetailType *objVerficationtype = [objSMFullVerificationObjectXML.arrmFullVerification objectAtIndex:indexPath.section-kAddedSections];
            SMObjectVerificationDetailAttribute *objSMObjectVerificationDetailAttribute = [objVerficationtype.arrmType objectAtIndex:indexPath.row];
            cell.lblDetailFullVerification.backgroundColor = [UIColor blackColor];
            cell.lblDetailFullVerification.preferredMaxLayoutWidth = self.view.frame.size.width-16;
            [cell.lblDetailFullVerification setAttributedText:objSMObjectVerificationDetailAttribute.strFINAL];
            finalCell = cell;
            finalCell.backgroundColor = [UIColor blackColor];
            
//            if(indexPath.section == 2 || indexPath.section == 4)
//             {
//                 cell.viewContainingTwoLabels.hidden = YES;
//                 cell.lblDescription.hidden = NO;
//             }
//             else
//             {
//                  cell.viewContainingTwoLabels.hidden = NO;
//                  cell.lblDescription.hidden = YES;
//             }
            
            //cell.backgroundColor = [UIColor redColor];
           
            
            return finalCell;
         
        }
            break;
    }
    
    
    
    return nil;
}

#pragma mark - WEB Services


-(void) loadMake
{
    
    [arrmForCondition removeAllObjects];
    
    
     if([selectedYear length] == 0)
     {
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter  setDateFormat:@"yyyy"];
     NSString  *currentYear = [formatter stringFromDate:[NSDate date]];
     selectedYear = currentYear;
     }
    
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllMakevaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:selectedYear];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    // self.txtYear.text
   
    
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
             arrmForMake = [[NSMutableArray alloc ] init];
            xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             [self hideProgressHUD];
         }
     }];
    
}

-(void)loadModelsListing
{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllModelsvaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:selectedYear makeId:selectedMakeId];
    
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
             return;
         }
         else
         {
             
             arrmForModel = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
    
}

-(void)loadVarientsListing
{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllVarintsvaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:selectedYear modelId:selectedModelId];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    // __weak SMSynopsisVerifyVINViewController *blocksafeSelf = self;
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
             arrmForVariant = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)getTheSynopsisDetails
{
    
    NSMutableURLRequest *requestURL=[SMWebServices getSynopsisSummaryWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:self.strMainVehicleYear.intValue andMakeId:self.strSelectedMakeID andModelId:self.strSelectedModelID andVariantId:self.strSelectedVariantID andVIN:self.strSelectedVINNumber andKiloMeters:self.strSelectedKiloMeters andExtrasCost:self.strSelectedExtrasCost andCondition:self.strSelectedCondition];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSforSummaryDetails *wsSMWSforSummaryDetails = [[SMWSforSummaryDetails alloc]init];
    [wsSMWSforSummaryDetails responseForWebServiceForReuest:requestURL response:^(SMSynopsisXMLResultObject *objSMSynopsisXMLResultObject) {
        
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        [self hideProgressHUD];
        
        switch (objSMSynopsisXMLResultObject.iStatus) {
                
            case kWSCrash:
            {
                SMAlert(kTitle, KWSCrashMessage);
            }
                break;
            case kWSNoRecord:
            {
                SMAlert(kTitle, KNorecordsFousnt);
            }
                break;
            case kWSSuccess:
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    SMSynopsisSummaryViewController *vcSMSynopsisVehicleLookUpViewController = [[SMSynopsisSummaryViewController alloc] initWithNibName:@"SMSynopsisSummaryViewController" bundle:nil];
                    vcSMSynopsisVehicleLookUpViewController.objSMSynopsisResult = objSMSynopsisXMLResultObject;
                    [self.navigationController pushViewController:vcSMSynopsisVehicleLookUpViewController animated:NO];
                }
                else
                {
                    SMSynopsisSummaryViewController *vcSMSynopsisVehicleLookUpViewController = [[SMSynopsisSummaryViewController alloc] initWithNibName:@"SMSynopsisSummaryViewController" bundle:nil];
                    vcSMSynopsisVehicleLookUpViewController.objSMSynopsisResult = objSMSynopsisXMLResultObject;
                    [self.navigationController pushViewController:vcSMSynopsisVehicleLookUpViewController animated:NO];
                }
                
            }
                break;
                
            default:
                break;
        }
    } andError:^(NSError *error) {
        SMAlert(@"Error", error.localizedDescription);
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        [self hideProgressHUD];
        
    }];
    
    
    
}


-(void) getSynopsisByMMCode
{
    
    NSMutableURLRequest *requestURL  =[SMWebServices getSynopsisSummaryByMMCodeCodeWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:self.strMainVehicleYear.intValue andMMCode:self.strSelectedMMCode withKiloMeters:self.strSelectedKiloMeters andVIN:self.strSelectedVINNumber andExtrasCost:self.strSelectedExtrasCost andCondition:self.strSelectedCondition];
        
            
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
            [self addingProgressHUD];
            [HUD show:YES];
            HUD.labelText = KLoaderText;
            
            SMWSforSummaryDetails *wsSMWSforSummaryDetails = [[SMWSforSummaryDetails alloc]init];
            [wsSMWSforSummaryDetails responseForWebServiceForReuest:requestURL response:^(SMSynopsisXMLResultObject *objSMSynopsisXMLResultObject) {
                
                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                [self hideProgressHUD];
                
                switch (objSMSynopsisXMLResultObject.iStatus) {
                        
                    case kWSCrash:
                    {
                        SMAlert(kTitle, KWSCrashMessage);
                    }
                        break;
                    case kWSNoRecord:
                    {
                        SMAlert(kTitle, KNorecordsFousnt);
                    }
                        break;
                    case kWSSuccess:
                    {
                        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                        {
                            SMSynopsisSummaryViewController *vcSMSynopsisVehicleLookUpViewController = [[SMSynopsisSummaryViewController alloc] initWithNibName:@"SMSynopsisSummaryViewController" bundle:nil];
                            vcSMSynopsisVehicleLookUpViewController.objSMSynopsisResult = objSMSynopsisXMLResultObject;
                            
                            
                            [self.navigationController pushViewController:vcSMSynopsisVehicleLookUpViewController animated:NO];
                        }
                        else
                        {
                            SMSynopsisSummaryViewController *vcSMSynopsisVehicleLookUpViewController = [[SMSynopsisSummaryViewController alloc] initWithNibName:@"SMSynopsisSummaryViewController" bundle:nil];
                            vcSMSynopsisVehicleLookUpViewController.objSMSynopsisResult = objSMSynopsisXMLResultObject;
                            [self.navigationController pushViewController:vcSMSynopsisVehicleLookUpViewController animated:NO];
                        }
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            } andError:^(NSError *error) {
                SMAlert(@"Error", error.localizedDescription);
                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                [self hideProgressHUD];
                
            }];
            
        
   
}

#pragma mark - xml parser delegate
-(void) parser:(NSXMLParser  *)     parser
didStartElement:(NSString    *)     elementName
  namespaceURI:(NSString     *)     namespaceURI
 qualifiedName:(NSString     *)     qName
    attributes:(NSDictionary *)     attributeDict
{
    if ([elementName isEqualToString:@"ListMakesJSONResult"])
    {
        ObjectDropDownObject=[[SMDropDownObject alloc]init];
    }
    if ([elementName isEqualToString:@"ListModelsJSONResult"])
    {
        ObjectDropDownObject=[[SMDropDownObject alloc]init];
    }
    if ([elementName isEqualToString:@"ListVariantsJSONResult"])
    {
        loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
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
    currentNodeContent = (NSMutableString *) [currentNodeContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //get make data
    NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObject=[NSJSONSerialization
                              JSONObjectWithData:data
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    
    if ([elementName isEqualToString:@"ListMakesJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {//// this is for Data For PopUpView
                ObjectDropDownObject=[[SMDropDownObject alloc]init];
                ObjectDropDownObject.strMakeId   = dictionary[@"makeID"];
                ObjectDropDownObject.strMakeName = dictionary[@"makeName"];
                ObjectDropDownObject.strSortText = dictionary[@"makeName"];
                
                ObjectDropDownObject.strSortTextID = ((int)[arrmForMake count] + 1);
                [arrmForMake addObject:ObjectDropDownObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
        
    }
    
    //get model data
    
    if ([elementName isEqualToString:@"ListModelsJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                ObjectDropDownObject             =[[SMDropDownObject alloc]init];
                ObjectDropDownObject.strMakeId   =dictionary[@"modelID"];
                ObjectDropDownObject.strMakeName =dictionary[@"modelName"];
                [arrmForModel  addObject:ObjectDropDownObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
    }
    
    //get varient data
    if ([elementName isEqualToString:@"ListVariantsJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
                loadVehiclesObject.strMakeId            =dictionary[@"variantID"];
                loadVehiclesObject.strMakeName          =dictionary[@"variantName"];
                loadVehiclesObject.strMeanCodeNumber    =dictionary[@"meadCode"];
                loadVehiclesObject.strMaxYear           =dictionary[@"MaxDate"];
                loadVehiclesObject.strMinYear           = dictionary[@"MinDate"];
                [arrmForVariant          addObject:loadVehiclesObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
        
    }
    
    // end of xml parsing
    
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    // [tblSynopsisSummaryTableView reloadData];
    [self hideProgressHUD];
}

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
    [HUD hide:YES];
}


-(void) gettingAllYearsForPickerView
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    int year = (int)[components year];
    // [self.txtYear setText:[NSString stringWithFormat:@"%d",year]];
    for (int i=year; i>=1990; i--)
    {
        [arrmForYear addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}


#pragma mark - Text Field Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == txtVinNumber)
    {
        return [SMAttributeStringFormatObject valdateTextFeild:txtVinNumber shouldChangeCharactersInRange:range replacementString:string withValidationType:ACCEPTABLE_CHARACTERS andLimit:0];
    }
    if(textField == self.txtRegNo)
    {
        return [SMAttributeStringFormatObject valdateTextFeild:self.txtRegNo shouldChangeCharactersInRange:range replacementString:string withValidationType:ACCEPTABLE_CHARACTERS andLimit:0];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
        case 419: {
            
            [self.view endEditing:YES];
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            [popUpView getTheDropDownData:[SMAttributeStringFormatObject getYear] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:YES]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                selectedYear = selectedTextValue;
                
                textField.text = selectedTextValue;
                SMCustomTextFieldForDropDown *textField1 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:420];
                
                textField1.text=@"";
                SMCustomTextFieldForDropDown *textField2 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:421];
                
                textField2.text=@"";
                SMCustomTextFieldForDropDown *textField3 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:422];
                
                textField3.text=@"";
                
                [HUD show:YES];
                HUD.labelText = KLoaderText;
                [self loadMake];                //selectedMakeId = selectIDValue;
            }];
           
            
            /*************  your Response *******************************************************/
            
        }
            break;
            
        case 420:{
            
            
            
            [self.view endEditing:YES];
            [textField resignFirstResponder];
            /*************  your Request *******************************************************/
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:arrmForMake withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear)
            {
                NSLog(@"selected text = %@",selectedTextValue);
                selectedMakeId = selectIDValue;
                textField.text = selectedTextValue;
                SMCustomTextFieldForDropDown *textField1 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:421];
                
                textField1.text=@"";
                
                SMCustomTextFieldForDropDown *textField2 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:422];
                
                textField2.text=@"";
                
                
                [self loadModelsListing];
                //NSLog(@"selected ID = %d",selectIDValue);//1,3,5,7

                 // NSLog(@"arrayOfMake = %@",arrmForMake);
            }];
            
        }
            break;
            
        case 421:
        {
            
            [self.view endEditing:YES];
            [textField resignFirstResponder];
            /*************  your Request *******************************************************/
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:arrmForModel withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/
            
            
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear)
             {
                 NSLog(@"selected text = %@",selectedTextValue);
                 selectedModelId = selectIDValue;
                 textField.text = selectedTextValue;
                 SMCustomTextFieldForDropDown *textField1 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:422];
                 
                 textField1.text=@"";
                 [self loadVarientsListing];
                 
             }];
            
        }
            break;
            
        case 422:
        {
            [self.view endEditing:YES];
            [textField resignFirstResponder];
            /*************  your Request *******************************************************/
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:arrmForVariant withVariant:YES andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/
            
            
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear)
             {
                 NSLog(@"selected text = %@",selectedTextValue);
                 textField.text = selectedTextValue;
                 
                 
             }];

            
            
        }
            break;
            
        default:
            break;
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
}


-(void) registerNibFile
{
    
    // for table views
    
    
    [tblVerifyVIN registerNib:[UINib nibWithNibName:@"SMVerifyVIN_ModelVariantCell" bundle:nil] forCellReuseIdentifier:@"SMVerifyVIN_ModelVariantCell"];
    
    [tblVerifyVIN registerNib:[UINib nibWithNibName:@"SMVerifyVIN_ColumnCell" bundle:nil] forCellReuseIdentifier:@"SMVerifyVIN_ColumnCell"];
    
    [tblVerifyVIN registerNib:[UINib nibWithNibName:@"SMVerifyVIN_BottomCell" bundle:nil] forCellReuseIdentifier:@"SMVerifyVIN_BottomCell"];
    
    [tblVerifyVIN registerNib:[UINib nibWithNibName:@"FullVerificationCell" bundle:nil] forCellReuseIdentifier:@"FullVerificationCell"];

}


- (NSArray *)viewsInRow:(NSUInteger)row section:(NSUInteger)section
{
     return [[[tblVerifyVIN cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)row inSection:(NSInteger)section]]contentView]subviews];
}
- (UIView *)viewInRow:(NSUInteger)row section:(NSUInteger)section
{
    return [[[[tblVerifyVIN cellForRowAtIndexPath:
    [NSIndexPath indexPathForRow:(NSInteger)row inSection:(NSInteger)section]]
     contentView] subviews] objectAtIndex:0];
}

-(BOOL)validateBlankTextForButton:(int)tag{
   
    SMCustomTextFieldForDropDown *textField1 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:420];
    textField1.text=@"";
    SMCustomTextFieldForDropDown *textField2 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:421];
    textField2.text=@"";
    SMCustomTextFieldForDropDown *textField3 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:422];
    textField3.text=@"";

    if ([textField1.text isEqualToString:@""]) {
        SMAlert(@"Smart Manager", KMakeSelection);
        return NO;
    }
    else if ([textField2.text isEqualToString:@""]){
        SMAlert(@"Smart Manager", KModelSelection);
        return NO;
    }
    else if ([textField3.text isEqualToString:@""]){
        SMAlert(@"Smart Manager", KVariantSelection);
        return NO;
    }
    
    return YES;
}

#pragma mark - Button Methods

- (void)btnChangeModelVariantDidClicked:(UIButton*)sender
{
    isChangeModelVariantButtonExpanded = !isChangeModelVariantButtonExpanded;
    [tblVerifyVIN reloadData];
    SMCustomTextFieldForDropDown *textField1 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:419];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter  setDateFormat:@"yyyy"];
    selectedYear = [formatter stringFromDate:[NSDate date]];
    textField1.text = selectedYear;
    if(isChangeModelVariantButtonExpanded)
        [self loadMake];
    
    
}
- (void)btnClearDidClicked:(UIButton*)sender
{
   
    SMCustomTextFieldForDropDown *textField1 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:420];
    textField1.text=@"";
    SMCustomTextFieldForDropDown *textField2 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:421];
    textField2.text=@"";
    SMCustomTextFieldForDropDown *textField3 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:422];
    textField3.text=@"";
    
}

- (void)btnUpdateDidClicked:(UIButton*)sender
{
    if ([self validateBlankTextForButton:0]) {
        self.strMainVehicleYear = selectedYear;
        SMCustomTextFieldForDropDown *textField1 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:420];
        SMCustomTextFieldForDropDown *textField2 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:421];
        //SMCustomTextFieldForDropDown *textField3 = (SMCustomTextFieldForDropDown *)[self.view viewWithTag:422];
        self.lblMainVehicleName.text = [NSString stringWithFormat:@"%@ %@ %@",self.strMainVehicleYear,textField1.text,textField2.text];
        isYellowButtonClicked = NO;
        isBlueButtonClicked = NO;
        isFullVerificationButtonExpanded = NO;
        isVINVerificationButtonExpanded=NO;
        [tblVerifyVIN reloadData];
    }
    
}

- (IBAction)btnSectionTitleDidClicked:(id)sender
{
    
}

- (IBAction)btnFullVerificationDidClicked:(id)sender
{
    
    isFullVerificationButtonExpanded = !isFullVerificationButtonExpanded;
    if(isFullVerificationButtonExpanded)
    {
        [imgViewArrow2 setImage:[UIImage imageNamed:@"down_arrowSelected"]];
        
    }
    else
    {
        [imgViewArrow2 setImage:[UIImage imageNamed:@"down_arrowT"]];
    }
    [tblVerifyVIN reloadData];
    
}

- (IBAction)btnVINVerificationButtonDidClicked:(id)sender
{
    [txtVinNumber resignFirstResponder];
    [self.txtRegNo resignFirstResponder];
    
    isVINVerificationButtonExpanded = !isVINVerificationButtonExpanded;
    if(isVINVerificationButtonExpanded)
    {
        [imgViewArrow1 setImage:[UIImage imageNamed:@"down_arrowSelected"]];
    }
    else
    {
        [imgViewArrow1 setImage:[UIImage imageNamed:@"down_arrowT"]];
    }
    [tblVerifyVIN reloadData];
}

- (IBAction)btnBackToSummaryDidClicked:(id)sender
{
    if(self.previousPageNumber == 2)
        [self getTheSynopsisDetails];
    else
        [self getSynopsisByMMCode];
}

- (IBAction)btnBlueVerifyVinDidClicked:(id)sender
{
    
    if (txtVinNumber.text.length==0 || [txtVinNumber.text isEqualToString:@"No VIN loaded"]) {
        SMAlert(kTitle,kVINNoSelection);
    }else{
        
        UIAlertController *altForgetPassword = [UIAlertController
                                                alertControllerWithTitle:kTitle
                                                message:kAlertUpdatePricing
                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [altForgetPassword addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        
        [altForgetPassword addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
             [self getVINVerificationDetails];
            
        }]];
           [self presentViewController:altForgetPassword animated:YES completion:nil];
    }
    
}

- (IBAction)btnYellowFullVerificationDidClicked:(id)sender
{
    if (txtVinNumber.text.length==0 || [txtVinNumber.text isEqualToString:@"No VIN loaded"]) {
        SMAlert(kTitle,kVINNoSelection);
    }else{
        UIAlertController *altForgetPassword = [UIAlertController
                                                alertControllerWithTitle:kTitle
                                                message:kAlertUpdatePricing
                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [altForgetPassword addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        
        [altForgetPassword addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self getFullVerificationDetails];
        }]];
        [self presentViewController:altForgetPassword animated:YES completion:nil];
    }
}

- (NSArray *)textFieldInRow:(NSUInteger)row section:(NSUInteger)section
{
    //return [[[[tblSynopsisSummaryTableView cellForRowAtIndexPath:
    //[NSIndexPath indexPathForRow:(NSInteger)row inSection:(NSInteger)section]]
    // contentView] subviews] objectAtIndex:0];
    
    return [[[tblVerifyVIN cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)row inSection:(NSInteger)section]]contentView]subviews];
}



#pragma mark - Web Services
-(void) getFullVerificationDetails{
    
   
    NSMutableURLRequest *requestURL=[SMWebServices loadFullVerificationDetails:[SMGlobalClass sharedInstance].hashValue andVINNum:txtVinNumber.text andYear:self.strMainVehicleYear andRegNumber:self.txtRegNo.text andMMCode:self.strSelectedMMCode andMileage:self.strSelectedKiloMeters];
    
    objSMFullVerificationObjectXML  = [[SMFullVerificationObjectXML alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSFullVerification *wsFullVerifications = [[SMWSFullVerification alloc]init];
    
    [wsFullVerifications responseForWebServiceForReuest:requestURL
                                             response:^(SMFullVerificationObjectXML *objSMFullVerificationObjectXMLResult) {
                                                 
                                                 [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                 [self hideProgressHUD];
                                                 
                                                 switch (objSMFullVerificationObjectXMLResult.iStatus) {
                                                         
                                                     case kWSCrash:
                                                     {
                                                         [SMAttributeStringFormatObject showAlertWebServicewithMessage:KWSCrashMessage ForViewController:self];
                                                     }
                                                         break;
                                                         
                                                     case kWSNoRecord:
                                                     {
                                                         [SMAttributeStringFormatObject showAlertWebServicewithMessage:KNorecordsFousnt ForViewController:self];
                                                     }
                                                         break;
                                                         
                                                     case kWSSuccess:
                                                     {
                                                         objSMFullVerificationObjectXML = objSMFullVerificationObjectXMLResult;
                                                         isYellowButtonClicked = YES;
                                                         switch (objSMFullVerificationObjectXMLResult.objSMVINVerificationXml.iStatus) {
                                                             case kWSError:
                                                             {
                                                                 SMAlert(kTitle,objSMFullVerificationObjectXMLResult.objSMVINVerificationXml.strResultCodeDescription);
                                                             }
                                                             break;
                                                             default:{
                                                                 isBlueButtonClicked = YES;
                                                                 objSMVINVerificationXml = objSMFullVerificationObjectXMLResult.objSMVINVerificationXml;
                                                             }
                                                                 break;
                                                         }
                                                         
                                                         //[self getVINVerificationDetails];
                                                         [tblVerifyVIN reloadData];
                                                     }
                                                         break;
                                                         
                                                     default:
                                                         break;
                                                 }
                                            }
                                             andError:^(NSError *error) {
                                                 
                                                 SMAlert(@"Error", error.localizedDescription);
                                                 [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                 [self hideProgressHUD];
                                             }
     ];
    
}


-(void) getVINVerificationDetails{
    
    
    NSMutableURLRequest *requestURL=[SMWebServices loadVINVerificationDetails:[SMGlobalClass sharedInstance].hashValue andVINNum:txtVinNumber.text andYear:self.strMainVehicleYear andRegNumber:self.txtRegNo.text andMMCode:self.strSelectedMMCode andMileage:self.strSelectedKiloMeters];
    objSMVINVerificationXml  = [[SMVINVerificationXml alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSVINVerification *wsFullVerifications = [[SMWSVINVerification alloc]init];
    
    [wsFullVerifications responseForWebServiceForReuest:requestURL
                                               response:^(SMVINVerificationXml *objSMVINVerificationXmlResult) {
                                                   
                                                   [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                   [self hideProgressHUD];
                                                   
                                                   switch (objSMVINVerificationXmlResult.iStatus) {
                                                           
                                                       case kWSCrash:
                                                       {
                                                            //[SMAttributeStringFormatObject showAlertWebServicewithMessage:KWSCrashMessage ForViewController:self];
                                                            SMAlert(kTitle,KWSCrashMessage);
                                                       }
                                                           break;
                                                           
                                                       case kWSNoRecord:
                                                       {
                                                          // [SMAttributeStringFormatObject showAlertWebServicewithMessage:KNorecordsFousnt ForViewController:self];
                                                            SMAlert(kTitle,KNorecordsFousnt);
                                                       }
                                                           break;
                                                           
                                                       case kWSSuccess:
                                                       {
                                                           objSMVINVerificationXml = objSMVINVerificationXmlResult;
                                                           isBlueButtonClicked = YES;
                                                           [tblVerifyVIN reloadData];
                                                       }
                                                           break;
                                                         
                                                       case kWSError:
                                                       {
                                                           SMAlert(kTitle,objSMVINVerificationXmlResult.strResultCodeDescription);
                                                       }
                                                           break;
                                                       default:
                                                           break;
                                                   }
                                                   
                                                   
                                               }
                                               andError:^(NSError *error) {
                                                   
                                                   SMAlert(@"Error", error.localizedDescription);
                                                   [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                   [self hideProgressHUD];
                                               }
     ];
    
}




@end
