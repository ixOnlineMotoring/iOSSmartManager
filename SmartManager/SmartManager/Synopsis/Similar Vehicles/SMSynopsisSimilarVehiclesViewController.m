//
//  SMSynopsisSimilarVehiclesViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 13/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMSynopsisSimilarVehiclesViewController.h"
#import "SMClassForToDoObjects.h"
#import "SMClassForToDoInnerObjects.h"
#import "SMCustomColor.h"
#import "SMSynopsisSimilarVehiclesCell.h"
#import "SMWSSimilarVehicle.h"

@interface SMSynopsisSimilarVehiclesViewController ()<MBProgressHUDDelegate>
{
    
    MBProgressHUD *HUD;
    IBOutlet UILabel *lblNameHeader;
    NSMutableArray *arrmDetails;
    SMSimilarVehicleXmlObject *objSMSimilarVehicleXmlObject;
}
@end

@implementation SMSynopsisSimilarVehiclesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    tblViewSimilarVehicles.delegate = self;
    tblViewSimilarVehicles.dataSource = self;
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Similar Vehicles"];
    arrmDetails = [[NSMutableArray alloc] init];
    
    [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstText:self.strYear andWithSecondText:self.strFriendlyName forLabel:lblNameHeader];
    
    tblViewSimilarVehicles.tableHeaderView = headerView;
    
    [tblViewSimilarVehicles registerNib:[UINib nibWithNibName:@"SMSynopsisSimilarVehiclesCell" bundle:nil] forCellReuseIdentifier:@"SMSynopsisSimilarVehiclesCell"];
    tblViewSimilarVehicles.estimatedRowHeight = 44.0f;
    tblViewSimilarVehicles.rowHeight = UITableViewAutomaticDimension;
    [self populateTheSectionsArray];
    //[self getArrayData];
     tblViewSimilarVehicles.tableFooterView = [[UIView alloc]init];
    [self getSimilarVehicles];
    // Do any additional setup after loading the view from its nib.
}

-(void)getArrayData{
    
    for (int i=0; i < 5; i++) {
        
        [arrmDetails addObject:@"2009 Polo Sedan 1.4 Comfortline(Man, Petrol)"];
    }
    
   
    //[tblViewSimilarVehicles reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Tableview datasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [arrayForSections count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:section];
    
    
    if (sectionObject.isExpanded)
    {
        //return sectionObject.arrayOfInnerObjects.count;
        return arrmDetails.count;
    }
    
    else
    {
        return 0;
    }

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            return 40;
        }
        else
        {
            return 50;
        }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSynopsisSimilarVehiclesCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SMSynopsisSimilarVehiclesCell"];
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.lblVehicleName.text = [arrmDetails objectAtIndex:indexPath.row] ;// @"2009 Polo Sedan 1.4 Comfortline(Man,Petrol)";
//    cell.lblVehicleName.preferredMaxLayoutWidth = cell.frame.size.width;
//    [cell layoutIfNeeded];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:section];
    
    return sectionObject.strSectionName;
    
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView1 = [[UIView alloc] init];
    UIView *headerColorView = [[UIView alloc] init];
    UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
    
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:section];
    
    imageViewArrowForsection = [[UIImageView alloc]init];
    
    imageViewArrowForsection.contentMode = UIViewContentModeScaleAspectFit;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [headerView1 setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
        [headerColorView setFrame:CGRectMake(8, 0, tableView.bounds.size.width-16, 30)];
        sectionLabelBtn.frame = CGRectMake(7, -5, tableView.bounds.size.width,30);
        sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
        [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-40,5,20,20)];
    }
    else
    {
        [headerView1 setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
        [headerColorView setFrame:CGRectMake(8, 0, tableView.bounds.size.width-16, 40)];
        sectionLabelBtn.frame = CGRectMake(7, -5, tableView.bounds.size.width,40);
        sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-40,10,20,20)];
    }
    
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(7.0, 5.0, 0.0, 0.0);
    else
        sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(7.0, 5.0, 0.0, 0.0);
        
    sectionLabelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
     UIImage *image = [UIImage imageNamed:@"side_Arrow.png"];
    if(sectionObject.isExpanded)
    {
        
//        [UIView animateWithDuration:2 animations:^
//         {
//             if (sectionObject.arrayOfInnerObjects.count>0)
//             {
//                 imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
//             }
//         }
//                         completion:nil];
        
        
        image = [UIImage imageNamed:@"down_arrowSelected"];

    }
   
    [imageViewArrowForsection setImage:image];
    
    countLbl = [[UILabel alloc]initWithFrame:CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-45,5, 20, 20)];
    
    countLbl.textColor = [UIColor whiteColor];
    countLbl.textAlignment = NSTextAlignmentCenter;
    countLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    countLbl.layer.borderWidth = 1.0;
    countLbl.layer.masksToBounds = YES;
    countLbl.font = [UIFont fontWithName:FONT_NAME size:15.0f];
    
    //countLbl.text = [NSString stringWithFormat:@"%d",sectionObject.arrayOfInnerObjects.count];
    
    countLbl.layer.cornerRadius = countLbl.frame.size.width/2;
    
    [self setTheLabelCountText:(int)sectionObject.arrayOfInnerObjects.count];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width,5, countLbl.frame.size.width, 20);
    }
    else
    {
        countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width,10, countLbl.frame.size.width, 20);
    }
    
    [headerColorView addSubview:countLbl];
    
    [headerColorView addSubview:imageViewArrowForsection];
    
    headerView1.backgroundColor = [UIColor clearColor];
    
    headerColorView.backgroundColor=[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
    
   // headerColorView.backgroundColor=[UIColor colorWithRed:85.0/255 green:175.0/255 blue:19.0/255 alpha:1.0];
    
    [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sectionLabelBtn addTarget:self action:@selector(btnSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sectionLabelBtn setTag:section];
    sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    
    [sectionLabelBtn setTitle:sectionObject.strSectionName forState:UIControlStateNormal];
    
    
    
    [headerColorView addSubview:sectionLabelBtn];
    headerColorView.layer.cornerRadius = 5.0f;
    [headerView1 addSubview:headerColorView];
    headerView1.clipsToBounds = YES;
    return headerView1;
    
}

-(void)populateTheSectionsArray
{
    
    arrayForSections = [[NSMutableArray alloc]init];
    
    NSArray *arrayOfSectionNames = [[NSArray alloc]initWithObjects:@"A year younger",@"Other models of the same year",@"A year older", nil];
    
    
    for(int i=0;i<3;i++)
    {
        SMClassForToDoObjects *sectionObject = [[SMClassForToDoObjects alloc]init];
        sectionObject.strSectionID = i+1;
        sectionObject.strSectionName = [arrayOfSectionNames objectAtIndex:i];
        [arrayForSections addObject:sectionObject];
        
    }
    
    
}
-(IBAction)btnSectionTitleDidClicked:(id)sender
{
    
    NSLog(@"sender tag %ld",(long)[sender tag]);
    
    // if([sender tag] == 0)
    // return;
    
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:[sender tag]];
    sectionObject.isExpanded = !sectionObject.isExpanded;
    
    
    
    [tblViewSimilarVehicles reloadData];
}

-(void)setTheLabelCountText:(int)lblCount
{
    if (lblCount<=0)
    {
        [countLbl setText:@"0"];
    }
    else
    {
        [countLbl setText:[NSString stringWithFormat:@"%d",lblCount]];
    }
    [countLbl sizeToFit];
    
    float widthWithPadding = countLbl.frame.size.width + 15.0;
    
    [countLbl setFrame:CGRectMake(countLbl.frame.origin.x, countLbl.frame.origin.y, widthWithPadding, countLbl.frame.size.height)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Web Services
-(void) getSimilarVehicles{
    
     NSMutableURLRequest *requestURL=[SMWebServices getSimilarVehiclesWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:self.strYear andVariantID:self.strVariantID];
    objSMSimilarVehicleXmlObject = [[SMSimilarVehicleXmlObject alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSSimilarVehicle  *wsSMWSSimilarVehicle = [[SMWSSimilarVehicle alloc]init];
    
    [wsSMWSSimilarVehicle responseForWebServiceForReuest:requestURL
                                            response:^(SMSimilarVehicleXmlObject *objSMSimilarVehicleXmlObjectResult) {
                                                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                [self hideProgressHUD];
                                                switch (objSMSimilarVehicleXmlObjectResult.iStatus) {
                                                        
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
                                                            objSMSimilarVehicleXmlObject = objSMSimilarVehicleXmlObjectResult;
                                                            [tblViewSimilarVehicles reloadData];
                                                    }
                                                        break;
                                                        
                                                    default:
                                                        break;
                                                }
                                                
                                                
                                            }
                                            andError: ^(NSError *error) {
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
