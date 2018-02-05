//
//  SMSynopsisVehicleInStockViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 21/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSynopsisVehicleInStockViewController.h"
#import "SMCustomTextFieldForDropDown.h"
#import "SMCustomTextField.h"
#import "SMDropDownObject.h"
#import "SMCustomColor.h"
#import "SMSynopsisSummaryViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMCommonClassMethods.h"
#import "SMDropDownObject.h"
#import "SMSynopsisXMLResultObject.h"
#import "SMSummaryObject.h"
#import "UIBAlertView.h"
#import "SMWSforSummaryDetails.h"
#import "SMSynopsisVerifyVINViewController.h"
@interface SMSynopsisVehicleInStockViewController ()
{
    SMSynopsisXMLResultObject *objSMSynopsisResult;
    SMSummaryObject *objSMSummeryObject;
    
    IBOutlet SMCustomTextFieldForDropDown *txtListAll;
    IBOutlet UIButton *btnCheckBoxSort;
    IBOutlet SMCustomTextFieldForDropDown *txtMake;
    IBOutlet SMCustomTextFieldForDropDown *txtModel;
    IBOutlet SMCustomTextFieldForDropDown *txtVariant;

    NSMutableArray *arrmForListAll;
    NSMutableArray *arrmForModel;
    NSMutableArray *arrmForVariant;
    NSMutableArray *arrmTemp;
    NSString *strSelectedVinNo;
    NSString *strSelectedRegNo;
    SMDropDownObject *ObjectDropDownObject;
    SMLoadVehiclesObject        *loadVehiclesObject;
    NSArray *arrVariantData;

}
- (IBAction)btnContinueToSummaryDidClicked:(id)sender;
- (IBAction)btnCheckBoxSortDidClicked:(id)sender;
@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnContinueToVerification;
- (IBAction)btnContinueToVerificationDidClicked:(id)sender;

@end




@implementation SMSynopsisVehicleInStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Vehicle In Stock"];
    arrmForModel = [[NSMutableArray alloc ] init];
    arrmForVariant = [[NSMutableArray alloc ] init];
    arrayOfStockList = [[NSMutableArray alloc]init];
    arrVariantData   = [NSArray arrayWithObjects:@"Excellent",@"Very Good",@"Good",@"Poor",@"Very Poor", nil];
    arrmTemp = [[NSMutableArray alloc ] init];
    arrayTempVehicles = [[NSMutableArray alloc]init];
    pageNumberCount = 0;
    vehicleYear = 0;
    strSelectedVinNo = @"";
    strSelectedRegNo = @"";
    [self addingProgressHUD];
    //[self loadPhotosAndExtrasWSWithStatusID:1 andSortText:@"friendlyname"];
    [self getConditionDropDown];
    
    arrLoadNib1 = [[NSBundle mainBundle]loadNibNamed:@"SMReusableSearchTableViewController" owner:self options:nil];
    searchMakeVC = [arrLoadNib1 objectAtIndex:0];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    vehicleYear = 0;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
}

-(void) getConditionDropDown{
    
    
    for(int i=0;i<5;i++)
    {
        SMDropDownObject *objCondition = [[SMDropDownObject alloc] init];
        objCondition.strSortTextID = i+1;
        objCondition.strSortText = [arrVariantData objectAtIndex:i];
        [arrmForVariant addObject:objCondition];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == txtVariant)
    {  [self.view endEditing:YES];
        [textField resignFirstResponder];

        if([txtModel.text length] == 0)
        {
            [textField resignFirstResponder];
            SMAlert(KLoaderTitle, KModelSelection);
        }
        else
        {
            
            [self loadVarientsListing];
            
           /* if(arrayOfDealerVariants.count > 0)
            {
                if(previousVehicleYear != vehicleYear)
                {
                    [self loadVarientsListing];
                }
                else
                {
                    
                    NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
                    SMCustomPopUpTableView *popUpView1 = [arrLoadNib objectAtIndex:0];
                    
                    
                    [popUpView1 getTheDropDownData:arrayOfDealerVariants withVariant:YES andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
                    
                    [self.view addSubview:popUpView1];
                    
                    //------  your Request --------------
                    
                    
                    
                   //------  your Response --------------
                    
                    [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                        NSLog(@"selected text = %@",selectedTextValue);
                        NSLog(@"selected ID = %d",selectIDValue);
                        
                        txtVariant.text = selectedTextValue;
                        vehicleVariantId = selectIDValue;
                    }];
                }
                
            }
            else
            {
                vehicleYear == 0 ? [self loadVarientsListingIsWithYear:NO] :  [self loadVarientsListingIsWithYear:YES];
                
            }*/
        }

    }
    else if(textField == txtMake)
    {   [self.view endEditing:YES];
        [textField resignFirstResponder];
        
       /* if(arrayOfDealerMakes.count > 0)
        {
            if(previousVehicleYear != vehicleYear)
            {
                [self loadMakeIsWithYear:YES];
            }
            else
            {
                [txtModel        setText:@""];
                [txtVariant     setText:@""];
                
                NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
                SMCustomPopUpTableView *popUpView1 = [arrLoadNib objectAtIndex:0];
                
                
                [popUpView1 getTheDropDownData:arrayOfDealerMakes withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
                
                [self.view addSubview:popUpView1];
                
                
                [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                    NSLog(@"selected text = %@",selectedTextValue);
                    NSLog(@"selected ID = %d",selectIDValue);
                    
                    txtMake.text = selectedTextValue;
                    vehicleMakeId = selectIDValue;
                }];
            }
            
        }
        else*/
        {
           // vehicleYear == 0 ? [self loadMakeIsWithYear:NO] :  [self loadMakeIsWithYear:YES];
           
            [self loadMakeIsWithYear:NO];
            
        }
        
       // if (arrayOfStockList.count!=0)
//        {
//            
//            BOOL doesContain = [self.view.subviews containsObject:popUpViewNoSearch];
//            
//            if(doesContain)
//            {
//                
//                [popUpViewNoSearch getTheDropDownData:arrayOfStockList withVariant:NO andIsPagination:YES ifSort:NO andIsFirstTimeSort:NO];
//                
//                // array to be passed for custom popup dropdown
//                [self hideProgressHUD];
//                
//            }
//            else
//            {
//                
//                
//                /*************  your Request *******************************************************/
//                NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
//                popUpViewNoSearch = [arrLoadNib objectAtIndex:0];
//                popUpViewNoSearch.paginationDelegate = self;
//                pageNumberCount = 0;
//                isSearchPopUpView = NO;
//                [popUpViewNoSearch getTheDropDownData:arrayOfStockList withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
//                
//                [self.view addSubview:popUpViewNoSearch];
//                
//                [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
//                    NSLog(@"selected text = %@",selectedTextValue);
//                    NSLog(@"selected MakeID = %d",selectIDValue);
//                    NSLog(@"selected MakeYear = %d",minYear);
//                    txtMake.text = selectedTextValue;
//                    selectedMakeId = selectIDValue;
//                    selectedMakeYear = minYear;
//                    
//                }];
//                
//                
//                [self hideProgressHUD];
//            }
//        }
        
    }
    else if(textField == txtModel)
    {   [self.view endEditing:YES];
        [textField resignFirstResponder];
        
        if([txtMake.text length] == 0)
        {
            [textField resignFirstResponder];
            SMAlert(KLoaderTitle, KMakeSelection);
        }
        else
        {
           /* if(arrayOfDealerModels.count > 0)
            {
                if(previousVehicleYear != vehicleYear)
                {
                    [self loadModelsListingIsWithYear:YES];
                }
                else
                {
                    
                    [txtVariant     setText:@""];
                    
                    
                    NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
                    SMCustomPopUpTableView *popUpView1 = [arrLoadNib objectAtIndex:0];
                    
                    
                    [popUpView1 getTheDropDownData:arrayOfDealerModels withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
                    
                    [self.view addSubview:popUpView1];
                    
                   
                    
                    [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                        NSLog(@"selected text = %@",selectedTextValue);
                        NSLog(@"selected ID = %d",selectIDValue);
                        
                        txtModel.text = selectedTextValue;
                        vehicleModelId = selectIDValue;
                    }];
                }
                
            }
            else*/
            {
               // vehicleYear == 0 ? [self loadModelsListingIsWithYear:NO] :  [self loadModelsListingIsWithYear:YES];
                [self loadModelsListingIsWithYear:NO];
                
            }
        }
        
        
//        /*************  your Request *******************************************************/
//        [textField resignFirstResponder];
//        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
//        SMCustomPopUpTableView *popUpView1 = [arrLoadNib objectAtIndex:0];
//        
//        
//        [popUpView1 getTheDropDownData:arrmForVariant withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
//        
//        [self.view addSubview:popUpView1];
//        
//        /*************  your Request *******************************************************/
//        
//        
//        
//        /*************  your Response *******************************************************/
//        
//        [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
//            NSLog(@"selected text = %@",selectedTextValue);
//            NSLog(@"selected ID = %d",selectIDValue);
//            
//            textField.text = selectedTextValue;
//        }];
    }
    else if(textField == txtListAll)
    {
        [self.view endEditing:YES];
        [textField resignFirstResponder];
        
        previousVehicleYear = vehicleYear;
        NSLog(@"previousVehicle = %d",previousVehicleYear);
        
        pageNumberCount = 0;
        [arrayOfStockList removeAllObjects];
        isSearchPopUpView = YES;
        [self loadPhotosAndExtrasWSWithStatusID:1 andSortText:@"friendlyname"];
        
       /* if([arrayTempVehicles count] > 0)
        {
        
                NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpSearchTableView" owner:self options:nil];
                popUpView = [arrLoadNib objectAtIndex:0];
                popUpView.paginationDelegateSearch = self;
                pageNumberCount = 0;
                isSearchPopUpView = YES;
                [popUpView getTheDropDownData:arrayTempVehicles withVariant:YES withVehicle:YES isPagination:NO]; // array to be passed for custom popup dropdown
                
                [self.view addSubview:popUpView];
                
                [SMCustomPopUpSearchTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int selectedYear, NSString *strVehicleStockId) {
                    NSLog(@"selected text = %@",selectedTextValue);
                    
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"strStockId == %@",strVehicleStockId];
                    NSArray *arrSearchedObjects = [arrayOfStockList filteredArrayUsingPredicate:pred];
                    SMDropDownObject *objSearch = [arrSearchedObjects objectAtIndex:0];
                    NSLog(@"selected Year22 = %d",selectedYear);
                    txtListAll.text = selectedTextValue;
                    NSLog(@"%@",objSearch.strMakeName);
                    vehicleYear = selectedYear;
                    vehicleMakeId = [objSearch.strMakeId intValue];
                    vehicleModelId = [objSearch.strModelId intValue];
                    vehicleVariantId = [objSearch.strVariantId intValue];
                    
                    
                }];
                
                [self hideProgressHUD];
            
        }
        else*/
       // {
            //isInitialSearchLoad = YES;

            //[self loadPhotosAndExtrasWSWithStatusID:1 andSortText:@"friendlyname"];
       // }
        
        
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
}

#pragma mark - Button Method

- (IBAction)btnContinueToSummaryDidClicked:(id)sender
{
    if([txtListAll.text length] == 0 && [txtMake.text length] == 0)
    {
        SMAlert(KLoaderTitle, @"Please select inputs.");
    }
    else
    {
        if([txtMake.text length]>0 && [txtModel.text length] == 0)
        {
            SMAlert(KLoaderTitle, KModelSelection);
        }
        else if ([txtModel.text length]>0 && [txtVariant.text length] == 0)
        {
            SMAlert(KLoaderTitle, KVariantSelection);
        }
        else
        {
            [self getTheSynopsisDetails];
        }
    }
    
}

- (IBAction)btnCheckBoxSortDidClicked:(id)sender {
    
    btnCheckBoxSort.selected = !btnCheckBoxSort.selected;
    
}

-(void)loadPhotosAndExtrasWSWithStatusID:(int)statusID andSortText:(NSString*)sortText
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingVehiclePhotosAndExtrasList:[SMGlobalClass sharedInstance].hashValue withstatusID:statusID withClientID:[[SMGlobalClass sharedInstance].strClientID intValue] withPageSize:10 withPageNumber:pageNumberCount sort:sortText andNewUsed:@""];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)loadPhotosAndExtrasWithSearchWSWithStatusCode:(int)statusCode andSearchTextText:(NSString*)searchText
{
        [HUD show:YES];
        [HUD setLabelText:KLoaderText];
    
    
    NSMutableURLRequest *requestURL=[SMWebServices filterThePhotosNExtrasBasedOnSearchWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andsearchKeyword:searchText andPageSize:10 andPageNumber:pageNumberCount andStatus:statusCode andSortText:@"friendlyname" andNewUsed:@""];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [self hideProgressHUD];
             
         }
         else
         {
             
            // [arrayOfStockList removeAllObjects];
             
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}


#pragma mark - xmlParserDelegate
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    
    
    if ([elementName isEqualToString:@"stock"])
    {
        vehicleObject =[[SMDropDownObject alloc]init];
        isVariantsWebserviceCalled = NO;
        
    }
    if ([elementName isEqualToString:@"Variants"])
    {
         isVariantsWebserviceCalled = YES;
    }
    if ([elementName isEqualToString:@"Variant"])
    {
        variantDropdownObject =[[SMDropDownObject alloc]init];
        
        
    }
    
    if ([elementName isEqualToString:@"GetSynopsisXmlResponse"])
    {
        isVariantsWebserviceCalled = NO;
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

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *str = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"stockCode1"])
    {
        if([currentNodeContent length] == 0)
        {
            vehicleObject.strMeanCodeNumber=@"Stock code?";
        }
        else
        {
            vehicleObject.strMeanCodeNumber=[[SMCommonClassMethods shareCommonClassManager]flattenHTML:currentNodeContent];
        }
        
    }
    else if ([elementName isEqualToString:@"vehicleName"])
    {
        if ([currentNodeContent isEqualToString:@""])
        {
            vehicleObject.strMakeName=@"Name?";
        }
        else
        {
            objectForMakes.strMakeName=currentNodeContent;
            vehicleObject.strMakeName= currentNodeContent;
       
        }
    }
    if ([elementName isEqualToString:@"total"])
    {
        vehicleObject.strSortText = currentNodeContent; // the total records count is stored in strSortText bcos we are using the existing NSOBject class instead of creating new one.
    }
    if ([elementName isEqualToString:@"usedYear"])
    {
        vehicleObject.strMakeYear = currentNodeContent;
    }
    if ([elementName isEqualToString:@"makeID"]) {
        vehicleMakeId = [currentNodeContent intValue];
        vehicleObject.strMakeId = currentNodeContent;
         objectForMakes.strMakeId = currentNodeContent;
    }
    if ([elementName isEqualToString:@"modelID"]) {
        vehicleModelId = [currentNodeContent intValue];
        vehicleObject.strModelId = currentNodeContent;
    }
    if ([elementName isEqualToString:@"variantID"])
    {
        if(isVariantsWebserviceCalled)
            variantDropdownObject.strMakeId = currentNodeContent;
        else
        {
            vehicleVariantId = [currentNodeContent intValue];
            vehicleObject.strVariantId = currentNodeContent;
        }
    }
    if ([elementName isEqualToString:@"meadCode"])
    {
        variantDropdownObject.strMeanCodeNumber = currentNodeContent;
    }
    if ([elementName isEqualToString:@"variantName"])
    {
        variantDropdownObject.strMakeName = currentNodeContent; // its actually storing the variantname only. we are reusing the existing object.
    }
    if ([elementName isEqualToString:@"usedVehicleStockID"])
    {
        vehicleObject.strStockId = currentNodeContent;
    }
    if ([elementName isEqualToString:@"colour"])
    {
        if(isVariantsWebserviceCalled)
            variantDropdownObject.strColor = currentNodeContent;
        else
        {
            vehicleObject.strColor = currentNodeContent;
        }
    }
    if ([elementName isEqualToString:@"Variant"])
    {
        [arrayOfDealerVariants addObject:variantDropdownObject];
    }
    if ([elementName isEqualToString:@"stock"])
    {
        [arrayOfStockList addObject:vehicleObject];
    }
    if ([elementName isEqualToString:@"ListDealerStockByModelXMLResponse"])
    {
        /*************  your Request *******************************************************/
        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpVariantTableView" owner:self options:nil];
        popUpView = [arrLoadNib objectAtIndex:0];
        
        [popUpView getTheDropDownData:arrayOfDealerVariants withVariant:YES withVehicle:YES isPagination:NO]; // array to be passed for custom popup dropdown
        
        [self.view addSubview:popUpView];
        
        [SMCustomPopUpSearchTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int selectedYear, NSString *strVehicleStockId) {
        
            NSLog(@"selected text = %@",selectedTextValue);
            NSLog(@"selected ID = %d",selectIDValue);
            
            txtVariant.text = selectedTextValue;
            vehicleVariantId = selectIDValue;
            vehicleYear = selectedYear;
            
            
        }];
        [self hideProgressHUD];
    }
    
    if ([elementName isEqualToString:@"ListVehiclesByStatusXMLResponse"] || [elementName isEqualToString:@"ListVehiclesByKeywordStatusXMLResponse"])
    {
        NSLog(@"pageNumberCnt = %d",pageNumberCount);
        NSLog(@"isSearchPopUpView = %d",isSearchPopUpView);
        
        //if(isInitialSearchLoad)
           // arrayTempVehicles = [arrayOfStockList mutableCopy];
        
        NSLog(@"arrayTempVehicles = %lu",(unsigned long)arrayTempVehicles.count);
         NSLog(@"arrayOfStockList = %lu",(unsigned long)arrayOfStockList.count);
        
        if(pageNumberCount >= 0 && isSearchPopUpView) // this is for popup with search
        {
            if (arrayOfStockList.count!=0)
            {
                BOOL doesContain = [self.view.subviews containsObject:popUpView];
                if(doesContain)
                {
                    
                    [popUpView getTheDropDownData:arrayOfStockList withVariant:YES withVehicle:YES isPagination:YES]; // array to be passed for custom popup dropdown
                    [self hideProgressHUD];
                    
                }
                else
                {
                    
                    
                    /*************  your Request *******************************************************/
                    NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpSearchTableView" owner:self options:nil];
                    popUpView = [arrLoadNib objectAtIndex:0];
                    popUpView.paginationDelegateSearch = self;
                    
                    [popUpView getTheDropDownData:arrayOfStockList withVariant:YES withVehicle:YES isPagination:NO]; // array to be passed for custom popup dropdown
                    
                    [self.view addSubview:popUpView];
                    
                    [SMCustomPopUpSearchTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int selectedYear, NSString *strVehicleStockId) {
                        NSLog(@"selected text = %@",selectedTextValue);
                        NSLog(@"%@",arrayOfStockList);
                        
                        
                        NSPredicate *pred = [NSPredicate predicateWithFormat:@"strStockId == %@",strVehicleStockId];
                        NSArray *arrSearchedObjects = [arrayOfStockList filteredArrayUsingPredicate:pred];
                        SMDropDownObject *objSearch = [arrSearchedObjects objectAtIndex:0];
                        NSLog(@"selected Year2 = %d",selectedYear);
                        txtListAll.text = selectedTextValue;
                        NSLog(@"%@",objSearch.strMakeName);
                        vehicleYear = selectedYear;
                        vehicleMakeId = [objSearch.strMakeId intValue];
                        vehicleModelId = [objSearch.strModelId intValue];
                        vehicleVariantId = [objSearch.strVariantId intValue];
                        strSelectedVinNo = objSearch.strVINNo;
                        strSelectedRegNo = objSearch.strRegNo;
                        
                    }];
                    
                    
                    [self hideProgressHUD];
                }
            }
            else
            {
                NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
                SMDropDownObject *tempObj = [[SMDropDownObject alloc] init];
                tempObj.strMakeName = @"No record(s) found.";
                [arrTemp addObject:tempObj];
                
                [popUpView getTheDropDownData:arrTemp withVariant:YES withVehicle:NO isPagination:NO]; // array to be passed for custom popup dropdown
                [self hideProgressHUD];

            }
        }
        else // this is for popup without search
        {
            if (arrayOfStockList.count!=0)
            {
                BOOL doesContain = [self.view.subviews containsObject:popUpViewNoSearch];
                if(doesContain)
                {
                    
                    [popUpViewNoSearch getTheDropDownData:arrayOfStockList withVariant:NO andIsPagination:YES ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
                    
                   
                    
                    [self hideProgressHUD];
                    
                }
               
            }
        }
        [self hideProgressHUD];
    }
    //get make data
    NSData *data = [currentNodeContent dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObject=[NSJSONSerialization
                              JSONObjectWithData:data
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    
    if ([elementName isEqualToString:@"ListDealerMakesOpenJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {//// this is for Data For PopUpView
                loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
                loadVehiclesObject.strMakeId   = dictionary[@"makeID"];
                loadVehiclesObject.strMakeName = dictionary[@"makeName"];
                
                [arrayOfDealerMakes addObject:loadVehiclesObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
        
    }
    
    if ([elementName isEqualToString:@"ListDealerMakesJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {//// this is for Data For PopUpView
                loadVehiclesObject=[[SMLoadVehiclesObject alloc]init];
                loadVehiclesObject.strMakeId   = dictionary[@"makeID"];
                loadVehiclesObject.strMakeName = dictionary[@"makeName"];
                
                [arrayOfDealerMakes addObject:loadVehiclesObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
        
    }
    
    //get model data
    
    if ([elementName isEqualToString:@"ListDealerModelsJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                ObjectDropDownObject             =[[SMDropDownObject alloc]init];
                ObjectDropDownObject.strMakeId   =dictionary[@"modelID"];
                ObjectDropDownObject.strMakeName =dictionary[@"modelName"];
                [arrayOfDealerModels  addObject:ObjectDropDownObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
    }
    
    if ([elementName isEqualToString:@"ListDealerModelsOpenJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                ObjectDropDownObject             =[[SMDropDownObject alloc]init];
                ObjectDropDownObject.strMakeId   =dictionary[@"modelID"];
                ObjectDropDownObject.strMakeName =dictionary[@"modelName"];
                [arrayOfDealerModels  addObject:ObjectDropDownObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
    }
    
    //get varient data
    if ([elementName isEqualToString:@"ListDealerVariantsJSONResult"] || [elementName isEqualToString:@"ListDealerVariantsOpenJSONResult"])
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
                [arrayOfDealerVariants          addObject:loadVehiclesObject];
            }
        }
        else
        {
            SMAlert(KLoaderTitle,[jsonObject valueForKey:@"message"]);
        }
        
    }
    
    // end of xml parsing
    
    if ([elementName isEqualToString:@"ListDealerMakesOpenJSONResponse"])
    {
        if (arrayOfDealerMakes.count!=0)
        {
            [txtModel        setText:@""];
            [txtVariant     setText:@""];
            
            
            [searchMakeVC getTheDropDownData:arrayOfDealerMakes];
            [self.view addSubview:searchMakeVC];
            
            [SMReusableSearchTableViewController getTheSelectedSearchDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                
                
                txtMake.text = selectedTextValue;
                vehicleMakeId = selectIDValue;
                
                
            }];
            
            [self hideProgressHUD];
            
        }
    }
    if ([elementName isEqualToString:@"ListDealerMakesJSONResponse"])
    {
        if (arrayOfDealerMakes.count!=0)
        {
            [txtModel        setText:@""];
            [txtVariant     setText:@""];
            
            
            [searchMakeVC getTheDropDownData:arrayOfDealerMakes];
            [self.view addSubview:searchMakeVC];
            
            [SMReusableSearchTableViewController getTheSelectedSearchDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                
                
                txtMake.text = selectedTextValue;
                vehicleMakeId = selectIDValue;
                
                
            }];
            
            [self hideProgressHUD];
            
        }
    }
    if ([elementName isEqualToString:@"ListDealerModelsJSONResponse"] || [elementName isEqualToString:@"ListDealerModelsOpenJSONResponse"])
    {
        if (arrayOfDealerModels.count!=0)
        {
            [txtVariant setText:@""];
            //modelArray.count>0 ?[self loadPopup]:SMAlert(KLoaderTitle,KNorecordsFousnt);
            
            /*************  your Request *******************************************************/
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView1 = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView1 getTheDropDownData:arrayOfDealerModels withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView1];
            
            /*************  your Request *******************************************************/
            
            
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                
                txtModel.text = selectedTextValue;
                selectedModelId = selectIDValue;
                vehicleModelId = selectIDValue;
            }];
            
            
            [self hideProgressHUD];
        }
    }
    if ([elementName isEqualToString:@"ListDealerVariantsJSONResponse"] || [elementName isEqualToString:@"ListDealerVariantsOpenJSONResponse"])
    {
        if (arrayOfDealerVariants.count!=0)
        {
            //modelArray.count>0 ?[self loadPopup]:SMAlert(KLoaderTitle,KNorecordsFousnt);
            
            /*************  your Request *******************************************************/
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView1 = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView1 getTheDropDownData:arrayOfDealerVariants withVariant:YES andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView1];
            
            /*************  your Request *******************************************************/
            
            
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                
                txtVariant.text = selectedTextValue;
                vehicleVariantId = selectIDValue;
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
            SMCustomPopUpTableView *popUpView1 = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView1 getTheDropDownData:arrmForVariant withVariant:YES andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView1];
            
            /*************  your Request *******************************************************/
            
            
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                selectedVariantId = selectIDValue;
                vehicleVariantId =  selectIDValue;
                txtVariant.text = selectedTextValue;
            }];
            
            
            [self hideProgressHUD];
        }
    }
    
    
    if ([elementName isEqualToString:@"ImageUrl"]) {
        
        objSMSynopsisResult.strVariantImage = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Year"]) {
        
        objSMSynopsisResult.intYear = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"year"])
    {
        variantDropdownObject.strMakeYear = currentNodeContent;
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
    if ([elementName isEqualToString:@"vin"]) {
        objSMSynopsisResult.strVINNo = currentNodeContent;
        vehicleObject.strVINNo = currentNodeContent;
    }
    if ([elementName isEqualToString:@"registration"]) {
        
        if ([currentNodeContent isEqualToString:@"No Registration"]) {
            objSMSynopsisResult.strRegNo = @"";
            vehicleObject.strRegNo = @"";
        }else{
        objSMSynopsisResult.strRegNo = currentNodeContent;
        vehicleObject.strRegNo = currentNodeContent;
        }
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
    if ([elementName isEqualToString:@"TradePrice"]) {
        
        objSMSynopsisResult.pricingTraderPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"RetailPrice"]) {
        objSMSynopsisResult.pricingRetailPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];

    }
    if ([elementName isEqualToString:@"PrivateAdvertsPrice"]) {
        objSMSynopsisResult.pricingPrivateAdvertPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];

    }
    if ([elementName isEqualToString:@"SimpleLogicTradePrice"]) {
        objSMSynopsisResult.pricingSLTradePrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];

    }
    if ([elementName isEqualToString:@"SimpleLogicRetailPrice"]) {
        objSMSynopsisResult.pricingSLRetailPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];

    }
    if ([elementName isEqualToString:@"TUATradePrice"]) {
        objSMSynopsisResult.pricingTUATradePrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];

    }
    if ([elementName isEqualToString:@"TUARetailPrice"]) {
        objSMSynopsisResult.pricingTUARetailPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];

    }
    if ([elementName isEqualToString:@"SeachDateTime"]) {
        objSMSynopsisResult.strTUASearchDateTime = currentNodeContent;

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
    
    if ([elementName isEqualToString:@"GetSynopsisXmlResponse"])
    {
        
        [self hideProgressHUD];
        
        if(objSMSynopsisResult.arrVariantDetails == nil && [objSMSynopsisResult.strMakeName length]== 0)
        {
            
                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Error while loading data. Please try again later." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                    if (didCancel)
                    {
                        return ;
                    }
                    
                }];
            
        
        }
        else
        {
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
                //            vcSMSynopsisVehicleLookUpViewController.selectedYear = selectedYear;
                //            vcSMSynopsisVehicleLookUpViewController.selectedMake = selectedMakeId;
                //            vcSMSynopsisVehicleLookUpViewController.selectedModel = selectedModelId;
                //            vcSMSynopsisVehicleLookUpViewController.selectedVariant = selectedVariantId;
                [self.navigationController pushViewController:vcSMSynopsisVehicleLookUpViewController animated:NO];
            }
        }
        
    }

    
    
}

-(void)requestForThePagination
{
     pageNumberCount++;
    NSLog(@"pageNumberCount from delegate = %d",pageNumberCount);
   // isInitialSearchLoad = NO;
    [self loadPhotosAndExtrasWSWithStatusID:1 andSortText:@"friendlyname"];

}

-(void)requestForThePaginationSearchWithIsFirstPagination:(BOOL)isFirstPagination
{

      if(isFirstPagination)
      {
          [arrayOfStockList removeAllObjects];
          pageNumberCount = 0;
      }
     else
     {
        pageNumberCount++;
     }
    /*if(isInitialSearchLoad)
    {
               isInitialSearchLoad = NO;
    }*/
    [self loadPhotosAndExtrasWSWithStatusID:1 andSortText:@"friendlyname"];

}

-(void)requestForTheSearchListWithSearchKeyword:(NSString*)searchText withIsFirstSearch:(BOOL) isFirstSearch
{
        
    if(isFirstSearch)
    {
        [arrayOfStockList removeAllObjects];
        pageNumberCount = 0;
    }
    else
    {
        pageNumberCount++;
    }
    
    [self loadPhotosAndExtrasWithSearchWSWithStatusCode:1 andSearchTextText:searchText];
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
#pragma mark - WEB Services


-(void) loadMakeIsWithYear:(BOOL)isWithYear
{
    NSMutableURLRequest *requestURL;
    
    if(isWithYear)
    {
        requestURL=[SMWebServices listDealerMakesJSON:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue year:[NSString stringWithFormat:@"%d",vehicleYear]];
    }
    else
    {
        requestURL=[SMWebServices listDealerMakesOpenXML:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
    }
    
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
             arrayOfDealerMakes = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             [self hideProgressHUD];
         }
     }];
    
}

-(void)loadModelsListingIsWithYear:(BOOL)isWithYear
{
    
    NSMutableURLRequest *requestURL;
    
    if(isWithYear)
    {
        requestURL=[SMWebServices listDealerModelJSON:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue year:vehicleYear makeID:vehicleMakeId];
    }
    else
    {
        requestURL=[SMWebServices listDealerModelOpenJSON:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue makeID:vehicleMakeId];
    }
    
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
             
             arrayOfDealerModels = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
    
}

-(void)loadVarientsListing
{
     NSMutableURLRequest *requestURL= [SMWebServices listDealerStockVariants:[SMGlobalClass sharedInstance].hashValue clientID:[SMGlobalClass sharedInstance].strClientID.intValue modelID:vehicleModelId];
    
    
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
             arrayOfDealerVariants = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)getTheSynopsisDetails
{
    if(vehicleYear == 0)
        vehicleYear = 2016;
    
    NSMutableURLRequest *requestURL=[SMWebServices getSynopsisSummaryWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:vehicleYear andMakeId:vehicleMakeId andModelId:vehicleModelId andVariantId:vehicleVariantId andVIN:strSelectedVinNo andKiloMeters:@"" andExtrasCost:@"" andCondition:@""];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSforSummaryDetails *wsSMWSforSummaryDetails = [[SMWSforSummaryDetails alloc]init];
    [wsSMWSforSummaryDetails responseForWebServiceForReuest:requestURL response:^(SMSynopsisXMLResultObject *objSMSynopsisXMLResultObject) {
        
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        [self hideProgressHUD];
        
        switch (objSMSynopsisXMLResultObject.iStatus) {
            
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
                
            default:{
                [SMAttributeStringFormatObject handleWebServiceErrorForCode:objSMSynopsisXMLResultObject.iStatus ForViewController:self withGOBack:NO];
            }
                break;
        }
    } andError:^(NSError *error) {
        SMAlert(@"Error", error.localizedDescription);
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        [self hideProgressHUD];
        
    }];

    
}


- (IBAction)btnContinueToVerificationDidClicked:(id)sender {
    
    if([txtListAll.text length] == 0 && [txtMake.text length] == 0)
    {
        SMAlert(KLoaderTitle, @"Please select inputs.");
    }
    else
    {
        if([txtMake.text length]>0 && [txtModel.text length] == 0)
        {
            SMAlert(KLoaderTitle, KModelSelection);
        }
        else if ([txtModel.text length]>0 && [txtVariant.text length] == 0)
        {
            SMAlert(KLoaderTitle, KVariantSelection);
        }
        else
        {
            [self continueToVerification];
        }
    }

}

-(void)continueToVerification{
    if(vehicleYear == 0)
        vehicleYear = 2016;
    

    SMSynopsisVerifyVINViewController *synopsisVerifyVINViewController;
    synopsisVerifyVINViewController = [[SMSynopsisVerifyVINViewController alloc] initWithNibName:@"SMSynopsisVerifyVINViewController" bundle:nil];
    synopsisVerifyVINViewController.previousPageNumber = 2;
    synopsisVerifyVINViewController.strMainVehicleYear =[NSString stringWithFormat:@"%d",vehicleYear];
    
    if (txtMake.text.length == 0 || txtModel.text==0) {
      synopsisVerifyVINViewController.strMainVehicleName =txtListAll.text;
    }else{
    synopsisVerifyVINViewController.strMainVehicleName = [NSString stringWithFormat:@"%@ %@",txtMake.text,txtModel.text];
    }
    synopsisVerifyVINViewController.strSelectedMakeID = vehicleMakeId;
    synopsisVerifyVINViewController.strSelectedModelID = vehicleModelId;
    synopsisVerifyVINViewController.strSelectedVariantID = vehicleVariantId;
    synopsisVerifyVINViewController.strSelectedVINNumber = strSelectedVinNo;
    synopsisVerifyVINViewController.strSelectedKiloMeters = @"";
    synopsisVerifyVINViewController.strSelectedExtrasCost = @"";
    synopsisVerifyVINViewController.strSelectedCondition = @"";
    synopsisVerifyVINViewController.strSelectedMMCode=@"";
    synopsisVerifyVINViewController.strSelectedRegNo = strSelectedRegNo;
    [self.navigationController pushViewController:synopsisVerifyVINViewController animated:YES];

}
@end
