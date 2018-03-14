//
//  SMRealTimeOnlineViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 21/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMRealTimeOnlineViewController.h"
#import "SMCustomTextFieldForDropDown.h"
#import "SMSMRealTimeOnlineViewCell.h"
#import "SMCustomPopUpTableView.h"
#import "SMDropDownObject.h"
#import "SMCustomColor.h"
@interface SMRealTimeOnlineViewController ()
{
    
    IBOutlet UITableView *tblRealTimeOnline;
    
    IBOutlet SMCustomTextFieldForDropDown *txtDealership;
    IBOutlet UIView *viewHeaderTable;
    
    NSArray *arrDealership;
    NSMutableArray *arrmTitle;
    NSMutableArray *arrm90Days;
    NSMutableArray *arrmRightNow;
    NSMutableArray *arrayOfAdvertRegions;
    
    NSString *strGroupName;
    int groupId;
    
    NSString *strCityName;
    int cityId;
    
    NSString *strProvinceName;
    int provinceId;
    
    MBProgressHUD *HUD;
    SMDropDownObject *ObjectDropDownObject;
    
    //*******************   Online Price details  **********************
    
    
    
}
@end

@implementation SMRealTimeOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addingProgressHUD];
    
   
    ifIphone{
        lblAdvertRegion.font = [UIFont fontWithName:FONT_NAME_BOLD size:17.0f];
    }else{
        lblAdvertRegion.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
    }

    
    if(self.screenNumberComingFrom == 1)
    {
        arrmTitle = [[NSMutableArray alloc] initWithObjects:@"Avg. Retail",@"Highest Retail",@"Lowest Retail",@"Avg. Km",@"Ad Count",@"Outlier Ads Excl.", nil];
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Online Pricing Now"];
        txtDealership.hidden = NO;
        lblNational.hidden = YES;
        lblAdvertRegion.text = @"Advert Region";
        [self loadRetailPricingForNationalWithVariantID:self.selectedVariantID andYear:self.selectedYear];
    }
    else if(self.screenNumberComingFrom == 2)
    {
        arrmTitle = [[NSMutableArray alloc] initWithObjects:@"Avg. Trade",@"Highest Trade",@"Lowest Trade",@"Avg. Km",@"Ad Count",@"Outlier Ads Excl.", nil];
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Trade Prices"];
        lblHeading1.text = @"iX Trader";
        lblRedNote.text = @"'Now' includes iX Trader adverts active now plus the last 30 days. '90 days' includes iX Trader adverts active now plus the last 90 days.";
        txtDealership.hidden = YES;
        lblNational.hidden = NO;
        lblAdvertRegion.text = @"Advert Region:";
        [self loadiXTradePricingForNationalWithVariantID:self.selectedVariantID andYear:self.selectedYear];
    }
    else
    {
        arrmTitle = [[NSMutableArray alloc] initWithObjects:@"Avg. Price",@"Highest Price",@"Lowest Price",@"Avg. Km",@"Ad Count",@"Outlier Ads Excl.", nil];
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Private Adverts"];
        lblHeading1.text = @"Private Ads";
        lblRedNote.text = @"'Now' includes Private adverts active now plus the last 30 days. '90 days' includes Private adverts active now plus the last 90 days.";
        txtDealership.hidden = YES;
        lblNational.hidden = NO;
        lblAdvertRegion.text = @"Advert Region:";
         [self loadPrivateAdvertsPricingForNationalWithVariantID:self.selectedVariantID andYear:self.selectedYear];
    }
    
    
    arrmRightNow = [[NSMutableArray alloc] init];
     arrm90Days = [[NSMutableArray alloc] init];

    tblRealTimeOnline.estimatedRowHeight = 30.0f;
    tblRealTimeOnline.rowHeight = UITableViewAutomaticDimension;
    tblRealTimeOnline.tableHeaderView = viewHeaderTable;
    tblRealTimeOnline.tableFooterView = viewTableFooter;
    [tblRealTimeOnline registerNib:[UINib nibWithNibName:@"SMSMRealTimeOnlineViewCell" bundle:nil] forCellReuseIdentifier:@"SMSMRealTimeOnlineViewCell"];
    
    

  
}


/*-(void) getConditionDropDown{
    
    
    for(int i=0;i<5;i++)
    {
        SMDropDownObject *objCondition = [[SMDropDownObject alloc] init];
        objCondition.strMakeId = [NSString stringWithFormat:@"%d",i+1];
        objCondition.strMakeName = [arrDealership objectAtIndex:i];
        [arrmDealership addObject:objCondition];
    }
    
}*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrm90Days.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMSMRealTimeOnlineViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SMSMRealTimeOnlineViewCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor blackColor];
    cell.lblTitle.text =[arrmTitle objectAtIndex:indexPath.row];
    cell.lblRightNow.text = [arrmRightNow objectAtIndex:indexPath.row];
    cell.lbl90Days.text = [arrm90Days objectAtIndex:indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Text Field Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   
        [self.view endEditing:YES];
        /*************  your Request *******************************************************/
        [textField resignFirstResponder];
         if(arrayOfAdvertRegions.count == 0 && self.screenNumberComingFrom == 1)
             [self loadRegionsDropdown];
        else
        {
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            ObjectDropDownObject=[[SMDropDownObject alloc]init];
            ObjectDropDownObject.strMakeId = @"00";
            ObjectDropDownObject.strMakeName = @"";
            [arrayOfAdvertRegions addObject:ObjectDropDownObject];
            [popUpView getTheDropDownData:arrayOfAdvertRegions withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected MakeID = %d",selectIDValue);
                NSLog(@"selected ModelID = %d",minYear);
                txtDealership.text = selectedTextValue;
                
                switch (maxYear) {
                    case 0:
                    {
                        [self loadRetailPricingForCityWithVariantID:self.selectedVariantID andYear:self.selectedYear andCityID:cityId];
                    }
                        break;
                    case 1:
                    {
                        [self loadRetailPricingForProvinceWithVariantID:self.selectedVariantID andYear:self.selectedYear andProvinceID:provinceId];
                    }
                        break;
                    case 2:
                    {
                        [self loadRetailPricingForNationalWithVariantID:self.selectedVariantID andYear:self.selectedYear];
                    }
                        break;
                    case 3:
                    {
                        [self loadRetailPricingForGroupWithVariantID:self.selectedVariantID andYear:self.selectedYear andGroupID:groupId];
                    }
                        break;
                    case 4:
                    {
                        [self loadRetailPricingForGroupAndCityWithVariantID:self.selectedVariantID andYear:self.selectedYear andGroupID:groupId andCityID:cityId];
                    }
                        break;
                    case 5:
                    {
                        [self loadRetailPricingForGroupAndProvinceWithVariantID:self.selectedVariantID andYear:self.selectedYear andGroupID:groupId andProvinceID:provinceId];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                
                
            }];
            
            /*************  your Response *******************************************************/
        }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
}

#pragma mark - Webservice Integration

-(void)loadRegionsDropdown
{
    
    NSMutableURLRequest *requestURL=[SMWebServices getAdvertRegionsList:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
   
    
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
             
             arrayOfAdvertRegions = [[NSMutableArray alloc] init];
             isOnlinePricesParsing = NO;
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
    
}

-(void)loadRetailPricingForCityWithVariantID:(int) variantID andYear:(int) year andCityID:(int) cityID
{
    
    NSMutableURLRequest *requestURL=[SMWebServices loadRetailPricingForCity:[SMGlobalClass sharedInstance].hashValue andVariantID:variantID year:year cityID:cityID];
    
        
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
             
             
             isOnlinePricesParsing = YES;
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
         
     }];
    
}

-(void)loadRetailPricingForProvinceWithVariantID:(int) variantID andYear:(int) year andProvinceID:(int) provinceID
{
    
    NSMutableURLRequest *requestURL=[SMWebServices loadRetailPricingForProvince:[SMGlobalClass sharedInstance].hashValue andVariantID:variantID year:year provinceID:provinceID];
    
    
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
             
            
             isOnlinePricesParsing = YES;
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
         
     }];
    
}

-(void)loadRetailPricingForNationalWithVariantID:(int) variantID andYear:(int) year
{
    
    NSMutableURLRequest *requestURL=[SMWebServices loadRetailPricingForNational:[SMGlobalClass sharedInstance].hashValue andVariantID:variantID year:year];
    
    
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
             
             isOnlinePricesParsing = YES;
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
         
     }];
    
}

-(void)loadRetailPricingForGroupWithVariantID:(int) variantID andYear:(int) year andGroupID:(int) groupID
{
    
    NSMutableURLRequest *requestURL=[SMWebServices loadRetailPricingForGroup:[SMGlobalClass sharedInstance].hashValue andVariantID:variantID year:year groupID:groupID];
    
    
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
             
             isOnlinePricesParsing = YES;
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
         
     }];
    
}

-(void)loadRetailPricingForGroupAndCityWithVariantID:(int) variantID andYear:(int) year andGroupID:(int) groupID andCityID:(int) cityID
{
    
    NSMutableURLRequest *requestURL=[SMWebServices loadRetailPricingForGroupCity:[SMGlobalClass sharedInstance].hashValue andVariantID:variantID year:year groupID:groupID cityID:cityID];
    
    
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
            
             isOnlinePricesParsing = YES;
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
         
     }];
    
}

-(void)loadRetailPricingForGroupAndProvinceWithVariantID:(int) variantID andYear:(int) year andGroupID:(int) groupID andProvinceID:(int) provinceID
{
    
    NSMutableURLRequest *requestURL=[SMWebServices loadRetailPricingForGroupProvince:[SMGlobalClass sharedInstance].hashValue andVariantID:variantID year:year groupID:groupID provinceID:provinceID];
    
    
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
             
             
             isOnlinePricesParsing = YES;
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
         
     }];
    
}

// ********************* Request For iXTrader screen

-(void)loadiXTradePricingForNationalWithVariantID:(int) variantID andYear:(int) year
{
    
    NSMutableURLRequest *requestURL=[SMWebServices loadiXTraderPricingForNational:[SMGlobalClass sharedInstance].hashValue andVariantID:variantID year:year];
    
    
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
             
             
             isOnlinePricesParsing = YES;
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
         
     }];
    
}

-(void)loadPrivateAdvertsPricingForNationalWithVariantID:(int) variantID andYear:(int) year
{
    
    NSMutableURLRequest *requestURL=[SMWebServices loadPrivatePricingForNational:[SMGlobalClass sharedInstance].hashValue andVariantID:variantID year:year];
    
    
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
             
             
             isOnlinePricesParsing = YES;
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate:self];
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
    if ([elementName isEqualToString:@"GroupID"])
    {
        ObjectDropDownObject=[[SMDropDownObject alloc]init];
    }
    if ([elementName isEqualToString:@"CityID"])
    {
        ObjectDropDownObject=[[SMDropDownObject alloc]init];
    }
    if ([elementName isEqualToString:@"ProvinceID"])
    {
        ObjectDropDownObject=[[SMDropDownObject alloc]init];
    }
    if ([elementName isEqualToString:@"PricingHistory"])
    {
        if(arrm90Days.count>0 && arrmRightNow.count>0)
        {
            [arrmRightNow removeAllObjects];
            [arrm90Days removeAllObjects];
        }
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
    
    if(!isOnlinePricesParsing)
    {
        if ([elementName isEqualToString:@"CityID"])
        {
            ObjectDropDownObject.strMakeId = currentNodeContent;
            cityId = currentNodeContent.intValue;
        }
        if ([elementName isEqualToString:@"CityName"])
        {
            ObjectDropDownObject.strMakeName = currentNodeContent;
            [arrayOfAdvertRegions addObject:ObjectDropDownObject];
            strCityName = currentNodeContent;
        }
        if ([elementName isEqualToString:@"ProvinceID"])
        {
            ObjectDropDownObject.strMakeId = currentNodeContent;
            provinceId = currentNodeContent.intValue;
        }
        if ([elementName isEqualToString:@"ProvinceName"])
        {
            ObjectDropDownObject.strMakeName = currentNodeContent;
            [arrayOfAdvertRegions addObject:ObjectDropDownObject];
            strProvinceName = currentNodeContent;
        }
        if ([elementName isEqualToString:@"GroupID"])
        {
            if (currentNodeContent.length == 0) {
                [SMAttributeStringFormatObject showAlertWebServicewithMessage:KNoGroupDataFound ForViewController:self];
            }
            groupId = currentNodeContent.intValue;
        }
        if ([elementName isEqualToString:@"GroupName"])
        {
            strGroupName = currentNodeContent;
        }
        if ([elementName isEqualToString:@"AdvertRegion"])
        {
            ObjectDropDownObject=[[SMDropDownObject alloc]init];
            ObjectDropDownObject.strMakeId = @"1";
            ObjectDropDownObject.strMakeName = @"National";
            [arrayOfAdvertRegions addObject:ObjectDropDownObject];
            
            ObjectDropDownObject=[[SMDropDownObject alloc]init];
            ObjectDropDownObject.strMakeId = [NSString stringWithFormat:@"%d",groupId];
            ObjectDropDownObject.strMakeName = [NSString stringWithFormat:@"%@ Dealers",strGroupName];
            [arrayOfAdvertRegions addObject:ObjectDropDownObject];
            
            ObjectDropDownObject=[[SMDropDownObject alloc]init];
            ObjectDropDownObject.strMakeId = [NSString stringWithFormat:@"%d",groupId];
            ObjectDropDownObject.strModelId = [NSString stringWithFormat:@"%d",cityId];
            ObjectDropDownObject.strMakeName = [NSString stringWithFormat:@"%@ %@ Dealers",strGroupName,strCityName];
            [arrayOfAdvertRegions addObject:ObjectDropDownObject];
            
            ObjectDropDownObject=[[SMDropDownObject alloc]init];
            ObjectDropDownObject.strMakeId = [NSString stringWithFormat:@"%d",groupId];
            ObjectDropDownObject.strModelId = [NSString stringWithFormat:@"%d",provinceId];
            ObjectDropDownObject.strMakeName = [NSString stringWithFormat:@"%@ %@ Dealers",strGroupName,strProvinceName];
            [arrayOfAdvertRegions addObject:ObjectDropDownObject];
            
            ObjectDropDownObject=[[SMDropDownObject alloc]init];
            ObjectDropDownObject.strMakeId = @"00";
            ObjectDropDownObject.strMakeName = @"";
            [arrayOfAdvertRegions addObject:ObjectDropDownObject];
            
            
        }
        if ([elementName isEqualToString:@"LoadAdvertRegionForClientResult"])
        {
            [self hideProgressHUD];
            
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            
            [popUpView getTheDropDownData:arrayOfAdvertRegions withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                NSLog(@"selected ModleID = %d",minYear);
                txtDealership.text = selectedTextValue;
                
                switch (maxYear) {
                    case 0:
                    {
                        [self loadRetailPricingForCityWithVariantID:self.selectedVariantID andYear:self.selectedYear andCityID:cityId];
                    }
                    break;
                    case 1:
                    {
                       [self loadRetailPricingForProvinceWithVariantID:self.selectedVariantID andYear:self.selectedYear andProvinceID:provinceId];
                    }
                        break;
                    case 2:
                    {
                            [self loadRetailPricingForNationalWithVariantID:self.selectedVariantID andYear:self.selectedYear];
                    }
                        break;
                    case 3:
                    {
                        [self loadRetailPricingForGroupWithVariantID:self.selectedVariantID andYear:self.selectedYear andGroupID:groupId];
                    }
                        break;
                    case 4:
                    {
                       [self loadRetailPricingForGroupAndCityWithVariantID:self.selectedVariantID andYear:self.selectedYear andGroupID:groupId andCityID:cityId];
                    }
                        break;
                    case 5:
                    {
                        [self loadRetailPricingForGroupAndProvinceWithVariantID:self.selectedVariantID andYear:self.selectedYear andGroupID:groupId andProvinceID:provinceId];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                
                
                
            }];
            
        }
    }
    else
    {
        int finalInt = currentNodeContent.intValue;
        
        
        if ([elementName isEqualToString:@"RetailAvg30Days"] || [elementName isEqualToString:@"TradeAvg30Days"] || [elementName isEqualToString:@"PrivateAdvertsAvg30Days"])
        {
            [arrmRightNow addObject:[NSString stringWithFormat:@"%@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",finalInt]]]];
            
           // objSMVINHistoryObject.strMileage = [[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent];
            
        }
        if ([elementName isEqualToString:@"RetailHigh30Days"] || [elementName isEqualToString:@"TradeHigh30Days"] || [elementName isEqualToString:@"PrivateAdvertsHigh30Days"])
        {
            [arrmRightNow addObject:[NSString stringWithFormat:@"%@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",finalInt]]]];
        }
        if ([elementName isEqualToString:@"RetailLow30Days"] || [elementName isEqualToString:@"TradeLow30Days"] || [elementName isEqualToString:@"PrivateAdvertsLow30Days"])
        {
            [arrmRightNow addObject:[NSString stringWithFormat:@"%@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",finalInt]]]];
        }
        if ([elementName isEqualToString:@"MileageAvg30Days"])
        {
            [arrmRightNow addObject:[NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:[NSString stringWithFormat:@"%d",finalInt]]]];
        }
        if ([elementName isEqualToString:@"AdvertsCount30Days"])
        {
            [arrmRightNow addObject:[NSString stringWithFormat:@"%d",finalInt]];
        }
        if ([elementName isEqualToString:@"AdvertsExcludedCount30Days"])
        {
            [arrmRightNow addObject:[NSString stringWithFormat:@"%d",finalInt]];
        }
        if ([elementName isEqualToString:@"RetailAvg90Days"] || [elementName isEqualToString:@"TradeAvg90Days"] || [elementName isEqualToString:@"PrivateAdvertsAvg90Days"])
        {
            [arrm90Days addObject:[NSString stringWithFormat:@"%@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",finalInt]]]];
        }
        if ([elementName isEqualToString:@"RetailHigh90Days"] || [elementName isEqualToString:@"TradeHigh90Days"] || [elementName isEqualToString:@"PrivateAdvertsHigh90Days"])
        {
            [arrm90Days addObject:[NSString stringWithFormat:@"%@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",finalInt]]]];
        }
        if ([elementName isEqualToString:@"RetailLow90Days"] || [elementName isEqualToString:@"TradeLow90Days"] || [elementName isEqualToString:@"PrivateAdvertsLow90Days"])
        {
            [arrm90Days addObject:[NSString stringWithFormat:@"%@",[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",finalInt]]]];
        }
        if ([elementName isEqualToString:@"MileageAvg90Days"])
        {
            [arrm90Days addObject:[NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:[NSString stringWithFormat:@"%d",finalInt]]]];
            NSLog(@"-=-=-=-=- %@",[NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:[NSString stringWithFormat:@"%d",finalInt]]]);
        }
        if ([elementName isEqualToString:@"AdvertsCount90Days"])
        {
            [arrm90Days addObject:[NSString stringWithFormat:@"%d",finalInt]];
        }
        if ([elementName isEqualToString:@"AdvertsExcludedCount90Days"])
        {
            [arrm90Days addObject:[NSString stringWithFormat:@"%d",finalInt]];
        }
        if ([elementName isEqualToString:@"PricingHistory"])
        {
            tblRealTimeOnline.dataSource = self;
            tblRealTimeOnline.delegate = self;
        }
        if ([elementName isEqualToString:@"LoadRetailPricingHistoryForGroupResult"])
        {
            [self hideProgressHUD];
            [tblRealTimeOnline reloadData];
        }
        if ([elementName isEqualToString:@"LoadRetailPricingHistoryForNationalResult"])
        {
            [self hideProgressHUD];
            [tblRealTimeOnline reloadData];
        }
        if ([elementName isEqualToString:@"LoadRetailPricingHistoryForProvinceResult"])
        {
            [self hideProgressHUD];
            [tblRealTimeOnline reloadData];
        }
        if ([elementName isEqualToString:@"LoadRetailPricingHistoryForGroupAndCityResult"])
        {
            [self hideProgressHUD];
            [tblRealTimeOnline reloadData];
        }
        if ([elementName isEqualToString:@"LoadRetailPricingHistoryForGroupAndProvinceResult"])
        {
            [self hideProgressHUD];
            [tblRealTimeOnline reloadData];
        }
        if ([elementName isEqualToString:@"LoadRetailPricingHistoryForCityResult"])
        {
            [self hideProgressHUD];
            [tblRealTimeOnline reloadData];
        }
        if ([elementName isEqualToString:@"LoadTradePricingHistoryForNationalResult"])
        {
            [self hideProgressHUD];
            [tblRealTimeOnline reloadData];
        }
        if ([elementName isEqualToString:@"LoadPrivatePricingHistoryForNationalResult"])
        {
            [self hideProgressHUD];
            [tblRealTimeOnline reloadData];
        }
        
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


@end
