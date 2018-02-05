//
//  SMVehicleAuditHistoryViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 04/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMVehicleAuditHistoryViewController.h"
#import "SMAuditHistoryListCell.h"
#import "SMVehicle_DateWiseAudit_ViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"


@interface SMVehicleAuditHistoryViewController ()

@end

@implementation SMVehicleAuditHistoryViewController

- (void)viewDidLoad
{
    [self addingProgressHUD];
    [super viewDidLoad];
    
    [self registerNib];
    arrayOfAuditHistory = [[NSMutableArray alloc]init];
    self.tblViewAuditDates.tableFooterView = [[UIView alloc]init];
    pageNumberCount=0;
    isLoadMore = NO;
    self.lblNoRecords.hidden = YES;
    
    [self getTheAuditHistoryList];
   
}


#pragma mark - tableView delegate methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrayOfAuditHistory.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *cellIdentifer1=@"SMAuditHistoryListCell";
        SMAuditHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer1 forIndexPath:indexPath];
    
        
        
        SMStockAuditDetailObject *auditHistoryObject = (SMStockAuditDetailObject*)[arrayOfAuditHistory objectAtIndex:indexPath.row];
        
        cell.lblAuditDate.text = auditHistoryObject.auditHistoryDate;
    
         if(auditHistoryObject.auditHistoryVehiclesCount.intValue == 1)
         {
             cell.lblVehicleNum.text = [NSString stringWithFormat:@"%@ vehicle",auditHistoryObject.auditHistoryVehiclesCount];
         }
         else
         {
             cell.lblVehicleNum.text = [NSString stringWithFormat:@"%@ vehicles",auditHistoryObject.auditHistoryVehiclesCount];

         }
                 
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
        cell.backgroundColor = [UIColor blackColor];
    
    if (arrayOfAuditHistory.count-1 == indexPath.row)
    {
        
        if (arrayOfAuditHistory.count !=totalCount)
        {
            ++pageNumberCount;
            isLoadMore=YES;
            [self getTheAuditHistoryList];
            
            
        }
    }
    
    return cell;
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
     SMStockAuditDetailObject *auditHistoryObject = (SMStockAuditDetailObject*)[arrayOfAuditHistory objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSDate *requiredDate1 = [dateFormatter dateFromString:auditHistoryObject.auditHistoryDate];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
   NSString *finalDate = [NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:requiredDate1]];

       
    SMVehicle_DateWiseAudit_ViewController *auditHistoryDetailVC = [[SMVehicle_DateWiseAudit_ViewController alloc] initWithNibName:@"SMVehicle_DateWiseAudit_ViewController" bundle:nil];
    auditHistoryDetailVC.selectedDateStr = finalDate;
    auditHistoryDetailVC.selectedDateStrForTitle = auditHistoryObject.auditHistoryDate;
    [self.navigationController pushViewController:auditHistoryDetailVC animated:YES];
}


- (void)registerNib
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
    listActiveSpecialsNavigTitle.text = @"Audit History";
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
    
    
   [self.tblViewAuditDates registerNib:[UINib nibWithNibName:@"SMAuditHistoryListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMAuditHistoryListCell"];
        
    
}


#pragma mark - WEbservice integration

-(void)getTheAuditHistoryList
{
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices getTheAuditHistoryListWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientId:[SMGlobalClass sharedInstance].strClientID.intValue andPageNumber:pageNumberCount andRecordCount:10];

    
    NSLog(@"Request URL = %@",requestURL);
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
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
                 [arrayOfAuditHistory removeAllObjects];
                 
             }
             
                  
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
         }
         
         
     }];
    
    
    
}


#pragma mark - Parsing delegate methods

// The first method to implement is parser:didStartElement:namespaceURI:qualifiedName:attributes:, which is fired when the start tag of an element is found:

//---when the start of an element is found---

-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict
{
    //NSLog(@"elementName %@",elementName);
    //NSLog(@"currentNodeContent %@",currentNodeContent);
    
    if([elementName isEqualToString:@"AuditHistory"])
    {
        self.auditHistoryObj = [[SMStockAuditDetailObject alloc]init];
        
    }
    if([elementName isEqualToString:@"AuditHistories"])
    {
        isCountOfIndividualVehicle = YES;
        
    }

    
    currentNodeContent = [NSMutableString stringWithString:@""];
    
}

//The next method to implement is parser:foundCharacters:, which gets fired when the parser finds the text of an element:

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
    
    
}


//Finally, when the parser encounters the end of an element, it fires the parser:didEndElement:namespaceURI:qualifiedName: method:

//---when the end of element is found---

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    [self hideProgressHUD];
    
   /* if([currentNodeContent length] == 0 || [currentNodeContent.lowercaseString isEqualToString:@"unknown"])
    {
        currentNodeContent = [NSMutableString stringWithFormat:@"No %@",elementName.capitalizedString];
    }*/
    
    
    if([elementName isEqualToString:@"Date"])
    {
        if([currentNodeContent length] == 0)
        {
            self.auditHistoryObj.auditHistoryDate = @"Date?";
        }
        else
           {
               self.auditHistoryObj.auditHistoryDate = currentNodeContent;
           }
    }
    if([elementName isEqualToString:@"Count"])
    {
        if(isCountOfIndividualVehicle)
        {
            self.auditHistoryObj.auditHistoryVehiclesCount = currentNodeContent;
        }
        else
        {
            totalCount = currentNodeContent.intValue;
        }
    }
    if([elementName isEqualToString:@"AuditHistories"])
    {
        isCountOfIndividualVehicle = NO;
        
    }
        if([elementName isEqualToString:@"AuditHistory"])
    {
        
        [arrayOfAuditHistory addObject:self.auditHistoryObj];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"arrayOfAuditHistory count = %lu",(unsigned long)arrayOfAuditHistory.count);
    
    
    [self hideProgressHUD];
    if(arrayOfAuditHistory.count == 0)
    {
        self.lblNoRecords.hidden = NO;
        self.lblSelectAuditDate.hidden = YES;
        self.tblViewAuditDates.hidden = YES;
        
    }
    else
    {
        self.lblNoRecords.hidden = YES;
        self.tblViewAuditDates.hidden = NO;
        self.lblSelectAuditDate.hidden = NO;

        [self.tblViewAuditDates reloadData];
    }
   
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
