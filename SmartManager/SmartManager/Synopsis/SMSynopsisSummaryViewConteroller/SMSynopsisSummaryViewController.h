//
//  SMSynopsisSummaryViewController.h
//  Smart Manager
//
//  Created by Sandeep on 19/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTableSectionView.h"
#import "SMSynopsisSummaryCell.h"
#import "SMWarrantyServiceCell.h"
#import "SMSaveAppraisalsViewController.h"
#import "SMSMSynopsisTableHeaderCell.h"
#import "MBProgressHUD.h"
#import "SMSynopsisXMLResultObject.h"

@interface SMSynopsisSummaryViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,MBProgressHUDDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    // liji..
    SMTableSectionView *sectionYearYoungerView;
    SMTableSectionView *sectionOtherModelsView;
    SMTableSectionView *sectionYearOlderView;
    SMTableSectionView *sectionManualSelectionView;
    SMTableSectionView *section0View;
    SMTableSectionView *section2View;
    
    UILabel *lblCountYearYounger;
    UILabel *lblCountOtherModels;
    UILabel *lblCountYearOlder;
    
    BOOL isChangeVechileExpand;
    BOOL isYearYoungerSectionExpanded;
    BOOL isOtherModelsSectionExpanded;
    BOOL isYearOlderSectionExpanded;
    BOOL isManualSelectionSectionExpanded;
    BOOL isExtraSelectedVechileExpand;
    BOOL isVehicleChanged;
    
    
    IBOutlet UITableView *tblSynopsisSummaryTableView;
    
    NSMutableString *currentNodeContent;
    //---web service access---
    NSMutableString *soapResults;
    //---xml parsing---
    NSXMLParser *xmlParser;
    
    int selectedMakeId;
    int selectedModelId;
    NSString *selectedYear;
    
    NSString *imageUrl;
    
    NSString *startDate;
    NSString *endDate;
    NSString *dateRange;
    NSString *vehicleImageUrl;

    NSMutableArray *arrmTemp;
    
    int vehicleVariantSelected;
    BOOL isFirstWarrantySectionEmpty;
    BOOL isSecondWattantySectionEmpty;
    
}

@property(strong,nonatomic) NSString *selectedYear;
@property(assign) int selectedMake;
@property(assign) int selectedModel;
@property(assign) int selectedVariant;
@property(strong,nonatomic) SMSynopsisXMLResultObject *objSMSynopsisResult;

@end
