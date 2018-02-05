//
//  SMSynopsisFarwordAppraisalViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 25/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMSynopsisFarwordAppraisalViewController.h"
#import "SMCustomColor.h"
#import "SMOEMSpecsHeaderView.h"
#import "SMSynopsisAppraisalHeaderCell.h"
#import "SMForwardATableViewCell.h"
#import "SMSellerViewCell.h"
@interface SMSynopsisFarwordAppraisalViewController ()
{
    IBOutlet UITableView *tblAppraisal;
    NSArray *arrForButtonHeading;
    NSArray *arrSellerTitle;
    NSArray *arrPurchaseDetails;
    NSArray *arrCondition;
    NSMutableArray *arrmVehicleExtras;
    NSMutableArray *arrmInteriorReconditioning;
    NSMutableArray *arrmEngineDrivetrain;
    NSMutableArray *arrmExteriorReconditioning;
    NSInteger intShowCellsForSection;
}
@end

@implementation SMSynopsisFarwordAppraisalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.titleView = [SMCustomColor setTitle:@"View / Send Appraisal"];
     arrForButtonHeading = [[NSArray alloc] initWithObjects:@"",@"Seller",@"Purchase Details",@"Condition",@"Vehicle Extras",@"Interior Reconditioning",@"Engine & Drivetrain",@"Exterior Reconditioning", nil ];
    
     arrSellerTitle = [[NSArray alloc] initWithObjects:@"Name",@"Surname",@"Company",@"ID",@" ",@"Email",@"Mobile",@"Street Address", nil ];

     arrPurchaseDetails = [[NSArray alloc] initWithObjects:@"Bought From",@"Date",@"Finance House",@"View/Send Appraisal",@"Account No.",@"Details",@"Comments", nil ];
    
     arrCondition = [[NSArray alloc] initWithObjects:@"Car Driven?",@"Full Service History?",@"Seen Service Book?",@"Toolkit?",@"Spare Keys?",@"Within Warranty?",@"Mileage Genuine?",@"Mileage Normal?",@"Been in Accident?",@"Stolen & Recovered?",@"Fleet / Rental veh?",@"Conclusion-",@"Overall Condition",@"Comments", nil ];
    
    arrmVehicleExtras = [[NSMutableArray alloc] init];
    [arrmVehicleExtras addObject:@"Tow bar"];
    [arrmVehicleExtras addObject:@"Total"];
    
    arrmInteriorReconditioning = [[NSMutableArray alloc] init];
    [arrmInteriorReconditioning addObject:@"Interior Smell"];
    [arrmInteriorReconditioning addObject:@"Total"];

    arrmEngineDrivetrain = [[NSMutableArray alloc] init];
    [arrmEngineDrivetrain addObject:@"Service Required"];
    [arrmEngineDrivetrain addObject:@"Total"];
    
    arrmExteriorReconditioning = [[NSMutableArray alloc] init];
    [arrmExteriorReconditioning addObject:@"Rim, RF - Repair"];
    [arrmExteriorReconditioning addObject:@"Rim, LR - Replace"];
    [arrmExteriorReconditioning addObject:@"Total"];
    
    [self registerTableComponents];
    tblAppraisal.estimatedSectionHeaderHeight = 60.0f;
    tblAppraisal.tableFooterView = [[UIView alloc]init];
    intShowCellsForSection = -1; //To store which section is tapped and it is used for showing cells for particular that cell
    tblAppraisal.estimatedRowHeight = 140.0f;
    tblAppraisal.rowHeight = UITableViewAutomaticDimension;
       // Do any additional setup after loading the view from its nib.
}


-(void)registerTableComponents{
    [tblAppraisal registerNib:[UINib nibWithNibName:@"SMOEMSpecsHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"SMOEMSpecsHeaderView"];
    
    [tblAppraisal registerNib:[UINib nibWithNibName:@"SMSynopsisAppraisalHeaderCell" bundle:nil] forCellReuseIdentifier:@"SMSynopsisAppraisalHeaderCell"];
    
    [tblAppraisal registerNib:[UINib nibWithNibName:@"SMForwardATableViewCell" bundle:nil] forCellReuseIdentifier:@"SMForwardATableViewCell"];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
       [tblAppraisal registerNib:[UINib nibWithNibName:@"SMSellerViewCell" bundle:nil] forCellReuseIdentifier:@"SMSellerViewCell"];    }
    else{
        
             [tblAppraisal registerNib:[UINib nibWithNibName:@"SMSellerViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMSellerViewCell"];
    }
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate and datasource Methods

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrForButtonHeading.count;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return nil;
    }
    SMOEMSpecsHeaderView *header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SMOEMSpecsHeaderView"];
    header.btnSpecification.tag = section;
    [header.btnSpecification setTitle:[arrForButtonHeading objectAtIndex:section] forState:UIControlStateNormal];
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
        return 0;
    else
    return 56.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    switch (section) {
        case 0:
            return 1;
            break;
        
            
        case 1:
        {
            if(intShowCellsForSection==section)
                return arrSellerTitle.count;
            else
                return 0;
        }
            break;
          
        case 2:
        {
            if(intShowCellsForSection==section)
                return arrPurchaseDetails.count;
            else
                return 0;
        }
            break;
            

        case 3:
        {
            if(intShowCellsForSection==section)
                return arrCondition.count;
            else
                return 0;
        }
            break;
            
        case 4:
        {
            if(intShowCellsForSection==section)
                return arrmVehicleExtras.count;
            else
                return 0;
        }

            break;
            
        case 5:
        {
            if(intShowCellsForSection==section)
                return arrmInteriorReconditioning.count;
            else
                return 0;
        }

            break;
            
        case 6:
        {
            if(intShowCellsForSection==section)
                return arrmEngineDrivetrain.count;
            else
                return 0;
        }

            break;
            
        case 7:
        {
            if(intShowCellsForSection==section)
                return arrmExteriorReconditioning.count;
            else
                return 0;
        }

            break;
            
        default:
           break;
    }
    
    if(intShowCellsForSection==section)
        return 0;
    else
        return 0;

}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0://Header with Photo on right side
        {
            static NSString *cellIdentifier= @"SMSynopsisAppraisalHeaderCell";
            SMSynopsisAppraisalHeaderCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstText:@"2010" andWithSecondText:@"Volkswagen Polo Hatch 1.4 Comfortline" forLabel: dynamicCell.lblNameYear];
            
            dynamicCell.lblDetails.text = @"1396cc, 76kW, 210Nm, Petrol, Manual, Hatch. Avail as new from Jan 2010 to Dec 2014";
            dynamicCell.lblDate.text = @"Date: Mon 12 Dec 2015";
            dynamicCell.lblAppraiser.text = @"Appraiser: Dave Johnson";

            return dynamicCell;
        }
            break;
            
        case 1:// For Seller
            
            switch (indexPath.row) {
                case 4:
                {    static NSString *cellIdentifier= @"SMSellerViewCell";
                       SMSellerViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                        dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
                        dynamicCell.backgroundColor = [UIColor blackColor];
                        return dynamicCell;
                    }
                    break;
                    
                default: {
                    static NSString *cellIdentifier= @"SMForwardATableViewCell";
                     SMForwardATableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    dynamicCell.backgroundColor = [UIColor blackColor];
                    dynamicCell.lblTitle.text = [arrSellerTitle objectAtIndex:indexPath.row];
                    return dynamicCell;
                }
                    

                   
                    break;
            }
            
            break;
            
        case 2: {
            static NSString *cellIdentifier= @"SMForwardATableViewCell";
            SMForwardATableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.lblTitle.text = [arrPurchaseDetails objectAtIndex:indexPath.row];
            return dynamicCell;
        }

            
            break;
            
        case 3:
        {
            static NSString *cellIdentifier= @"SMForwardATableViewCell";
            SMForwardATableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.lblTitle.text = [arrCondition objectAtIndex:indexPath.row];
            [dynamicCell layoutIfNeeded];
            return dynamicCell;
        }

            break;
            
        case 4:
        {
            static NSString *cellIdentifier= @"SMForwardATableViewCell";
            SMForwardATableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.lblTitle.text = [arrmVehicleExtras objectAtIndex:indexPath.row];
            return dynamicCell;
        }

            break;
            
        case 5:
        {
            static NSString *cellIdentifier= @"SMForwardATableViewCell";
            SMForwardATableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.lblTitle.text = [arrmInteriorReconditioning objectAtIndex:indexPath.row];
            return dynamicCell;
        }

            break;
            
        case 6:
        {
            static NSString *cellIdentifier= @"SMForwardATableViewCell";
            SMForwardATableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.lblTitle.text = [arrmEngineDrivetrain objectAtIndex:indexPath.row];
            return dynamicCell;
        }

            break;
            
        case 7:
        {
            static NSString *cellIdentifier= @"SMForwardATableViewCell";
            SMForwardATableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.lblTitle.text = [arrmExteriorReconditioning objectAtIndex:indexPath.row];
            return dynamicCell;
        }

            break;
        default:
            break;
    }
    static NSString *cellIdentifier= @"SMOEMSpecsTableViewCell";
    SMSynopsisAppraisalHeaderCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
    dynamicCell.backgroundColor = [UIColor blackColor];
    
    return dynamicCell;

  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1)
    {
        if(indexPath.row == 4)
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
            return 95.0f;
            }
            else
            {
                 return 135.0f;
            }
        }
        else
        {
            return UITableViewAutomaticDimension;
        }
    }
    else
    {
        return UITableViewAutomaticDimension;
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
    
    [tblAppraisal reloadData];
    
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
