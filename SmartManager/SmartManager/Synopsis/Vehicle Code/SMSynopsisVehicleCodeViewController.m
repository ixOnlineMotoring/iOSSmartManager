//
//  SMSynopsisVehicleCodeViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 21/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSynopsisVehicleCodeViewController.h"
#import "SMCustomPopUpPickerView.h"
#import "SMCustomPopUpTableView.h"
#import "SMCustomTextField.h"
#import "SMCustomTextFieldForDropDown.h"
#import "SMDropDownObject.h"
#import "SMCustomColor.h"
#import "SMSynopsisSummaryViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMSynopsisXMLResultObject.h"
#import "SMSummaryObject.h"
#import "UIBAlertView.h"
#import "SMWSforSummaryDetails.h"
#import "SMSynopsisVerifyVINViewController.h"
@interface SMSynopsisVehicleCodeViewController ()
{
    IBOutlet UITableView *tblView;

    IBOutlet SMCustomTextFieldForDropDown *txtYear;
    IBOutlet SMCustomTextFieldForDropDown *txtCondition;
    IBOutlet SMCustomTextField *txtVINNo;
    IBOutlet SMCustomTextField *txtKilometers;
    IBOutlet SMCustomTextField *txtExtrasAtCost;
    IBOutlet SMCustomTextField *txtMMCode;
    IBOutlet SMCustomTextField *txtLightstoneCode;
    IBOutlet SMCustomTextField *txtTruTradeCode;
    IBOutlet SMCustomTextField *txtiXCode;
    
    NSArray *arrConditionData;
    NSMutableArray *arrmForYear;
    NSMutableArray *arrmForCondition;
    //NSMutableArray *arrVariantDetails;
    SMSynopsisXMLResultObject *objSMSynopsisResult;
    SMSummaryObject *objSMSummeryObject;
    IBOutlet UIView *viewForHeader;
    IBOutlet UIView *viewForFooter;
    IBOutlet UIView *viewForCodes;
    
    
    NSMutableDictionary *dictmVariantDetails;
    NSMutableArray *arrmTemp;
}

- (IBAction)btnContinueToSummaryDidClicked:(id)sender;
- (IBAction)btnContinueToVerificationDidClicked:(id)sender;


@end

@implementation SMSynopsisVehicleCodeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addingProgressHUD];
    
    txtYear.delegate = self;
    txtCondition.delegate = self;
    txtVINNo.delegate = self;
    txtKilometers.delegate = self;
    txtExtrasAtCost.delegate = self;
    txtMMCode.delegate = self;
    txtLightstoneCode.delegate = self;
    txtTruTradeCode.delegate = self;
    txtiXCode.delegate = self;
    
    
     self.navigationItem.titleView = [SMCustomColor setTitle:@"Vehicle Code "];
    arrmForYear = [[NSMutableArray alloc ] init];
    
    
    arrmTemp = [[NSMutableArray alloc ] init];
    [self gettingAllYearsForPickerView];
    arrmForCondition  = [[NSMutableArray alloc ] init];
    arrConditionData  = [NSArray arrayWithObjects:@"Excellent",@"Very Good",@"Good",@"Poor",@"Very Poor", nil];
    
    tblView.dataSource = self;
    tblView.delegate = self;
    tblView.tableHeaderView = viewForHeader;
    tblView.tableFooterView = viewForFooter;
    tblView.estimatedRowHeight = 236.0f;
    [self getConditionDropDown];
    
//    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
//    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
//    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad:)],
//                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                            [[UIBarButtonItem alloc]initWithTitle:@"Ok" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)]];
//    [numberToolbar sizeToFit];
//    txtExtrasAtCost.inputAccessoryView = numberToolbar;
//    txtKilometers.inputAccessoryView = numberToolbar;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    txtCondition.text = [arrConditionData objectAtIndex:2]; //Set default value to GOOD
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
}

-(void)cancelNumberPad:(id)sender{
    
    if(!isTxtKiloMetersSelected)
    {
        [txtExtrasAtCost resignFirstResponder];
        txtExtrasAtCost.text = @"";
        //txtCondition.userInteractionEnabled = YES;
    }
    else
    {
        [txtKilometers resignFirstResponder];
        txtKilometers.text = @"";
    }
}

-(void)doneWithNumberPad:(id)sender{
    //NSString *numberFromTheKeyboard = txtExtrasAtRetail.text;
    if(!isTxtKiloMetersSelected)
    {
        [txtExtrasAtCost resignFirstResponder];
        //txtCondition.userInteractionEnabled = YES;
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
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    int year = (int)[components year];
     [txtYear setText:[NSString stringWithFormat:@"%d",year]];
    for (int i=year; i>=1990; i--)
    {
        [arrmForYear addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}

#pragma mark - Table View Delegate and Datasource methods


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier= @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
   
    [cell addSubview:viewForCodes];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor blackColor];
    return cell;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56.0f;
}

#pragma mark - Text Field Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == txtVINNo)
    {
        return [SMAttributeStringFormatObject valdateTextFeild:txtVINNo shouldChangeCharactersInRange:range replacementString:string withValidationType:ACCEPTABLE_CHARACTERS andLimit:0];
        
    }
    
    if(textField == txtMMCode)
    {
        return [SMAttributeStringFormatObject valdateTextFeild:txtMMCode shouldChangeCharactersInRange:range replacementString:string withValidationType:ACCEPTABLE_CHARACTERS_Number andLimit:0];

    }
   
    if(textField == txtKilometers)
    {
        return [SMAttributeStringFormatObject valdateTextFeild:txtKilometers shouldChangeCharactersInRange:range replacementString:string withValidationType:ACCEPTABLE_CHARACTERS_Number andLimit:kKilometerLimit];

    }
    
    if(textField == txtExtrasAtCost)
    {
        return [SMAttributeStringFormatObject valdateTextFeild:txtExtrasAtCost shouldChangeCharactersInRange:range replacementString:string withValidationType:ACCEPTABLE_CHARACTERS_Number andLimit:0];

    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == txtCondition)
    {  [self.view endEditing:YES];
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
    {  [self.view endEditing:YES];
        /*************  your Request *******************************************************/
        [textField resignFirstResponder];
        
        [self.view endEditing:YES];
        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
        SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
        
        [popUpView getTheDropDownData:[SMAttributeStringFormatObject getYear] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:YES]; // array to be passed for custom popup dropdown
        
        [self.view addSubview:popUpView];
        
        [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
            NSLog(@"selected text = %@",selectedTextValue);
            NSLog(@"selected ID = %d",selectIDValue);
            textField.text = selectedTextValue;
            //selectedMakeId = selectIDValue;
        }];
        /*************  your Response *******************************************************/
        
    }
    else if(textField == txtExtrasAtCost)
    {
        //txtCondition.userInteractionEnabled = NO;
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
    
    if (txtExtrasAtCost.text.length ==0) {
       // txtExtrasAtCost.userInteractionEnabled = YES;
    }
    
}

#pragma mark - Button Methods

- (IBAction)btnContinueToSummaryDidClicked:(id)sender
{
    NSMutableURLRequest *requestURL;
    
    UIButton *btn = (UIButton *)sender;
    
    //If return YES means no blank feild
    if([self validateBlankTextForButton:(int)btn.tag])
    {
    if ([txtMMCode.text isEqualToString:@""])
    { // Never executed because client told to remoce ix Code.
        requestURL=[SMWebServices getSynopsisSummaryByIxCodeWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:[txtYear.text intValue] andiXCode:txtiXCode.text];
    }
    else{
      requestURL  =[SMWebServices getSynopsisSummaryByMMCodeCodeWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:[txtYear.text intValue] andMMCode:txtMMCode.text withKiloMeters:txtKilometers.text andVIN:txtVINNo.text andExtrasCost:txtExtrasAtCost.text andCondition:txtCondition.text];
    }
    
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
}

- (IBAction)btnContinueToVerificationDidClicked:(id)sender {
  
    UIButton *btn = (UIButton *)sender;
    
    //If return YES means no blank feild
    if([self validateBlankTextForButton:(int)btn.tag])
    {
    SMSynopsisVerifyVINViewController *synopsisVerifyVINViewController;
    synopsisVerifyVINViewController = [[SMSynopsisVerifyVINViewController alloc] initWithNibName:@"SMSynopsisVerifyVINViewController" bundle:nil];
    synopsisVerifyVINViewController.previousPageNumber = 3;
    synopsisVerifyVINViewController.strMainVehicleYear = txtYear.text;
    synopsisVerifyVINViewController.strMainVehicleName = @"Make?Model?";
    synopsisVerifyVINViewController.strSelectedMMCode = txtMMCode.text;
    synopsisVerifyVINViewController.strSelectedRegNo = @"";
    synopsisVerifyVINViewController.strSelectedVINNumber = txtVINNo.text;
    synopsisVerifyVINViewController.strSelectedKiloMeters = txtKilometers.text;
    synopsisVerifyVINViewController.strSelectedExtrasCost = txtExtrasAtCost.text;
    synopsisVerifyVINViewController.strSelectedCondition = txtCondition.text;
    [self.navigationController pushViewController:synopsisVerifyVINViewController animated:YES];
    }
}

-(BOOL)validateBlankTextForButton:(int)tag{
    if ([txtMMCode.text isEqualToString:@""]) {
        SMAlert(@"Smart Manager", kMMCodeORIXCode);
        return NO;
    }
//    else if ([txtVINNo.text isEqualToString:@""] && tag==1){
//        SMAlert(@"Smart Manager", kVINNoSelection);
//        [txtVINNo becomeFirstResponder];
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
