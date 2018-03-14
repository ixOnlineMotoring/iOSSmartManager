//
//  SMSavedScanVinViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 19/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSavedScanVinViewController.h"
#import "SMCustomSavedVINTableViewCell.h"
#import "SMVehiclelisting.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"
#import "SMSynopsisScanDetailViewController.h"
@interface SMSavedScanVinViewController ()
{
    IBOutlet UITableView *tblviewSavedVIN;
    NSMutableArray *arrmForSavedVINScan;
    NSString *strSampleDtetail;
    IBOutlet UIView *viewForHeader;
}
@end

@implementation SMSavedScanVinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self addingProgressHUD];
    arrmForSavedVINScan = [[NSMutableArray alloc] init];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Saved VIN Scans"];

    
    // [self loadSavedVINScans];   //Load the array With Saved VIN Scans for table Datasource and calling Web Service Method
    
    [self setTableView];  //Table View Various Properties and register Nib

   // strSampleDtetail = @"Honda S2000 | Red | 2004 | VIN:12345DGF007D | 23 Oct 2015 12:23";
    // Do any additional setup after loading the view from its nib.
    tblviewSavedVIN.tableFooterView = [[UIView alloc] init];
    
    [self fetchSavedVinScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



#pragma mark - Intialization Methods

///Load the array With Saved VIN Scans for table Datasource and calling Web Service
-(void)loadSavedVINScans{
    
    SMVehiclelisting *objVehicleForSavedVIN = [[SMVehiclelisting alloc] init];
    
//    objVehicleForSavedVIN.strVehicleName;
//    objVehicleForSavedVIN.strVehicleColor;
//    objVehicleForSavedVIN.strVehicleYear;
//    objVehicleForSavedVIN.strVehicleVIN;
//    objVehicleForSavedVIN.strVehicleTeadeTimeLeft;
    
    [arrmForSavedVINScan addObject:objVehicleForSavedVIN];
    
}

///Table View Various Properties and register Nib
-(void) setTableView{
    
    [tblviewSavedVIN registerNib:[UINib nibWithNibName:@"SMCustomSavedVINTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMCustomSavedVINTableViewCell"];
    
    tblviewSavedVIN.tableHeaderView = viewForHeader;
    tblviewSavedVIN.estimatedRowHeight = 30.0f;
    tblviewSavedVIN.rowHeight = UITableViewAutomaticDimension;
       
}
#pragma mark - Table View Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return savedVINScanArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *strMake,*strModel,*strColor,*strYear,*strDateExpires;
    SMCustomSavedVINTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SMCustomSavedVINTableViewCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor blackColor];
    SMVINLookupObject *obj = (SMVINLookupObject*)[savedVINScanArray objectAtIndex:indexPath.row];
    obj.strScannedDate = [self returnTheExpectedDateForGivenString:obj.strScannedDate];
    if ([obj.strYear isKindOfClass:[NSNull class]]) {
        strYear = @"Year?";
    }
    else
    {
        strYear = obj.strYear;
    }
    
    if ([obj.Colour isKindOfClass:[NSNull class]]) {
        strColor = @"Colour?";
    }
    else{
         strColor =obj.Colour;
    }
    
    if ([obj.strScannedDate isKindOfClass:[NSNull class]] || [obj.strScannedDate length] == 0) {
        strDateExpires =@"Date?" ;
    }else{
         strDateExpires =obj.strScannedDate;
    }
    
    if ([obj.Make isKindOfClass:[NSNull class]]) {
        strMake = @"Make?";
    }else{
        strMake = obj.Make;
    }
    
    if ([obj.Model isKindOfClass:[NSNull class]]) {
        strModel = @"Model?";
    }else{
        strModel = obj.Model;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@ %@ |%@ | %@ | VIN:%@ | %@",strMake,strModel,strColor,strYear,obj.VIN,strDateExpires];
    cell.lblTime.text = str;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //SMSynopsisScanDetailViewController  * VINSynonpisDetailsView;
    //    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    //    {
    //        VINSynonpisDetailsView  =[[SMSynopsisScanDetailViewController alloc]initWithNibName:@"SMSynopsisScanDetailViewController" bundle:nil];
    //
    //    }
    //    else
    //    {
    //        VINSynonpisDetailsView  =[[SMSynopsisScanDetailViewController alloc]initWithNibName:@"SMSynopsisScanDetailViewController_iPad" bundle:nil];
    //
    //    }
    
    UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    SMSynopsisScanDetailViewController   *VINSynonpisDetailsView = (SMSynopsisScanDetailViewController* )[tableViewStoryboard instantiateViewControllerWithIdentifier:@"SMSynopsisScanDetailsTableViewController"];
    
    SMVINLookupObject *obj = (SMVINLookupObject*)[savedVINScanArray objectAtIndex:indexPath.row];
    
    if([obj.DateExpires isKindOfClass:[NSNull class]] || [obj.DateExpires length] == 0  || [obj.DateExpires isEqualToString:@"<null>"])
        obj.DateExpires = @"LicExpiry?";
    VINSynonpisDetailsView.VINLookupObject=obj;
    VINSynonpisDetailsView.isFromScanPage = NO;
    [self.navigationController pushViewController:VINSynonpisDetailsView animated:YES];


   /* if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        SMSynopsisVehicleLookUpViewController *vcSMSynopsisVehicleLookUpViewController = [[SMSynopsisVehicleLookUpViewController alloc] initWithNibName:@"SMSynopsisVehicleLookUpViewController" bundle:nil];
        [self.navigationController pushViewController:vcSMSynopsisVehicleLookUpViewController animated:NO];
        
        
    }
    else{
        SMSynopsisVehicleLookUpViewController *vcSMSynopsisVehicleLookUpViewController = [[SMSynopsisVehicleLookUpViewController alloc] initWithNibName:@"SMSynopsisVehicleLookUpViewController_iPad" bundle:nil];
        [self.navigationController pushViewController:vcSMSynopsisVehicleLookUpViewController animated:NO];
        
        
    }*/

    
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
            NSArray *arrayData = [jsonObject valueForKey:@"data"];
            
            if([arrayData count] == 0)
            {
                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:KNorecordsFousnt cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
                 {
                     if (didCancel)
                     {
                         
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                     
                 }];
            
            }
            
            for (NSDictionary *dictionary in jsonObject[@"data"])
            {
                VINLookupObject=[[SMVINLookupObject alloc]init];
                VINLookupObject.Registration=dictionary[@"registration"];;
                VINLookupObject.Shape=dictionary[@"shape"];
                VINLookupObject.Make=dictionary[@"make"];
                VINLookupObject.Model=dictionary[@"model"];
                VINLookupObject.strVariantName=dictionary[@"variant"];
                VINLookupObject.variant = dictionary[@"variantID"];
                VINLookupObject.Colour=dictionary[@"colour"];
                VINLookupObject.VIN=dictionary[@"VIN"];
                VINLookupObject.EngineNo=dictionary[@"engineNo"];
                VINLookupObject.savedScanID=dictionary[@"savedScanID"];
                VINLookupObject.DateExpires=dictionary[@"licenseExpiry"];
                VINLookupObject.strScannedDate=dictionary[@"date"];
                VINLookupObject.strKiloMeters=dictionary[@"kilometers"];
                VINLookupObject.strYear=dictionary[@"year"];
                VINLookupObject.strExtras=dictionary[@"extras"];
                VINLookupObject.strCondition=dictionary[@"condition"];
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
                [tblviewSavedVIN reloadData];
            });
        }
    }
    
    
}


-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
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
#pragma mark - Set Attributed Text

-(NSMutableString *) getMainStringWithSeperatorwithName:(NSString *)strName withColor:(NSString *)strColor withYear:(NSString *)strYear   withVIN:(NSString *)strVIN  withTime:(NSString *)strTime{
    
    NSMutableString *strMainWithSeparator = [[NSMutableString alloc]initWithString:@""];
    [strMainWithSeparator appendFormat:@"%@ | %@ | %@ | %@ | %@",strName,strColor,strYear,strVIN,strTime];
    return strMainWithSeparator;
    
}

-(NSMutableAttributedString *)setAttributedTextForYear:(NSString*)firstText andName:(NSString*)secondText
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
  NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *separatorText = [[NSMutableAttributedString alloc] initWithString:@" | "                                                                                           attributes:FirstAttribute];
    
    

    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    [attributedFirstText appendAttributedString:separatorText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    
    // Set it in our UILabel and we are done!
    return attributedFirstText;
    
}

-(NSMutableAttributedString *)setAttributedTextForVinNumber:(NSString*)firstText colortext:(NSString*)secondText Timetext:(NSString*)thirdText
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSMutableAttributedString *separatorText = [[NSMutableAttributedString alloc] initWithString:@" | "                                                                                           attributes:FirstAttribute];
    

    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:FirstAttribute];
    
    
   
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",thirdText]
                                                                                             attributes:FirstAttribute];
    

    [attributedFirstText appendAttributedString:separatorText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    [attributedFirstText appendAttributedString:separatorText];
    [attributedFirstText appendAttributedString:attributedThirdText];
    // Set it in our UILabel and we are done!
    return attributedFirstText;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
