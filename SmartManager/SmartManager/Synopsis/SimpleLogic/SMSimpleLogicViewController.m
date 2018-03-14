//
//  SMSimpleLogicViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 21/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMSimpleLogicViewController.h"
#import "SMCustomColor.h"
#import "SMWSSimpleLogic.h"
#import "SMObjectSimpleLogicXml.h"
#import "MBProgressHUD.h"
#import "SMGlobalClass.h"
@interface SMSimpleLogicViewController ()<MBProgressHUDDelegate>
{
    IBOutlet UIScrollView *scrollVIewParent;
    IBOutlet UILabel *lblBottom;
    SMObjectSimpleLogicXml *objSMObjectSimpleLogicXml;
    MBProgressHUD *HUD;
}
@end

@implementation SMSimpleLogicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.titleView = [SMCustomColor setTitle:@"Simple Logic"];
    
    scrollVIewParent.contentSize  = CGSizeMake(self.view.bounds.size.width,lblRedNote.frame.origin.y + lblRedNote.frame.size.height + 35.0f);
    [self getSimpleLogic];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web Services
-(void) getSimpleLogic{
    
    NSLog(@"%d",self.objSummary.intYear);
    NSString *strYear = [NSString stringWithFormat:@"%d",self.objSummary.intYear];
    NSLog(@"%@",strYear);
    
    if([self.objSummary.strKilometers length] == 0)
        self.objSummary.strKilometers = @"0";
    
    NSMutableURLRequest *requestURL=[SMWebServices getSimpleLogicForVariant:[SMGlobalClass sharedInstance].hashValue andYear:strYear andVariantID:[NSString stringWithFormat:@"%d",self.objSummary.intVariantId] andMileage:self.objSummary.strKilometers];
   
    //NSMutableURLRequest *requestURL=[SMWebServices getSimpleLogicForVariant:[SMGlobalClass sharedInstance].hashValue andYear:@"2016" andVariantID:@"23142" andMileage:@"0"];
    // Need to pass Mileage but not availabe from web service
    
    objSMObjectSimpleLogicXml = [[SMObjectSimpleLogicXml alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSSimpleLogic *wsSMWSSimpleLogic = [[SMWSSimpleLogic alloc]init];
    
    [wsSMWSSimpleLogic responseForWebServiceForReuest:requestURL
                                            response:^(SMObjectSimpleLogicXml *objSMSimpleLogicXmlObjectResult) {
                                                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                [self hideProgressHUD];
                                                switch (objSMSimpleLogicXmlObjectResult.iStatus) {
                                                        
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
                                                        objSMObjectSimpleLogicXml = objSMSimpleLogicXmlObjectResult;
                                                        lblAgeValue.text = objSMObjectSimpleLogicXml.strAge;
                                                        lblMileageValue.text = objSMObjectSimpleLogicXml.strMileage;
                                                        lblSuggestedTradeValue.text = objSMObjectSimpleLogicXml.strTrade;
                                                        lblSuggestedRetailValue.text =objSMObjectSimpleLogicXml.strRetail;
                                                        lblNewPriceValue.text = objSMObjectSimpleLogicXml.strLatestPrice;
                                                        
                                                        lblLess10Value.text = [NSString stringWithFormat:@"(%@)",objSMObjectSimpleLogicXml.strAgeDepreciation];
                                                        
                                                        if ([objSMObjectSimpleLogicXml.strMileageAdjustment isEqualToString:@"0"])
                                                        {
                                                            lblLess5Value.text = @"-";
                                                            lblAdd5Value.text = @"-";
                                                        }
                                                        else{
                                                            
                                                            if([objSMObjectSimpleLogicXml.strMileageAdjustment containsString:@"-"])
                                                            {
                                                                objSMObjectSimpleLogicXml.strMileageAdjustment = [objSMObjectSimpleLogicXml.strMileageAdjustment stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                                                
                                                                lblLess5Value.text = [NSString stringWithFormat:@"(R%@)",objSMObjectSimpleLogicXml.strMileageAdjustment];
                                                                lblAdd5Value.text = @"-";
                                                            }
                                                            else
                                                            {
                                                                objSMObjectSimpleLogicXml.strMileageAdjustment = [objSMObjectSimpleLogicXml.strMileageAdjustment stringByReplacingOccurrencesOfString:@"+" withString:@""];
                                                                
                                                                lblAdd5Value.text = [NSString stringWithFormat:@"(R%@)",objSMObjectSimpleLogicXml.strMileageAdjustment];
                                                                lblLess5Value.text = @"-";
                                                            }

                                                        }
                                                        
                                                        [self setAttributedTextForVehicleNameWithFirstText:[NSString stringWithFormat:@"%d",self.objSummary.intYear] andWithSecondText:self.objSummary.strFriendlyName forLabel:lblVehicleName];
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

-(void)setAttributedTextForVehicleNameWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}
@end
