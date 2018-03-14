//
//  SMSynopsisAverageDaysViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 13/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMSynopsisAverageDaysViewController.h"
#import "SMAverageDaysViewCell.h"
#import "SMCustomColor.h"
#import "SMWSAverageDays.h"
@interface SMSynopsisAverageDaysViewController ()<MBProgressHUDDelegate>
{
    IBOutlet UITableView *tblAverageDays;
    IBOutlet UIView *viewFooterTable;
    MBProgressHUD *HUD;
    SMObjectAverageDaysXml *objSMObjectAverageDaysXml;
    int iAverageCity,iAverageClient,iAverageNational;
    int iSampleSizeCity,iSampleSizeClient,iSampleSizeNational;
    int iStockCity,iStockClient,iStockNational;
}

@end

@implementation SMSynopsisAverageDaysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Average Days"];
    
    iAverageCity=0;
    iAverageClient=0;
    iAverageNational=0;
    
    iSampleSizeCity=0;
    iSampleSizeClient=0;
    iSampleSizeNational=0;
    
    iStockCity=0;
    iStockClient=0;
    iStockNational=0;
    
    tblAverageDays.tableFooterView = viewFooterTable;
    tblAverageDays.estimatedRowHeight = 30.0f;
    tblAverageDays.rowHeight = UITableViewAutomaticDimension;
    [tblAverageDays registerNib:[UINib nibWithNibName:@"SMAverageDaysViewCell" bundle:nil] forCellReuseIdentifier:@"SMAverageDaysViewCell"];
    [self getAverageDays];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view Delegates and datasource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (objSMObjectAverageDaysXml.arrmAverageDays.count != 0) {
        NSLog(@"Total rows %lu",(objSMObjectAverageDaysXml.arrmAverageDays.count +3));
        return (objSMObjectAverageDaysXml.arrmAverageDays.count +3);/// 1 + 2 for bottom
    }
    else{
        return  0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMAverageDaysViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SMAverageDaysViewCell"];
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSLog(@"indexPath.row %ld  test %lu",(long)indexPath.row,objSMObjectAverageDaysXml.arrmAverageDays.count+3-1);
    if (indexPath.row == 0) {
         [self configureCellForHeaderCell:cell atIndexPath:indexPath];
    }
    else if(indexPath.row == objSMObjectAverageDaysXml.arrmAverageDays.count +3-2)
    {
         [self configureCellAverageCell:cell atIndexPath:indexPath];
    }
    else if (indexPath.row == objSMObjectAverageDaysXml.arrmAverageDays.count +3-1)
    {
        [self configureCellForFooterCell:cell atIndexPath:indexPath];
    }
    else{
        [self configureCell:cell atIndexPath:indexPath];
    }
    
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - Cell Configuration
- (void)configureCellForHeaderCell:(SMAverageDaysViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.lblDetails.text = @"";
    cell.lblColumn1.text = @"Us";
    cell.lblColumn2.text = objSMObjectAverageDaysXml.strCityName;
    cell.lblColumn3.text = @"National";
    
}

- (void)configureCell:(SMAverageDaysViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [self setlabelColor:cell forColour:[UIColor whiteColor]];
    SMObjectAverageDays *objSMObjectAverageDays = [[SMObjectAverageDays alloc]init];
    objSMObjectAverageDays = [objSMObjectAverageDaysXml.arrmAverageDays objectAtIndex:(indexPath.row-1)];
    cell.lblDetails.text   = objSMObjectAverageDays.strVariantName;
    cell.lblColumn1.text   = [NSString stringWithFormat:@"%d",objSMObjectAverageDays.iClientAverageDays];
    cell.lblColumn2.text   = [NSString stringWithFormat:@"%d",objSMObjectAverageDays.iCityAverageDays];
    cell.lblColumn3.text   = [NSString stringWithFormat:@"%d",objSMObjectAverageDays.iNationalAverageDays];
}


- (void)configureCellAverageCell:(SMAverageDaysViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [self setlabelColor:cell forColour:[UIColor whiteColor]];
    cell.lblDetails.text = @"Average";
//    cell.lblColumn1.text = [NSString stringWithFormat:@"%d",iAverageClient/iStockClient];
//    cell.lblColumn2.text = [NSString stringWithFormat:@"%d",iAverageCity/iStockCity];
//    cell.lblColumn3.text = [NSString stringWithFormat:@"%d",iAverageNational/iStockNational];
    
    cell.lblColumn1.text = [NSString stringWithFormat:@"%d",iAverageClient/objSMObjectAverageDaysXml.arrmAverageDays.count];
    cell.lblColumn2.text = [NSString stringWithFormat:@"%d",iAverageCity/objSMObjectAverageDaysXml.arrmAverageDays.count];
    cell.lblColumn3.text = [NSString stringWithFormat:@"%d",iAverageNational/objSMObjectAverageDaysXml.arrmAverageDays.count];


}

- (void)configureCellForFooterCell:(SMAverageDaysViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [self setlabelColor:cell forColour:[SMCustomColor setBlueColorThemeButton]];
    cell.lblDetails.text = @"Sample Size";
    cell.lblColumn1.text = [NSString stringWithFormat:@"%d",iStockClient];
    cell.lblColumn2.text = [NSString stringWithFormat:@"%d",iStockCity];
    cell.lblColumn3.text = [NSString stringWithFormat:@"%d",iStockNational];
}

- (void)setlabelColor:(SMAverageDaysViewCell *)cell forColour:(UIColor *)color{
    cell.lblDetails.textColor = color;
    cell.lblColumn1.textColor = color;
    cell.lblColumn2.textColor = color;
    cell.lblColumn3.textColor = color;
}


#pragma mark - Web Services
-(void) getAverageDays{
    
    NSMutableURLRequest *requestURL=[SMWebServices getAverageDaysWithUserHash:[SMGlobalClass sharedInstance].hashValue andModelId:self.strModelID andClientID:[SMGlobalClass sharedInstance].strClientID];
    
  //  NSMutableURLRequest *requestURL=[SMWebServices getAverageDaysWithUserHash:[SMGlobalClass sharedInstance].hashValue andModelId:@"496" andClientID:@"103"];
    
    objSMObjectAverageDaysXml = [[SMObjectAverageDaysXml alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSAverageDays *wsSMWSAvaibility = [[SMWSAverageDays alloc]init];
    
    [wsSMWSAvaibility responseForWebServiceForReuest:requestURL
                                            response:^(SMObjectAverageDaysXml *objSMObjectAverageDaysXmlResult) {
                                                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                [HUD hide:YES];
                                                
                                                switch (objSMObjectAverageDaysXmlResult.iStatus) {
                                    
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
                                                        objSMObjectAverageDaysXml = objSMObjectAverageDaysXmlResult;
                                                        for (int i=0; i<objSMObjectAverageDaysXmlResult.arrmAverageDays.count; i++) {
                                                            
                                                            SMObjectAverageDays *objSMObjectAverageDays = [[SMObjectAverageDays alloc]init];
                                                            objSMObjectAverageDays = [objSMObjectAverageDaysXml.arrmAverageDays objectAtIndex:i];
                                                            
                                                            iAverageCity = iAverageCity + objSMObjectAverageDays.iCityAverageDays;
                                                            iAverageClient = iAverageClient + objSMObjectAverageDays.iClientAverageDays;
                                                            iAverageNational = iAverageNational + objSMObjectAverageDays.iNationalAverageDays;
                                                            
                                                            iStockCity = iStockCity + objSMObjectAverageDays.iCityTotalStockMovements;
                                                            iStockClient = iStockClient + objSMObjectAverageDays.iClientTotalStockMovements;
                                                            iStockNational = iStockNational + objSMObjectAverageDays.iNationalTotalStockMovements;

                                                        }
                                                        [tblAverageDays reloadData];
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
