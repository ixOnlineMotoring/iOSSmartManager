//
//  SMVINScanLookupDetailsViewController.m
//  SmartManager
//
//  Created by Priya on 17/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMVINScanLookupDetailsViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMLoadVehicleTableViewCell.h"
#import "SMAddToStockViewController.h"
#import "SMVinStockObject.h"
#import "UIBAlertView.h"
#import "SMCustomColor.h"
@interface SMVINScanLookupDetailsViewController ()
{
    BOOL isVariantWebserviceCalledinBackground;
}

@end

@implementation SMVINScanLookupDetailsViewController
@synthesize vehicleListDelegates,isFromSaveListing;



#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addingProgressHUD];
    backGroundQueue = dispatch_queue_create("FetchingCurrentLocationInTheBackground", NULL);
    
   // [self setTheDirections];
    
    UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationItem.backBarButtonItem = _backButton;
    isVariantWebserviceCalledinBackground = NO;
    
    /*UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-7.0f];
    UIButton *buttonMenu = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 21)];
    [buttonMenu setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [buttonMenu addTarget:self action:@selector(pushBackToListingView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnMenu =  [[UIBarButtonItem alloc]initWithCustomView:buttonMenu];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer,btnMenu];*/
    // self.navigationItem.leftBarButtonItem = btnMenu;
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    [self registerNib];
    [self fetchVINScanDetails];
    [self setCustomFonts];
    
    yearArray=[[NSMutableArray alloc]init];
    existingVehicleTableView.tableFooterView=self.footerView;
    if(![self.VINLookupObject.strVariantName isKindOfClass:[NSNull class]] )
    {
        isVariantWebserviceCalledinBackground = YES;
        [self fetchVarientsForSelectedModel:self.VINLookupObject.strYear];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [self hideProgressHUD];
    [popupView removeFromSuperview];
    
}
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - custom font

-(void)setCustomFonts
{
    loadVehicleTableView.layer.cornerRadius=15.0;
    loadVehicleTableView.clipsToBounds      = YES;
    loadVehicleTableView.layer.borderWidth=1.5;
    loadVehicleTableView.layer.borderColor=[[UIColor blackColor] CGColor];
    
    pickerView.layer.cornerRadius=15.0;
    pickerView.clipsToBounds      = YES;
    pickerView.layer.borderWidth=1.5;
    pickerView.layer.borderColor=[[UIColor blackColor] CGColor];
    
    self.navigationItem.titleView = lblTitle;

    updateButton.layer.cornerRadius = 5.0f;
    [scrollView setContentSize:(CGSizeMake(320, contentView.frame.size.height-50))];
    
   
    validateButtons.layer.cornerRadius = 5.0f;
    self.discardButton.layer.cornerRadius = 5.0f;
    
    self.txtVariants.rightView= downArrowButton1;
    [self.txtStartYear  setRightViewMode:UITextFieldViewModeAlways];
    self.txtStartYear.rightView=downArrowButton2;
    [self.txtEndYear  setRightViewMode:UITextFieldViewModeAlways];
    self.txtEndYear.rightView=downArrowButton4;
    [self.txtStockNo  setRightViewMode:UITextFieldViewModeAlways];
    self.txtStockNo.rightView=downArrowButton5;
}

-(void)pushBackToListingView
{
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Getting Current Location


-(void)setTheDirections
{
    if(locationManager==nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.distanceFilter = 10;
    }
    
    
    locationManager.delegate = self;
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
    {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        
        
        // If the status is denied or only granted for when in use, display an alert
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied )
        {
            NSString *title;
            title = (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusNotDetermined) ? @"Location services are off" : @"Background location is not enabled";
            NSString *message = @"You can enable access in Settings->Privacy->Location->Location Services";
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        // The user has not enabled any location services. Request background authorization.
        else if (status == kCLAuthorizationStatusNotDetermined)
        {
            [locationManager requestWhenInUseAuthorization];
        }
    }
    
    
    [locationManager startUpdatingLocation];
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
    _currentUserCoordinate = [newLocation coordinate];
    
    
    [SMGlobalClass sharedInstance].googleLatitude =  _currentUserCoordinate.latitude;
    [SMGlobalClass sharedInstance].googleLongitude = _currentUserCoordinate.longitude;
    
    dispatch_async(backGroundQueue, ^{
        
        NSData *datAddress=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=AIzaSyBIdVyndCKPLHyYHXxEq9lRR-zwtF9_JS0", _currentUserCoordinate.latitude, _currentUserCoordinate.longitude]]];
        
        // NSLog(@"datAddress=%@",[[NSString alloc]initWithData:datAddress encoding:NSUTF8StringEncoding]);
        
        NSDictionary *dictAddress;
        
        if([datAddress length] > 0)
        {
            dictAddress=[NSJSONSerialization JSONObjectWithData:datAddress options:NSJSONReadingMutableContainers error:NULL];
        }
        
        NSLog(@"formatted_address results %@",[[dictAddress objectForKey:@"results"]valueForKey:@"formatted_address"][0]);
        
        
        strGeoLocation = [[dictAddress objectForKey:@"results"]valueForKey:@"formatted_address"][0];
    }) ;
    
    
}



-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location services disabled." message:@"Please enable the location services on your device." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

#pragma mark - IBAction
-(IBAction)btnCancelDidClicked:(id)sender
{
    
    [self dismissPopup];
    UIButton *btn=(UIButton*)sender;
    if (btn.tag==2)
    {
        
        [self.txtStartYear setText:strPickerValue];
        self.txtVariants.text=@"";
    }
    
}
-(IBAction)btnDiscardDidClicked:(id)sender
{
    

    if ([self.discardButton.titleLabel.text isEqualToString:@"Update"])
    {
        
        if (self.txtModel.text.length==0 )
        {
            SMAlert(KLoaderTitle,KModelSelection);
        }
        else if (self.txtStartYear.text.length==0 )
        {
            SMAlert(KLoaderTitle,KyearSelection);
        }
        else if (self.txtVariants.text.length==0)
        {
            SMAlert(KLoaderTitle,KVariantSelection);
        }
        else if(self.txtStockNo.text.length == 0)
        {
            SMAlert(KLoaderTitle,kStockNumberSelection);
        }
        else
        {
          
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle  message:KvehicleInStcokNeedUpdate cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes",nil];
            
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 
                 switch (selectedIndex)
                 {
                     case 1:
                         [self moveToUpdateScreen];
                         break;
                     default:
                         break;
                 }
             }];
            
        }
    }
    else
    {
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:KWantToDiscard cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                    
                        switch (selectedIndex)
                        {
                            case 1:
                            {
                                if(isFromSaveListing)
                                    [self discardingVINScan];
                                else
                                    [self discardVINIfNotSaved];

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


-(void) discardVINIfNotSaved
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)btnSaveForLaterDidClicked:(id)sender
{
    
    if (self.txtStartYear.text.length==0 )
    {
        [self showAlert:KyearSelection];
    }
    else if (self.txtModel.text.length==0 )
    {
        [self showAlert:KModelSelection];
    }
    else if (self.txtVariants.text.length==0)
    {
        [self showAlert:KVariantSelection];
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


-(void) saveForLaterScan
{

    [HUD show:YES];

    
   /* NSMutableURLRequest *requestURL=[SMWebServices SavedVinScanForLater:[SMGlobalClass sharedInstance].hashValue clientID:[SMGlobalClass sharedInstance].strClientID.intValue vin:self.VINLookupObject.VIN registration:self.VINLookupObject.Registration shape:self.VINLookupObject.Shape makeId:self.VINLookupObject.Make modelId:self.VINLookupObject.Model colour:self.VINLookupObject.Colour engineNo:self.VINLookupObject.EngineNo kilometers:@"" extrasCost:@"" condition:@""];*/
    //NSLog(@"SELECTED make = %@",self.VINLookupObject.Make);
   // NSLog(@"SELECTED variant = %@",self.VINLookupObject.Model);
    
     NSMutableURLRequest *requestURL=[SMWebServices SavedVinScanForLater:[SMGlobalClass sharedInstance].hashValue clientID:[SMGlobalClass sharedInstance].strClientID.intValue vin:self.VINLookupObject.VIN registration:self.VINLookupObject.Registration shape:self.VINLookupObject.Shape year:self.txtStartYear.text makeId:self.VINLookupObject.Make modelId:self.VINLookupObject.Model variant:strSelectedVariantName colour:self.VINLookupObject.Colour engineNo:self.VINLookupObject.EngineNo kilometers:@"" extrasCost:@"" condition:@"" licExpiry:@"" variantid:[NSString stringWithFormat:@"%d",selectedVariantId]];
    
    
    
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


-(IBAction)btnAddToStocklDidClicked:(id)sender
{
    
    if (self.txtStartYear.text.length==0 )
    {
        [self showAlert:KyearSelection];
    }
    else if (self.txtModel.text.length==0 )
    {
        [self showAlert:KModelSelection];
    }
    else if (self.txtVariants.text.length==0)
    {
        [self showAlert:KVariantSelection];
    }
    else
    {
        SMAddToStockViewController *addToStockView;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            addToStockView=[[SMAddToStockViewController alloc]initWithNibName:@"SMAddToStockViewController" bundle:nil];
        }
        else
        {
            
            addToStockView=[[SMAddToStockViewController alloc]initWithNibName:@"SMAddToStockViewController_iPad" bundle:nil];
        
        }
        
        
        
        addToStockView.isUpdateVehicleInformation = NO;
        
        addToStockView.isFromAddToStockPage = YES;
        
        addToStockView.VINLookupObject = self.VINLookupObject;
        addToStockView.strStockNumber  = self.txtStockNo.text;
        addToStockView.strMeanCode     = selectedVarientMeanCode;
        addToStockView.strVariantId    = selectedVariantId;
        addToStockView.strUsedYear     = self.txtStartYear.text;
        addToStockView.strProgramName  =[NSString stringWithFormat:@"%@ %@ %@",self.txtStartYear.text ,self.txtMake.text, self.txtVariants.text];
        addToStockView.strSelctedVarinatName =[NSString stringWithFormat:@"%@ %@ %@",self.txtStartYear.text ,self.txtMake.text, self.txtVariants.text];
        
        
        dispatch_async(dispatch_get_main_queue(),^
        {
            [SMGlobalClass sharedInstance].isListModule = NO;
            addToStockView.isFromVinLookUpEditPage = NO;
            [self.navigationController pushViewController:addToStockView animated:YES];
        });
    }
}
-(IBAction)btnStolenCheckDidClicked:(id)sender
{
    stolenCheckButton.selected=!stolenCheckButton.selected;
}
-(IBAction)btnHasAccidentCheckDidClicked:(id)sender
{
    accidentCheckButton.selected=!accidentCheckButton.selected;
    
}
#pragma mark - Validate VIN Scan
-(IBAction)btnValidateDidClicked:(id)sender
{
    if (!stolenCheckButton.selected)
    {
        
        [[[UIAlertView alloc]initWithTitle:KLoaderTitle 
                                   message:@"Please Select Stolen/Financed Checkbox"
                                  delegate:self cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil, nil]
         show];
    }
    else if (!accidentCheckButton.selected)
    {
        [[[UIAlertView alloc]initWithTitle:KLoaderTitle 
                                   message:@"Please Select Has Accidents Checkbox"
                                  delegate:self cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil, nil]
         show];
    }
    else
    {
        
        
        NSMutableURLRequest *requestURL=[SMWebServices ValidateVINForVehicles:[SMGlobalClass sharedInstance].hashValue vin:self.VINLookupObject.VIN ];
        
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
                 
                 VINDetailArray = [[NSMutableArray alloc] init];
                 xmlParser = [[NSXMLParser alloc] initWithData: data];
                 [xmlParser setDelegate: self];
                 [xmlParser setShouldResolveExternalEntities:YES];
                 [xmlParser parse];
             }
         }];
    }
}


#pragma mark - UITableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==loadVehicleTableView)
    {
        
        
        if(selectedType == 2)
        {
        
           /* int heightNeedToAdd;

            heightNeedToAdd = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 70: 90;
            float totalFrameOfView = heightNeedToAdd+([variantArray count]*43);
            {
                //Make View Size smaller, no scrolling
                loadVehicleTableView.frame = CGRectMake(loadVehicleTableView.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, loadVehicleTableView.frame.size.width, 300.0);
            }*/
           
            
            return variantArray.count;
        }
               
        //for dynamic height
        
        /*float maxHeigthOfView = [self view].frame.size.height/2+50.0;
        int heightNeedToAdd;
        
        
        heightNeedToAdd = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 45 : 80;
        float totalFrameOfView = heightNeedToAdd+([VINDetailArray count]*43);
        if (totalFrameOfView <= maxHeigthOfView)
        {
            //Make View Size smaller, no scrolling
            loadVehicleTableView.frame = CGRectMake(loadVehicleTableView.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, loadVehicleTableView.frame.size.width, totalFrameOfView);
        }
        else
        {
            loadVehicleTableView.frame = CGRectMake(loadVehicleTableView.frame.origin.x, maxHeigthOfView/2-22.0, loadVehicleTableView.frame.size.width, maxHeigthOfView);
        }*/
        
        return VINDetailArray.count;
    }
    
    else
        
        return listArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==loadVehicleTableView)
    {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 45 : 65;
    }
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==loadVehicleTableView)
    {
        return cancelButton;
        
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        return selectedType == 2 ? 70 :45;
    }
    else
    {
        return selectedType == 2 ? 90 :60;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (tableView==loadVehicleTableView)
    {
        static NSString *CellIdentifier =@"SMLoadVehicleTableViewCell";
       
            
        static NSString *CellIdentifierVariantListing =@"VariantListing";

        SMLoadVehicleTableViewCell *cell;
        switch (selectedType)
        {
            case 1:
            {
                
               cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

                SMVINScanModelObject *objectVehicleListingInCell = (SMVINScanModelObject *) [VINDetailArray objectAtIndex:indexPath.row];
                [cell.lblMakeName      setText:objectVehicleListingInCell.strModelName];
            }
                break;
            case 2:
            {

                cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifierVariantListing];

                SMVINScanDetailsObject *objectVehicleListingInCell = (SMVINScanDetailsObject *) [variantArray objectAtIndex:indexPath.row];
                [cell.lableVariantName      setText:objectVehicleListingInCell.strVariantsFriendly];

                
                
                if ([objectVehicleListingInCell.strVariantsMaxYear isEqualToString:@""])
                {
                    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
                    NSInteger year = [components year];
                    objectVehicleListingInCell.strVariantsMaxYear = [NSString stringWithFormat:@"%ld",(long)year];
                }
                
                [cell.lableVarinatCodeWithyear setText:[NSString stringWithFormat:@"%@ (%@ to %@)",objectVehicleListingInCell.strVariantsCode,objectVehicleListingInCell.strVariantsMinYear,objectVehicleListingInCell.strVariantsMaxYear]];
            }
                break;
            case 3:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

                SMVinStockObject *objectVehicleListingInCell = (SMVinStockObject *) [VINDetailArray objectAtIndex:indexPath.row];
                [cell.lblMakeName      setText:objectVehicleListingInCell.strCode];
            }
                break;
            default:
                break;
        }
        return cell;
    }
    
    static NSString *CellIdentifier = @"SMExistingVehicleTableViewCell";
    SMExistingVehicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.lblDescription.hidden=NO;
    cell.txtDescription.hidden=YES;
    
    if (indexPath.row==2 || indexPath.row==3 || indexPath.row==4 )
    {
        cell.txtDescription.text=[detailArray objectAtIndex:indexPath.row];
        cell.txtDescription.hidden=NO;
        cell.lblDescription.hidden=YES;
        
    }
    else
    {
        cell.lblDescription.text=[detailArray objectAtIndex:indexPath.row];
        cell.lblDescription.hidden=NO;
        
    }
    if (indexPath.row==1)
    {
        if (strHasModel==0)
        {
            cell.txtDescription.text=[detailArray objectAtIndex:indexPath.row];
            cell.txtDescription.hidden=NO;
            cell.lblDescription.hidden=YES;
        }
        else
        {
            cell.lblDescription.text=[detailArray objectAtIndex:indexPath.row];
            cell.lblDescription.hidden=NO;
        }
    }
    cell.lblTitle.text=[listArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (selectedType)
    
    {
        case 1:
        {
            SMVINScanModelObject *objectVehicleListingInCell = (SMVINScanModelObject *)[VINDetailArray objectAtIndex:indexPath.row];
            
            
            [self.txtModel setText:objectVehicleListingInCell.strModelName];
          
            selectedModelId = objectVehicleListingInCell.strModelId.intValue;
            self.VINLookupObject.Model = objectVehicleListingInCell.strModelName;
            [self dismissPopup];
            
            MaxYear=[objectVehicleListingInCell.strModelMaxYear intValue];
            MinYear=[objectVehicleListingInCell.strModelMinYear intValue];
            
            // if max is 1900 i.e NULL
            if (MaxYear == 1900)
            {
                //Get Current Year into Current Year
                NSDateFormatter *formatter       = [[NSDateFormatter alloc] init];
                [formatter         setDateFormat:@"yyyy"];
                MaxYear     = [[formatter stringFromDate:[NSDate date]] intValue];
            }
            
            yearArray=[[NSMutableArray alloc]init];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
            NSInteger year = [components year];
            
            for (int i=MaxYear; i>=MinYear; i--)
            {

                /// temp added by jignesh neeto to remove
                if (i<= year)
                {
                    NSLog(@"this1**");
                    [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
                }
            }
            
            [yearPickerView reloadAllComponents];
            
            // once selcted new model clear all years
            
            [self.txtStartYear setText:@""];
            [self.txtVariants  setText:@""];
            
        }
            break;
        case 2:
        {
            SMVINScanDetailsObject *objectVehicleListingInCell = (SMVINScanDetailsObject *)[variantArray objectAtIndex:indexPath.row];
            
            [self.txtVariants setText:objectVehicleListingInCell.strVariantsFriendly];
            
            
            selectedVariantId = objectVehicleListingInCell.strVariantsId.intValue;
            selectedVarientMeanCode=objectVehicleListingInCell.strVariantsCode;
            strSelectedVariantName = objectVehicleListingInCell.strVariantsName;
            [self dismissPopup];
        }
            break;
        case 3:
        {
            
            
            SMVinStockObject *objectVehicleListingInCell = (SMVinStockObject *)[VINDetailArray objectAtIndex:indexPath.row];
            [self.txtStockNo setText:objectVehicleListingInCell.strCode];
            selectedStockIdId      =objectVehicleListingInCell.strId.intValue;
            strSelectedStockNumber = objectVehicleListingInCell.strCode;
            [self dismissPopup];
        }
            break;
        default:
            break;
    }
}

#pragma mark - fetch varient for selected model
-(void)fetchVarientsForSelectedModel:(NSString*)startYear
{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllVarintsvaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:startYear modelId:selectedModelId];
    
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

#pragma mark - textfield delegate


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.txtStockNo)
    {
    
        if (self.txtStartYear.text.length == 0) {
            
            [self showAlert:KyearSelection];
        }
        else if (self.txtModel.text.length == 0)
        {
            [self showAlert:KModelSelection];
        }
        else if (self.txtVariants.text.length == 0)
        {
            [self showAlert:KVariantSelection];
        }
        else
        {
            selectedType=3;
            [loadVehicleTableView setHidden:NO];
            [self.view endEditing:YES];

            if (stockArray==0)
            {
                [self showAlert:KNoStockAvailable];
            }
            else
            {
                VINDetailArray=[[NSMutableArray alloc]init];
                VINDetailArray=[stockArray mutableCopy];
                [loadVehicleTableView reloadData];
                [self loadPopup];
            }
            
        }
        
        return NO;

    }
    else if (textField==self.txtStartYear)
    {
        isStartYear=YES;
        [pickerView         setHidden:NO];
        [self.txtMake       resignFirstResponder];
        [self.txtStartYear  resignFirstResponder];
        [loadVehicleTableView setHidden:YES];
        
        if (strHasModel==1)
        {
            if (self.txtStartYear.text.length!=0)
            {
                [pickerView setHidden:NO];
                strPickerValue=self.txtStartYear.text;
                
                [self.view endEditing:YES];
                NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
                SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
                
                [popUpView getTheDropDownData:[SMAttributeStringFormatObject getDropDownArray:yearArray] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
                
                [self.view addSubview:popUpView];
                
                [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                    NSLog(@"selected text = %@",selectedTextValue);
                    NSLog(@"selected ID = %d",selectIDValue);
                    textField.text = selectedTextValue;
                    strPickerValue = selectedTextValue;
                    //selectedMakeId = selectIDValue;
                }];
                
               /* for (int i=0; i<yearArray.count; i++)
                {
                    NSString *str=[yearArray objectAtIndex:i];
                    
                    if ([str isEqualToString:strPickerValue])
                    {
                        [yearPickerView reloadAllComponents];
                        [yearPickerView selectRow:i inComponent:0 animated:YES];
                    }
                }*/
            }
            else
            {
                [self.view endEditing:YES];
                NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
                SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
                
                [popUpView getTheDropDownData:[SMAttributeStringFormatObject getDropDownArray:yearArray] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
                
                [self.view addSubview:popUpView];
                
                [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                    NSLog(@"selected text = %@",selectedTextValue);
                    NSLog(@"selected ID = %d",selectIDValue);
                    textField.text = selectedTextValue;
                    strPickerValue = selectedTextValue;
                    //selectedMakeId = selectIDValue;
                }];
            
            }
            //[yearPickerView reloadAllComponents];
            
            //[self loadPopup];
        }
        else
        {
            [self.view endEditing:YES];
          
            if (self.txtModel.text.length==0 )
            {
                [self showAlert:KModelSelection];
            }
            else
            {
                if (self.txtStartYear.text.length!=0)
                {
                    [pickerView setHidden:NO];
                    strPickerValue=self.txtStartYear.text;
                    
                   /* for (int i=0; i<yearArray.count; i++)
                    {
                        NSString *str=[yearArray objectAtIndex:i];
                        if ([str isEqualToString:strPickerValue])
                      {
                        [yearPickerView selectRow:i inComponent:0 animated:YES];
                      }
                    }*/
                   /* [self.view endEditing:YES];
                    NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
                    SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
                    
                    [popUpView getTheDropDownData:[SMAttributeStringFormatObject getDropDownArray:yearArray] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
                    
                    [self.view addSubview:popUpView];
                    
                    [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                        NSLog(@"selected text = %@",selectedTextValue);
                        NSLog(@"selected ID = %d",selectIDValue);
                        textField.text = selectedTextValue;
                        strPickerValue = selectedTextValue;
                        //selectedMakeId = selectIDValue;
                    }];*/
                    
                }
                if (yearArray.count == 0)
                {
                    [self.txtStartYear setText:@""];
                    [self.txtVariants setText:@""];
                    [self showAlert:KNoYearsLoadedForSelectedModel];
                }
                else
                {
                    
                    [self.view endEditing:YES];
                    NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
                    SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
                    
                    [popUpView getTheDropDownData:[SMAttributeStringFormatObject getDropDownArray:yearArray] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
                    
                    [self.view addSubview:popUpView];
                    
                    [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                        NSLog(@"selected text = %@",selectedTextValue);
                        NSLog(@"selected ID = %d",selectIDValue);
                        textField.text = selectedTextValue;
                        strPickerValue = selectedTextValue;
                        //selectedMakeId = selectIDValue;
                    }];
                    
                    
                    /*[yearPickerView reloadAllComponents];
                    [self loadPopup];*/
                }
            }
        }
        
        return NO;
    }
    else if (textField==self.txtVariants)
    {
        isModelText=NO;
        selectedType=2;
        [self.txtMake       resignFirstResponder];
        [self.txtVariants  resignFirstResponder];
        if (strHasModel==0)
        {
            if (self.txtModel.text.length==0 )
            {
                [self showAlert:KModelSelection];
            }
            else if (self.txtStartYear.text.length==0 )
            {
                [self showAlert:KyearSelection];
            }
            else
            {
                isVariantWebserviceCalledinBackground = NO;
                [self fetchVarientsForSelectedModel:self.txtStartYear.text];
            }
        }
        else
        {
            if (self.txtStartYear.text.length==0 )
            {
                [self showAlert:KyearSelection];
            }
            else
            {
                isVariantWebserviceCalledinBackground = NO;
                [self fetchVarientsForSelectedModel:self.txtStartYear.text];
                
            }
        }
        [self.view endEditing:YES];
        
        return NO;
    }
    else
        return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==self.txtColour || textField==self.txtRegNo || textField==self.txtEngineNo || textField==self.txtVINNo || textField==self.txtExpires)
    {
        CGRect frame = [scrollView convertRect:textField.frame fromView:textField.superview];

        
        if ([[UIScreen mainScreen] bounds].size.height == 480)
        {
            [scrollView setContentOffset:CGPointMake(0, frame.origin.y-120) animated:YES];
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            [scrollView setContentOffset:CGPointMake(0, frame.origin.y-200) animated:YES];
        }
        else
        {
            [scrollView setContentOffset:CGPointMake(0, frame.origin.y-300) animated:YES];
        }
    }
    [pickerView setHidden:YES];
    [loadVehicleTableView setHidden:YES];
    
    if (textField==self.txtModel)
    {
        isModelText=YES;
        selectedType=1;
        [loadVehicleTableView setHidden:NO];
        
        if (strHasModel==0) // it will excute in pop up show for model
        {
            [self.txtModel resignFirstResponder];
            
            VINDetailArray  =[[NSMutableArray alloc]init];
            VINDetailArray  =[modelArray mutableCopy];
            [loadVehicleTableView reloadData];
            [self loadPopup];
        }
    }
    
}

#pragma mark- filter variant list
-(void)filterVariantList
{
   
    
    VINDetailArray=[[NSMutableArray alloc]init];
    
    for (int i=0;i<variantArray.count; i++)
    {
        SMVINScanDetailsObject * VINScanDetailsObjects;
        VINScanDetailsObjects =[SMVINScanDetailsObject new];
        VINScanDetailsObjects=[variantArray objectAtIndex:i];
        if (MinYear <=[self.txtStartYear.text intValue] && MaxYear>=[self.txtStartYear.text intValue])
        {
            
            [VINDetailArray addObject:VINScanDetailsObjects];
        }
        
    }
    
    
    if (VINDetailArray.count!=0)
    {
        [loadVehicleTableView setHidden:NO];
        [pickerView setHidden:YES];
        
        [self loadPopup];
        [loadVehicleTableView reloadData];
        
    }
    else
    {
        [self showAlert:KVariantsNotFound];
    }
}

#pragma mark- load popup
-(void)loadPopup
{
    
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (vc != self)
        return;
    [popupView setFrame:[UIScreen mainScreen].bounds];
    [popupView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [popupView setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popupView];
    [popupView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [popupView setAlpha:0.75];
         [popupView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [popupView setAlpha:1.0];
              [popupView setTransform:CGAffineTransformIdentity];
          }
          completion:^(BOOL finished)
          {
          }];
         
     }];
}

#pragma mark - dismiss popup
-(void)dismissPopup
{
    [popupView setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popupView];
    [UIView animateWithDuration:0.1 animations:^{
        [popupView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [popupView setAlpha:0.3];
              [popupView setTransform:CGAffineTransformMakeScale(0.9    ,0.9)];
              
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   [popupView setAlpha:0.0];
               }
                completion:^(BOOL finished)
               {
                   [popupView removeFromSuperview];
                   [popupView setTransform:CGAffineTransformIdentity];
               }];
          }];
     }];
    
}

#pragma mark - picker datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;// or the number of vertical "columns" the picker will show...
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (yearArray!=nil)
    {
        return [yearArray count];//this will tell the picker how many rows it has - in this case, the size of your loaded array...
    }
    return 0;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* lbl = (UILabel*)view;
    // Customise Font
    if (lbl == nil)
    {
        //label size
        CGRect frame = CGRectMake(0.0, 0.0, 70, 30);
        
        lbl = [[UILabel alloc] initWithFrame:frame];
        
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor blackColor]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        //here you can play with fonts
        [lbl setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0]];
        
    }
    //picker view array is the datasource
    [lbl setText:[yearArray objectAtIndex:row]];
    
    
    return lbl;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //you can also write code here to descide what data to return depending on the component ("column")
    if (yearArray!=nil)
    {
        
        return [yearArray objectAtIndex:row];
        //assuming the array contains strings..
    }
    return @"";//or nil, depending how protective you are
}

#pragma mark - picker delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    strPickerValue=[yearArray objectAtIndex:row];
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

#pragma mark - xml parser delegate
-(void) parser:(NSXMLParser *)  parser
didStartElement:(NSString *)    elementName
  namespaceURI:(NSString *)     namespaceURI
 qualifiedName:(NSString *)     qName
    attributes:(NSDictionary *)    attributeDict
{
    VINScanDetailsObject=[[SMVINScanDetailsObject alloc]init];
    currentNodeContent = [NSMutableString stringWithString:@""];
    loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
    
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
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
            but there are some that don't match, so we have to pass hasModel=false and the list of models
        
        */
        
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
                    
                    vinScanModelObject=[[SMVINScanModelObject alloc]init];
                    vinScanModelObject.strModelId      = dictionary[@"modelID"];
                    vinScanModelObject.strModelName    =    dictionary[@"modelName"];
                    vinScanModelObject.strModelMinYear =dictionary[@"minYear"];
                    vinScanModelObject.strModelMaxYear =dictionary[@"maxYear"];
                    if ([vinScanModelObject.strModelMaxYear isEqualToString:@"0"])
                    {
                    
                        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
                        NSInteger year = [components year];
                        vinScanModelObject.strModelMaxYear = [NSString stringWithFormat:@"%ld",(long)year];
                    }
                    [modelArray addObject:vinScanModelObject];
                    
                }
                self.txtModel.userInteractionEnabled = YES;
            }
            else
            {
                [self.txtModel  setRightViewMode:UITextFieldViewModeAlways];
                self.txtModel.rightView        = downArrowButton3;
                
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
                     NSLog(@"this2**");
                    [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
                }
                //yearArray=[[[yearArray reverseObjectEnumerator] allObjects] mutableCopy];
                if (strPickerValue.length==0)
                {
                    strPickerValue =jsonObject[@"maxYear"];
                }
                self.txtModel.text=self.VINLookupObject.Model;
                self.txtModel.userInteractionEnabled = NO;
                variantArray=[[NSMutableArray alloc]init];
                VINScanDetailsObject.strExisting =jsonObject[@"existing"];
                VINScanDetailsObject.strHasModel =[jsonObject[@"hasModel"] boolValue];
                VINScanDetailsObject.strMaxYear  =jsonObject[@"maxYear"];
                VINScanDetailsObject.strMinYear  =jsonObject[@"minYear"];
                MaxYear=[VINScanDetailsObject.strMaxYear intValue];
                MinYear=[VINScanDetailsObject.strMinYear intValue];
                
                selectedModelId=[jsonObject[@"ModelID"] intValue];
                
                
                
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
            
            //hide progress bar
            [self hideProgressHUD];
            
            
            isExisiting=NO;
            scrollView.hidden=NO;
            self.txtMake.text=self.VINLookupObject.Make;
            
            if(![self.VINLookupObject.strYear isKindOfClass:[NSNull class]] )
                self.txtStartYear.text=self.VINLookupObject.strYear;
            
            if(![self.VINLookupObject.strVariantName isKindOfClass:[NSNull class]] )
            {
                self.txtVariants.text=self.VINLookupObject.strVariantName;
                selectedVariantId = self.VINLookupObject.variant.intValue;
               // selectedVarientMeanCode = self.VINLookupObject.m
                
                for(SMVINScanDetailsObject *individualObj in variantArray)
                {
                    if([individualObj.strVariantsId isEqualToString:self.VINLookupObject.variant])
                    {
                        selectedVarientMeanCode = individualObj.strVariantsCode;
                    }
                }
                
            }
            
            
            self.txtExpires.text=self.VINLookupObject.DateExpires;
            self.txtRegNo.text=self.VINLookupObject.Registration;
            self.txtVINNo.text=self.VINLookupObject.VIN;
            self.txtColour.text=self.VINLookupObject.Colour;
            self.txtEngineNo.text=self.VINLookupObject.EngineNo;
            self.txtLicenseNo.text=self.VINLookupObject.Entry4;
           
            
            NSLog(@"jsonObject is %@",VINDetailArray);
            
            if ([jsonObject[@"existing"] isEqualToString:@"yes"])
            {
                isExisiting=YES;
                [scrollView setContentSize:(CGSizeMake(320, contentView.frame.size.height-90))];
                
                for (NSDictionary *dictionary in jsonObject[@"stock"])
                {
                    SMVinStockObject *stockObject=[[SMVinStockObject alloc]init];
                    stockObject.strCode =dictionary[@"code"];
                    stockObject.strId   =dictionary[@"id"];
                    [stockArray addObject:stockObject];
                }
                
                [self.saveForLaterButton setHidden:YES];
                [self.AddToStockButton   setHidden:YES];
                [lblStockNo              setHidden:NO];
                [self.txtStockNo         setHidden:NO];
                [self setFrameIfVehicleExist];
                [self setInteractionEnable]; // THIS WILL SET ALL TEXT ENABLED
                [self.discardButton      setTitle:@"Update" forState:UIControlStateNormal];
                lblVariantNote.frame = CGRectMake(lblVariantNote.frame.origin.x,self.txtExpires.frame.origin.y + self.txtExpires.frame.size.height + 7.0, lblVariantNote.frame.size.width, lblVariantNote.frame.size.height);
                

                [self.discardButton      setBackgroundColor:[SMCustomColor setBlueColorThemeButton]];
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    
                    [self.discardButton setFrame:CGRectMake(self.discardButton.frame.origin.x, self.discardButton.frame.origin.y, self.discardButton.frame.size.width+400, self.discardButton.frame.size.height)];
                }
                [self.discardButton       setHidden:NO];
                [self.saveForLaterButton  setHidden:YES];
                [self.AddToStockButton    setHidden:YES];
            }
            else
            {
                
                [self.discardButton setHidden:NO];
                [self.saveForLaterButton setHidden:NO];
                [self.AddToStockButton setHidden:NO];
                
                [scrollView setContentSize:(CGSizeMake(320, contentView.frame.size.height-120))];
            }
        }
        else
        {
            SMAlert(KLoaderTitle, [jsonObject valueForKey:@"message"]);
        }
        
    }
    if ([elementName isEqualToString:@"ListVariantsJSONResult"])
    {
        VINDetailArray=[[NSMutableArray alloc]init];
        NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
           
            
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                
                VINScanDetailsObject=[[SMVINScanDetailsObject alloc]init];
                VINScanDetailsObject.strVariantsFriendly =dictionary[@"variantName"];
                VINScanDetailsObject.strVariantsId       =dictionary[@"variantID"];
                VINScanDetailsObject.strVariantsCode     =dictionary[@"meadCode"];
                VINScanDetailsObject.strVariantsName     =dictionary[@"variantName"];
                VINScanDetailsObject.strVariantsMaxYear  =dictionary[@"MaxDate"];
                VINScanDetailsObject.strVariantsMinYear  =dictionary[@"MinDate"];
                [variantArray addObject:VINScanDetailsObject];
            
            }
            [self hideProgressHUD];

            if(!isVariantWebserviceCalledinBackground)
            {
                [loadVehicleTableView setHidden:NO];
                [pickerView setHidden:YES];
                [self loadPopup];
                [loadVehicleTableView reloadData];
            }
        }
        else
        {
            [self hideProgressHUD];
            [self showAlert:KVariantsNotFound];
        }
        
    }
    if ([elementName isEqualToString:@"SaveVINScanResult"])
    {
    
        NSArray *arraySaveVIN = [currentNodeContent componentsSeparatedByString:@":"];
        
        if ([[arraySaveVIN objectAtIndex:0] isEqualToString:@"OK"]) {
            
            
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
        
    }
    // end of xml parsing
    
    if ([elementName isEqualToString:@"CheckScannedVinJSONResponse"])
    {
        if (VINDetailArray.count!=0)
        {
            [self hideProgressHUD];
            [loadVehicleTableView reloadData];
        }
        
    }
    if ([elementName isEqualToString:@"SaveVINScanResponse"])
    {
        
        
        NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        [self hideProgressHUD];

       
        if ([[jsonObject valueForKey:@"status"] isEqualToString:@"error"])
        {
            [self showAlert:[jsonObject valueForKey:@"message"]];
        }
        
    }
    if ([elementName isEqualToString:@"ValidateVinJSONResult"])
    {
        
        NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        [self hideProgressHUD];

        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            lblFinanced.hidden          =NO;
            self.txtStolen.hidden       =NO;
            self.txtFinanced.hidden     =NO;
            self.txtHasAccidents.hidden =NO;
            stolenCheckButton.hidden    =YES;
            accidentCheckButton.hidden  =YES;
            lbValiodationText.hidden    =YES;
            [validateButtons setBackgroundColor:[UIColor colorWithRed:0.498f green:0.498f blue:0.498f alpha:1.0f]];
            
            if (isExisiting)
            {
                [self.txtStolen setFrame:CGRectMake(self.txtStolen.frame.origin.x, self.txtStolen.frame.origin.y+31, self.txtStolen.frame.size.width,  self.txtStolen.frame.size.height)];
                [self.txtFinanced setFrame:CGRectMake(self.txtFinanced.frame.origin.x, self.txtFinanced.frame.origin.y+31, self.txtFinanced.frame.size.width,  self.txtFinanced.frame.size.height)];
                [self.txtHasAccidents setFrame:CGRectMake(self.txtHasAccidents.frame.origin.x, self.txtHasAccidents.frame.origin.y+29, self.txtHasAccidents.frame.size.width,  self.txtHasAccidents.frame.size.height)];
                [scrollView setContentSize:(CGSizeMake(320, contentView.frame.size.height-55))];
                
            }
            else
            {
                [scrollView setContentSize:(CGSizeMake(320, contentView.frame.size.height-85))];
                
            }
            
            [lblFinanced setFrame:lblHasAccidents.frame];
            [lblHasAccidents setFrame:CGRectMake(lblHasAccidents.frame.origin.x, lblHasAccidents.frame.origin.y+34, lblStolen.frame.size.width,  lblHasAccidents.frame.size.height)];
            
            [validateButtons setFrame:CGRectMake(validateButtons.frame.origin.x, validateButtons.frame.origin.y+38, 307,  validateButtons.frame.size.height)];
            
            
            lblStolen.text        =@"Stolen";
            lblFinanced.text      =@"Financed";
            lblHasAccidents.text  =@"Has Accident/s";
            [self.txtHasAccidents setText:jsonObject[@"Accident"]];
            [self.txtFinanced     setText:jsonObject[@"Financed"]];
            [self.txtStolen       setText:jsonObject[@"Stolen"]];
            [validateButtons      setEnabled:NO];
        }
        else
        {
            [self showAlert:jsonObject[@"message"]];
        }
    }
    
    // if vehicle information updated successfully
    if([elementName isEqualToString:@"UpdateVehicleViaObjResult"])
    {
        [self showAlert:currentNodeContent];
        [self hideProgressHUD];
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
    
}
-(void)setFrameIfVehicleExist
{
    [lblColour setFrame:lblLicenseNo.frame];
    [lblLicenseNo setFrame:lblRegNo.frame];
    [lblRegNo setFrame:lblEngineNo.frame];
    [lblEngineNo setFrame:lblVINNo.frame];
    [lblVINNo setFrame:lblExpires.frame];
    [lblExpires setFrame:CGRectMake(lblExpires.frame.origin.x, lblExpires.frame.origin.y+35, lblExpires.frame.size.width,  lblExpires.frame.size.height)];
    
    [self.txtColour setFrame:self.txtRegNo.frame];
    [self.txtLicenseNo setFrame:self.txtRegNo.frame];
    [self.txtRegNo setFrame:self.txtEngineNo.frame];
    [self.txtEngineNo setFrame:self.txtVINNo.frame];
    [self.txtVINNo setFrame:self.txtExpires.frame];
    [self.txtExpires setFrame:CGRectMake(self.txtExpires.frame.origin.x, self.txtExpires.frame.origin.y+37, self.txtExpires.frame.size.width,  self.txtExpires.frame.size.height)];
    
    [self.discardButton setFrame:CGRectMake(self.discardButton.frame.origin.x, self.discardButton.frame.origin.y+34, 307,  self.discardButton.frame.size.height)];
    [lblStolen setFrame:CGRectMake(lblStolen.frame.origin.x, lblStolen.frame.origin.y+31, lblStolen.frame.size.width,  lblStolen.frame.size.height)];
    [lblHasAccidents setFrame:CGRectMake(lblHasAccidents.frame.origin.x, lblHasAccidents.frame.origin.y+31, lblStolen.frame.size.width,  lblHasAccidents.frame.size.height)];
    [lbValiodationText setFrame:CGRectMake(lbValiodationText.frame.origin.x, lbValiodationText.frame.origin.y+31, lbValiodationText.frame.size.width,  lbValiodationText.frame.size.height)];
    
    [validateButtons setFrame:CGRectMake(validateButtons.frame.origin.x, validateButtons.frame.origin.y+34, 307,  validateButtons.frame.size.height)];
    
    [stolenCheckButton setFrame:CGRectMake(stolenCheckButton.frame.origin.x, stolenCheckButton.frame.origin.y+31, stolenCheckButton.frame.size.width,  stolenCheckButton.frame.size.height)];
    [accidentCheckButton setFrame:CGRectMake(accidentCheckButton.frame.origin.x, accidentCheckButton.frame.origin.y+31, accidentCheckButton.frame.size.height,  accidentCheckButton.frame.size.height)];
    
    
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
-(void) moveToUpdateScreen
{

    [SMGlobalClass sharedInstance].isListModule = NO;
    
    SMAddToStockViewController *addToStockView;
    addToStockView=[[SMAddToStockViewController alloc]initWithNibName:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? @"SMAddToStockViewController" : @"SMAddToStockViewController_iPad"  bundle:nil];
    addToStockView.VINLookupObject              =self.VINLookupObject;
    addToStockView.strMeanCode                  =selectedVarientMeanCode;
    addToStockView.strVariantId                 =selectedVariantId;
    addToStockView.strUsedYear                  =self.txtStartYear.text;
    addToStockView.strStockNumber               = strSelectedStockNumber;
    addToStockView.iStockID                     = selectedStockIdId;
    addToStockView.isFromAddToStockPage = YES;
    addToStockView.isUpdateVehicleInformation   = YES;
    addToStockView.strProgramName               =[NSString stringWithFormat:@"%@ %@ %@",self.txtStartYear.text ,self.txtMake.text, self.txtVariants.text];
    addToStockView.strSelctedVarinatName =[NSString stringWithFormat:@"%@ %@ %@",self.txtStartYear.text ,self.txtMake.text, self.txtVariants.text];
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [SMGlobalClass sharedInstance].isListModule = NO;
        addToStockView.isFromVinLookUpEditPage = YES;
        [self.navigationController pushViewController:addToStockView animated:YES];
        
    });
}
/*!
 @brief This will call To Register NIb files .
 */
-(void)registerNib
{
    
    // Main Vehicle Table
    [loadVehicleTableView     registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMLoadVehicleTableViewCell" : @"SMLoadVehicleTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMLoadVehicleTableViewCell"];
    
    
    // For Variant Cell
    
    [loadVehicleTableView     registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMVariantCell" : @"SMVariantCell_iPad" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
    
    // existing Cell
    
    [existingVehicleTableView registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMExistingVehicleTableViewCell" : @"SMExistingVehicleTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMExistingVehicleTableViewCell"];
    
}

#pragma mark -

#pragma mark - MBProgress HUD
-(void) addingProgressHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}
-(void) hideProgressHUD
{
    [HUD hide:YES];
}
#pragma mark -


#pragma mark - TextFields User Interaction Disabled Calls

-(void) setInteractionEnable
{
    [self.txtModel      setUserInteractionEnabled:YES];
    [self.txtMake       setUserInteractionEnabled:NO];
    [self.txtColour     setUserInteractionEnabled:NO];
    [self.txtLicenseNo  setUserInteractionEnabled:NO];
    [self.txtRegNo      setUserInteractionEnabled:NO];
    [self.txtEngineNo   setUserInteractionEnabled:NO];
    [self.txtVINNo      setUserInteractionEnabled:NO];
    [self.txtExpires    setUserInteractionEnabled:NO];
}


#pragma mark -

@end
