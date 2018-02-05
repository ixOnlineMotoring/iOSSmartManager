//
//  SMAddEditTradePartnersViewController.m
//  Smart Manager
//
//  Created by Sandeep on 06/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMAddEditTradePartnersViewController.h"
#import "SMCustomColor.h"
#import "SMSelectTypeObject.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"

@interface SMAddEditTradePartnersViewController ()

@end

@implementation SMAddEditTradePartnersViewController
@synthesize isAddPartners;
@synthesize saveButton;
@synthesize removeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addingProgressHUD];

    self.saveButton.layer.cornerRadius = 4.0;
    self.removeButton.layer.cornerRadius = 4.0;

    self.removeButton.layer.cornerRadius = 4.0;
    self.saveButton.layer.cornerRadius = 4.0;

    self.viewForClientsDropdown.layer.masksToBounds = NO;
    [self.viewForClientsDropdown.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    self.viewForClientsDropdown.layer.shadowOffset = CGSizeMake(-5, 5);

    self.viewForClientsDropdown.layer.cornerRadius = 8;
    self.tblViewType.layer.cornerRadius = 8;
    self.viewForClientsDropdown.layer.shadowRadius = 5;
    self.viewForClientsDropdown.layer.shadowOpacity = 0.5;
    selectTypeArray = [[NSMutableArray alloc]init];
    selectPartnerArray = [[NSMutableArray alloc]init];
    fromDayArray = [[NSMutableArray alloc] init];

    tableOriginalFrame = self.tblViewType.frame;
    viewForClientsDropdownOriginalFrame = self.viewForClientsDropdown.frame;

    for (int i = 1; i<=3; i++) {
        SMSelectTypeObject *selectTypeObj = [[SMSelectTypeObject alloc]init];

        switch (i) {
            case 1:
            {
                selectTypeObj.selectTypeString = @"Dealer";
                selectTypeObj.ID = 1;
                [selectTypeArray addObject:selectTypeObj];

            }
                break;
            case 2:
            {
                selectTypeObj.selectTypeString = @"Group";
                selectTypeObj.ID = 2;
                [selectTypeArray addObject:selectTypeObj];
            }
                break;
            case 3:
            {
                selectTypeObj.selectTypeString = @"Make";
                selectTypeObj.ID = 3;
                [selectTypeArray addObject:selectTypeObj];


            }
                break;
            default:
                break;
        }
    }

    if (!self.isAddPartners) {

        self.navigationItem.titleView = [SMCustomColor setTitle:@"Edit Trade Partner"];
        removeButton.hidden = NO;

        settingsID = self.obj.settingID;
        [self setTradePriod];
        [self getLoadTradePartner];
    }
    else{
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Add Trade Partner"];

        settingsID = 0;
        removeButton.hidden = YES;
    }
}

-(void)setTypeId:(NSString *)type{

}
-(void)setTradePriod{
    switch (self.obj.traderPeriod) {
        case -1:
        {
            fromDayTextField.text = @"No Access";
        }
            break;
        case 0:
        {
            fromDayTextField.text = @"Nil days";
        }
            break;
        case 1:
        {
            fromDayTextField.text = [NSString stringWithFormat:@"+%d day",self.obj.traderPeriod];
        }
            break;
        default:
        {
            fromDayTextField.text = [NSString stringWithFormat:@"+%d days",self.obj.traderPeriod];
        }
            break;
    }
}

#pragma mark - Tableview datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (selectedTextFieldTag) {
        case 0:
            return [selectTypeArray count];
            break;
        case 1:
            return [selectPartnerArray count];
            break;
        case 2:
            return [fromDayArray count];
            break;

        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        return 43;
    }
    else
    {
        return 50;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.btnCancel;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        return 43.0;
    }
    else
    {
        return 60.0f;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier= @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:14.0];
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:20.0];
    }
    cell.backgroundColor = [UIColor clearColor];


    cell.accessoryType =UITableViewCellAccessoryNone;


    switch (selectedTextFieldTag) {
        case 0:
        {
            SMSelectTypeObject *selectTypeObj = (SMSelectTypeObject*)[selectTypeArray objectAtIndex:indexPath.row];

            cell.textLabel.text = selectTypeObj.selectTypeString;
        }
            break;
        case 1:
        {
            SMClassForNewTaskMembers *selectTypeObj = (SMClassForNewTaskMembers*)[selectPartnerArray objectAtIndex:indexPath.row];
            cell.textLabel.text = selectTypeObj.memberName;
        }

            break;
        case 2:
        {
            SMClassForNewTaskMembers *selectTypeObj = (SMClassForNewTaskMembers*)[fromDayArray objectAtIndex:indexPath.row];
            cell.textLabel.text = selectTypeObj.memberName;
        }

            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (selectedTextFieldTag) {
        case 0:
        {
            SMSelectTypeObject *clientObj = (SMSelectTypeObject*)[selectTypeArray objectAtIndex:indexPath.row];
            selectTypeTextField.text = clientObj.selectTypeString;
            selectTypeID = clientObj.ID;
            selectPartnerTextField.text = @"";
        }
            break;
        case 1:
        {
            SMClassForNewTaskMembers *selectTypeObj = (SMClassForNewTaskMembers*)[selectPartnerArray objectAtIndex:indexPath.row];;
            selectPartnerTextField.text = selectTypeObj.memberName;
            selectPartnerID = selectTypeObj.memberID;
        }
            break;
        case 2:
        {
            SMClassForNewTaskMembers *selectTypeObj = (SMClassForNewTaskMembers*)[fromDayArray objectAtIndex:indexPath.row];;
            fromDayTextField.text = selectTypeObj.memberName;
            if(selectTypeObj.memberID != -1)
            {
                self.tradeVechiclesCheckBoxButton.selected = YES;
            
            }
            else
            {
                self.tradeVechiclesCheckBoxButton.selected = NO;
            }
            selectFromDayID = selectTypeObj.memberID;
        }
            break;
        default:
            break;
    }

    [self dismissPopup];
}

- (IBAction)btnCancelDidClicked:(id)sender
{
    [self dismissPopup];
}

-(void) addingProgressHUD
{
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

#pragma mark- load popup
-(void)loadPopup
{
    [self.popUpView setFrame:[UIScreen mainScreen].bounds];
    [self.popUpView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.50]];
    [self.popUpView setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self.popUpView];
    [self.popUpView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [self.popUpView setAlpha:0.75];
         [self.popUpView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];

     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [self.popUpView setAlpha:1.0];

              [self.popUpView setTransform:CGAffineTransformIdentity];
          }
                          completion:^(BOOL finished)
          {
          }];

     }];
}

#pragma mark - dismiss popup
-(void)dismissPopup
{
    [self.popUpView setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self.popUpView];
    [UIView animateWithDuration:0.1 animations:^{
        [self.popUpView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [self.popUpView setAlpha:0.3];
              [self.popUpView setTransform:CGAffineTransformMakeScale(0.9    ,0.9)];

          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {

                   [self.popUpView setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [self.popUpView removeFromSuperview];
                   [self.popUpView setTransform:CGAffineTransformIdentity];

                   self.viewForClientsDropdown.frame = viewForClientsDropdownOriginalFrame;
                   self.tblViewType.frame =  tableOriginalFrame;
               }];
          }];
     }];
}
-(void) showAlrt:(NSString *)alertMeassge
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert;
            if (alert == nil)
            {
                alert  = [[UIAlertView alloc]initWithTitle:KLoaderTitle  message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            }

            [alert setMessage:alertMeassge];
            [alert show];
        });
    });
}
- (BOOL)textFieldShouldBeginEditing:(SMCustomTextFieldForDropDown *)textField{

    [textField resignFirstResponder];

    if (textField == selectTypeTextField) {

        selectedTextFieldTag = 0;

        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            self.viewForClientsDropdown.frame = CGRectMake(41, 222, 689, 230);
        }
        else{

            self.tblViewType.frame = CGRectMake(0, 123, 287, 160+38);
            self.viewForClientsDropdown.frame = CGRectMake(17, 123, 287, 160+38);
        }
        [self.tblViewType reloadData];
        selectTypeArray.count > 0 ? [self loadPopup] : [self showAlrt:@"No record(s) found."];
    }
    else if(textField == selectPartnerTextField){
        selectedTextFieldTag = 1;

        if ([selectTypeTextField.text isEqualToString:@""]) {
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Please select type" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {

            }];

        }
        else{
           
                if ([selectTypeTextField.text isEqualToString:@"Dealer"]) {
                    [self getAllTheAvailableClients];
                }
                else if ([selectTypeTextField.text isEqualToString:@"Make"]) {
                    [self loadingAllMakeListing];
                }
                else if ([selectTypeTextField.text isEqualToString:@"Group"]){
                    [self getTheClientsCorporateGroup];
                }
            }
    }
    
    else{
     
        selectedTextFieldTag = 2;
        [self getGetFromDays];
    }
    return NO;
}

-(void)loadingAllMakeListing
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    [selectPartnerArray removeAllObjects];
    NSMutableURLRequest *requestURL=[SMWebServices getMakeWithUserHash:[SMGlobalClass sharedInstance].hashValue withFromYear:0 withToYear:0];

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];

    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [self hideProgressHUD];
             return;
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

-(void)getAllTheAvailableClients
{

    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    [selectPartnerArray removeAllObjects];
    NSMutableURLRequest *requestURL=[SMWebServices getAllTheAvailableClientsCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue];

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];


    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {


         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
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

-(void)getTheClientsCorporateGroup
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    [selectPartnerArray removeAllObjects];
    NSMutableURLRequest *requestURL=[SMWebServices getClientCorporateGroupsCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andClientId:[[SMGlobalClass sharedInstance].strClientID intValue]];

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];


    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
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

-(void)getGetFromDays
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    [fromDayArray removeAllObjects];
    NSMutableURLRequest *requestURL=[SMWebServices getFromDaysWithUserHash:[SMGlobalClass sharedInstance].hashValue];

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];


    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
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
-(void)getLoadTradePartner{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    NSMutableURLRequest *requestURL=[SMWebServices getLoadTradePartnerWithUserHash:[SMGlobalClass sharedInstance].hashValue andType:self.obj.typeString andSettingsID:self.obj.settingID];

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];


    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
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

   
    if([elementName isEqualToString:@"member"])
    {
        membersObject = [[SMClassForNewTaskMembers alloc]init];
    }
    if ([elementName isEqualToString:@"client"]) {
        membersObject = [[SMClassForNewTaskMembers alloc]init];
    }
    if ([elementName isEqualToString:@"Make"]) {
        membersObject = [[SMClassForNewTaskMembers alloc]init];
    }
    if ([elementName isEqualToString:@"Group"]) {
        membersObject = [[SMClassForNewTaskMembers alloc]init];
    }
    if ([elementName isEqualToString:@"option"]) {
        membersObject = [[SMClassForNewTaskMembers alloc]init];
        membersObject.memberID = [[attributeDict valueForKey:@"value"] intValue];
    }
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

    // code for getting memebers
    if([elementName isEqualToString:@"memberID"])
    {
        membersObject.memberID = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"memberName"])
    {
        membersObject.memberName = currentNodeContent ;
    }
    if([elementName isEqualToString:@"member"])
    {
        [selectPartnerArray addObject:membersObject];
    }

    if ([elementName isEqualToString:@"Members"])
    {
        [self.tblViewType reloadData];
        selectPartnerArray.count > 0 ? [self loadPopup] : [self showAlrt:@"No record(s) found."];
    }

    //Getting Dealer info
    if([elementName isEqualToString:@"clientID"])
    {
        membersObject.memberID = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"clientName"])
    {
        membersObject.memberName = currentNodeContent ;
    }
    if([elementName isEqualToString:@"client"])
    {
        [selectPartnerArray addObject:membersObject];
    }
    if([elementName isEqualToString:@"Clients"])
    {
        [self.tblViewType reloadData];
        selectPartnerArray.count > 0 ? [self loadPopup] : [self showAlrt:@"No record(s) found."];
    }

    //Getting Make info
    if([elementName isEqualToString:@"id"])
    {
        membersObject.memberID = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"name"])
    {
        membersObject.memberName = currentNodeContent ;
    }
    if([elementName isEqualToString:@"Make"])
    {
        [selectPartnerArray addObject:membersObject];
    }
    if([elementName isEqualToString:@"Makes"])
    {
        [self.tblViewType reloadData];
        selectPartnerArray.count > 0 ? [self loadPopup] : [self showAlrt:@"No record(s) found."];
    }

    //get getFromDay
    if ([elementName isEqualToString:@"option"]) {
        membersObject.memberName = currentNodeContent;
        [fromDayArray addObject:membersObject];
    }
    if([elementName isEqualToString:@"options"])
    {
        [self.tblViewType reloadData];
        fromDayArray.count > 0 ? [self loadPopup] : [self showAlrt:@"No record(s) found."];
    }


    //Getting groups info
    if([elementName isEqualToString:@"ID"])
    {
        membersObject.memberID = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"Name"])
    {
        membersObject.memberName = currentNodeContent ;
    }
    if([elementName isEqualToString:@"Group"])
    {
        [selectPartnerArray addObject:membersObject];
    }
    
    if([elementName isEqualToString:@"GetClientCorprateGroupsResult"])
    {
        [self.tblViewType reloadData];
        selectPartnerArray.count > 0 ? [self loadPopup] : [self showAlrt:@"No record(s) found."];
    }
   
    //Get trade partner info
    if ([elementName isEqualToString:@"SettingID"]) {
        self.obj.settingID = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"TraderPeriod"]) {
        self.obj.traderPeriod = [currentNodeContent intValue];
        [self setTradePriod];
    }
    if ([elementName isEqualToString:@"AuctionAccess"]) {
        self.obj.auctionAccess = [currentNodeContent boolValue];
        self.tradeVechiclesCheckBoxButton.selected = self.obj.auctionAccess;
    }
    if ([elementName isEqualToString:@"TenderAccess"]) {
        self.obj.tenderAccess = [currentNodeContent boolValue];
        self.tenderVechiclesCheckBoxButton.selected = self.obj.tenderAccess;
    }
    if ([elementName isEqualToString:@"ID"]) {
        self.obj.ID = [currentNodeContent intValue];
        selectPartnerID = self.obj.ID;
    }
    if ([elementName isEqualToString:@"Name"]) {
        self.obj.nameString = currentNodeContent;
        selectPartnerTextField.text = self.obj.nameString;
    }
    if ([elementName isEqualToString:@"Type"]) {
        self.obj.typeString = currentNodeContent;
        selectTypeTextField.text = self.obj.typeString;
    }
    if ([elementName isEqualToString:@"TypeID"]) {
        self.obj.typeID = [currentNodeContent intValue];
        selectTypeID = self.obj.typeID;
    }


    if([elementName isEqualToString:@"Message"])
    {
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"reached here...");
    [self hideProgressHUD];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonDidClicked:(id)sender {

    if ([selectTypeTextField.text isEqualToString:@""]) {
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Please select type" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {

        }];
    }else if ([selectPartnerTextField.text isEqualToString:@""]){
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Please select partner" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {

        }];
    }
    else if (self.tradeVechiclesCheckBoxButton.isSelected && ([fromDayTextField.text isEqualToString:@"No Access"]))
    {
    
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Please select from day" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            
        }];
    }
    else
    {
        //Called Saved WS
        [HUD show:YES];
        [HUD setLabelText:KLoaderText];
        
        int fromDayValue;
        if(self.tradeVechiclesCheckBoxButton.isSelected)
        {
            fromDayValue = selectFromDayID;
        }
        else
        {
            fromDayValue = -1;
        }
        
        
        NSMutableURLRequest *requestURL=[SMWebServices SaveTradePartnerWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andSettingID:settingsID andTraderPeriod:fromDayValue andAuctionAccess:(int)self.tradeVechiclesCheckBoxButton.selected andTenderAccess:(int)self.tenderVechiclesCheckBoxButton.selected andId:selectPartnerID andName:selectPartnerTextField.text andType:selectTypeTextField.text andTypeID:selectTypeID];

        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];


        [NSURLConnection sendAsynchronousRequest:requestURL
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
         {

             [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

             if (error!=nil)
             {
                 SMAlert(@"Error", error.localizedDescription);
                 [HUD hide:YES];
             }
             else
             {
                 //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.

                 xmlParser = [[NSXMLParser alloc] initWithData: data];
                 [xmlParser setDelegate: self];
                 [xmlParser setShouldResolveExternalEntities:YES];
                 [xmlParser parse];
             }
         }];
    }
}
- (IBAction)removeButtonDidClicked:(id)sender {

    NSMutableURLRequest *requestURL=[SMWebServices removeTradePartnerWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andSettingID:settingsID andTraderPeriod:selectFromDayID andAuctionAccess:(int)self.tradeVechiclesCheckBoxButton.selected andTenderAccess:(int)self.tenderVechiclesCheckBoxButton.selected andId:selectPartnerID andName:selectPartnerTextField.text andType:selectTypeTextField.text andTypeID:selectTypeID];

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];


    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {


         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.

             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (IBAction)checkBoxDidClicked:(id)sender {

    UIButton *button = (UIButton *)sender;

    switch (button.tag) {
        case 0:
        {
           self.tradeVechiclesCheckBoxButton.selected = !button.selected;
            
            if(!self.tradeVechiclesCheckBoxButton.selected)
                fromDayTextField.text = @"No Access";
            
        }
            break;
        case 1:{
            self.tenderVechiclesCheckBoxButton.selected = !button.selected;
        }

            break;
        default:
            break;
    }
}
@end
