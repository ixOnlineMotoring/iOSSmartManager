//
//  SMOEMSpecsViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 05/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMOEMSpecsViewController.h"
#include "SMCustomColor.h"
#import "SMOEMSpecsHeaderView.h"
#import "SMOEMSpecsTableViewCell.h"
#import "SMWebServices.h"
#import "MBProgressHUD.h"
#import "SMGlobalClass.h"
#import "SMWSforOEMSpecsDetails.h"
#import "SMCustomSavedVINTableViewCell.h"

@interface SMOEMSpecsViewController ()<MBProgressHUDDelegate>
{
    IBOutlet UITableView *tblOEMSpecs;
    NSInteger intShowCellsForSection;
    NSArray *arrForButtonHeading;
    MBProgressHUD *HUD;
    SMOEMSpecsXMLObject *objSMOEMSpecsXMLObject;
//    SMOEMSpecsDetails *objSMOEMSpecsDetails;
//    SMOEMSpecsDetailsSpecification *objSMOEMSpecsDetailsSpecification;
}
@end

@implementation SMOEMSpecsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"OEM Specs"];
    arrForButtonHeading = [[NSArray alloc] initWithObjects:@"Disclaimer",@"Engine & Gearbox",@"Dimensions",@"Features",@"Suspension & Drivetrain",@"Safety & Security",@"Plans Valid from First \n Year of Registration", nil ];
    [self registerTableComponents];
    tblOEMSpecs.estimatedSectionHeaderHeight = 60.0f;
    intShowCellsForSection = -1; //To store which section is tapped and it is used for showing cells for particular that cell
    tblOEMSpecs.estimatedRowHeight = 25.0f;
    tblOEMSpecs.rowHeight = UITableViewAutomaticDimension;
    
    [self getOEMSpecsDetails];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registerTableComponents{
    [tblOEMSpecs registerNib:[UINib nibWithNibName:@"SMOEMSpecsHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"SMOEMSpecsHeaderView"];
    
    [tblOEMSpecs registerNib:[UINib nibWithNibName:@"SMOEMSpecsTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMOEMSpecsTableViewCell"];
    [tblOEMSpecs registerNib:[UINib nibWithNibName:@"SMCustomSavedVINTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMCustomSavedVINTableViewCell"];
    
}

#pragma mark - Table View Delegate and datasource Methods

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    if (objSMOEMSpecsXMLObject.strDisclaimer.length == 0) {
        return objSMOEMSpecsXMLObject.arrmForDetails.count;
    }
    else
    {
        return (objSMOEMSpecsXMLObject.arrmForDetails.count + 1);
    }
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SMOEMSpecsHeaderView *header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SMOEMSpecsHeaderView"];
    header.btnSpecification.tag = section;
  
    header.contentView.backgroundColor = [UIColor blackColor];
    if (section == 0) {
        if (objSMOEMSpecsXMLObject.strDisclaimer.length == 0) {
             SMOEMSpecsDetails *  objSMOEMSpecsDetails = [objSMOEMSpecsXMLObject.arrmForDetails objectAtIndex:section];
            [header.btnSpecification setTitle:objSMOEMSpecsDetails.strOEMDetailsTitle forState:UIControlStateNormal];
        }
        else
        {
            [header.btnSpecification setTitle:@"Disclaimer" forState:UIControlStateNormal];
        }
    }
    else
    {
          SMOEMSpecsDetails *  objSMOEMSpecsDetails = [objSMOEMSpecsXMLObject.arrmForDetails objectAtIndex:(section-1)];
          [header.btnSpecification setTitle:objSMOEMSpecsDetails.strOEMDetailsTitle forState:UIControlStateNormal];
    }
    
    [header.btnSpecification addTarget:self action:@selector(btnSpecificationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    if(intShowCellsForSection == section)
    {
        [header.imgArrow setImage:[UIImage imageNamed:@"down_arrowSelected"]];
    }
    else
    {
        [header.imgArrow setImage:[UIImage imageNamed:@"down_arrowT"]];
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
             return 40.0f;
        }
        else
        {
             return 56.0f;
        }
        
    }
    
        if (objSMOEMSpecsXMLObject.strDisclaimer.length == 0) {
            SMOEMSpecsDetails *  objSMOEMSpecsDetails = [objSMOEMSpecsXMLObject.arrmForDetails objectAtIndex:(section - 1)];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                if(section == (objSMOEMSpecsDetails.arrmOEMDetails.count-1))
                    return 61.0f;
                else
                    return 40.0f;
                
            }
            else
                if(section == (objSMOEMSpecsDetails.arrmOEMDetails.count-1))
                    return 76.0f;
                else
                    return 56.0f;

        }
        else
        {
            SMOEMSpecsDetails *  objSMOEMSpecsDetails = [objSMOEMSpecsXMLObject.arrmForDetails objectAtIndex:(section - 1)];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                if(section == (objSMOEMSpecsDetails.arrmOEMDetails.count))
                    return 61.0f;
                else
                    return 40.0f;
                
            }
            else
                if(section == (objSMOEMSpecsDetails.arrmOEMDetails.count))
                    return 76.0f;
                else
                    return 56.0f;

        }
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(intShowCellsForSection==section)
    {
        if (section == 0) {
            if (objSMOEMSpecsXMLObject.strDisclaimer.length == 0) {
             SMOEMSpecsDetails *objSMOEMSpecsDetails = [objSMOEMSpecsXMLObject.arrmForDetails objectAtIndex:section];
                return objSMOEMSpecsDetails.arrmOEMDetails.count;
            }
            else
            {
                return 1;
            }
        }
        else
        {
           SMOEMSpecsDetails *objSMOEMSpecsDetails = [objSMOEMSpecsXMLObject.arrmForDetails objectAtIndex:(section-1)];
            return objSMOEMSpecsDetails.arrmOEMDetails.count;
        }

    }
    else
        return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier= @"SMOEMSpecsTableViewCell";
    if (indexPath.section == 0) {
        if (objSMOEMSpecsXMLObject.strDisclaimer.length == 0) {
           
            SMOEMSpecsTableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            SMOEMSpecsDetails *objSMOEMSpecsDetails = [objSMOEMSpecsXMLObject.arrmForDetails objectAtIndex:(indexPath.section)];
            SMOEMSpecsDetailsSpecification *objSMOEMSpecsDetailsSpecification = [objSMOEMSpecsDetails.arrmOEMDetails objectAtIndex:indexPath.row];
            dynamicCell.lblName.text = objSMOEMSpecsDetailsSpecification.strSpecsTitle;
            dynamicCell.lblPrice.text =objSMOEMSpecsDetailsSpecification.strSpecsValue;
            return dynamicCell;
        }
        else
        {   NSString *cellIdentifier1= @"SMCustomSavedVINTableViewCell";
            
            SMCustomSavedVINTableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.lblTime.text = objSMOEMSpecsXMLObject.strDisclaimer;
            return dynamicCell;
         }
    }
    else
    {
        SMOEMSpecsTableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
        dynamicCell.backgroundColor = [UIColor blackColor];
        SMOEMSpecsDetails *objSMOEMSpecsDetails = [objSMOEMSpecsXMLObject.arrmForDetails objectAtIndex:(indexPath.section - 1)];
        SMOEMSpecsDetailsSpecification *objSMOEMSpecsDetailsSpecification = [objSMOEMSpecsDetails.arrmOEMDetails objectAtIndex:indexPath.row];
        dynamicCell.lblName.text = objSMOEMSpecsDetailsSpecification.strSpecsTitle;
        dynamicCell.lblPrice.text =objSMOEMSpecsDetailsSpecification.strSpecsValue;
        return dynamicCell;

    }

}


-(IBAction)btnSpecificationDidClicked:(UIButton*)sender
{
    NSLog(@"Button clicked");
    if(sender.tag != intShowCellsForSection)
    {
        intShowCellsForSection = sender.tag;
    }
    else
    {
        intShowCellsForSection = -1;
    }
    
    [tblOEMSpecs reloadData];
    
}


#pragma mark - Web Services
-(void) getOEMSpecsDetails{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingOEMSpecsDetails:[SMGlobalClass sharedInstance].hashValue Year:self.strYear variantID:self.strVariantId];
   
    objSMOEMSpecsXMLObject = [[SMOEMSpecsXMLObject alloc] init];

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSforOEMSpecsDetails *wsOEMSpecsDetails = [[SMWSforOEMSpecsDetails alloc]init];
    
    [wsOEMSpecsDetails responseForWebServiceForReuest:requestURL
                                            response:^(SMOEMSpecsXMLObject *objSMOEMSpecsXMLObjectResult) {
                                                
                                                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                [self hideProgressHUD];
                                                
                                                switch (objSMOEMSpecsXMLObjectResult.iStatus) {
                                                        
                                                    case kWSSuccess:
                                                    {
                                                        objSMOEMSpecsXMLObject = objSMOEMSpecsXMLObjectResult;
                                                        if (objSMOEMSpecsXMLObject.strDisclaimer == nil) {
                                                            objSMOEMSpecsXMLObject.strDisclaimer = @"";
                                                        }
                                                        [tblOEMSpecs reloadData];
                                                    }
                                                        break;
                                                        
                                                    default:
                                                    {
                                                        [SMAttributeStringFormatObject handleWebServiceErrorForCode:objSMOEMSpecsXMLObjectResult.iStatus ForViewController:self withGOBack:YES];
                                                    }
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
