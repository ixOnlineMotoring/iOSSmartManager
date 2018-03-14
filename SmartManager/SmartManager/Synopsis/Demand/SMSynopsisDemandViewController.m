//
//  SMSynopsisDemandViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 13/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMSynopsisDemandViewController.h"
#import "SMDemadsViewCell.h"
#import "SMCustomColor.h"
#import "SMWSDemand.h"
@interface SMSynopsisDemandViewController ()<MBProgressHUDDelegate>
{
    
    IBOutlet UITableView *tblDemands;
    IBOutlet UIView *viewHeaderTable;
    UIFont *fnt;
    IBOutlet UIView *viewFooterTable;
    MBProgressHUD *HUD;
    SMObjectDemandXml *objSMObjectDemandXml;
    
}
@end

@implementation SMSynopsisDemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [SMCustomColor setTitle:@" Demand "];
    
    [tblDemands registerNib:[UINib nibWithNibName:@"SMDemadsViewCell" bundle:nil] forCellReuseIdentifier:@"SMDemadsViewCell"];

   
    
        tblDemands.tableHeaderView = viewHeaderTable;
    tblDemands.tableFooterView = viewFooterTable;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        tblDemands.estimatedRowHeight = 68.0f;
        tblDemands.rowHeight = UITableViewAutomaticDimension;
        fnt = [UIFont fontWithName:FONT_NAME size:10.0f];
        
    }
    else
    {
        tblDemands.estimatedRowHeight = 68.0f;
        tblDemands.rowHeight = UITableViewAutomaticDimension;
        fnt = [UIFont fontWithName:FONT_NAME size:15.0f];
        
    }
    
    tblDemands.dataSource= self;
    tblDemands.delegate = self;
    [self getDemand];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [tblDemands reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate and datasource



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (objSMObjectDemandXml.iStatus == kWSSuccess) {
        return 4;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMDemadsViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SMDemadsViewCell"];
    ifIphone
    {
    cell.lblVariantName.preferredMaxLayoutWidth = self.view.frame.size.width - 225.0f;
    cell.lblModelName.preferredMaxLayoutWidth = self.view.frame.size.width - 225.0f;
    }
    else{
        cell.lblVariantName.preferredMaxLayoutWidth = self.view.frame.size.width - 456.0f;
        cell.lblModelName.preferredMaxLayoutWidth = self.view.frame.size.width - 456.0f;
 
    }
    cell.lblModelName.text = objSMObjectDemandXml.strModelName;
    cell.lblVariantName.text = objSMObjectDemandXml.strVariantName;
    
    switch (indexPath.row) {
        case 0:
        {
            [self configureCellForClient:cell forIndexPath:indexPath];
        }
        break;
         
        case 1:
        {
             [self configureCellForCity:cell forIndexPath:indexPath];
        }
            break;
            
        case 2:
        {
             [self configureCellForProvince:cell forIndexPath:indexPath];
        }
            break;
        case 3:
        {
             [self configureCellForNational:cell forIndexPath:indexPath];
        }
            break;
        default:
            break;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

-(void) configureCellForClient:(SMDemadsViewCell *)cell forIndexPath:(NSIndexPath *)NSIndexPath{
   
    cell.lblHeaderName.text = objSMObjectDemandXml.strClientName;
    
    //Model
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strClientModelLeadCount andWithSecondText:objSMObjectDemandXml.strClientModelLeadCountRanking forLabel:cell.lblModelLeadsRanked];
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strClientModelSoldLeadCount andWithSecondText:objSMObjectDemandXml.strClientModelSoldLeadCountRanking forLabel:cell.lblModelSalesRanked];
    
    //Variant
    
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strClientVariantSoldLeadCount andWithSecondText:objSMObjectDemandXml.strClientVariantSoldLeadCountRanking forLabel:cell.lblVariantSalesRanked];
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strClientVariantLeadCount andWithSecondText:objSMObjectDemandXml.strClientVariantLeadCountRanking forLabel:cell.lblVariantLeadsRanked];
}

-(void) configureCellForCity:(SMDemadsViewCell *)cell forIndexPath:(NSIndexPath *)NSIndexPath{
    cell.lblHeaderName.text = objSMObjectDemandXml.strCityName;
    
    //Model
   
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strCityModelLeadCount andWithSecondText:objSMObjectDemandXml.strCityModelLeadCountRanking forLabel:cell.lblModelLeadsRanked];
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strCityModelSoldLeadCount andWithSecondText:objSMObjectDemandXml.strCityModelSoldLeadCountRanking forLabel:cell.lblModelSalesRanked];
   
    //Variant
   
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strCityVariantLeadCount andWithSecondText:objSMObjectDemandXml.strCityVariantLeadCountRanking forLabel:cell.lblVariantLeadsRanked];
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strCityVariantSoldLeadCount andWithSecondText:objSMObjectDemandXml.strCityVariantSoldLeadCountRanking forLabel:cell.lblVariantSalesRanked];
   
}

-(void) configureCellForProvince:(SMDemadsViewCell *)cell forIndexPath:(NSIndexPath *)NSIndexPath{
    cell.lblHeaderName.text = objSMObjectDemandXml.strProvinceName;
    
    //Model
       [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strProvinceModelLeadCount andWithSecondText:objSMObjectDemandXml.strProvinceModelLeadCountRanking forLabel:cell.lblModelLeadsRanked];
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strProvinceModelSoldLeadCount andWithSecondText:objSMObjectDemandXml.strProvinceModelSoldLeadCountRanking forLabel:cell.lblModelSalesRanked];
    
    
    //Variant
   
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strProvinceVariantLeadCount andWithSecondText:objSMObjectDemandXml.strProvinceVariantLeadCountRanking forLabel:cell.lblVariantLeadsRanked];
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strProvinceVariantSoldLeadCount andWithSecondText:objSMObjectDemandXml.strProvinceVariantSoldLeadCountRanking forLabel:cell.lblVariantSalesRanked];
    
 
}
-(void) configureCellForNational:(SMDemadsViewCell *)cell forIndexPath:(NSIndexPath *)NSIndexPath{
    cell.lblHeaderName.text = @"National";
    
    //Model
   
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strNationalModelLeadCount andWithSecondText:objSMObjectDemandXml.strNationalModelLeadCountRanking forLabel:cell.lblModelLeadsRanked];
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strNationalModelSoldLeadCount andWithSecondText:objSMObjectDemandXml.strNationalModelSoldLeadCountRanking forLabel:cell.lblModelSalesRanked];
    
    //Variant
   
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strNationalVariantLeadCount andWithSecondText:objSMObjectDemandXml.strNationalVariantLeadCountRanking forLabel:cell.lblVariantLeadsRanked];
    [SMAttributeStringFormatObject setAttributedTextForDemandLeadsAndSales:objSMObjectDemandXml.strNationalVariantSoldLeadCount andWithSecondText:objSMObjectDemandXml.strNationalVariantSoldLeadCountRanking forLabel:cell.lblVariantSalesRanked];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        return UITableViewAutomaticDimension;
    }
    else
    {
        return UITableViewAutomaticDimension;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - Web Services
-(void) getDemand{
    
    NSMutableURLRequest *requestURL=[SMWebServices getDemandsWithUserHash:[SMGlobalClass sharedInstance].hashValue andVariantID:self.strVariantID andClientId:[SMGlobalClass sharedInstance].strClientID];
    
    objSMObjectDemandXml = [[SMObjectDemandXml alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSDemand *wsSMWSDemand = [[SMWSDemand alloc]init];
    
    [wsSMWSDemand responseForWebServiceForReuest:requestURL
                                            response:^(SMObjectDemandXml *objSMObjectDemandXmlResult) {
                                                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                [HUD hide:YES];
                                                switch (objSMObjectDemandXmlResult.iStatus) {
                                                        
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
                                                        objSMObjectDemandXml = objSMObjectDemandXmlResult;
                                                        [tblDemands reloadData];
                                                    }
                                                        break;
                                                        
                                                    default:
                                                        break;
                                                }
                                                
                                            }
                                            andError: ^(NSError *error) {
                                                SMAlert(@"Error", error.localizedDescription);
                                                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                [HUD hide:YES];
                                            }
     ];
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
