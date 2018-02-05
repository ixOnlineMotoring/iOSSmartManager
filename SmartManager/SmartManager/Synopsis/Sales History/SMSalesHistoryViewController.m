//
//  SMSalesHistoryViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 14/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMSalesHistoryViewController.h"
#import "SMSalesHistoryViewCell.h"
#import "SMCustomColor.h"
#import "SMCustomLabelAutolayout.h"
#import "SMAutolayoutLightLabel.h"

#import "SMWSSaleHistory.h"
#import "SMObjectSaleHistory.h"
#import "SMSaleHistoryXml.h"
@interface SMSalesHistoryViewController ()<MBProgressHUDDelegate>
{
    
    IBOutlet UITableView *tblSaleHistory;
    IBOutlet UIView *viewHeaderTable;
    IBOutlet UIView *viewFooterTable;
    MBProgressHUD *HUD;
    IBOutlet SMCustomLabelAutolayout *lblAvgText;
    IBOutlet SMCustomLabelAutolayout *lblHeader;
    IBOutlet SMCustomLabelAutolayout *lblTotal;
    IBOutlet SMAutolayoutLightLabel *lblAverage;
    IBOutlet SMAutolayoutLightLabel *lblPoloInStock;
    IBOutlet SMCustomLabelAutolayout *lblStockNowText;
    IBOutlet SMAutolayoutLightLabel *lblAverage30Days;
    IBOutlet SMAutolayoutLightLabel *lblAverage45Days;
    IBOutlet SMAutolayoutLightLabel *lblAverage60Days;
    int iAverage,iTotal;
    SMSaleHistoryXml *objSMSaleHistoryXml;
}
@end

@implementation SMSalesHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Sales History"];
    iAverage = iTotal = 0;
    [tblSaleHistory registerNib:[UINib nibWithNibName:@"SMSalesHistoryViewCell" bundle:nil] forCellReuseIdentifier:@"SMSalesHistoryViewCell"];
    tblSaleHistory.estimatedRowHeight = 30.0f;
    tblSaleHistory.rowHeight = UITableViewAutomaticDimension;
    tblSaleHistory.estimatedSectionHeaderHeight = 70.0f;
    tblSaleHistory.sectionHeaderHeight = UITableViewAutomaticDimension;
    tblSaleHistory.tableFooterView = viewFooterTable;
    lblAvgText.text = [NSString stringWithFormat:@"Avg. %@ sales pm",self.strModelName];
    lblStockNowText.text = [NSString stringWithFormat:@"%@'s in stock now",self.strModelName];
    //lblTotal.text = @"25";
    //lblAverage.text = @"15";
    [self getSalesHistory];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
            
        case 0:
        {
            lblHeader.text = [NSString stringWithFormat:@"%@ sales during the last 6 months-",self.strModelName];
            return viewHeaderTable;
        }
            break;
        case 1:
        {
            return viewFooterTable;
        }
            break;
            
        default:{
            return [[UIView alloc]init];
        }
            break;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,1.0f)];
    if (section == 1) {
        view.alpha = 0.0f;
        view.backgroundColor = [UIColor clearColor];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return objSMSaleHistoryXml.arrmSalesHistory.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMSalesHistoryViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SMSalesHistoryViewCell"];
    SMObjectSaleHistory *objSMObjectSaleHistory= [objSMSaleHistoryXml.arrmSalesHistory objectAtIndex:indexPath.row];
    cell.lblDetails.text = objSMObjectSaleHistory.strVariantName;
    cell.lblDetailsValue.text = objSMObjectSaleHistory.strSalesCount;
//    if (indexPath.section == 1) {
//        
//        switch (indexPath.row) {
//    
//            case 0:
//            {
//                cell.lblDetails.text = @"30 days stockholding";
//                cell.lblDetailsValue.text = @"7";
//            }
//                break;
//            case 1:
//            {
//                cell.lblDetails.text = @"45 days stockholding";
//                cell.lblDetailsValue.text = @"7";
//            }
//                break;
//            case 2:
//            {
//                cell.lblDetails.text = @"60 days stockholding";
//                cell.lblDetailsValue.text = @"7";
//            }
//                break;
//            case 3:
//            {
//                cell.lblDetails.text = @"Polo's in stock now";
//                cell.lblDetailsValue.text = @"7";
//            }
//            default:
//                break;
//        }
//        cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
//        cell.lblDetails.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
//    }
//    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



-(void) getSalesHistory{
    
   
    NSMutableURLRequest *requestURL=[SMWebServices getSalesHistoryWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:self.strYear andVariantID:self.strVariantId];
    
    objSMSaleHistoryXml  = [[SMSaleHistoryXml alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSSaleHistory *wsSMWSSaleHistory = [[SMWSSaleHistory alloc]init];
    
    [wsSMWSSaleHistory responseForWebServiceForReuest:requestURL
                                            response:^(SMSaleHistoryXml *objSMSaleHistoryXmlResult) {
                                                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                [HUD hide:YES];
                                                switch (objSMSaleHistoryXmlResult.iStatus) {
                                                        
                                                 case kWSSuccess:
                                                    {
                                                        objSMSaleHistoryXml = objSMSaleHistoryXmlResult;
                                                       
                                                        for (int i=0; i<objSMSaleHistoryXml.arrmSalesHistory.count;i++) {
                                                            SMObjectSaleHistory *objSMObjectSaleHistory= [objSMSaleHistoryXml.arrmSalesHistory objectAtIndex:i];
                                                        iTotal = iTotal+objSMObjectSaleHistory.strSalesCount.intValue;
                                                           //NSLog(@"---%d,-----%d",objSMObjectSaleHistory.strSalesCount.intValue,iTotal);
                                                        }
                                                        
                                                        lblTotal.text =[NSString stringWithFormat:@"%d",iTotal];
                                                        lblAverage.text =[NSString stringWithFormat:@"%d",objSMSaleHistoryXml.strAverageSalesPerMonth.intValue];
                                                        lblAverage30Days.text =[NSString stringWithFormat:@"%d",objSMSaleHistoryXml.strAverageStockHolding30Days.intValue];
                                                        lblAverage45Days.text =[NSString stringWithFormat:@"%d",objSMSaleHistoryXml.strAverageStockHolding45Days.intValue];
                                                        lblAverage60Days.text =[NSString stringWithFormat:@"%d",objSMSaleHistoryXml.strAverageStockHolding60Days.intValue];
                                                        //lblPoloInStock.text = @"value?";
                                                        lblPoloInStock.text = [NSString stringWithFormat:@"%d",objSMSaleHistoryXml.strInStock.intValue];
                                                        [tblSaleHistory reloadData];
                                                    }
                                                        break;
                                                        
                                                    default:
                                                    {
                                                        [SMAttributeStringFormatObject handleWebServiceErrorForCode:objSMSaleHistoryXmlResult.iStatus ForViewController:self withGOBack:YES];
                                                    }
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
