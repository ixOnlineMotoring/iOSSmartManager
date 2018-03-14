//
//  SMLeadPoolViewController.m
//  Smart Manager
//
//  Created by Sandeep on 23/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMLeadPoolViewController.h"
#import "SMCustomColor.h"
#import "SMWSLeadPool.h"
#import "SMLeadPoolDetailsViewController.h"
#import "SMWSGroupID.h"

@interface SMLeadPoolViewController ()<MBProgressHUDDelegate>
{
    SMObjectLeadPoolXml *objSMObjectLeadPoolXml;
    MBProgressHUD *HUD;
}
@end

@implementation SMLeadPoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Lead Pool"];
    NSArray *arraySMLeadPoolView = [[NSBundle mainBundle]loadNibNamed:@"SMLeadPoolView" owner:self options:nil];
    loadPoolViewObj = [arraySMLeadPoolView objectAtIndex:0];
    tblLoadPoolView.tableHeaderView = loadPoolViewObj;
    
    [SMAttributeStringFormatObject setAttributedTextLeadPoolHeaderFullColourWithFirstText:@"The following lead prospects are/were interested in a new or used" andWithSecondText:self.strModelName forLabel:loadPoolViewObj.lblHeader];
    
    NSArray *arraySMLeadPoolFooterView = [[NSBundle mainBundle]loadNibNamed:@"SMLeadPoolFooterView" owner:self options:nil];
    leadPoolFooterView = [arraySMLeadPoolFooterView objectAtIndex:0];
    tblLoadPoolView.tableFooterView = leadPoolFooterView;

    tblLoadPoolView.estimatedRowHeight = 44.0;
    tblLoadPoolView.rowHeight = UITableViewAutomaticDimension;
    //tblLoadPoolView.tableFooterView = [[UIView alloc]init];

    [tblLoadPoolView registerNib:[UINib nibWithNibName: @"SMLeadPoolViewCell" bundle:nil] forCellReuseIdentifier:@"SMLeadPoolViewCell"];

    [self getLeadPoolGroupId];
}
-(void)nextButtonDidClicked{

    SMReviewsViewController *obj = [[SMReviewsViewController alloc]initWithNibName:@"SMReviewsViewController" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (objSMObjectLeadPoolXml.iStatus == kWSSuccess) {
        return 2;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"SMLeadPoolViewCell";
    
    SMLeadPoolViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    switch (indexPath.row) {
        case kLPClient:
        {
            [self configureCellForClient:dynamicCell forIndexPath:indexPath];
        }
            break;
            
        case kLPGroup:
        {
            [self configureCellForGroup:dynamicCell forIndexPath:indexPath];
        }
            break;

        default:
            break;
    }

    dynamicCell.backgroundColor = [UIColor blackColor];
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dynamicCell.backgroundColor = [UIColor blackColor];

    return dynamicCell;
}

-(void) configureCellForClient:(SMLeadPoolViewCell *)dynamicCell forIndexPath:(NSIndexPath *)indexPath{
    
    dynamicCell.leadToolTitleLabel.text = objSMObjectLeadPoolXml.strClientName;
    [SMAttributeStringFormatObject setButtonUnderlineText:objSMObjectLeadPoolXml.strClientActiveLeads withColour:[UIColor whiteColor] forButton:dynamicCell.btnActive];
    [SMAttributeStringFormatObject setButtonUnderlineText:objSMObjectLeadPoolXml.strClientLostLeads withColour:[UIColor whiteColor] forButton:dynamicCell.btnClose];
    
    [dynamicCell.btnActive addTarget:self action:@selector(btnActiveDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [dynamicCell.btnClose addTarget:self action:@selector(btnClosedDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [dynamicCell.btnClose setTag:indexPath.row];
    [dynamicCell.btnActive setTag:indexPath.row];

}

-(void) configureCellForGroup:(SMLeadPoolViewCell *)dynamicCell forIndexPath:(NSIndexPath *)indexPath{
    dynamicCell.leadToolTitleLabel.text = objSMObjectLeadPoolXml.strGroupName;
    
    //[SMAttributeStringFormatObject setButtonUnderlineText:objSMObjectLeadPoolXml.strGroupActiveLeads withColour:[UIColor whiteColor] forButton:dynamicCell.btnActive];
    
    [dynamicCell.btnActive setTitle:objSMObjectLeadPoolXml.strGroupActiveLeads forState:UIControlStateNormal];
    [SMAttributeStringFormatObject setButtonUnderlineText:objSMObjectLeadPoolXml.strGroupLostLeads withColour:[UIColor whiteColor] forButton:dynamicCell.btnClose];
    
    [dynamicCell.btnActive addTarget:self action:@selector(btnActiveDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [dynamicCell.btnClose addTarget:self action:@selector(btnClosedDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [dynamicCell.btnClose setTag:indexPath.row];
    [dynamicCell.btnActive setTag:indexPath.row];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web Services

-(void) getLeadPoolGroupId{
    
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
                                                      [self getLeadPoolSummary];
                                                  }
                                                      break;
                                                
                                                  default:
                                                  {
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

-(void) getLeadPoolSummary{
    
    NSMutableURLRequest *requestURL=[SMWebServices getLeadPoolSummary:[SMGlobalClass sharedInstance].hashValue  andModelId:self.strModelId andYear:self.strYear andClientId:[SMGlobalClass sharedInstance].strClientID  andGroupId:[SMGlobalClass sharedInstance].strGroupID];
    
    objSMObjectLeadPoolXml = [[SMObjectLeadPoolXml alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSLeadPool *wsSMWSLeadPool = [[SMWSLeadPool alloc]init];
    
    [wsSMWSLeadPool responseForWebServiceForReuest:requestURL
                                            response:^(SMObjectLeadPoolXml *objSMObjectLeadPoolXmlResult) {
                                                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                [HUD hide:YES];
                                                switch (objSMObjectLeadPoolXmlResult.iStatus) {
                                                        
                                                
                                                    case kWSSuccess:
                                                    {
                                                            objSMObjectLeadPoolXml = objSMObjectLeadPoolXmlResult;
                                                            [tblLoadPoolView reloadData];
                                                    }
                                                        break;
                                                        
                                                    default:
                                                    {
                                                        [SMAttributeStringFormatObject handleWebServiceErrorForCode:objSMObjectLeadPoolXmlResult.iStatus ForViewController:self withGOBack:YES];
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

-(void)btnActiveDidClicked:(UIButton *)btn{
    
    switch (btn.tag) {
        case kLPClient:
        {
            if ([objSMObjectLeadPoolXml.strClientActiveLeads isEqualToString:@"0"]) {
               
            }
            else
            {
                [self moveAToDetailsWithisClient:YES withLeadStatusId:@"1" andisActive:YES];
            }
            
        }
            break;
            
        case kLPGroup:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

-(void)btnClosedDidClicked:(UIButton *)btn{
    
    
    switch (btn.tag) {
        case kLPClient:
        {
            if ([objSMObjectLeadPoolXml.strClientLostLeads isEqualToString:@"0"]) {
                
            }
            else
            {
             [self moveAToDetailsWithisClient:YES withLeadStatusId:@"3" andisActive:NO];
            }
        }
            break;
            
        case kLPGroup:
        {
            if ([objSMObjectLeadPoolXml.strGroupLostLeads isEqualToString:@"0"]) {
                
            }
            else
            {
             [self moveAToDetailsWithisClient:NO withLeadStatusId:@"3" andisActive:NO];
            }
        }
            break;
            
        default:
            break;
    }
    
}



-(void)moveAToDetailsWithisClient:(BOOL)isClient withLeadStatusId:(NSString *) strLeadStatusId andisActive:(BOOL ) isActive{
    
    SMLeadPoolDetailsViewController *synopsisSMLeadPoolDetailsViewController;
    synopsisSMLeadPoolDetailsViewController = [[SMLeadPoolDetailsViewController alloc] initWithNibName:@"SMLeadPoolDetailsViewController" bundle:nil];
    synopsisSMLeadPoolDetailsViewController.strYear = self.strYear;
    synopsisSMLeadPoolDetailsViewController.strModelId = self.strModelId;
    if (isClient) {
        synopsisSMLeadPoolDetailsViewController.strClientOrGroupName = objSMObjectLeadPoolXml.strClientName;
    }
    else{
        synopsisSMLeadPoolDetailsViewController.strClientOrGroupName = objSMObjectLeadPoolXml.strGroupName;
    }
    synopsisSMLeadPoolDetailsViewController.strLeadStatusId = strLeadStatusId;
    synopsisSMLeadPoolDetailsViewController.isActive = isActive;
    synopsisSMLeadPoolDetailsViewController.isClient = isClient;
    [self.navigationController pushViewController:synopsisSMLeadPoolDetailsViewController animated:YES];
    
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
