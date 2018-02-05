//
//  SMLeadPoolDetailsViewController.m
//  Smart Manager
//
//  Created by Ankit S on 8/4/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMLeadPoolDetailsViewController.h"
#import "SMLeadPoolDetailsTableViewCell.h"
#import "SMLeadsHeaderTableViewCell.h"
#import "SMCustomColor.h"
#import "SMWSLeadsActive.h"
#import "SMObjectLeadsActiveXml.h"
#import "SMObjectActiveLead.h"
@interface SMLeadPoolDetailsViewController ()<MBProgressHUDDelegate>

{
    MBProgressHUD *HUD;
    IBOutlet UIView *viewHeader;
    IBOutlet UITableView *tblLeadPoolDetails;
    IBOutlet UILabel *lblHeader;
    SMObjectLeadsActiveXml *objSMObjectLeadsActiveXml;
}
@end

@implementation SMLeadPoolDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isActive) {
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Active Leads"];
    }
    else
    {
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Lost Leads"];
    }
    
    [tblLeadPoolDetails registerNib:[UINib nibWithNibName: @"SMLeadPoolDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMLeadPoolDetailsTableViewCell"];
    
    [tblLeadPoolDetails registerNib:[UINib nibWithNibName: @"SMLeadsHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMLeadsHeaderTableViewCell"];

    tblLeadPoolDetails.estimatedRowHeight = 110.0f;
    tblLeadPoolDetails.rowHeight = UITableViewAutomaticDimension;
    
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0,0,0,1.0f)];
    view.backgroundColor = [UIColor clearColor];
    tblLeadPoolDetails.tableFooterView = view;
    
    if (self.isClient) {
        [self getActiveLeads];

    }else{
        [self getActiveLeadsExcluded];
    }
       // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return objSMObjectLeadsActiveXml.arrmActiveLeads.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"SMLeadPoolDetailsTableViewCell";
    
    if (indexPath.row == 0) {
        SMLeadsHeaderTableViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:@"SMLeadsHeaderTableViewCell"];
    
        dynamicCell.lblHeader.preferredMaxLayoutWidth = self.view.frame.size.width - 16.0f;
        
        if (self.isActive) {
             dynamicCell.lblHeader.text = [NSString stringWithFormat:@"%@ Active Leads",self.strClientOrGroupName];
        }
       else
        {
            dynamicCell.lblHeader.text = [NSString stringWithFormat:@"%@ Lost Leads",self.strClientOrGroupName];
        }
        
        ifIphone{
            dynamicCell.lblHeader.font =[UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
        }
        else{
             dynamicCell.lblHeader.font =[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        }
        dynamicCell.backgroundColor = [UIColor blackColor];
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        dynamicCell.backgroundColor = [UIColor blackColor];
        return dynamicCell;
    }
    else{
    SMLeadPoolDetailsTableViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureCellForActiveLeads:dynamicCell forIndexPath:indexPath];
    dynamicCell.backgroundColor = [UIColor blackColor];
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dynamicCell.backgroundColor = [UIColor blackColor];
    return dynamicCell;
    }
}

-(void) configureCellForActiveLeads:(SMLeadPoolDetailsTableViewCell *)dynamicCell forIndexPath:(NSIndexPath *)indexPath{
    SMObjectActiveLead *objLead = [objSMObjectLeadsActiveXml.arrmActiveLeads objectAtIndex:(indexPath.row-1)];
    
    [SMAttributeStringFormatObject setAttributedTextLeadDetailBlueColourWithFirstText:objLead.strLeadID andWithSecondText:objLead.strProspectName forLabel:dynamicCell.lblRow1];
    //[SMAttributeStringFormatObject setAttributedTextLeadDetailWhiteColourWithFirstText:@"2010" andWithSecondText:@"Volkswagen Sharan 1.8 turbo" forLabel:dynamicCell.lblRow2];
    
    NSString *strFriendlyName = [NSString stringWithFormat:@"%@ %@ %@",objLead.strMakeName,objLead.strModelName,objLead.strVariantName];
    if (objLead.strYear.length == 0) {
        objLead.strYear = @"Year?";
    }
    [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstText:objLead.strYear andWithSecondText:strFriendlyName forLabel:dynamicCell.lblRow2];
    
    [SMAttributeStringFormatObject setAttributedTextLeadDetailWhiteColourWithFirstText:objLead.strProspectContactNumber andWithSecondText:objLead.strProspectEmail forLabel:dynamicCell.lblRow3];
    
    if ([self.strLeadStatusId isEqualToString:@"1"]){
        [SMAttributeStringFormatObject setAttributedTextLeadDetailRedColourWithFirstText:[NSString stringWithFormat:@"Last update: %@ days ago",objLead.strLeadAgeInDays] andWithSecondText:[NSString stringWithFormat:@"by %@",objLead.strSalesPerson] withSize:13.0 forLabel:dynamicCell.lblRow4];
    }
    else
    {
        [SMAttributeStringFormatObject setAttributedTextLeadDetailRedColourWithFirstText:[NSString stringWithFormat:@"Closed %@ days ago",objLead.strLeadAgeInDays] andWithSecondText:[NSString stringWithFormat:@"by %@",objLead.strSalesPerson] withSize:13.0 forLabel:dynamicCell.lblRow4];
    }

}

-(void) getActiveLeads{
    
     NSMutableURLRequest *requestURL=[SMWebServices getLeadPoolForClient:[SMGlobalClass sharedInstance].hashValue andModelId:self.strModelId andYear:self.strYear andClientId:[SMGlobalClass sharedInstance].strClientID andLeadStatusId:self.strLeadStatusId];
    
   // NSMutableURLRequest *requestURL=[SMWebServices getLeadPoolForClient:[SMGlobalClass sharedInstance].hashValue andModelId:@"2123" andYear:@"2016" andClientId:@"12703" andLeadStatusId:self.strLeadStatusId];
    
    objSMObjectLeadsActiveXml = [[SMObjectLeadsActiveXml alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSLeadsActive *wsSMWSLeadsActive = [[SMWSLeadsActive alloc]init];
    
    [wsSMWSLeadsActive responseForWebServiceForReuest:requestURL
                                             response:^(SMObjectLeadsActiveXml *objSMObjectLeadsActiveXmlResult) {
                                                 [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                 [HUD hide:YES];
                                                 switch (objSMObjectLeadsActiveXmlResult.iStatus) {
                                                         
                                                     
                                                     case kWSSuccess:
                                                     {
                                                         objSMObjectLeadsActiveXml = objSMObjectLeadsActiveXmlResult;
                                                         [tblLeadPoolDetails reloadData];
                                                     }
                                                         break;
                                                         
                                                     default:
                                                     {
                                                         [SMAttributeStringFormatObject handleWebServiceErrorForCode:objSMObjectLeadsActiveXmlResult.iStatus ForViewController:self withGOBack:YES];
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


-(void) getActiveLeadsExcluded{
  
    NSMutableURLRequest *requestURL=[SMWebServices getLeadPoolForGroupExcludeClient:[SMGlobalClass sharedInstance].hashValue andModelId:self.strModelId andYear:self.strYear andGroupID:[SMGlobalClass sharedInstance].strGroupID andClientId:[SMGlobalClass sharedInstance].strClientID andLeadStatusId:self.strLeadStatusId];
    
     objSMObjectLeadsActiveXml = [[SMObjectLeadsActiveXml alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSLeadsActive *wsSMWSLeadsActive = [[SMWSLeadsActive alloc]init];
    
    [wsSMWSLeadsActive responseForWebServiceForReuest:requestURL
                                          response:^(SMObjectLeadsActiveXml *objSMObjectLeadsActiveXmlResult) {
                                              [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                              [HUD hide:YES];
                                              switch (objSMObjectLeadsActiveXmlResult.iStatus) {
                                                      
                                                  case kWSSuccess:
                                                  {
                                                      objSMObjectLeadsActiveXml = objSMObjectLeadsActiveXmlResult;
                                                      [tblLeadPoolDetails reloadData];
                                                  }
                                                      break;
                                                      
                                                  default:
                                                  {
                                                      [SMAttributeStringFormatObject handleWebServiceErrorForCode:objSMObjectLeadsActiveXmlResult.iStatus ForViewController:self withGOBack:YES];
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
