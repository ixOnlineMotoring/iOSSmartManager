//
//  SMLoadVehiclesViewController.m
//  SmartManager
//
//  Created by Priya on 15/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMLoadVehiclesViewController.h"
#import "SMLoadVehicleTableViewCell.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMCustomColor.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "SMReusableSearchTableViewController.h"

@interface SMLoadVehiclesViewController ()
{
     SMReusableSearchTableViewController *searchMakeVC;
    NSArray *arrLoadNib;
}
@end

@implementation SMLoadVehiclesViewController


#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.titleView = [SMCustomColor setTitle:@"Load Vehicle"];
    
    [self addingProgressHUD];
    
    selectedVariantId = 0;
    
    [self registerNibCustomFunction];
    [self gettingAllYearsForPickerView];
    [self setFontToTextField];
    
    
    self.txtModel.userInteractionEnabled = NO;
    self.txtVariants.userInteractionEnabled = NO;
    
    // Do any additional setup after loading the view from its nib.

    selectedMakeIndex       = -1;
    selectedModelIndex      = -1;
    selectedVariantsIndex   = -1;
    
    arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMReusableSearchTableViewController" owner:self options:nil];
   searchMakeVC = [arrLoadNib objectAtIndex:0];
   
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [self hideProgressHUD];
    [popupView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -



#pragma mark - IBAction

-(IBAction)btnClearDidClicked:(id)sender
{
    strPickerValue= [yearArray objectAtIndex:0];
    [self.txtYear     setText:strPickerValue];
    [self.txtModel    setText:@""];
    [self.txtMake     setText:@""];
    [self.txtVariants setText:@""];
    selectedMakeId =0;
    selectedModelId=0;
    selectedVariantId =0;
    [modelArray   removeAllObjects];
    [variantArray removeAllObjects];
}

-(IBAction)btnNextDidClicked:(id)sender
{
    
    SMAddToStockViewController  *viewAddStock;
    if (selectedMakeId == 0  || self.txtMake.text.length == 0)
    {
        SMAlert(KLoaderTitle,KMakeSelection);
        return;
    }
    else if(selectedModelId == 0 || self.txtModel.text.length == 0)
    {
        SMAlert(KLoaderTitle, KModelSelection);
        return;
    }
    else if(selectedVariantId == 0 || self.txtVariants.text.length == 0)  // compare against nil
    {
        SMAlert(KLoaderTitle, KVariantSelection);
        return;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        viewAddStock = [[SMAddToStockViewController alloc] initWithNibName:@"SMAddToStockViewController" bundle:nil];
    }
    else
    {
        viewAddStock = [[SMAddToStockViewController alloc] initWithNibName:@"SMAddToStockViewController_iPad" bundle:nil];
    }
    
    viewAddStock.isUpdateVehicleInformation = NO;
    viewAddStock.strVariantId               = selectedVariantId;
    viewAddStock.strMeanCode                = selectedMeanCode;
    viewAddStock.strUsedYear                = strPickerValue;
    
    NSLog(@"VehicleNameee = %@",[NSString stringWithFormat:@"%@ %@",strPickerValue,strSelectedVarinatName]);
    
    viewAddStock.strSelctedVarinatName      = [NSString stringWithFormat:@"%@ %@ %@ ",strPickerValue,self.txtMake.text,self.txtModel.text];
    viewAddStock.isUpdateVehicleInformation = NO;
    
    /// Navigate on Main thread ..UI related Task
    dispatch_async(dispatch_get_main_queue(),^
    {
        [SMGlobalClass sharedInstance].isListModule = NO;
        viewAddStock.isFromVinLookUpEditPage = NO;
        [self.navigationController pushViewController:viewAddStock animated:YES];
    });

}


-(IBAction)btnCancelDidClicked:(id)sender
{
        [self dismissPopup];
        UIButton *btn=(UIButton*)sender;
        if (btn.tag==2)
        {
            
            if (![strPickerValue isEqualToString:self.txtYear.text])
            {
                // once select year make, model and variant will clear
                [self.txtMake       setText:@""];
                [self.txtModel      setText:@""];
                [self.txtVariants   setText:@""];
                [self.txtYear       setText:strPickerValue];

                
                // clear array again to get new recrod'd
                [makeArray          removeAllObjects];
                [modelArray         removeAllObjects];
                [variantArray       removeAllObjects];
            }
        }
    
}
#pragma mark -

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
#pragma mark -
#pragma mark - picker delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    strPickerValue=[yearArray objectAtIndex:row];
   
    
    self.txtVariants.userInteractionEnabled = NO;
    self.txtModel.userInteractionEnabled = NO;
}

#pragma mark - UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    float maxHeigthOfView = [self view].frame.size.height/2+50.0;

    int heightNeedtoAdd;
    
    if (selectedType == kListingTypeVariant)
        heightNeedtoAdd = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 75: 100;
    else
        heightNeedtoAdd = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? 43: 58;
    
    float totalFrameOfView ;
   
    switch (selectedType)
    {
        case kListingTypeMake:
            totalFrameOfView = heightNeedtoAdd+([makeArray count]*43);
            break;
        case kListingTypeModel:
            totalFrameOfView = heightNeedtoAdd+([modelArray count]*43);
            break;
        case kListingTypeVariant:
            totalFrameOfView = heightNeedtoAdd+([variantArray count]*43);
            break;
        default:
            break;
    }
    
    
  
    
    if (totalFrameOfView <= maxHeigthOfView)
    {
        //Make View Size smaller, no scrolling
        loadVehicleTableView.frame = CGRectMake(loadVehicleTableView.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, loadVehicleTableView.frame.size.width, totalFrameOfView);
    }
    else
    {
        loadVehicleTableView.frame = CGRectMake(loadVehicleTableView.frame.origin.x, maxHeigthOfView/2-22.0, loadVehicleTableView.frame.size.width, maxHeigthOfView);
    }
    
    switch (selectedType)
    {
        case kListingTypeMake:
                return makeArray.count;
                break;
        case kListingTypeModel:
                return modelArray.count;
                break;
        case kListingTypeVariant:
                return variantArray.count;
                break;
        default:
            break;
 
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43 : 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.cancelButtonView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedType== kListingTypeVariant)
       return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 65.0 : 80.0;
    else
       return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? 40.0 : 55.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier         = @"SMLoadVehicleTableViewCell";
    
    static NSString *CellIdentifierVariant  = @"VariantListing";

    switch (selectedType)
    {
        case kListingTypeMake:
        {
            SMLoadVehicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *) [makeArray objectAtIndex:indexPath.row];
            [cell.lblMakeName      setText:objectVehicleListingInCell.strMakeName];
            return cell;
            
        }
        break;
        case kListingTypeModel:
        {
            SMLoadVehicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *) [modelArray objectAtIndex:indexPath.row];
            [cell.lblMakeName      setText:objectVehicleListingInCell.strMakeName];
            return cell;
        }
        break;
        case kListingTypeVariant:
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



#pragma mark -
#pragma mark - Tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (selectedType)
    {
       /* case kListingTypeMake:
        {
            SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *)[makeArray objectAtIndex:indexPath.row];
            [self.txtMake setText:objectVehicleListingInCell.strMakeName];
            selectedMakeId = objectVehicleListingInCell.strMakeId.intValue;
            //if (selectedMakeIndex!=indexPath.row)   // commented on 30 Aug
            {
                selectedMakeIndex = (int)indexPath.row;
                selectedModelIndex      = -1;
                selectedVariantsIndex   = -1;
                [self.txtModel          setText:@""];
                [self.txtVariants       setText:@""];
                self.txtModel.userInteractionEnabled    = YES;
                self.txtVariants.userInteractionEnabled = NO;
                [modelArray removeAllObjects];
            }
            [self dismissPopup];
        }
            break;*/
        case kListingTypeModel:
        {
            SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *)[modelArray objectAtIndex:indexPath.row];
            [self.txtModel setText:objectVehicleListingInCell.strMakeName];
            selectedModelId = objectVehicleListingInCell.strMakeId.intValue;
            //if (selectedModelIndex != indexPath.row)  // commented on 30 Aug
            {
                selectedModelIndex      = (int)indexPath.row;
                self.txtVariants.userInteractionEnabled = YES;
                [self.txtVariants setText:@""];
                [variantArray removeAllObjects];
            }
            
            [self dismissPopup];

        }
            
            break;
        case kListingTypeVariant:
        {
            SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *)[variantArray objectAtIndex:indexPath.row];
            [self.txtVariants setText:objectVehicleListingInCell.strMakeName];
            selectedVariantId =  objectVehicleListingInCell.strMakeId.intValue;
            selectedMeanCode  =  objectVehicleListingInCell.strMeanCodeNumber;
            strSelectedVarinatName = objectVehicleListingInCell.strMakeName;
            
            [self dismissPopup];
        }
            
            break;
        default:
            break;
    }
}

#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    // if text field not txtvin scan show popup
    if (textField!=self.txtVINScan)
    {
        [pickerView setHidden:YES];
        [loadVehicleTableView setHidden:YES];
        
        if (textField!=self.txtYear) 
        {
            [loadVehicleTableView setHidden:NO];
            if (textField==self.txtMake) // if make
            {
                selectedType=kListingTypeMake;
                if (makeArray.count >0 )
                {
                    //[self loadPopup];
                    //[loadVehicleTableView reloadData];
                    
                   
                    [searchMakeVC getTheDropDownData:makeArray];
                    [self.view addSubview:searchMakeVC];
                   
                    [SMReusableSearchTableViewController getTheSelectedSearchDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue) {
                        NSLog(@"selected text = %@",selectedTextValue);
                        NSLog(@"selected ID = %d",selectIDValue);
                        
                        
                            [self.txtMake setText:selectedTextValue];
                            selectedMakeId = selectIDValue;
                        
                                selectedModelIndex      = -1;
                                selectedVariantsIndex   = -1;
                                [self.txtModel          setText:@""];
                                [self.txtVariants       setText:@""];
                                self.txtModel.userInteractionEnabled    = YES;
                                self.txtVariants.userInteractionEnabled = NO;
                                [modelArray removeAllObjects];
                        
                        
                        
                        
                    }];
                    
                     [self hideProgressHUD];
                    
                }
                else
                {
                   [self loadMakeListing];
            
                }
                
            }
            else if (textField==self.txtModel)  //if model

            {
                selectedType= kListingTypeModel;
                
                if (self.txtMake.text.length==0)
                {
                    SMAlert(KLoaderTitle, KMakeSelection);
                }
                else
                {
                    if (modelArray.count >0 )
                    {
                        [self loadPopup];
                        [loadVehicleTableView reloadData];
                    }
                    else
                        [self loadModelsListing];
                }
            }
            else // if variant
            {
                selectedType= kListingTypeVariant;
                
                if (self.txtMake.text.length==0)
                {
                    SMAlert(KLoaderTitle,KMakeSelection);
                }
                else if(self.txtModel.text.length==0)
                {
                    SMAlert(KLoaderTitle,KModelSelection);
                }
                else
                {
                    if (variantArray.count >0 )
                    {
                        [self loadPopup];
                        [loadVehicleTableView reloadData];
                    }
                    else
                        [self loadVarientsListing];
                }
            }
        }
        else
        {
            //[pickerView setHidden:NO];
            strPickerValue=self.txtYear.text;
            
            [self.view endEditing:YES];
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            [popUpView getTheDropDownData:[SMAttributeStringFormatObject getYear] withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:YES]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                textField.text = selectedTextValue;
                strPickerValue=selectedTextValue;
                
                //===========================
                //Change by Dr. Ankit
                
                self.txtMake.text =@"";
                self.txtModel.text =@"";
                self.txtVariants.text =@"";
                
                //===========================

                self.txtVariants.userInteractionEnabled = NO;
                self.txtModel.userInteractionEnabled = NO;
            }];
        }
    }
    else
    {
        SMVINLookUpViewController *VINLookUpView;
        VINLookUpView =[[SMVINLookUpViewController alloc]initWithNibName:@"SMVINLookUpViewController" bundle:nil];

        dispatch_async(dispatch_get_main_queue(), ^{

                [self.navigationController pushViewController:VINLookUpView animated:YES];
        });

    }
}


#pragma mark - User Define Functions


/*!
 @brief This will set custom fonts to some controls. Call is coming from ViewDidLoad
 
 @discussion For setting Any Custom Font Make it Here Only.
 
 To use it, Already Called Given A call In view did load
 
 @param  No
 
 @return No.
 */

-(void)setFontToTextField
{
    
    

    self.txtYear.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtYear.layer.borderWidth= 0.8f;
    self.txtYear.font = UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? [UIFont fontWithName:FONT_NAME size:15.0] : [UIFont fontWithName:FONT_NAME size:20.0];
    [self.txtYear setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)]];
    [self.txtYear setLeftViewMode:UITextFieldViewModeAlways];
    
    
    loadVehicleTableView.layer.cornerRadius =15.0;
    loadVehicleTableView.clipsToBounds      =YES;
    loadVehicleTableView.layer.borderWidth  =1.5;
    loadVehicleTableView.layer.borderColor  =[[UIColor blackColor] CGColor];
    
    pickerView.layer.cornerRadius           =15.0;
    pickerView.clipsToBounds                =YES;
    pickerView.layer.borderWidth            =1.5;
    pickerView.layer.borderColor            =[[UIColor blackColor] CGColor];
    
    
    [self.txtVariants  setRightViewMode:UITextFieldViewModeAlways];
    self.txtVariants.rightView  = downArrowButton1;
    
    [self.txtVINScan   setRightViewMode:UITextFieldViewModeAlways];
    self.txtVINScan.rightView   = downArrowButton2;
    
    [self.txtMake      setRightViewMode:UITextFieldViewModeAlways];
    self.txtMake.rightView      = downArrowButton3;
    
    [self.txtModel     setRightViewMode:UITextFieldViewModeAlways];
    self.txtModel.rightView     = downArrowButton4;
    
    [self.txtYear      setRightViewMode:UITextFieldViewModeAlways];
    self.txtYear.rightView      = downArrowButton5;
    
}

/*!
 @brief This will call when user want to Load Popup View.
 
 @discussion Popup for Make, Model, etc.
 
 To use it, simply call loadPopup
 
 @param  No
 
 @return No.
 */

-(void)loadPopup
{
    
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (vc != self)
        return;
    
    
    [popupView setFrame:[UIScreen mainScreen].bounds];
    [popupView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.50]];
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

/*!
 @brief This will call when user want to Hide Popup View.
 
 @discussion Hide Popup for Make, Model, etc.
 
 To use it, simply call dismissPopup
 
 @param  No
 
 @return No.
 */

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
/*!
 @brief This will call when user want to Load The Make.
 
 @discussion When User wants to Show Make Listing From Web service Then Call this Functions.
 
 To use it, simply call loadMakeListing
 
 @param  Year Will required to call web service
 
 @return Listing Of Makes.
 */
-(void)loadMakeListing
{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllMakevaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:self.txtYear.text];
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
            
            makeArray = [[NSMutableArray alloc] init];
            xmlParser = [[NSXMLParser alloc] initWithData: data];
            [xmlParser setDelegate: self];
            [xmlParser setShouldResolveExternalEntities:YES];
            [xmlParser parse];
         }
     }];
}

/*!
 @brief This will call when user want to Load The Model.
 
 @discussion When User wants to Show Model Listing From Web service Then Call this Function.
 
 To use it, simply call loadModelsListing
 
 @param  Selected Make Id And Year Will required to call web service
 
 @return Listing Of Models.
 */

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
          
             SMAlert(@"Error", error.localizedDescription);
             [self hideProgressHUD];
             return;
         }
         else
         {
             
             modelArray = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
  
}


/*!
 @brief This will call when user want to Load The Variants.
 
 @discussion When User wants to Show Model Listing From Web service Then Call this Function.
 
 To use it, simply call loadVarientsListing
 
 @param  Selected Model Id and year Will required to call web service
 
 @return Listing Of Variants.
 */

-(void)loadVarientsListing
{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingAllVarintsvaluesForVehicles:[SMGlobalClass sharedInstance].hashValue Year:self.txtYear.text modelId:selectedModelId];
    
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
             variantArray = [[NSMutableArray alloc] init];
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
/*!
 @brief This will call From View Did Load .
 
 @discussion Year from current year to 1990.
 
 To use it, simply call gettingAllYearsForPickerView
 
 @param  No
 
 @return No.
 */
-(void) gettingAllYearsForPickerView
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    int year = (int)[components year];
    yearArray=[[NSMutableArray alloc]init];
    [self.txtYear setText:[NSString stringWithFormat:@"%d",year]];
    for (int i=year; i>=1990; i--)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    if (strPickerValue.length==0)
    {
        strPickerValue= [yearArray objectAtIndex:0];
    }
    
}


#pragma mark -


#pragma mark - xml parser delegate
-(void) parser:(NSXMLParser  *)     parser
didStartElement:(NSString    *)     elementName
  namespaceURI:(NSString     *)     namespaceURI
 qualifiedName:(NSString     *)     qName
    attributes:(NSDictionary *)     attributeDict
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
    else
    {
        loadVehiclesDetailsObject=[[SMLoadVehiclesDetailsObject alloc]init];
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
    //get model data

    if ([elementName isEqualToString:@"ListModelsJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                loadVehiclesObject             =[[SMLoadVehiclesObject alloc]init];
                loadVehiclesObject.strMakeId   =dictionary[@"modelID"];
                loadVehiclesObject.strMakeName =dictionary[@"modelName"];
                [modelArray  addObject:loadVehiclesObject];
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
                [variantArray          addObject:loadVehiclesObject];
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
        if (makeArray.count!=0)
        {
            // [loadVehicleTableView reloadData];
            // makeArray.count>0?[self loadPopup]:SMAlert(KLoaderTitle,KNorecordsFousnt);
            
            [self.txtModel        setText:@""];
            [self.txtVariants     setText:@""];
            
           
            searchMakeVC = [arrLoadNib objectAtIndex:0];
           [searchMakeVC getTheDropDownData:makeArray];
             [self.view addSubview:searchMakeVC];
            [SMReusableSearchTableViewController getTheSelectedSearchDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                
                [self.txtMake setText:selectedTextValue];
                selectedMakeId = selectIDValue;
                
                selectedModelIndex      = -1;
                selectedVariantsIndex   = -1;
                [self.txtModel          setText:@""];
                [self.txtVariants       setText:@""];
                self.txtModel.userInteractionEnabled    = YES;
                self.txtVariants.userInteractionEnabled = NO;
                [modelArray removeAllObjects];

                
            }];

            [self hideProgressHUD];
        }
    }
    if ([elementName isEqualToString:@"ListModelsJSONResponse"])
    {
        if (modelArray.count!=0)
        {
            [self.txtVariants setText:@""];
            [loadVehicleTableView reloadData];
             modelArray.count>0 ?[self loadPopup]:SMAlert(KLoaderTitle,KNorecordsFousnt);
            [self hideProgressHUD];
        }
    }
    
    if ([elementName isEqualToString:@"ListVariantsJSONResponse"])
    {
        if (variantArray.count!=0)
        {
            [loadVehicleTableView reloadData];
            variantArray.count>0 ?[self loadPopup]:SMAlert(KLoaderTitle,KNorecordsFousnt);
            [self hideProgressHUD];
        }
    }
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
}
#pragma mark -


#pragma mark - Registering NIb Functions
-(void) registerNibCustomFunction
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [loadVehicleTableView registerNib:[UINib nibWithNibName: @"SMLoadVehicleTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMLoadVehicleTableViewCell"];
        [loadVehicleTableView registerNib:[UINib nibWithNibName:@"SMVariantCell" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
    }
    else
    {
        [loadVehicleTableView registerNib:[UINib nibWithNibName:@"SMLoadVehicleTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMLoadVehicleTableViewCell"];
        [loadVehicleTableView registerNib:[UINib nibWithNibName:@"SMVariantCell_iPad" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
    }
}
#pragma mark -




@end
