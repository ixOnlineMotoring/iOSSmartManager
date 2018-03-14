//
//  SMStockSummaryTableVC.m
//  Smart Manager
//
//  Created by Ketan Nandha on 06/10/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import "SMStockSummaryTableVC.h"
#import "SMStockSummaryCell2.h"
#import "SMStockSummaryCell1.h"
#import "SMStockSummaryCell3.h"
#import "SMStockSummaryCell4.h"
#import "SMStockSummaryCell5.h"
#import "SMCustomColor.h"

@interface SMStockSummaryTableVC ()<NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    NSMutableArray *arrmUsedActiveValues;
    NSMutableArray *arrmUsedExcludedValues;
    NSMutableArray *arrmUsedInvalidValues;
    NSMutableArray *arrmNewActiveValues;
    NSMutableArray *arrmNewExcludedValues;
    NSMutableArray *arrmNewInvalidValues;
    NSMutableArray *arrmUsedTotals;
    NSMutableArray *arrmNewTotals;
    NSArray *arrayStockFeeds;
    
    NSString *strDealerName;
    NSString *strStockImport;
    NSString *strManualUpdate;
    NSString *strMainTotal;
     NSString *strStockFeeds;
    
    BOOL isUsedStock;
    BOOL isActive;
    BOOL isExcluded;
    BOOL isInvalid;
    
    int intUserExcluded;
    int intUserInvalid;
    int intNewExcluded;
    int intNewInvalid;
}

@end

@implementation SMStockSummaryTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addingProgressHUD];
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Stock Summary"];
    self.tableView.estimatedRowHeight = 170;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    intUserExcluded = 0;
    intUserInvalid = 0;
    intNewExcluded = 0;
    intNewInvalid = 0;
    
    arrmUsedActiveValues = [[NSMutableArray alloc] init];
    arrmUsedExcludedValues = [[NSMutableArray alloc] init];
    arrmUsedInvalidValues = [[NSMutableArray alloc] init];
    
    arrmNewActiveValues = [[NSMutableArray alloc] init];
    arrmNewExcludedValues = [[NSMutableArray alloc] init];
    arrmNewInvalidValues = [[NSMutableArray alloc] init];
    
    arrmNewTotals = [[NSMutableArray alloc] init];
    arrmUsedTotals = [[NSMutableArray alloc] init];
    
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    [self webserviceForFetchingStockDetails];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;

}

-(BOOL)isValidEmail:(NSString*) emailID
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regExpred =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringCheck = [regExpred evaluateWithObject:emailID];
    
    if(!myStringCheck)
    {
        return NO;
    }
    else
        return YES;
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return arrayStockFeeds.count;
            break;
        case 2:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifer1 = @"SMStockSummaryCell1";
    static NSString *cellIdentifer2 = @"SMStockSummaryCell2";
    static NSString *cellIdentifer3 = @"SMStockSummaryCell3";
    static NSString *cellIdentifer4 = @"SMStockSummaryCell4";
    static NSString *cellIdentifer5 = @"SMStockSummaryCell5";
    
    SMStockSummaryCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifer2 forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    SMStockSummaryCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifer1 forIndexPath:indexPath];
                    cell1.lblDealerName.text = strDealerName;
                    cell1.lblStockImportDate.text = strStockImport;
                    cell1.lblManualUpdateDate.text = strManualUpdate;
                    [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
                    return cell1;
                    
                }
                break;
                case 1:
                {
                    cell2.lblVehicleType.text = @"Used";
                    cell2.lblActiveVehs.text = [arrmUsedActiveValues objectAtIndex:0];
                    cell2.lblActivePics.text = [arrmUsedActiveValues objectAtIndex:1];
                    cell2.lblActiveVideo.text = [arrmUsedActiveValues objectAtIndex:2];
                    cell2.lblActiveMan.text = [arrmUsedActiveValues objectAtIndex:3];
                    
                    cell2.lblExcludedVehs.text = [arrmUsedExcludedValues objectAtIndex:0];
                    cell2.lblExcludedPics.text = [arrmUsedExcludedValues objectAtIndex:1];
                    cell2.lblExcludedVideo.text = [arrmUsedExcludedValues objectAtIndex:2];
                    cell2.lblExcludedMan.text = [arrmUsedExcludedValues objectAtIndex:3];
                    
                    cell2.lblInvalidVehs.text = [arrmUsedInvalidValues objectAtIndex:0];
                    cell2.lblInvalidPics.text = [arrmUsedInvalidValues objectAtIndex:1];
                    cell2.lblInvalidVideo.text = [arrmUsedInvalidValues objectAtIndex:2];
                    cell2.lblInvalidMan.text = [arrmUsedInvalidValues objectAtIndex:3];
                    
                    cell2.lblVehsTotal.text = [arrmUsedTotals objectAtIndex:0];
                    cell2.lblPicsTotal.text = [arrmUsedTotals objectAtIndex:1];
                    cell2.lblVideoTotal.text = [arrmUsedTotals objectAtIndex:2];
                    cell2.lblManTotal.text = [arrmUsedTotals objectAtIndex:3];
                    [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
                    
                    return cell2;
                }
                break;
                case 2:
                {
                    cell2.lblVehicleType.text = @"New";
                    cell2.lblActiveVehs.text = [arrmNewActiveValues objectAtIndex:0];
                    cell2.lblActivePics.text = [arrmNewActiveValues objectAtIndex:1];
                    cell2.lblActiveVideo.text = [arrmNewActiveValues objectAtIndex:2];
                    cell2.lblActiveMan.text = [arrmNewActiveValues objectAtIndex:3];
                    
                    cell2.lblExcludedVehs.text = [arrmNewExcludedValues objectAtIndex:0];
                    cell2.lblExcludedPics.text = [arrmNewExcludedValues objectAtIndex:1];
                    cell2.lblExcludedVideo.text = [arrmNewExcludedValues objectAtIndex:2];
                    cell2.lblExcludedMan.text = [arrmNewExcludedValues objectAtIndex:3];
                    
                    cell2.lblInvalidVehs.text = [arrmNewInvalidValues objectAtIndex:0];
                    cell2.lblInvalidPics.text = [arrmNewInvalidValues objectAtIndex:1];
                    cell2.lblInvalidVideo.text = [arrmNewInvalidValues objectAtIndex:2];
                    cell2.lblInvalidMan.text = [arrmNewInvalidValues objectAtIndex:3];
                    
                    cell2.lblVehsTotal.text = [arrmNewTotals objectAtIndex:0];
                    cell2.lblPicsTotal.text = [arrmNewTotals objectAtIndex:1];
                    cell2.lblVideoTotal.text = [arrmNewTotals objectAtIndex:2];
                    cell2.lblManTotal.text = [arrmNewTotals objectAtIndex:3];
                    [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
                    return cell2;
                }
                break;
                case 3:
                {
                    SMStockSummaryCell3 *cell3 = [tableView dequeueReusableCellWithIdentifier:cellIdentifer3 forIndexPath:indexPath];
                    cell3.lblMainTotal.text = strMainTotal;
                    [cell3 setSelectionStyle:UITableViewCellSelectionStyleNone];
                    return cell3;
                }
                    break;
                    
                default:
                    break;
            }
        }
        break;
        case 1:
        {
            SMStockSummaryCell4 *cell4 = [tableView dequeueReusableCellWithIdentifier:cellIdentifer4 forIndexPath:indexPath];
            cell4.lblStockFeed.text = [arrayStockFeeds objectAtIndex:indexPath.row];
            [cell4 setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell4;
        }
        break;
        case 2:
        {
            SMStockSummaryCell5 *cell5 = [tableView dequeueReusableCellWithIdentifier:cellIdentifer5 forIndexPath:indexPath];
            [cell5.btnSendEmail addTarget:self action:@selector(btnSendDidClicked) forControlEvents:UIControlEventTouchUpInside];
            cell5.txtFieldEmaiIds.delegate = self;
            [cell5 setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell5;
        }
        break;
            
        default:
            break;
    }
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1)
        return viewWorkTypeSectionHeader;
    else
        return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
        return 35.0;
    else
        return 0.0;

}

-(void) btnSendDidClicked{

    [self.view endEditing:YES];
    
    SMCustomTextField *emailTxtField = [self.view viewWithTag:5];
    
    if([emailTxtField.text length] == 0)
    {
        [self hideProgressHUD];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Please enter email address." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    emailTxtField.text = [emailTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray *arr = [emailTxtField.text componentsSeparatedByString:@";"];
    
    if(arr.count == 1 && [arr[0] containsString:@","])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Please separate email addresses with semicolon." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    for(int i=0; i<arr.count;i++)
    {
        if(![self isValidEmail:arr[i]])
        {
           
            [self hideProgressHUD];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:[NSString stringWithFormat:@"Email address: %@ is incorrect.",arr[i]] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }
    if([emailTxtField.text length] >0)
    {
        if(intUserExcluded == 0 && intUserInvalid == 0 && intNewExcluded == 0 && intNewInvalid ==0)
        {
            [self hideProgressHUD];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Please select at least one option." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        [self webserviceForSendingEmailsWithUsedExcluded:intUserExcluded andUsedInvalid:intUserInvalid andNewExcluded:intNewExcluded andNewInvalid:intNewInvalid andEmailIds:emailTxtField.text];
    }
    else
    {
        
        [self hideProgressHUD];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Please enter email address." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

#pragma mark webservice integration

-(void) webserviceForFetchingStockDetails
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    NSMutableURLRequest * requestURL = [SMWebServices getTheStockSummaryWith:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            if (error!=nil)
                                            {
                                                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                    // Do something...
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        SMAlert(@"Error", error.localizedDescription);
                                                        [self hideProgressHUD];
                                                        return;
                                                    });
                                                });
                                                
                                            }
                                            else
                                            {
                                                
                                                xmlParser = [[NSXMLParser alloc] initWithData:data];
                                                [xmlParser setDelegate:self];
                                                [xmlParser setShouldResolveExternalEntities:YES];
                                                [xmlParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
}

-(void) webserviceForSendingEmailsWithUsedExcluded:(BOOL) usedExcluded andUsedInvalid:(BOOL) usedInvalid andNewExcluded:(BOOL) newExcluded andNewInvalid:(BOOL) newInvalid andEmailIds:(NSString*) emailIds
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    NSMutableURLRequest * requestURL = [SMWebServices sendStockSummaryEmailsWith:[SMGlobalClass sharedInstance].hashValue andclientID:[SMGlobalClass sharedInstance].strClientID.intValue andusedExcluded:usedExcluded andusedInvalid:usedInvalid andnewExcluded:newExcluded andnewInvailid:newInvalid andrecipientslist:emailIds];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            if (error!=nil)
                                            {
                                                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                    // Do something...
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        SMAlert(@"Error", error.localizedDescription);
                                                        [self hideProgressHUD];
                                                        return;
                                                    });
                                                });
                                                
                                            }
                                            else
                                            {
                                                
                                                xmlParser = [[NSXMLParser alloc] initWithData:data];
                                                [xmlParser setDelegate:self];
                                                [xmlParser setShouldResolveExternalEntities:YES];
                                                [xmlParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
}





#pragma mark - NSXMLParser Delegate Methods

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    
    
    if ([elementName isEqualToString:@"Used"])
    {
        isUsedStock = YES;
    }
    else if ([elementName isEqualToString:@"New"])
    {
        isUsedStock = NO;
    }
    else if ([elementName isEqualToString:@"Active"])
    {
        isActive = YES;
        isExcluded = NO;
        isInvalid = NO;
    }
    else if ([elementName isEqualToString:@"Excluded"])
    {
        isActive = NO;
        isExcluded = YES;
        isInvalid = NO;
    }
    else if ([elementName isEqualToString:@"Invalid"])
    {
        isActive = NO;
        isExcluded = NO;
        isInvalid = YES;
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"DealerName"])
    {
        strDealerName = currentNodeContent;
    }
    else if([elementName isEqualToString:@"Last_Stock_Import"])
    {
        strStockImport = currentNodeContent;
    }
    else if([elementName isEqualToString:@"Last_Manual_Upadte"])
    {
        strManualUpdate = currentNodeContent;
    }
    else if([elementName isEqualToString:@"Total"])
    {
       strMainTotal = currentNodeContent;
    }
    else if([elementName isEqualToString:@"Active_Stock_Feeds"])
    {
        strStockFeeds = currentNodeContent;
    }
    else if([elementName isEqualToString:@"vehs"])
    {
        if(isUsedStock)
        {
        if(isActive)
           [arrmUsedActiveValues addObject:currentNodeContent];
        else if(isExcluded)
            [arrmUsedExcludedValues addObject:currentNodeContent];
        else if(isInvalid)
            [arrmUsedInvalidValues addObject:currentNodeContent];
        }
        else if(!isUsedStock)
        {
            if(isActive)
                [arrmNewActiveValues addObject:currentNodeContent];
            else if(isExcluded)
                [arrmNewExcludedValues addObject:currentNodeContent];
            else if(isInvalid)
                [arrmNewInvalidValues addObject:currentNodeContent];
        
        }
    }
    else if([elementName isEqualToString:@"Pics"])
    {
        if(isUsedStock)
        {
            if(isActive)
                [arrmUsedActiveValues addObject:currentNodeContent];
            else if(isExcluded)
                [arrmUsedExcludedValues addObject:currentNodeContent];
            else if(isInvalid)
                [arrmUsedInvalidValues addObject:currentNodeContent];
        }
        else if(!isUsedStock)
        {
            if(isActive)
                [arrmNewActiveValues addObject:currentNodeContent];
            else if(isExcluded)
                [arrmNewExcludedValues addObject:currentNodeContent];
            else if(isInvalid)
                [arrmNewInvalidValues addObject:currentNodeContent];
            
        }
    }
    else if([elementName isEqualToString:@"Videos"])
    {
        if(isUsedStock)
        {
            if(isActive)
                [arrmUsedActiveValues addObject:currentNodeContent];
            else if(isExcluded)
                [arrmUsedExcludedValues addObject:currentNodeContent];
            else if(isInvalid)
                [arrmUsedInvalidValues addObject:currentNodeContent];
        }
        else if(!isUsedStock)
        {
            if(isActive)
                [arrmNewActiveValues addObject:currentNodeContent];
            else if(isExcluded)
                [arrmNewExcludedValues addObject:currentNodeContent];
            else if(isInvalid)
                [arrmNewInvalidValues addObject:currentNodeContent];
            
        }
    }
    else if([elementName isEqualToString:@"Man"])
    {
        if(isUsedStock)
        {
            if(isActive)
                [arrmUsedActiveValues addObject:currentNodeContent];
            else if(isExcluded)
                [arrmUsedExcludedValues addObject:currentNodeContent];
            else if(isInvalid)
                [arrmUsedInvalidValues addObject:currentNodeContent];
        }
        else if(!isUsedStock)
        {
            if(isActive)
                [arrmNewActiveValues addObject:currentNodeContent];
            else if(isExcluded)
                [arrmNewExcludedValues addObject:currentNodeContent];
            else if(isInvalid)
                [arrmNewInvalidValues addObject:currentNodeContent];
            
        }
    }
    else if([elementName isEqualToString:@"Used_Vehs"])
    {
        [arrmUsedTotals addObject:currentNodeContent];
    }
    else if([elementName isEqualToString:@"Used_Pics"])
    {
        [arrmUsedTotals addObject:currentNodeContent];
    }
    else if([elementName isEqualToString:@"Used_Videos"])
    {
        [arrmUsedTotals addObject:currentNodeContent];
    }
    else if([elementName isEqualToString:@"Used_Man"])
    {
        [arrmUsedTotals addObject:currentNodeContent];
    }
    else if([elementName isEqualToString:@"New_Vehs"])
    {
        [arrmNewTotals addObject:currentNodeContent];
    }
    else if([elementName isEqualToString:@"New_Pics"])
    {
        [arrmNewTotals addObject:currentNodeContent];
    }
    else if([elementName isEqualToString:@"New_Videos"])
    {
        [arrmNewTotals addObject:currentNodeContent];
    }
    else if([elementName isEqualToString:@"New_Man"])
    {
        [arrmNewTotals addObject:currentNodeContent];
    }
    else if([elementName isEqualToString:@"Success"])
    {
       if([currentNodeContent isEqualToString:@"False"])
       {
           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Failure Stock list not sent. Please try again." preferredStyle:UIAlertControllerStyleAlert];
           [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
           [self presentViewController:alertController animated:YES completion:nil];

       }
        else
        {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Stock List sent successfully." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            SMCustomTextField *emailTxtField = [self.view viewWithTag:5];
            emailTxtField.text = @"";
            UIButton *btn1 = [self.view viewWithTag:1];
            btn1.selected = false;
            UIButton *btn2 = [self.view viewWithTag:2];
            btn2.selected = false;
            UIButton *btn3 = [self.view viewWithTag:3];
            btn3.selected = false;
            UIButton *btn4 = [self.view viewWithTag:4];
            btn4.selected = false;
           // [self.tableView reloadData];
            });
        }
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
    dispatch_async(dispatch_get_main_queue(), ^{
        arrayStockFeeds = [strStockFeeds componentsSeparatedByString:@","];
        
        //////////Monami add array count checking due to crash for empty array
        if(arrayStockFeeds.count>0){
            self.tableView.dataSource = self;
            self.tableView.delegate = self;
            [self.tableView reloadData];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Smart Manager"
                                                                           message:@"No record(s) found."
                                                                    preferredStyle:UIAlertControllerStyleAlert]; // 1
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   [self.navigationController popViewControllerAnimated:YES];
                                                               }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    });
    ////////////////////////End////////////////////////////////
    
}

- (IBAction)btnCheckBoxClicked:(UIButton*)sender {
    NSLog(@"hello");
    
    if(sender.tag == 1){
        sender.selected = !sender.selected;
        intUserExcluded = sender.selected;
    }else if(sender.tag == 2){
        sender.selected = !sender.selected;
        intUserInvalid = sender.selected;
    }else if(sender.tag == 3){
        sender.selected = !sender.selected;
        intNewExcluded = sender.selected;
    }else if(sender.tag == 4){
        sender.selected = !sender.selected;
        intNewInvalid = sender.selected;
    }
}


#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.color = [UIColor blackColor];
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



@end
