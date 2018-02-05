//
//  SMCustomerScanDetailViewController.m
//  SmartManager
//
//  Created by Jignesh on 03/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomerScanDetailViewController.h"
#import "SMCustomerDetailsScamInformationTableViewCell.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMDLVehicleClassCell.h"
#import "SMCustomerScanViewController.h"
#import "UIBAlertView.h"

@interface SMCustomerScanDetailViewController ()

@end

@implementation SMCustomerScanDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
       
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(pushBackToViewControllerWithoutRefreshing)];

}

-(void)pushBackToViewController
{
    SMCustomerScanViewController *scanView;
    for (UINavigationController *view in self.navigationController.viewControllers)
    {
        //when found, do the same thing to find the MasterViewController under the nav controller
        if ([view isKindOfClass:[SMCustomerScanViewController class]])
        {
            scanView = (SMCustomerScanViewController*)view;
            
        }
    }
    
    [self.refreshDLListDelegate refreshTheDLList];

    [self.navigationController popToViewController:scanView animated:YES];


}

-(void)pushBackToViewControllerWithoutRefreshing
{
    if(!self.isFromDLListScreen)
    {
    
    UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle  message:@"You have not added any contact information. Do you want to continue?" cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
        if (didCancel)
        {
            return;
        }
        switch (selectedIndex)
        {
            case 1:
            {
                [self optionSelectedForPush];
            }
                break;
            case 2:
            {
                return;

            }
                break;
            default:
                break;
        }
    }];
    
    }
    else
    {
        [self optionSelectedForPush];
    }
    
}

-(void)optionSelectedForPush
{
    SMCustomerScanViewController *scanView;
    for (UINavigationController *view in self.navigationController.viewControllers)
    {
        //when found, do the same thing to find the MasterViewController under the nav controller
        if ([view isKindOfClass:[SMCustomerScanViewController class]])
        {
            scanView = (SMCustomerScanViewController*)view;
            
        }
    }
    
    [self.navigationController popToViewController:scanView animated:YES];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addingProgressHUD];
    [self setTheTitle];
    
    arrayOfVehicleClass = [[NSMutableArray alloc]init];
    
    NSLog(@"telephone number = %@",self.custDetailsObj.custPhoneNumber);
    NSLog(@"email address = %@",self.custDetailsObj.custEmailAddress);

    
    self.lblCustomerID.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblCustomerName.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblID.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblName.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblDOB.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblDOBValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblGender.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblGenderValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblRestrictions.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblRestrictionsValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblAge.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblAgeValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblCertificate.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    self.lblCertificateValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];

    self.viewContainingPhoto.layer.borderWidth = 1.0;
    self.viewContainingPhoto.layer.borderColor = [[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    
    custClasses = @"";
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.topItem.title = @"Back";

    // arrayforScandetailsInformations = [[NSMutableArray alloc]init];
    [self registerNibforTable];

    if(!self.isFromDLListScreen)
    {
        self.textFieldPhoneNumber.text = @"";
        self.textFieldsEmailAddress.text = @"";
        [self.buttonSave setTitle:@"Save" forState:UIControlStateNormal];
      [self getTheCustomerDetailsFromDriverLicenceScan];
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            
        {
            self.lblCustomerID.text = [NSString stringWithFormat:@"%@", self.custDetailsObj.customerID];
            
            self.lblCustomerName.text = self.custDetailsObj.customerName;
            UIImage *custImage = [self decodeBase64ToImage:self.custDetailsObj.custPhoto];
            self.imgCustomer.image = custImage;
            
            self.lblDOBValue.text = self.custDetailsObj.custDOB;
            self.lblGenderValue.text = self.custDetailsObj.custGender;
            self.lblAgeValue.text = [self returnTheAgeFromDOB:self.custDetailsObj.custDOB];
            self.lblRestrictionsValue.text = self.custDetailsObj.custRestriction;
            [self.lblRestrictionsValue sizeToFit];
            
            self.lblCertificateValue.text = self.custDetailsObj.custCertificateNo;
            
            
            if([self.custDetailsObj.custRestriction rangeOfString:@","].location!=NSNotFound)
            {
                NSLog(@"Entered...");
                
                self.viewContainingCertificate.frame = CGRectMake(self.viewContainingCertificate.frame.origin.x, self.lblRestrictionsValue.frame.origin.y + self.lblRestrictionsValue.frame.size.height, self.viewContainingCertificate.frame.size.width, self.viewContainingCertificate.frame.size.height);
                
                
                
                [self.tableForCustomerInformations setTableHeaderView:self.viewHeaderInformations];
                
                
            }
        }
        else
        {
            
            self.lblCustomerID_iPad.text = [NSString stringWithFormat:@"%@", self.custDetailsObj.customerID];
            
            self.lblCustomerName_iPad.text = self.custDetailsObj.customerName;
            UIImage *custImage = [self decodeBase64ToImage:self.custDetailsObj.custPhoto];
            self.imgCustomer_iPad.image = custImage;
            
            self.lblDOBValue_iPad.text = self.custDetailsObj.custDOB;
            self.lblGenderValue_iPad.text = self.custDetailsObj.custGender;
            self.lblAgeValue_iPad.text = [self returnTheAgeFromDOB:self.custDetailsObj.custDOB];
            self.lblRestrictionsValue_iPad.text = self.custDetailsObj.custRestriction;
            [self.lblRestrictionsValue_iPad sizeToFit];
            
            self.lblCertificateValue_iPad.text = self.custDetailsObj.custCertificateNo;
            
            
            if([self.custDetailsObj.custRestriction rangeOfString:@","].location!=NSNotFound)
            {
                NSLog(@"Entered...");
                
                self.viewContainingCertificate_iPad.frame = CGRectMake(self.viewContainingCertificate_iPad.frame.origin.x, self.lblRestrictionsValue_iPad.frame.origin.y + self.lblRestrictionsValue_iPad.frame.size.height, self.viewContainingCertificate_iPad.frame.size.width, self.viewContainingCertificate_iPad.frame.size.height);
                
                [self.tableForCustomerInformations setTableHeaderView:self.viewHeaderInformations_iPad];
                
            }
            
            
        }
        
        self.textFieldPhoneNumber.text = self.custDetailsObj.custPhoneNumber;
        self.textFieldsEmailAddress.text = self.custDetailsObj.custEmailAddress;
        [self.buttonSave setTitle:@"Update" forState:UIControlStateNormal];

        [self.tableForCustomerInformations reloadData];

    
    }
    
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData
{
    NSLog(@"strEncodeData = %@",strEncodeData);
    if([strEncodeData isKindOfClass:[NSNull class]] || strEncodeData.length == 0)
    {
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Could not find the details." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel)
            {
                [HUD hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
                
                return;
                
            }
            
        }];
    }
    else
    {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        return [UIImage imageWithData:data];
    }
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UItetxfields methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{

    CGRect frame = [self.tableForCustomerInformations convertRect:self.textFieldPhoneNumber.frame fromView:self.textFieldPhoneNumber.superview];
    [self.tableForCustomerInformations setContentOffset:CGPointMake(0, frame.origin.y) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.textFieldPhoneNumber)
    {
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int length = (int)[currentString length];
    if (length > 10) {
        return NO;
    }
    return YES;
    }
    return YES;
}

-(void)doneButtOnDIdPressed
{
    [self.view endEditing:YES];
}

#pragma mark -

#pragma mark - UITable View
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifer1=@"SMDLVehicleClassCell";
    SMDLVehicleClassCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer1 forIndexPath:indexPath];
    
    SMCustomerVehicleClassObj *vehicleClassObj;
    
    if(!self.isFromDLListScreen)
    {
        vehicleClassObj = (SMCustomerVehicleClassObj*)[arrayOfVehicleClass objectAtIndex:indexPath.row];
    }
    else
    {
        vehicleClassObj = (SMCustomerVehicleClassObj*)[self.arrayOfVehicleClass objectAtIndex:indexPath.row];
    }
    
    cell.lblIssuedDateValue.text = vehicleClassObj.vehicleClassIssuedDate;
    cell.lblVehicleClassName.text = vehicleClassObj.vehicleClassName;
    cell.lblRestrictionsValue.text = vehicleClassObj.vehicleClassRestrictions;
    [cell.lblRestrictionsValue sizeToFit];
    
    if([vehicleClassObj.vehicleClassName hasPrefix:@"A "])
        cell.imgViewVehicleClass.image = [UIImage imageNamed:@"A_motorcycle.png"];
    else if ([vehicleClassObj.vehicleClassName hasPrefix:@"A1 "])
        cell.imgViewVehicleClass.image = [UIImage imageNamed:@"A1_Motorcycle.png"];
    else if ([vehicleClassObj.vehicleClassName hasPrefix:@"B "])
        cell.imgViewVehicleClass.image = [UIImage imageNamed:@"B_Vehicle_Trailer.png"];
    else if ([vehicleClassObj.vehicleClassName hasPrefix:@"C "])
        cell.imgViewVehicleClass.image = [UIImage imageNamed:@"C_Bus.png"];
    else if ([vehicleClassObj.vehicleClassName hasPrefix:@"C1 "])
        cell.imgViewVehicleClass.image = [UIImage imageNamed:@"C1_Small_Truck.png"];
    else if ([vehicleClassObj.vehicleClassName hasPrefix:@"EB "])
        cell.imgViewVehicleClass.image = [UIImage imageNamed:@"EB_Vehicle_Caravan.png"];
    else if ([vehicleClassObj.vehicleClassName hasPrefix:@"EC "])
        cell.imgViewVehicleClass.image = [UIImage imageNamed:@"EC_Bus_Trailer.png"];
    else if ([vehicleClassObj.vehicleClassName hasPrefix:@"EC1 "])
        cell.imgViewVehicleClass.image = [UIImage imageNamed:@"EC1_Truck_Trailer.png"];
    
    
        
    if(UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPad)
    {

        cell.backgroundColor = [UIColor clearColor];
    }
        
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
        {
        [cell setPreservesSuperviewLayoutMargins:NO];
        }
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
   
    //end of code for swipe to delete
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.isFromDLListScreen)
    {
        return arrayOfVehicleClass.count;
    }
    else
    {
        return self.arrayOfVehicleClass.count;
    }
}

/*-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (IS_IOS8_OR_ABOVE)
        return UITableViewAutomaticDimension;
    else
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ?44.0f :64.0f;
    
}*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 102.0;
    
   // return  UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 44.0 : 64.0;
}


#pragma mark -

#pragma mark - User Define Functions

//
-(IBAction)buttonSave:(id)sender
{
    [self.textFieldsEmailAddress resignFirstResponder];
    [self.textFieldPhoneNumber resignFirstResponder];
    
    if([self validateSave]  == YES)
    {
        if(![self mobileNumberValidate:self.textFieldPhoneNumber.text])
        {
            SMAlert(KLoaderTitle,@"Please enter valid phone number");
            return;
        }
        
        if(!self.isFromDLListScreen)
        {
            
            [self saveTheDriverLicenseToServerWithSCanID:ScanID];
        }
        else
        {
            [self saveTheDriverLicenseToServerWithSCanID:self.custDetailsObj.custScanID.intValue];

        }
        
    }
    
}
-(void) registerNibforTable
{
    
    [self.tableForCustomerInformations registerNib:[UINib nibWithNibName:@"SMCustomerDetailsScamInformationTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    
    [self.tableForCustomerInformations setTableFooterView:self.viewFooterInformations];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
         [self.tableForCustomerInformations setTableHeaderView:self.viewHeaderInformations];
    }
    else
    {
        
        self.lblCustomerID_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblCustomerName_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblID_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblName_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblDOB_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblDOBValue_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblGender_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblGenderValue_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblRestrictions_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblRestrictionsValue_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblAge_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblAgeValue_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblCertificate_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblCertificateValue_iPad.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        
        self.viewContainingPhoto_iPad.layer.borderWidth = 1.0;
        self.viewContainingPhoto_iPad.layer.borderColor = [[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];

        
        
        [self.tableForCustomerInformations setTableHeaderView:self.viewHeaderInformations_iPad];

    }
    
   // self.textFieldPhoneNumber.toolbarDelegate    = self;

}

-(BOOL)validateSave
{

    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regExpred =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringCheck = [regExpred evaluateWithObject:self.textFieldsEmailAddress.text];
    
    if (self.textFieldPhoneNumber.text.length == 0)
    {
        SMAlert(KLoaderTitle,kSelectPhoneNUmber);
        return NO;
    }
    else if(!myStringCheck)
    {
        SMAlert(KLoaderTitle,kEnterValidEmail);
        return NO;
    }
    else if (self.textFieldsEmailAddress.text.length == 0)
    {
        SMAlert(KLoaderTitle,kEnterYourEmail);
        return NO;
    }
    return YES;
}

- (BOOL)mobileNumberValidate:(NSString*)number
{
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}


#pragma mark - Webservice Integration


-(void)getTheCustomerDetailsFromDriverLicenceScan
{
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices getTheCustomerDetailsDLScanWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andBase64LicenseString:[SMGlobalClass sharedInstance].Base64String_CustomerDLScan];
    
    NSLog(@"Request URL = %@",requestURL);
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         
         if (error!=nil)
         {
             
             [self hideProgressHUD];

             
             [[[UIAlertView alloc]initWithTitle:@"Error"
                                        message:[error.localizedDescription capitalizedString]
                                       delegate:self cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil]
              show];
             
         }
         else
         {
             
                        
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}

-(void)saveTheDriverLicenseToServerWithSCanID:(int)scanId
{
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices saveTheDLScanDataWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andScanID:scanId andEmailAddress:self.textFieldsEmailAddress.text andPhoneNumber:self.textFieldPhoneNumber.text];
    
   
    
    NSLog(@"Request URL = %@",requestURL);
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         
         if (error!=nil)
         {
             
             [self hideProgressHUD];
             
             
             [[[UIAlertView alloc]initWithTitle:@"Error"
                                        message:[error.localizedDescription capitalizedString]
                                       delegate:self cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil]
              show];
             
         }
         else
         {
             
             
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}



#pragma mark - NsXmlParser delegate methods

#pragma mark - Parsing delegate methods

// The first method to implement is parser:didStartElement:namespaceURI:qualifiedName:attributes:, which is fired when the start tag of an element is found:

//---when the start of an element is found---

-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict
{
    if([elementName isEqualToString:@"DrivingLicenseCard"])
    {
        self.custDetailsObj = [[SMCustomerDetailsDLScanObj alloc]init];
    }
    if([elementName isEqualToString:@"VehicleClass1"])
    {
        isIndividualVehicleClassDone = NO;
        self.vehicleClassObj = [[SMCustomerVehicleClassObj alloc]init];
    }
    if([elementName isEqualToString:@"VehicleClass2"])
    {
        isIndividualVehicleClassDone = NO;
        self.vehicleClassObj = [[SMCustomerVehicleClassObj alloc]init];
    }
    if([elementName isEqualToString:@"VehicleClass3"])
    {
        isIndividualVehicleClassDone = NO;
        self.vehicleClassObj = [[SMCustomerVehicleClassObj alloc]init];
    }
    if([elementName isEqualToString:@"VehicleClass4"])
    {
        isIndividualVehicleClassDone = NO;
        self.vehicleClassObj = [[SMCustomerVehicleClassObj alloc]init];
    }
    
    
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

//The next method to implement is parser:foundCharacters:, which gets fired when the parser finds the text of an element:

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}



-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    
    if([elementName isEqualToString:@"Number"])
    {
        self.custDetailsObj.customerID = currentNodeContent;
    }
    
    if([elementName isEqualToString:@"Surname"])
    {
        custSurName = currentNodeContent;
    }
    
    if([elementName isEqualToString:@"Initials"])
    {
        self.custDetailsObj.customerName = [NSString stringWithFormat:@"%@ %@",currentNodeContent,custSurName];
    }
    if([elementName isEqualToString:@"DriverRestriction1"])
    {
        
        if([currentNodeContent isEqualToString:@"0"])
            tempDriverRestrictionStr = @"None";
        
        else  if([currentNodeContent isEqualToString:@"1"])
        {
            currentNodeContent = [NSMutableString stringWithFormat:@"%@", @"Glasses / Contact lenses"];
            
            tempDriverRestrictionStr = [NSString stringWithFormat:@"%@", currentNodeContent];
        }
        else  if([currentNodeContent isEqualToString:@"2"])
        {
             tempDriverRestrictionStr = [NSMutableString stringWithFormat:@"%@", @"Artificial Limb"];
        
        }
        
        
    }
    if([elementName isEqualToString:@"DriverRestriction2"])
    {
                
        if([currentNodeContent isEqualToString:@"1"])
        {
            currentNodeContent = [NSMutableString stringWithFormat:@"%@", @"Glasses / Contact lenses"];
            
            if([tempDriverRestrictionStr isEqualToString:@"Artificial Limb"])
                 self.custDetailsObj.custRestriction = [NSString stringWithFormat:@"%@, %@",tempDriverRestrictionStr, currentNodeContent];
            else
                   self.custDetailsObj.custRestriction = currentNodeContent;
            
        }
        else if([currentNodeContent isEqualToString:@"2"])
        {
            currentNodeContent = [NSMutableString stringWithFormat:@"%@", @"Artificial Limb"];

            
            if([tempDriverRestrictionStr isEqualToString:@"Glasses / Contact lenses"])
            {
                if(currentNodeContent)
                self.custDetailsObj.custRestriction = [NSString stringWithFormat:@"%@, %@",tempDriverRestrictionStr, currentNodeContent];
            }
            
            else
                self.custDetailsObj.custRestriction = [NSString stringWithFormat:@"%@", currentNodeContent];

            
        }
        else if([currentNodeContent isEqualToString:@"0"])
        {
            currentNodeContent = [NSMutableString stringWithFormat:@"%@", @"None"];
            
            self.custDetailsObj.custRestriction = tempDriverRestrictionStr;
            
        }

        
    }
    if([elementName isEqualToString:@"DateOfBirth"])
    {
         NSLog(@"DateOfBirthhhh = %@",currentNodeContent);
        self.custDetailsObj.custDOB = currentNodeContent;
    }
    if([elementName isEqualToString:@"Gender"])
    {
        NSLog(@"Genderrrr = %@",currentNodeContent);
        self.custDetailsObj.custGender = currentNodeContent;
    }
    
    if([elementName isEqualToString:@"CertificateNumber"])
    {
        if([currentNodeContent length] == 0)
        {
            self.custDetailsObj.custCertificateNo = @"Cert?";
        }
        else
        {
            self.custDetailsObj.custCertificateNo = currentNodeContent;
        }
    }
    if([elementName isEqualToString:@"Code"])
    {
        
        
          if([currentNodeContent isEqualToString:@"A"])
              self.vehicleClassObj.vehicleClassName = @"A | Motorcycle";
          else if ([currentNodeContent isEqualToString:@"A1"])
              self.vehicleClassObj.vehicleClassName =  @"A1 | Motorcycle";
          else if ([currentNodeContent isEqualToString:@"EB"])
              self.vehicleClassObj.vehicleClassName =  @"EB | Vehicle & Trailer";
          else if ([currentNodeContent isEqualToString:@"B"])
              self.vehicleClassObj.vehicleClassName =  @"B | Vehicle & Trailer";
          else if ([currentNodeContent isEqualToString:@"C"])
              self.vehicleClassObj.vehicleClassName =  @"C | Bus/ Truck";
          else if ([currentNodeContent isEqualToString:@"C1"])
              self.vehicleClassObj.vehicleClassName =  @"C1 | Minibus/ Truck";
          else if ([currentNodeContent isEqualToString:@"EC"])
              self.vehicleClassObj.vehicleClassName =  @"EC | Truck & Trailer";
          else if ([currentNodeContent isEqualToString:@"EC1"])
              self.vehicleClassObj.vehicleClassName =  @"EC1 | Truck & Trailer";

        
    }
    if([elementName isEqualToString:@"FirstIssueDate"])
    {
        
        self.vehicleClassObj.vehicleClassIssuedDate = currentNodeContent;

    }
    if([elementName isEqualToString:@"VehicleRestriction"])
    {
        
         if([currentNodeContent isEqualToString:@"0"])
             self.vehicleClassObj.vehicleClassRestrictions = @"None";
        else if([currentNodeContent isEqualToString:@"1"])
            self.vehicleClassObj.vehicleClassRestrictions = @"Automatic transmission";
        else if([currentNodeContent isEqualToString:@"2"])
            self.vehicleClassObj.vehicleClassRestrictions = @"Electrically powered";
        else if([currentNodeContent isEqualToString:@"3"])
            self.vehicleClassObj.vehicleClassRestrictions = @"Physically disabled";
        else if([currentNodeContent isEqualToString:@"4"])
            self.vehicleClassObj.vehicleClassRestrictions = @"Bus > 16000 Kg(GVM) permitted";
        
        //self.vehicleClassObj.vehicleClassRestrictions = @"Electrically powered";
        
    }
    
    if([elementName isEqualToString:@"VehicleClass1"])
    {
        [arrayOfVehicleClass addObject:self.vehicleClassObj];
        isIndividualVehicleClassDone = YES;
    }
    if([elementName isEqualToString:@"VehicleClass2"])
    {
        if(!isIndividualVehicleClassDone)
        {
            if(self.vehicleClassObj.vehicleClassRestrictions.length > 0)
            {
                [arrayOfVehicleClass addObject:self.vehicleClassObj];
                isIndividualVehicleClassDone = YES;
            }
        }
    }
    if([elementName isEqualToString:@"VehicleClass3"])
    {
        if(!isIndividualVehicleClassDone)
        {
            if(self.vehicleClassObj.vehicleClassRestrictions.length > 0)
            {
                [arrayOfVehicleClass addObject:self.vehicleClassObj];
                isIndividualVehicleClassDone = YES;
            }
        }
    }
    if([elementName isEqualToString:@"VehicleClass4"])
    {
        if(!isIndividualVehicleClassDone)
        {
            if(self.vehicleClassObj.vehicleClassRestrictions.length > 0)
            {
                [arrayOfVehicleClass addObject:self.vehicleClassObj];
                isIndividualVehicleClassDone = YES;
            }
        }
    }
    
    
    if([elementName isEqualToString:@"Photo"])
    {
        self.custDetailsObj.custPhoto = currentNodeContent;
    }
   
    if([elementName isEqualToString:@"SavedScanID"])
    {
        ScanID = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"Status"])
    {
        if([currentNodeContent isEqualToString:@"Success"])
        {
           // SMAppDelegate *appDelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
           // [appDelegate.refrshObj refreshMethodCall];

            
            NSString *message;
            
            if(self.isFromDLListScreen)
                message = @"License information updated";
            else
                message = @"License information saved";
 
            
            
            UIBAlertView *alert;
            alert = [[UIBAlertView alloc] initWithTitle:@"Smart Manager" message:message cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 
                 if (didCancel)
                 {
                     [self pushBackToViewController];
                     
                 }
             }];
        
        }
    }
    
    
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"Vehicle Array count = %lu",(unsigned long)arrayOfVehicleClass.count);
    
    self.custDetailsObj.custClasses = custClasses;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

    {
        self.lblCustomerID.text = [NSString stringWithFormat:@"%@", self.custDetailsObj.customerID];
    
        self.lblCustomerName.text = self.custDetailsObj.customerName;
        UIImage *custImage = [self decodeBase64ToImage:self.custDetailsObj.custPhoto];
        self.imgCustomer.image = custImage;
    
        self.lblDOBValue.text = self.custDetailsObj.custDOB;
        self.lblGenderValue.text = self.custDetailsObj.custGender;
        self.lblAgeValue.text = [self returnTheAgeFromDOB:self.custDetailsObj.custDOB];
        self.lblRestrictionsValue.text = self.custDetailsObj.custRestriction;
        [self.lblRestrictionsValue sizeToFit];

        self.lblCertificateValue.text = self.custDetailsObj.custCertificateNo;
  
    
   if([self.custDetailsObj.custRestriction rangeOfString:@","].location!=NSNotFound)
   {
       NSLog(@"Entered...");
       
       self.viewContainingCertificate.frame = CGRectMake(self.viewContainingCertificate.frame.origin.x, self.lblRestrictionsValue.frame.origin.y + self.lblRestrictionsValue.frame.size.height, self.viewContainingCertificate.frame.size.width, self.viewContainingCertificate.frame.size.height);

      

       [self.tableForCustomerInformations setTableHeaderView:self.viewHeaderInformations];


   }
  }
 else
 {
     
     self.lblCustomerID_iPad.text = [NSString stringWithFormat:@"%@", self.custDetailsObj.customerID];
     
     self.lblCustomerName_iPad.text = self.custDetailsObj.customerName;
     UIImage *custImage = [self decodeBase64ToImage:self.custDetailsObj.custPhoto];
     self.imgCustomer_iPad.image = custImage;
     
     self.lblDOBValue_iPad.text = self.custDetailsObj.custDOB;
     self.lblGenderValue_iPad.text = self.custDetailsObj.custGender;
     self.lblAgeValue_iPad.text = [self returnTheAgeFromDOB:self.custDetailsObj.custDOB];
     self.lblRestrictionsValue_iPad.text = self.custDetailsObj.custRestriction;
     [self.lblRestrictionsValue_iPad sizeToFit];
     
     self.lblCertificateValue_iPad.text = self.custDetailsObj.custCertificateNo;
     
     
     if([self.custDetailsObj.custRestriction rangeOfString:@","].location!=NSNotFound)
     {
         NSLog(@"Entered...");
         
         self.viewContainingCertificate_iPad.frame = CGRectMake(self.viewContainingCertificate_iPad.frame.origin.x, self.lblRestrictionsValue_iPad.frame.origin.y + self.lblRestrictionsValue_iPad.frame.size.height, self.viewContainingCertificate_iPad.frame.size.width, self.viewContainingCertificate_iPad.frame.size.height);
         
         [self.tableForCustomerInformations setTableHeaderView:self.viewHeaderInformations_iPad];

     }


 }
    
    [self.tableForCustomerInformations reloadData];
    
    [self hideProgressHUD];
}

#pragma mark - ProgressBar Method

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
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
        });
    });
}


-(NSString*)returnTheAgeFromDOB:(NSString*)DOBString
{
    if(DOBString.length != 0)
    {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/mm/yyyy"];
    NSDate *dateReceived = [dateFormatter dateFromString:DOBString];

       NSDateComponents *diff = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:dateReceived toDate:[NSDate date] options:0];
    
    return [NSString stringWithFormat:@"%ld",(long)diff.year];
    }
    else return @"Age?";
    

}

- (void)setTheTitle
{
    
    UILabel *listActiveSpecialsNavigTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        listActiveSpecialsNavigTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0f];//SavingsBond
    }
    else
    {
        listActiveSpecialsNavigTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];//SavingsBond
    }
    listActiveSpecialsNavigTitle.backgroundColor = [UIColor clearColor];
    listActiveSpecialsNavigTitle.textColor = [UIColor whiteColor]; // change this color
    listActiveSpecialsNavigTitle.text = @"Scan Info";
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
    
    
    // Register the cell
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tableForCustomerInformations registerNib:[UINib nibWithNibName:@"SMDLVehicleClassCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMDLVehicleClassCell"];
        
        
    }
    else
    {
        [self.tableForCustomerInformations registerNib:[UINib nibWithNibName:@"SMDLVehicleClassCell_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMDLVehicleClassCell"];

    
    }
    
    
}


@end
