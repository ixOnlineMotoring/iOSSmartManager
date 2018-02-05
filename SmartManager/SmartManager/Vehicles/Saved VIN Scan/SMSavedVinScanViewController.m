//
//  SMSavedVinScanViewController.m
//  SmartManager
//
//  Created by Priya on 28/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMSavedVinScanViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMSavedVINScanTableViewCell.h"
#import "SMCustomColor.h"
#import "UIBAlertView.h"
@interface SMSavedVinScanViewController ()

@end

@implementation SMSavedVinScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addingProgressHUD];

    self.navigationItem.titleView = lblTitle;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [lblTitle setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14.0f]];
        [self.tableView registerNib:[UINib nibWithNibName:@"SMSavedVINScanTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMSavedVINScanTableViewCell"];
    }
    else
    {
        [lblTitle setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0f]];
        [self.tableView registerNib:[UINib nibWithNibName:@"SMSavedVINScanTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMSavedVINScanTableViewCell"];
    }

    [self.tableView setTableHeaderView:[[UIView alloc] init]];
    [self fetchSavedVinScan];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return savedVINScanArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 101.0 : 130.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMSavedVINScanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMSavedVINScanTableViewCell"];
    SMVINLookupObject *obj = (SMVINLookupObject*)[savedVINScanArray objectAtIndex:indexPath.row];
    
    
    if([obj.DateExpires isKindOfClass:[NSNull class]] || [obj.DateExpires isEqualToString:@"null"] ){
        obj.DateExpires = @"Expiry?";
        cell.lblDate.text=[NSString stringWithFormat:@"%@ | %@",obj.savedScanID, obj.DateExpires];
        
    
    }
    else
    {
        obj.DateExpires = [self returnTheExpectedDateForGivenString:obj.DateExpires];
        cell.lblDate.text=[NSString stringWithFormat:@"%@ | %@",obj.savedScanID, obj.DateExpires];
    }
  
    cell.lblMakeName.text=[NSString stringWithFormat:@"%@ %@",obj.Make, obj.Model];
    cell.lblMakeInfo.text=[NSString stringWithFormat:@"%@ | %@",obj.VIN, obj.Colour];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

#define mark - table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMVINLookupObject *objInDidSelect = (SMVINLookupObject*)[savedVINScanArray objectAtIndex:indexPath.row];
    SMVINScanLookupDetailsViewController *vinDetailViewLookUp;
    if (UI_USER_INTERFACE_IDIOM() ==  UIUserInterfaceIdiomPhone)
    {
         vinDetailViewLookUp = [[SMVINScanLookupDetailsViewController alloc] initWithNibName:@"SMVINScanLookupDetailsViewController" bundle:nil];
    }
    else
    {
    
        vinDetailViewLookUp = [[SMVINScanLookupDetailsViewController alloc] initWithNibName:@"SMVINScanLookupDetailsiPad" bundle:nil];
    }
    
    
    vinDetailViewLookUp.vehicleListDelegates = self;
    
    vinDetailViewLookUp.VINLookupObject = objInDidSelect;
    vinDetailViewLookUp.isFromSaveListing = YES;
    dispatch_async(dispatch_get_main_queue(),^
    {
        [self.navigationController pushViewController:vinDetailViewLookUp animated:YES];
    });
    
}


#pragma mark - fetch saved vin scan
-(void)fetchSavedVinScan
{
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingSavedVINForVehicles:[SMGlobalClass sharedInstance].hashValue clientID:[SMGlobalClass sharedInstance].strClientID];
    
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
             savedVINScanArray = [[NSMutableArray alloc] init];
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
    
    if ([elementName isEqualToString:@"ListSavedVINScansJSONResult"])
    {
        if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ok"])
        {
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
             
                VINLookupObject=[[SMVINLookupObject alloc]init];
                VINLookupObject.Registration=dictionary[@"registration"];;
                VINLookupObject.Shape=dictionary[@"shape"];
                VINLookupObject.Make=dictionary[@"make"];
                VINLookupObject.Model=dictionary[@"model"];
                VINLookupObject.strYear=dictionary[@"year"];
                VINLookupObject.strVariantName=dictionary[@"variant"];
                VINLookupObject.variant=dictionary[@"variantID"];
                VINLookupObject.Colour=dictionary[@"colour"];
                VINLookupObject.VIN=dictionary[@"VIN"];
                VINLookupObject.EngineNo=dictionary[@"engineNo"];
                VINLookupObject.savedScanID=dictionary[@"savedScanID"];
                VINLookupObject.DateExpires=dictionary[@"date"];
                [savedVINScanArray addObject:VINLookupObject];
            }
        
        }
        else
        {
          UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"No scans" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
          [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
            {
                        if (didCancel)
                        {
                    
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    
            }];
        }
    }
    
    
    if ([elementName isEqualToString:@"ListSavedVINScansJSONResponse"])
    {
        if (savedVINScanArray.count!=0)
        {
                // Do something...
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
        }
    }
    
    
}


-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];    
}

-(void) getSavedVINListingRefreshing
{
    [self fetchSavedVinScan];
}
-(NSString*)returnTheExpectedDateForGivenString:(NSString*)inputString
{
    NSArray *filteredPrice = [inputString componentsSeparatedByString:@"."];
    inputString = [filteredPrice objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *requiredDate1 = [dateFormatter dateFromString:inputString];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"dd MMM yyyy HH:mm"];
    NSString *finalDate = [NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:requiredDate1]];
    return finalDate;
    
    
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
