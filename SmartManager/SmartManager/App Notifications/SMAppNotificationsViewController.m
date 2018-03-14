//
//  SMAppNotificationsViewController.m
//  Smart Manager
//
//  Created by Ketan Nandha on 02/02/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import "SMAppNotificationsViewController.h"
#import "SMAppNotificationCell.h"
#import "SMAppNotificationObject.h"
#import "SMCommonClassMethods.h"
#import "SMAttributeStringFormatObject.h"
#import "SMCustomColor.h"
#import "SMMyLeadsDetailViewController.h"

@interface SMAppNotificationsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblViewAppNotifications;
    NSMutableArray *arrmAppNotificationList;
    SMAppNotificationObject *notificationObj;
    int totalCount;
    int pageIncrementCount;

}

@end

@implementation SMAppNotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNibForTableView];
    [self addingProgressHUD];
    pageIncrementCount = 0;
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Notifications"];
    tblViewAppNotifications.estimatedRowHeight = 64.0;
    tblViewAppNotifications.rowHeight = UITableViewAutomaticDimension;
    tblViewAppNotifications.tableFooterView = [[UIView alloc] init];
    [self webserviceGetAllAppNotifications];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - tableView delegate methods


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrmAppNotificationList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier= @"SMAppNotificationCell";
    SMAppNotificationCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    SMAppNotificationObject *individualObj = (SMAppNotificationObject*)[arrmAppNotificationList objectAtIndex:indexPath.row];
    dynamicCell.txtViewDescription.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    dynamicCell.lblTitle.text = [NSString stringWithFormat:@"%@ %@",individualObj.strSource,individualObj.strIdentity];
    dynamicCell.txtViewDescription.text = individualObj.strMessage;
    if(![individualObj.strIsRead boolValue])
    {
        dynamicCell.viewTransparentBackground.hidden = NO;
         [SMAttributeStringFormatObject setAttributedTextLeadDetailRedColourWithFirstText:@"New" andWithSecondText:individualObj.strSentDate withSize:11.0 forLabel:dynamicCell.lblDate];
    }
    else
    {
        dynamicCell.viewTransparentBackground.hidden = YES;
        [SMAttributeStringFormatObject setAttributedTextLeadDetailRedColourWithFirstText:@"" andWithSecondText:individualObj.strSentDate withSize:11.0 forLabel:dynamicCell.lblDate];
    }
   dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
        if (arrmAppNotificationList.count-1 == indexPath.row)
        {
            if (arrmAppNotificationList.count != totalCount)
            {
                pageIncrementCount++;
                [self webserviceGetAllAppNotifications];
            }
        }
    
    
    return dynamicCell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMAppNotificationObject *individualObj = (SMAppNotificationObject*)[arrmAppNotificationList objectAtIndex:indexPath.row];
    
    [self webserviceForMarkingNotificationAsReadWithNotificationID:individualObj.strMessageID.intValue];
    
    SMMyLeadsDetailViewController *leadDetailVC = [[SMMyLeadsDetailViewController alloc] initWithNibName:@"SMMyLeadsDetailViewController" bundle:nil];
    
    leadDetailVC.leadID =2728751;
    //leadDetailVC.listRefreshDelegate = self;
    [self.navigationController pushViewController:leadDetailVC animated:YES];
}

#pragma mark - TextFieldNotifications

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self webserviceForSearchingAppNotificationsWithSearchKey:textField.text];
    return YES;
}

#pragma mark - Webservice Integration

-(void)webserviceGetAllAppNotifications
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices getAllAppNotifications:[SMGlobalClass sharedInstance].hashValue andPageSize:10 andPageNum:pageIncrementCount];
    
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
             arrmAppNotificationList = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
         }
     }];
}

-(void)webserviceForSearchingAppNotificationsWithSearchKey:(NSString*) searchKey
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    //NSMutableURLRequest *requestURL = [SMWebServices getAllAppNotifications:[SMGlobalClass sharedInstance].hashValue andPageSize:10 andPageNum:pageIncrementCount];
    
    NSMutableURLRequest *requestURL = [SMWebServices searchAppNotifications:[SMGlobalClass sharedInstance].hashValue andSearchKey:searchKey andPageSize:10 andPageNum:0];
    
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
             [arrmAppNotificationList removeAllObjects];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
         }
     }];
}


-(void)webserviceForMarkingNotificationAsReadWithNotificationID:(int) notificationID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices markNotificationAsRead:[SMGlobalClass sharedInstance].hashValue andNotificationID:notificationID];
    
   
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
    if ([elementName isEqualToString:@"notification"])
    {
        notificationObj  = [[SMAppNotificationObject alloc] init];
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"MessageLogID"])
    {
        notificationObj.strMessageID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"message"])
    {
        notificationObj.strMessage = currentNodeContent;
    }
    if ([elementName isEqualToString:@"heading"])
    {
        notificationObj.strHeading = currentNodeContent;
    }
    if ([elementName isEqualToString:@"sent"])
    {
        notificationObj.strSentDate = [[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:currentNodeContent withFormat:6];
    }
    if ([elementName isEqualToString:@"source"])
    {
        notificationObj.strSource = currentNodeContent;
    }
    if ([elementName isEqualToString:@"identity"])
    {
        notificationObj.strIdentity = currentNodeContent;
    }
    if ([elementName isEqualToString:@"isRead"])
    {
        notificationObj.strIsRead = currentNodeContent;
    }
    if ([elementName isEqualToString:@"totalMessages"])
    {
        totalCount = currentNodeContent.intValue;
    }
    if ([elementName isEqualToString:@"notification"])
    {
        [arrmAppNotificationList addObject:notificationObj];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [tblViewAppNotifications reloadData];
    [self hideProgressHUD];
}

#pragma mark - User Define Functions
-(void) registerNibForTableView
{
    [tblViewAppNotifications registerNib:[UINib nibWithNibName:@"SMAppNotificationCell" bundle:nil] forCellReuseIdentifier:@"SMAppNotificationCell"];
    
    tblViewAppNotifications.tableHeaderView = _viewTableFooter;
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

@end
