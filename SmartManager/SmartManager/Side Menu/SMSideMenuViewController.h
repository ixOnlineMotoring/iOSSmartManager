//
//  SMSideMenuViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"


@interface SMSideMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrOfModuleListingData;

}

@property (strong, nonatomic) IBOutlet UITableView *tblViewSideMenu;
@property (strong, nonatomic) IBOutlet UIView *viewHeaderView;

// Bottom Tab bar

@property (strong, nonatomic) JASidePanelController *sidePanelController;

@property (strong, nonatomic) IBOutlet UIView *viewBottomBar;


@property (strong, nonatomic) IBOutlet UIButton *btnHome;

@property (strong, nonatomic) IBOutlet UIButton *btnSynopsis;

@property (strong, nonatomic) IBOutlet UIButton *btnPost;

@property (strong, nonatomic) IBOutlet UIButton *btnDCard;

@property (strong, nonatomic) IBOutlet UIButton *btnContact;

@property (strong, nonatomic) IBOutlet UILabel *lblHome;

@property (strong, nonatomic) IBOutlet UILabel *lblSynopsis;

@property (strong, nonatomic) IBOutlet UILabel *lblPost;

@property (strong, nonatomic) IBOutlet UILabel *lblDCard;

@property (strong, nonatomic) IBOutlet UILabel *lblContact;

@property (strong, nonatomic) IBOutlet UILabel *lblMainMenu;

@property (strong, nonatomic) IBOutlet UILabel *lblModuleTitle;


- (IBAction)btnHomeDidClicked:(id)sender;

- (IBAction)btnSynopsisDidClicked:(id)sender;

- (IBAction)btnPostDidClicked:(id)sender;

- (IBAction)btnDCardDidClicked:(id)sender;

- (IBAction)btnContactDidClicked:(id)sender;

@end
