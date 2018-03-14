//
//  SMListUpdateVariantViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 27/01/15. // Modifications By Ketan
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMListUpdateVariantViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMLoadVehicleTableViewCell.h"

@interface SMListUpdateVariantViewController ()

@end

@implementation SMListUpdateVariantViewController
@synthesize vehicleListDelegates;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    selectedMakeIndex       = -1;
    selectedModelIndex      = -1;
    selectedVariantIndex    = -1;

    self.pickerView.layer.cornerRadius  = 15.0;
    self.pickerView.clipsToBounds       = YES;
    self.pickerView.layer.borderWidth   = 1.5;
    self.pickerView.layer.borderColor   = [[UIColor blackColor] CGColor];
    
    self.tableParentView.layer.cornerRadius  = 15.0;
    self.tableParentView.clipsToBounds       = YES;
    
    self.txtFieldModel.userInteractionEnabled   = NO;
    self.txtFieldVariant.userInteractionEnabled = NO;
    
    [self gettingAllYearsForPickerView];
    [self registerNibCustomFunction];
    
    [self addingProgressHUD];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];

    [self hideProgressHUD];
    
    [popupView removeFromSuperview];
}

#pragma mark - UITableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    float maxHeigthOfView = [self view].frame.size.height/2+50.0;
    
    int heightNeedtoAdd;
    
    heightNeedtoAdd = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 43 : 50;
    float totalFrameOfView = 0.0f;
    
    switch (selectedType)
    {
        case 1:
            totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? heightNeedtoAdd+([makeArray count]*43) : heightNeedtoAdd+([makeArray count]*50);
            break;
            
        case 2:
            totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? heightNeedtoAdd+([modelArray count]*43) : heightNeedtoAdd+([modelArray count]*50);
            break;

        case 3:
            totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? heightNeedtoAdd+([variantArray count]*55) : heightNeedtoAdd+([variantArray count]*50);
            break;
    }
    
    if(selectedType == 3)
    {
         self.tableParentView.frame = CGRectMake(self.tableParentView.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, self.tableParentView.frame.size.width, 300.0);
    
    }
    else
    {
    if (totalFrameOfView <= maxHeigthOfView)
    {
        //Make View Size smaller, no scrolling
        self.tableParentView.frame = CGRectMake(self.tableParentView.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, self.tableParentView.frame.size.width, totalFrameOfView);
    }
    else
    {
        self.tableParentView.frame = CGRectMake(self.tableParentView.frame.origin.x, maxHeigthOfView/2-22.0, self.tableParentView.frame.size.width, maxHeigthOfView);
    }
    }
    switch (selectedType)
    {
        case 1:
            return makeArray.count;
            break;
            
        case 2:
            return modelArray.count;
            break;
            
        case 3:
            return variantArray.count;
            break;
            
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(selectedType== 3)
        return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 70.0 : 80.0;
    else
        return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 40.0 : 55.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    static NSString *CellIdentifier = @"SMLoadVehicleTableViewCell";
    
    static NSString *CellIdentifierVariant = @"VariantListing";

    switch (selectedType)
    {
        case 1:
        {
            SMLoadVehicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *) [makeArray objectAtIndex:indexPath.row];
            [cell.lblMakeName      setText:objectVehicleListingInCell.strMakeName];
            return cell;
            
        }
            break;
        case 2:
        {
            SMLoadVehicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *) [modelArray objectAtIndex:indexPath.row];
            [cell.lblMakeName      setText:objectVehicleListingInCell.strMakeName];
            return cell;
        }
            break;
        case 3:
        {
            
            SMLoadVehicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierVariant];
            SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *) [variantArray objectAtIndex:indexPath.row];
            [cell.lableVariantName      setText:objectVehicleListingInCell.strMakeName];
            [cell.lableVarinatCodeWithyear setText:[NSString stringWithFormat:@"%@ (%@ to %@)",objectVehicleListingInCell.strMeanCodeNumber,objectVehicleListingInCell.strMinYear,objectVehicleListingInCell.strMaxYear]];
            return cell;
        }
            break;
        default:
            break;
    }
    
    return 0;
}

#pragma mark - Tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (selectedType)
    {
        case 1:
        {
            SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *)[makeArray objectAtIndex:indexPath.row];
            [self.txtFieldMake setText:objectVehicleListingInCell.strMakeName];
            selectedMakeId = objectVehicleListingInCell.strMakeId.intValue;

            if (selectedMakeIndex!=indexPath.row)
            {
                selectedMakeIndex       = (int)indexPath.row;
                selectedModelIndex      = -1;
                selectedVariantIndex    = -1;
                [self.txtFieldModel     setText:@""];
                [self.txtFieldVariant   setText:@""];
                [modelArray             removeAllObjects];
                [variantArray           removeAllObjects];
            }
            
            self.txtFieldModel.userInteractionEnabled    = YES;
            self.txtFieldVariant.userInteractionEnabled  = NO;

            [self dismissPopup];
        }
            
            break;
        case 2:
        {
            SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *)[modelArray objectAtIndex:indexPath.row];
            [self.txtFieldModel setText:objectVehicleListingInCell.strMakeName];
            selectedModelId = objectVehicleListingInCell.strMakeId.intValue;
            if (selectedModelIndex!=indexPath.row)
            {
                selectedModelIndex      = (int)indexPath.row;
                selectedVariantIndex    = -1;
                self.txtFieldVariant.text   = @"";
                [variantArray removeAllObjects];
            }
            self.txtFieldVariant.userInteractionEnabled  =YES;
            [self dismissPopup];
        }
            
            break;
        case 3:
        {
            SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *)[variantArray objectAtIndex:indexPath.row];
            [self.txtFieldVariant setText:objectVehicleListingInCell.strMakeName];
            selectedVariantId           =  objectVehicleListingInCell.strMakeId.intValue;
            selectedMeanCode            =  objectVehicleListingInCell.strMeanCodeNumber;
            strSelectedVarinatName      =  objectVehicleListingInCell.strMakeName;
            objectVehicleListingInCell.strMakeYear = self.txtFieldYear.text;
            
           [[NSNotificationCenter defaultCenter]postNotificationName:@"GetTheVariantMeanCode" object:objectVehicleListingInCell];
            
            [vehicleListDelegates getRefreshedVairnatName];
            
            [self dismissPopup];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
            
            break;
        default:
            break;
    }
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
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
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
    self.txtFieldModel.userInteractionEnabled    = NO;
    self.txtFieldVariant.userInteractionEnabled = NO;

}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];

    // if make
    
    if (textField==self.txtFieldMake)
    {
        selectedType=1;
        [self.tableParentView setHidden:NO];
        [self.pickerView setHidden:YES];
        
        if (makeArray.count>0)
        {
            [self.tblViewLoadVarient reloadData];
            [self loadPopup];
        }
        else
        {
            [self loadMakeListing];
        }
    }
    
    //if model
    
    else if (textField==self.txtFieldModel)
    {
        selectedType=2;
        [self.tableParentView setHidden:NO];
        [self.pickerView setHidden:YES];
       
        if (modelArray.count>0)
        {
            [self.tblViewLoadVarient reloadData];
            [self loadPopup];
        }
        else
        {
            [self loadModelsListing];
        }
    }
    
    // if variant
    
    else if(textField == self.txtFieldVariant)
    {
        selectedType=3;
        [self.tableParentView setHidden:NO];
        [self.pickerView setHidden:YES];
       
        if (variantArray.count>0)
        {
            [self.tblViewLoadVarient reloadData];
            [self loadPopup];
        }
        else
        {
            [self loadVarientsListing];
        }
    }
    
    //if year
    
    if(textField == self.txtFieldYear)
    {
        [self.pickerView setHidden:NO];
        [self.tableParentView setHidden:YES];
        strPickerValue=self.txtFieldYear.text;
        
        for (int i=0; i<yearArray.count; i--)
        {
            NSString *str=[yearArray objectAtIndex:i];
            
            if ([str isEqualToString:strPickerValue])
            {
                [self.yearPickerView reloadAllComponents];
                [self.yearPickerView selectRow:i inComponent:0 animated:YES];
            }
        }
        [self loadPopup];
    }
}


#pragma mark - load makes
-(void)loadMakeListing
{
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllMakevaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:self.txtFieldYear.text];
    
    
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
             SMAlert(@"Error",error.localizedDescription);
             [self hideProgressHUD];
         }
         else
         {
             makeArray = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

#pragma mark - load models
-(void)loadModelsListing
{
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllModelsvaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:strPickerValue makeId:selectedMakeId];
    
    
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
             
             SMAlert(@"Error",error.localizedDescription);
             [self hideProgressHUD];
         }
         else
         {
            
             
             modelArray = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

#pragma mark - load varients
-(void)loadVarientsListing
{
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllVarintsvaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:self.txtFieldYear.text modelId:selectedModelId];
    
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
             
             SMAlert(@"Error",error.localizedDescription);
             [self hideProgressHUD];
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

#pragma mark - Global Alert Function

-(void) showAlert:(NSString *) alertMeassge
{
    dispatch_async(dispatch_get_main_queue(),^
                   {
                       SMAlert(KLoaderTitle, alertMeassge);
                   });
}
#pragma mark - xml parser delegate

-(void) parser:(NSXMLParser *)  parser
didStartElement:(NSString *)    elementName
  namespaceURI:(NSString *)     namespaceURI
 qualifiedName:(NSString *)     qName
    attributes:(NSDictionary *)    attributeDict
{
    if ([elementName isEqualToString:@"ListMakesJSONResult"])
    {
        loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
    }
    if ([elementName isEqualToString:@"ListModelsJSONResult"])
    {
        loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
    }
    if ([elementName isEqualToString:@"ListVariantsJSONResult"])
    {
        loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
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
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
                loadVehiclesObject.strMakeId   =dictionary[@"makeID"];
                loadVehiclesObject.strMakeName =dictionary[@"makeName"];
                [makeArray addObject:loadVehiclesObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
    }
    //get maodel data
    
    if ([elementName isEqualToString:@"ListModelsJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
                loadVehiclesObject.strMakeId =dictionary[@"modelID"];
                loadVehiclesObject.strMakeName =dictionary[@"modelName"];
                [modelArray addObject:loadVehiclesObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle, [jsonObject valueForKey:@"message"]);
        }
    }
    
    //get varient data
    if ([elementName isEqualToString:@"ListVariantsJSONResult"])
    {
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
    }
    
    // end of xml parsing
    
    if ([elementName isEqualToString:@"ListMakesJSONResponse"])
    {
        if (makeArray.count!=0)
        {
            [self.txtFieldMake setText:@""];
            [self.txtFieldModel setText:@""];
            [self.tblViewLoadVarient reloadData];
            
            makeArray.count>0 ? [self loadPopup] : [self showAlert:@"No record(s) found."];
            
            [self hideProgressHUD];
        }
    }
    if ([elementName isEqualToString:@"ListModelsJSONResponse"])
    {
        if (modelArray.count!=0)
        {
            [self.txtFieldVariant setText:@""];
            [self.tblViewLoadVarient reloadData];
            
            modelArray.count>0 ? [self loadPopup] : [self showAlert:@"No record(s) found."];
            
            [self hideProgressHUD];
        }
    }
    
    if ([elementName isEqualToString:@"ListVariantsJSONResponse"])
    {
        if (variantArray.count!=0)
        {
            [self.tblViewLoadVarient reloadData];
            variantArray.count>0?[self loadPopup]:[self showAlert:KNorecordsFousnt];
            [self hideProgressHUD];
        }
   }
}

#pragma mark - Registering NIb Functions
-(void) registerNibCustomFunction
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tblViewLoadVarient registerNib:[UINib nibWithNibName: @"SMLoadVehicleTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMLoadVehicleTableViewCell"];
        [self.tblViewLoadVarient registerNib:[UINib nibWithNibName:@"SMVariantCell" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
    }
    else
    {
        [self.tblViewLoadVarient registerNib:[UINib nibWithNibName:@"SMLoadVehicleTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMLoadVehicleTableViewCell"];
        [self.tblViewLoadVarient registerNib:[UINib nibWithNibName:@"SMVariantCell_iPad" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
    }
}

#pragma mark - User Define Functions
-(void) gettingAllYearsForPickerView
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    NSInteger year = [components year];
    yearArray=[[NSMutableArray alloc]init];
    [self.txtFieldYear setText:[NSString stringWithFormat:@"%d",year]];
    for (int i=year; i>=1990; i--)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    if (strPickerValue.length==0)
    {
        strPickerValue= [yearArray objectAtIndex:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnCancelYearDidClicked:(id)sender
{
    [self.txtFieldYear setText:strPickerValue];

    [self dismissPopup];
    
    [self.txtFieldMake      setText:@""];
    [self.txtFieldModel     setText:@""];
    [self.txtFieldVariant   setText:@""];
    
    [self.txtFieldModel     setUserInteractionEnabled:NO];
    [self.txtFieldVariant   setUserInteractionEnabled:NO];
    
    [makeArray      removeAllObjects];
    [modelArray     removeAllObjects];
    [variantArray   removeAllObjects];
}

- (IBAction)btnCancelListDidClicked:(id)sender
{
    [self dismissPopup];
}
#pragma mark -


@end
