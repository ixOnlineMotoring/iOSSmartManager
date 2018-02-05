//
//  SMCustomerScanViewController.m
//  SmartManager
//
//  Created by Jignesh on 02/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomerScanViewController.h"
#import "SMCustomerTableViewCell.h"
#import "Fontclass.h"
#import "SMCustomerScanDetailViewController.h"
#import "SMCustomColor.h"
#import "SMCustomerDLScanViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"

@interface SMCustomerScanViewController ()

@end

@implementation SMCustomerScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - ViewLifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lblNoRecords.hidden = YES;
    [self addingProgressHUD];
    pageNumberCount=0;
    isLoadMore = NO;
    
    arrayOfDriverLicences = [[NSMutableArray alloc]init];
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Scan License"];
    
    SMAppDelegate *appDelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.refrshObj.refeshDelegate = self;
    
    NSLog(@"refrshObj.refeshDelegate = self %@",appDelegate.refrshObj.refeshDelegate = self);
    
    
    
    cellScrolled = -1;

    [self getTheDriverLicenceListFromServer];
    [self registernibfortable];
}

-(void)refreshTheDLList
{
    NSLog(@"refreshDLMethod");
    pageNumberCount=0;
    isLoadMore = NO;
    
    [arrayOfDriverLicences removeAllObjects];
    
    [self getTheDriverLicenceListFromServer];
}

-(void)pushTheDetailScreenFromTheListingScreen
{
    SMCustomerScanDetailViewController *customerDetails = [[SMCustomerScanDetailViewController alloc] initWithNibName:@"SMCustomerScanDetailViewController" bundle:nil];
    customerDetails.isFromDLListScreen = NO;
    customerDetails.refreshDLListDelegate = self;
    [self.navigationController pushViewController:customerDetails animated:YES];
    
    
}


- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView)
    {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:17.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ViewLifecycle




#pragma mark - Table view datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return arrayOfDriverLicences.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableScanLicenseList)
    {
        return self.mainHeaderView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return self.mainHeaderView.frame.size.height;
    
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMCustomerTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.backgroundColor = [UIColor clearColor];
    
    SMCustomerDetailsDLScanObj *custDetailsObject = (SMCustomerDetailsDLScanObj*)[arrayOfDriverLicences objectAtIndex:indexPath.row];
    
    cell.lblDriverID.text = [NSString stringWithFormat:@"ID: %@",custDetailsObject.customerID];
    cell.lblDriverName.text = custDetailsObject.customerName;
    UIImage *custImage = [self decodeBase64ToImage:custDetailsObject.custPhoto];
    cell.imgDriverImage.image = custImage;
    
    
    //start of code for swipe to delete
    [Fontclass ButtonWithAttributedFont:cell.buttonSearch iconID:450];
    //[Fontclass ButtonWithAttributedFont:cell.buttonSearch iconID:370];
    //cell.buttonSearch.backgroundColor = [UIColor greenColor];
    NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc]init];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:231.0f/255.0f green:0.0f/255.0f blue:18.0f/255.0f alpha:1.0f] title:@"x"];
    // [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor grayColor] title:@"x"];
    cell.rightUtilityButtons    = rightUtilityButtons;
    cell.delegate               = self;
    cell.indexPathCell          = indexPath;
    
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
    
   // NSLog(@"Indexpath.Row = %ld",(long)indexPath.row);
    
    if (arrayOfDriverLicences.count-1 == indexPath.row)
    {
        
        if (arrayOfDriverLicences.count !=totalCount)
        {
            ++pageNumberCount;
            isLoadMore=YES;
            [self getTheDriverLicenceListFromServer];
            
            
        }
        
        
    }
    


    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 85.0;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMCustomerDetailsDLScanObj *custDetailsObject = (SMCustomerDetailsDLScanObj*)[arrayOfDriverLicences objectAtIndex:indexPath.row];
    
    SMCustomerScanDetailViewController *customerDetails = [[SMCustomerScanDetailViewController alloc] initWithNibName:@"SMCustomerScanDetailViewController" bundle:nil];
    
    customerDetails.isFromDLListScreen = YES;
    customerDetails.refreshDLListDelegate = self;

    customerDetails.custDetailsObj = custDetailsObject;
    customerDetails.arrayOfVehicleClass = custDetailsObject.arrayDriverVehicleClasses;
    
    [self.navigationController pushViewController:customerDetails animated:YES];
 
    
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state andIndexpath:(NSIndexPath *)indexpath
{
    
    if (state == kCellStateRight)
    {
        if (cellScrolled==cell.indexPathCell.row)
        {
            return;
        }
        else if (cellScrolled != -1)
        {
            NSIndexPath *myIP = [NSIndexPath indexPathForRow:cellScrolled inSection:0] ;
            SMCustomerTableViewCell *cellcust = (SMCustomerTableViewCell*)[self.tableScanLicenseList cellForRowAtIndexPath:myIP];
            
            [cellcust hideUtilityButtonsAnimated:YES];
        }
        
        cellScrolled=(int)cell.indexPathCell.row;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index andIndexpath:(NSIndexPath*)indexpath
{
    SMCustomerDetailsDLScanObj * scanObject = (SMCustomerDetailsDLScanObj*)[arrayOfDriverLicences objectAtIndex:indexpath.row];
    
    selectedIndexForDelete = (int)indexpath.row;
    [self removeTheSelectedDriverLicenceWithScanID:scanObject.custScanID.intValue];
    
}


-(void)getTheDriverLicenceListFromServer
{
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
  
    
     NSMutableURLRequest *requestURL=[SMWebServices listTheDriverLicencesWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andPageNumber:pageNumberCount andRecordCount:10];
    
    NSLog(@"Request URL = %@",requestURL);
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    isListingDataBeingFetched = YES;

    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         isListingDataBeingFetched = NO;

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
             
             if (!isLoadMore)
             {
                 [arrayOfDriverLicences removeAllObjects];
                 
             }
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
         }
         
     }];
}


-(void)removeTheSelectedDriverLicenceWithScanID:(int)scannedID
{
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
     NSMutableURLRequest *requestURL=[SMWebServices removeTheSelectedDriverLicenceWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andScanID:scannedID];
    
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
    NSLog(@"Parser caleedddd");
    
    if([elementName isEqualToString:@"DrivingLicenseCard"])
    {
        self.custDetailsObj = [[SMCustomerDetailsDLScanObj alloc]init];
        self.arrayOfVehicleClass = [[NSMutableArray alloc]init];

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
        self.custDetailsObj.custDOB = currentNodeContent;
    }
    if([elementName isEqualToString:@"Gender"])
    {
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
        if([currentNodeContent length] == 0)
        {
            self.vehicleClassObj.vehicleClassIssuedDate = @"Issue Date?";
        }
        else
        {
            self.vehicleClassObj.vehicleClassIssuedDate = currentNodeContent;
        }
        
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
        [self.arrayOfVehicleClass addObject:self.vehicleClassObj];
        isIndividualVehicleClassDone = YES;
    }
    if([elementName isEqualToString:@"VehicleClass2"])
    {
        if(!isIndividualVehicleClassDone)
        {
            if(self.vehicleClassObj.vehicleClassRestrictions.length > 0)
            {
                [self.arrayOfVehicleClass addObject:self.vehicleClassObj];
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
                [self.arrayOfVehicleClass addObject:self.vehicleClassObj];
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
                [self.arrayOfVehicleClass addObject:self.vehicleClassObj];
                isIndividualVehicleClassDone = YES;
            }
        }
    }
    
    
    if([elementName isEqualToString:@"Photo"])
    {
        self.custDetailsObj.custPhoto = currentNodeContent;
    }
    if([elementName isEqualToString:@"Telephone"])
    {
         if([currentNodeContent length] == 0)
         {
             self.custDetailsObj.custPhoneNumber = @"Telephone?";
         }
        else
        {
             self.custDetailsObj.custPhoneNumber = currentNodeContent;
        }
       
         //NSLog(@"telephoneeee number = %@",currentNodeContent);
    }
    if([elementName isEqualToString:@"EmailAddress"])
    {
        if([currentNodeContent length] == 0)
        {
             self.custDetailsObj.custEmailAddress = @"Email Address?";
        }
        else
        {
            self.custDetailsObj.custEmailAddress = currentNodeContent;

        }
        //NSLog(@"email addressssss = %@",currentNodeContent);

    }
    if([elementName isEqualToString:@"SavedScanID"])
    {
        self.custDetailsObj.custScanID = currentNodeContent;
    }
    if([elementName isEqualToString:@"DrivingLicenseCard"])
    {
      

        self.custDetailsObj.arrayDriverVehicleClasses = self.arrayOfVehicleClass;
        [arrayOfDriverLicences addObject:self.custDetailsObj];
        
        
    }
    if([elementName isEqualToString:@"Total"])
    {
        totalCount = currentNodeContent.intValue;
    
    }
    if([elementName isEqualToString:@"Message"])
    {
        if([currentNodeContent isEqualToString:@"License information removed"])
        {
            UIBAlertView *alert;
            alert = [[UIBAlertView alloc] initWithTitle:@"Smart Manager" message:@"License information removed" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
             {
                 
                 if (didCancel)
                 {
                     NSLog(@"index removed = %d",selectedIndexForDelete);
                     [arrayOfDriverLicences removeObjectAtIndex:selectedIndexForDelete];
                     [self.tableScanLicenseList reloadData];
                     
                 }
             }];

        
        }
    
    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
    [self hideProgressHUD];
    
    if(arrayOfDriverLicences.count > 0)
    {
        self.lblNoRecords.hidden = YES;

        [self.tableScanLicenseList reloadData];
    }
    else
    {
        {
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"No details found, please try again." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                if (didCancel)
                {
                    
                    return;
                    
                }
                
            }];
        }
    }
   
    
}


#pragma mark -


#pragma mark - User Define Functions 

-(void)registernibfortable
{

    [self.tableScanLicenseList registerNib:[UINib nibWithNibName:@"SMCustomerTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableScanLicenseList setTableFooterView:[[UIView alloc] init]];
}

#pragma mark -

#pragma mark - 

-(IBAction)buttonscanDriverLicenseDidPressed
{
    SMCustomerDLScanViewController *scanObject = [[SMCustomerDLScanViewController alloc] initWithNibName:@"SMCustomerDLScanViewController" bundle:nil];
    
    scanObject.pushDetailsDelegate = self;
    [self.navigationController pushViewController:scanObject animated:YES];
    
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

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}


#pragma mark -


@end
