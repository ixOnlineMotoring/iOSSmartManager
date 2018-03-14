//
//  SMMyBuyersSellersViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 07/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMMyBuyersSellersViewController.h"
#import "SMMyBuyersSellersCell.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"

static int kPageSize=10;

typedef enum : NSUInteger
{
    myBuyersVC = 0,
    mySellersVC,
    
}viewControllerType;



@interface SMMyBuyersSellersViewController ()

@end

@implementation SMMyBuyersSellersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNib];
    [self addingProgressHUD];

    switch (self.viewControllerTradePartnerType)
    {
        case myBuyersVC:
        {
            [self setTheTitleForScreenAs:@"My Buyers"];
            lblHeadingTitle.text = @"The following dealers, groups and OEMs have access to see, buy or bid on my trade vehicles";
            [self webserviceforGettingMyBuyersList];
        }
            break;
        case mySellersVC:
        {
            [self setTheTitleForScreenAs:@"My Sellers"];
            lblHeadingTitle.text = @"The following dealers, groups and OEMs have given me access to see, buy or bid on their trade vehicles";
            [self webserviceforGettingMySellersList];
        }
            break;
       
    }

    arrayOfBuyersSellersList = [[NSMutableArray alloc]init];
    tblViewMyBuyersSellers.tableHeaderView = viewHeader;
    tblViewMyBuyersSellers.tableFooterView = viewFooter;
    //tblViewMyBuyersSellers.tableFooterView = viewFooterEveryone;
}


#pragma mark - UITableViewDataSource

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return arrayOfBuyersSellersList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier= @"SMMyBuyersSellersCell";
    
    
    SMMyBuyersSellersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    
    SMTradeSettingsObject *rowObject = (SMTradeSettingsObject*)[arrayOfBuyersSellersList objectAtIndex:indexPath.row];
    
    
    cell.lblTitle.text = rowObject.tradeClientName;
    cell.lblType.text = rowObject.tradeClientType;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        cell.backgroundColor = [UIColor clearColor];
    }
       
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}

-(void)webserviceforGettingMyBuyersList
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
    NSMutableURLRequest *requestURL = [SMWebServices getTradeMyBuyersWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
    
    
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

-(void)webserviceforGettingMySellersList
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
    NSMutableURLRequest *requestURL = [SMWebServices getMySellersWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue];
    
    
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
    if ([elementName isEqualToString:@"TradePartner"])
    {
        tradeObject  = [[SMTradeSettingsObject alloc] init];
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"SettingID"])
    {
        tradeObject.tradeSettingsID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TraderPeriod"])
    {
        tradeObject.tradePeriod = currentNodeContent;
    }
    if ([elementName isEqualToString:@"AuctionAccess"])
    {
        tradeObject.tradeAuctionAccess = currentNodeContent.boolValue;
    }
    if ([elementName isEqualToString:@"TenderAccess"])
    {
        tradeObject.tradeTenderAccess = currentNodeContent.boolValue;
    }
    if ([elementName isEqualToString:@"ID"])
    {
        tradeObject.tradeClientID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Name"])
    {
        tradeObject.tradeClientName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Type"])
    {
        tradeObject.tradeClientType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TypeID"])
    {
        tradeObject.tradeClientTypeID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"AllowGlobal"])
    {
       isEveryone = currentNodeContent.boolValue;
    }
    if ([elementName isEqualToString:@"TradePartner"])
    {
        [arrayOfBuyersSellersList addObject:tradeObject];
    }
    
    if ([elementName isEqualToString:@"GetTradePartnerSettingsResult"] || [elementName isEqualToString:@"GetTradeSellerSettingsResult"])
    {
        
        switch (self.viewControllerTradePartnerType)
        {
            case myBuyersVC:
            {
                if(isEveryone)
                {
                    tblViewMyBuyersSellers.tableFooterView = viewFooterEveryone;
                }
                else
                {
                    tblViewMyBuyersSellers.dataSource = self;
                    tblViewMyBuyersSellers.delegate = self;
                    tblViewMyBuyersSellers.tableFooterView = viewFooter;
                    if(arrayOfBuyersSellersList.count >0)
                        [tblViewMyBuyersSellers reloadData];
                    else
                    {
                        UIAlertView *alertNoRecords = [[UIAlertView alloc] initWithTitle:@"Smart Manager"message:@"No record(s) found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertNoRecords show];
                    
                    }
                }
                
            }
            break;
            case mySellersVC:
            {
                tblViewMyBuyersSellers.dataSource = self;
                tblViewMyBuyersSellers.delegate = self;
                tblViewMyBuyersSellers.tableFooterView = viewFooter;
                [tblViewMyBuyersSellers reloadData];
            }
            break;
                
        }

       
    }
          
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"reached here...");
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




- (void)registerNib
{
    //if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [tblViewMyBuyersSellers registerNib:[UINib nibWithNibName:@"SMMyBuyersSellersCell" bundle:nil] forCellReuseIdentifier:@"SMMyBuyersSellersCell"];
        
    }
}

- (void)setTheTitleForScreenAs:(NSString*)titleOfScreen
{
    
    listActiveSpecialsNavigTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        listActiveSpecialsNavigTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0f];//SavingsBond
    }
    else
    {
        listActiveSpecialsNavigTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];//SavingsBond
    }
    listActiveSpecialsNavigTitle.backgroundColor = [UIColor clearColor];
    listActiveSpecialsNavigTitle.textColor = [UIColor whiteColor]; // change this color
    listActiveSpecialsNavigTitle.text = titleOfScreen;
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
