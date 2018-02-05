//
//  SMAddEditTradePartnersViewController.m
//  Smart Manager
//
//  Created by Sandeep on 06/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMTradePartnersViewController.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"
@interface SMTradePartnersViewController ()

@end

@implementation SMTradePartnersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addingProgressHUD];

    tradePartnersTableView.tableHeaderView = tableHeaderView;
    tradePartnersTableView.backgroundColor = [UIColor blackColor];
    tradePartnersTableView.dataSource = self;
    tradePartnersTableView.delegate = self;
    addPartnersButton.layer.cornerRadius = 4.0;

    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        tradePartnersTableView.layoutMargins = UIEdgeInsetsZero;
        tradePartnersTableView.preservesSuperviewLayoutMargins = NO;
    }
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Trade Partners"];

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        [tradePartnersTableView registerNib:[UINib nibWithNibName: @"SMTradePartnersCell" bundle:nil] forCellReuseIdentifier:@"SMTradePartnersCell"];
    }
    else{
        [tradePartnersTableView registerNib:[UINib nibWithNibName: @"SMTradePartnersCellipad" bundle:nil] forCellReuseIdentifier:@"SMTradePartnersCell"];
    }
    memebersArray = [[NSMutableArray alloc]init];
    
    tradePartnersTableView.tableFooterView = [[UIView alloc]init];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self wbServiceForGetListTradePartners];
}
-(void)wbServiceForGetListTradePartners
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    [memebersArray removeAllObjects];
    NSMutableURLRequest *requestURL=[SMWebServices getListTradePartnersWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue]];

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

-(IBAction)radioButtonDidClicked:(id)sender{

    UIButton *button = (UIButton *)sender;

    switch (button.tag) {
        case 0:
        {
            isEveryOne = YES;
            [radioButton setSelected:YES];
            [radioButton1 setSelected:NO];
        }
            break;
        case 1:
        {
            isEveryOne = NO;
            [radioButton setSelected:NO];
            [radioButton1 setSelected:YES];
        }
            break;
        default:
            break;
    }
    [self performSelector:@selector(wbServiceForSaveTradePartnerSetting) withObject:nil afterDelay:0.3];
}

-(void)wbServiceForSaveTradePartnerSetting
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    NSMutableURLRequest *requestURL=[SMWebServices SaveTradePartnerSettingWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andEveryone:(int)isEveryOne];

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
    if ([elementName isEqualToString:@"TradePartner"]) {
        tradePartnersObj = [[SMListTradePartnersObject alloc]init];
    }

    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"SettingID"]) {
        tradePartnersObj.settingID = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"TraderPeriod"]) {
        tradePartnersObj.traderPeriod = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"AuctionAccess"]) {
        tradePartnersObj.auctionAccess = [currentNodeContent boolValue];
    }
    if ([elementName isEqualToString:@"TenderAccess"]) {
        tradePartnersObj.tenderAccess = [currentNodeContent boolValue];
    }
    if ([elementName isEqualToString:@"ID"]) {
        tradePartnersObj.ID = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"Name"]) {
        tradePartnersObj.nameString = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Type"]) {
        tradePartnersObj.typeString = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TypeID"]) {
        tradePartnersObj.typeID = [currentNodeContent boolValue];
    }


    if ([elementName isEqualToString:@"AllowGlobal"]) {
        AllowGlobalBoolValue = [currentNodeContent boolValue];

        if (AllowGlobalBoolValue) {

            [radioButton setSelected:YES];
            [radioButton1 setSelected:NO];
        }
        else{
            [radioButton setSelected:NO];
            [radioButton1 setSelected:YES];
        }
    }
    if ([elementName isEqualToString:@"SaveTradePartnerSettingResponse"])
    {
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel)
            {
                
                return;
                
            }
            
        }];

    }
    if ([elementName isEqualToString:@"TradePartner"]) {
        [memebersArray addObject:tradePartnersObj];
    }

}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"reached here...");
    [tradePartnersTableView reloadData];
    [self hideProgressHUD];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return memebersArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    SMListTradePartnersObject *obj = (SMListTradePartnersObject *)[memebersArray objectAtIndex:indexPath.row];
    return ([self heightForText:obj.nameString]+19);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellid=@"SMTradePartnersCell";
    SMTradePartnersCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SMListTradePartnersObject *obj = (SMListTradePartnersObject *)[memebersArray objectAtIndex:indexPath.row];

    cell.partnerNameLabel.frame = [self heightForLabel:cell.partnerNameLabel string:obj.nameString];

    cell.partnerNameLabel.text = obj.nameString;
    cell.partnerNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.partnerNameLabel.numberOfLines = 0;
    cell.partnerNameLabel.textColor = [UIColor whiteColor];
    //  [cell.partnerNameLabel sizeToFit];

    

    cell.tradeAccessLabel.text =obj.auctionAccess== YES? @"Yes":@"No";
    cell.tenderAccessLabel.text = obj.tenderAccess== YES? @"Yes":@"No";;

    cell.editButton.tag = indexPath.row;
    [cell.editButton addTarget:self action:@selector(edidButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    cell.backgroundColor = [UIColor blackColor];

    return cell;
}
-(IBAction)edidButtonDidClicked:(id)sender{

    UIButton *button = (UIButton *)sender;

    SMListTradePartnersObject *obj = (SMListTradePartnersObject *)[memebersArray objectAtIndex:button.tag];
    
    SMAddEditTradePartnersViewController *addPartneersOb = [[SMAddEditTradePartnersViewController alloc]initWithNibName:@"SMAddEditTradePartnersViewController" bundle:nil];
    addPartneersOb.isAddPartners = NO;
    addPartneersOb.obj = obj;
    [self.navigationController pushViewController:addPartneersOb animated:YES];
}

-(CGRect)heightForLabel:(UILabel *)label string:(NSString *)string{
    CGRect currentFrame = label.frame;
    CGSize max = CGSizeMake(label.frame.size.width, MAXFLOAT);
    CGSize expected = [string sizeWithFont:label.font constrainedToSize:max lineBreakMode:label.lineBreakMode];
    currentFrame.size.height = expected.height;
    return currentFrame;
}

- (CGFloat)heightForText:(NSString *)bodyText
{
    UIFont *cellFont;
    CGSize constraintSize;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:10];
        constraintSize = CGSizeMake(91, MAXFLOAT);

    }
    else{
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:15];
        constraintSize = CGSizeMake(204, MAXFLOAT);
    }
  
    //   CGSize labelSize = [bodyText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect textRect = [bodyText boundingRectWithSize:constraintSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:cellFont}
                                             context:nil];
    
    CGSize labelSize = textRect.size;
    CGFloat height = labelSize.height;
    
    return height;}
-(IBAction)addPartnersButtonDidClicked:(id)sender{
    SMAddEditTradePartnersViewController *addPartneersOb = [[SMAddEditTradePartnersViewController alloc]initWithNibName:@"SMAddEditTradePartnersViewController" bundle:nil];
    addPartneersOb.isAddPartners = YES;
    [self.navigationController pushViewController:addPartneersOb animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
