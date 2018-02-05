//
//  SMAddEditTradeMemeberViewController.m
//  Smart Manager
//
//  Created by Sandeep on 06/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMAddEditTradeMemeberViewController.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMClassForNewTaskMembers.h"
#import "UIBAlertView.h"

@interface SMAddEditTradeMemeberViewController ()

@end

@implementation SMAddEditTradeMemeberViewController
@synthesize isAddMember;
@synthesize obj;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addingProgressHUD];
    arrayOfMembers = [[NSMutableArray alloc]init];
    removeButton.layer.cornerRadius = 4.0;
    saveButton.layer.cornerRadius = 4.0;
    self.viewForClientsDropdown.layer.masksToBounds = NO;
    [self.viewForClientsDropdown.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];

    self.viewForClientsDropdown.layer.shadowOffset = CGSizeMake(-5, 5);

    self.viewForClientsDropdown.layer.cornerRadius = 8;
    self.tblViewType.layer.cornerRadius = 8;
    self.viewForClientsDropdown.layer.shadowRadius = 5;
    self.viewForClientsDropdown.layer.shadowOpacity = 0.5;

    if (!self.isAddMember) {

        self.navigationItem.titleView = [SMCustomColor setTitle:@"Edit Trade Member"];
        memeberTextField.userInteractionEnabled = NO;
        removeButton.hidden = NO;

        [self webServiceForGetListTradeMembers];
    }
    else{
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Add Trade Member"];
        removeButton.hidden = YES;
        saveButton.frame = CGRectMake(8.0, saveButton.frame.origin.y, 304, saveButton.frame.size.height);
        
        memeberTextField.userInteractionEnabled = YES;
        self.obj.tradeBuyBoolValue = NO;
        self.obj.tradeSellBoolValue = NO;
        self.obj.tenderAcceptBoolValue = NO;
        self.obj.tenderDeclineBoolValue = NO;
        self.obj.tenderManagerBoolValue = NO;
        self.obj.tenderAuditorBoolValue = NO;
        [buyButton setSelected:self.obj.tradeBuyBoolValue];
        [sellButton setSelected:self.obj.tradeSellBoolValue];
        [acceptButton setSelected:self.obj.tenderAcceptBoolValue];
        [declineButton setSelected:self.obj.tenderDeclineBoolValue];
        [managerButton setSelected:self.obj.tenderManagerBoolValue];
        [auditorButton setSelected:self.obj.tenderAuditorBoolValue];

       
    }
    
}

-(void)getAllTheTradeMembersFromTheServer
{
    NSMutableURLRequest *requestURL=[SMWebServices getAllTheMembersForSettingsMembersToUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];

    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
         }
         else
         {
             [arrayOfMembers removeAllObjects];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)webServiceForGetListTradeMembers{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL = [SMWebServices getLoadTradeMemberWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andMemberID:(int)self.obj.memberID];

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
    if([elementName isEqualToString:@"member"])
    {
        self.membersObject = [[SMClassForNewTaskMembers alloc]init];
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

    if ([elementName isEqualToString:@"ID"])
    {
        self.obj.ID = [currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"MemberID"])
    {
        self.obj.memberID = [currentNodeContent intValue];
        selectedClientId = (int)self.obj.memberID;
    }
    else if ([elementName isEqualToString:@"MemberName"])
    {
        self.obj.memberNameString = currentNodeContent;
        memeberTextField.text = self.obj.memberNameString;
    }
    else if ([elementName isEqualToString:@"TradeBuy"])
    {
        self.obj.tradeBuyBoolValue = [currentNodeContent boolValue];
    }
    else if ([elementName isEqualToString:@"TradeSell"])
    {
        self.obj.tradeSellBoolValue = [currentNodeContent boolValue];
    }
    else if ([elementName isEqualToString:@"TenderAccept"])
    {
        self.obj.tenderAcceptBoolValue = [currentNodeContent boolValue];
    }
    else if ([elementName isEqualToString:@"TenderDecline"])
    {
        self.obj.tenderDeclineBoolValue = [currentNodeContent boolValue];
    }
    else if ([elementName isEqualToString:@"TenderManager"])
    {
        self.obj.tenderManagerBoolValue = [currentNodeContent boolValue];
    }
    else if ([elementName isEqualToString:@"TenderAuditor"])
    {
        self.obj.tenderAuditorBoolValue = [currentNodeContent boolValue];
    }

    if ([elementName isEqualToString:@"TradeMemberObject"])
    {
        [buyButton setSelected:self.obj.tradeBuyBoolValue];
        [sellButton setSelected:self.obj.tradeSellBoolValue];
        [acceptButton setSelected:self.obj.tenderAcceptBoolValue];
        [declineButton setSelected:self.obj.tenderDeclineBoolValue];
        [managerButton setSelected:self.obj.tenderManagerBoolValue];
        [auditorButton setSelected:self.obj.tenderAuditorBoolValue];
    }

    if([elementName isEqualToString:@"memberID"])
    {
        self.membersObject.memberID = [currentNodeContent intValue];
        NSLog(@"MEMBERID = %d",self.membersObject.memberID);
    }
    if([elementName isEqualToString:@"memberName"])
    {
        self.membersObject.memberName = currentNodeContent ;
    }
    if([elementName isEqualToString:@"member"])
    {
        [arrayOfMembers addObject:self.membersObject];
    }

    if([elementName isEqualToString:@"Members"])
    {
        // [self.tblViewType reloadData];
        arrayOfMembers.count > 0 ? [self loadPopup] : [self showAlrt:@"No record(s) found."];
    }

    
    if([elementName isEqualToString:@"Message"])
    {
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel)
            {

                [[SMMemeberUpdateList sharedManager]calledMemeberUpdateListDelegateMethod:self.obj andIsUpdate:self.isAddMember];

                [self.navigationController popViewControllerAnimated:YES];

                return;
            }

        }];
    }
}
- (BOOL)textFieldShouldBeginEditing:(SMCustomTextFieldForDropDown *)textField{

    [textField resignFirstResponder];
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    [self getAllTheTradeMembersFromTheServer];
    

    return NO;
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"reached here...");
   
    [self hideProgressHUD];
}
-(void)webServiceForSaveTradeMember{


}
-(IBAction)saveButtonDidclicked:(id)sender{


    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    NSMutableURLRequest *requestURL = [SMWebServices setSaveTradeMemberWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andTradeMemberID:(int)self.obj.ID andMemberID:(int)self.obj.memberID andMemberName:self.obj.memberNameString andCanBuy:self.obj.tradeBuyBoolValue andCanSell:self.obj.tradeSellBoolValue andCanAccept:self.obj.tenderAcceptBoolValue andCanDecline:self.obj.tenderDeclineBoolValue andIsManager:self.obj.tenderManagerBoolValue andIsAuditor:self.obj.tenderAuditorBoolValue];

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

-(IBAction)removeButtonDidclicked:(id)sender{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    NSMutableURLRequest *requestURL = [SMWebServices removeTradeMemberWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andTradeMemberID:(int)self.obj.ID andMemberID:(int)self.obj.memberID];

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

-(IBAction)checkBoxButtonDidclicked:(id)sender{

    UIButton *button = (UIButton *)sender;

    switch (button.tag) {
        case 0:
        {
            self.obj.tradeBuyBoolValue = !self.obj.tradeBuyBoolValue;
            [buyButton setSelected:self.obj.tradeBuyBoolValue];
        }
            break;
        case 1:
        {

                self.obj.tradeSellBoolValue = !self.obj.tradeSellBoolValue;
                [sellButton setSelected:self.obj.tradeSellBoolValue];
            }
            break;
        case 2:
        {

                self.obj.tenderAcceptBoolValue = !self.obj.tenderAcceptBoolValue;
                [acceptButton setSelected:self.obj.tenderAcceptBoolValue];


        }
            break;
        case 3:
        {

                self.obj.tenderDeclineBoolValue = !self.obj.tenderDeclineBoolValue;
                [declineButton setSelected:self.obj.tenderDeclineBoolValue];


        }
            break;
        case 4:
        {

                self.obj.tenderManagerBoolValue = !self.obj.tenderManagerBoolValue;
                [managerButton setSelected:self.obj.tenderManagerBoolValue];



        }
            break;
        case 5:
        {

                self.obj.tenderAuditorBoolValue = !self.obj.tenderAuditorBoolValue;
                [auditorButton setSelected:self.obj.tenderAuditorBoolValue];

        }
            break;

        default:
            break;
    }
}

#pragma mark - ProgressBar Method

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

#pragma mark - Tableview datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayOfMembers count];
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

    SMClassForNewTaskMembers *clientObj = (SMClassForNewTaskMembers*)[arrayOfMembers objectAtIndex:indexPath.row];

    cell.textLabel.text = clientObj.memberName;


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    SMClassForNewTaskMembers *clientObj = (SMClassForNewTaskMembers*)[arrayOfMembers objectAtIndex:indexPath.row];
    memeberTextField.text = clientObj.memberName;
    selectedClientId = clientObj.memberID;
    self.obj.memberID = clientObj.memberID;
    self.obj.memberNameString = clientObj.memberName;

    [self dismissPopup];
}

- (IBAction)btnCancelDidClicked:(id)sender
{
    [self dismissPopup];

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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
