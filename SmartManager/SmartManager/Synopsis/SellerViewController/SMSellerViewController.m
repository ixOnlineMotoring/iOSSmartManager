//
//  SMSellerViewController.m
//  Smart Manager
//
//  Created by Sandeep on 06/01/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMSellerViewController.h"
#import "SMCustomColor.h"
#import "SMSellerViewCell.h"
#import "SMSellerFooterView.h"
#import "SMSellerDetailsObj.h"
#import "SMWebServices.h"
#import "SMCustomTextField.h"

@interface SMSellerViewController ()
{
    IBOutlet UIView *viewForHeader;
    SMSellerFooterView *sellerFooterView;
    SMSellerDetailsObj *sellerObject;
    NSMutableArray *arrmSellerDetails;
    
    IBOutlet SMCustomTextField *txtFieldName;
    
    IBOutlet SMCustomTextField *txtFieldSurName;
    
    IBOutlet SMCustomTextField *txtFieldCompany;
    
    IBOutlet SMCustomTextField *txtFieldID;
    
    BOOL isPassFailResultForSave;
    
    
}
@end

@implementation SMSellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Seller"];
    [tblSellerView registerNib:[UINib nibWithNibName: @"SMSellerViewCell" bundle:nil] forCellReuseIdentifier:@"SMSellerViewCell"];
    
    
    tblSellerView.tableHeaderView = viewForHeader;
    
    NSArray *arraySMSellerFooterView = [[NSBundle mainBundle]loadNibNamed:@"SMSellerFooterView" owner:self options:nil];
    sellerFooterView = [arraySMSellerFooterView objectAtIndex:0];
    tblSellerView.tableFooterView = sellerFooterView;
    [sellerFooterView.btnSave addTarget:self action:@selector(btnSaveDidClicked) forControlEvents:UIControlEventTouchUpInside];
    tblSellerView.estimatedRowHeight = 180.0f;
    tblSellerView.rowHeight = UITableViewAutomaticDimension;
    [self addingProgressHUD];
    [self webServiceForLoadingSellerDetails];
}

-(void)viewWillAppear:(BOOL)animated{
    
   


}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

     if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
         return 102;
     }
    else
        return 133.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"SMSellerViewCell";

    SMSellerViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    SMSellerDetailsObj *sellerObj = [arrmSellerDetails objectAtIndex:0];
    dynamicCell.lblAge.text = sellerObj.strAge;
    dynamicCell.lblDOB.text = sellerObj.strDOB;
    dynamicCell.lblGender.text = sellerObj.strGender;
    dynamicCell.lblDriverLicence.text = sellerObj.strDriverLicence;
    
    dynamicCell.backgroundColor = [UIColor blackColor];
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dynamicCell.backgroundColor = [UIColor blackColor];
    
    return dynamicCell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnScanDriverLicenceDidClciked:(id)sender
{
    SMCustomerDLScanViewController *scanObject = [[SMCustomerDLScanViewController alloc] initWithNibName:@"SMCustomerDLScanViewController" bundle:nil];
    
    scanObject.isComingFromStockAudit = NO;
    scanObject.isComingFromSynopsis = NO;
    scanObject.strFromViewController  = @"SMSellerViewController";
    [self.navigationController pushViewController:scanObject animated:YES];
    
}

-(void) btnSaveDidClicked{

    [self.view endEditing:YES];
    [self webserviceCallForSavingSellerDetails];

}

#pragma mark - WEbservice integration

-(void)webServiceForLoadingSellerDetails{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices loadAppraisalSellerDetails:[SMGlobalClass sharedInstance].hashValue andAppraisalID:self.objSummary.appraisalID.intValue andVinNum:self.objSummary.strVINNo];
    
    
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

-(void) webserviceCallForSavingSellerDetails
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
   
    
    NSMutableURLRequest * requestURL = [SMWebServices saveSellerInfoWithUserHash:[SMGlobalClass sharedInstance].hashValue andAppraisalID:sellerObject.strAppraisalId.intValue andCompany:txtFieldCompany.text andEmailAddress:sellerFooterView.txtFieldEmailID.text andIDNumber:txtFieldID.text andMobileNum:sellerFooterView.txtFieldMobilNum.text andName:txtFieldName.text andSurname:txtFieldSurName.text andSellerID:sellerObject.strSellerId.intValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andVIN:self.objSummary.strVINNo andStreetAddrs:sellerFooterView.txtViewComment.text];
    
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
    if ([elementName isEqualToString:@"SellerInfo"])
    {
        sellerObject =[[SMSellerDetailsObj alloc]init];
        arrmSellerDetails = [[NSMutableArray alloc]init];
    }
   else if ([elementName isEqualToString:@"SaveSellerInformationResult"])
    {
        isPassFailResultForSave = YES;
    }
    else if ([elementName isEqualToString:@"LoadSellerInformationResult"])
    {
         isPassFailResultForSave = NO;
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"AppraisalId"])
    {
        sellerObject.strAppraisalId = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Age"])
    {
        if(currentNodeContent.length == 0 || [currentNodeContent isEqualToString:@"0"])
        sellerObject.strAge = @"Age?";
        else
        sellerObject.strAge = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Company"])
    {
        sellerObject.strCompany = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"DOB"])
    {
        if([currentNodeContent isEqualToString:@"0"])
            sellerObject.strDOB = @"DOB?";
        else
        {
            NSLog(@"CurremtNode Date = %@",currentNodeContent);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
            NSDate *dateReceived = [dateFormatter dateFromString:currentNodeContent];
            
            dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"dd MMM yyyy"];
            
            sellerObject.strDOB = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dateReceived]];
            NSLog(@"final Date = %@",sellerObject.strDOB);
        }
    }
    else if ([elementName isEqualToString:@"Email"])
    {
        sellerObject.strEmail = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"IDNumber"])
    {
        sellerObject.strIDNumber = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Mobile"])
    {
        sellerObject.strMobile = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Name"])
    {
        sellerObject.strName = currentNodeContent ;
    }
    else if ([elementName isEqualToString:@"Surname"])
    {
        sellerObject.strSurname = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"GenderType"])
    {
        if([currentNodeContent length] == 0)
           sellerObject.strGender = @"Gender?";
        else
        sellerObject.strGender = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"DriversLicenceName"])
    {
        if([sellerObject.strDriverLicence length] == 0)
        sellerObject.strDriverLicence = currentNodeContent;
        else
            sellerObject.strDriverLicence = [NSString stringWithFormat:@"%@, %@",sellerObject.strDriverLicence,currentNodeContent];
    }
    else if ([elementName isEqualToString:@"SellerId"])
    {
        sellerObject.strSellerId = currentNodeContent;

    }
    else if ([elementName isEqualToString:@"StreetAddress"]) {
        sellerObject.strStreetAddress = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"SellerInfo"]) {
        [arrmSellerDetails addObject:sellerObject];
    
    }
    else if ([elementName isEqualToString:@"PassOrFailed"]) {
    
         if(isPassFailResultForSave)
         {
            if([currentNodeContent isEqualToString:@"true"])
            {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Seller information saved successfully" preferredStyle:UIAlertControllerStyleAlert];
                
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
    else if ([elementName isEqualToString:@"PassOrFailed"])
    {
    
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!isPassFailResultForSave)
            {
                NSLog(@"reached here...");
                SMSellerDetailsObj *sellerObj = [arrmSellerDetails objectAtIndex:0];
                txtFieldName.text = sellerObj.strName;
                txtFieldSurName.text = sellerObj.strSurname;
                txtFieldID.text = sellerObj.strIDNumber;
                txtFieldCompany.text = sellerObj.strCompany;
                sellerFooterView.txtFieldEmailID.text = sellerObj.strEmail;
                sellerFooterView.txtFieldMobilNum.text = sellerObj.strMobile;
                sellerFooterView.txtViewComment.text = sellerObj.strStreetAddress;
                [tblSellerView reloadData];
            }
            
            
        });
        
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
