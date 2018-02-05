//
//  SMSynopsisVehicleLookUpViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 19/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

/* UNABLE TO DO PERFORM HIT WEB SERVICE
 
 <0x7a2df0 SMWebServices.m:(1333)> Soap Message : <?xml version="1.0" encoding="utf-8"?><Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Body><ListMakesJSON xmlns="http://tempuri.org/"><userHash>2C5D9839B125490E0E8CD4E1AE2C5211</userHash><year>2015</year></ListMakesJSON></Body></Envelope>
 */

#import "SMSynopsisVehicleLookUpViewController.h"
#import "SMCustomTextField.h"
#import "SMCustomTextFieldForDropDown.h"
#import "SMCustomPopUpPickerView.h"
#import "SMCustomPopUpTableView.h"
#import "SMDropDownObject.h"
#import "SMSynopsisVehicleCodeViewController.h"
#import "SMSynopsisVehicleInStockViewController.h"
#import "SMSynopsisSummaryViewController.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMSynopsisXMLResultObject.h"
#import "SMSummaryObject.h"
#import "SMWSforSummaryDetails.h"
#import "SMSynopsisVerifyVINViewController.h"
#import "SMReusableSearchTableViewController.h"


@interface SMSynopsisVehicleLookUpViewController ()
{
    MBProgressHUD *HUD;

    SMSynopsisXMLResultObject *objSMSynopsisResult;
    SMSummaryObject *objSMSummeryObject;
    IBOutlet UIScrollView *scrollView;
    IBOutlet SMCustomTextFieldForDropDown *txtYear;
    IBOutlet SMCustomTextFieldForDropDown *txtMake;
    IBOutlet SMCustomTextFieldForDropDown *txtModel;
    IBOutlet SMCustomTextFieldForDropDown *txtVariant;
    IBOutlet SMCustomTextFieldForDropDown *txtCondition;
    IBOutlet SMCustomTextField *txtVINNo;
    IBOutlet SMCustomTextField *txtKilometers;
    IBOutlet SMCustomTextField *txtExtrasAtRetail;
    
    IBOutlet UILabel *lblCostsMayApplyForScroll;
    
    NSArray *arrConditionData;
    
    NSMutableArray *arrmForYear;
    NSMutableArray *arrmForMake;
    NSMutableArray *arrmForModel;
    NSMutableArray *arrmForVariant;
    NSMutableArray *arrmForCondition;
    NSMutableArray *arrmTemp;
    
    SMDropDownObject *ObjectDropDownObject;
    SMLoadVehiclesObject        *loadVehiclesObject;
    SMReusableSearchTableViewController *searchMakeVC;
    NSArray *arrLoadNib;
}

- (IBAction)btnContinueToSummaryDidClicked:(id)sender;
- (IBAction)btnContinueToVerificationDidClicked:(id)sender;

@end

@implementation SMSynopsisVehicleLookUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addingProgressHUD];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Ok" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    txtExtrasAtRetail.inputAccessoryView = numberToolbar;
    txtKilometers.inputAccessoryView = numberToolbar;
    arrmTemp = [[NSMutableArray alloc ] init];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Vehicle Lookup"];
    arrmForYear = [[NSMutableArray alloc ] init];
    [self gettingAllYearsForPickerView];
    arrmForMake = [[NSMutableArray alloc ] init];
    arrmForModel = [[NSMutableArray alloc ] init];
    arrmForVariant = [[NSMutableArray alloc ] init];
    arrmForCondition = [[NSMutableArray alloc ] init];
    arrConditionData   = [NSArray arrayWithObjects:@"Excellent",@"Very Good",@"Good",@"Poor",@"Very Poor", nil];
    
    [self getConditionDropDown];
    
    arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMReusableSearchTableViewController" owner:self options:nil];
    searchMakeVC = [arrLoadNib objectAtIndex:0];
    
    // Do any additional setup after loading the view from its nib.
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    txtCondition.text = [arrConditionData objectAtIndex:2]; //Set default value to GOOD
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width,lblCostsMayApplyForScroll.frame.origin.y + lblCostsMayApplyForScroll.frame.size.height + 10.0f);
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
}

-(void)cancelNumberPad{
    
    if(!isTxtKiloMetersSelected)
    {
        [txtExtrasAtRetail resignFirstResponder];
        txtExtrasAtRetail.text = @"";
        txtCondition.userInteractionEnabled = YES;
    }
    else
    {
        [txtKilometers resignFirstResponder];
        txtKilometers.text = @"";
    }
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = txtExtrasAtRetail.text;
    if(!isTxtKiloMetersSelected)
    {
        [txtExtrasAtRetail resignFirstResponder];
        txtCondition.userInteractionEnabled = YES;
    }
    else
    {
        [txtKilometers resignFirstResponder];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) getConditionDropDown{
    
    
    for(int i=0;i<5;i++)
    {
        SMDropDownObject *objCondition = [[SMDropDownObject alloc] init];
        objCondition.strMakeId = [NSString stringWithFormat:@"%d",i+1];
        objCondition.strMakeName = [arrConditionData objectAtIndex:i];
        [arrmForCondition addObject:objCondition];
    }
    
}

-(void) gettingAllYearsForPickerView
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    int year = (int)[components year];
    [txtYear setText:[NSString stringWithFormat:@"%d",year]];
    selectedYear = txtYear.text;
    // [self.txtYear setText:[NSString stringWithFormat:@"%d",year]];
    for (int i=year; i>=1990; i--)
    {
        [arrmForYear addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}


#pragma mark - WEB Services


-(void) loadMake
{
   
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllMakevaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:txtYear.text];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    // self.txtYear.text
    
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [self hideProgressHUD];
             return;
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             [self hideProgressHUD];
         }
     }];
    
}

-(void)loadModelsListing
{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllModelsvaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:txtYear.text makeId:selectedMakeId];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [self hideProgressHUD];
             return;
         }
         else
         {
             
             arrmForModel = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
    
}

-(void)loadVarientsListing
{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllVarintsvaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:txtYear.text modelId:selectedModelId];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [self hideProgressHUD];
             return;
         }
         else
         {
             arrmForVariant = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}


#pragma mark - xml parser delegate
-(void) parser:(NSXMLParser  *)     parser
didStartElement:(NSString    *)     elementName
  namespaceURI:(NSString     *)     namespaceURI
 qualifiedName:(NSString     *)     qName
    attributes:(NSDictionary *)     attributeDict
{
    if ([elementName isEqualToString:@"ListMakesJSONResult"])
    {
        //loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
    }
    if ([elementName isEqualToString:@"ListModelsJSONResult"])
    {
        ObjectDropDownObject=[[SMDropDownObject alloc]init];
    }
    
    if ([elementName isEqualToString:@"ListVariantsJSONResult"])
    {
        loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
    }
    
    if ([elementName isEqualToString:@"SummaryItem"]) {
        objSMSummeryObject = [[SMSummaryObject alloc]init];
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
    
    //get make data
    NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObject=[NSJSONSerialization
                              JSONObjectWithData:data
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    
    if ([elementName isEqualToString:@"ListMakesJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            [arrmForMake removeAllObjects];
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {//// this is for Data For PopUpView
                loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
                loadVehiclesObject.strMakeId   = dictionary[@"makeID"];
                loadVehiclesObject.strMakeName = dictionary[@"makeName"];
                
                //ObjectDropDownObject.strSortTextID = ((int)[arrmForMake count] + 1);
                [arrmForMake addObject:loadVehiclesObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
        
    }
    //get model data
    
    if ([elementName isEqualToString:@"ListModelsJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                ObjectDropDownObject             =[[SMDropDownObject alloc]init];
                ObjectDropDownObject.strMakeId   =dictionary[@"modelID"];
                ObjectDropDownObject.strMakeName =dictionary[@"modelName"];
                [arrmForModel  addObject:ObjectDropDownObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
    }
    
    //get varient data
    if ([elementName isEqualToString:@"ListVariantsJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
                loadVehiclesObject.strMakeId            =dictionary[@"variantID"];
                loadVehiclesObject.strMakeName          =dictionary[@"variantName"];
                loadVehiclesObject.strMeanCodeNumber    =dictionary[@"meadCode"];
                loadVehiclesObject.strMaxYear           =dictionary[@"MaxDate"];
                loadVehiclesObject.strMinYear           = dictionary[@"MinDate"];
                [arrmForVariant          addObject:loadVehiclesObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
        
    }
    
    // end of xml parsing
    
    if ([elementName isEqualToString:@"ListMakesJSONResponse"])
    {
        if (arrmForMake.count!=0)
        {
            [txtModel        setText:@""];
            [txtVariant     setText:@""];
            
            
                [searchMakeVC getTheDropDownData:arrmForMake];
                [self.view addSubview:searchMakeVC];
                
                [SMReusableSearchTableViewController getTheSelectedSearchDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue) {
                    NSLog(@"selected text = %@",selectedTextValue);
                    NSLog(@"selected ID = %d",selectIDValue);
                    
                    
                    txtMake.text = selectedTextValue;
                    selectedMakeId = selectIDValue;
                    
                    
                }];
                
                [self hideProgressHUD];

        }
    }
    if ([elementName isEqualToString:@"ListModelsJSONResponse"])
    {
        if (arrmForModel.count!=0)
        {
            [txtVariant setText:@""];
            //modelArray.count>0 ?[self loadPopup]:SMAlert(KLoaderTitle,KNorecordsFousnt);
            
            /*************  your Request *******************************************************/
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:arrmForModel withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
           
            /*************  your Response *******************************************************/
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                
                txtModel.text = selectedTextValue;
                selectedModelId = selectIDValue;
            }];
            
            
            [self hideProgressHUD];
        }
    }
    
    if ([elementName isEqualToString:@"ListVariantsJSONResponse"])
    {
        if (arrmForVariant.count!=0)
        {
            //variantArray.count>0 ?[self loadPopup]:SMAlert(KLoaderTitle,KNorecordsFousnt);
            
            /*************  your Request *******************************************************/
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:arrmForVariant withVariant:YES andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/

            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                selectedVariantId = selectIDValue;
                txtVariant.text = selectedTextValue;
            }];
            
            [self hideProgressHUD];
        }
    }
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
}


#pragma mark - Text Field Delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    if(textField == txtCondition)
    {
        [self.view endEditing:YES];
        /*************  your Request *******************************************************/
        [textField resignFirstResponder];
        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
        SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
        
        
        [popUpView getTheDropDownData:arrmForCondition withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
        
        [self.view addSubview:popUpView];
        
        /*************  your Request *******************************************************/
        
        /*************  your Response *******************************************************/
        
        [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
            NSLog(@"selected text = %@",selectedTextValue);
            NSLog(@"selected ID = %d",selectIDValue);
            textField.text = selectedTextValue;
            
        }];
        
        /*************  your Response *******************************************************/
    }
    else if(textField == txtYear)
    {
        [self.view endEditing:YES];
        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
        SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
        
        [popUpView getTheDropDownData:[SMAttributeStringFormatObject getYear] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:YES]; // array to be passed for custom popup dropdown
        
        [self.view addSubview:popUpView];
        
        [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
            NSLog(@"selected text = %@",selectedTextValue);
            NSLog(@"selected ID = %d",selectIDValue);
            textField.text = selectedTextValue;
            txtMake.text = @"";
            txtModel.text = @"";
            txtVariant.text = @"";
            //selectedMakeId = selectIDValue;
        }];
        /*************  your Response *******************************************************/
        
    }
    
    else if(textField == txtVariant)
    {
        if ([txtModel.text isEqualToString:@""])
        {
            SMAlert(@"Smart Manager", KModelSelection);
            
        }else{
        [self.view endEditing:YES];
        [textField resignFirstResponder];
        [txtExtrasAtRetail resignFirstResponder];
        [self loadVarientsListing];
        }
    }
    
    
    else if(textField == txtMake)
    {
        
            [self.view endEditing:YES];
            [textField resignFirstResponder];
            [self loadMake];
        
    }
    
    
    else if(textField == txtModel)
    {
        if ([txtMake.text isEqualToString:@""]) {
            SMAlert(@"Smart Manager", KMakeSelection);
        }else
        {[self.view endEditing:YES];
        [textField resignFirstResponder];
        [self loadModelsListing];
        }
        
    }
    else if(textField == txtExtrasAtRetail)
    {
        txtCondition.userInteractionEnabled = NO;
        isTxtKiloMetersSelected = NO;
    }
    else if(textField == txtKilometers)
    {
        isTxtKiloMetersSelected = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if(textField == txtExtrasAtRetail)
    {
        txtCondition.userInteractionEnabled = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if(textField == txtVINNo)
    {
        return [SMAttributeStringFormatObject valdateTextFeild:txtVINNo shouldChangeCharactersInRange:range replacementString:string withValidationType:ACCEPTABLE_CHARACTERS andLimit:0];
    }
    
    if(textField == txtKilometers)
    {
        return [SMAttributeStringFormatObject valdateTextFeild:txtKilometers shouldChangeCharactersInRange:range replacementString:string withValidationType:ACCEPTABLE_CHARACTERS_Number andLimit:kKilometerLimit];
   
    }
    if(textField == txtExtrasAtRetail)
    {
        return [SMAttributeStringFormatObject valdateTextFeild:txtExtrasAtRetail shouldChangeCharactersInRange:range replacementString:string withValidationType:ACCEPTABLE_CHARACTERS_Number andLimit:0];
    }
    return YES;
}

#pragma mark - Button Methods

- (IBAction)btnContinueToSummaryDidClicked:(id)sender {
    

       UIButton *btn = (UIButton *)sender;
    
    //If return YES means no blank feild
    if([self validateBlankTextForButton:(int)btn.tag]){
        [self getTheSynopsisDetails];
    }
    
//    
}

- (IBAction)btnContinueToVerificationDidClicked:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    //If return YES means no blank feild
    if([self validateBlankTextForButton:(int)btn.tag]){
        SMSynopsisVerifyVINViewController *synopsisVerifyVINViewController;
        synopsisVerifyVINViewController = [[SMSynopsisVerifyVINViewController alloc] initWithNibName:@"SMSynopsisVerifyVINViewController" bundle:nil];
        synopsisVerifyVINViewController.previousPageNumber = 2;
        synopsisVerifyVINViewController.strMainVehicleYear = txtYear.text;
        synopsisVerifyVINViewController.strMainVehicleName = [NSString stringWithFormat:@"%@ %@",txtMake.text,txtModel.text];
        synopsisVerifyVINViewController.strSelectedMakeID = selectedMakeId;
        synopsisVerifyVINViewController.strSelectedModelID = selectedModelId;
        synopsisVerifyVINViewController.strSelectedVariantID = selectedVariantId;
        synopsisVerifyVINViewController.strSelectedVINNumber = txtVINNo.text;
        synopsisVerifyVINViewController.strSelectedKiloMeters = txtKilometers.text;
        synopsisVerifyVINViewController.strSelectedExtrasCost = txtExtrasAtRetail.text;
        synopsisVerifyVINViewController.strSelectedCondition = txtCondition.text;
         synopsisVerifyVINViewController.strSelectedMMCode = @"";
        synopsisVerifyVINViewController.strSelectedRegNo = @"";
        [self.navigationController pushViewController:synopsisVerifyVINViewController animated:YES];
    }
   
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

-(void)getTheSynopsisDetails
{
   
    NSMutableURLRequest *requestURL=[SMWebServices getSynopsisSummaryWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:txtYear.text.intValue andMakeId:selectedMakeId andModelId:selectedModelId andVariantId:selectedVariantId andVIN:txtVINNo.text andKiloMeters:txtKilometers.text andExtrasCost:txtExtrasAtRetail.text andCondition:txtCondition.text];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSforSummaryDetails *wsSMWSforSummaryDetails = [[SMWSforSummaryDetails alloc]init];
    [wsSMWSforSummaryDetails responseForWebServiceForReuest:requestURL response:^(SMSynopsisXMLResultObject *objSMSynopsisXMLResultObject) {
        
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        [self hideProgressHUD];
        
        switch (objSMSynopsisXMLResultObject.iStatus) {
                
            case kWSCrash:
            {
                SMAlert(kTitle, KWSCrashMessage);
            }
                break;
            case kWSNoRecord:
            {
                SMAlert(kTitle, KNorecordsFousnt);
            }
                break;
            case kWSSuccess:
            {
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    SMSynopsisSummaryViewController *vcSMSynopsisVehicleLookUpViewController = [[SMSynopsisSummaryViewController alloc] initWithNibName:@"SMSynopsisSummaryViewController" bundle:nil];
                    vcSMSynopsisVehicleLookUpViewController.objSMSynopsisResult = objSMSynopsisXMLResultObject;
                    [self.navigationController pushViewController:vcSMSynopsisVehicleLookUpViewController animated:NO];
                }
                else
                {
                    SMSynopsisSummaryViewController *vcSMSynopsisVehicleLookUpViewController = [[SMSynopsisSummaryViewController alloc] initWithNibName:@"SMSynopsisSummaryViewController" bundle:nil];
                    vcSMSynopsisVehicleLookUpViewController.objSMSynopsisResult = objSMSynopsisXMLResultObject;
                    [self.navigationController pushViewController:vcSMSynopsisVehicleLookUpViewController animated:NO];
                }
                
            }
               break;
            default:
                break;
        }
    } andError:^(NSError *error) {
        SMAlert(@"Error", error.localizedDescription);
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        [self hideProgressHUD];
        
    }];
    

    
}


-(BOOL)validateBlankTextForButton:(int)tag{
    if ([txtMake.text isEqualToString:@""]) {
        SMAlert(@"Smart Manager", KMakeSelection);
        return NO;
    }
    else if ([txtModel.text isEqualToString:@""])
    {
        SMAlert(@"Smart Manager", KModelSelection);
        return NO;
    }
    else if ([txtVariant.text isEqualToString:@""]){
        SMAlert(@"Smart Manager", KVariantSelection);
        return NO;
    }
//    else if ([txtVINNo.text isEqualToString:@""] && tag==1){
//        SMAlert(@"Smart Manager", kVINNoSelection);
//         [txtVINNo becomeFirstResponder];
//        return NO;
//    }
    else if ([txtKilometers.text isEqualToString:@""]){
        SMAlert(@"Smart Manager", kKilometerSelection);
        [txtKilometers becomeFirstResponder];
        return NO;
    }
    else if ([txtCondition.text isEqualToString:@""]){
        SMAlert(@"Smart Manager", KConditionSelection);
        return NO;
    }
    return YES;
}
@end
