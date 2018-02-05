//
//  SMSynopsisVehicleExtrasViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 12/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMSynopsisVehicleExtrasViewController.h"
#import "SMCustomColor.h"
#import "CustomTextView.h"
#import "SMSynopsisVehicleExtrasViewCell.h"
#import "SMInteriorReconditioningObject.h"

@interface SMSynopsisVehicleExtrasViewController ()
{
    
    IBOutlet UIView *viewHeaderTable;
    IBOutlet UIView *viewFooterTable;
    IBOutlet UITableView *tblVehicleExtras;
    
    IBOutlet CustomTextView *txtViewComments;
    
    NSMutableArray *arrmVehicleExtras;
    SMInteriorReconditioningObject *objInteriorReconditioning;
    
    IBOutlet UILabel *lblTotal;
    int intTotal;
    int intNoofRows;
    int totalCnt;
}
- (IBAction)btnSaveDidClicked:(id)sender;
- (IBAction)btnAddDidClicked:(id)sender;
@end

@implementation SMSynopsisVehicleExtrasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    intNoofRows = 1;
    intTotal = 0;
    arrmVehicleExtras =[[NSMutableArray alloc] init];
    [self addingProgressHUD];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Vehicle Extras"];
    
    lblTotal.text = [NSString stringWithFormat:@"R %d",intTotal ];
    [self setTableProperties];
    [self webserviceForLoadingVehicleExtras];
    // Do any additional setup after loading the view from its nib.
}


-(void) setTableProperties{
    
    [tblVehicleExtras registerNib:[UINib nibWithNibName:@"SMSynopsisVehicleExtrasViewCell" bundle:nil] forCellReuseIdentifier:@"SMSynopsisVehicleExtrasViewCell"];
   
    tblVehicleExtras.tableHeaderView = viewHeaderTable;
    tblVehicleExtras.estimatedRowHeight = 45.0f;
    tblVehicleExtras.rowHeight = UITableViewAutomaticDimension;
    tblVehicleExtras.tableFooterView = viewFooterTable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Delegates and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrmVehicleExtras.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier2= @"SMSynopsisVehicleExtrasViewCell";

    
        SMSynopsisVehicleExtrasViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        [cell.btnDelete addTarget:self action:@selector(deleteVehicleExtrasDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnDelete.tag = indexPath.row*2;
        SMInteriorReconditioningObject *individualObj = (SMInteriorReconditioningObject*)[arrmVehicleExtras objectAtIndex:indexPath.row];
        
        cell.txtDetails.text = individualObj.strTitle;
        cell.txtPrice.text = individualObj.strValue;
        
        cell.txtDetails.delegate = self;
        cell.txtPrice.delegate = self;
       /* cell.btnCheckBox.tag = indexPath.row;
        
        cell.btnCheckBox.selected =individualObj.isCheckBoxSelected.boolValue;
        [cell.btnCheckBox addTarget:self action:@selector(checkBoxButtonPressed:) forControlEvents:UIControlEventTouchUpInside];*/
        cell.txtDetails.tag = indexPath.row + 102;
        cell.txtPrice.tag = indexPath.row + 100;
        cell.txtDetails.delegate = nil;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor blackColor];
        return cell;
        
        
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - TextFields Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"finalText = %@",textField.text);
    resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    resultString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"resultString = %@",resultString);
    {
        totalCnt = 0;
        for(int i = 0; i<arrmVehicleExtras.count;i++)
        {
            if(i+100 != textField.tag)
            {
                /* SMCustomInteriorTableViewCell *cellCustomType1 = (SMCustomInteriorTableViewCell *)[tblviewEngineDriveTrain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];*/
                SMInteriorReconditioningObject *individualObj = (SMInteriorReconditioningObject*)[arrmVehicleExtras objectAtIndex:i];
                NSString *tempPrice = [individualObj.strValue stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                if([tempPrice hasPrefix:@"R"])
                {
                    tempPrice = [tempPrice substringFromIndex:1];
                }
                if(![tempPrice isEqualToString:@""])
                {
                    
                    totalCnt = totalCnt + [tempPrice intValue];
                    
                    if(totalCnt < 0)
                    {
                        totalCnt = 0;
                    }
                    
                }
                
            }
        }
        
        if([resultString hasPrefix:@"R"])
        {
            resultString = [resultString substringFromIndex:1];
        }
        totalCnt = totalCnt + [resultString intValue];
        lblTotal.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalCnt]];
    }
    
    if([resultString length] == 0)
    {
        NSLog(@"textField.tag = %ld",(long)textField.tag-100);
        SMInteriorReconditioningObject *individualObj = (SMInteriorReconditioningObject*)[arrmVehicleExtras objectAtIndex:textField.tag-100];
        if(individualObj.isEmptyInputFieldAdded)
        {
            SMSynopsisVehicleExtrasViewCell *cellCustomType = [tblVehicleExtras cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag-100 inSection:0]];
            cellCustomType.txtPrice.text = @"";
        }
        else
        {
        }
        
        SMInteriorReconditioningObject *objCustomType1 = (SMInteriorReconditioningObject*)[arrmVehicleExtras objectAtIndex:textField.tag -100];
        
        objCustomType1.strValue = @"";
        [tblVehicleExtras reloadData];
    }
    return YES;

}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    intTotal = intTotal - [textField.text intValue];
    
    if(intTotal < 0)
        intTotal = 0;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag - 100 <100)
    {
        SMInteriorReconditioningObject *objCustomType1 = (SMInteriorReconditioningObject*)[arrmVehicleExtras objectAtIndex:textField.tag -100];
        
        if(objCustomType1.isEmptyInputFieldAdded)
        {
            SMSynopsisVehicleExtrasViewCell *cellCustomType = [tblVehicleExtras cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag-100 inSection:0]];
            
            objCustomType1.strValue = cellCustomType.txtPrice.text;
            objCustomType1.strTitle = cellCustomType.txtDetails.text;
            // objCustomType1.isCheckBoxSelected = @"1";
        }
        else
        {
            objCustomType1.strValue = textField.text;
            //objCustomType1.isCheckBoxSelected = @"1";
        }
        
    }
}


-(void)webserviceForLoadingVehicleExtras{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
     NSMutableURLRequest *requestURL = [SMWebServices loadAppraisalVehicleExtras:[SMGlobalClass sharedInstance].hashValue andAppraisalID:self.objSummary.appraisalID.intValue andVinNum:self.objSummary.strVINNo];
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
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

-(void) webserviceCallForSavingVehicleExtras
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    
    NSMutableURLRequest * requestURL = [SMWebServices saveVehicleExtras:[SMGlobalClass sharedInstance].hashValue andExtrasArray:arrmVehicleExtras andAppraisalID:self.objSummary.appraisalID andClientID:[SMGlobalClass sharedInstance].strClientID andVinNum:self.objSummary.strVINNo andVehicleExtraID:1 andComments:txtViewComments.text];
    
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
    if ([elementName isEqualToString:@"Extra"])
    {
        objInteriorReconditioning =[[SMInteriorReconditioningObject alloc]init];
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    
    if ([elementName isEqualToString:@"ExtraID"])
    {
        objInteriorReconditioning.strReconditioningTypeID = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Name"])
    {
        objInteriorReconditioning.strTitle = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Price"])
    {
       // tempPriceValue = currentNodeContent.intValue;
        
        objInteriorReconditioning.strValue = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:currentNodeContent];
    }
   
    if ([elementName isEqualToString:@"Extra"]) {
        objInteriorReconditioning.isEmptyInputFieldAdded = NO;
        [arrmVehicleExtras addObject:objInteriorReconditioning];
        
        
    }
    if ([elementName isEqualToString:@"Comments"])
    {
        txtViewComments.text = currentNodeContent;
    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog( @"arrAyCount = %lu",(unsigned long)arrmVehicleExtras.count);
    tblVehicleExtras.dataSource = self;
    tblVehicleExtras.delegate = self;
    
   /* if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        lblTotalCount.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalCnt]];
    else
        lbltotalCntIpad.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalCnt]];*/
    
    [tblVehicleExtras reloadData];
    [self hideProgressHUD];
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





#pragma mark - Button Methods

-(IBAction) deleteVehicleExtrasDidClicked:(UIButton*)sender
{
    //SMInteriorReconditioningObject *objVehicleExtras

}

- (IBAction)btnSaveDidClicked:(id)sender {
    [self.view endEditing:YES];
    [self webserviceCallForSavingVehicleExtras];
    
    
}

- (IBAction)btnAddDidClicked:(id)sender {
    
   SMInteriorReconditioningObject *objVehicleExtras =[[SMInteriorReconditioningObject alloc]init];
    
    objVehicleExtras.strReconditioningTypeID = @"";
    objVehicleExtras.strTitle  =@"";
    objVehicleExtras.strValue = @"R";
     objVehicleExtras.isEmptyInputFieldAdded = YES;
    [arrmVehicleExtras addObject:objVehicleExtras];
    
    [tblVehicleExtras reloadData];
}
@end
