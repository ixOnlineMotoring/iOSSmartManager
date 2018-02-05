//
//  SMSettings_MembersViewController.m
//  Smart Manager
//
//  Created by Sandeep on 05/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSettings_MembersViewController.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"

@interface SMSettings_MembersViewController ()

@end

@implementation SMSettings_MembersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        settingsMembersTableView.tableHeaderView = tableHeaderView;
  [settingsMembersTableView registerNib:[UINib nibWithNibName: @"SMSettings_MembersCell" bundle:nil] forCellReuseIdentifier:@"SMSettings_MembersCell"];
    }
    else{
        settingsMembersTableView.tableHeaderView = tableHeaderViewiPad;
        [settingsMembersTableView registerNib:[UINib nibWithNibName: @"SMSettings_MembersCellipad" bundle:nil] forCellReuseIdentifier:@"SMSettings_MembersCell"];

    }
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        settingsMembersTableView.layoutMargins = UIEdgeInsetsZero;
        settingsMembersTableView.preservesSuperviewLayoutMargins = NO;
    }
    settingsMembersTableView.backgroundColor = [UIColor blackColor];
    settingsMembersTableView.dataSource = self;
    settingsMembersTableView.delegate = self;
    addMemberButton.layer.cornerRadius = 4.0;
    addMemberButtoniPad.layer.cornerRadius = 4.0;
    [[SMMemeberUpdateList sharedManager]setMemeberDelegate:self];
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Authorised Members"];

    memebersArray = [[NSMutableArray alloc]init];
    
    [self addingProgressHUD];

    settingsMembersTableView.tableFooterView = [[UIView alloc]init];
    [self webServiceForGetListTradeMembers];
}

-(void)webServiceForGetListTradeMembers{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];


    NSMutableURLRequest *requestURL = [SMWebServices getListTradeMembersWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue];

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
    if ([elementName isEqualToString:@"TradeMembers"])
    {
        tradeMemeberObj=[[SMTradeMembersObject alloc]init];
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
        tradeMemeberObj.ID = [currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"MemberID"])
    {
        tradeMemeberObj.memberID = [currentNodeContent intValue];
    }
    else if ([elementName isEqualToString:@"MemberName"])
    {
        tradeMemeberObj.memberNameString = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"TradeBuy"])
    {
        tradeMemeberObj.tradeBuyBoolValue = [currentNodeContent boolValue];
    }
    else if ([elementName isEqualToString:@"TradeSell"])
    {
        tradeMemeberObj.tradeSellBoolValue = [currentNodeContent boolValue];
    }
    else if ([elementName isEqualToString:@"TenderAccept"])
    {
        tradeMemeberObj.tenderAcceptBoolValue = [currentNodeContent boolValue];
    }
    else if ([elementName isEqualToString:@"TenderDecline"])
    {
        tradeMemeberObj.tenderDeclineBoolValue = [currentNodeContent boolValue];
    }
    else if ([elementName isEqualToString:@"TenderManager"])
    {
       tradeMemeberObj.tenderManagerBoolValue = [currentNodeContent boolValue];
    }
    else if ([elementName isEqualToString:@"TenderAuditor"])
    {
        tradeMemeberObj.tenderAuditorBoolValue = [currentNodeContent boolValue];
    }

    if ([elementName isEqualToString:@"TradeMembers"])
    {
        [memebersArray addObject:tradeMemeberObj];
    }

    if ([elementName isEqualToString:@"TradeMemberArray"]) {
        [settingsMembersTableView reloadData];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"reached here...");
    [self hideProgressHUD];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return memebersArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 SMTradeMembersObject *obj = (SMTradeMembersObject *)[memebersArray objectAtIndex:indexPath.row];
    return ([self heightForText:obj.memberNameString]+10);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellid=@"SMSettings_MembersCell";
    SMSettings_MembersCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];


    if (cell == nil) {
        cell = [[SMSettings_MembersCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    SMTradeMembersObject *obj = (SMTradeMembersObject *)[memebersArray objectAtIndex:indexPath.row];
 NSLog(@"cell.memberNameLabel.frame %@", NSStringFromCGRect(cell.memberNameLabel.frame));
    cell.memberNameLabel.frame = [self heightForLabel:cell.memberNameLabel string:obj.memberNameString];

   
    cell.memberNameLabel.text = obj.memberNameString;
    cell.memberNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.memberNameLabel.numberOfLines = 0;
    cell.memberNameLabel.textColor = [UIColor whiteColor];
    [cell.memberNameLabel sizeToFit];
    cell.backgroundColor = [UIColor blackColor];

    cell.tradeBuyLabel.text = obj.tradeBuyBoolValue == YES?@"\u2713":@"\u2718";
    cell.tradeSellLabel.text = obj.tradeSellBoolValue == YES?@"\u2713":@"\u2718";
    cell.tradeAcceptLabel.text = obj.tenderAcceptBoolValue == YES?@"\u2713":@"\u2718";
    cell.tradeDeclineLabel.text = obj.tenderDeclineBoolValue == YES?@"\u2713":@"\u2718";
    cell.tradeMgrLabel.text = obj.tenderManagerBoolValue == YES?@"\u2713":@"\u2718";
    cell.tradeAuditorLabel.text = obj.tenderAuditorBoolValue == YES?@"\u2713":@"\u2718";

    cell.tradeBuyLabel.textColor = obj.tradeBuyBoolValue == YES?[UIColor greenColor]:[UIColor redColor];
    cell.tradeSellLabel.textColor = obj.tradeSellBoolValue == YES?[UIColor greenColor]:[UIColor redColor];
    cell.tradeAcceptLabel.textColor = obj.tenderAcceptBoolValue == YES?[UIColor greenColor]:[UIColor redColor];
    cell.tradeDeclineLabel.textColor = obj.tenderDeclineBoolValue == YES?[UIColor greenColor]:[UIColor redColor];
    cell.tradeMgrLabel.textColor = obj.tenderManagerBoolValue == YES?[UIColor greenColor]:[UIColor redColor];
    cell.tradeAuditorLabel.textColor = obj.tenderAuditorBoolValue == YES?[UIColor greenColor]:[UIColor redColor];

    cell.editButton.tag = indexPath.row;
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    [cell.editButton addTarget:self action:@selector(editButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell layoutIfNeeded];
    return cell;
}

-(IBAction)editButtonDidClicked:(id)sender{
    UIButton *button = (UIButton *)sender;

    NSLog(@"%ld",(long)button.tag);
    SMTradeMembersObject *obj = (SMTradeMembersObject *)[memebersArray objectAtIndex:button.tag];
    SMAddEditTradeMemeberViewController *addMemeberbj = [[SMAddEditTradeMemeberViewController alloc]initWithNibName:@"SMAddEditTradeMemeberViewController" bundle:nil];
    addMemeberbj.isAddMember = NO;
    addMemeberbj.obj = obj;

    selectedUpdateIndex = button.tag;
    [self.navigationController pushViewController:addMemeberbj animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
-(CGRect)heightForLabel:(UILabel *)label string:(NSString* )string
{
    CGRect currentFrame = label.frame;
    UIFont *cellFont;
    CGSize constraintSize;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:8];
        constraintSize = CGSizeMake(57, MAXFLOAT);
        currentFrame.size.width = 57;
    }
    else{
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:16];
        constraintSize = CGSizeMake(146, MAXFLOAT);
        currentFrame.size.width = 146;
    }
    
    
    // CGSize expected = [string sizeWithFont:label.font constrainedToSize:max lineBreakMode:label.lineBreakMode];
    CGRect labelRect = [string
                        boundingRectWithSize:constraintSize
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName:cellFont}
                        context:nil];
    
    
    currentFrame.size.height = ceil(labelRect.size.height);
    return currentFrame;
}

- (CGFloat)heightForText:(NSString *)bodyText
{
    UIFont *cellFont;
    CGSize constraintSize;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:9];
        constraintSize = CGSizeMake(57, MAXFLOAT);

    }
    else{
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:16];
        constraintSize = CGSizeMake(146, MAXFLOAT);
    }

    CGRect labelRect = [bodyText
                        boundingRectWithSize:constraintSize
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName:cellFont}
                        context:nil];
    
    CGFloat height = ceil(labelRect.size.height + 10);

    return height;
}

-(IBAction)addMemberDidClicked:(id)sender{

    SMAddEditTradeMemeberViewController *addMemeberbj = [[SMAddEditTradeMemeberViewController alloc]initWithNibName:@"SMAddEditTradeMemeberViewController" bundle:nil];
    addMemeberbj.isAddMember = YES;

    SMTradeMembersObject *tradeMemebObj=[[SMTradeMembersObject alloc]init];

    tradeMemebObj.tradeBuyBoolValue = NO;
    tradeMemebObj.tradeSellBoolValue = NO;
    tradeMemebObj.tenderAcceptBoolValue = NO;
    tradeMemebObj.tenderDeclineBoolValue = NO;
    tradeMemebObj.tenderManagerBoolValue = NO;
    tradeMemebObj.tenderAuditorBoolValue = NO;
    tradeMemebObj.memberNameString = @"";
    tradeMemebObj.ID = 0;

    addMemeberbj.obj = tradeMemebObj;
    [self.navigationController pushViewController:addMemeberbj animated:YES];
}

- (void)updateMemeberListObj:(SMTradeMembersObject *)memeberObj andIsUpdate:(BOOL )isUpdate{

//    if (isUpdate) {
//        SMTradeMembersObject *obj = (SMTradeMembersObject *)[memebersArray objectAtIndex:selectedUpdateIndex];
//        obj.tradeBuyBoolValue =memeberObj.tradeBuyBoolValue;
//        obj.tradeSellBoolValue =memeberObj.tradeSellBoolValue;
//        obj.tenderAcceptBoolValue =memeberObj.tenderAcceptBoolValue;
//        obj.tenderDeclineBoolValue =memeberObj.tenderDeclineBoolValue;
//        obj.tenderManagerBoolValue =memeberObj.tenderManagerBoolValue;
//        obj.tenderAuditorBoolValue =memeberObj.tenderAuditorBoolValue;
//        [settingsMembersTableView reloadData];
//    }
//    else{

        [memebersArray removeAllObjects];
        [settingsMembersTableView reloadData];
        [self performSelector:@selector(webServiceForGetListTradeMembers) withObject:nil afterDelay:0.2];
//    }

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
