//
//  SMAvailabilityViewController.m
//  Smart Manager
//
//  Created by Sandeep on 04/01/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMAvailabilityViewController.h"
#import "SMCustomColor.h"
#import "SMSynopsisDoAppraisalViewController.h"
#import "SMWSAvaibility.h"
#import "SMWSGroupID.h"
#import "SMAvaibiltyObject.h"

@interface SMAvailabilityViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    SMObjectAvaibilityXml *objSMWSAvaibility;
    BOOL isSetHeight;
    int iClient,iGroup,iProvince,iNational;
}
@end

@implementation SMAvailabilityViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ( isSetHeight) {
         [self headerview];
    }
}

-(void) headerview{
    SMAvailabilityHeaderView *headerView =(SMAvailabilityHeaderView *) tblAvailabilityTableView.tableHeaderView;
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    CGFloat height = (headerView.lblColumn2.frame.origin.y + headerView.lblColumn2.frame.size.height+45.0f);
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    isSetHeight = NO;
    tblAvailabilityTableView.tableHeaderView = headerView;
  
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [SMCustomColor setTitle:@"Availability"];
    // Do any additional setup after loading the view from its nib.

    [tblAvailabilityTableView registerNib:[UINib nibWithNibName: @"SMAvailabilityViewCell" bundle:nil] forCellReuseIdentifier:@"SMAvailabilityViewCell"];

    tblAvailabilityTableView.estimatedRowHeight = 44.0;
    tblAvailabilityTableView.rowHeight = UITableViewAutomaticDimension;
    isSetHeight = YES;
    NSArray *arraySMAvailabilityHeaderView = [[NSBundle mainBundle]loadNibNamed:@"SMAvailabilityHeaderView" owner:self options:nil];
    availabilityHeaderView = [arraySMAvailabilityHeaderView objectAtIndex:0];
    tblAvailabilityTableView.tableHeaderView = availabilityHeaderView;

    NSArray *arraySMAvailabilityFooterView = [[NSBundle mainBundle]loadNibNamed:@"SMAvailabilityFooterView" owner:self options:nil];
    availabilityFooterView = [arraySMAvailabilityFooterView objectAtIndex:0];
    tblAvailabilityTableView.tableFooterView = availabilityFooterView;
    
    [self getGroupID];
    
}

-(void)nextButtonDidClicked{

    SMSynopsisDoAppraisalViewController *obj = [[SMSynopsisDoAppraisalViewController alloc]initWithNibName:@"SMSynopsisDoAppraisalViewController" bundle:nil];

    [self.navigationController pushViewController:obj animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return objSMWSAvaibility.arrmAvaibility.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"SMAvailabilityViewCell";
    SMAvailabilityViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (indexPath.row == objSMWSAvaibility.arrmAvaibility.count) {
        [self configureCellTotal:dynamicCell forIndexPath:indexPath];

    }
    else{
        [self configureCell:dynamicCell forIndexPath:indexPath];
    }
            
    
       dynamicCell.backgroundColor = [UIColor blackColor];
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dynamicCell.backgroundColor = [UIColor blackColor];

    return dynamicCell;
}


-(void)configureCellTotal:(SMAvailabilityViewCell*)dynamicCell forIndexPath:(NSIndexPath *)indexPath{
    
    
    dynamicCell.availabilityTitleLabel.text =@"Total";
    
    dynamicCell.lblColumn1.text  = [NSString stringWithFormat:@"%d",iClient] ;
    dynamicCell.retailLabel.text = [NSString stringWithFormat:@"%d",iGroup] ;
    dynamicCell.tradeLabel.text  = [NSString stringWithFormat:@"%d",iProvince] ;
    dynamicCell.totalLabel.text  = [NSString stringWithFormat:@"%d",iNational] ;;
    
}

-(void)configureCell:(SMAvailabilityViewCell*)dynamicCell forIndexPath:(NSIndexPath *)indexPath{
    
    SMAvaibiltyObject *objSMAvaibiltyObject = [objSMWSAvaibility.arrmAvaibility objectAtIndex:indexPath.row];
    dynamicCell.availabilityTitleLabel.text = objSMAvaibiltyObject.strVariantName;
    dynamicCell.lblColumn1.text = objSMAvaibiltyObject.strClientAvailability;
    dynamicCell.retailLabel.text = objSMAvaibiltyObject.strGroupAvailability;
    dynamicCell.tradeLabel.text = objSMAvaibiltyObject.strProvinceAvailability;
    dynamicCell.totalLabel.text = objSMAvaibiltyObject.strNationalAvailability;
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Web Services


-(void)getGroupID{
    NSMutableURLRequest *requestURL=[SMWebServices getClientCorporateGroupsCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andClientId: [SMGlobalClass sharedInstance].strClientID.intValue];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSGroupID *wsSMWSLeadPool = [[SMWSGroupID alloc]init];
    
    [wsSMWSLeadPool responseForWebServiceForReuest:requestURL
                                          response:^(int iStatus) {
                                              [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                              
                                              [HUD hide:YES];
                                              switch (iStatus) {
                                                      
                                                  case kWSSuccess:
                                                  {
                                                      [self getAvaibility];
                                                  }
                                                      break;
                                                 
                                                      
                                                  default:{
                                                      [SMAttributeStringFormatObject handleWebServiceErrorForCode:iStatus ForViewController:self withGOBack:YES];
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
-(void) getAvaibility{
    
    iClient=iGroup=iProvince=iNational=0;
    
    NSMutableURLRequest *requestURL=[SMWebServices getAvaibilityWithUserHash:[SMGlobalClass sharedInstance].hashValue andModelID:self.strModelID andClientID:[SMGlobalClass sharedInstance].strClientID andGroupId:[SMGlobalClass sharedInstance].strGroupID];
    
    objSMWSAvaibility = [[SMObjectAvaibilityXml alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSAvaibility *wsSMWSAvaibility = [[SMWSAvaibility alloc]init];
    
    [wsSMWSAvaibility responseForWebServiceForReuest:requestURL
                                          response:^(SMObjectAvaibilityXml *objSMObjectAvaibilityXmlResult) {
                                              [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                              [HUD hide:YES];
                                              switch (objSMObjectAvaibilityXmlResult.iStatus) {
                                                      
                                                case kWSSuccess:
                                                  {
                                                      objSMWSAvaibility = objSMObjectAvaibilityXmlResult;
                                                      availabilityHeaderView.lblVehicleName.text =[NSString stringWithFormat:@"%@'s Availability",self.strModelName];
                                                      availabilityHeaderView.lblColumn1.text = @"Us";
                                                      availabilityHeaderView.lblColumn2.text = objSMWSAvaibility.strGroupName;
                                                      availabilityHeaderView.lblColumn3.text = objSMWSAvaibility.strProvinceName;
                                                      availabilityHeaderView.lblColumn4.text = @"National";
                                                      for (int i=0; i<objSMWSAvaibility.arrmAvaibility.count;i++) {
                                                          SMAvaibiltyObject *objSMAvaibiltyObject= [objSMWSAvaibility.arrmAvaibility objectAtIndex:i];
                                                          
                                                         iClient = iClient + objSMAvaibiltyObject.strClientAvailability.intValue;
                                                          
                                                         iGroup= iGroup + objSMAvaibiltyObject.strGroupAvailability.intValue;
                                                         iProvince= iProvince + objSMAvaibiltyObject.strProvinceAvailability.intValue;
                                                         iNational=iNational+ objSMAvaibiltyObject.strNationalAvailability.intValue;

                                                      }
                                                      [tblAvailabilityTableView reloadData];
                                                  }
                                                      break;
                                                      
                                                  default:
                                                  {
                                                      [SMAttributeStringFormatObject handleWebServiceErrorForCode:objSMObjectAvaibilityXmlResult.iStatus ForViewController:self withGOBack:YES];
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

@end
