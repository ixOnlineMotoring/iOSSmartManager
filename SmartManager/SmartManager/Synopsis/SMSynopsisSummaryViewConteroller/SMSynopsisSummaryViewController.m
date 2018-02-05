//
//  SMSynopsisSummaryViewController.m
//  Smart Manager
//
//  Created by Sandeep on 19/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMSynopsisSummaryViewController.h"
#import "SMCustomColor.h"
#import "SMChangeVehicleViewCell.h"
#import "SMExtraSelectedVehicleCell.h"
#import "SMCustomPopUpTableView.h"
#import "SMDropDownObject.h"
#import "SMCustomPopUpPickerView.h"
#import "SMSynopsisDoAppraisalViewController.h"
#import "SMLeadPoolViewController.h"
#import "SMOEMSpecsViewController.h"
#import "SMReviewsViewController.h"
#import "SMAvailabilityViewController.h"
#import "SMVINHistoryViewController.h"
#import "SMLoadVehiclesObject.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMSynopsisDemandViewController.h"
#import "SMSynopsisAverageDaysViewController.h"
#import "SMSynopsisSimilarVehiclesViewController.h"
#import "SMSalesHistoryViewController.h"
#import "SMSynopsisVerifyVINViewController.h"
#import "SMSynopsisNewPricePlotterViewController.h"
#import "SMPricing_ValuationViewController.h"

#import "UIImage+Resize.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "SMSummaryObject.h"
#import "SMSynopsisSummary2Cell.h"
#import "FGalleryViewController.h"
#import "SMAppDelegate.h"
#import "SMWSforSummaryDetails.h"
#import "SMReviewTitleViewCell.h"
#import "SMWSSimilarVehicle.h"
#import "SMCustomerDLScanViewController.h"
#import "SMReusableSearchTableViewController.h"


@interface SMSynopsisSummaryViewController ()<FGalleryViewControllerDelegate>
{
    MBProgressHUD *HUD;
    
    NSArray *arrConditionData;
    NSMutableArray *arrmForYear;
    NSMutableArray *arrmForMake;
    NSMutableArray *arrmForModel;
    NSMutableArray *arrmForVariant;
    NSMutableArray *arrmForCondition;
    
    SMDropDownObject *ObjectDropDownObject;
    SMLoadVehiclesObject        *loadVehiclesObject;
    
    SMSynopsisXMLResultObject *objUpdateSMSynopsisResult;
    SMSimilarVehicleXmlObject *objSimilarVehiclesBject;
    SMSummaryObject *objUpdateSMSummeryObject;
    FGalleryViewController *networkGallery;
    NSString *strDemandSummary;
    NSAttributedString *strDemandSummaryAttribut;
    NSString *strAverageAvailableSummary;
    NSString *strAverageDaysInStockSummary;
    NSString *strLeadPoolSummary;
    NSString *strPrefixToRemove;
    NSString *strVINForDoAppraisal;
    BOOL isbtnFetchPricingDidClicked;
    // NSString *strWarrantySummary;
    float xAxisCount;
    SMReusableSearchTableViewController *searchMakeVC;
    NSArray *arrLoadNib;
    NSIndexPath *selectedIndexpathForVIN;
}
@end

@implementation SMSynopsisSummaryViewController

@synthesize selectedYear;
@synthesize selectedMake;
@synthesize selectedModel;
@synthesize selectedVariant;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addingProgressHUD];
    isChangeVechileExpand = NO;
    isYearYoungerSectionExpanded = NO;
    isOtherModelsSectionExpanded = NO;
    isYearOlderSectionExpanded = NO;
    isManualSelectionSectionExpanded = NO;
    isExtraSelectedVechileExpand = YES;
    isVehicleChanged = NO;
    vehicleImageUrl = @"";
    arrmTemp = [[NSMutableArray alloc ] init];
    strPrefixToRemove = @"| ";
    // liji..
    
    // Sections initialization
   
    NSArray *arraySMTableSectionView1 = [[NSBundle mainBundle]loadNibNamed:@"SMTableSectionView" owner:self options:nil];
    
    section0View = [arraySMTableSectionView1 objectAtIndex:0];
    [section0View.sectionButton setTitle:@"Change Vehicle" forState:UIControlStateNormal];
    section0View.sectionButton.tag = 10;
    
    [section0View.sectionButton addTarget:self action:@selector(expandTableSectionDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *arraySMTableSectionView3 = [[NSBundle mainBundle]loadNibNamed:@"SMTableSectionView" owner:self options:nil];
    sectionYearYoungerView = [arraySMTableSectionView3 objectAtIndex:0];
    [sectionYearYoungerView.sectionButton setTitle:@"A year younger" forState:UIControlStateNormal];
    sectionYearYoungerView.sectionButton.tag = 30;
    [sectionYearYoungerView.sectionButton addTarget:self action:@selector(expandTableSectionDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblCountYearYounger = [[UILabel alloc]initWithFrame:CGRectMake(sectionYearYoungerView.frame.size.width-sectionYearYoungerView.imgArrowDown.frame.size.width-10-35,5, 20, 20)];
    
    lblCountYearYounger.textColor = [UIColor whiteColor];
    lblCountYearYounger.textAlignment = NSTextAlignmentCenter;
    lblCountYearYounger.layer.borderColor = [UIColor whiteColor].CGColor;
    lblCountYearYounger.layer.borderWidth = 1.0;
    lblCountYearYounger.layer.masksToBounds = YES;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        lblCountYearYounger.font = [UIFont fontWithName:FONT_NAME size:15.0f];
        
        lblCountYearYounger.frame = CGRectMake(sectionYearYoungerView.frame.size.width-sectionYearYoungerView.imgArrowDown.frame.size.width-15-lblCountYearYounger.frame.size.width,8, lblCountYearYounger.frame.size.width, 20);
        
    }
    else
    {
        lblCountYearYounger.font = [UIFont fontWithName:FONT_NAME size:17.0f];
        
         lblCountYearYounger.frame = CGRectMake(sectionYearYoungerView.frame.size.width-sectionYearYoungerView.imgArrowDown.frame.size.width-10-lblCountYearYounger.frame.size.width-12,10, lblCountYearYounger.frame.size.width, 20);
        
    }
    
    lblCountYearYounger.layer.cornerRadius = lblCountYearYounger.frame.size.width/2;

    [sectionYearYoungerView addSubview:lblCountYearYounger];
    
    sectionYearYoungerView.sectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    sectionYearYoungerView.sectionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 2, 0);
    
    
    
    
    NSArray *arraySMTableSectionView4 = [[NSBundle mainBundle]loadNibNamed:@"SMTableSectionView" owner:self options:nil];
    sectionOtherModelsView = [arraySMTableSectionView4 objectAtIndex:0];
    [sectionOtherModelsView.sectionButton setTitle:@"Other models of the same year" forState:UIControlStateNormal];
    sectionOtherModelsView.sectionButton.tag = 40;
    [sectionOtherModelsView.sectionButton addTarget:self action:@selector(expandTableSectionDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblCountOtherModels = [[UILabel alloc]initWithFrame:CGRectMake(sectionOtherModelsView.frame.size.width-sectionOtherModelsView.imgArrowDown.frame.size.width-10-35,5, 20, 20)];
    
    lblCountOtherModels.textColor = [UIColor whiteColor];
    lblCountOtherModels.textAlignment = NSTextAlignmentCenter;
    lblCountOtherModels.layer.borderColor = [UIColor whiteColor].CGColor;
    lblCountOtherModels.layer.borderWidth = 1.0;
    lblCountOtherModels.layer.masksToBounds = YES;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        lblCountOtherModels.font = [UIFont fontWithName:FONT_NAME size:15.0f];
        
        lblCountOtherModels.frame = CGRectMake(sectionOtherModelsView.frame.size.width-sectionOtherModelsView.imgArrowDown.frame.size.width-15-lblCountOtherModels.frame.size.width,8, lblCountOtherModels.frame.size.width, 20);
        
    }
    else
    {
        lblCountOtherModels.font = [UIFont fontWithName:FONT_NAME size:17.0f];
        
        lblCountOtherModels.frame = CGRectMake(sectionOtherModelsView.frame.size.width-sectionOtherModelsView.imgArrowDown.frame.size.width-10-lblCountOtherModels.frame.size.width-12,10, lblCountOtherModels.frame.size.width, 20);
        
    }
    
    lblCountOtherModels.layer.cornerRadius = lblCountOtherModels.frame.size.width/2;
    
    [sectionOtherModelsView addSubview:lblCountOtherModels];
    
    sectionOtherModelsView.sectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    sectionOtherModelsView.sectionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 2, 0);
    
    
    
    NSArray *arraySMTableSectionView5 = [[NSBundle mainBundle]loadNibNamed:@"SMTableSectionView" owner:self options:nil];
    sectionYearOlderView = [arraySMTableSectionView5 objectAtIndex:0];
    [sectionYearOlderView.sectionButton setTitle:@"A year older" forState:UIControlStateNormal];
    sectionYearOlderView.sectionButton.tag = 50;
    
    [sectionYearOlderView.sectionButton addTarget:self action:@selector(expandTableSectionDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    lblCountYearOlder = [[UILabel alloc]initWithFrame:CGRectMake(sectionYearOlderView.frame.size.width-sectionYearOlderView.imgArrowDown.frame.size.width-10-35,5, 20, 20)];
    
    lblCountYearOlder.textColor = [UIColor whiteColor];
    lblCountYearOlder.textAlignment = NSTextAlignmentCenter;
    lblCountYearOlder.layer.borderColor = [UIColor whiteColor].CGColor;
    lblCountYearOlder.layer.borderWidth = 1.0;
    lblCountYearOlder.layer.masksToBounds = YES;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        lblCountYearOlder.font = [UIFont fontWithName:FONT_NAME size:15.0f];
        
        lblCountYearOlder.frame = CGRectMake(sectionYearOlderView.frame.size.width-sectionYearOlderView.imgArrowDown.frame.size.width-15-lblCountYearOlder.frame.size.width,8, lblCountYearOlder.frame.size.width, 20);
        
    }
    else
    {
        lblCountYearOlder.font = [UIFont fontWithName:FONT_NAME size:17.0f];
        
        lblCountYearOlder.frame = CGRectMake(sectionYearOlderView.frame.size.width-sectionYearOlderView.imgArrowDown.frame.size.width-10-lblCountYearOlder.frame.size.width-12,10, lblCountYearOlder.frame.size.width, 20);
        
    }
    
    lblCountYearOlder.layer.cornerRadius = lblCountYearOlder.frame.size.width/2;
   
    
    [sectionYearOlderView addSubview:lblCountYearOlder];
    
    sectionYearOlderView.sectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    sectionYearOlderView.sectionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 2, 0);
    
    NSArray *arraySMTableSectionView6 = [[NSBundle mainBundle]loadNibNamed:@"SMTableSectionView" owner:self options:nil];
    sectionManualSelectionView = [arraySMTableSectionView6 objectAtIndex:0];
    [sectionManualSelectionView.sectionButton setTitle:@"Manual selection" forState:UIControlStateNormal];
    sectionManualSelectionView.sectionButton.tag = 60;
    
    [sectionManualSelectionView.sectionButton addTarget:self action:@selector(expandTableSectionDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    sectionManualSelectionView.sectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    sectionManualSelectionView.sectionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 2, 0);

    
    NSLog(@"%@",self.objSMSynopsisResult);
    NSDateFormatter *formatter       = [[NSDateFormatter alloc] init];
    [formatter         setDateFormat:@"yyyy"];
    selectedYear     = [formatter stringFromDate:[NSDate date]];
    
    
    NSMutableString *teststring = [[NSMutableString alloc]init];
    NSString *newString;
    for (SMSummaryObject *objSMSummeryObject in self.objSMSynopsisResult.arrmDemandSummary) {
        
        [teststring appendString:[NSString stringWithFormat:@"%@ : %d |",objSMSummeryObject.strArea,objSMSummeryObject.intValue]];
        [teststring appendString:@" "];
        NSLog(@"%@",teststring);
        
    }
    
    if ([teststring hasSuffix:strPrefixToRemove]){
        newString  = [teststring substringToIndex:[teststring length] - strPrefixToRemove.length];
    }else{
        newString = teststring;
    }
    strDemandSummary = newString;
    
    NSMutableString *teststring1 = [[NSMutableString alloc]init];
    
    
    for (SMSummaryObject *objSMSummeryObject in self.objSMSynopsisResult.arrmAverageAvailableSummary) {
        
        [teststring1 appendString:[NSString stringWithFormat:@"%@ : %d |",objSMSummeryObject.strArea,objSMSummeryObject.intValue]];
        [teststring1 appendString:@" "];
        
        NSLog(@"%@",teststring1);
    }
   
    if ([teststring1 hasSuffix:strPrefixToRemove]){
        newString  = [teststring1 substringToIndex:[teststring1 length] - strPrefixToRemove.length];

    }else{
        newString = teststring1;
    }
    strAverageAvailableSummary = newString;

    NSMutableString *teststring2 = [[NSMutableString alloc]init];
    for (SMSummaryObject *objSMSummeryObject in self.objSMSynopsisResult.arrmAverageDaysInStockSummary) {
        
        [teststring2 appendString:[NSString stringWithFormat:@"%@ : %d |",objSMSummeryObject.strArea,objSMSummeryObject.intValue]];
        [teststring2 appendString:@" "];
        
        
    }
    
    NSLog(@"%@",teststring2);
    if ([teststring2 hasSuffix:strPrefixToRemove]){
        newString  = [teststring2 substringToIndex:[teststring2 length] - strPrefixToRemove.length];

    }else{
        newString = teststring2;
    }
    
    strAverageDaysInStockSummary = newString;
    NSMutableString *teststring3 = [[NSMutableString alloc]init];
    for (SMSummaryObject *objSMSummeryObject in self.objSMSynopsisResult.arrmLeadPoolSummary)
    {
        if(self.objSMSynopsisResult.arrmLeadPoolSummary.count == 0)
            strLeadPoolSummary = @"N/A";
        else
        {
        [teststring3 appendString:[NSString stringWithFormat:@"%@ : %d |",objSMSummeryObject.strArea,objSMSummeryObject.intValue]];
        [teststring3 appendString:@" "];
        
        NSLog(@"%@",teststring3);
          
        }
    }
    
    if ([teststring3 hasSuffix:strPrefixToRemove]){
        newString  = [teststring3 substringToIndex:[teststring3 length] - strPrefixToRemove.length];
    }else{
        newString = teststring3;
    }
    
    strLeadPoolSummary = newString;
    
    NSArray *arraySMTableSectionView2 = [[NSBundle mainBundle]loadNibNamed:@"SMTableSectionView" owner:self options:nil];
    section2View = [arraySMTableSectionView2 objectAtIndex:0];
    //section2View.imgArrowDown.transform = CGAffineTransformMakeRotation(M_PI_2);
    [section2View.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowSelected"]];
    [section2View.sectionButton setTitle:@"Extra Info on Selected Vehicle" forState:UIControlStateNormal];
    section2View.sectionButton.tag = 20;
    [section2View.sectionButton addTarget:self action:@selector(expandTableSectionDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [tblSynopsisSummaryTableView registerNib:[UINib nibWithNibName: @"SMSynopsisSummaryCell" bundle:nil] forCellReuseIdentifier:@"SMSynopsisSummaryCell"];
    
    [tblSynopsisSummaryTableView registerNib:[UINib nibWithNibName: @"SMSynopsisSummary2Cell" bundle:nil] forCellReuseIdentifier:@"SMSynopsisSummary2Cell"];
    
    [tblSynopsisSummaryTableView registerNib:[UINib nibWithNibName: @"SMChangeVehicleViewCell" bundle:nil] forCellReuseIdentifier:@"SMChangeVehicleViewCell"];
    
    [tblSynopsisSummaryTableView registerNib:[UINib nibWithNibName: @"SMExtraSelectedVehicleCell" bundle:nil] forCellReuseIdentifier:@"SMExtraSelectedVehicleCell"];
    
    [tblSynopsisSummaryTableView registerNib:[UINib nibWithNibName: @"SMReviewTitleViewCell" bundle:nil] forCellReuseIdentifier:@"SMReviewTitleViewCell"];

    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [tblSynopsisSummaryTableView registerNib:[UINib nibWithNibName: @"SMWarrantyServiceCell" bundle:nil] forCellReuseIdentifier:@"SMWarrantyServiceCell"];
    }
    else
    {
         [tblSynopsisSummaryTableView registerNib:[UINib nibWithNibName: @"SMWarrantyServiceCell_ipad" bundle:nil] forCellReuseIdentifier:@"SMWarrantyServiceCell"];
    }
    
    [tblSynopsisSummaryTableView registerNib:[UINib nibWithNibName: @"SMSMSynopsisTableHeaderCell" bundle:nil] forCellReuseIdentifier:@"SMSMSynopsisTableHeaderCell"];
    
    
    //    NSArray *arraySMSynopsisTableHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SMSynopsisTableHeaderView" owner:self options:nil];
    //    SMSynopsisTableHeaderView *tableHeaderView = [arraySMSynopsisTableHeaderView objectAtIndex:0];
    //tblSynopsisSummaryTableView.tableHeaderView = tableHeaderView;
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Summary"];
    
    tblSynopsisSummaryTableView.estimatedRowHeight = 127.0;
    tblSynopsisSummaryTableView.rowHeight = UITableViewAutomaticDimension;
    tblSynopsisSummaryTableView.tableFooterView = [[UIView alloc]init];
    
    arrmForMake = [[NSMutableArray alloc ] init];
    arrmForModel = [[NSMutableArray alloc ] init];
    arrmForVariant = [[NSMutableArray alloc ] init];
    
    arrmForYear = [[NSMutableArray alloc] init];
    [self gettingAllYearsForPickerView];
    arrmForCondition = [[NSMutableArray alloc ] init];
    arrConditionData   = [NSArray arrayWithObjects:@"Excellent",@"Very Good",@"Good",@"Poor",@"Very Poor", nil];
    // [self getConditionDropDown];
    isbtnFetchPricingDidClicked = NO;

    //   [self getTheSynopsisDetails];
    
    
    [self getSimilarVehicles];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheVINNumberForDoAppraisal:) name:@"postNotificationForVINNumber" object:nil];
    
    arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMReusableSearchTableViewController" owner:self options:nil];
    searchMakeVC = [arrLoadNib objectAtIndex:0];
    
    [self webserviceIsGivenVINVerified];

}

-(void)viewWillAppear:(BOOL)animated{
     xAxisCount = self.view.frame.size.width - 65.0f;
    [super viewWillAppear:animated];
    
}

-(void)getTheVINNumberForDoAppraisal:(NSNotification *) notification
{
    strVINForDoAppraisal = [notification object];
    self.objSMSynopsisResult.strVINNo = strVINForDoAppraisal;

    NSLog(@"VINForDoAppraisal = %@",strVINForDoAppraisal);
    [self.navigationController popViewControllerAnimated:YES];
    
    if(selectedIndexpathForVIN.section == 2 && selectedIndexpathForVIN.row == 3)
    {
        SMSynopsisDoAppraisalViewController *synopsisDoAppraisalViewController;
        
        synopsisDoAppraisalViewController = [[SMSynopsisDoAppraisalViewController alloc] initWithNibName:@"SMSynopsisDoAppraisalViewController" bundle:nil];
        synopsisDoAppraisalViewController.objSMSynopsisResult = self.objSMSynopsisResult;
        
        [self.navigationController pushViewController:synopsisDoAppraisalViewController animated:YES];
    }
    else if (selectedIndexpathForVIN.section == 2 && selectedIndexpathForVIN.row == 2)
    {
        
        SMVINHistoryViewController *synopsisVINHistoryViewController;
        
        synopsisVINHistoryViewController = [[SMVINHistoryViewController alloc] initWithNibName:@"SMVINHistoryViewController" bundle:nil];
        synopsisVINHistoryViewController.strVehicleName =self.objSMSynopsisResult.strFriendlyName;
        synopsisVINHistoryViewController.strYear=[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear];
        synopsisVINHistoryViewController.strVINNo = self.objSMSynopsisResult.strVINNo;
        [self.navigationController pushViewController:synopsisVINHistoryViewController animated:YES];
    
    }
   // [self loadAppraisalInfoWithVIN:strVINForDoAppraisal];
}


-(void) getConditionDropDown{
    
    
    for(int i=0;i<5;i++)
    {
        SMDropDownObject *objCondition = [[SMDropDownObject alloc] init];
        objCondition.strSortTextID = i+1;
        objCondition.strSortText = [arrConditionData objectAtIndex:i];
        [arrmForCondition addObject:objCondition];
    }
    
}
-(void)nextButtonDidClicked{
    
    SMSaveAppraisalsViewController *obj = [[SMSaveAppraisalsViewController alloc]initWithNibName:@"SMSaveAppraisalsViewController" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

-(IBAction)expandTableSectionDidClicked:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    switch (button.tag) {
        case 10:
        {
            isChangeVechileExpand = !isChangeVechileExpand;
            
            if (isChangeVechileExpand) {
                
                [section0View.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowSelected"]];
                
            }
            else{
                [ section0View.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowT"]];
            }
        }
            break;
        case 20:
        {
            isExtraSelectedVechileExpand = !isExtraSelectedVechileExpand;
            
            if (isExtraSelectedVechileExpand) {
                [section2View.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowSelected"]];
                
            }
            else{
                [ section2View.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowT"]];
            }
        }
        break;
        case 30:
        {
            isYearYoungerSectionExpanded = !isYearYoungerSectionExpanded;
            
            if (isYearYoungerSectionExpanded) {
                [sectionYearYoungerView.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowSelected"]];
                
            }
            else{
                [ sectionYearYoungerView.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowT"]];
            }
        }
            break;

        case 40:
        {
            isOtherModelsSectionExpanded = !isOtherModelsSectionExpanded;
            
            if (isOtherModelsSectionExpanded) {
                [sectionOtherModelsView.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowSelected"]];
                
            }
            else{
                [ sectionOtherModelsView.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowT"]];
            }
        }
            break;

        case 50:
        {
            isYearOlderSectionExpanded = !isYearOlderSectionExpanded;
            
            if (isYearOlderSectionExpanded) {
                [sectionYearOlderView.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowSelected"]];
                
            }
            else{
                [ sectionYearOlderView.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowT"]];
            }
        }
        break;
        case 60:
        {
            isManualSelectionSectionExpanded = !isManualSelectionSectionExpanded;
            
            if (isManualSelectionSectionExpanded) {
                [sectionManualSelectionView.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowSelected"]];
                
            }
            else{
                [ sectionManualSelectionView.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowT"]];
            }
        }
            break;
            
        default:
            break;
    }
    [tblSynopsisSummaryTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (isChangeVechileExpand)
        return 8;
    else
        return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(!isChangeVechileExpand)
    {
        
        switch (section) {
            case 0:{
                return 1;
            }
                break;
            case 1:
            {
                return 0;
            }
                break;
            case 2:{
                return 4;
            }
                break;
            case 3:{
                if (isExtraSelectedVechileExpand) {
                    return 9;
                }
                return 0;
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (section) {
            case 0:
            {
                return 1;
            }
                break;
                
            case 1: // change vehicle
            {
                if (isChangeVechileExpand) {
                    return 1;
                }
                return 0;
            }
                break;
            case 2: // year younger section
            {
                if (isYearYoungerSectionExpanded)
                    return objSimilarVehiclesBject.arrOfYearYoungerVehicles.count;
                return 0;
            }
                break;
            case 3: // other models section
            {
                if (isOtherModelsSectionExpanded)
                    return objSimilarVehiclesBject.arrOfOtherModelVehicles.count;
                return 0;
            }
                break;
            case 4: // year older section
            {
                if (isYearOlderSectionExpanded) {
                    return objSimilarVehiclesBject.arrOfYearOlderVehicles.count;
                }
                return 0;
            }
                break;
            case 5: // Manual selection section
            {
                if (isManualSelectionSectionExpanded) {
                    return 1;
                }
                return 0;
            }
                break;
                
            case 6:{ // pricing section
                return 4;
            }
                break;
                
            case 7:{
                if (isExtraSelectedVechileExpand) {
                    return 9;
                }
                return 0;
            }
                break;
            default:
                break;
        }
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(!isChangeVechileExpand)
    {
        switch (section) {
                
            case 1:{
                return section0View;
            }
                break;
                
            case 3:{
                return section2View;
            }
                break;
            default:
                break;
                
        }
    }
    else
    {
        switch (section) {
                
            case 1:{
                return section0View;
            }
                break;
            case 2:{
                return sectionYearYoungerView;
            }
                break;
            case 3:{
                return sectionOtherModelsView;
            }
                break;
                
            case 4:{
                return sectionYearOlderView;
            }
                break;
            case 5:{
                return sectionManualSelectionView;
            }
                break;
            case 7:{
                return section2View;
            }
                break;
            default:
                break;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(!isChangeVechileExpand)
    {
        switch (section) {
                
            case 1:{
                return section0View.frame.size.height;
            }
                break;
                
            case 3:{
                return section2View.frame.size.height;
            }
                break;
            default:
                break;
                
        }
    }
    else
    {
        switch (section) {
                
            case 1:{
                return section0View.frame.size.height;
            }
                break;
            case 2:{
                return sectionYearYoungerView.frame.size.height;
            }
                break;
            case 3:{
                return sectionOtherModelsView.frame.size.height;
            }
                break;
                
            case 4:{
                return sectionYearOlderView.frame.size.height;
            }
                break;
            case 5:{
                return sectionManualSelectionView.frame.size.height;
            }
                break;
            case 7:{
                return section2View.frame.size.height;
            }
                break;
            default:
                break;
        }
    }
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(!isChangeVechileExpand)
    {
        switch (indexPath.section) {
            case 0:{
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
                    
                    return UITableViewAutomaticDimension;
                }else{
                    return UITableViewAutomaticDimension;
                }
            }
                break;
            case 1:{
                return 226.0f;
            }
                break;
            case 2:{
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
                    
                    if (indexPath.row == 0) {
                        if (isbtnFetchPricingDidClicked) {
                            return 174.0f;
                        }
                        else{
                            return 152.0f;
                        }
                    }
                    return 33.0f;
                }
                else
                {
                    if (indexPath.row == 0) {
                        if (isbtnFetchPricingDidClicked) {
                            return 174.0f;
                        }
                        else{
                            return 152.0f;
                        }
                    }
                    return 45.0f;
                }
            
            }
            break;
            case 3:{
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
                    
                    if (indexPath.row == 5) {
                        return UITableViewAutomaticDimension;
                    }else if (indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8)
                    {
                        return 33.0f;
                    }
                    return UITableViewAutomaticDimension;
                }
                else
                {
                    
                    if (indexPath.row == 5) {
                        return 132.0f;
                    }else if (indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8)
                    {
                        return 52.0f;
                    }
                    return UITableViewAutomaticDimension;
                }
            }
                break;
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.section) {
            case 0:{
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
                    
                    return UITableViewAutomaticDimension;
                }else{
                    return UITableViewAutomaticDimension;
                }
            }
                break;
            case 1:{
                if(isChangeVechileExpand)
                return 30.0f;
                return 0.0f;
            }
                break;
            case 2:{
                
                if(isYearYoungerSectionExpanded)
                    return UITableViewAutomaticDimension;
                return 0.0f;
            }
                break;
            case 3:{
                
                if(isOtherModelsSectionExpanded)
                    return UITableViewAutomaticDimension;
                return 0.0f;
            }
                break;
                
            case 4:
            {
                if(isYearOlderSectionExpanded)
                    return UITableViewAutomaticDimension;
                return 0.0f;
            }
                break;
            case 5:
            {
                return 226.0;
            }
                break;
            case 6:
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
                    
                    if (indexPath.row == 0) {
                        if (isbtnFetchPricingDidClicked) {
                            return 174.0f;
                        }
                        else{
                            return 152.0f;
                        }
                    }
                    return 33.0f;
                }
                else
                {
                    if (indexPath.row == 0) {
                        if (isbtnFetchPricingDidClicked) {
                            return 174.0f;
                        }
                        else{
                            return 152.0f;
                        }
                    }
                    return 45.0f;
                }
                
            }
                break;
            case 7:
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
                    
                    if (indexPath.row == 5) {
                        return 86.0f;
                    }else if (indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8)
                    {
                        return 33.0f;
                    }
                    return UITableViewAutomaticDimension;
                }
                else
                {
                    
                    if (indexPath.row == 5) {
                        return 132.0f;
                    }else if (indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8)
                    {
                        return 52.0f;
                    }
                    return UITableViewAutomaticDimension;
                }
            }
                break;
                
                
            default:
                break;
        }
    }
    return  0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!isChangeVechileExpand)
    {
        return [self cellForRowWithLessSections:indexPath tableView:tableView];
    }
    else
    {
        return [self cellForRowWithMoreSections:indexPath tableView:tableView];
    }

}

-(UITableViewCell *)cellForRowWithLessSections:(NSIndexPath*) indexPath tableView:(UITableView*) tableView
{
    
    static NSString *cellidSection=@"SMSMSynopsisTableHeaderCell";
    static NSString *cellidSection0=@"SMChangeVehicleViewCell";
    static NSString *cellidSection1=@"SMSynopsisSummaryCell";
    static NSString *cellidSection2=@"SMExtraSelectedVehicleCell";
    static NSString *cellidSectionLastIndex2=@"SMWarrantyServiceCell";
    static NSString *cellidSection22 = @"SMSynopsisSummary2Cell";
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:{
            SMSMSynopsisTableHeaderCell *cellObj=[tableView dequeueReusableCellWithIdentifier:cellidSection];
            [cellObj.btnVehicleImage addTarget:self action:@selector(btnImageGalleryDidClicked) forControlEvents:UIControlEventTouchUpInside];
            [self setAttributedTextForVehicleDetailsWithFirstText:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear] andWithSecondText:self.objSMSynopsisResult.strFriendlyName forLabel:cellObj.vechicleName];
            
            
            cellObj.vechicleDesciption.text = self.objSMSynopsisResult.strVariantDetails;
            
            [cellObj.vechicleImage setImageWithURL:[NSURL URLWithString:self.objSMSynopsisResult.strVariantImage] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
            
            cellObj.vechicleImage.backgroundColor = [UIColor clearColor];
            cellObj.vechicleName.numberOfLines = 0;
            
            cellObj.vechicleDesciption.numberOfLines = 0;
            
            cell = cellObj;
        }
            break;
        case 1:
        {
            SMChangeVehicleViewCell *cellObj=[tableView dequeueReusableCellWithIdentifier:cellidSection0];
            cellObj.txtMake.delegate = self;
            cellObj.txtModel.delegate = self;
            cellObj.txtVariant.delegate = self;
            cellObj.txtYear.delegate = self;
            
            [ cellObj.btnUpdateVehicle addTarget:self action:@selector(btnUpdateDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            // cellObj.txtYear.text = [arrmForYear objectAtIndex:0];
            
            NSLog(@"txtMakeeee = %@",cellObj.txtMake.text);
            cell = cellObj;
        }
            break;
        case 2:
        {
            SMSynopsisSummaryCell *cellObj=[tableView dequeueReusableCellWithIdentifier:cellidSection1];
            
            SMSynopsisSummary2Cell *cellObj2=[tableView dequeueReusableCellWithIdentifier:cellidSection22];
            
            switch (indexPath.row) {
                case 0:{
                    cellObj.objContentView.hidden = NO;
                    if (self.objSMSynopsisResult.intSources == 1) {
                        cellObj.pricingLabel.text = [NSString stringWithFormat:@"Avg: %d Source",self.objSMSynopsisResult.intSources];
                    }else{
                        cellObj.pricingLabel.text = [NSString stringWithFormat:@"Avg: %d Sources",self.objSMSynopsisResult.intSources];
                    }
                    
                    [SMAttributeStringFormatObject setButtonUnderlineText:kFetchTUAPricing forButton:cellObj.btnFetchPricing];
                    [cellObj.btnFetchPricing addTarget:self  action:@selector(btnFetchPricingDidClicked)  forControlEvents:UIControlEventTouchUpInside];
                    
                    if (isbtnFetchPricingDidClicked) {
                        
                        [cellObj.btnFetchPricing setHidden:YES];
                        [SMAttributeStringFormatObject setButtonUnderlineText:kUpdate forButton:cellObj.btnUpdate];
                        [cellObj.btnUpdate addTarget:self  action:@selector(btnUpdatePricingDidClicked)  forControlEvents:UIControlEventTouchUpInside];
                        
                        [cellObj.view1 setFrame:CGRectMake(cellObj.view1.frame.origin.x, cellObj.view1.frame.origin.y, cellObj.view1.frame.size.width,44.0f)];
                        
                        if ([self.objSMSynopsisResult.strTUASearchDateTime isKindOfClass:[NSNull class]]) {
                            cellObj.lblTUAPriceCheck.text = [NSString stringWithFormat:@"Date?"];
                        }
                        else
                        {
                            
                            if([self.objSMSynopsisResult.strTUASearchDateTime length] != 0)
                            {
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                
                                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                
                                NSDate *requiredDate1 = [dateFormatter dateFromString:self.objSMSynopsisResult.strTUASearchDateTime];
                                
                                NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                                [dateFormatter1 setDateFormat:@"dd MMM yyyy"];
                                
                                NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:requiredDate1]];
                                
                                
                                cellObj.lblTUAPriceCheck.text = [NSString stringWithFormat:@"TUA price check: %@",textDate];
                            }
                            else
                            {
                                
                                cellObj.lblTUAPriceCheck.text = @"TUA price check: Date?";
                            }
                        }
                        
                        [cellObj.lblTUAPriceCheck sizeToFit];
                        
                        [cellObj.btnUpdate setFrame:CGRectMake(cellObj.lblTUAPriceCheck.frame.size.width+cellObj.lblTUAPriceCheck.frame.origin.x+5, cellObj.btnUpdate.frame.origin.y, cellObj.btnUpdate.frame.size.width, cellObj.btnUpdate.frame.size.height)];
                        
                        cellObj.lblRetail.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingTUARetailPrice];
                        cellObj.lblTrade.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingTUATradePrice];
                        cellObj.lblMarket.text = @"";
                        [cellObj.lblTrade setHidden:NO];
                        [cellObj.lblMarket setHidden:NO];
                        [cellObj.lblRetail  setHidden:NO];
                        
                    }
                    else{
                        [cellObj.lblTrade setHidden:YES];
                        [cellObj.lblMarket setHidden:YES];
                        [cellObj.lblRetail  setHidden:YES];
                        [cellObj.view1 setFrame:CGRectMake(cellObj.view1.frame.origin.x, cellObj.view1.frame.origin.y, cellObj.view1.frame.size.width,22.0f)];
                    }
                    
                    [cellObj.view2 setFrame:CGRectMake(cellObj.view2.frame.origin.x, cellObj.view1.frame.origin.y+cellObj.view1.frame.size.height, cellObj.view2.frame.size.width,cellObj.view2.frame.size.height)];
                    
                    [cellObj.view3 setFrame:CGRectMake(cellObj.view3.frame.origin.x, cellObj.view2.frame.origin.y+cellObj.view2.frame.size.height, cellObj.view3.frame.size.width,cellObj.view3.frame.size.height)];
                    
                    [cellObj.view4 setFrame:CGRectMake(cellObj.view4.frame.origin.x, cellObj.view3.frame.origin.y+cellObj.view3.frame.size.height, cellObj.view4.frame.size.width,cellObj.view4.frame.size.height)];
                    
                    [cellObj.view5 setFrame:CGRectMake(cellObj.view5.frame.origin.x, cellObj.view4.frame.origin.y+cellObj.view4.frame.size.height, cellObj.view5.frame.size.width,cellObj.view5.frame.size.height)];
                    
                    
                    cellObj.tradeLabel.text = [NSString stringWithFormat:@"%dK",(int)self.objSMSynopsisResult.floatAverageTradePrice/1000];
                    cellObj.marketLabel.text = [NSString stringWithFormat:@"%dK",(int)self.objSMSynopsisResult.floatMarketPrice/1000];
                    cellObj.retailLabel.text = [NSString stringWithFormat:@"%dK",(int)self.objSMSynopsisResult.floatAveragePrice/1000];
                    
                    cellObj.lblTradePriceValue.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingTraderPrice];
                    cellObj.lblRetailPriceValue.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingRetailPrice];
                    cellObj.lblSLTradePrice.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingSLTradePrice];
                    cellObj.lblSLRetailPrice.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingSLRetailPrice];
                    cellObj.lblSLMarketPrice.text = @"";
                    cellObj.lblMarketPriceValue.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingPrivateAdvertPrice];
                    
                   
                    cell = cellObj;
                }
                    break;
                case 1:{
                    
                    cellObj2.objContentView.hidden = YES;
                  //  cellObj2.btnScanVIN.hidden = YES;
                    cellObj2.titleLabel.text = [NSString stringWithFormat:@"Verify VIN  %@",self.objSMSynopsisResult.strVINNo];
                    
                    [self setAttributeStringOnCell:cellObj2 andRangeOfString:@"Verify VIN "];
                    cell = cellObj2;
                }
                    break;
                case 2:{
                    cellObj2.objContentView.hidden = YES;
                    //cellObj2.btnScanVIN.hidden = YES;
                    cellObj2.titleLabel.text = @"VIN History";
                    
                    [self setAttributeStringOnCell:cellObj2 andRangeOfString:@"VIN "];
                    cell = cellObj2;
                    
                }
                    break;
                case 3:{
                    cellObj2.objContentView.hidden = YES;
                   // cellObj2.btnScanVIN.hidden = NO;
                   cellObj2.titleLabel.text = @"Do Appraisal";
                    [self setAttributeStringOnCell:cellObj2 andRangeOfString:@"Appraisal"];
                    cell = cellObj2;
                }
                    break;
               
                default:
                    break;
            }
            
            
            
        }
            break;
        case 3:
        {
            SMWarrantyServiceCell *warrantyServicecellObj=[tableView dequeueReusableCellWithIdentifier:cellidSectionLastIndex2];
            SMExtraSelectedVehicleCell *cellObj=[tableView dequeueReusableCellWithIdentifier:cellidSection2];
            
            switch (indexPath.row) {
                case 0:{
                    cellObj.detailLabel.hidden = NO;
                    cellObj.titleCountLabel.hidden = YES;
                    cellObj.titleLabel.text = @"Demand";
                    // cellObj.titleCountLabel.text = @"14";
                    cellObj.detailLabel.text = self.objSMSynopsisResult.arrmDemandSummary.count == 0?@"N/A":strDemandSummary;
                    cell = cellObj;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                }
                    break;
                case 1:{
                    cellObj.detailLabel.hidden = NO;
                    cellObj.titleCountLabel.hidden = YES;
                    cellObj.titleLabel.text = @"Availability";
                    // cellObj.titleCountLabel.text = @"16";
                    cellObj.detailLabel.text = self.objSMSynopsisResult.arrmAverageAvailableSummary.count == 0?@"N/A":strAverageAvailableSummary;
                    cell = cellObj;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                }
                    break;
                case 2:{
                    cellObj.detailLabel.hidden = NO;
                    cellObj.titleCountLabel.hidden = YES;
                    cellObj.titleLabel.text = @"Average Days";
                    // cellObj.titleCountLabel.text = @"37";
                    cellObj.detailLabel.text = self.objSMSynopsisResult.arrmAverageDaysInStockSummary.count == 0?@"N/A":strAverageDaysInStockSummary;
                    cell = cellObj;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                }
                    break;
                case 3:{
                    cellObj.detailLabel.hidden = NO;
                    cellObj.titleCountLabel.hidden = YES;
                    cellObj.titleLabel.text = @"Sales History";
                    //  cellObj.titleCountLabel.text = @"7";
                    cellObj.detailLabel.text = @"N/A";
                    cell = cellObj;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                }
                    break;
                case 4:{
                    cellObj.detailLabel.hidden = NO;
                    cellObj.titleCountLabel.hidden = YES;
                    cellObj.titleLabel.text = @"Lead Pool";
                    //  cellObj.titleCountLabel.text = @"12";
                    cellObj.detailLabel.text = self.objSMSynopsisResult.arrmLeadPoolSummary.count == 0?@"N/A":strLeadPoolSummary;
                    cell = cellObj;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                }
                    break;
                case 5:{
                    
                    SMSummaryObject *objSMSummeryObject0 = (SMSummaryObject *) [self.objSMSynopsisResult.arrmWarrantySummary objectAtIndex:0];
                    SMSummaryObject *objSMSummeryObject1 = (SMSummaryObject *) [self.objSMSynopsisResult.arrmWarrantySummary objectAtIndex:1];
                    SMSummaryObject *objSMSummeryObject2 = (SMSummaryObject *) [self.objSMSynopsisResult.arrmWarrantySummary objectAtIndex:2];
                    
                    if([objSMSummeryObject0.strType length] == 0)
                    {
                        warrantyServicecellObj.heightC_Warranty.constant = 0;
                        warrantyServicecellObj.warrantyLabel.text =[NSString stringWithFormat:@"%@ : %@",objSMSummeryObject0.strArea, @"N/A"];
                        [self setAttributeStringOnUILabel:warrantyServicecellObj.warrantyLabel andRangeOfString:[NSString stringWithFormat:@"%@ :",objSMSummeryObject0.strArea]];
                       // warrantyServicecellObj.warrantyLabel.backgroundColor = [UIColor redColor];
                        isFirstWarrantySectionEmpty = YES;
                        cell = warrantyServicecellObj;
                    }
                    else
                    {
                        isFirstWarrantySectionEmpty = NO;
                        warrantyServicecellObj.warrantyLabel.text =[NSString stringWithFormat:@"%@ : %@",objSMSummeryObject0.strArea, objSMSummeryObject0.strType];
                        [self setAttributeStringOnUILabel:warrantyServicecellObj.warrantyLabel andRangeOfString:[NSString stringWithFormat:@"%@ :",objSMSummeryObject0.strArea]];
                    }
                    
                    if([objSMSummeryObject1.strType length] == 0)
                    {
                        warrantyServicecellObj.heightC_ServicePlan.constant = 0;
                        warrantyServicecellObj.servicePlanLabel.text =[NSString stringWithFormat:@"%@ : %@",objSMSummeryObject1.strArea,@"N/A"];
                        [self setAttributeStringOnUILabel:warrantyServicecellObj.servicePlanLabel andRangeOfString:[NSString stringWithFormat:@"%@ :",objSMSummeryObject1.strArea]];
                        //warrantyServicecellObj.servicePlanLabel.backgroundColor = [UIColor redColor];
                        
                        isSecondWattantySectionEmpty = YES;
                        cell = warrantyServicecellObj;
                    }
                    else
                    {
                        isSecondWattantySectionEmpty = NO;
                        warrantyServicecellObj.servicePlanLabel.text =[NSString stringWithFormat:@"%@ : %@",objSMSummeryObject1.strArea,objSMSummeryObject1.strType];
                        [self setAttributeStringOnUILabel:warrantyServicecellObj.servicePlanLabel andRangeOfString:[NSString stringWithFormat:@"%@ :",objSMSummeryObject1.strArea]];
                    }
                    
                    if([objSMSummeryObject2.strType length] == 0)
                    {
                        
                        if(isFirstWarrantySectionEmpty && isSecondWattantySectionEmpty)
                        {
                            warrantyServicecellObj.serviceIntervalsLabel.text = @"N/A";
                        }
                        else
                        {
                            warrantyServicecellObj.heightC_ServiceInterval.constant = 0;
                            warrantyServicecellObj.serviceIntervalsLabel.text = @"";
                        }
                        warrantyServicecellObj.serviceIntervalsLabel.text =[NSString stringWithFormat:@"%@ : %@",objSMSummeryObject2.strArea,@"N/A"];
                        [self setAttributeStringOnUILabel:warrantyServicecellObj.serviceIntervalsLabel andRangeOfString:[NSString stringWithFormat:@"%@ :",objSMSummeryObject2.strArea]];
                        cell = warrantyServicecellObj;
                    }
                    else
                    {
                        NSLog(@"******-- 3");
                        warrantyServicecellObj.serviceIntervalsLabel.text =[NSString stringWithFormat:@"%@ : %@",objSMSummeryObject2.strArea,objSMSummeryObject2.strType];
                        [self setAttributeStringOnUILabel:warrantyServicecellObj.serviceIntervalsLabel andRangeOfString:[NSString stringWithFormat:@"%@ :",objSMSummeryObject2.strArea]];
                        cell = warrantyServicecellObj;
                    }
                    
                    
                }
                    break;
                case 6:
                {
                    cellObj.detailLabel.hidden = YES;
                    cellObj.titleLabel.text = @"Reviews";
                    cellObj.titleLabel.backgroundColor = [UIColor blackColor];
                    cellObj.titleCountLabel.text = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intReviewCount];
                    cellObj.titleCountLabel.hidden = NO;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                    cell = cellObj;
                    
                    
                }
                    break;
                case 7:
                {
                    cellObj.detailLabel.hidden = YES;
                    cellObj.titleLabel.text = @"OEM Specs";
                    cellObj.titleLabel.backgroundColor = [UIColor blackColor];
                    // cellObj.titleCountLabel.text = @"3";
                    cellObj.titleCountLabel.hidden = YES;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                    NSLog(@"cellObj.titleLabel Frame %@",NSStringFromCGRect(cellObj.titleLabel.frame));
                    cell = cellObj;
                    
                }
                    break;
                case 8:
                {
                    cellObj.detailLabel.hidden = YES;
                    cellObj.titleLabel.text = @"New Price Plotter";
                    cellObj.titleLabel.backgroundColor = [UIColor blackColor];
                    cellObj.titleCountLabel.hidden = YES;
                    // cellObj.titleCountLabel.text = @"3";
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                    NSLog(@"cellObj.titleLabel Frame %@",NSStringFromCGRect(cellObj.titleLabel.frame));
                    cell = cellObj;
                    
                }
                    break;
                default:{
                    cellObj.detailLabel.hidden = NO;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                    cell = cellObj;
                    
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    //    cell.layoutMargins = UIEdgeInsetsZero;
    //    cell.preservesSuperviewLayoutMargins = NO;
    if (indexPath.section == 0) {
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

-(UITableViewCell *)cellForRowWithMoreSections:(NSIndexPath*) indexPath tableView:(UITableView*) tableView
{
    
    static NSString *cellidSection=@"SMSMSynopsisTableHeaderCell";
    static NSString *cellidSection0=@"SMChangeVehicleViewCell";
    static NSString *cellidSection1=@"SMSynopsisSummaryCell";
    static NSString *cellidSection2=@"SMExtraSelectedVehicleCell";
    static NSString *cellidSectionLastIndex2=@"SMWarrantyServiceCell";
    static NSString *cellidSection22 = @"SMSynopsisSummary2Cell";
    static NSString *cellidSection4 = @"SMReviewTitleViewCell";
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:{
            SMSMSynopsisTableHeaderCell *cellObj=[tableView dequeueReusableCellWithIdentifier:cellidSection];
            [cellObj.btnVehicleImage addTarget:self action:@selector(btnImageGalleryDidClicked) forControlEvents:UIControlEventTouchUpInside];
            [self setAttributedTextForVehicleDetailsWithFirstText:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear] andWithSecondText:self.objSMSynopsisResult.strFriendlyName forLabel:cellObj.vechicleName];
            
            
            cellObj.vechicleDesciption.text = self.objSMSynopsisResult.strVariantDetails;
            
            [cellObj.vechicleImage setImageWithURL:[NSURL URLWithString:self.objSMSynopsisResult.strVariantImage] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
            
            /* [cellObj.vechicleImage setImageWithURL:[NSURL URLWithString:self.objSMSynopsisResult.strVariantImage] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"] options:SDWebImageCacheMemoryOnly success:^(UIImage *image, BOOL cached) {
             cellObj.vechicleImage.image = image;
             
             } failure:^(NSError *error) {
             cellObj.vechicleImage.image = [UIImage imageNamed:@"placeholder.jpeg"];
             }];*/
            cellObj.vechicleImage.backgroundColor = [UIColor clearColor];
            // [cellObj.vechicleImage sizeToFit];
            cellObj.vechicleName.numberOfLines = 0;
            //[cellObj.vechicleName sizeToFit];
            
            cellObj.vechicleDesciption.numberOfLines = 0;
            //[cellObj.vechicleDesciption sizeToFit];
            
            cell = cellObj;
        }
            break;
        case 1:
        {
            static NSString *cellIdentifier= @"Cell";
            
            UITableViewCell *cellObj = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if(!cellObj)
            {
                cellObj = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
            }
            cellObj.selectionStyle = UITableViewCellSelectionStyleNone;
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                cellObj.textLabel.font = [UIFont fontWithName:FONT_NAME size:14.0];
            }
            else
            {
                cellObj.textLabel.font = [UIFont fontWithName:FONT_NAME size:20.0];
            }
            cellObj.backgroundColor = [UIColor clearColor];
            cellObj.accessoryType =UITableViewCellAccessoryNone;
            cellObj.textLabel.text = @"Change selected vehicle to -";
            cellObj.textLabel.textColor = [UIColor whiteColor];
            cellObj.textLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
            
            cell = cellObj;
        }
        break;
        case 2:
        {
            SMReviewTitleViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellidSection4];
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            SMDropDownObject *individualRowObj = (SMDropDownObject*)[objSimilarVehiclesBject.arrOfYearYoungerVehicles objectAtIndex:indexPath.row];
            dynamicCell.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:7.0];
            dynamicCell.titleLabel.preferredMaxLayoutWidth = self.view.frame.size.width-16.0f;
            
            [[SMAttributeStringFormatObject sharedService]setAttributedTextForChangeVehicleSectionWithFirstText:individualRowObj.strMinYear andWithSecondText:individualRowObj.strMakeName andWithThirdText:[NSString stringWithFormat:@"(%@, %@)",individualRowObj.strStockId,individualRowObj.strModelId] forLabel:dynamicCell.titleLabel];
            
            dynamicCell.lblSeparator.hidden = YES;
            cell = dynamicCell;
        }
            break;
        case 3:
        {
            SMReviewTitleViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellidSection4];
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            SMDropDownObject *individualRowObj = (SMDropDownObject*)[objSimilarVehiclesBject.arrOfOtherModelVehicles objectAtIndex:indexPath.row];
            dynamicCell.titleLabel.preferredMaxLayoutWidth = self.view.frame.size.width-16.0f;
            [[SMAttributeStringFormatObject sharedService]setAttributedTextForChangeVehicleSectionWithFirstText:individualRowObj.strMinYear andWithSecondText:individualRowObj.strMakeName andWithThirdText:[NSString stringWithFormat:@"(%@, %@)",individualRowObj.strStockId,individualRowObj.strModelId] forLabel:dynamicCell.titleLabel];
            dynamicCell.lblSeparator.hidden = YES;
            cell = dynamicCell;
        }
            break;
        case 4:
        {
            SMReviewTitleViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellidSection4];
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            SMDropDownObject *individualRowObj = (SMDropDownObject*)[objSimilarVehiclesBject.arrOfYearOlderVehicles objectAtIndex:indexPath.row];
            dynamicCell.titleLabel.preferredMaxLayoutWidth = self.view.frame.size.width-16.0f;
            [[SMAttributeStringFormatObject sharedService]setAttributedTextForChangeVehicleSectionWithFirstText:individualRowObj.strMinYear andWithSecondText:individualRowObj.strMakeName andWithThirdText:[NSString stringWithFormat:@"(%@, %@)",individualRowObj.strStockId,individualRowObj.strModelId] forLabel:dynamicCell.titleLabel];
            dynamicCell.lblSeparator.hidden = YES;
            cell = dynamicCell;
        }
            break;
        case 5:
        {
            SMChangeVehicleViewCell *cellObj=[tableView dequeueReusableCellWithIdentifier:cellidSection0];
            cellObj.txtMake.delegate = self;
            cellObj.txtModel.delegate = self;
            cellObj.txtVariant.delegate = self;
            cellObj.txtYear.delegate = self;
          
            [ cellObj.btnUpdateVehicle addTarget:self action:@selector(btnUpdateDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            // cellObj.txtYear.text = [arrmForYear objectAtIndex:0];
            
            NSLog(@"txtMakeeee = %@",cellObj.txtMake.text);
            cell = cellObj;
        }
            break;
        case 6:
        {
            SMSynopsisSummaryCell *cellObj=[tableView dequeueReusableCellWithIdentifier:cellidSection1];
            
            SMSynopsisSummary2Cell *cellObj2=[tableView dequeueReusableCellWithIdentifier:cellidSection22];
            
            switch (indexPath.row) {
                case 0:{
                    cellObj.objContentView.hidden = NO;
                    if (self.objSMSynopsisResult.intSources == 1) {
                        cellObj.pricingLabel.text = [NSString stringWithFormat:@"Avg: %d Source",self.objSMSynopsisResult.intSources];
                    }else{
                        cellObj.pricingLabel.text = [NSString stringWithFormat:@"Avg: %d Sources",self.objSMSynopsisResult.intSources];
                    }
                    
                    [SMAttributeStringFormatObject setButtonUnderlineText:kFetchTUAPricing forButton:cellObj.btnFetchPricing];
                    [cellObj.btnFetchPricing addTarget:self  action:@selector(btnFetchPricingDidClicked)  forControlEvents:UIControlEventTouchUpInside];
                    
                    if (isbtnFetchPricingDidClicked) {
                        
                        [cellObj.btnFetchPricing setHidden:YES];
                        [SMAttributeStringFormatObject setButtonUnderlineText:kUpdate forButton:cellObj.btnUpdate];
                        [cellObj.btnUpdate addTarget:self  action:@selector(btnUpdatePricingDidClicked)  forControlEvents:UIControlEventTouchUpInside];
                        
                        [cellObj.view1 setFrame:CGRectMake(cellObj.view1.frame.origin.x, cellObj.view1.frame.origin.y, cellObj.view1.frame.size.width,44.0f)];
                        
                        if ([self.objSMSynopsisResult.strTUASearchDateTime isKindOfClass:[NSNull class]]) {
                            cellObj.lblTUAPriceCheck.text = [NSString stringWithFormat:@"Date?"];
                        }
                        else
                        {
                            
                            if([self.objSMSynopsisResult.strTUASearchDateTime length] != 0)
                            {
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                
                                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                
                                NSDate *requiredDate1 = [dateFormatter dateFromString:self.objSMSynopsisResult.strTUASearchDateTime];
                                
                                NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                                [dateFormatter1 setDateFormat:@"dd MMM yyyy"];
                                
                                NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:requiredDate1]];
                                
                                
                                cellObj.lblTUAPriceCheck.text = [NSString stringWithFormat:@"TUA price check: %@",textDate];
                            }
                            else
                            {
                                
                                cellObj.lblTUAPriceCheck.text = @"TUA price check: Date?";
                            }
                        }
                        
                        [cellObj.lblTUAPriceCheck sizeToFit];
                        
                        [cellObj.btnUpdate setFrame:CGRectMake(cellObj.lblTUAPriceCheck.frame.size.width+cellObj.lblTUAPriceCheck.frame.origin.x+5, cellObj.btnUpdate.frame.origin.y, cellObj.btnUpdate.frame.size.width, cellObj.btnUpdate.frame.size.height)];
                        
                        cellObj.lblRetail.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingTUARetailPrice];
                        cellObj.lblTrade.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingTUATradePrice];
                        cellObj.lblMarket.text = @"";
                        [cellObj.lblTrade setHidden:NO];
                        [cellObj.lblMarket setHidden:NO];
                        [cellObj.lblRetail  setHidden:NO];
                        
                    }
                    else{
                        [cellObj.lblTrade setHidden:YES];
                        [cellObj.lblMarket setHidden:YES];
                        [cellObj.lblRetail  setHidden:YES];
                        [cellObj.view1 setFrame:CGRectMake(cellObj.view1.frame.origin.x, cellObj.view1.frame.origin.y, cellObj.view1.frame.size.width,22.0f)];
                    }
                    
                    [cellObj.view2 setFrame:CGRectMake(cellObj.view2.frame.origin.x, cellObj.view1.frame.origin.y+cellObj.view1.frame.size.height, cellObj.view2.frame.size.width,cellObj.view2.frame.size.height)];
                    
                    [cellObj.view3 setFrame:CGRectMake(cellObj.view3.frame.origin.x, cellObj.view2.frame.origin.y+cellObj.view2.frame.size.height, cellObj.view3.frame.size.width,cellObj.view3.frame.size.height)];
                    
                    [cellObj.view4 setFrame:CGRectMake(cellObj.view4.frame.origin.x, cellObj.view3.frame.origin.y+cellObj.view3.frame.size.height, cellObj.view4.frame.size.width,cellObj.view4.frame.size.height)];
                    
                    [cellObj.view5 setFrame:CGRectMake(cellObj.view5.frame.origin.x, cellObj.view4.frame.origin.y+cellObj.view4.frame.size.height, cellObj.view5.frame.size.width,cellObj.view5.frame.size.height)];
                    
                    
                    cellObj.tradeLabel.text = [NSString stringWithFormat:@"%dK",(int)self.objSMSynopsisResult.floatAverageTradePrice/1000];
                    cellObj.marketLabel.text = [NSString stringWithFormat:@"%dK",(int)self.objSMSynopsisResult.floatMarketPrice/1000];
                    cellObj.retailLabel.text = [NSString stringWithFormat:@"%dK",(int)self.objSMSynopsisResult.floatAveragePrice/1000];
                    
                    cellObj.lblTradePriceValue.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingTraderPrice];
                    cellObj.lblRetailPriceValue.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingRetailPrice];
                    cellObj.lblSLTradePrice.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingSLTradePrice];
                    cellObj.lblSLRetailPrice.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingSLRetailPrice];
                    cellObj.lblSLMarketPrice.text = @"";
                    cellObj.lblMarketPriceValue.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingPrivateAdvertPrice];
                    cell = cellObj;
                }
                    break;
                case 1:{
                    
                    cellObj2.objContentView.hidden = YES;
                    //cellObj2.btnScanVIN.hidden = YES;
                    cellObj2.titleLabel.text = [NSString stringWithFormat:@"Verify VIN  %@",self.objSMSynopsisResult.strVINNo];
                    
                    [self setAttributeStringOnCell:cellObj2 andRangeOfString:@"Verify VIN "];
                    cell = cellObj2;
                }
                    break;
                case 2:{
                    cellObj2.objContentView.hidden = YES;
                   // cellObj2.btnScanVIN.hidden = YES;
                    cellObj2.titleLabel.text = @"VIN History";
                    
                    [self setAttributeStringOnCell:cellObj2 andRangeOfString:@"VIN "];
                    cell = cellObj2;
                    
                }
                    break;
                case 3:{
                    cellObj2.objContentView.hidden = YES;
                   // cellObj2.btnScanVIN.hidden = NO;
                    cellObj2.titleLabel.text = @"Do Appraisal";
                    [self setAttributeStringOnCell:cellObj2 andRangeOfString:@"Appraisal"];
                    cell = cellObj2;
                }
                    break;
                /*case 4:{
                    cellObj2.objContentView.hidden = YES;
                    cellObj2.titleLabel.text = @"Similar Vehicles";
                    cellObj2.titleLabel.textColor = [UIColor whiteColor];
                    [self setAttributeStringOnCell:cellObj2 andRangeOfString:@"Similar "];
                    cell = cellObj2;
                    
                }
                    break;*/
                default:
                    break;
            }
            
            
            
        }
            break;
        case 7:
        {
            SMWarrantyServiceCell *warrantyServicecellObj=[tableView dequeueReusableCellWithIdentifier:cellidSectionLastIndex2];
            SMExtraSelectedVehicleCell *cellObj=[tableView dequeueReusableCellWithIdentifier:cellidSection2];
            cellObj.titleCountLabel.hidden = YES;
            switch (indexPath.row) {
                    case 0:{
                    cellObj.detailLabel.hidden = NO;
                    cellObj.titleCountLabel.hidden = YES;
                    cellObj.titleLabel.text = @"Demand";
                    // cellObj.titleCountLabel.text = @"14";
                    cellObj.detailLabel.text = self.objSMSynopsisResult.arrmDemandSummary.count == 0?@"N/A":strDemandSummary;
                    cell = cellObj;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                }
                    break;
                case 1:{
                    cellObj.detailLabel.hidden = NO;
                    cellObj.titleCountLabel.hidden = YES;
                    cellObj.titleLabel.text = @"Availability";
                    // cellObj.titleCountLabel.text = @"16";
                    cellObj.detailLabel.text = self.objSMSynopsisResult.arrmAverageAvailableSummary.count == 0?@"N/A":strAverageAvailableSummary;
                    cell = cellObj;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                }
                    break;
                case 2:{
                    cellObj.detailLabel.hidden = NO;
                    cellObj.titleCountLabel.hidden = YES;
                    cellObj.titleLabel.text = @"Average Days";
                    // cellObj.titleCountLabel.text = @"37";
                    cellObj.detailLabel.text = self.objSMSynopsisResult.arrmAverageDaysInStockSummary.count == 0?@"N/A":strAverageDaysInStockSummary;
                    cell = cellObj;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                }
                    break;
                case 3:{
                    cellObj.detailLabel.hidden = NO;
                    cellObj.titleCountLabel.hidden = YES;
                    cellObj.titleLabel.text = @"Sales History";
                    //  cellObj.titleCountLabel.text = @"7";
                    cellObj.detailLabel.text = @"N/A";
                    cell = cellObj;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                }
                    break;
                case 4:{
                    cellObj.detailLabel.hidden = NO;
                    cellObj.titleCountLabel.hidden = YES;
                    cellObj.titleLabel.text = @"Lead Pool";
                    //  cellObj.titleCountLabel.text = @"12";
                    cellObj.detailLabel.text = self.objSMSynopsisResult.arrmLeadPoolSummary.count == 0?@"N/A":strLeadPoolSummary;
                    cell = cellObj;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                }
                    break;
                case 5:{
                    
                    SMSummaryObject *objSMSummeryObject0 = (SMSummaryObject *) [self.objSMSynopsisResult.arrmWarrantySummary objectAtIndex:0];
                    SMSummaryObject *objSMSummeryObject1 = (SMSummaryObject *) [self.objSMSynopsisResult.arrmWarrantySummary objectAtIndex:1];
                    SMSummaryObject *objSMSummeryObject2 = (SMSummaryObject *) [self.objSMSynopsisResult.arrmWarrantySummary objectAtIndex:2];
                    
                    if([objSMSummeryObject0.strType length] == 0)
                    {
                        warrantyServicecellObj.heightC_Warranty.constant = 0;
                        warrantyServicecellObj.warrantyLabel.text =[NSString stringWithFormat:@"%@ : %@",objSMSummeryObject0.strArea, @"N/A"];
                        [self setAttributeStringOnUILabel:warrantyServicecellObj.warrantyLabel andRangeOfString:[NSString stringWithFormat:@"%@ :",objSMSummeryObject0.strArea]];                       // warrantyServicecellObj.warrantyLabel.backgroundColor = [UIColor redColor];
                        isFirstWarrantySectionEmpty = YES;
                        cell = warrantyServicecellObj;
                    }
                    else
                    {
                        isFirstWarrantySectionEmpty = NO;
                        warrantyServicecellObj.warrantyLabel.text =[NSString stringWithFormat:@"%@ : %@",objSMSummeryObject0.strArea, objSMSummeryObject0.strType];
                        [self setAttributeStringOnUILabel:warrantyServicecellObj.warrantyLabel andRangeOfString:[NSString stringWithFormat:@"%@ :",objSMSummeryObject0.strArea]];
                    }
                    
                    if([objSMSummeryObject1.strType length] == 0)
                    {
                        warrantyServicecellObj.heightC_ServicePlan.constant = 0;
                        warrantyServicecellObj.servicePlanLabel.text =[NSString stringWithFormat:@"%@ : %@",objSMSummeryObject1.strArea,@"N/A"];
                        [self setAttributeStringOnUILabel:warrantyServicecellObj.servicePlanLabel andRangeOfString:[NSString stringWithFormat:@"%@ :",objSMSummeryObject1.strArea]];
                        //warrantyServicecellObj.servicePlanLabel.backgroundColor = [UIColor redColor];
                        
                        isSecondWattantySectionEmpty = YES;
                        cell = warrantyServicecellObj;
                    }
                    else
                    {
                        isSecondWattantySectionEmpty = NO;
                        warrantyServicecellObj.servicePlanLabel.text =[NSString stringWithFormat:@"%@ : %@",objSMSummeryObject1.strArea,objSMSummeryObject1.strType];
                        [self setAttributeStringOnUILabel:warrantyServicecellObj.servicePlanLabel andRangeOfString:[NSString stringWithFormat:@"%@ :",objSMSummeryObject1.strArea]];
                    }
                    
                    if([objSMSummeryObject2.strType length] == 0)
                    {
                        
                        if(isFirstWarrantySectionEmpty && isSecondWattantySectionEmpty)
                        {
                            warrantyServicecellObj.serviceIntervalsLabel.text = @"N/A";
                            //warrantyServicecellObj.serviceIntervalsLabel.backgroundColor = [UIColor redColor];
                        }
                        else
                        {
                            warrantyServicecellObj.heightC_ServiceInterval.constant = 0;
                            warrantyServicecellObj.serviceIntervalsLabel.text = @"";
                        }
                        
                        warrantyServicecellObj.serviceIntervalsLabel.text =[NSString stringWithFormat:@"%@ : %@",objSMSummeryObject2.strArea,@"N/A"];
                        [self setAttributeStringOnUILabel:warrantyServicecellObj.serviceIntervalsLabel andRangeOfString:[NSString stringWithFormat:@"%@ :",objSMSummeryObject2.strArea]];
                        
                        cell = warrantyServicecellObj;
                    }
                    else
                    {
                        NSLog(@"******-- 3");
                        warrantyServicecellObj.serviceIntervalsLabel.text =[NSString stringWithFormat:@"%@ : %@",objSMSummeryObject2.strArea,objSMSummeryObject2.strType];
                        [self setAttributeStringOnUILabel:warrantyServicecellObj.serviceIntervalsLabel andRangeOfString:[NSString stringWithFormat:@"%@ :",objSMSummeryObject2.strArea]];
                        cell = warrantyServicecellObj;
                    }
                    
                    
                }
                    break;
                case 6:
                {
                    cellObj.detailLabel.hidden = YES;
                    cellObj.titleLabel.text = @"Reviews";
                    cellObj.titleLabel.backgroundColor = [UIColor blackColor];
                    cellObj.titleCountLabel.text = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intReviewCount];
                    cellObj.titleCountLabel.hidden = NO;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                    cell = cellObj;
                    
                    
                }
                    break;
                case 7:
                {
                    cellObj.detailLabel.hidden = YES;
                    cellObj.titleLabel.text = @"OEM Specs";
                    cellObj.titleLabel.backgroundColor = [UIColor blackColor];
                    // cellObj.titleCountLabel.text = @"3";
                    cellObj.titleCountLabel.hidden = YES;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                    NSLog(@"cellObj.titleLabel Frame %@",NSStringFromCGRect(cellObj.titleLabel.frame));
                    cell = cellObj;
                    
                }
                    break;
                case 8:
                {
                    cellObj.detailLabel.hidden = YES;
                    cellObj.titleLabel.text = @"New Price Plotter";
                    cellObj.titleLabel.backgroundColor = [UIColor blackColor];
                    cellObj.titleCountLabel.hidden = YES;
                    // cellObj.titleCountLabel.text = @"3";
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                    NSLog(@"cellObj.titleLabel Frame %@",NSStringFromCGRect(cellObj.titleLabel.frame));
                    cell = cellObj;
                    
                }
                    break;
                default:{
                    cellObj.detailLabel.hidden = NO;
                    cellObj.detailLabel.numberOfLines = 0;
                    [cellObj.detailLabel sizeToFit];
                    cell = cellObj;
                    
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    //    cell.layoutMargins = UIEdgeInsetsZero;
    //    cell.preservesSuperviewLayoutMargins = NO;
    if (indexPath.section == 0) {
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(!isChangeVechileExpand)
    {
        switch (indexPath.section)
        {
            case 2:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        
                        SMPricing_ValuationViewController *synopsisSMPricing_ValuationViewController;
                        
                        synopsisSMPricing_ValuationViewController = [[SMPricing_ValuationViewController alloc] initWithNibName:@"SMPricing_ValuationViewController" bundle:nil];
                        synopsisSMPricing_ValuationViewController.isValuation = NO;
                        synopsisSMPricing_ValuationViewController.strVehicleYear = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear];
                        synopsisSMPricing_ValuationViewController.strVehicleVariant = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intVariantId];
                        synopsisSMPricing_ValuationViewController.strVehicleName = self.objSMSynopsisResult.strFriendlyName;
                        
                        synopsisSMPricing_ValuationViewController.strVehicleDetails = self.objSMSynopsisResult.strVariantDetails;
                        NSLog(@"MMCode = %@",self.objSMSynopsisResult.strMMCode);
                        synopsisSMPricing_ValuationViewController.objSummary = self.objSMSynopsisResult;
                        
                        [self.navigationController pushViewController:synopsisSMPricing_ValuationViewController animated:YES];
                    }
                        
                        break;
                        
                        
                    case 1:
                    {
                        
                        SMSynopsisVerifyVINViewController *synopsisVerifyVINViewController;
                        
                        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                        {
                            synopsisVerifyVINViewController = [[SMSynopsisVerifyVINViewController alloc] initWithNibName:@"SMSynopsisVerifyVINViewController" bundle:nil];
                        }
                        else
                        {
                            synopsisVerifyVINViewController = [[SMSynopsisVerifyVINViewController alloc] initWithNibName:@"SMSynopsisVerifyVINViewController~ipad" bundle:nil];
                        }
                        synopsisVerifyVINViewController.strMainVehicleName = self.objSMSynopsisResult.strFriendlyName;
                        synopsisVerifyVINViewController.strMainVehicleYear = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear];
                        synopsisVerifyVINViewController.strSelectedVINNumber = self.objSMSynopsisResult.strVINNo;
                        synopsisVerifyVINViewController.strSelectedMMCode = self.objSMSynopsisResult.strMMCode;
                        synopsisVerifyVINViewController.strSelectedRegNo = self.objSMSynopsisResult.strRegNo;
                        synopsisVerifyVINViewController.strSelectedKiloMeters = self.objSMSynopsisResult.strKilometers;
                        synopsisVerifyVINViewController.previousPageNumber = 1;
                        [self.navigationController pushViewController:synopsisVerifyVINViewController animated:YES];
                    }
                        
                        break;
                        
                    case 2:
                    {
                        selectedIndexpathForVIN = indexPath;
                        
                        if([self.objSMSynopsisResult.strVINNo isEqualToString:@"No VIN loaded"])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self displayAlertForScanVIN];
                                
                            });
                        }
                        else
                        {
                            SMVINHistoryViewController *synopsisVINHistoryViewController;
                            
                            synopsisVINHistoryViewController = [[SMVINHistoryViewController alloc] initWithNibName:@"SMVINHistoryViewController" bundle:nil];
                            synopsisVINHistoryViewController.strVehicleName =self.objSMSynopsisResult.strFriendlyName;
                            synopsisVINHistoryViewController.strYear=[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear];
                            synopsisVINHistoryViewController.strVINNo = self.objSMSynopsisResult.strVINNo;
                            [self.navigationController pushViewController:synopsisVINHistoryViewController animated:YES];
                        }
                    }
                        break;
                    case 3:
                    {
                        selectedIndexpathForVIN = indexPath;
                        
                        if([self.objSMSynopsisResult.strVINNo isEqualToString:@"No VIN loaded"])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self displayAlertForScanVIN];
                                
                            });
                        }
                        else
                        {
                            SMSynopsisDoAppraisalViewController *synopsisDoAppraisalViewController;
                        
                            synopsisDoAppraisalViewController = [[SMSynopsisDoAppraisalViewController alloc] initWithNibName:@"SMSynopsisDoAppraisalViewController" bundle:nil];
                            synopsisDoAppraisalViewController.objSMSynopsisResult = self.objSMSynopsisResult;
                        
                            [self.navigationController pushViewController:synopsisDoAppraisalViewController animated:YES];
                        }
                    }
                        break;
                        
                    case 4:
                    {
                        
                        SMSynopsisSimilarVehiclesViewController *synopsisSimilarVehiclesViewController;
                        
                        synopsisSimilarVehiclesViewController = [[SMSynopsisSimilarVehiclesViewController alloc] initWithNibName:@"SMSynopsisSimilarVehiclesViewController" bundle:nil];
                        
                        [self.navigationController pushViewController:synopsisSimilarVehiclesViewController animated:YES];
                    }
                        break;
                        
                        
                    default:
                        break;
                }
                
            }
                break;
            case 3:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        SMSynopsisDemandViewController *synopsisDemandViewController;
                        
                        synopsisDemandViewController = [[SMSynopsisDemandViewController alloc] initWithNibName:@"SMSynopsisDemandViewController" bundle:nil];
                        
                        synopsisDemandViewController.strVariantID = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intVariantId ];
                        synopsisDemandViewController.strYear =[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear ];
                        [self.navigationController pushViewController:synopsisDemandViewController animated:YES];
                    }
                        break;
                        
                    case 1:
                    {
                        SMAvailabilityViewController *synopsisAvailabilityViewController;
                        
                        synopsisAvailabilityViewController = [[SMAvailabilityViewController alloc] initWithNibName:@"SMAvailabilityViewController" bundle:nil];
                        synopsisAvailabilityViewController.strModelID = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intModelId];
                        synopsisAvailabilityViewController.strYear =[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear ];
                        synopsisAvailabilityViewController.strModelName=self.objSMSynopsisResult.strModelName;
                        [self.navigationController pushViewController:synopsisAvailabilityViewController animated:YES];
                    }
                        break;
                    case 2:
                    {
                        SMSynopsisAverageDaysViewController *synopsisAverageDaysViewController;
                        
                        synopsisAverageDaysViewController = [[SMSynopsisAverageDaysViewController alloc] initWithNibName:@"SMSynopsisAverageDaysViewController" bundle:nil];
                        
                        synopsisAverageDaysViewController.strModelID = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intModelId];
                        synopsisAverageDaysViewController.strYear =[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear ];
                        
                        [self.navigationController pushViewController:synopsisAverageDaysViewController animated:YES];
                    }
                        break;
                    case 3:
                    {
                        SMSalesHistoryViewController *synopsisSMSalesHistoryViewController;
                        
                        synopsisSMSalesHistoryViewController = [[SMSalesHistoryViewController alloc] initWithNibName:@"SMSalesHistoryViewController" bundle:nil];
                        synopsisSMSalesHistoryViewController.strModelName = self.objSMSynopsisResult.strModelName;
                        synopsisSMSalesHistoryViewController.strYear =[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear ];
                        synopsisSMSalesHistoryViewController.strVariantId = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intVariantId];
                        [self.navigationController pushViewController:synopsisSMSalesHistoryViewController animated:YES];
                    }
                        break;
                    case 4:
                    {
                        SMLeadPoolViewController *synopsisLeadPoolViewController;
                        
                        synopsisLeadPoolViewController = [[SMLeadPoolViewController alloc] initWithNibName:@"SMLeadPoolViewController" bundle:nil];
                        synopsisLeadPoolViewController.strYear=[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear];
                        synopsisLeadPoolViewController.strVariantID = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intVariantId];
                        synopsisLeadPoolViewController.strModelId = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intModelId];
                        synopsisLeadPoolViewController.strModelName = self.objSMSynopsisResult.strModelName;
                        [self.navigationController pushViewController:synopsisLeadPoolViewController animated:YES];
                    }
                        break;
                    case 6:
                    {
                        SMReviewsViewController *synopsisReviewsViewController;
                        
                        synopsisReviewsViewController = [[SMReviewsViewController alloc] initWithNibName:@"SMReviewsViewController" bundle:nil];
                        synopsisReviewsViewController.strFriendlyName =self.objSMSynopsisResult.strFriendlyName;
                        synopsisReviewsViewController.strYear=[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear];
                        synopsisReviewsViewController.strVariantID = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intVariantId];
                        synopsisReviewsViewController.strModelID = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intModelId];
                        
                        [self.navigationController pushViewController:synopsisReviewsViewController animated:YES];
                    }
                        break;
                    case 7:
                    {
                        SMOEMSpecsViewController *synopsisOEMSpecsViewController;
                        synopsisOEMSpecsViewController = [[SMOEMSpecsViewController alloc] initWithNibName:@"SMOEMSpecsViewController" bundle:nil];
                        synopsisOEMSpecsViewController.strVariantId = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intVariantId ];
                        synopsisOEMSpecsViewController.strYear =[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear ];
                        [self.navigationController pushViewController:synopsisOEMSpecsViewController animated:YES];
                    }
                        break;
                        
                    case 8:
                    {
                        SMSynopsisNewPricePlotterViewController *synopsisSMSynopsisNewPricePlotterViewController;
                        
                        synopsisSMSynopsisNewPricePlotterViewController = [[SMSynopsisNewPricePlotterViewController alloc] initWithNibName:@"SMSynopsisNewPricePlotterViewController" bundle:nil];
                        synopsisSMSynopsisNewPricePlotterViewController.strYear=[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear];
                        synopsisSMSynopsisNewPricePlotterViewController.strVariantID = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intVariantId];
                        
                        [self.navigationController pushViewController:synopsisSMSynopsisNewPricePlotterViewController animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }
    
    }
    else
    {
        switch (indexPath.section)
        {
            case 2:
            {
                SMDropDownObject *individualRowObj = (SMDropDownObject*)[objSimilarVehiclesBject.arrOfYearYoungerVehicles objectAtIndex:indexPath.row];
                [self updateSummaryForSimilarVehicle:individualRowObj];
                
            }
                break;
            case 3:
            {
                SMDropDownObject *individualRowObj = (SMDropDownObject*)[objSimilarVehiclesBject.arrOfOtherModelVehicles objectAtIndex:indexPath.row];
                 [self updateSummaryForSimilarVehicle:individualRowObj];
                
            }
                break;
            case 4:
            {
                SMDropDownObject *individualRowObj = (SMDropDownObject*)[objSimilarVehiclesBject.arrOfYearOlderVehicles objectAtIndex:indexPath.row];
                 [self updateSummaryForSimilarVehicle:individualRowObj];
                
            }
                break;

            case 6:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        
                        SMPricing_ValuationViewController *synopsisSMPricing_ValuationViewController;
                        
                        synopsisSMPricing_ValuationViewController = [[SMPricing_ValuationViewController alloc] initWithNibName:@"SMPricing_ValuationViewController" bundle:nil];
                        synopsisSMPricing_ValuationViewController.isValuation = NO;
                        synopsisSMPricing_ValuationViewController.strVehicleYear = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear];
                        synopsisSMPricing_ValuationViewController.strVehicleVariant = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intVariantId];
                        synopsisSMPricing_ValuationViewController.strVehicleName = self.objSMSynopsisResult.strFriendlyName;
                        synopsisSMPricing_ValuationViewController.strVehicleDetails = self.objSMSynopsisResult.strVariantDetails;
                        synopsisSMPricing_ValuationViewController.objSummary = self.objSMSynopsisResult;
                        [self.navigationController pushViewController:synopsisSMPricing_ValuationViewController animated:YES];
                    }
                        
                        break;

                    case 1:
                    {
                        SMSynopsisVerifyVINViewController *synopsisVerifyVINViewController;
                        
                        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                        {
                            synopsisVerifyVINViewController = [[SMSynopsisVerifyVINViewController alloc] initWithNibName:@"SMSynopsisVerifyVINViewController" bundle:nil];
                        }
                        else
                        {
                            synopsisVerifyVINViewController = [[SMSynopsisVerifyVINViewController alloc] initWithNibName:@"SMSynopsisVerifyVINViewController~ipad" bundle:nil];
                        }
                        synopsisVerifyVINViewController.strMainVehicleName = self.objSMSynopsisResult.strFriendlyName;
                        synopsisVerifyVINViewController.strMainVehicleYear = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear];
                        synopsisVerifyVINViewController.strSelectedVINNumber = self.objSMSynopsisResult.strVINNo;
                        synopsisVerifyVINViewController.strSelectedMMCode = self.objSMSynopsisResult.strMMCode;
                        synopsisVerifyVINViewController.strSelectedRegNo = self.objSMSynopsisResult.strRegNo;
                        synopsisVerifyVINViewController.strSelectedKiloMeters = self.objSMSynopsisResult.strKilometers;
                        synopsisVerifyVINViewController.previousPageNumber = 1;
                        [self.navigationController pushViewController:synopsisVerifyVINViewController animated:YES];
                    }
                        
                        break;
                        
                    case 2:
                    {
                        
                        SMVINHistoryViewController *synopsisVINHistoryViewController;
                        
                        synopsisVINHistoryViewController = [[SMVINHistoryViewController alloc] initWithNibName:@"SMVINHistoryViewController" bundle:nil];
                        synopsisVINHistoryViewController.strVehicleName =self.objSMSynopsisResult.strFriendlyName;
                        synopsisVINHistoryViewController.strYear=[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear];
                        synopsisVINHistoryViewController.strVINNo = self.objSMSynopsisResult.strVINNo;
                        [self.navigationController pushViewController:synopsisVINHistoryViewController animated:YES];
                    }
                        break;
                    case 3:
                    {
                        
                        SMSynopsisDoAppraisalViewController *synopsisDoAppraisalViewController;
                        
                        synopsisDoAppraisalViewController = [[SMSynopsisDoAppraisalViewController alloc] initWithNibName:@"SMSynopsisDoAppraisalViewController" bundle:nil];
                        
                        [self.navigationController pushViewController:synopsisDoAppraisalViewController animated:YES];
                    }
                        break;
                        
                    case 4:
                    {
                        
                        SMSynopsisSimilarVehiclesViewController *synopsisSimilarVehiclesViewController;
                        
                        synopsisSimilarVehiclesViewController = [[SMSynopsisSimilarVehiclesViewController alloc] initWithNibName:@"SMSynopsisSimilarVehiclesViewController" bundle:nil];
                        
                        [self.navigationController pushViewController:synopsisSimilarVehiclesViewController animated:YES];
                    }
                        break;
                        
                        
                    default:
                        break;
                }
                
            }
                break;
            case 7:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        SMSynopsisDemandViewController *synopsisDemandViewController;
                        
                        synopsisDemandViewController = [[SMSynopsisDemandViewController alloc] initWithNibName:@"SMSynopsisDemandViewController" bundle:nil];
                        
                        synopsisDemandViewController.strVariantID = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intVariantId ];
                        synopsisDemandViewController.strYear =[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear ];
                        [self.navigationController pushViewController:synopsisDemandViewController animated:YES];
                    }
                        break;
                        
                    case 1:
                    {
                        SMAvailabilityViewController *synopsisAvailabilityViewController;
                        
                        synopsisAvailabilityViewController = [[SMAvailabilityViewController alloc] initWithNibName:@"SMAvailabilityViewController" bundle:nil];
                        synopsisAvailabilityViewController.strModelID = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intModelId];
                        synopsisAvailabilityViewController.strYear =[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear ];
                        synopsisAvailabilityViewController.strModelName=self.objSMSynopsisResult.strModelName;
                        [self.navigationController pushViewController:synopsisAvailabilityViewController animated:YES];
                    }
                        break;
                    case 2:
                    {
                        SMSynopsisAverageDaysViewController *synopsisAverageDaysViewController;
                        
                        synopsisAverageDaysViewController = [[SMSynopsisAverageDaysViewController alloc] initWithNibName:@"SMSynopsisAverageDaysViewController" bundle:nil];
                        
                        synopsisAverageDaysViewController.strModelID = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intModelId];
                        synopsisAverageDaysViewController.strYear =[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear ];
                        
                        [self.navigationController pushViewController:synopsisAverageDaysViewController animated:YES];
                    }
                        break;
                    case 3:
                    {
                        SMSalesHistoryViewController *synopsisSMSalesHistoryViewController;
                        
                        synopsisSMSalesHistoryViewController = [[SMSalesHistoryViewController alloc] initWithNibName:@"SMSalesHistoryViewController" bundle:nil];
                        synopsisSMSalesHistoryViewController.strModelName = self.objSMSynopsisResult.strModelName;
                        synopsisSMSalesHistoryViewController.strModelName = self.objSMSynopsisResult.strModelName;
                        synopsisSMSalesHistoryViewController.strYear =[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear ];
                        synopsisSMSalesHistoryViewController.strVariantId = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intVariantId];
                        [self.navigationController pushViewController:synopsisSMSalesHistoryViewController animated:YES];
                    }
                        break;
                    case 4:
                    {
                        SMLeadPoolViewController *synopsisLeadPoolViewController;
                        
                        synopsisLeadPoolViewController = [[SMLeadPoolViewController alloc] initWithNibName:@"SMLeadPoolViewController" bundle:nil];
                        synopsisLeadPoolViewController.strYear=[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear];
                        synopsisLeadPoolViewController.strVariantID = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intVariantId];
                        synopsisLeadPoolViewController.strModelId = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intModelId];
                        synopsisLeadPoolViewController.strModelName = self.objSMSynopsisResult.strModelName;
                        [self.navigationController pushViewController:synopsisLeadPoolViewController animated:YES];
                    }
                        break;
                    case 6:
                    {
                        SMReviewsViewController *synopsisReviewsViewController;
                        
                        synopsisReviewsViewController = [[SMReviewsViewController alloc] initWithNibName:@"SMReviewsViewController" bundle:nil];
                        synopsisReviewsViewController.strFriendlyName =self.objSMSynopsisResult.strFriendlyName;
                        synopsisReviewsViewController.strYear=[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear];
                        synopsisReviewsViewController.strVariantID = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intVariantId];
                        synopsisReviewsViewController.strModelID = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intModelId];
                        
                        [self.navigationController pushViewController:synopsisReviewsViewController animated:YES];
                    }
                        break;
                    case 7:
                    {
                        SMOEMSpecsViewController *synopsisOEMSpecsViewController;
                        synopsisOEMSpecsViewController = [[SMOEMSpecsViewController alloc] initWithNibName:@"SMOEMSpecsViewController" bundle:nil];
                        synopsisOEMSpecsViewController.strVariantId = [NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intVariantId ];
                        synopsisOEMSpecsViewController.strYear =[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear ];
                        [self.navigationController pushViewController:synopsisOEMSpecsViewController animated:YES];
                    }
                        break;
                        
                    case 8:
                    {
                        SMSynopsisNewPricePlotterViewController *synopsisSMSynopsisNewPricePlotterViewController;
                        
                        synopsisSMSynopsisNewPricePlotterViewController = [[SMSynopsisNewPricePlotterViewController alloc] initWithNibName:@"SMSynopsisNewPricePlotterViewController" bundle:nil];
                        synopsisSMSynopsisNewPricePlotterViewController.strYear=[NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intYear];
                        synopsisSMSynopsisNewPricePlotterViewController.strVariantID = [NSString stringWithFormat:@"%d", self.objSMSynopsisResult.intVariantId];
                        
                        [self.navigationController pushViewController:synopsisSMSynopsisNewPricePlotterViewController animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }
    
    }
    
    
}
-(void)setAttributeStringOnUILabel:(UILabel *)label andRangeOfString:(NSString*)string{
    
    label.textColor = [UIColor whiteColor];
    NSRange range1 = [label.text rangeOfString:string];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:label.text];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:14]}range:range1];
    }
    else
    {
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad]}range:range1];
    }
    
    label.attributedText = attributedText;
}

-(void)setAttributeStringOnCell:(SMSynopsisSummary2Cell *)cellObj andRangeOfString:(NSString*)string{
    
    cellObj.titleLabel.textColor = [UIColor whiteColor];
    NSRange range1 = [cellObj.titleLabel.text rangeOfString:string];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:cellObj.titleLabel.text];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone]}range:range1];
    }
    else
    {
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad]}range:range1];
    }
    
    cellObj.titleLabel.attributedText = attributedText;
}

#pragma mark - WEB Services


-(void) loadMake
{
    if([selectedYear length] == 0)
    {
        NSDateFormatter *formatter       = [[NSDateFormatter alloc] init];
        [formatter         setDateFormat:@"yyyy"];
        selectedYear     = [formatter stringFromDate:[NSDate date]];
        
    }
    
    
    [arrmForCondition removeAllObjects];
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllMakevaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:selectedYear];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    // self.txtYear.text
    
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


-(void)getTheSynopsisDetailsFromIXCode
{
    
    NSMutableURLRequest *requestURL=[SMWebServices getSynopsisSummaryByIxCodeWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:0 andiXCode:@""];
    
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
             
             
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
    
}


-(void)getTheSynopsisDetails
{
    if([selectedYear length] == 0)
    {
        NSDateFormatter *formatter       = [[NSDateFormatter alloc] init];
        [formatter         setDateFormat:@"yyyy"];
        selectedYear     = [formatter stringFromDate:[NSDate date]];
        
    }
    
    
   UITextField *makeTextField = (UITextField*)[self.view viewWithTag:222];
    UITextField *modelTextField = (UITextField*)[self.view viewWithTag:333];
   UITextField *variantTextField = (UITextField*)[self.view viewWithTag:444];
    
    if ([makeTextField.text isEqualToString:@""]) {
        SMAlert(@"Smart Manager", KMakeSelection);
    }
    else if ([modelTextField.text isEqualToString:@""])
    {
        SMAlert(@"Smart Manager", KModelSelection);
    }else if ([variantTextField.text isEqualToString:@""]){
        SMAlert(@"Smart Manager", KVariantSelection);
    }
    else
    {
        [self getSynopsisDetailOnUpdate];
    }
   
    
}

-(void)loadTransUnionPricing
{
    
   // NSMutableURLRequest *requestURL=[SMWebServices loadTransUnionPricing:[SMGlobalClass sharedInstance].hashValue andVINNum:@"WAUZZZ8K3FA087643" andYear:@"2015" andRegNumber:@"ND805214" andMMCode:@"04042131" andMileage:@"41000"];
    //self.objSMSynopsisResult.strMMCode
    if([self.objSMSynopsisResult.strVINNo isEqualToString:@"No VIN loaded"])
    {
        self.objSMSynopsisResult.strVINNo = @"";
    }
    
    NSMutableURLRequest *requestURL=[SMWebServices loadTransUnionPricing:[SMGlobalClass sharedInstance].hashValue andVINNum:self.objSMSynopsisResult.strVINNo andYear:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear] andRegNumber:@"" andMMCode:self.objSMSynopsisResult.strMMCode andMileage:self.objSMSynopsisResult.strKilometers];
    
       [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    //"WAUZZZ8K3FA087643", "2015", "ND805214", "04042131", 41000)
  
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
             
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
    
}

-(void)loadAppraisalInfoWithVIN:(NSString*) vinNumber
{
    
    NSMutableURLRequest *requestURL=[SMWebServices loadAppraisalInfo:[SMGlobalClass sharedInstance].hashValue andVIN:vinNumber andClientID:1];
    
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
             
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
    
}



#pragma mark - Web Services
-(void) getSimilarVehicles{
    
    NSMutableURLRequest *requestURL= [SMWebServices getSimilarVehiclesWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear] andVariantID:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intVariantId]];
    
   // objSMSimilarVehicleXmlObject = [[SMSimilarVehicleXmlObject alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSSimilarVehicle  *wsSMWSSimilarVehicle = [[SMWSSimilarVehicle alloc]init];
    
    [wsSMWSSimilarVehicle responseForWebServiceForReuest:requestURL
                                                response:^(SMSimilarVehicleXmlObject *objSMSimilarVehicleXmlObjectResult) {
                                                    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                    [self hideProgressHUD];
                                                    switch (objSMSimilarVehicleXmlObjectResult.iStatus) {
                                                            
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
                                                            objSimilarVehiclesBject = objSMSimilarVehicleXmlObjectResult;
                                                             [self setTheLabelCountText:(int)objSimilarVehiclesBject.arrOfYearYoungerVehicles.count forLabel:lblCountYearYounger];
                                                             [self setTheLabelCountText:(int)objSimilarVehiclesBject.arrOfOtherModelVehicles.count forLabel:lblCountOtherModels];
                                                             [self setTheLabelCountText:(int)objSimilarVehiclesBject.arrOfYearOlderVehicles.count forLabel:lblCountYearOlder];
                                                            [tblSynopsisSummaryTableView reloadData];
                                                        }
                                                            break;
                                                            
                                                        default:
                                                            break;
                                                    }
                                                    
                                                    
                                                }
                                                andError: ^(NSError *error) {
                                                    SMAlert(@"Error", error.localizedDescription);
                                                    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                    [self hideProgressHUD];
                                                }
     ];
    
}


-(void) webserviceIsGivenVINVerified
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    NSMutableURLRequest * requestURL;
    
     if([self.objSMSynopsisResult.strVINNo isEqualToString:@"No VIN loaded"])
         requestURL = [SMWebServices isGivenVINVerifiedWithUserHash:[SMGlobalClass sharedInstance].hashValue andVIN:@""];
    else
        requestURL = [SMWebServices isGivenVINVerifiedWithUserHash:[SMGlobalClass sharedInstance].hashValue andVIN:self.objSMSynopsisResult.strVINNo];
    
    
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
                                                
                                                xmlParser = [[NSXMLParser alloc] initWithData:data];
                                                [xmlParser setDelegate:self];
                                                [xmlParser setShouldResolveExternalEntities:YES];
                                                [xmlParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
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
        loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
    }
    if ([elementName isEqualToString:@"ListModelsJSONResult"])
    {
        ObjectDropDownObject=[[SMDropDownObject alloc]init];
    }
    if ([elementName isEqualToString:@"ListVariantsJSONResult"])
    {
        loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
    }
    if ([elementName isEqualToString:@"GetSynopsisXmlResponse"]) {
        objUpdateSMSynopsisResult = [[SMSynopsisXMLResultObject alloc]init];
        objUpdateSMSynopsisResult.arrmDemandSummary = [[NSMutableArray alloc ] init];
        objUpdateSMSynopsisResult.arrmAverageAvailableSummary = [[NSMutableArray alloc ] init];
        objUpdateSMSynopsisResult.arrmAverageDaysInStockSummary = [[NSMutableArray alloc ] init];
        objUpdateSMSynopsisResult.arrmLeadPoolSummary = [[NSMutableArray alloc ] init];
        objUpdateSMSynopsisResult.arrmWarrantySummary = [[NSMutableArray alloc ] init];
        
    }
    if ([elementName isEqualToString:@"VariantDetails"])
    {
        objUpdateSMSynopsisResult.arrVariantDetails = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < 6; ++i)
        {
            [objUpdateSMSynopsisResult.arrVariantDetails addObject:@""];
        }
        
        //[arrVariantDetails replaceObjectAtIndex:0 withObject:object];
        //[arrVariantDetails replaceObjectAtIndex:3 withObject:object];
        NSLog(@"Did enter hereg...");
    }
    
    if ([elementName isEqualToString:@"SummaryItem"]) {
        objUpdateSMSummeryObject = [[SMSummaryObject alloc]init];
        
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
    
    if ([elementName isEqualToString:@"Appraisal"])
    {
        SMSynopsisDoAppraisalViewController *synopsisDoAppraisalViewController;
        
        synopsisDoAppraisalViewController = [[SMSynopsisDoAppraisalViewController alloc] initWithNibName:@"SMSynopsisDoAppraisalViewController" bundle:nil];
        
        [self.navigationController pushViewController:synopsisDoAppraisalViewController animated:YES];
    }
    
    if ([elementName isEqualToString:@"TradePrice"])
    {
        self.objSMSynopsisResult.pricingTUATradePrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"RetailPrice"])
    {
        self.objSMSynopsisResult.pricingTUARetailPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"SearchDateTime"])
    {
        self.objSMSynopsisResult.strTUASearchDateTime = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Error"])
    {
        
    }
    if ([elementName isEqualToString:@"LoadTransUnionPricingResult"])
    {
        if([currentNodeContent containsString:@"VehicleCode Validation Failed"])
        {
            SMAlert(@"Smart Manager", @"No pricing available for this vehicle's M&M code");
            return;
        }
        
        SMSynopsisSummaryCell *cellObj;
        
        if(!isChangeVechileExpand)
            cellObj = (SMSynopsisSummaryCell*)[tblSynopsisSummaryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        else
            cellObj = (SMSynopsisSummaryCell*)[tblSynopsisSummaryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:6]];
        
        if([self.objSMSynopsisResult.strTUASearchDateTime length] != 0)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            
            NSDate *requiredDate1 = [dateFormatter dateFromString:self.objSMSynopsisResult.strTUASearchDateTime];
            
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            [dateFormatter1 setDateFormat:@"dd MMM yyyy"];
            
            NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:requiredDate1]];
            cellObj.lblTUAPriceCheck.text = [NSString stringWithFormat:@"TUA price check: %@",textDate];
        }
        else
        {
            
            cellObj.lblTUAPriceCheck.text = @"TUA price check: Date?";
        }
        [cellObj.lblTUAPriceCheck sizeToFit];
   
        cellObj.lblRetail.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingTUARetailPrice];
        cellObj.lblTrade.text = [NSString stringWithFormat:@"%@",self.objSMSynopsisResult.pricingTUATradePrice];
    
    }


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
                loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
                loadVehiclesObject.strMakeId   = dictionary[@"makeID"];
                loadVehiclesObject.strMakeName = dictionary[@"makeName"];
               // ObjectDropDownObject.strSortText = dictionary[@"makeName"];
                
               // ObjectDropDownObject.strSortTextID = ((int)[arrmForMake count] + 1);
                [arrmForMake addObject:loadVehiclesObject];
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
    
    if ([elementName isEqualToString:@"ListMakesJSONResponse"])
    {
        if (arrmForMake.count!=0)
        {
            
            [searchMakeVC getTheDropDownData:arrmForMake];
            [self.view addSubview:searchMakeVC];
            
            [SMReusableSearchTableViewController getTheSelectedSearchDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                
                
                
                UITextField *makeTField = (UITextField*)[self.view viewWithTag:222];
                UITextField *modelTField = (UITextField*)[self.view viewWithTag:333];
                UITextField *variantTField = (UITextField*)[self.view viewWithTag:444];
                
                modelTField.text = @"";
                variantTField.text = @"";
                makeTField.text = selectedTextValue;
                
                selectedMakeId = selectIDValue;
            }];
            
            
            
            [self hideProgressHUD];
        }
    }
    if ([elementName isEqualToString:@"ListModelsJSONResponse"])
    {
        if (arrmForModel.count!=0)
        {
            
            //modelArray.count>0 ?[self loadPopup]:SMAlert(KLoaderTitle,KNorecordsFousnt);
            
            /*************  your Request *******************************************************/
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:arrmForModel withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/
            
            
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                
                UITextField *modelTField = (UITextField*)[self.view viewWithTag:333];
                UITextField *variantTField = (UITextField*)[self.view viewWithTag:444];
                
                modelTField.text = selectedTextValue;
                variantTField.text = @"";
                
                
                selectedModelId = selectIDValue;
            }];
            
            
            [self hideProgressHUD];
        }
    }
    
    if ([elementName isEqualToString:@"ListVariantsJSONResponse"])
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
                
                vehicleVariantSelected = selectIDValue;
                
                UITextField *variantTField = (UITextField*)[self.view viewWithTag:444];
                
                variantTField.text = selectedTextValue;
                
                
            }];
            
            
            [self hideProgressHUD];
        }
    }
    
  ///////////////////////////   UPDATE  //////////////////////////////////////////////////////////////
    
    if ([elementName isEqualToString:@"ImageUrl"]) {
        
        objUpdateSMSynopsisResult.strVariantImage = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Year"]) {
        
        objUpdateSMSynopsisResult.intYear = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"MakeId"]) {
        objUpdateSMSynopsisResult.intMakeId = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"ModelId"]) {
        objUpdateSMSynopsisResult.intModelId = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"VariantId"]) {
        objUpdateSMSynopsisResult.intVariantId = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"MakeName"]) {
        objUpdateSMSynopsisResult.strMakeName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ModelName"]) {
        objUpdateSMSynopsisResult.strModelName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"VariantName"]) {
        objUpdateSMSynopsisResult.strVariantName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"FriendlyName"]) {
        objUpdateSMSynopsisResult.strFriendlyName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MMCode"]) {
        objUpdateSMSynopsisResult.strMMCode = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Transmission"]) {
        objUpdateSMSynopsisResult.strTransmission = currentNodeContent;
    }
    if ([elementName isEqualToString:@"StartDate"]) {
        objUpdateSMSynopsisResult.strStartDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"EndDate"]) {
        objUpdateSMSynopsisResult.strEndDate = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"VariantDetails"])
    {
        if([currentNodeContent length] == 0)
            objUpdateSMSynopsisResult.arrVariantDetails = nil;
    }
    
    if ([elementName isEqualToString:@"Gears"]) {
        objUpdateSMSynopsisResult.intGears = [currentNodeContent intValue];
    }
    
    
    if ([elementName isEqualToString:@"Fuel_Type"])
    {
        [objUpdateSMSynopsisResult.arrVariantDetails replaceObjectAtIndex:3 withObject:currentNodeContent];
    }
    if ([elementName isEqualToString:@"Power_KW"])
    {
        [objUpdateSMSynopsisResult.arrVariantDetails replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@ kW",currentNodeContent]];
    }
    if ([elementName isEqualToString:@"Torque_NM"])
    {
        [objUpdateSMSynopsisResult.arrVariantDetails replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@ Nm",currentNodeContent]];
    }
    if ([elementName isEqualToString:@"Engine_CC"])
    {
        [objUpdateSMSynopsisResult.arrVariantDetails replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@ cc",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent]]];
    }
    if ([elementName isEqualToString:@"Transmission_Type"])
    {
        objUpdateSMSynopsisResult.strGearbox = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"Gears"]) {
        objUpdateSMSynopsisResult.intGears = [currentNodeContent intValue];
        
        NSString *strValue = [NSString stringWithFormat:@"%@",objUpdateSMSynopsisResult.strGearbox];
        if ([strValue isEqualToString:@"(null)"]) {
            [objUpdateSMSynopsisResult.arrVariantDetails replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%d gears",objUpdateSMSynopsisResult.intGears]];
        }
        else{
            [objUpdateSMSynopsisResult.arrVariantDetails replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@, %d gears",objUpdateSMSynopsisResult.strGearbox,objUpdateSMSynopsisResult.intGears]];
        }
    }
    
    if ([elementName isEqualToString:@"Sources"]) {
        objUpdateSMSynopsisResult.intSources = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"AverageTradePrice"]) {
        objUpdateSMSynopsisResult.floatAverageTradePrice = [currentNodeContent floatValue];
    }
    if ([elementName isEqualToString:@"AveragePrice"]) {
        objUpdateSMSynopsisResult.floatAveragePrice = [currentNodeContent floatValue];
    }
    if ([elementName isEqualToString:@"MarketPrice"]) {
        objUpdateSMSynopsisResult.floatMarketPrice = [currentNodeContent floatValue];
    }
    if ([elementName isEqualToString:@"Value"]) {
        objUpdateSMSummeryObject.intValue = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"Area"]) {
        objUpdateSMSummeryObject.strArea = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Type"]) {
        objUpdateSMSummeryObject.strType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SummaryItem"]) {
        [arrmTemp addObject:objUpdateSMSummeryObject];
    }
    if ([elementName isEqualToString:@"DemandSummary"]) {
        [objUpdateSMSynopsisResult.arrmDemandSummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"AverageAvailableSummary"]) {
        [objUpdateSMSynopsisResult.arrmAverageAvailableSummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"AverageDaysInStockSummary"]) {
        [objUpdateSMSynopsisResult.arrmAverageDaysInStockSummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"LeadPoolSummary"]) {
        [objUpdateSMSynopsisResult.arrmLeadPoolSummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"WarrantySummary"]) {
        [objUpdateSMSynopsisResult.arrmWarrantySummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"ReviewCount"]) {
        objUpdateSMSynopsisResult.intReviewCount = [currentNodeContent intValue];
    }
    
    if ([elementName isEqualToString:@"GetSynopsisXmlResponse"]) {
        
        [self hideProgressHUD];
        
        self.objSMSynopsisResult = objUpdateSMSynopsisResult;
        self.objSMSynopsisResult.intVariantId = vehicleVariantSelected;
        
        NSMutableString *teststring = [[NSMutableString alloc]init];
        for (SMSummaryObject *objSMSummeryObject in self.objSMSynopsisResult.arrmDemandSummary) {
            
            [teststring appendString:[NSString stringWithFormat:@"%@ : %d |",objSMSummeryObject.strArea,objSMSummeryObject.intValue]];
            [teststring appendString:@" "];
            
            
            NSLog(@"%@",teststring);
            strDemandSummary = teststring;
        }
        
        
        NSMutableString *teststring1 = [[NSMutableString alloc]init];
        
        for (SMSummaryObject *objSMSummeryObject in self.objSMSynopsisResult.arrmAverageAvailableSummary) {
            
            [teststring1 appendString:[NSString stringWithFormat:@"%@ : %d",objSMSummeryObject.strArea,objSMSummeryObject.intValue]];
            [teststring1 appendString:@" "];
            
            NSLog(@"%@",teststring1);
            strAverageAvailableSummary = teststring1;
        }
        
        NSMutableString *teststring2 = [[NSMutableString alloc]init];
        for (SMSummaryObject *objSMSummeryObject in self.objSMSynopsisResult.arrmAverageDaysInStockSummary) {
            
            
            
            [teststring2 appendString:[NSString stringWithFormat:@"%@ : %d",objSMSummeryObject.strArea,objSMSummeryObject.intValue]];
            [teststring2 appendString:@" "];
            
            NSLog(@"%@",teststring2);
            strAverageDaysInStockSummary = teststring2;
        }
        
        NSMutableString *teststring3 = [[NSMutableString alloc]init];
        for (SMSummaryObject *objSMSummeryObject in self.objSMSynopsisResult.arrmLeadPoolSummary)
        {
            if(self.objSMSynopsisResult.arrmLeadPoolSummary.count == 0)
                strLeadPoolSummary = @"N/A";
            else
            {
            [teststring3 appendString:[NSString stringWithFormat:@"%@ : %d",objSMSummeryObject.strArea,objSMSummeryObject.intValue]];
            [teststring3 appendString:@" "];
            
            NSLog(@"%@",teststring3);
            strLeadPoolSummary = teststring3;
            }
        }
        
        [self hideProgressHUD];
        tblSynopsisSummaryTableView.dataSource = self;
        tblSynopsisSummaryTableView.delegate = self;
        [tblSynopsisSummaryTableView reloadData];

        
    }
    
    if ([elementName isEqualToString:@"StartDate"])
    {
        startDate = currentNodeContent;
        
    }
    if ([elementName isEqualToString:@"EndDate"])
    {
        endDate = currentNodeContent;
    }
    if([elementName isEqualToString:@"Verified"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Do stuff to UI
            if(currentNodeContent.boolValue == false)
            {
                SMSynopsisSummary2Cell *cellToUpdate = (SMSynopsisSummary2Cell*)[tblSynopsisSummaryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
                
                cellToUpdate.titleLabel.text = [NSString stringWithFormat:@"Verify VIN  %@ \u2718",self.objSMSynopsisResult.strVINNo];
                
                [self setAttributeStringOnCell:cellToUpdate andRangeOfString:@"Verify VIN "];
                
            }
            else
            {
                SMSynopsisSummary2Cell *cellToUpdate = (SMSynopsisSummary2Cell*)[tblSynopsisSummaryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
                
                cellToUpdate.titleLabel.text = [NSString stringWithFormat:@"Verify VIN  %@ \u2713",self.objSMSynopsisResult.strVINNo];
                
                [self setAttributeStringOnCell:cellToUpdate andRangeOfString:@"Verify VIN "];
            }
            //oldTableViewHeight = tblSMSendOffer.contentSize.height;
            
            [HUD hide:YES];
        });

    }
    
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
      
//    [self hideProgressHUD];
//    tblSynopsisSummaryTableView.dataSource = self;
//    tblSynopsisSummaryTableView.delegate = self;
//    [tblSynopsisSummaryTableView reloadData];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(NSString*)returnTheExpectedDateForGivenString:(NSString*)inputString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *requiredDate1 = [dateFormatter dateFromString:inputString];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MMM yyyy"];
    NSString *finalDate = [NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:requiredDate1]];
    return finalDate;
    
    
}

- (void)btnUpdateDidClicked:(id)sender
{
    [self getTheSynopsisDetails];
}

-(void)btnFetchPricingDidClicked{
    
    isbtnFetchPricingDidClicked = YES;
    [tblSynopsisSummaryTableView reloadData];
    
}

-(void)btnUpdatePricingDidClicked{
    
    UIAlertController *altForgetPassword = [UIAlertController
                                            alertControllerWithTitle:kTitle
                                            message:kAlertUpdatePricing
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [altForgetPassword addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    [altForgetPassword addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [self loadTransUnionPricing];
    }]];
    
   
    
    [self presentViewController:altForgetPassword animated:YES completion:nil];
    
    
}



-(void) displayAlertForScanVIN
{
    UIAlertController * alert = [UIAlertController
                             alertControllerWithTitle:KLoaderTitle
                             message:@"The vehicle has no VIN number. Please scan the VIN to proceed."
                             preferredStyle:UIAlertControllerStyleAlert];

//Add Buttons

UIAlertAction* yesButton = [UIAlertAction
                            actionWithTitle:@"Cancel"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action) {}];

UIAlertAction* noButton = [UIAlertAction
                           actionWithTitle:@"Scan VIN"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               
                               //Handle your yes please button action here
                               
                               SMCustomerDLScanViewController *scanObject = [[SMCustomerDLScanViewController alloc] initWithNibName:@"SMCustomerDLScanViewController" bundle:nil];
                               
                               scanObject.isComingFromStockAudit = NO;
                               scanObject.isComingFromSynopsis = YES;
                               scanObject.strFromViewController  = @"SMSynopsisSummaryViewController";
                               [self.navigationController pushViewController:scanObject animated:YES];
                           }];

//Add your buttons to alert controller

[alert addAction:yesButton];
[alert addAction:noButton];

[self presentViewController:alert animated:YES completion:nil];

}


#pragma mark - Text Field Delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
        case 111: {
            
            [self.view endEditing:YES];
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            [popUpView getTheDropDownData:[SMAttributeStringFormatObject getYear] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:YES]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                selectedYear = selectedTextValue;
                
                textField.text = selectedTextValue;
                
                // UITextField *txtYear = (UITextField*)[self.view viewWithTag:20];
               // UITextField *txtMake = (UITextField*)[self.view viewWithTag:20];
               // UITextField *txtModel = (UITextField*)[self.view viewWithTag:30];
              //  UITextField *txtVariant = (UITextField*)[self.view viewWithTag:40];
                
                UITextField *txtYear = (UITextField*)[self.view viewWithTag:111];
                UITextField *txtMake = (UITextField*)[self.view viewWithTag:222];
                UITextField *txtModel = (UITextField*)[self.view viewWithTag:333];
                UITextField *txtVariant = (UITextField*)[self.view viewWithTag:444];
                
                txtYear.text = selectedYear;
                txtMake.text = @"";
                txtModel.text = @"";
                txtVariant.text = @"";

                //selectedMakeId = selectIDValue;
            }];
            
                       /*************  your Response *******************************************************/
            
        }
            break;
            
        case 222:{
            
            [self.view endEditing:YES];
            [textField resignFirstResponder];
            [self loadMake];
            
            
        }
            break;
            
        case 333: {
            [self.view endEditing:YES];
            [textField resignFirstResponder];
            [self loadModelsListing];
            
        }
            break;
            
        case 444:
        {
            [self.view endEditing:YES];
            [textField resignFirstResponder];
            [self loadVarientsListing];
            
            
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

- (NSArray *)textFieldInRow:(NSUInteger)row section:(NSUInteger)section
{
    //return [[[[tblSynopsisSummaryTableView cellForRowAtIndexPath:
    //[NSIndexPath indexPathForRow:(NSInteger)row inSection:(NSInteger)section]]
    // contentView] subviews] objectAtIndex:0];
    
    return [[[tblSynopsisSummaryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)row inSection:(NSInteger)section]]contentView]subviews];
    
    
}

#pragma mark - FGalleryViewController Delegate Method
-(void)btnImageGalleryDidClicked{
    
    networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
    appdelegate.isPresented =  YES;
    [self.navigationController pushViewController:networkGallery animated:YES];
}

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    
    
    return 1;
    //    if(gallery == networkGallery)
    //    {
    //        int num;
    //
    //        num = (int)[arrayFullImages count];
    //
    //        return num;
    //    }
    //    else
    //        return 0;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    //    if( gallery == networkGallery )
    //    {
    //        caption = [networkCaptions objectAtIndex:index];
    //    }
    caption = self.objSMSynopsisResult.strVariantImage;
    return @"";
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    return self.objSMSynopsisResult.strVariantImage;
}

-(void)updateSummaryForSimilarVehicle:(SMDropDownObject *)objSimilarVehicle{
    
    
    selectedYear = objSimilarVehicle.strMinYear;
    vehicleVariantSelected = objSimilarVehicle.strMakeId.intValue;//it is variant for similar vehicle because no new object created(SMdropdown used).
    
    selectedMakeId = self.objSMSynopsisResult.intMakeId;
    selectedModelId = self.objSMSynopsisResult.intModelId;
    [self getSynopsisDetailOnUpdate];
}

-(void)getSynopsisDetailOnUpdate
{
    NSMutableURLRequest *requestURL=[SMWebServices getSynopsisSummaryWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:selectedYear.intValue andMakeId:selectedMakeId andModelId:selectedModelId andVariantId:vehicleVariantSelected andVIN:self.objSMSynopsisResult.strVINNo andKiloMeters:self.objSMSynopsisResult.strKilometers andExtrasCost:self.objSMSynopsisResult.strExtras andCondition:self.objSMSynopsisResult.strCondition];
    
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
                isChangeVechileExpand = NO;
                 [ section0View.imgArrowDown setImage:[UIImage imageNamed:@"down_arrowT"]];
                isYearYoungerSectionExpanded = NO;
                isYearOlderSectionExpanded = NO;
                isOtherModelsSectionExpanded = NO;
                

                self.objSMSynopsisResult = objSMSynopsisXMLResultObject;
                self.objSMSynopsisResult.intVariantId = vehicleVariantSelected;
                [tblSynopsisSummaryTableView reloadData];
                [self getSimilarVehicles];
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

//SMChangeVehicleViewCell *cellObj=[tableView dequeueReusableCellWithIdentifier:cellidSection0];
#pragma mark - Set Attributed Text

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
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
    
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

-(void)setTheLabelCountText:(int)lblCount forLabel:(UILabel*) countLbl
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
    
      float widthWithPadding;
      widthWithPadding = countLbl.frame.size.width + 12.0;
      [countLbl setFrame:CGRectMake(xAxisCount, countLbl.frame.origin.y, widthWithPadding, countLbl.frame.size.height)];
}




@end
