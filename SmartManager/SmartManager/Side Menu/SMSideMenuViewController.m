//
//  SMSideMenuViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMSideMenuViewController.h"
#import "SMGridModuleData.h"
#import "SMListingModuleCell.h"
#import "SMGlobalClass.h"
#import "SMCellForCustomHomeOption.h"
#import "NSString+FontAwesome.h"
#import "Fontclass.h"

@interface SMSideMenuViewController ()

@end

@implementation SMSideMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNib];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblMainMenu.font = [UIFont fontWithName:FONT_NAME_BOLD size:18.0];
        self.lblContact.font = [UIFont fontWithName:FONT_NAME size:10.0];
        self.lblDCard.font = [UIFont fontWithName:FONT_NAME size:10.0];
        self.lblHome.font = [UIFont fontWithName:FONT_NAME size:10.0];
        self.lblPost.font = [UIFont fontWithName:FONT_NAME size:10.0];
        self.lblSynopsis.font = [UIFont fontWithName:FONT_NAME size:10.0];
        
        self.lblModuleTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
    }
    else
    {
        self.lblMainMenu.font = [UIFont fontWithName:FONT_NAME_BOLD size:22.0];
        self.lblContact.font = [UIFont fontWithName:FONT_NAME size:16.0];
        self.lblDCard.font = [UIFont fontWithName:FONT_NAME size:16.0];
        self.lblHome.font = [UIFont fontWithName:FONT_NAME size:16.0];
        self.lblPost.font = [UIFont fontWithName:FONT_NAME size:16.0];
        self.lblSynopsis.font = [UIFont fontWithName:FONT_NAME size:16.0];
        
        self.lblModuleTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:18.0];
    }
        
    // This is to remove extra lines in the tableview.
    self.tblViewSideMenu.tableFooterView = [[UIView alloc]init];
    self.tblViewSideMenu.tableHeaderView = self.viewHeaderView;
    self.viewBottomBar.hidden = YES;
    
   // Array allocations
    
    arrOfModuleListingData = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheSlideMenuData:) name:@"RefreshTheSlideMenu" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"RefreshTable" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTheSlideMenuData:) name:@"InitialRefreshForSideMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMainMenuName:) name:@"InitialRefreshMainMenuName" object:nil];
}

- (void)registerNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tblViewSideMenu registerNib:[UINib nibWithNibName:@"SMListingModuleCell" bundle:nil] forCellReuseIdentifier:@"SMListingModuleCell"];
        
        [self.tblViewSideMenu registerNib:[UINib nibWithNibName:@"SMCellForCustomHomeOption" bundle:nil] forCellReuseIdentifier:@"SMCellForCustomHomeOptionIdentifier"];
    }
    else
    {
        [self.tblViewSideMenu registerNib:[UINib nibWithNibName:@"SMListingModuleCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMListingModuleCell"];
        
        [self.tblViewSideMenu registerNib:[UINib nibWithNibName:@"SMCellForCustomHomeOption_iPad" bundle:nil] forCellReuseIdentifier:@"SMCellForCustomHomeOptionIdentifier"];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self.tblViewSideMenu reloadData];
}

#pragma  mark - TableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     //return [[SMGlobalClass sharedInstance].arrayOfModules count];
   return [arrOfModuleListingData count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        return 40.0f;
    }
    else
    {
        return 60.0f;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMGridModuleData *gridModuleObj = (SMGridModuleData*)[arrOfModuleListingData objectAtIndex:indexPath.row];
    
    if([gridModuleObj.moduleName isEqualToString:@"Home"])
    {        
        SMCellForCustomHomeOption *cell = [tableView dequeueReusableCellWithIdentifier:@"SMCellForCustomHomeOptionIdentifier"];
        
        [cell setBackgroundColor:[UIColor colorWithRed:32.0/255.0 green:36.0/255.0 blue:39.0/255.0 alpha:1.0]];

        [Fontclass AttributeStringMethodwithFontWithButton:cell.btnBackArrow iconID:24];
        cell.lblHome.text = @"Back";

        UIView *backgroundView = [[UIView alloc]init];
        [backgroundView setBackgroundColor:[UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0]];
        [cell setSelectedBackgroundView:backgroundView];
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier= @"SMListingModuleCell";
        
        SMListingModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.backgroundColor = [UIColor colorWithRed:38.0/255 green:41.0/255 blue:48.0/255 alpha:1.0];
       
        cell.lblModuleName.text = gridModuleObj.moduleName;
        
        UIView *backgroundView = [[UIView alloc]init];
        [backgroundView setBackgroundColor:[UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0]];
        [cell setSelectedBackgroundView:backgroundView];

        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SMGridModuleData *gridModuleObj = (SMGridModuleData*)[arrOfModuleListingData objectAtIndex:indexPath.row];
    
    if([gridModuleObj.moduleName isEqualToString:@"Social"] || [gridModuleObj.moduleName isEqualToString:@"Planner"] || [gridModuleObj.moduleName isEqualToString:@"Vehicles"] || [gridModuleObj.moduleName isEqualToString:@"Trader"])
    {
        self.lblMainMenu.text = gridModuleObj.moduleName;
    }
    
    else if ([gridModuleObj.moduleName isEqualToString:@"Home"])
    {
        self.lblMainMenu.text = @"Main Menu";
    }
    [self.sidePanelController showCenterPanelAnimated:YES];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadTheQuickLinkData" object:[arrOfModuleListingData objectAtIndex:indexPath.row]];
}


#pragma mark - impelementation of custom methods

-(void)refreshTheSlideMenuData:(NSNotification *) notification
{
    arrOfModuleListingData = [notification object];
    
    [self.tblViewSideMenu reloadData];
}

-(void)refreshTableView
{
    [self.tblViewSideMenu reloadData];
}

- (void)refreshMainMenuName:(NSNotification *) notification
{
    self.lblMainMenu.text = [notification object];
}
- (IBAction)btnHomeDidClicked:(id)sender{
}
- (IBAction)btnSynopsisDidClicked:(id)sender{
}
- (IBAction)btnPostDidClicked:(id)sender{
}
- (IBAction)btnDCardDidClicked:(id)sender{
}
- (IBAction)btnContactDidClicked:(id)sender{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
