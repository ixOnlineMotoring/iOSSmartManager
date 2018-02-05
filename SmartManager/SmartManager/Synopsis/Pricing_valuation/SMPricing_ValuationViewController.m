//
//  SMPricing_ValuationViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 20/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMPricing_ValuationViewController.h"
#import "SMCustomLabelAutolayout.h"
#import "SMPricing_ValuationHeaderView.h"
#import "SMVerifyVIN_ModelVariantCell.h"
#import "SMCustomColor.h"
#import "SMSimpleLogicViewController.h"
#import "SMRealTimeOnlineViewController.h"
#import "SMPricingGraphViewController.h"
#import "SMPricingCell.h"
#import "Fontclass.h"
#import "SMPricingHeader1.h"
#import "SMValuationDetailsObj.h"
#import "SMCustomTextField.h"
#import "SMCustomTextFieldForDropDown.h"
#import "SMDropDownObject.h"



#define ACCEPTABLE_CHARACTERS_NumberMinus @"0123456789-"
#define ACCEPTABLE_CHARACTERS_NumberOnly @"0123456789"


@interface SMPricing_ValuationViewController ()
{
     MBProgressHUD *HUD;
    
    IBOutlet UITableView *tblPricing_valuation;
    IBOutlet UIView *viewHeaderTable;
    IBOutlet UIView *viewValuation;
    IBOutlet SMCustomLabelAutolayout *lblNameYear;
    IBOutlet SMCustomLabelAutolayout *lblDetail;
    IBOutlet SMCustomLabelAutolayout *lblRetailHeader;
    BOOL isExpandTruUnion;
    BOOL isExpandLightStone;
    NSInteger intShowCellsForSection;
    SMValuationDetailsObj *valuationObject;
    NSString *strTransUnionTrade,*strTransUnionMarket,*strTransUnionRetail;
    NSString *resultString;
    NSMutableArray *arrmConditions;
    SMDropDownObject *conditionObj;
    
    IBOutlet UILabel *lblAvgRetailValue;
    
    IBOutlet UILabel *lblRetailConditionValue;
    
    IBOutlet UILabel *lblRetailExtrasValue;
    
    IBOutlet UILabel *lblRetailKilometerValue;
    
    IBOutlet UILabel *lblRetailOtherValue;
    
    IBOutlet SMCustomLabelAutolayout *lblAnticipatedRetailValue;
    
    IBOutlet UILabel *lblAvgTradeValue;
    
    IBOutlet UILabel *lblOfferConditionValue;
    
    IBOutlet UILabel *lblOfferExtrasValue;
    
    IBOutlet UILabel *lblOfferKilometersValue;
    
    IBOutlet UILabel *lblOfferInteriorValue;
    
    IBOutlet UILabel *lblOfferEngineValue;
    
    IBOutlet UILabel *lblOfferExteriorValue;
    
    IBOutlet UILabel *lblOfferOtherValue;
    
    IBOutlet SMCustomTextField *txtFieldAvgRetail;
    
    IBOutlet SMCustomTextFieldForDropDown *txtFieldRetailCondition;
    
    IBOutlet SMCustomTextField *txtFieldRetailExtras;
    
    IBOutlet SMCustomTextField *txtFieldRetailKilometers;
    
    IBOutlet SMCustomTextField *txtFieldRetailOthers;
    
    IBOutlet SMCustomTextField *txtFieldAvgTrade;
    
    IBOutlet SMCustomTextFieldForDropDown *txtFieldOfferCondition;
    
    IBOutlet SMCustomTextField *txtFieldOfferExtras;
    
    IBOutlet SMCustomTextField *txtFieldOfferKilometers;
    
    IBOutlet SMCustomTextField *txtFieldOfferInterior;
    
    IBOutlet SMCustomTextField *txtFieldOfferEngine;
    
    IBOutlet SMCustomTextField *txtFieldOfferExterior;
    
    IBOutlet SMCustomTextField *txtFieldOfferOthers;
    
    
    IBOutlet SMCustomLabelAutolayout *lblMyOfferValue;
    
    IBOutlet SMCustomLabelAutolayout *lblGrossProfitValue;
    
    IBOutlet SMCustomLabelAutolayout *lblGrossProfitPercent;
    
    BOOL isCalculatingRetailTag;
    
    int totalAnticipatedPrice;
    int totalMyOfferPrice;
    
    
}
@end



@implementation SMPricing_ValuationViewController


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self headerview];
}

-(void) headerview{
    UIView *headerView = tblPricing_valuation.tableHeaderView;
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    CGFloat height = (lblRetailHeader.frame.origin.y + lblRetailHeader.frame.size.height + 8.0f);
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    tblPricing_valuation.tableHeaderView = headerView;
}
    

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    isExpandTruUnion = NO;
    isExpandLightStone = NO;
    intShowCellsForSection = -1;
    totalAnticipatedPrice = 0;
    
    [self addingProgressHUD];
   
    lblDetail.text = _objSummary.strVariantDetails;
    
   
    [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstText:[NSString stringWithFormat:@"%d",_objSummary.intYear] andWithSecondText:_objSummary.strFriendlyName forLabel:lblNameYear];
    
    
    tblPricing_valuation.tableHeaderView = viewHeaderTable;
    
    if(self.isValuation){
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Valuation"];
         tblPricing_valuation.tableFooterView = viewValuation;
         lblCostApplyHeightConstraint.constant = 0;
    }
    else
    {
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Pricing"];
        tblPricing_valuation.tableFooterView = [[UIView alloc] init];
    }
   
    tblPricing_valuation.estimatedRowHeight = 30.f;
     tblPricing_valuation.rowHeight = UITableViewAutomaticDimension;
    tblPricing_valuation.estimatedSectionHeaderHeight = 40.0f;
    tblPricing_valuation.sectionHeaderHeight = UITableViewAutomaticDimension;
   
     [tblPricing_valuation registerNib:[UINib nibWithNibName:@"SMPricing_ValuationHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"SMPricing_ValuationHeaderView"];
    
    [tblPricing_valuation registerNib:[UINib nibWithNibName:@"SMPricingHeader1" bundle:nil] forHeaderFooterViewReuseIdentifier:@"SMPricingHeader1"];
    
    [tblPricing_valuation registerNib:[UINib nibWithNibName:@"SMPricingCell" bundle:nil] forCellReuseIdentifier:@"SMPricingCell"];
    // Do any additional setup after loading the view from its nib.
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        lblDetail.font = [UIFont fontWithName:FONT_NAME size:15.0];
    }
    else
    {
        lblDetail.font = [UIFont fontWithName:FONT_NAME size:20.0];
    }
   
    if(![_objSummary.pricingTUATradePrice isEqualToString:@"R0"] || ![_objSummary.pricingTUARetailPrice isEqualToString:@"R0"] || ![_objSummary.strTUASearchDateTime isEqualToString:@"Date?"])
    {
        intShowCellsForSection = 0;
         [tblPricing_valuation reloadData];
    }
    
    [self webserviceCallForFetchingValuationDetails];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(SMPricing_ValuationHeaderView *) setHeader:(SMPricing_ValuationHeaderView *)header WithTitle:(NSString *)strTitle WithTrade:(NSString *)strTrade WithMarket:(NSString *)strMarket WithRetail:(NSString *)strRetail willButtonRefreshHide:(BOOL) btnRefreshHide willButtonFetchHide:(BOOL) btnFetchHide withTag:(NSInteger) Tag{
    
    header.lblTitle.text  = strTitle;
    header.lblTrade.text  = strTrade;
    header.lblMarket.text = strMarket;
    header.lblRetail.text = strRetail;
    
    [Fontclass AttributeStringMethodwithFontWithButton:header.btnRefresh iconID:439];
    
    [header.btnRefresh addTarget:self  action:@selector(btnRefreshDidClicked:)  forControlEvents:UIControlEventTouchUpInside];
    header.btnRefresh.tag = Tag;
    header.btnRefresh.hidden = btnRefreshHide;

    if(btnFetchHide)
    {
        [header.btnFetch setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
    else{
        [SMAttributeStringFormatObject setButtonUnderlineText:kFetchTUAPricing forButton:header.btnFetch];
    }
    header.btnFetch.backgroundColor = [UIColor clearColor];
   
    header.btnFetch.tag = Tag;
        [header.btnFetch addTarget:self  action:@selector(btnFetchDidClicked:) forControlEvents:UIControlEventTouchUpInside];

    if(intShowCellsForSection == Tag)
    {
        [header.imgArrow setImage:[UIImage imageNamed:@"down_arrowSelected"]];
    }
    else
    {
        [header.imgArrow setImage:[UIImage imageNamed:@"down_arrowT"]];//
        
    }
    
    if(Tag == 0)
    {
        NSLog (@"%ftext",header.imgArrow.frame.size.height);
        NSLog (@"%ftext",header.imgArrow.frame.size.width);
        NSLog (@"%@ text",header.imgArrow.image);
      
    }
    return header;
}



-(void)btnRefreshUnion:(UIButton *) sender{
    NSLog(@"button Refresh");
    
    switch (sender.tag) {
        case 1:
            
        case 2:
            
        case 3:
            {
                strTransUnionTrade = @"36000";
                strTransUnionMarket = @"48100";
                strTransUnionRetail = @"";
            }
            break;
        default:{
             strTransUnionTrade = @"111111";
             strTransUnionMarket = @"222222";
             strTransUnionRetail = @"333333";
        }
            break;

    }
    
    [tblPricing_valuation reloadData];
}

-(void)btnRefreshDidClicked:(UIButton *) sender{
    NSLog(@"button Refresh");
    
    switch (sender.tag) {
        case 0:
            break;
            
        case 1:
            break;
    }
}

-(void)btnUpdateDidClicked{
    
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
-(void)btnFetchDidClicked:(UIButton *) sender{
    NSLog(@"button fetch");
  
    switch (sender.tag) {
            
        case 0:
        {
            if(sender.tag != intShowCellsForSection)
            {
                intShowCellsForSection = sender.tag;
            }
            else
            {
                intShowCellsForSection = -1;
            }
            
            [tblPricing_valuation reloadData];
        }
        break;
        case 1:
        {
            
            
            SMRealTimeOnlineViewController *vcSMSynopsisVehicleInStockViewController = [[SMRealTimeOnlineViewController alloc] initWithNibName:@"SMRealTimeOnlineViewController" bundle:nil];
            vcSMSynopsisVehicleInStockViewController.screenNumberComingFrom = 1;
            vcSMSynopsisVehicleInStockViewController.selectedVariantID = self.strVehicleVariant.intValue;
            vcSMSynopsisVehicleInStockViewController.selectedYear = self.strVehicleYear.intValue;
            [self.navigationController pushViewController:vcSMSynopsisVehicleInStockViewController animated:NO];
            
            /*if(sender.tag != intShowCellsForSection)
             {
             intShowCellsForSection = sender.tag;
             }
             else
             {
             intShowCellsForSection = -1;
             }
             
             [tblPricing_valuation reloadData];*/
        }
            break;
        case 2:
        {
            SMSimpleLogicViewController *vcSMSynopsisVehicleInStockViewController = [[SMSimpleLogicViewController alloc] initWithNibName:@"SMSimpleLogicViewController" bundle:nil];
            vcSMSynopsisVehicleInStockViewController.objSummary = self.objSummary;
            [self.navigationController pushViewController:vcSMSynopsisVehicleInStockViewController animated:NO];
           /* if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                SMSimpleLogicViewController *vcSMSynopsisVehicleInStockViewController = [[SMSimpleLogicViewController alloc] initWithNibName:@"SMSimpleLogicViewController" bundle:nil];
                vcSMSynopsisVehicleInStockViewController.objSummary = self.objSummary;
                [self.navigationController pushViewController:vcSMSynopsisVehicleInStockViewController animated:NO];
                
            }
            else{
                SMSimpleLogicViewController *vcSMSynopsisVehicleInStockViewController = [[SMSimpleLogicViewController alloc] initWithNibName:@"SMSimpleLogicViewController_iPad" bundle:nil];
                [self.navigationController pushViewController:vcSMSynopsisVehicleInStockViewController animated:NO];
                
            }*/

             //break;
        }
            break;
        case 3:
        {
            
            SMRealTimeOnlineViewController *vcSMSynopsisVehicleInStockViewController = [[SMRealTimeOnlineViewController alloc] initWithNibName:@"SMRealTimeOnlineViewController" bundle:nil];
            vcSMSynopsisVehicleInStockViewController.screenNumberComingFrom = 2;
            vcSMSynopsisVehicleInStockViewController.selectedVariantID = self.strVehicleVariant.intValue;
            vcSMSynopsisVehicleInStockViewController.selectedYear = self.strVehicleYear.intValue;
            [self.navigationController pushViewController:vcSMSynopsisVehicleInStockViewController animated:NO];
            
            /* SMPricingGraphViewController *vcSMSynopsisVehicleInStockViewController = [[SMPricingGraphViewController alloc] initWithNibName:@"SMPricingGraphViewController" bundle:nil];
             
             [self.navigationController pushViewController:vcSMSynopsisVehicleInStockViewController animated:NO];*/
            
            /*if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
             {
             SMSimpleLogicViewController *vcSMSynopsisVehicleInStockViewController = [[SMSimpleLogicViewController alloc] initWithNibName:@"SMSimpleLogicViewController" bundle:nil];
             [self.navigationController pushViewController:vcSMSynopsisVehicleInStockViewController animated:NO];
             
             }
             else{
             SMSimpleLogicViewController *vcSMSynopsisVehicleInStockViewController = [[SMSimpleLogicViewController alloc] initWithNibName:@"SMSimpleLogicViewController_iPad" bundle:nil];
             [self.navigationController pushViewController:vcSMSynopsisVehicleInStockViewController animated:NO];
             
             }*/
        }
            
            break;
            
        case 4:
        {
            
            SMRealTimeOnlineViewController *vcSMSynopsisVehicleInStockViewController = [[SMRealTimeOnlineViewController alloc] initWithNibName:@"SMRealTimeOnlineViewController" bundle:nil];
            vcSMSynopsisVehicleInStockViewController.screenNumberComingFrom = 3;
            vcSMSynopsisVehicleInStockViewController.selectedVariantID = self.strVehicleVariant.intValue;
            vcSMSynopsisVehicleInStockViewController.selectedYear = self.strVehicleYear.intValue;
            [self.navigationController pushViewController:vcSMSynopsisVehicleInStockViewController animated:NO];
            
            /*  SMRealTimeOnlineViewController *vcSMSynopsisVehicleInStockViewController = [[SMRealTimeOnlineViewController alloc] initWithNibName:@"SMRealTimeOnlineViewController" bundle:nil];
             
             [self.navigationController pushViewController:vcSMSynopsisVehicleInStockViewController animated:NO];*/
        }
            break;
            
        case 5:
        {
           /* SMPricingGraphViewController *vcSMSynopsisVehicleInStockViewController = [[SMPricingGraphViewController alloc] initWithNibName:@"SMPricingGraphViewController" bundle:nil];
            
            [self.navigationController pushViewController:vcSMSynopsisVehicleInStockViewController animated:NO];*/
        }
            break;
           


      default:
               break;
    }


}

#pragma mark - textField delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == txtFieldRetailCondition || textField == txtFieldOfferCondition)
    {
        [textField resignFirstResponder];
        [self.view endEditing:YES];
        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
        SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
        
        [popUpView getTheDropDownData:arrmConditions withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:YES]; // array to be passed for custom popup dropdown
        
        [self.view addSubview:popUpView];
        
        [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
            NSLog(@"selected text = %@",selectedTextValue);
            NSLog(@"selected ID = %d",selectIDValue);
            textField.text = selectedTextValue;
            //selectedMakeId = selectIDValue;
        }];
        return NO;
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
        resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        resultString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
        

            if(textField == txtFieldAvgRetail)
           {
               totalAnticipatedPrice = 0;
               if([resultString hasPrefix:@"-"])
                   totalAnticipatedPrice = (-(totalAnticipatedPrice - [resultString intValue]) +txtFieldRetailExtras.text.intValue + txtFieldRetailKilometers.text.intValue + txtFieldRetailOthers.text.intValue);
               else
                    totalAnticipatedPrice = ((totalAnticipatedPrice + [resultString intValue] +txtFieldRetailExtras.text.intValue + txtFieldRetailKilometers.text.intValue + txtFieldRetailOthers.text.intValue));
               
              
           }
           else if (textField == txtFieldRetailExtras)
           {
               totalAnticipatedPrice = 0;
               if([resultString hasPrefix:@"-"])
               {
                   totalAnticipatedPrice = (-(totalAnticipatedPrice - [resultString intValue]) +txtFieldAvgRetail.text.intValue + txtFieldRetailKilometers.text.intValue + txtFieldRetailOthers.text.intValue);
               }
               else
                  totalAnticipatedPrice = ((totalAnticipatedPrice + [resultString intValue]) +txtFieldAvgRetail.text.intValue + txtFieldRetailKilometers.text.intValue + txtFieldRetailOthers.text.intValue);
           }
           else if (textField == txtFieldRetailKilometers)
           {
               totalAnticipatedPrice = 0;
                if([resultString hasPrefix:@"-"])
                    totalAnticipatedPrice = (-(totalAnticipatedPrice - [resultString intValue]) +txtFieldAvgRetail.text.intValue + txtFieldRetailExtras.text.intValue + txtFieldRetailOthers.text.intValue);
               else
                   totalAnticipatedPrice = ((totalAnticipatedPrice + [resultString intValue]) +txtFieldAvgRetail.text.intValue + txtFieldRetailExtras.text.intValue + txtFieldRetailOthers.text.intValue);
           }
           else if (textField == txtFieldRetailOthers)
           {
               totalAnticipatedPrice = 0;
               if([resultString hasPrefix:@"-"])
                   totalAnticipatedPrice = (-(totalAnticipatedPrice - [resultString intValue]) +txtFieldAvgRetail.text.intValue + txtFieldRetailKilometers.text.intValue + txtFieldRetailExtras.text.intValue);
               else
                  totalAnticipatedPrice = ((totalAnticipatedPrice + [resultString intValue]) +txtFieldAvgRetail.text.intValue + txtFieldRetailKilometers.text.intValue + txtFieldRetailExtras.text.intValue);
           }
           else if (textField == txtFieldAvgTrade)
           {
               totalMyOfferPrice = 0;
               if([resultString hasPrefix:@"-"])
                   totalMyOfferPrice = (-(totalMyOfferPrice - [resultString intValue]) +txtFieldOfferExtras.text.intValue + txtFieldOfferKilometers.text.intValue - txtFieldOfferInterior.text.intValue - txtFieldOfferEngine.text.intValue - txtFieldOfferExterior.text.intValue + txtFieldOfferOthers.text.intValue);
               else
                   totalMyOfferPrice = ((totalMyOfferPrice + [resultString intValue]) +txtFieldOfferExtras.text.intValue + txtFieldOfferKilometers.text.intValue - txtFieldOfferInterior.text.intValue - txtFieldOfferEngine.text.intValue - txtFieldOfferExterior.text.intValue + txtFieldOfferOthers.text.intValue);
           }
           else if (textField == txtFieldOfferExtras)
           {
               totalMyOfferPrice = 0;
               
            totalMyOfferPrice = (-(totalMyOfferPrice - [resultString intValue]) +txtFieldAvgTrade.text.intValue + txtFieldOfferKilometers.text.intValue - txtFieldOfferInterior.text.intValue - txtFieldOfferEngine.text.intValue - txtFieldOfferExterior.text.intValue + txtFieldOfferOthers.text.intValue);
           
           }
           else if (textField == txtFieldOfferKilometers)
           {
               totalMyOfferPrice = 0;
               if([resultString hasPrefix:@"-"])
                   totalMyOfferPrice = (-(totalMyOfferPrice - [resultString intValue]) +txtFieldAvgTrade.text.intValue + txtFieldOfferExtras.text.intValue - txtFieldOfferInterior.text.intValue - txtFieldOfferEngine.text.intValue - txtFieldOfferExterior.text.intValue + txtFieldOfferOthers.text.intValue);
               else
                   totalMyOfferPrice = ((totalMyOfferPrice + [resultString intValue]) +txtFieldAvgTrade.text.intValue + txtFieldOfferExtras.text.intValue - txtFieldOfferInterior.text.intValue - txtFieldOfferEngine.text.intValue - txtFieldOfferExterior.text.intValue + txtFieldOfferOthers.text.intValue);
               
           }
           else if (textField == txtFieldOfferInterior)
           {
               totalMyOfferPrice = 0;
               //if([resultString hasPrefix:@"-"])
                   totalMyOfferPrice = ((totalMyOfferPrice - [resultString intValue]) +txtFieldAvgTrade.text.intValue + txtFieldOfferExtras.text.intValue + txtFieldOfferKilometers.text.intValue - txtFieldOfferEngine.text.intValue - txtFieldOfferExterior.text.intValue + txtFieldOfferOthers.text.intValue);
              /* else
                   totalMyOfferPrice = ((totalMyOfferPrice + [resultString intValue]) +txtFieldAvgTrade.text.intValue + txtFieldOfferExtras.text.intValue + txtFieldOfferKilometers.text.intValue - txtFieldOfferEngine.text.intValue - txtFieldOfferExterior.text.intValue + txtFieldOfferOthers.text.intValue);*/
               
           }
           else if (textField == txtFieldOfferEngine)
           {
               totalMyOfferPrice = 0;
              // if([resultString hasPrefix:@"-"])
                   totalMyOfferPrice = ((totalMyOfferPrice - [resultString intValue]) +txtFieldAvgTrade.text.intValue + txtFieldOfferExtras.text.intValue + txtFieldOfferKilometers.text.intValue - txtFieldOfferInterior.text.intValue - txtFieldOfferExterior.text.intValue + txtFieldOfferOthers.text.intValue);
              /* else
                   totalMyOfferPrice = ((totalMyOfferPrice + [resultString intValue]) +txtFieldAvgTrade.text.intValue + txtFieldOfferExtras.text.intValue + txtFieldOfferKilometers.text.intValue - txtFieldOfferInterior.text.intValue - txtFieldOfferExterior.text.intValue + txtFieldOfferOthers.text.intValue);*/
               
           }
           else if (textField == txtFieldOfferExterior)
           {
               totalMyOfferPrice = 0;
               //if([resultString hasPrefix:@"-"])
                   totalMyOfferPrice = ((totalMyOfferPrice - [resultString intValue]) +txtFieldAvgTrade.text.intValue + txtFieldOfferExtras.text.intValue + txtFieldOfferKilometers.text.intValue - txtFieldOfferInterior.text.intValue - txtFieldOfferEngine.text.intValue + txtFieldOfferOthers.text.intValue);
              /* else
                   totalMyOfferPrice = ((totalMyOfferPrice + [resultString intValue]) +txtFieldAvgTrade.text.intValue + txtFieldOfferExtras.text.intValue + txtFieldOfferKilometers.text.intValue - txtFieldOfferInterior.text.intValue - txtFieldOfferEngine.text.intValue + txtFieldOfferOthers.text.intValue);*/
               
           }
           else if (textField == txtFieldOfferOthers)
           {
               totalMyOfferPrice = 0;
               if([resultString hasPrefix:@"-"])
                   totalMyOfferPrice = (-(totalMyOfferPrice - [resultString intValue]) +txtFieldAvgTrade.text.intValue + txtFieldOfferExtras.text.intValue + txtFieldOfferKilometers.text.intValue - txtFieldOfferInterior.text.intValue - txtFieldOfferEngine.text.intValue - txtFieldOfferExterior.text.intValue);
               else
                   totalMyOfferPrice = ((totalMyOfferPrice + [resultString intValue]) +txtFieldAvgTrade.text.intValue + txtFieldOfferExtras.text.intValue + txtFieldOfferKilometers.text.intValue - txtFieldOfferInterior.text.intValue - txtFieldOfferEngine.text.intValue - txtFieldOfferExterior.text.intValue);
               
           }
    
    
       lblAnticipatedRetailValue.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalAnticipatedPrice]];
    
     lblMyOfferValue.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalMyOfferPrice]];
    
    NSString *strAnticipatedPrice = [[lblAnticipatedRetailValue.text stringByReplacingOccurrencesOfString:@" "  withString:@""] stringByReplacingOccurrencesOfString:@"R"  withString:@""];
    
    NSString *strMyOfferPrice = [[lblMyOfferValue.text stringByReplacingOccurrencesOfString:@" "  withString:@""] stringByReplacingOccurrencesOfString:@"R"  withString:@""];
    
    lblGrossProfitValue.text =  [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",strAnticipatedPrice.intValue - strMyOfferPrice.intValue]];
    
    
    NSString *strGrossPrice = [[lblGrossProfitValue.text stringByReplacingOccurrencesOfString:@" "  withString:@""] stringByReplacingOccurrencesOfString:@"R"  withString:@""];
    
    float percentValue = (strGrossPrice.floatValue/strAnticipatedPrice.floatValue)*100;
    
    if(strGrossPrice.intValue > 0)
        lblGrossProfitPercent.text = [NSString stringWithFormat:@"%.02f %%",percentValue];
    else
       lblGrossProfitPercent.text = @"0%";
    
    if(textField == txtFieldRetailExtras || textField == txtFieldOfferExtras)
    {
        
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_NumberOnly] invertedSet];
        NSString       *filtered       = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if(newLength>8)
        {
            return (newLength > 8) ? NO : YES;
        }
        else
        {
            return [string isEqualToString:filtered];
        }
        
    }
    else if([txtFieldAvgTrade isFirstResponder] || [txtFieldAvgRetail isFirstResponder] ||[txtFieldOfferKilometers isFirstResponder] || [txtFieldOfferOthers isFirstResponder] || [txtFieldRetailKilometers isFirstResponder] || [txtFieldRetailOthers isFirstResponder])
    {
        
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_NumberMinus] invertedSet];
        NSString       *filtered       = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if(newLength>8)
        {
            return (newLength > 8) ? NO : YES;
        }
        else
        {
            if(textField.text.length >0 && [string containsString:@"-"])
                return NO;
            return [string isEqualToString:filtered];
        }
        
    }
    return YES;
}




#pragma mark - Table View

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}


-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SMPricing_ValuationHeaderView *header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SMPricing_ValuationHeaderView"];

    switch (section) {
        case 0:
        {
            
//            SMPricingHeader1 *header1=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SMPricingHeader1"];
//            return [self setHeaderTranunion:header1];
            
            header = [self setHeader:header WithTitle:@"TransUnion Auto" WithTrade:_objSummary.pricingTUATradePrice WithMarket:@"" WithRetail:_objSummary.pricingTUARetailPrice willButtonRefreshHide:YES willButtonFetchHide:NO withTag:section];
             header.imgArrow.hidden = YES;
            
        }
            break;
           
        case 2:
        {
            
            header = [self setHeader:header WithTitle:@"Simple Logic" WithTrade:_objSummary.pricingSLTradePrice WithMarket:@"" WithRetail:_objSummary.pricingSLRetailPrice willButtonRefreshHide:YES willButtonFetchHide:YES withTag:section];
      
        }
            break;
            
        case 1:
        {
            header = [self setHeader:header WithTitle:@"Online Prices Now" WithTrade:@"" WithMarket:@"" WithRetail:_objSummary.pricingRetailPrice willButtonRefreshHide:YES willButtonFetchHide:YES withTag:section];
            header.imgArrow.hidden = NO;
        }
            break;
            
        case 3:
        {
            header = [self setHeader:header WithTitle:@"iX Trader" WithTrade:_objSummary.pricingTraderPrice WithMarket:@"" WithRetail:@"" willButtonRefreshHide:YES willButtonFetchHide:YES withTag:section];
            header.imgArrow.hidden = NO;
        }
            
           break;
            
        case 4:
        {
          
            header = [self setHeader:header WithTitle:@"Private Adverts" WithTrade:@"" WithMarket:_objSummary.pricingPrivateAdvertPrice WithRetail:@"" willButtonRefreshHide:YES willButtonFetchHide:YES withTag:section];
            header.imgArrow.hidden = NO;
         
           
        }
            
            break;
        case 5:
        {
            
            int avgTradePrice = 0;
            int totalTradeCount = 0;
            NSString *strTUATradeFinalValue;
            NSString *strSLTradeFinalValue;
            NSString *strTradeFinalValue;
            
            if ([_objSummary.pricingTUATradePrice hasPrefix:@"R"] && [_objSummary.pricingTUATradePrice length] > 1 && ![_objSummary.pricingTUATradePrice isEqualToString:@"R0"])
            {
                strTUATradeFinalValue = [_objSummary.pricingTUATradePrice stringByReplacingOccurrencesOfString:@" " withString:@""];
                strTUATradeFinalValue = [strTUATradeFinalValue substringFromIndex:1];
                
                if(strTUATradeFinalValue.intValue > 0)
                {
                avgTradePrice = avgTradePrice + strTUATradeFinalValue.intValue;
                totalTradeCount++;
                }
            }
            if ([_objSummary.pricingSLTradePrice hasPrefix:@"R"] && [_objSummary.pricingSLTradePrice length] > 1)
            {
                strSLTradeFinalValue = [_objSummary.pricingSLTradePrice stringByReplacingOccurrencesOfString:@" " withString:@""];
                strSLTradeFinalValue = [strSLTradeFinalValue substringFromIndex:1];
                if(strSLTradeFinalValue.intValue > 0)
                {
                    avgTradePrice = avgTradePrice + strSLTradeFinalValue.intValue;
                    totalTradeCount++;
                }
            }
            if ([_objSummary.pricingTraderPrice hasPrefix:@"R"] && [_objSummary.pricingTraderPrice length] > 1)
            {
                strTradeFinalValue = [_objSummary.pricingTraderPrice stringByReplacingOccurrencesOfString:@" " withString:@""];
                strTradeFinalValue = [strTradeFinalValue substringFromIndex:1];
                if(strTradeFinalValue.intValue > 0)
                {
                    avgTradePrice = avgTradePrice + strTradeFinalValue.intValue;
                    totalTradeCount++;
                }
            }
            
            int finalTradeValue;
            
            if(totalTradeCount > 0 )
               // finalTradeValue = avgTradePrice/3;// Change by Dr. Ankit
               finalTradeValue = avgTradePrice/totalTradeCount;
            else
                finalTradeValue = 0;
            
            strTradeFinalValue = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",finalTradeValue]];
            
  //////////////////////////////////////////////////////////////////////////////////////////////
            
            int avgRetailPrice = 0;
            int totalRetailCount = 0;
            
            NSString *strTUARetailFinalValue;
            NSString *strSLRetailFinalValue;
            NSString *strRetailFinalValue;
            
            if ([_objSummary.pricingTUARetailPrice hasPrefix:@"R"] && [_objSummary.pricingTUARetailPrice length] > 1)
            {
                strTUARetailFinalValue = [_objSummary.pricingTUARetailPrice stringByReplacingOccurrencesOfString:@" " withString:@""];
               strTUARetailFinalValue = [strTUARetailFinalValue substringFromIndex:1];
                
                if(strTUARetailFinalValue.intValue > 0)
                {
                    avgRetailPrice = avgRetailPrice + strTUARetailFinalValue.intValue;
                    totalRetailCount++;
                }
            }
            if ([_objSummary.pricingSLRetailPrice hasPrefix:@"R"] && [_objSummary.pricingSLRetailPrice length] > 1)
            {
                strSLRetailFinalValue = [_objSummary.pricingSLRetailPrice stringByReplacingOccurrencesOfString:@" " withString:@""];
               strSLRetailFinalValue = [strSLRetailFinalValue substringFromIndex:1];
                if(strSLRetailFinalValue.intValue > 0)
                {
                    avgRetailPrice = avgRetailPrice + strSLRetailFinalValue.intValue;
                    totalRetailCount++;
                }
            }
            if ([_objSummary.pricingRetailPrice hasPrefix:@"R"] && [_objSummary.pricingRetailPrice length] > 1)
            {
                strRetailFinalValue = [_objSummary.pricingRetailPrice stringByReplacingOccurrencesOfString:@" " withString:@""];
                strRetailFinalValue = [strRetailFinalValue substringFromIndex:1];
                if(strRetailFinalValue.intValue > 0)
                {
                    avgRetailPrice = avgRetailPrice + strRetailFinalValue.intValue;
                    totalRetailCount++;
                }
            }
            
            int finalRetailValue;
            
            if(totalRetailCount > 0 )
               // finalRetailValue = avgRetailPrice/3;//Change by Dr. Ankit
                finalRetailValue = avgRetailPrice/totalRetailCount;
            else
                finalRetailValue = 0;
            
            strRetailFinalValue = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",finalRetailValue]];
            
            
           //Change by Dr. Ankit
            header = [self setHeader:header WithTitle:@"Avg. of Sources" WithTrade:strTradeFinalValue WithMarket:_objSummary.pricingPrivateAdvertPrice WithRetail:strRetailFinalValue willButtonRefreshHide:YES willButtonFetchHide:YES withTag:section];
            header.imgArrow.hidden = YES;
            
        }

            break;
        case 6:
        {
            
            
        }
            break;
        case 7:
        {
           
        }
            break;
        default:
            break;
    }
  
    if (section != 0) {
         [header.btnFetch setAttributedTitle:@"" forState:UIControlStateNormal];
    }
    else{
        if (intShowCellsForSection != -1) {
            [header.btnFetch setHidden:YES];
            [header.lblSeparator setHidden:YES];
            [header.lblTrade setHidden:NO];
            [header.lblMarket setHidden:NO];
            [header.lblRetail  setHidden:NO];

            
        }else{
            [header.lblTrade setHidden:YES];
            [header.lblMarket setHidden:YES];
            [header.lblRetail  setHidden:YES];
        }
    }
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return UITableViewAutomaticDimension;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    if(intShowCellsForSection==section)
        return 1;
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier= @"SMPricingCell";
    SMPricingCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
    dynamicCell.backgroundColor = [UIColor blackColor];
   
    switch (indexPath.section) {
        case 0:
        {
            if([_objSummary.strTUASearchDateTime length] != 0)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                
                NSDate *requiredDate1 = [dateFormatter dateFromString:_objSummary.strTUASearchDateTime];
                
                NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                [dateFormatter1 setDateFormat:@"dd MMM yyyy"];
                
                NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:requiredDate1]];
                
                
                dynamicCell.lblDetails.text = [NSString stringWithFormat:@"TUA price check: %@",textDate];
            }
            else
            {
                dynamicCell.lblDetails.text = @"TUA price check: Date?";
            }
            
           
            [SMAttributeStringFormatObject setButtonUnderlineText:kUpdate forButton:dynamicCell.btnUpdate];
            [dynamicCell.btnUpdate addTarget:self  action:@selector(btnUpdateDidClicked)  forControlEvents:UIControlEventTouchUpInside];
        }
            break;
       /* case 2:
            [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstTextPricing:@"Your Lightstone Auto acc no.  " andWithSecondText:@"08765" forLabel: dynamicCell.lblDetails];;
            break;*/
            
        default:
            break;
    }
    
     return dynamicCell;
  }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)loadTransUnionPricing
{
    
   // NSMutableURLRequest *requestURL=[SMWebServices loadTransUnionPricing:[SMGlobalClass sharedInstance].hashValue andVINNum:@"WAUZZZ8K3FA087643" andYear:@"2015" andRegNumber:@"ND805214" andMMCode:@"04042131" andMileage:@"41000"];
    
      NSMutableURLRequest *requestURL=[SMWebServices loadTransUnionPricing:[SMGlobalClass sharedInstance].hashValue andVINNum:self.objSummary.strVINNo andYear:[NSString stringWithFormat:@"%d",self.objSummary.intYear] andRegNumber:@"" andMMCode:self.objSummary.strMMCode andMileage:self.objSummary.strKilometers];
    
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

#pragma mark - Webservice integration

-(void) webserviceCallForFetchingValuationDetails
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    NSMutableURLRequest * requestURL = [SMWebServices getTheValuationPriceDetailsWithUserHash:[SMGlobalClass sharedInstance].hashValue andAppraisalID:self.objSummary.appraisalID.intValue andVIN:self.objSummary.strVINNo];
   // self.objSummary.strVINNo
    
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
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    // Do stuff to UI
                                                   [xmlParser parse];
                                                    //oldTableViewHeight = tblSMSendOffer.contentSize.height;
                                                    
                                                });
                                                
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
     currentNodeContent = [NSMutableString stringWithString:@""];
    
    if ([elementName isEqualToString:@"ReturnValuationResult"])
    {
        valuationObject = [[SMValuationDetailsObj alloc] init];
    }
    if ([elementName isEqualToString:@"CalculatingRetail"]){
        isCalculatingRetailTag = YES;
    }
    else if ([elementName isEqualToString:@"CalculatingOffer"]){
        isCalculatingRetailTag = NO;
    }
    if ([elementName isEqualToString:@"ConditionValues"]){
    
        arrmConditions = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"ConditionValue"]){
       conditionObj = [[SMDropDownObject alloc] init];
    }

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
    
    if ([elementName isEqualToString:@"TradePrice"])
    {
        _objSummary.pricingTUATradePrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"RetailPrice"])
    {
        _objSummary.pricingTUARetailPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"SearchDateTime"])
    {
        _objSummary.strTUASearchDateTime = currentNodeContent;
    }
    if ([elementName isEqualToString:@"LoadTransUnionPricingResult"])
    {
        if([currentNodeContent containsString:@"VehicleCode Validation Failed"])
        {
            SMAlert(@"Smart Manager", @"No pricing available for this vehicle's M&M code");
            [HUD hide:YES];
            return;
        }
        NSRange range = NSMakeRange(0, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [tblPricing_valuation reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        [HUD hide:YES];
        
    }
    
    // Parsing for Valuation page
    
    if ([elementName isEqualToString:@"AverageRetail"])
        valuationObject.avgRetailPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    
    else if([elementName isEqualToString:@"AdjCondition"])
    {
        if(isCalculatingRetailTag)
            valuationObject.retailCondition = currentNodeContent;
        else
            valuationObject.offerCondition = currentNodeContent;
    }
    
    else if([elementName isEqualToString:@"AdjExtras"])
    {
        if(isCalculatingRetailTag)
           valuationObject.retailExtras = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        else
           valuationObject.offerExtrasPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        
        
    }
    else if([elementName isEqualToString:@"AdjKilometers"])
    {
        if(isCalculatingRetailTag)
            valuationObject.retailKilometers = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        else
           valuationObject.offerKilometersPrice = currentNodeContent;
    }
    else if([elementName isEqualToString:@"AdjInterior"])
    {
        valuationObject.offerInteriorPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    else if([elementName isEqualToString:@"AdjEngine"])
    {
        valuationObject.offerEnginePrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    else if([elementName isEqualToString:@"AdjExterior"])
    {
        valuationObject.offerExteriorPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    else if([elementName isEqualToString:@"AdjOther"])
    {
        if(isCalculatingRetailTag)
            valuationObject.retailOthers = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        else
            valuationObject.offerOtherPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    
    }
    
    else if([elementName isEqualToString:@"AnticipatedRetail"])
        valuationObject.anticipatedPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    else if([elementName isEqualToString:@"AverageTrade"])
        valuationObject.avgTradePrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    else if([elementName isEqualToString:@"Text"])
        conditionObj.strMakeName = currentNodeContent;
    else if([elementName isEqualToString:@"Value"])
        conditionObj.strMakeId = currentNodeContent;
    else if([elementName isEqualToString:@"ConditionValue"])
            [arrmConditions addObject:conditionObj];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Do stuff to UI
        lblAvgRetailValue.text = valuationObject.avgRetailPrice;
        lblRetailConditionValue.text = valuationObject.retailCondition;
        lblOfferConditionValue.text = valuationObject.offerCondition;
        lblRetailExtrasValue.text = [NSString stringWithFormat:@"%@ (+)",valuationObject.retailExtras];
        lblOfferExtrasValue.text = [NSString stringWithFormat:@"(+) %@",valuationObject.offerExtrasPrice];
        lblRetailKilometerValue.text = [NSString stringWithFormat:@"%@ (+ -)",valuationObject.retailKilometers];
        lblOfferKilometersValue.text = valuationObject.offerKilometersPrice;
        lblRetailOtherValue.text = [NSString stringWithFormat:@"%@ (+ -)",valuationObject.retailOthers];
        lblOfferOtherValue.text = [NSString stringWithFormat:@"(+ -) %@",valuationObject.offerOtherPrice];
        lblAnticipatedRetailValue.text = valuationObject.anticipatedPrice;
        lblAvgTradeValue.text = valuationObject.avgTradePrice;
        lblOfferInteriorValue.text = [NSString stringWithFormat:@"(-) %@",valuationObject.offerInteriorPrice];
        lblOfferEngineValue.text = [NSString stringWithFormat:@"(-) %@",valuationObject.offerEnginePrice];
        lblOfferExteriorValue.text = [NSString stringWithFormat:@"(-) %@",valuationObject.offerExteriorPrice];
        
        [HUD hide:YES];
        
    });
    
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

@end
