//
//  SMSynopsisDoAppraisalViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 29/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSynopsisDoAppraisalViewController.h"
#import "SMSynopsisAppraisalHeaderCell.h"
#include "SMSynopsisAppraisalNormalCell.h"
#import "SMCustomColor.h"
#import "SMSynopsisPurchaseDetailsViewController.h"
#import "SMSynopsisConditionViewController.h"
#import "SMSynopsisEngineDriveTrainViewController.h"
#import "SMInteriorReconditioningViewController.h"
#import "SMOEMSpecsViewController.h"
#import "SMSellerViewController.h"
#import "SMSendOfferViewController.h"
#import "SMExteriorReconditioningViewController.h"
#import "SMSynopsisVehicleExtrasViewController.h"
#import "SMPricing_ValuationViewController.h"
#import "SMForwardAppraisalViewController.h"
#import "UIImageView+WebCache.h"
#import "SMVerticalLabel.h"
#import "SMDoAppraisalObject.h"

@interface SMSynopsisDoAppraisalViewController ()
{
    IBOutlet UITableView *tblAppraisal;
    NSArray *arrForOption;
    NSArray *arrForRating;
    SMDoAppraisalObject *appraisalObj;
}
@end

@implementation SMSynopsisDoAppraisalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"***ScannedVIN = %@",self.objSMSynopsisResult.strVINNo);
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Do Appraisal "];

    
    arrForOption = [[NSArray alloc] initWithObjects:@"Seller",@"Purchase Details",@"Condition",@"Vehicle Extras",@"Interior Reconditioning",@"Engine & Drivetrain",@"Exterior Reconditioning",@"Valuation",@"Send Offer",@"Forward Appraisal", nil];
    
  
    //arrForRating = [[NSArray alloc] initWithObjects:@"YES",@"NO",@"Good",@"R5000",@"R1000",@"R2000",@"R2850",@"R128k & R140k",@"",@"", nil];
    
    [tblAppraisal registerNib:[UINib nibWithNibName:@"SMSynopsisAppraisalHeaderCell" bundle:nil] forCellReuseIdentifier:@"SMSynopsisAppraisalHeaderCell"];
    
    [tblAppraisal registerNib:[UINib nibWithNibName:@"SMSynopsisAppraisalNormalCell" bundle:nil] forCellReuseIdentifier:@"SMSynopsisAppraisalNormalCell"];
    
    tblAppraisal.estimatedRowHeight = 200.0f;
    tblAppraisal.rowHeight = UITableViewAutomaticDimension;
    
    tblAppraisal.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self addingProgressHUD];
    
    [self loadAppraisalInfoWithVIN:self.objSMSynopsisResult.strVINNo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view Delegates and Data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;  //10+header cell
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMSynopsisAppraisalNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMSynopsisAppraisalNormalCell"];
    cell.backgroundColor = [UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
        {
            SMSynopsisAppraisalHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMSynopsisAppraisalHeaderCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            [cell.imgviewVehicle setImageWithURL:[NSURL URLWithString:self.objSMSynopsisResult.strVariantImage] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
            
            
            [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstText:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear] andWithSecondText:self.objSMSynopsisResult.strFriendlyName forLabel: cell.lblNameYear];
            
            cell.lblDetails.text = self.objSMSynopsisResult.strVariantDetails;
            cell.lblDate.text = [NSString stringWithFormat:@"Date: %@",appraisalObj.appraisalCreateDate];
            cell.lblAppraiser.text = [NSString stringWithFormat:@"Name: %@",appraisalObj.appraisalName];
            [cell.lblDetails alignTop];
            return cell;
        }
        break;
        case 1:
        {
            cell.lblOptions.text =[arrForOption objectAtIndex:indexPath.row - 1];
            if(appraisalObj.isSeller)
            {
                cell.lblRating.textColor = [UIColor greenColor];
                cell.lblRating.text =@"\u2713";
            }
            else
            {
                cell.lblRating.textColor = [UIColor redColor];
                cell.lblRating.text =@"\u2718";

            }
        }
        break;
        case 2:
        {
            cell.lblOptions.text =[arrForOption objectAtIndex:indexPath.row - 1];
            if(appraisalObj.isPurchaseDetails)
            {
                cell.lblRating.textColor = [UIColor greenColor];
                cell.lblRating.text =@"\u2713";
            }
            else
            {
                cell.lblRating.textColor = [UIColor redColor];
                cell.lblRating.text =@"\u2718";
                
            }
        }
        break;
        case 3:
        {
            cell.lblOptions.text =[arrForOption objectAtIndex:indexPath.row - 1];
            cell.lblRating.textColor = [UIColor whiteColor];
            cell.lblRating.text =appraisalObj.appraisalCondition;
        }
        break;
        case 4:
        {
            cell.lblOptions.text =[arrForOption objectAtIndex:indexPath.row - 1];
            cell.lblRating.textColor = [UIColor whiteColor];
            cell.lblRating.text =appraisalObj.appraisalVehicleExtras;
        }
        break;
        case 5:
        {
            cell.lblOptions.text =[arrForOption objectAtIndex:indexPath.row - 1];
            cell.lblRating.textColor = [UIColor whiteColor];
            cell.lblRating.text =appraisalObj.appraisalInteriorR;
        }
        break;
        case 6:
        {
            cell.lblOptions.text =[arrForOption objectAtIndex:indexPath.row - 1];
            cell.lblRating.textColor = [UIColor whiteColor];
            cell.lblRating.text =appraisalObj.appraisalEngineD;
        }
        break;
        case 7:
        {
            cell.lblOptions.text =[arrForOption objectAtIndex:indexPath.row - 1];
            cell.lblRating.textColor = [UIColor whiteColor];
            cell.lblRating.text =appraisalObj.appraisalExteriorR;
        }
        break;
        case 8:
        {
            cell.lblOptions.text =[arrForOption objectAtIndex:indexPath.row - 1];
            cell.lblRating.textColor = [UIColor whiteColor];
            cell.lblRating.text =[NSString stringWithFormat:@"%@ & %@",appraisalObj.appraisalValuationStart,appraisalObj.appraisalValuationEnd];
        }
        break;
        case 9:
        case 10:
        {
            cell.lblOptions.text =[arrForOption objectAtIndex:indexPath.row - 1];
        }
        break;
        
        default:
            break;
    }
    
    
    
  /* if(indexPath.row!=0)
   {
       
       
       
       if([[arrForRating objectAtIndex:indexPath.row - 1] isEqual:@"YES"])
       {
             cell.lblRating.textColor = [UIColor greenColor];
             cell.lblRating.text =@"\u2713";
       }
       else if([[arrForRating objectAtIndex:indexPath.row - 1] isEqual:@"NO"])
       {
             cell.lblRating.textColor = [UIColor redColor];
             cell.lblRating.text =@"\u2718";
       }
       else{
             cell.lblRating.textColor = [UIColor whiteColor];
             cell.lblRating.text =[arrForRating objectAtIndex:indexPath.row - 1];
       }
     
       
       return cell;

   }
   else
   {
    SMSynopsisAppraisalHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMSynopsisAppraisalHeaderCell"];
       
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
       
       [cell.imgviewVehicle setImageWithURL:[NSURL URLWithString:self.objSMSynopsisResult.strVariantImage] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];

       
     [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstText:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear] andWithSecondText:self.objSMSynopsisResult.strFriendlyName forLabel: cell.lblNameYear];
       
    cell.lblDetails.text = self.objSMSynopsisResult.strVariantDetails;
    cell.lblDate.text = @"Date: Mon 12 Dec 2015";
    cell.lblAppraiser.text = @"Appraiser: Dave Johnson";
    [cell.lblDetails alignTop];
    return cell;
   }*/
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
    switch (indexPath.row) {
        case 0: return UITableViewAutomaticDimension;
            break;
        case 1:
        case 3:
        case 4:
        case 8:
        case 9:
            return 38.0f;
        break;
        default:
            return 50.0f;

            break;
    }
    }
    else
    {
        switch (indexPath.row) {
            case 0: return UITableViewAutomaticDimension;
                break;
            default:
                return 58.0f;
                
                break;
    }
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
            
        case 1:{
           
                SMSellerViewController *vcsynopsisSellerViewController = [[SMSellerViewController alloc] initWithNibName:@"SMSellerViewController" bundle:nil];
            vcsynopsisSellerViewController.objSummary = self.objSMSynopsisResult;
                [self.navigationController pushViewController:vcsynopsisSellerViewController animated:NO];
            
                }
            break;
        case 2:{
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
            SMSynopsisPurchaseDetailsViewController *vcSMSynopsisPurchaseDetailsViewController = [[SMSynopsisPurchaseDetailsViewController alloc] initWithNibName:@"SMSynopsisPurchaseDetailsViewController" bundle:nil];
            vcSMSynopsisPurchaseDetailsViewController.objSummary = self.objSMSynopsisResult;
            [self.navigationController pushViewController:vcSMSynopsisPurchaseDetailsViewController animated:NO];
            }
            else{
                SMSynopsisPurchaseDetailsViewController *vcSMSynopsisPurchaseDetailsViewController = [[SMSynopsisPurchaseDetailsViewController alloc] initWithNibName:@"SMSynopsisPurchaseDetailsViewController_iPad" bundle:nil];
                
                [self.navigationController pushViewController:vcSMSynopsisPurchaseDetailsViewController animated:NO];

            }

        }
      break;
        case 3:{
            
            SMSynopsisConditionViewController *vcSMSynopsisConditionViewController = [[SMSynopsisConditionViewController alloc] initWithNibName:@"SMSynopsisConditionViewController" bundle:nil];
                
            vcSMSynopsisConditionViewController.objSummary = self.objSMSynopsisResult;
            [self.navigationController pushViewController:vcSMSynopsisConditionViewController animated:NO];
                        }
            break;
        case 4:{
            
                SMSynopsisVehicleExtrasViewController *vcSMSynopsisVehicleExtrasViewController = [[SMSynopsisVehicleExtrasViewController alloc] initWithNibName:@"SMSynopsisVehicleExtrasViewController" bundle:nil];
                vcSMSynopsisVehicleExtrasViewController.objSummary = self.objSMSynopsisResult;
                [self.navigationController pushViewController:vcSMSynopsisVehicleExtrasViewController animated:NO];
            
            
        }
            break;

        case 5:{
            
            SMInteriorReconditioningViewController *vcSMSynopsisInteriorRecondtioningViewController = [[SMInteriorReconditioningViewController alloc] initWithNibName:@"SMInteriorReconditioningViewController" bundle:nil];
            vcSMSynopsisInteriorRecondtioningViewController.objSummary = self.objSMSynopsisResult;
            [self.navigationController pushViewController:vcSMSynopsisInteriorRecondtioningViewController animated:NO];
            
        }
            break;

        case 6:{
            
            SMSynopsisEngineDriveTrainViewController *vcSMSynopsisEngineDriveTrainViewController = [[SMSynopsisEngineDriveTrainViewController alloc] initWithNibName:@"SMSynopsisEngineDriveTrainViewController" bundle:nil];
            vcSMSynopsisEngineDriveTrainViewController.objSummary = self.objSMSynopsisResult;
            [self.navigationController pushViewController:vcSMSynopsisEngineDriveTrainViewController animated:NO];
           
        }
        break;
        case 7:{
            
            SMExteriorReconditioningViewController *vcExteriorReconditioningViewController = [[SMExteriorReconditioningViewController alloc] initWithNibName:@"SMExteriorReconditioningViewController" bundle:nil];
             vcExteriorReconditioningViewController.objSummary = self.objSMSynopsisResult;
            [self.navigationController pushViewController:vcExteriorReconditioningViewController animated:NO];
            
        }
            break;
        case 8:{
        
            SMPricing_ValuationViewController *synopsisSMPricing_ValuationViewController;
            
            synopsisSMPricing_ValuationViewController = [[SMPricing_ValuationViewController alloc] initWithNibName:@"SMPricing_ValuationViewController" bundle:nil];
            synopsisSMPricing_ValuationViewController.isValuation = YES;
            synopsisSMPricing_ValuationViewController.objSummary = self.objSMSynopsisResult;
            [self.navigationController pushViewController:synopsisSMPricing_ValuationViewController animated:YES];
        
        
        }
         break;    
        case 9:{
            
                SMSendOfferViewController *vcSMSendOfferViewController = [[SMSendOfferViewController alloc] initWithNibName:@"SMSendOfferViewController" bundle:nil];
                vcSMSendOfferViewController.objSMSynopsisResult = self.objSMSynopsisResult;
                [self.navigationController pushViewController:vcSMSendOfferViewController animated:NO];
           
             }
            break;
        case 10:{
            
            SMForwardAppraisalViewController *vcForwrdAppraisalViewController = [[SMForwardAppraisalViewController alloc] initWithNibName:@"SMForwardAppraisalViewController" bundle:nil];
            vcForwrdAppraisalViewController.objSMSynopsisResult = self.objSMSynopsisResult;
            [self.navigationController pushViewController:vcForwrdAppraisalViewController animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
  }

-(void)loadAppraisalInfoWithVIN:(NSString*) vinNumber
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    NSMutableURLRequest *requestURL=[SMWebServices loadAppraisalInfo:[SMGlobalClass sharedInstance].hashValue andVIN:vinNumber andClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
    
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
                                                [xmlParser parse];
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
    if ([elementName isEqualToString:@"GetAppraisalInfoResult"])
    {
        appraisalObj = [[SMDoAppraisalObject alloc] init];
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
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
    
    if ([elementName isEqualToString:@"AppraisalId"])
        appraisalObj.appraisalID = currentNodeContent;
    else if ([elementName isEqualToString:@"AppraisalName"])
        appraisalObj.appraisalName = currentNodeContent;
    else if ([elementName isEqualToString:@"PhotosSaved"])
        appraisalObj.isSeller = [currentNodeContent boolValue];
    else if ([elementName isEqualToString:@"PurchaseDetailsSaved"])
        appraisalObj.isPurchaseDetails = currentNodeContent.boolValue;
    else if ([elementName isEqualToString:@"CreateDate"])
    {
        appraisalObj.appraisalCreateDate = [[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:currentNodeContent withFormat:6];
    }
    else if ([elementName isEqualToString:@"OverallconditionName"])
        appraisalObj.appraisalCondition = currentNodeContent;
    else if ([elementName isEqualToString:@"VehicleExtraTotalPrice"])
        appraisalObj.appraisalVehicleExtras = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    else if ([elementName isEqualToString:@"InteriorReconditioningTotalPrice"])
        appraisalObj.appraisalInteriorR = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    else if ([elementName isEqualToString:@"EngineDrivetrainTotalPrice"])
        appraisalObj.appraisalEngineD = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    else if ([elementName isEqualToString:@"ExteriorReconditioningTotalPrice"])
        appraisalObj.appraisalExteriorR = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    else if ([elementName isEqualToString:@"ValuationStartPrice"])
        appraisalObj.appraisalValuationStart = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    else if ([elementName isEqualToString:@"ValuationEndPrice"])
        appraisalObj.appraisalValuationEnd = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];;
    
    
    
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Do stuff to UI
        self.objSMSynopsisResult.appraisalID = appraisalObj.appraisalID;
       // self.objSMSynopsisResult.strVINNo = @"VNKKJ0D390A234522";
        [tblAppraisal reloadData];
        //oldTableViewHeight = tblSMSendOffer.contentSize.height;
        
        [HUD hide:YES];
    });

   
}


#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.color = [UIColor blackColor];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}
-(void) hideProgressHUD
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
        });
    });
}



@end
