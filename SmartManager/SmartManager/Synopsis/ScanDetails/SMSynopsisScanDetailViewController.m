//
//  SMSynopsisScanDetailViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 18/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSynopsisScanDetailViewController.h"
#import "SMCustomTextField.h"
#import "SMCustomPopUpTableView.h"
#import "SMCustomColor.h"
#import "SMCustomPopUpPickerView.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "XMLDictionary.h"
#import "SMSynopsisSummaryViewController.h"
#import "SMSynopsisVINScanViewController.h"
#import "SMSynopsisXMLResultObject.h"
#import "SMSummaryObject.h"
#import "SMWSforSummaryDetails.h"
#import "SMSynopsisVerifyVINViewController.h"
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;

#define ACCEPTABLE_CHARACTERS_OEM  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define ACCEPTABLE_CHARACTERS_Number @"0123456789"
//#import "TPKeyboardAvoidingScrollView.h"
//FOR CUSTOM TEXTFIEDS TO HANDLE TEXT FIELD DELEGATE

typedef enum : NSUInteger
{
    Years = 0,
    Variant,
    Kilometers,
    ExtraCost,
    Condition,
}textFieldSelected;


@interface SMSynopsisScanDetailViewController ()
{
     MBProgressHUD *HUD;
    SMSynopsisXMLResultObject *objSMSynopsisResult;
    SMSummaryObject *objSMSummeryObject;
    
    IBOutlet UIScrollView *scrollViewParent;
    IBOutlet UILabel *lblMakeText;
    IBOutlet UILabel *lblColorText;
    IBOutlet UILabel *lblRegText;
    IBOutlet UILabel *lblEngineText;
    IBOutlet UILabel *lblVINText;
    IBOutlet UILabel *lblLicenceText;
    IBOutlet UILabel *lblExpiresText;
    IBOutlet UILabel *lblDescription;
    IBOutlet UILabel *lblCostApply;
    
    IBOutlet UILabel *lblVariant;
    IBOutlet UILabel *lblYear;
    __weak IBOutlet UILabel *lblModelName;
     NSString *strKilometers,*strExtras,*strCondition;
    
    IBOutlet SMCustomTextFieldForDropDown *txtModel;
    
    IBOutlet SMCustomTextFieldForDropDown *txtYear;
    IBOutlet SMCustomTextFieldForDropDown *txtVariant;
    IBOutlet SMCustomTextField *txtKilometers;
    IBOutlet SMCustomTextField *txtExtraCost;
    IBOutlet SMCustomTextFieldForDropDown *txtCondition;
    
    NSMutableArray *arrmForCondition;
    NSMutableArray *arrmForVariant;
    NSMutableArray *arrmForYear;
    NSMutableArray *arrConditionData;
    NSMutableArray *arrmTemp;
    
    NSString *strYear;
    
}

- (IBAction)btnContinueToSummaryDidClicked:(id)sender;
- (IBAction)btnContinueToVerficationDidClicked:(id)sender;
- (IBAction)btnDiscardDidClicked:(id)sender;
- (IBAction)btnSaveForLaterDidClicked:(id)sender;
@end

@implementation SMSynopsisScanDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addingProgressHUD];
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Scan VIN"];
   
    arrmForVariant = [[NSMutableArray alloc] init];
    yearArray = [[NSMutableArray alloc] init];
    arrConditionData = [[NSMutableArray alloc]init];
    arrmTemp = [[NSMutableArray alloc ] init];
    
    arrayOfConditionOptions   = [NSArray arrayWithObjects:@"Excellent",@"Very Good",@"Good",@"Poor",@"Very Poor", nil];
    
    if(!self.isFromScanPage)
    {
    
        btnSaveForLater.hidden = YES;
        lblCostApply.frame = CGRectMake(lblCostApply.frame.origin.x, lblCostApply.frame.origin.y - 44, lblCostApply.frame.size.width, lblCostApply.frame.size.height);
    }
    else
    {
        btnSaveForLater.hidden = NO;
    }
    
    
    [self getConditionDropDown];
    
    [self setLabelEntries];
    [self fetchVINScanDetails];
    
      scrollViewParent.contentSize = CGSizeMake(self.view.bounds.size.width,viewHoldingBottomFields.frame.origin.y + viewHoldingBottomFields.frame.size.height + 10.0f);
   
     self.view.backgroundColor = [UIColor blackColor];
      // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    txtCondition.text = [arrayOfConditionOptions objectAtIndex:2]; //Set default value to GOOD
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(pushBackToDesiredViewController)];
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Loading Mehods

/// Set Label text Entries from Scanner Details
-(void) setLabelEntries
{
    lblMakeText.text = self.VINLookupObject.Make;
    //lblModelText.text = self.VINLookupObject.Model;
    lblColorText.text =  [self.VINLookupObject.Colour uppercaseString];
    lblVINText.text = self.VINLookupObject.VIN;
    lblEngineText.text =self.VINLookupObject.EngineNo;
    lblExpiresText.text =self.VINLookupObject.DateExpires;
    lblRegText.text = self.VINLookupObject.Registration;
    if([self.VINLookupObject.strYear isKindOfClass:[NSNull class]])
        txtYear.text = @"";
    else txtYear.text = self.VINLookupObject.strYear;
    
    if(!self.isFromScanPage || self.isFromScanPage) // this means it is from SavedVin SCan page that is the edit page.
    {
        if([self.VINLookupObject.strKiloMeters isKindOfClass:[NSNull class]] || [self.VINLookupObject.strKiloMeters length] == 0)
        {
            txtKilometers.text = @"";
            lblKilometers.hidden = YES;
            txtKilometers.hidden = NO;
           
        }
        else
        {
            txtKilometers.hidden = YES;
            lblKilometers.hidden = NO;
            lblKilometers.text = self.VINLookupObject.strKiloMeters;
            strKilometers = self.VINLookupObject.strKiloMeters;
        }
        
        if([self.VINLookupObject.strExtras isKindOfClass:[NSNull class]] || [self.VINLookupObject.strExtras length] == 0)
        {
            txtExtraCost.text = @"";
            lblExtrasCost.hidden = YES;
            txtExtraCost.hidden = NO;
            
        }
        else
        {
            txtExtraCost.hidden = YES;
            lblExtrasCost.hidden = NO;
            lblExtrasCost.text = self.VINLookupObject.strExtras;
            strExtras = self.VINLookupObject.strExtras;
        }
        
        if([self.VINLookupObject.strCondition isKindOfClass:[NSNull class]] || [self.VINLookupObject.strCondition length] == 0)
        {
            txtCondition.text = @"";
            lblCondition.hidden = YES;
            txtCondition.hidden = NO;
        }
        else
        {
            lblCondition.hidden = NO;
            txtCondition.hidden = YES;
            strCondition = self.VINLookupObject.strCondition;
            lblCondition.text = self.VINLookupObject.strCondition;
        }
        
        if([self.VINLookupObject.strYear isKindOfClass:[NSNull class]] || [self.VINLookupObject.strYear length] == 0)
        {
            txtYear.text = @"";
            lblYear.hidden = YES;
            txtYear.hidden = NO;
            
        }
        else
        {
            lblYear.hidden = NO;
            txtYear.hidden = YES;
            lblYear.text = self.VINLookupObject.strYear;
            strYear= self.VINLookupObject.strYear;
        }
        
        if([self.VINLookupObject.strVariantName isKindOfClass:[NSNull class]] || [self.VINLookupObject.strVariantName length] == 0)
        {
            txtVariant.text = @"";
            lblVariant.hidden = YES;
            txtVariant.hidden = NO;
            
        }
        else
        {
            lblVariant.hidden = NO;
            txtVariant.hidden = YES;
            lblVariant.text = self.VINLookupObject.strVariantName;
            selectedVariantId = [self.VINLookupObject.variant intValue];
        }

    }
    viewHoldingBottomFields.frame = CGRectMake(viewHoldingBottomFields.frame.origin.x, txtVariant.frame.origin.y + txtVariant.frame.size.height + 8.0, viewHoldingBottomFields.frame.size.width, viewHoldingBottomFields.frame.size.height);
    lblDescription.hidden = YES;
    
    //lblLicenceText.text = @"Not Available Now";
   // lblDescription.text = @"VIN found in iX records: Last listed as a 2004 Honda S2000 2.0 VTEC (2004-2009). Durban,12 Jun 2014";
    
}

-(void) getConditionDropDown
{
  
    for(int i=0;i<5;i++)
    {
        SMDropDownObject *objCondition = [[SMDropDownObject alloc] init];
        objCondition.strMakeId = [NSString stringWithFormat:@"%d",i+1];
        objCondition.strMakeName = [arrayOfConditionOptions objectAtIndex:i];
        [arrConditionData addObject:objCondition];
    }
    
}

#pragma mark - WEB Services



#pragma mark - Text Field Delegate


-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField
{
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =  midline - viewRect.origin.y  - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= 177;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    return YES;
    
}

- (BOOL) textFieldShouldEndEditing:(UITextField*)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += 177;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
 if(textField == txtCondition)
   {
       [self.view endEditing:YES];
 /*************  your Request *******************************************************/
    [textField resignFirstResponder];
    NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
    SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
    
    
    [popUpView getTheDropDownData:arrConditionData withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
    
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
      txtVariant.text = @"";
      
       if([txtModel.text length] == 0 && txtModel.hidden == NO)
       {
           [self showAlert:KModelSelection];
           return;
       }
      /*************  your Request *******************************************************/
      [textField resignFirstResponder];
      [self.view endEditing:YES];
      NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
      SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
      
      [popUpView getTheDropDownData:[SMAttributeStringFormatObject getDropDownArray:yearArray] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
      
      [self.view addSubview:popUpView];
      
      [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
          NSLog(@"selected text = %@",selectedTextValue);
          selectedYear = selectedTextValue;
          strYear = selectedTextValue;
          textField.text = selectedTextValue;
          textField.textColor = [UIColor whiteColor];

      }];
      /*************  your Response *******************************************************/
  
  }
    
   else if(textField == txtVariant)
   {
       selectedType = 2;
       
       [self.view endEditing:YES];
       [textField resignFirstResponder];
       
       
       if([txtYear.text length] == 0)
       {
           [self showAlert:KNoYearsLoadedForSelectedModel];
       }
       else
          [self fetchVarientsForSelectedModel:selectedYear];
       
  }
  else if (textField== txtModel)
    {
        selectedType = 1;
        
        if (strHasModel==0) // it will excute in pop up show for model
        {
            [txtModel resignFirstResponder];
             txtYear.text = @"";
            txtVariant.text = @"";
            VINDetailArray  =[[NSMutableArray alloc]init];
            VINDetailArray  =[modelArray mutableCopy];
            [self.view endEditing:YES];
            /*************  your Request *******************************************************/
            [textField resignFirstResponder];
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            NSLog(@"ModelArray cpont = %lu",(unsigned long)modelArray.count);
            
            [popUpView getTheDropDownData:modelArray withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear)
             {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                textField.text = selectedTextValue;
                 selectedModelId = selectIDValue;
                 self.VINLookupObject.Model =selectedTextValue;
                 //[NSString stringWithFormat:@"%d",selectedModelId];
                 
                 // if max is 1900 i.e NULL
                 if (maxYear == 1900)
                 {
                     //Get Current Year into Current Year
                     NSDateFormatter *formatter       = [[NSDateFormatter alloc] init];
                     [formatter         setDateFormat:@"yyyy"];
                     maxYear     = [[formatter stringFromDate:[NSDate date]] intValue];
                 }
                 
                 yearArray=[[NSMutableArray alloc]init];
                 NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                 NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                 NSInteger year = [components year];
                 
                 for (int i=maxYear; i>=minYear; i--)
                 {
                     if (i<= year)
                     {
                         [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
                     }
                     
                 }

        }];

        }
    }
  
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == txtKilometers)
    {
        
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_Number] invertedSet];
        NSString       *filtered       = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if(newLength>6)
        {
            return (newLength > 6) ? NO : YES;
        }
        else
        {
            return [string isEqualToString:filtered];
        }
        
    }
    if(textField == txtExtraCost)
    {
        
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_Number] invertedSet];
        NSString       *filtered       = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if(newLength>8)
        {
            return (newLength > 8) ? NO : YES;
        }
        else
        {
            return [string isEqualToString:filtered];
        }
        
    }

    return YES;
}
-(void) loadSynopsisSummaryXML
{
    
    if(!self.isFromScanPage || self.isFromScanPage) // this means it is from SavedVin SCan page that is the edit page.
    {
        if([self.VINLookupObject.strKiloMeters isKindOfClass:[NSNull class]] || [self.VINLookupObject.strKiloMeters length] == 0)
        {
            strKilometers = txtKilometers.text;
        }
        else
        {
            strKilometers = self.VINLookupObject.strKiloMeters;
        }
        
        if([self.VINLookupObject.strExtras isKindOfClass:[NSNull class]] || [self.VINLookupObject.strExtras length] == 0)
        {
            strExtras = txtExtraCost.text;
            
        }
        else
        {
            strExtras = self.VINLookupObject.strExtras;
        }
        
        if([self.VINLookupObject.strCondition isKindOfClass:[NSNull class]] || [self.VINLookupObject.strCondition length] == 0)
        {
            strCondition = txtCondition.text;
        }
        else
        {
            strCondition = self.VINLookupObject.strCondition;
        }
        if([self.VINLookupObject.strYear isKindOfClass:[NSNull class]] || [self.VINLookupObject.strYear length] == 0)
        {
            strYear = txtYear.text;
        }
        else
        {
            strYear = self.VINLookupObject.strYear;
        }
        if([self.VINLookupObject.strVariantName isKindOfClass:[NSNull class]] || [self.VINLookupObject.strVariantName length] == 0)
        {
          
        }
        else
        {
             selectedVariantId = [self.VINLookupObject.variant intValue];
        }

        
    }

    NSMutableURLRequest *requestURL=[SMWebServices getSynopsisSummaryWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:[strYear intValue] andMakeId:selectedMakeId andModelId:selectedModelId andVariantId:selectedVariantId andVIN:lblVINText.text andKiloMeters:strKilometers andExtrasCost:strExtras andCondition:strCondition];
    
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

#pragma mark - Button Mehods

- (IBAction)btnContinueToSummaryDidClicked:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    //If return YES means no blank feild
    if([self validateBlankTextForButton:(int)btn.tag]){
        [self loadSynopsisSummaryXML];
    }
    
   /* SMSynopsisSummaryViewController *vcSMSynopsisVehicleLookUpViewController = [[SMSynopsisSummaryViewController alloc] initWithNibName:@"SMSynopsisSummaryViewController" bundle:nil];
    
    [self.navigationController pushViewController:vcSMSynopsisVehicleLookUpViewController animated:NO];*/
}

-(BOOL)validateBlankTextForButton:(int)tag{
    
    if(!txtModel.isHidden && [txtModel.text isEqualToString:@""])
    {
        SMAlert(@"Smart Manager", KModelSelection);
        return NO;
    }
    else if (!txtYear.isHidden && [txtYear.text isEqualToString:@""])
    {
        SMAlert(@"Smart Manager", KyearSelection);
        return NO;
    }
    else if (!txtVariant.isHidden && [txtVariant.text isEqualToString:@""]){
        SMAlert(@"Smart Manager", KVariantSelection);
        return NO;
    }
    else if(!txtKilometers.isHidden && [txtKilometers.text isEqualToString:@""]){
        SMAlert(kTitle, kKilometerSelection);
        return NO;
    }
    return YES;
}


- (IBAction)btnContinueToVerficationDidClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if(!self.isFromScanPage || self.isFromScanPage) // this means it is from SavedVin SCan page that is the edit page.
    {
        if([self.VINLookupObject.strVariantName isKindOfClass:[NSNull class]] || [self.VINLookupObject.strVariantName length] == 0)
        {
            
        }
        else
        {
            selectedVariantId = [self.VINLookupObject.variant intValue];
        }
    }
    
    //If return YES means no blank feild
    if([self validateBlankTextForButton:(int)btn.tag]){
        SMSynopsisVerifyVINViewController *synopsisVerifyVINViewController;
        synopsisVerifyVINViewController = [[SMSynopsisVerifyVINViewController alloc] initWithNibName:@"SMSynopsisVerifyVINViewController" bundle:nil];
        
        if(txtModel.isHidden)
        {
            synopsisVerifyVINViewController.strMainVehicleName = [NSString stringWithFormat:@"%@ %@",lblMakeText.text,lblModelName.text];
        }
        else{
            synopsisVerifyVINViewController.strMainVehicleName = [NSString stringWithFormat:@"%@ %@",lblMakeText.text,txtModel.text];
        }
        if (txtYear.isHidden)
        {
            synopsisVerifyVINViewController.strMainVehicleYear = lblYear.text;
        }
        else{
            synopsisVerifyVINViewController.strMainVehicleYear = txtYear.text;
        }
        if(txtKilometers.isHidden){
            synopsisVerifyVINViewController.strSelectedKiloMeters = lblKilometers.text;
        }
        else{
            synopsisVerifyVINViewController.strSelectedKiloMeters = txtKilometers.text;
        }
        synopsisVerifyVINViewController.strSelectedVINNumber = lblVINText.text;
        synopsisVerifyVINViewController.strSelectedCondition = txtCondition.text;
        synopsisVerifyVINViewController.previousPageNumber = 2;
        synopsisVerifyVINViewController.strSelectedMMCode = @"";
        synopsisVerifyVINViewController.strSelectedMakeID = selectedMakeId;
        synopsisVerifyVINViewController.strSelectedModelID = selectedModelId;
        synopsisVerifyVINViewController.strSelectedVariantID = selectedVariantId;
        synopsisVerifyVINViewController.strSelectedCondition = txtCondition.text;
        synopsisVerifyVINViewController.strSelectedRegNo = lblRegText.text;
        [self.navigationController pushViewController:synopsisVerifyVINViewController animated:YES];
    }
}

- (IBAction)btnDiscardDidClicked:(id)sender
{
    {
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:KWantToDiscard cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            
            switch (selectedIndex)
            {
                case 1:
                {
                     if(_VINLookupObject.savedScanID.intValue != 0)
                     {
                         [self discardingVINScan];
                     }
                     else
                     {
                         for (UIViewController *vc in [self.navigationController viewControllers]) {
                             if ([vc isMemberOfClass:[SMSynopsisVINScanViewController class]]) {
                                 [self.navigationController popToViewController:vc animated:YES];
                                 return;
                             }
                         }
                         return;
                     }
              
                }
                    break;
                    
                default:
                    break;
            }
            
            return;
        }];
        
    }
    
}

-(void)discardingVINScan
{
    NSLog(@"withSaveScanID = %@",_VINLookupObject.savedScanID);
    
    NSMutableURLRequest *requestURL=[SMWebServices removeVINscan:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withSaveScanID:_VINLookupObject.savedScanID.intValue];
    
    [HUD show:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(KLoaderTitle, error.localizedDescription);
             [HUD hide:YES];
             return;
         }
         else
         {
             VINDetailArray = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (IBAction)btnSaveForLaterDidClicked:(id)sender
{
    
    if (!txtYear.isHidden && [txtYear.text isEqualToString:@""])
    {
        SMAlert(@"Smart Manager", KyearSelection);
    }else if (!txtVariant.isHidden && [txtVariant.text isEqualToString:@""]){
        SMAlert(@"Smart Manager", KVariantSelection);
    }
    
    else
    {
    UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle  message:KSaveScanLater cancelButtonTitle:nil     otherButtonTitles:@"No",@"Yes",nil];
    
    [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
     {
         
         switch (selectedIndex)
         {
             case 1:
                 [self saveForLaterScan];
                 break;
             default:
                 break;
         }
     }];
    }
    
    
}

-(void)saveForLaterScan
{
    
    [HUD show:YES];
    
   /* NSMutableURLRequest *requestURL=[SMWebServices SavedVinScanForLater:[SMGlobalClass sharedInstance].hashValue clientID:[SMGlobalClass sharedInstance].strClientID.intValue vin:self.VINLookupObject.VIN registration:self.VINLookupObject.Registration shape:self.VINLookupObject.Shape makeId:self.VINLookupObject.Make modelId:self.VINLookupObject.Model colour:self.VINLookupObject.Colour engineNo:self.VINLookupObject.EngineNo kilometers:txtKilometers.text extrasCost:txtExtraCost.text condition:txtCondition.text];*/
    
    
    NSMutableURLRequest *requestURL = [SMWebServices SavedVinScanForLater:[SMGlobalClass sharedInstance].hashValue clientID:[SMGlobalClass sharedInstance].strClientID.intValue vin:self.VINLookupObject.VIN registration:self.VINLookupObject.Registration shape:self.VINLookupObject.Shape year:selectedYear makeId:self.VINLookupObject.Make modelId:self.VINLookupObject.Model variant:selectedVariant colour:self.VINLookupObject.Colour engineNo:self.VINLookupObject.EngineNo kilometers:txtKilometers.text extrasCost:txtExtraCost.text condition:txtCondition.text licExpiry:lblExpiresText.text variantid:[NSString stringWithFormat:@"%d",selectedVariantId]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             return;
         }
         else
         {
             VINDetailArray = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];

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

-(void)pushBackToDesiredViewController
{
    
    SMSynopsisVINScanViewController *selectType;
    
    for (UINavigationController *view in self.navigationController.viewControllers)
    {
        //when found, do the same thing to find the MasterViewController under the nav controller
        if ([view isKindOfClass:[SMSynopsisVINScanViewController class]])
        {
            selectType = (SMSynopsisVINScanViewController*)view;
            
        }
    }
    [self.navigationController popToViewController:selectType animated:YES];
    
    //[self.navigationController popViewControllerAnimated:YES];
    return;
       
    
}

#pragma mark -


#pragma mark - User Define Functions Call's
/*!
 @brief This is class method to show alert.
 @discussion When you want to show alert just pass the meassge no need to create Alert instances.
 @param  alertMeassge String
 @return No.
 */
-(void) showAlert:(NSString *)alertMeassge
{
    SMAlert(KLoaderTitle, alertMeassge);
}
/*!
 @brief This will call when user want to Update VIN.
 @discussion When User wants to update if vehicle is already added in to stcok it will navigate to add to stcok screen with update mode.To use it, simply call moveToUpdateScreen
 @param  No
 @return No.
 */


-(void)loadVarientsListing
{
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllVarintsvaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:txtYear.text modelId:1317];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
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
             variantArray = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}


#pragma mark - fetch  VIN Scan details
-(void)fetchVINScanDetails
{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingVINScanForVehicles:[SMGlobalClass sharedInstance].hashValue clientID:[SMGlobalClass sharedInstance].strClientID.intValue vin:self.VINLookupObject.VIN registration:self.VINLookupObject.Registration makeId:self.VINLookupObject.Make modelId:self.VINLookupObject.Model];
    
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
             [HUD hide:YES];
             return;
             
         }
         else
         {
             
             stockArray=[[NSMutableArray alloc]init];
             VINDetailArray = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

#pragma mark - fetch varient for selected model
-(void)fetchVarientsForSelectedModel:(NSString*)startYear
{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllVarintsvaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:strYear modelId:selectedModelId];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [HUD show:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
             return;
             
         }
         else
         {
             variantArray = [[NSMutableArray alloc] init];
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
   
    VINScanDetailsObject=[[SMVINScanDetailsObject alloc]init];
    
    if ([elementName isEqualToString:@"ListVariantsJSONResult"])
    {
        loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
    }
    if ([elementName isEqualToString:@"GetSynopsisByVinNumberXmlResponse"]) {
        objSMSynopsisResult = [[SMSynopsisXMLResultObject alloc]init];
        objSMSynopsisResult.arrmDemandSummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmAverageAvailableSummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmAverageDaysInStockSummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmLeadPoolSummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmWarrantySummary = [[NSMutableArray alloc ] init];
        
    }
    if ([elementName isEqualToString:@"VariantDetails"])
    {
        objSMSynopsisResult.arrVariantDetails = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < 6; ++i)
        {
            [objSMSynopsisResult.arrVariantDetails addObject:@""];
        }
        
        //[arrVariantDetails replaceObjectAtIndex:0 withObject:object];
        //[arrVariantDetails replaceObjectAtIndex:3 withObject:object];
        NSLog(@"Did enter hereg...");
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
    
    
    if ([elementName isEqualToString:@"CheckScannedVinJSONResult"])
    {
        NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        
        /*
         
         Added By Jignesh K
         
         LogiC behind Model Listing *******
         
         The scan provides a make name and a model name
         We check the Database for the make name - and
         get our makeID from that
         We then also check for the model name - IF we can find it,
         then we return hasModel=true and a list of variants
         if we don't find it, we return hasModel=false,
         and a list of models
         for most vehicles, hasModel should be true
         but there are some that don't match, so we have to pass hasModel=false and the list of models*/
         
    
        
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            
            
            strHasModel =[jsonObject[@"hasModel"] boolValue];
            
            
            if (strHasModel ==0)
            {
                modelArray                     =[[NSMutableArray alloc]init];
                vinScanModelObject.strExisting =jsonObject[@"existing"];
                vinScanModelObject.strHasModel =[jsonObject[@"hasModel"] boolValue];
                vinScanModelObject.strMaxYear  =jsonObject[@"maxYear"];
                
                //
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                NSInteger year = [components year];
                if(vinScanModelObject.strMaxYear.intValue <= year)
                {
                    vinScanModelObject.strMaxYear   = jsonObject[@"maxYear"];
                }
                
                vinScanModelObject.strMinYear  =jsonObject[@"minYear"];
                
               
                
                for (NSDictionary *dictionary in jsonObject[@"models"])
                {
                    modelDropdownObj=[[SMDropDownObject alloc]init];
                    modelDropdownObj.strMakeId      = dictionary[@"modelID"];
                    modelDropdownObj.strMakeName    =    dictionary[@"modelName"];
                    modelDropdownObj.strMinYear =dictionary[@"minYear"];
                    modelDropdownObj.strMaxYear =dictionary[@"maxYear"];
                    selectedMakeId  = [jsonObject[@"makeID"] intValue];
                    
                    if ([modelDropdownObj.strMaxYear isEqualToString:@"0"])
                    {
                        
                        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                        NSInteger year = [components year];
                        modelDropdownObj.strMaxYear = [NSString stringWithFormat:@"%ld",(long)year];
                    }
               
                    [modelArray addObject:modelDropdownObj];
                    
                }
                txtModel.userInteractionEnabled = YES;
                txtModel.hidden = NO;
                lblModelName.hidden = YES;
               
            }
            else
            {
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                NSInteger year = [components year];
                
                int currentYear = [jsonObject[@"maxYear"] intValue];
                
                if (currentYear == 0)
                {
                    currentYear = year;
                }
                for(int i=currentYear; i>=[jsonObject[@"minYear"] intValue]; i--)
                {
                    [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
                }
                NSLog(@"YearRArray = %@",yearArray);
                
                txtModel.userInteractionEnabled = NO;
                txtModel.hidden = YES;
                lblModelName.hidden = NO;
                lblModelName.text=self.VINLookupObject.Model;

                variantArray=[[NSMutableArray alloc]init];
                VINScanDetailsObject.strExisting =jsonObject[@"existing"];
                VINScanDetailsObject.strHasModel =[jsonObject[@"hasModel"] boolValue];
                VINScanDetailsObject.strMaxYear  =jsonObject[@"maxYear"];
                VINScanDetailsObject.strMinYear  =jsonObject[@"minYear"];
                MaximumYear=[VINScanDetailsObject.strMaxYear intValue];
                MinimumYear=[VINScanDetailsObject.strMinYear intValue];
                selectedMakeId  = [jsonObject[@"makeID"] intValue];
                selectedModelId = [jsonObject[@"ModelID"] intValue];
              
                
                for (NSDictionary *dictionary in jsonObject[@"variants"])
                {
                    VINScanDetailsObject=[[SMVINScanDetailsObject alloc]init];
                    VINScanDetailsObject.strVariantsCode =dictionary[@"code"];
                    VINScanDetailsObject.strVariantsFriendly =dictionary[@"name"];
                    VINScanDetailsObject.strVariantsId =dictionary[@"id"];
                    VINScanDetailsObject.strVariantsMaxYear =dictionary[@"maxYear"];
                    VINScanDetailsObject.strVariantsMinYear =dictionary[@"minYear"];
                    VINScanDetailsObject.strVariantsName =dictionary[@"name"];
                                        
                    if ([VINScanDetailsObject.strVariantsMaxYear isEqualToString:@"0"])
                    {
                        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                        NSInteger year = [components year];
                        VINScanDetailsObject.strVariantsMaxYear = [NSString stringWithFormat:@"%ld",(long)year];
                    }
                    
                    [variantArray addObject:VINScanDetailsObject];
                    
                }
                
                
            }
            
            ////////////////// END OF WEB SERVICE CHECKSCANN VIN JSON
            
            if([self.VINLookupObject.strVariantName isKindOfClass:[NSNull class]] || [self.VINLookupObject.strVariantName length] == 0)
            {
                txtVariant.text = @"";
                lblVariant.hidden = YES;
                txtVariant.hidden = NO;
                
            }
            else
            {
                lblVariant.hidden = NO;
                txtVariant.hidden = YES;
                lblVariant.text = self.VINLookupObject.strVariantName;
                selectedVariantId = [self.VINLookupObject.variant intValue];
            }
            ////////////////// END OF WEB SERVICE CHECKSCANN VIN JSON
                       
            //hide progress bar
            [self hideProgressHUD];
            
            
            isExisiting=NO;
            
            NSLog(@"jsonObject is %@",VINDetailArray);
            
            
        }
        else
        {
            SMAlert(KLoaderTitle, [jsonObject valueForKey:@"message"]);
        }
        
    }
    
    //get make data
    NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObject=[NSJSONSerialization
                              JSONObjectWithData:data
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    
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
                [variantArray          addObject:loadVehiclesObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
        
    }
    
    
    if ([elementName isEqualToString:@"ListVariantsJSONResponse"])
    {
        if (variantArray.count!=0)
        {
            //[loadVehicleTableView reloadData];
           // variantArray.count>0 ?[self loadPopup]:SMAlert(KLoaderTitle,KNorecordsFousnt);
            
            /*************  your Request *******************************************************/
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:variantArray withVariant:YES andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/
            
            
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                selectedVariantId = selectIDValue;
                selectedVariant = selectedTextValue;
                txtVariant.text = selectedTextValue;
            }];
            
            
            
        }
    }
    if ([elementName isEqualToString:@"SaveVINScanResult"])
    {
       if([currentNodeContent containsString:@"OK"])
       {
           UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle  message:KScanSavedSuccess cancelButtonTitle:nil     otherButtonTitles:@"Ok",nil];
           
           [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
            {
                
                switch (selectedIndex)
                {
                    case 0:
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        break;
                    default:
                        break;
                }
            }];
       }
       else
       {
           UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle  message:jsonObject[@"message"] cancelButtonTitle:nil     otherButtonTitles:@"Ok",nil];
           
           [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
            {
                
                switch (selectedIndex)
                {
                    case 0:
                        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count -3] animated:YES];
                        break;
                    default:
                        break;
                }
            }];
        }
        
        
   ///////////////    Json Response /////////////////////////////////////////
        
      /*  NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        
        
        if ([[jsonObject valueForKey:@"SaveVINScanResult"]isEqualToString:@"OK"])
        {
            
            
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle  message:KScanSavedSuccess cancelButtonTitle:nil     otherButtonTitles:@"Ok",nil];
            
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 
                 switch (selectedIndex)
                 {
                     case 0:
                         [self.navigationController popToRootViewControllerAnimated:YES];
                         break;
                     default:
                         break;
                 }
             }];
            
        }
        else
        {
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle  message:jsonObject[@"message"] cancelButtonTitle:nil     otherButtonTitles:@"Ok",nil];
            
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 
                 switch (selectedIndex)
                 {
                     case 0:
                         [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count -3] animated:YES];
                         break;
                     default:
                         break;
                 }
             }];
        
        }*/
        
    }
    
    // if vehicle is discarded
    
    if ([elementName isEqualToString:@"RemoveVINScanResult"])
    {
        
        NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        [self hideProgressHUD];
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle  message:KVehicleDiscardedSuccessfully cancelButtonTitle:nil     otherButtonTitles:@"Ok",nil];
            
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 
                 switch (selectedIndex)
                 {
                     case 0:
                         [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count -3] animated:YES];
                         break;
                     default:
                         break;
                 }
             }];
        }
        else
        {
            [self showAlert:KRemovedVINScan];
        }
        
    }
    
 /////////////////////////////////////////////////////////////////////////////////////////////////
    
    if ([elementName isEqualToString:@"ImageUrl"]) {
        
        objSMSynopsisResult.strVariantImage = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Year"]) {
        
        objSMSynopsisResult.intYear = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"MakeId"]) {
        objSMSynopsisResult.intMakeId = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"ModelId"]) {
        objSMSynopsisResult.intModelId = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"VariantId"]) {
        objSMSynopsisResult.intVariantId = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"MakeName"]) {
        objSMSynopsisResult.strMakeName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ModelName"]) {
        objSMSynopsisResult.strModelName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"VariantName"]) {
        objSMSynopsisResult.strVariantName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"FriendlyName"]) {
        objSMSynopsisResult.strFriendlyName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MMCode"]) {
        objSMSynopsisResult.strMMCode = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Transmission"]) {
        objSMSynopsisResult.strTransmission = currentNodeContent;
    }
    if ([elementName isEqualToString:@"StartDate"]) {
        objSMSynopsisResult.strStartDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"EndDate"]) {
        objSMSynopsisResult.strEndDate = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"VariantDetails"])
    {
        if([currentNodeContent length] == 0)
            objSMSynopsisResult.arrVariantDetails = nil;
    }
    
    if ([elementName isEqualToString:@"Gears"]) {
        objSMSynopsisResult.intGears = [currentNodeContent intValue];
    }
    
    
    if ([elementName isEqualToString:@"Fuel_Type"])
    {
        [objSMSynopsisResult.arrVariantDetails replaceObjectAtIndex:3 withObject:currentNodeContent];
    }
    if ([elementName isEqualToString:@"Power_KW"])
    {
        [objSMSynopsisResult.arrVariantDetails replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@ kW",currentNodeContent]];
    }
    if ([elementName isEqualToString:@"Torque_NM"])
    {
        [objSMSynopsisResult.arrVariantDetails replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@ Nm",currentNodeContent]];
    }
    if ([elementName isEqualToString:@"Engine_CC"])
    {
        [objSMSynopsisResult.arrVariantDetails replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@ cc",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent]]];
    }
    if ([elementName isEqualToString:@"Transmission_Type"])
    {
        objSMSynopsisResult.strGearbox = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"Gears"]) {
        objSMSynopsisResult.intGears = [currentNodeContent intValue];
        
        NSString *strValue = [NSString stringWithFormat:@"%@",objSMSynopsisResult.strGearbox];
        if ([strValue isEqualToString:@"(null)"]) {
            [objSMSynopsisResult.arrVariantDetails replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%d gears",objSMSynopsisResult.intGears]];
        }
        else{
            [objSMSynopsisResult.arrVariantDetails replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%@, %d gears",objSMSynopsisResult.strGearbox,objSMSynopsisResult.intGears]];
        }
    }
    
    if ([elementName isEqualToString:@"Sources"]) {
        objSMSynopsisResult.intSources = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"AverageTradePrice"]) {
        objSMSynopsisResult.floatAverageTradePrice = [currentNodeContent floatValue];
    }
    if ([elementName isEqualToString:@"AveragePrice"]) {
        objSMSynopsisResult.floatAveragePrice = [currentNodeContent floatValue];
    }
    if ([elementName isEqualToString:@"MarketPrice"]) {
        objSMSynopsisResult.floatMarketPrice = [currentNodeContent floatValue];
    }
    if ([elementName isEqualToString:@"Value"]) {
        objSMSummeryObject.intValue = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"Area"]) {
        objSMSummeryObject.strArea = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Type"]) {
        objSMSummeryObject.strType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SummaryItem"]) {
        [arrmTemp addObject:objSMSummeryObject];
    }
    if ([elementName isEqualToString:@"DemandSummary"]) {
        [objSMSynopsisResult.arrmDemandSummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"AverageAvailableSummary"]) {
        [objSMSynopsisResult.arrmAverageAvailableSummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"AverageDaysInStockSummary"]) {
        [objSMSynopsisResult.arrmAverageDaysInStockSummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"LeadPoolSummary"]) {
        [objSMSynopsisResult.arrmLeadPoolSummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"WarrantySummary"]) {
        [objSMSynopsisResult.arrmWarrantySummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"ReviewCount"]) {
        objSMSynopsisResult.intReviewCount = [currentNodeContent intValue];
    }
    
    if ([elementName isEqualToString:@"GetSynopsisByVinNumberXmlResponse"]) {
        
        [self hideProgressHUD];
        
         if([currentNodeContent length] == 0)
         {
             SMAlert(@"Smart Manager", @"Error while loading data. Please try again later.");
             return;
         }
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            SMSynopsisSummaryViewController *vcSMSynopsisVehicleLookUpViewController = [[SMSynopsisSummaryViewController alloc] initWithNibName:@"SMSynopsisSummaryViewController" bundle:nil];
            vcSMSynopsisVehicleLookUpViewController.objSMSynopsisResult = objSMSynopsisResult;
            
            
            [self.navigationController pushViewController:vcSMSynopsisVehicleLookUpViewController animated:NO];
        }
        else
        {
            SMSynopsisSummaryViewController *vcSMSynopsisVehicleLookUpViewController = [[SMSynopsisSummaryViewController alloc] initWithNibName:@"SMSynopsisSummaryViewController" bundle:nil];
            vcSMSynopsisVehicleLookUpViewController.objSMSynopsisResult = objSMSynopsisResult;
           
            [self.navigationController pushViewController:vcSMSynopsisVehicleLookUpViewController animated:NO];
        }
        
    }

    
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
}

-(void)loadSynopsisSummaryWithVin
{
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    //  NSMutableURLRequest *requestURL=[SMWebServices getSynopsisSummaryByVinNumberWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:selectedYear.intValue andVinNumber:lblVINText.text];
    
    NSMutableURLRequest *requestURL=[SMWebServices getSynopsisSummaryByVinNumberWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:txtYear.text.intValue andVinNumber:lblVINText.text withKiloMeters:txtKilometers.text andExtrasCost:txtExtraCost.text andCondition:txtCondition.text];
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
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
             variantArray = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}



@end
