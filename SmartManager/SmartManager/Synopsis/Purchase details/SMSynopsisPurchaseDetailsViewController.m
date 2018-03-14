//
//  SMSynopsisPurchaseDetailsViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 29/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSynopsisPurchaseDetailsViewController.h"
#import "SMCustomTextField.h"

#import "CustomTextView.h"
#import "SMCustomButtonBlue.h"
#import "SMPurchaseDetailsObj.h"

@interface SMSynopsisPurchaseDetailsViewController ()<UITextFieldDelegate>
{
    
    IBOutlet SMCustomTextField *txtBroughtFrom;
    IBOutlet SMCustomTextField *txtDate;
    IBOutlet SMCustomTextField *txtFinanceHouse;
    IBOutlet SMCustomTextField *txtSettlement;
    IBOutlet SMCustomTextField *txtAccount;
    IBOutlet SMCustomTextField *txtDetails;
    IBOutlet CustomTextView *txtviewComments;
    IBOutlet SMCustomButtonBlue *btnSave;
    IBOutlet UIScrollView *scrollParent;
    
    SMPurchaseDetailsObj *purchaseDetailObj;
    NSMutableArray *arrmPurchaseDetails;
    
    
}
- (IBAction)btnSaveDidClicked:(id)sender;

@end

@implementation SMSynopsisPurchaseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Purchase Details"];
    [self addingProgressHUD];
    dateView.layer.cornerRadius =15.0;
    dateView.clipsToBounds      = YES;

    [self webServiceForLoadingPurchaseDetails];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    scrollParent.contentSize  = CGSizeMake(self.view.bounds.size.width,btnSave.frame.origin.y + btnSave.frame.size.height + 10.0f);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField == txtDate)
    {
        [textField resignFirstResponder];
        [self loadPopUpView];
        
        return NO;
    }
   return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Text View Delegate

-(void)textViewDidEndEditing:(UITextView *)textView{
    [txtviewComments resignFirstResponder];
    
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [txtviewComments resignFirstResponder];
    return YES;
}

- (IBAction)btnSaveDidClicked:(id)sender
{
    [self webServiceForSavingPurchaseDetails];
    
}

#pragma mark -
#pragma mark - Load/Hide Drop Down For Start & End Date

-(void)loadPopUpView
{
    [popupView setFrame:[UIScreen mainScreen].bounds];
    [popupView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
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

-(void) hidePopUpView
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
              [popupView setTransform:CGAffineTransformMakeScale(0.9,0.9)];
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

#pragma mark -

-(IBAction)buttonCancelDidPressed:(id)sender
{
    
    [self hidePopUpView];
}

-(IBAction)buttonDoneDidPrssed:(id) sender
{
    NSLog(@"datepicker date = %@",datePickerForTime.date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datePickerForTime.date]];
    
    [txtDate setText:textDate];
        [self hidePopUpView];
    
   }


#pragma mark - WEbservice integration

-(void)webServiceForLoadingPurchaseDetails{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices loadAppraisalPurchaseDetails:[SMGlobalClass sharedInstance].hashValue andAppraisalID:self.objSummary.appraisalID.intValue andVinNum:self.objSummary.strVINNo];
    
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

-(void)webServiceForSavingPurchaseDetails{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    NSString *strPurchaseDetails;
    
    if([purchaseDetailObj.strPurchaseDetailsID length] == 0)
        strPurchaseDetails = @"";
    else
        strPurchaseDetails = purchaseDetailObj.strPurchaseDetailsID;
    
     NSMutableURLRequest *requestURL = [SMWebServices savePurchaseDetails:[SMGlobalClass sharedInstance].hashValue andPurchaseDetailsId:strPurchaseDetails andAccountNum:txtAccount.text andAppraisalID:self.objSummary.appraisalID andBoughtFrom:txtBroughtFrom.text andComments:txtviewComments.text andDate:txtDate.text andDetails:txtDetails.text andFinanceHouse:txtFinanceHouse.text andSettlementR:txtSettlement.text andClientID:[SMGlobalClass sharedInstance].strClientID andVinNum:self.objSummary.strVINNo];
    
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
    if ([elementName isEqualToString:@"PurchaseDetail"])
    {
        purchaseDetailObj =[[SMPurchaseDetailsObj alloc]init];
        arrmPurchaseDetails = [[NSMutableArray alloc]init];
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"elementName %@  currentNodeContent %@",elementName,currentNodeContent);
    
    if ([elementName isEqualToString:@"AppraisalId"])
    {
        purchaseDetailObj.strAppraisalID = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"AccountNo"])
    {
        purchaseDetailObj.strAccountNum = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"BoughtFrom"])
    {
        purchaseDetailObj.strBoughtFrom = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Comments"])
    {
        purchaseDetailObj.strComments = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Date"])
    {
        purchaseDetailObj.strDate = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Details"])
    {
        purchaseDetailObj.strDetails = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"FinanceHouse"])
    {
        purchaseDetailObj.strFinanceHouse = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"PurchaseDetailsId"])
    {
        purchaseDetailObj.strPurchaseDetailsID = currentNodeContent ;
    }
    else if ([elementName isEqualToString:@"SettlementR"])
    {
        purchaseDetailObj.strSettlement = [NSString stringWithFormat:@"%d",currentNodeContent.intValue];
    }
   
   else if ([elementName isEqualToString:@"PurchaseDetail"]) {
        [arrmPurchaseDetails addObject:purchaseDetailObj];
        
    }
    else if ([elementName isEqualToString:@"PassOrFailed"]) {
       
       {
           if([currentNodeContent isEqualToString:@"true"])
           {
               
               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Purchase details saved successfully" preferredStyle:UIAlertControllerStyleAlert];
               
               UIAlertAction* okButton = [UIAlertAction
                                          actionWithTitle:@"Ok"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action) {
                                              //Handle your yes please button action here
                                              [self.navigationController popViewControllerAnimated:YES];
                                          }];
               
               [alertController addAction:okButton];
               [self presentViewController:alertController animated:YES completion:nil];
               
           }
           
       }
       
   }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"reached here...");
    SMPurchaseDetailsObj *purchaseDetailsObj = [arrmPurchaseDetails objectAtIndex:0];
    txtBroughtFrom.text = purchaseDetailsObj.strBoughtFrom;
    purchaseDetailsObj.strDate = [[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:purchaseDetailsObj.strDate
                                                                                             withFormat:7];
    
    txtDate.text = purchaseDetailsObj.strDate;
    txtAccount.text = purchaseDetailsObj.strAccountNum;
    txtDetails.text = purchaseDetailsObj.strDetails;
    txtSettlement.text = purchaseDetailsObj.strSettlement;
    txtFinanceHouse.text = purchaseDetailsObj.strFinanceHouse;
    txtviewComments.text = purchaseDetailsObj.strComments;
    
    
    
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

@end
