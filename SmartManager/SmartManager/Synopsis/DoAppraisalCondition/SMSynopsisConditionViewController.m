//
//  SMSynopsisConditionViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 04/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMSynopsisConditionViewController.h"
#import "SMCustomTextFieldForDropDown.h"
#import "SMCustomPopUpTableView.h"
#import "SMCustomColor.h"
#import "SMCustomButtonBlue.h"
#import "CustomTextView.h"
#import "SMDropDownObject.h"
#import "SMSynopsisConditionCell.h"
#import "SMInteriorReconditioningObject.h"
#import "SMConditionOptionsObject.h"

@interface SMSynopsisConditionViewController ()
{
    
    IBOutlet UITableView *tblViewCondition;
    
    IBOutlet UIView *viewFooter;
    
    IBOutlet UIView *viewFooteriPad;
    
    
    IBOutlet SMCustomTextFieldForDropDown *txtFieldConditionDropdown;
    
    IBOutlet CustomTextView *txtViewComment;
    
    NSMutableArray *arrmForCondition;
    NSMutableArray *arrmConditionDropdown;
    NSArray *arrConditionData;
    SMInteriorReconditioningObject *objInteriorReconditioning;
    SMConditionOptionsObject *objIndividualOptionsObj;
    
    BOOL isIdentityUnderOptionsTag;
    int selectedConditionID;
    
   
}
@end

@implementation SMSynopsisConditionViewController

- (void)viewDidLoad {
  
    
    // Do any additional setup after loading the view from its nib.
    
    [super viewDidLoad];
    
    [self registerNibForTableView];
    [self addingProgressHUD];
    isIdentityUnderOptionsTag = NO;
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Condition"];
    
    arrmForCondition = [[NSMutableArray alloc] init];
    arrmConditionDropdown = [[NSMutableArray alloc] init];
    arrConditionData   = [NSArray arrayWithObjects:@"Excellent",@"Very Good",@"Good",@"Poor",@"Very Poor", nil];
    [self getConditionDropDown];
    [self webServiceForLoadingVehicleCondition];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

-(void) getConditionDropDown{
    
    
    for(int i=0;i<5;i++)
    {
        SMDropDownObject *objCondition = [[SMDropDownObject alloc] init];
        objCondition.strSortTextID = i+1;
        objCondition.strMakeId = [NSString stringWithFormat:@"%d",i+1];
        objCondition.strSortText = [arrConditionData objectAtIndex:i];
        objCondition.strMakeName = [arrConditionData objectAtIndex:i];
        [arrmConditionDropdown addObject:objCondition];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == txtFieldConditionDropdown)
    {  [self.view endEditing:YES];
        [textField resignFirstResponder];
        
        /*************  your Request *******************************************************/
        [textField resignFirstResponder];
        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
        SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
        [popUpView getTheDropDownData:arrmConditionDropdown withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
        [self.view addSubview:popUpView];
        
        /*************  your Request *******************************************************/
        /*************  your Response *******************************************************/
        
        [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear)
         {
             NSLog(@"selected text = %@",selectedTextValue);
             NSLog(@"selected ID = %d",selectIDValue);
             
             textField.text = selectedTextValue;
             selectedConditionID = selectIDValue;
         }];
    }
}

#pragma mark - User Define Functions
-(void) registerNibForTableView
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [tblViewCondition registerNib:[UINib nibWithNibName:@"SMSynopsisConditionCell" bundle:nil]        forCellReuseIdentifier:@"SMSynopsisConditionCell"];
    }
    else
    {
        [tblViewCondition registerNib:[UINib nibWithNibName:@"SMSynopsisConditionCell~ipad" bundle:nil]        forCellReuseIdentifier:@"SMSynopsisConditionCell"];
    }
    
    [tblViewCondition setTableFooterView:viewFooter];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
  
    [textField resignFirstResponder];
   
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
}

#pragma mark - Text View Delegate

-(void)textViewDidEndEditing:(UITextView *)textView{
    [txtViewComment resignFirstResponder];

}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [txtViewComment resignFirstResponder];
    return YES;
}

#pragma mark - tableView delegate methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrmForCondition.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier= @"SMSynopsisConditionCell";
    
    SMSynopsisConditionCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [dynamicCell.radioBtnYes addTarget:self action:@selector(radioBtnYesPressed:) forControlEvents:UIControlEventTouchUpInside];
    [dynamicCell.radioBtnNo addTarget:self action:@selector(radioBtnNoPressed:) forControlEvents:UIControlEventTouchUpInside];
    [dynamicCell.radioBtnLow addTarget:self action:@selector(radioLowYesPressed:) forControlEvents:UIControlEventTouchUpInside];
    dynamicCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    SMInteriorReconditioningObject *individualObj = [arrmForCondition objectAtIndex:indexPath.row];
   
    dynamicCell.radioBtnYes.tag = indexPath.row;
    dynamicCell.radioBtnNo.tag = indexPath.row;
    dynamicCell.radioBtnLow.tag = indexPath.row;
    
    dynamicCell.lblConditionName.text =individualObj.strTitle;
    SMConditionOptionsObject *individualOptionsObj1 = [individualObj.arrmOptions objectAtIndex:0];
    dynamicCell.radioBtnYes.selected =individualOptionsObj1.isOptionSelected;
    SMConditionOptionsObject *individualOptionsObj2 = [individualObj.arrmOptions objectAtIndex:1];
    dynamicCell.radioBtnNo.selected =individualOptionsObj2.isOptionSelected;
    if(individualObj.arrmOptions.count >2)
    {
        dynamicCell.viewContainingLow.hidden = NO;
        SMConditionOptionsObject *individualOptionsObj3 = [individualObj.arrmOptions objectAtIndex:2];
        dynamicCell.radioBtnLow.selected =individualOptionsObj3.isOptionSelected;
    }
    else
       dynamicCell.viewContainingLow.hidden = YES;
    
    [dynamicCell.radioBtnYes addTarget:self action:@selector(radioBtnYesPressed:) forControlEvents:UIControlEventTouchUpInside];
    [dynamicCell.radioBtnNo addTarget:self action:@selector(radioBtnNoPressed:) forControlEvents:UIControlEventTouchUpInside];
    [dynamicCell.radioBtnLow addTarget:self action:@selector(radioLowYesPressed:) forControlEvents:UIControlEventTouchUpInside];
    dynamicCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return dynamicCell;
    
}


#pragma mark - WEbservice integration

-(void)webServiceForLoadingVehicleCondition{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
     NSMutableURLRequest *requestURL = [SMWebServices loadVehicleCondition:[SMGlobalClass sharedInstance].hashValue andAppraisalID:self.objSummary.appraisalID.intValue andVinNum:self.objSummary.strVINNo];
    
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
-(void)webServiceForSavingVehicleCondition{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
       NSMutableURLRequest *requestURL = [SMWebServices saveVehicleCondition:[SMGlobalClass sharedInstance].hashValue andConditionsArray:arrmForCondition andRootConditionID:@"" andAppraisalID:self.objSummary.appraisalID andOverallConditionID:[NSString stringWithFormat:@"%d",selectedConditionID] andComments:txtViewComment.text andClientID:[SMGlobalClass sharedInstance].strClientID andVin:self.objSummary.strVINNo];
    
    
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
    if ([elementName isEqualToString:@"Condition"])
    {
        objInteriorReconditioning =[[SMInteriorReconditioningObject alloc]init];
    }
    /*if ([elementName isEqualToString:@"Items"])
    {
        objInteriorReconditioning.arrmOptions = [[NSMutableArray alloc] init];
    }*/
    if ([elementName isEqualToString:@"Options"])
    {
        isIdentityUnderOptionsTag = YES;
    }
    if ([elementName isEqualToString:@"Answer"])
    {
        objIndividualOptionsObj =[[SMConditionOptionsObject alloc]init];
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"string = %@",string);
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"Identity"])
    {
        if(!isIdentityUnderOptionsTag)
            objInteriorReconditioning.strInteriorReconditioningValue = currentNodeContent;
        else
            objIndividualOptionsObj.optionID = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Name"])
    {
        if([currentNodeContent containsString:@"&"])
        {
            NSArray *arr = [currentNodeContent componentsSeparatedByString:@"&"];
            NSString *string  = [NSString stringWithFormat:@"%@ & %@",arr[0],arr[1]];
            objInteriorReconditioning.strTitle = string;
        }
        else
            objInteriorReconditioning.strTitle = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Comment"])
    {
        NSLog(@"CommentValue = %@",currentNodeContent);
        txtViewComment.text = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"OverallCondition"])
    {
        switch (currentNodeContent.intValue) {
            case 1:
                txtFieldConditionDropdown.text = @"Excellent";
                break;
            case 2:
                txtFieldConditionDropdown.text = @"Very Good";
                break;
            case 3:
                txtFieldConditionDropdown.text = @"Good";
                break;
            case 4:
                txtFieldConditionDropdown.text = @"Poor";
                break;
            case 5:
                txtFieldConditionDropdown.text = @"Very Poor";
                break;
                
            default:
                break;
        }
    }
    else if ([elementName isEqualToString:@"Value"])
    {
        objIndividualOptionsObj.optionValue = currentNodeContent;
        
    }
    else if ([elementName isEqualToString:@"Selected"])
    {
        objIndividualOptionsObj.isOptionSelected = currentNodeContent.boolValue;
        
    }
    else if ([elementName isEqualToString:@"Answer"])
    {
        [objInteriorReconditioning.arrmOptions addObject:objIndividualOptionsObj];
        
    }
    else if ([elementName isEqualToString:@"Options"])
    {
        isIdentityUnderOptionsTag = NO;
    }
    if ([elementName isEqualToString:@"Condition"]) {
        [arrmForCondition addObject:objInteriorReconditioning];
        
    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog( @"arrAyCount = %lu",(unsigned long)arrmForCondition.count);
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        tblViewCondition.tableFooterView = viewFooter;
    else
        tblViewCondition.tableFooterView = viewFooteriPad;
    
    [tblViewCondition reloadData];
    [self hideProgressHUD];
}

- (IBAction)radioBtnYesPressed:(UIButton*)sender {
    
    UIButton *button = sender;
    button.selected = !button.selected;
    
    SMInteriorReconditioningObject *individualObj = [arrmForCondition objectAtIndex:[sender tag]];
    
    SMConditionOptionsObject *individualOptionsObj1 = [individualObj.arrmOptions objectAtIndex:0];
    individualOptionsObj1.isOptionSelected = button.isSelected;
    
    if(button.isSelected)
    {
        SMConditionOptionsObject *individualOptionsObj2 = [individualObj.arrmOptions objectAtIndex:1];
        individualOptionsObj2.isOptionSelected = NO;
        
        if(individualObj.arrmOptions.count > 2)
        {
            SMConditionOptionsObject *individualOptionsObj3 = [individualObj.arrmOptions objectAtIndex:2];
            individualOptionsObj3.isOptionSelected = NO;
        
        }
    }
    [tblViewCondition reloadData];
}

- (IBAction)radioBtnNoPressed:(UIButton*)sender {
    
     UIButton *button = sender;
    button.selected = !button.selected;
    SMInteriorReconditioningObject *individualObj = [arrmForCondition objectAtIndex:[sender tag]];
    
    SMConditionOptionsObject *individualOptionsObj1 = [individualObj.arrmOptions objectAtIndex:1];
    individualOptionsObj1.isOptionSelected = button.isSelected;
    
    if(button.isSelected)
    {
        SMConditionOptionsObject *individualOptionsObj2 = [individualObj.arrmOptions objectAtIndex:0];
        individualOptionsObj2.isOptionSelected = NO;
        
        if(individualObj.arrmOptions.count > 2)
        {
            SMConditionOptionsObject *individualOptionsObj3 = [individualObj.arrmOptions objectAtIndex:2];
            individualOptionsObj3.isOptionSelected = NO;
            
        }
    }
    [tblViewCondition reloadData];
}

- (IBAction)radioLowYesPressed:(UIButton*)sender {
    
     UIButton *button = sender;
    button.selected = !button.selected;
    SMInteriorReconditioningObject *individualObj = [arrmForCondition objectAtIndex:[sender tag]];
    
    SMConditionOptionsObject *individualOptionsObj = [individualObj.arrmOptions objectAtIndex:2];
    individualOptionsObj.isOptionSelected = button.isSelected;
    
    if(button.isSelected)
    {
        SMConditionOptionsObject *individualOptionsObj2 = [individualObj.arrmOptions objectAtIndex:0];
        individualOptionsObj2.isOptionSelected = NO;
        
        SMConditionOptionsObject *individualOptionsObj3 = [individualObj.arrmOptions objectAtIndex:1];
            individualOptionsObj3.isOptionSelected = NO;
            
       
    }
    [tblViewCondition reloadData];
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

- (IBAction)btnSaveDidClicked:(id)sender
{
    [self webServiceForSavingVehicleCondition];
    
}
@end
