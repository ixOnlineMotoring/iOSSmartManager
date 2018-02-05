//
//  SMInteriorReconditioningViewController.m
//  Smart Manager
//
//  Created by Ketan Nandha on 29/12/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMInteriorReconditioningViewController.h"
#import "SMCustomInteriorTableViewCell.h"
#import "SMInteriorReconditioningObject.h"
#import "SMCustomColor.h"
#import "SMCustomButtonBlue.h"
#import "CustomTextView.h"
#import "SMSynopsisVehicleExtrasViewCell.h"

@interface SMInteriorReconditioningViewController ()
{
    IBOutlet UITableView *tblviewInteriorReconditioning;

    IBOutlet UIView *viewTableFooter;
    
    IBOutlet UIView *viewTableFooterIpad;
    
    
    IBOutlet UILabel *lblTotalCount;
    
    IBOutlet UILabel *lbltotalCntIpad;
    
    
    IBOutlet UITextView *txtViewComments;
    
    IBOutlet CustomTextView *txtViewCommentsIpad;
    
    IBOutlet SMCustomButtonBlue *btnSave;
    
    NSMutableArray *arrmInteriorReconditioning;
    SMInteriorReconditioningObject *objInteriorReconditioning;
    
    int totalCnt;
    int tempPriceValue;
    int plusButtonClickedCount;
    NSString *resultString;
}




@end

@implementation SMInteriorReconditioningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Interior Reconditioning"];
    [self registerNibForTableView];
    [self addingProgressHUD];
    totalCnt = 0;
    plusButtonClickedCount = 0;
    tempPriceValue = 0;
    resultString = @"0";
    arrmInteriorReconditioning = [[NSMutableArray alloc] init];
    
    [self webServiceForLoadingInteriorReconditioningDetails];
    
   // NSURLSessionConfiguration *sessionConfig = [
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - tableView delegate methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return arrmInteriorReconditioning.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *cellIdentifier= @"SMCustomInteriorTableViewCell";
        static NSString *cellIdentifier2= @"SMSynopsisVehicleExtrasViewCell";
    
   
    
    SMInteriorReconditioningObject *individualObj = [arrmInteriorReconditioning objectAtIndex:indexPath.row];
    
        if(indexPath.row >= arrmInteriorReconditioning.count - (1 + plusButtonClickedCount) )
        {
            
            SMSynopsisVehicleExtrasViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
            [cell.btnDelete addTarget:self action:@selector(deleteVehicleExtrasDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnDelete.tag = indexPath.row*2;
            SMInteriorReconditioningObject *individualObj = (SMInteriorReconditioningObject*)[arrmInteriorReconditioning objectAtIndex:indexPath.row];
            
            cell.txtDetails.text = individualObj.strTitle;
            cell.txtPrice.text = individualObj.strValue;
            
            cell.txtDetails.delegate = self;
            cell.txtPrice.delegate = self;
            cell.btnCheckBox.tag = indexPath.row;
            
            cell.btnCheckBox.selected =individualObj.isCheckBoxSelected.boolValue;
            [cell.btnCheckBox addTarget:self action:@selector(checkBoxButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.txtDetails.tag = indexPath.row + 102;
            cell.txtPrice.tag = indexPath.row + 100;
            cell.txtDetails.delegate = nil;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor blackColor];
            return cell;
            
            
        }
        else
        {
             SMCustomInteriorTableViewCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
            if (dynamicCell == nil) {
                dynamicCell = [[SMCustomInteriorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }

            dynamicCell.lblTitle.hidden = NO;
            dynamicCell.lblTitle.text =individualObj.strTitle;
            dynamicCell.txtFieldTitleInput.hidden = YES;
            
            dynamicCell.txtFieldPrice.tag = indexPath.row + 100;
            dynamicCell.txtFieldTitleInput.tag = indexPath.row + 200;
            dynamicCell.txtFieldPrice.delegate = self;
            dynamicCell.txtFieldTitleInput.delegate = self;
            dynamicCell.btnCheckBox.tag = indexPath.row;
   
            dynamicCell.txtFieldPrice.text =individualObj.strValue;
            dynamicCell.btnCheckBox.selected =individualObj.isCheckBoxSelected.boolValue;
            [dynamicCell.btnCheckBox addTarget:self action:@selector(checkBoxButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return dynamicCell;
        }
    
}

- (IBAction)checkBoxButtonPressed:(UIButton*)sender {
    
    UIButton *button = sender;
    SMInteriorReconditioningObject *individualObj = [arrmInteriorReconditioning objectAtIndex:[sender tag]];
    
    NSLog(@"sender.tag = %ld",(long)[sender tag]);
   
    int tag =(int) [sender tag];
    tag = tag + 100;
    SMCustomTextField *textField = (SMCustomTextField*)[self.view viewWithTag:tag];
    NSString *text = textField.text;
    
    if(![text isEqualToString:@""] && ![text isEqualToString:@"R0"])
    {
        if(individualObj.isEmptyInputFieldAdded)
        {
             SMSynopsisVehicleExtrasViewCell *cellCustomType = [tblviewInteriorReconditioning cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
            
           // SMCustomTextField *textField = (SMCustomTextField*)[self.view viewWithTag:tag + 102];
            NSString *text = cellCustomType.txtDetails.text;
            
            if(![text isEqualToString:@""])
            {
                button.selected = !button.selected;
                
                if([sender tag] == arrmInteriorReconditioning.count-1)
                {
                    if(button.selected)
                    {
                        
                        totalCnt = totalCnt + [resultString intValue];
                    }
                    else
                    {
                        totalCnt = totalCnt - [resultString intValue];
                    }
                }
                else if([sender tag] == arrmInteriorReconditioning.count-2)
                {
                    if(button.selected)
                    {
                        
                        totalCnt = totalCnt + [resultString intValue];
                    }
                    else
                    {
                        totalCnt = totalCnt - [resultString intValue];
                    }
                }
                else
                {
                    NSString *tempCnt = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    if([tempCnt hasPrefix:@"R"])
                    {
                        tempCnt = [tempCnt substringFromIndex:1];
                    }
                    
                    if(button.selected)
                    {
                        
                        totalCnt = totalCnt + [tempCnt intValue];
                    }
                    else
                    {
                        totalCnt = totalCnt - [tempCnt intValue];
                    }
                }
                if(totalCnt < 0)
                {
                    totalCnt = 0;
                }
                
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                    lblTotalCount.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalCnt]];
                else
                    lbltotalCntIpad.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalCnt]];
            }
            else
            {
              // show the alert that the input field is empty
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Manager" message:@"Please enter the name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
                
            }
            
        }
        else
        {
        button.selected = !button.selected;
        
        if([sender tag] == arrmInteriorReconditioning.count-1)
        {
            if(button.selected)
            {
                
                totalCnt = totalCnt + [resultString intValue];
            }
            else
            {
                totalCnt = totalCnt - [resultString intValue];
            }
        }
        else if([sender tag] == arrmInteriorReconditioning.count-2)
        {
            if(button.selected)
            {
                if(resultString.intValue > 0)
                    totalCnt = totalCnt + [resultString intValue];
                else
                {
                    NSString *tempCnt = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    if([tempCnt hasPrefix:@"R"])
                    {
                        tempCnt = [tempCnt substringFromIndex:1];
                    }
                    totalCnt = totalCnt + [tempCnt intValue];
                }
            }
            else
            {
                if(resultString.intValue > 0)
                    totalCnt = totalCnt - [resultString intValue];
                else
                {
                    NSString *tempCnt = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    if([tempCnt hasPrefix:@"R"])
                    {
                        tempCnt = [tempCnt substringFromIndex:1];
                    }
                    totalCnt = totalCnt - [tempCnt intValue];
                }
            }
        }
        else
        {
            NSString *tempCnt = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if([tempCnt hasPrefix:@"R"])
            {
                tempCnt = [tempCnt substringFromIndex:1];
            }
            
            if(button.selected)
            {
                
                totalCnt = totalCnt + [tempCnt intValue];
            }
            else
            {
                totalCnt = totalCnt - [tempCnt intValue];
            }
        }
        if(totalCnt < 0)
        {
            totalCnt = 0;
        }
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            lblTotalCount.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalCnt]];
        else
           lbltotalCntIpad.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalCnt]];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Manager" message:@"Please enter the price" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    
    }
    
    individualObj.isCheckBoxSelected = [NSString stringWithFormat:@"%d",button.isSelected];
    
}

#pragma mark - textField delegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"textField.tag = %ld",(long)textField.tag);
    if(textField.tag - 100 <100)
    {
        NSLog(@"finalText = %@",textField.text);
        resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        resultString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSLog(@"resultString = %@",resultString);
        SMCustomInteriorTableViewCell *cellCustomType = [tblviewInteriorReconditioning cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag-100 inSection:0]];
        if(cellCustomType.btnCheckBox.isSelected)
        {
            totalCnt = 0;
            for(int i = 0; i<arrmInteriorReconditioning.count;i++)
            {
                if(i+100 != textField.tag)
                {
                    /* SMCustomInteriorTableViewCell *cellCustomType1 = (SMCustomInteriorTableViewCell *)[tblviewEngineDriveTrain cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];*/
                    SMInteriorReconditioningObject *individualObj = (SMInteriorReconditioningObject*)[arrmInteriorReconditioning objectAtIndex:i];
                    NSString *tempPrice = [individualObj.strValue stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    if([tempPrice hasPrefix:@"R"])
                    {
                        tempPrice = [tempPrice substringFromIndex:1];
                    }
                    if(![tempPrice isEqualToString:@""])
                    {
                        
                        if(individualObj.isCheckBoxSelected.boolValue)
                        {
                            
                            totalCnt = totalCnt + [tempPrice intValue];
                        }
                        
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
            
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                lblTotalCount.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalCnt]];
            else
              lbltotalCntIpad.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalCnt]];
        }
        
        if([resultString length] == 0)
        {
            NSLog(@"textField.tag = %ld",(long)textField.tag-100);
            SMInteriorReconditioningObject *individualObj = (SMInteriorReconditioningObject*)[arrmInteriorReconditioning objectAtIndex:textField.tag-100];
            if(individualObj.isEmptyInputFieldAdded)
            {
                SMSynopsisVehicleExtrasViewCell *cellCustomType = [tblviewInteriorReconditioning cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag-100 inSection:0]];
                cellCustomType.txtPrice.text = @"";
            }
            else
            {
                SMCustomInteriorTableViewCell *cellCustomType = [tblviewInteriorReconditioning cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag-100 inSection:0]];
                cellCustomType.txtFieldPrice.text = @"";
            }
            
            SMInteriorReconditioningObject *objCustomType1 = (SMInteriorReconditioningObject*)[arrmInteriorReconditioning objectAtIndex:textField.tag -100];
            
            objCustomType1.isCheckBoxSelected = @"0";
            objCustomType1.strValue = @"";
            [tblviewInteriorReconditioning reloadData];
        }
        
    }
    return YES;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
     if(textField.tag - 100 <100)
     {
         SMInteriorReconditioningObject *objCustomType1 = (SMInteriorReconditioningObject*)[arrmInteriorReconditioning objectAtIndex:textField.tag -100];
    
          if(objCustomType1.isEmptyInputFieldAdded)
          {
              SMSynopsisVehicleExtrasViewCell *cellCustomType = [tblviewInteriorReconditioning cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag-100 inSection:0]];
              
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

#pragma mark - User Define Functions
-(void) registerNibForTableView
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [tblviewInteriorReconditioning registerNib:[UINib nibWithNibName:@"SMCustomInteriorTableViewCell" bundle:nil]        forCellReuseIdentifier:@"SMCustomInteriorTableViewCell"];
        
         [tblviewInteriorReconditioning registerNib:[UINib nibWithNibName:@"VehicleExtrasInputCell" bundle:nil] forCellReuseIdentifier:@"SMSynopsisVehicleExtrasViewCell"];
    }
    else
        [tblviewInteriorReconditioning registerNib:[UINib nibWithNibName:@"SMCustomInteriorTableViewCell~ipad" bundle:nil]        forCellReuseIdentifier:@"SMCustomInteriorTableViewCell"];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        [tblviewInteriorReconditioning setTableFooterView:viewTableFooter];
    else
         [tblviewInteriorReconditioning setTableFooterView:viewTableFooterIpad];
}

#pragma mark - WEbservice integration

-(void)webServiceForLoadingInteriorReconditioningDetails{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
   // NSMutableURLRequest *requestURL = [SMWebServices loadInteriorReconditioning:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andVin:self.objSummary.strVINNo];
    
    NSMutableURLRequest *requestURL = [SMWebServices loadInteriorReconditioning:[SMGlobalClass sharedInstance].hashValue andAppraisalID:self.objSummary.appraisalID.intValue andVin:self.objSummary.strVINNo];

    
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


-(void)webServiceForSavingInteriorReconditioningDetails{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
    NSMutableURLRequest *requestURL = [SMWebServices saveInteriorReconditioning:[SMGlobalClass sharedInstance].hashValue andIRArray:arrmInteriorReconditioning andInteriorReconditioningID:@"" andAppraisalID:self.objSummary.appraisalID andComments:txtViewComments.text andClientID:[SMGlobalClass sharedInstance].strClientID andVinNumber:self.objSummary.strVINNo];
    
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

#pragma mark - NSXMLParser Delegate Methods

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    if ([elementName isEqualToString:@"Interior"])
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
    
    
    if ([elementName isEqualToString:@"InteriorReconditioningValueID"])
    {
        objInteriorReconditioning.strInteriorReconditioningValue = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"ReconditioningType"])
    {
        objInteriorReconditioning.strTitle = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"ReconditioningTypeID"])
    {
        objInteriorReconditioning.strReconditioningTypeID = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"CustomType"])
    {
        objInteriorReconditioning.strTitle = [NSString stringWithFormat:@"%@%@",objInteriorReconditioning.strTitle,currentNodeContent];
    }
    else if ([elementName isEqualToString:@"Value"])
    {
        tempPriceValue = currentNodeContent.intValue;
        
        objInteriorReconditioning.strValue = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:currentNodeContent];
    }
    else if ([elementName isEqualToString:@"IsActive"])
    {
        objInteriorReconditioning.isCheckBoxSelected = currentNodeContent;
        if(currentNodeContent.boolValue)
        {
          totalCnt = totalCnt + tempPriceValue;
        }
    }
    if ([elementName isEqualToString:@"Interior"]) {
        objInteriorReconditioning.isEmptyInputFieldAdded = NO;
        [arrmInteriorReconditioning addObject:objInteriorReconditioning];
        
    }
    if ([elementName isEqualToString:@"Comments"])
    {
        txtViewComments.text = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Items"]) {
        
      
        
        objInteriorReconditioning =[[SMInteriorReconditioningObject alloc]init];
        objInteriorReconditioning.strTitle = @"";
        objInteriorReconditioning.strValue = @"R0";
        objInteriorReconditioning.strReconditioningTypeID = @"";
        objInteriorReconditioning.strInteriorReconditioningValue = @"";
        objInteriorReconditioning.isCheckBoxSelected = @"0";
        objInteriorReconditioning.isEmptyInputFieldAdded = YES;
        [arrmInteriorReconditioning addObject:objInteriorReconditioning];
        
        
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog( @"arrAyCount = %lu",(unsigned long)arrmInteriorReconditioning.count);
    tblviewInteriorReconditioning.dataSource = self;
    tblviewInteriorReconditioning.delegate = self;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        lblTotalCount.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalCnt]];
    else
       lbltotalCntIpad.text = [[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",totalCnt]];
    
    [tblviewInteriorReconditioning reloadData];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnPlusButtonDidClicked:(id)sender {
    
    plusButtonClickedCount ++;
    
    objInteriorReconditioning =[[SMInteriorReconditioningObject alloc]init];
    objInteriorReconditioning.strTitle = @"";
    objInteriorReconditioning.strValue = @"R0";
    objInteriorReconditioning.strReconditioningTypeID = @"";
    objInteriorReconditioning.strInteriorReconditioningValue = @"";
    objInteriorReconditioning.isCheckBoxSelected = @"0";
    objInteriorReconditioning.isEmptyInputFieldAdded = YES;
    [arrmInteriorReconditioning addObject:objInteriorReconditioning];

    [tblviewInteriorReconditioning reloadData];
    
    
}

- (IBAction)btnSaveDidClicked:(id)sender
{
    [self.view endEditing:YES];
        
       /* SMCustomInteriorTableViewCell *cellCustomType1 = [tblviewInteriorReconditioning cellForRowAtIndexPath:[NSIndexPath indexPathForRow:arrmInteriorReconditioning.count-2 inSection:0]];
    
            SMInteriorReconditioningObject *objCustomType1 = (SMInteriorReconditioningObject*)[arrmInteriorReconditioning objectAtIndex:arrmInteriorReconditioning.count-2];
            
            objCustomType1.strTitle = cellCustomType1.txtFieldTitleInput.text;
            objCustomType1.strValue = cellCustomType1.txtFieldPrice.text;
            objCustomType1.strReconditioningTypeID = @"";
            objCustomType1.strInteriorReconditioningValue = @"";
            objCustomType1.isCheckBoxSelected = [NSString stringWithFormat:@"%d",cellCustomType1.btnCheckBox.isSelected];
            [arrmInteriorReconditioning replaceObjectAtIndex:arrmInteriorReconditioning.count-2 withObject:objCustomType1];
    
    SMCustomInteriorTableViewCell *cellCustomType2 = [tblviewInteriorReconditioning cellForRowAtIndexPath:[NSIndexPath indexPathForRow:arrmInteriorReconditioning.count-1 inSection:0]];
    
    SMInteriorReconditioningObject *objCustomType2 = (SMInteriorReconditioningObject*)[arrmInteriorReconditioning objectAtIndex:arrmInteriorReconditioning.count-1];
    
    objCustomType2.strTitle = cellCustomType2.txtFieldTitleInput.text;
    objCustomType2.strValue = cellCustomType2.txtFieldPrice.text;
    objCustomType2.strReconditioningTypeID = @"";
    objCustomType2.strInteriorReconditioningValue = @"";
    objCustomType2.isCheckBoxSelected = [NSString stringWithFormat:@"%d",cellCustomType1.btnCheckBox.isSelected];
    [arrmInteriorReconditioning replaceObjectAtIndex:arrmInteriorReconditioning.count-1 withObject:objCustomType2];*/
    
    [self webServiceForSavingInteriorReconditioningDetails];
    
}

-(IBAction) deleteVehicleExtrasDidClicked:(UIButton*)sender
{
    plusButtonClickedCount--;

    NSInteger deleteCellTag = [sender tag]/2;
     NSLog(@"deleteCellTag = %ld",(long)deleteCellTag);
    
    [arrmInteriorReconditioning removeObjectAtIndex:deleteCellTag];
    
    [tblviewInteriorReconditioning reloadData];
    
}
@end
