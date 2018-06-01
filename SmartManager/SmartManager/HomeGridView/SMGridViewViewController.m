//
//  SMGridViewViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.

// Modification Done By Jignesh K As Follows  :

 // 1. On impersonation listing for loading client added autolayout for multiple lines clent listing

//  Copyright (c) 2014 SmartManager. All rights reserved.


#import "SMGridViewViewController.h"
#import "SMModuleGridViewCell.h"
#import "SMGridModuleData.h"
#import "SMGlobalClass.h"
#import "SMLoginViewController.h"
#import "SMLoginViewController.h"
#import "SMImpersonateObject.h"
#import "SMClassForRefreshingData.h"
#import "SMCreateBlogViewController.h"
#import "SMSearchBlogViewController.h"
#import "SMCreateBlogViewController.h"
#import "SMPlannerLogActivityViewController.h"
#import "SMLoadVehiclesViewController.h"
#import "SMPlannerNewTaskViewController.h"
#import "SMPlannerToDoViewController.h"
#import "SMPlannerTasksByMeViewController.h"
#import "SMWantedViewController.h"
#import "SMCustomerScanViewController.h"
#import "SMLeadsListViewController.h"
#import "SMNotificationViewController.h"
#import "SMVehicleAuditedTodayViewController.h"
#import "SMVehicle_StillToAudit_ViewController.h"
#import "SMVehicleAuditHistoryViewController.h"
#import "SMVehicleStockAuditList.h"
// Trader
#import "SMTraderViewController.h"
#import "SMSellsViewController.h"
#import "SMMyBidsViewController.h"
#import "SMTrader_WinningBidsViewController.h"
#import "SMTraderPrivateOffersViewController.h"

#import "NSString+FontAwesome.h"
#import "Fontclass.h"

#import "SMImpersonateObject.h"
#import "SMStockListViewController.h"
#import "SMCustomerScanDetailViewController.h"
#import "SMVehicleAlertsViewController.h"
#import "SMSettings_ReadinessViewController.h"
#import "SMSettings_AuctionViewController.h"
#import "SMSettings_DisplayViewController.h"
#import "SMSettings_TradePriceViewController.h"
#import "SMSettings_CustomMsgsViewController.h"
#import "SMActiveTradesViewController.h"
#import "SMBiddingEndedViewController.h"

#import "SMBiddingReceivedViewController.h"
#import "SMSalesViewController.h"
#import "SMMyBuyersSellersViewController.h"
#import "SMSettings_MembersViewController.h"
#import "SMTradePartnersViewController.h"
#import "SMTradeVehicleListingViewController.h"

#import "SMReusableHeaderViewController.h"

#import "SMSynopsisVINScanViewController.h"
#import "SMSynopsisVehicleLookUpViewController.h"
#import "SMSynopsisVehicleCodeViewController.h"
#import "SMSynopsisVehicleInStockViewController.h"
#import "SMSaveAppraisalsViewController.h"
#import "SMCarTouchRecognitionViewController.h"
#import "SMVehicleStockListViewController.h"

#import "SMAppNotificationsViewController.h"
#import "SMVehicleNewBrochureViewController.h"
#import "SMStockSummaryTableVC.h"
#import "SMAppDelegate.h"
#import "SDImageCache.h"
////////Monami//////
/////Support Request ///////
#import "SMSupportRequestViewController.h"
enum gridData
{
    home = 0,
    blogPost = 1,
    others=99
    
}gg;

@interface SMGridViewViewController ()<NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    SMAppDelegate *appDeleage;
}

@end

@implementation SMGridViewViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        arrGridModileObjects = [[NSMutableArray alloc]init];
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumInteritemSpacing = 1;
        flow.minimumLineSpacing = 1;
        
        self.refreshData = [[SMClassForRefreshingData alloc]init];
        self.refreshData.authenticateDelegate = self;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    
    ///////////////////////Monami/////////////////
    /// Add parameter to save the image locally in imageview which has been uploaded to the server
    strForProfileImage = @"";
    
    ///////////////////  END       //////////////////////////
    
    ////////////// Monami remove extra row from dropdown ////////
    self.tblViewDropDown.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //////////////////// End///////////////////////////
    
    
    // fontAwesome ID for Home Image is 289
    
   // [Fontclass AttributeStringMethodwithFontWithButton:self.btnHome iconID:289];
    subModuleNumber = -1;
    isBackToHome = NO;
    arrayOfImages = [[NSMutableArray alloc]init];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblHome.font = [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
        self.lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblSearchImpersonate.font = [UIFont fontWithName:FONT_NAME size:15.0];
        self.lblNoRecords.font = [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
        self.lblContact.font = [UIFont fontWithName:FONT_NAME_BOLD size:10.0];
        self.lblDCard.font = [UIFont fontWithName:FONT_NAME_BOLD size:10.0];
        self.lblPost.font = [UIFont fontWithName:FONT_NAME_BOLD size:10.0];
        self.lblSynopsis.font = [UIFont fontWithName:FONT_NAME_BOLD size:10.0];
        
        [self.collectionViewModuleList registerNib:[UINib nibWithNibName:@"SMModuleGridViewCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMModuleGridViewCell"];
        
        [self.tblSearchClients registerNib:[UINib nibWithNibName:@"SMImpersonationClientListing" bundle:nil] forCellReuseIdentifier:@"SMImpersonationClientListing"];
    }
    else
    {
        self.lblHome.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:25.0];
        self.lblSearchImpersonate.font = [UIFont fontWithName:FONT_NAME size:20.0];
        self.lblNoRecords.font = [UIFont fontWithName:FONT_NAME_BOLD size:18.0];
        self.lblContact.font = [UIFont fontWithName:FONT_NAME_BOLD size:18.0];
        self.lblDCard.font = [UIFont fontWithName:FONT_NAME_BOLD size:18.0];
        self.lblPost.font = [UIFont fontWithName:FONT_NAME_BOLD size:18.0];
        self.lblSynopsis.font = [UIFont fontWithName:FONT_NAME_BOLD size:18.0];
        
        [self.collectionViewModuleList registerNib:[UINib nibWithNibName:@"SMModuleGridViewCell_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMModuleGridViewCell"];
        [self.tblSearchClients registerNib:[UINib nibWithNibName:@"SMImpersonationClientListing_iPad" bundle:nil] forCellReuseIdentifier:@"SMImpersonationClientListing"];
        
    }
    
    
    arrayDropDown = [[NSMutableArray alloc]init];
    
    [arrayDropDown addObject:@"Impersonate"];
    [arrayDropDown addObject:@"Change Profile Photo"];// Change Required
    [arrayDropDown addObject:@"Logout"];
    
    [self createTableView];
    
    [self setTheLabelCountText:55];
    self.tblViewDropDown.separatorColor = [UIColor colorWithRed:60.0/255 green:62.0/255 blue:62.0/255 alpha:1.0];
    self.tblSearchClients.separatorColor = [UIColor colorWithRed:60.0/255 green:62.0/255 blue:62.0/255 alpha:1.0];
   // self.tblViewDropDown.layer.borderColor = [UIColor colorWithRed:33.0/255 green:34.0/255 blue:36.0/255 alpha:1.0].CGColor;
    
    self.txtFieldSearch.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtFieldSearch.layer.borderWidth= 0.8f;
    
    // This is to give padding to the text field text
    
    UIView *viewForPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 7, 30)];
    self.txtFieldSearch.leftView = viewForPadding;
    
    
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setTheTopHeaderData" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissTheSubViews) name:@"DismissTheSubViewsOfHomeScreen" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTheQuickLinkData:) name:@"ReloadTheQuickLinkData" object:nil];
    
    arrayOfBlog = [[NSMutableArray alloc]initWithObjects:@"Blog Post",@"Home", nil];
    arrayOfModules = [[NSMutableArray alloc]initWithObjects:@"Post", nil];
    
    //dashBoardArray = [[NSMutableArray alloc]init];
    //bottomBarArray = [[NSMutableArray alloc]init];
    
    moduleClicked = -1;
    selectedModule = home;
    self.btnHome.selected = YES;

    filteredArray = [SMGlobalClass sharedInstance].arrayOfImpersonateClients;
    
    moduleObjFromSlideMenu = [[SMGridModuleData alloc]init];
    
    [self.collectionViewModuleList reloadData];
    
    [self addingProgressHUD];
    
    self.multipleImagePicker = [[RPMultipleImagePickerViewController alloc] init];
    self.multipleImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.multipleImagePicker.photoSelectionDelegate = self;
    
    [SMGlobalClass sharedInstance].totalImageSelected  = 0;
    [SMGlobalClass sharedInstance].isFromCamera = NO;

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:NO];
    
    NSLog(@"%d",[[NSUserDefaults standardUserDefaults] boolForKey:@"SubcriptionTrue"]);
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"SubcriptionDone"] == 0 ){
        
        [self subcriptionAlertShow];
    }

     appDeleage =(SMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
     appDeleage.refrshObj.refeshDelegate = nil;
    
    if(![SMGlobalClass sharedInstance].isFromEbrochure){
    [self authenticationSucceeded];
    
   }else{
       [self GetProfileImage];
    }
    
    self.viewBottomBar.hidden = NO;
    [self.tblViewDropDown removeFromSuperview];
    [self.confirmationView removeFromSuperview];
    
    [self.collectionViewModuleList reloadData];
    
    [self.view endEditing:YES];
    
}
///////////////////////// Monami //////////////////////////////////////

//////////////// Add a alert for subcription after login when app launch first time
-(void)subcriptionAlertShow{
    
    appDeleage = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Smart Manager"
                                 message:@"Do you want to subscribe to notification services?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    [appDeleage.oneSignal setSubscription:true];
                                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"SubcriptionTrue"];
                                    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SubcriptionDone"];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   
                                   [appDeleage.oneSignal setSubscription:false];
                                   [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"SubcriptionTrue"];
                                   [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SubcriptionDone"];
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
///////////////////////////////////////// END//////////////////////////////////


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    self.viewBottomBar.hidden = YES;
}

#pragma mark - NSNotification Center Reload Data

-(void)reloadData
{
    
    int totalQuickLinkCount = [[SMGlobalClass sharedInstance].filteredArrayForBottomBar count ] + 1;
    int initialValue = self.view.bounds.size.width/totalQuickLinkCount;
    float xPosition = initialValue;
    self.btnHome.frame = CGRectMake((initialValue/2)-(self.btnHome.frame.size.width/2), self.btnHome.frame.origin.y, self.btnHome.frame.size.width, self.btnHome.frame.size.height);
    
    for(int i=0;i<[[SMGlobalClass sharedInstance].filteredArrayForBottomBar count ];i++)
    {
        self.btnPost.frame = CGRectMake(xPosition+(initialValue/2)-(self.btnPost.frame.size.width/2), self.btnPost.frame.origin.y, self.btnPost.frame.size.width, self.btnPost.frame.size.height);
        xPosition = xPosition*2;
        
        
    }
    
    
    
    
    [self.collectionViewModuleList reloadData];
    
}

-(void)dismissTheSubViews
{
    [self.tblViewDropDown removeFromSuperview];
    [self.confirmationView removeFromSuperview];
    
}


#pragma mark - textField delegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    [downloadingQueue cancelAllOperations];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"impersonateClientName BEGINSWITH[cd] %@",resultString];
    
    filteredArray = [[SMGlobalClass sharedInstance].arrayOfImpersonateClients filteredArrayUsingPredicate:predicate];
    
    
    if([filteredArray count]>2)
    {
        heightForTheDropDown = 40*2;
        self.tblSearchClients.scrollEnabled = YES;
        
    }
    else
    {
        self.tblSearchClients.scrollEnabled = YES;
        heightForTheDropDown = 40*[filteredArray count];
        
    }
    
    if([filteredArray count]==0)
    {
        self.tblSearchClients.tableFooterView = self.lblNoRecords;
        

    }
    else
    {
        self.tblSearchClients.tableFooterView = nil;
        

    }
    
    [self.tblSearchClients reloadData];
    
    if([resultString length]==0)
    {
        self.tblSearchClients.tableFooterView = nil;
        filteredArray = [SMGlobalClass sharedInstance].arrayOfImpersonateClients;
        self.tblSearchClients.scrollEnabled = YES;
        
        
        [self.tblSearchClients reloadData];
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtFieldSearch) {
        [textField resignFirstResponder];
        
    }
    return YES;
}


#pragma mark - scrollView delegate method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[self.txtFieldSearch resignFirstResponder];
    
}

#pragma  mark - TableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tblSearchClients)
        return [filteredArray count];
    else
        return [arrayDropDown count];
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblViewDropDown)
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            return 40.0;
        }
        else
        {
            return 60.0;
        }
    }
    else
    {
//        ************************
        // This Part has done by Jignesh K
        // (6)
        if (IS_IOS8_OR_ABOVE) {
            return UITableViewAutomaticDimension;
        }
        
        [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
        
        // (8)
        [self.prototypeCell updateConstraintsIfNeeded];
        [self.prototypeCell layoutIfNeeded];
        
        // (9)
        return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        // End For  - This Part has done by Jignesh K
        //        ************************

        
        
    }
    
}

- (SMImpersonationClientListing *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.tblSearchClients dequeueReusableCellWithIdentifier:NSStringFromClass([SMImpersonationClientListing class])];
    }
    
    return _prototypeCell;
}


- (void)configureCell:(SMImpersonationClientListing *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _prototypeCell.backgroundColor = [UIColor clearColor];
    _prototypeCell.lblClientName.textColor = [UIColor whiteColor];
    [_prototypeCell.lblClientName setNumberOfLines:0];
    [_prototypeCell.lblClientName setLineBreakMode:NSLineBreakByWordWrapping];
    
    [_prototypeCell.lblClientName sizeToFit];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        _prototypeCell.lblClientName.font = [UIFont fontWithName:FONT_NAME size:15.0f];
    }
    else
    {
        _prototypeCell.lblClientName.font = [UIFont fontWithName:FONT_NAME size:20.0f];
    }
    _prototypeCell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _prototypeCell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:85.0/255.0 blue:152.0/255.0 alpha:0.2];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblViewDropDown)
    {
        static NSString *cellIdentifier= @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        
        
        cell.backgroundColor = [UIColor colorWithRed:33.0/255 green:34.0/255 blue:35.0/255 alpha:1.0];
        cell.textLabel.text = [arrayDropDown objectAtIndex:indexPath.row];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:15.0];
        }
        else
        {
            cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:20.0];
        }
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:24.0/255.0 green:85.0/255.0 blue:152.0/255.0 alpha:0.2];
        return cell;
    }
    else
    {
        SMImpersonationClientListing *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SMImpersonationClientListing class])];
        SMImpersonateObject *clientObject = (SMImpersonateObject*)[filteredArray objectAtIndex:indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.lblClientName.text = clientObject.impersonateClientName;
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /////////////////////////////////////////Monami///////////////////////////
    /////////////////////Only Delete array Count Condition from indexpath 1 and 2 while impersonate data still not coming through API///////////////////////
    if(tableView==self.tblViewDropDown)
    {
        
        if( indexPath.row==2)
        {
                [self btnLogoutDidClicked];
        }
//        else if([SMGlobalClass sharedInstance].arrayOfImpersonateClients.count==0 && indexPath.row==1)
//        {
//            [self btnLogoutDidClicked];
//        }
        else if(indexPath.row==1)
        {
            
                [UIActionSheet showInView:self.view
                                withTitle:@"Select the picture"
                        cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@[@"Camera", @"Select from library"]
                          didDismissBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                              
                              
                              switch (buttonIndex) {
                                  case 0:
                                  {
                                      
                                      if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
                                      {
                                          self.multipleImagePicker.isFromApp = YES;
                                          picker = [[UIImagePickerController alloc] init];
                                          picker.delegate = self;
                                          [picker setAllowsEditing:NO];
                                          picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                          [self presentViewController:picker animated:YES completion:^{}];
                                      }
                                      else
                                      {
                                          SMAlert(KLoaderTitle, @"Camera Not Available.");
                                          return;
                                      }
                                  }
                                      break;
                                  case 1:
                                  {
                                      
                                      [SMGlobalClass sharedInstance].isFromCamera = NO;
                                      
                                      [self callPhotoUploadForUserImage];
                                  }
                                      
                                  default:
                                      break;
                              }
                              
                              
                          }];
            
        }
        else if(indexPath.row==0)
        {
            [self.tblViewDropDown removeFromSuperview];
            
            if([[arrayDropDown objectAtIndex:0] isEqualToString:@"Impersonate"])
            {
                // hereeeeeee
                
                [self.tblSearchClients reloadData];
                
                [self.view addSubview:self.confirmationView];
                self.txtFieldSearch.text = @"";
                self.tblSearchClients.scrollEnabled = YES;
                self.tblSearchClients.tableFooterView = nil;
                self.confirmationView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
                

            }
            else if([[arrayDropDown objectAtIndex:0] isEqualToString:@"Revert"])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"setTheTopHeaderData" object:nil];
                [arrayDropDown replaceObjectAtIndex:0 withObject:@"Impersonate"];
                [SMGlobalClass sharedInstance].strClientID = [SMGlobalClass sharedInstance].strDefaultClientID;
            }
            
        }
    }
    else
    {
        
        if([[arrayDropDown objectAtIndex:0] isEqualToString:@"Impersonate"])
        {
            SMImpersonateObject *clientObject = (SMImpersonateObject*)[filteredArray objectAtIndex:indexPath.row];
            [SMGlobalClass sharedInstance].strClientID = clientObject.impersonateClientID;
            
            self.txtFieldSearch.text = @"";
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SetTheSelectedClientNameNotification" object:clientObject];
            [arrayDropDown replaceObjectAtIndex:0 withObject:@"Revert"];
            
            [self.confirmationView removeFromSuperview];
        }
        else if([[arrayDropDown objectAtIndex:0] isEqualToString:@"Revert"])
        {
            [SMGlobalClass sharedInstance].strClientID = [SMGlobalClass sharedInstance].strDefaultClientID;
        }
        else
        {
            [self btnLogoutDidClicked];
        }
    }
}

-(void) sendTheImpersonateClients:(NSMutableArray*)arrayOfImpersonateClients
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [HUD hide:YES];
//    });
    
    
    [SMGlobalClass sharedInstance].arrayOfImpersonateClients = arrayOfImpersonateClients;
    
     filteredArray = [SMGlobalClass sharedInstance].arrayOfImpersonateClients;
    
    

}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    
    if(subModuleNumber == -1)
    {
        float heigthCollectionView = self.collectionViewModuleList.bounds.size.height;
        
        int numberOfRows = 0;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            numberOfRows = (int)heigthCollectionView/106.0;
        }
        else
        {
            numberOfRows = (int)heigthCollectionView/110.0;
        }
        int expectedSections = numberOfRows*3;
        
        if(!isThirdLevelGridNeedToBeDisplayedFromSideMenu)
        {
            strModuleName = previousModuleName;
        }
        
        if ([[self arraySelected:strModuleName] count] < expectedSections)
        {
            int numberOfSectionsNeedToBeAdded = expectedSections-(int)[[self arraySelected:strModuleName] count];
            if (numberOfSectionsNeedToBeAdded > 0)
            {
                for (int i=0;i<numberOfSectionsNeedToBeAdded;i++)
                {
                    SMGridModuleData *gridModuleObj = [[SMGridModuleData alloc] init];
                    gridModuleObj.moduleName = @"";
                    gridModuleObj.isQuickLink = NO;
                    gridModuleObj.isAlertPresent = NO;
                    [[self arraySelected:strModuleName] addObject:gridModuleObj];
                }
            }
        }
        
        return [[self arraySelected:strModuleName] count];
    }
    else
    {
        
        float heigthCollectionView = self.collectionViewModuleList.bounds.size.height;
        
        int numberOfRows = 0;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            numberOfRows = (int)heigthCollectionView/106.0;
        }
        else
        {
            numberOfRows = (int)heigthCollectionView/110.0;
        }
        int expectedSections = numberOfRows*3;
        if (subModuleNumber < expectedSections)
        {
            int numberOfSectionsNeedToBeAdded = expectedSections-(int)subModuleNumber;
            if (numberOfSectionsNeedToBeAdded > 0)
            {
                for (int i=0;i<numberOfSectionsNeedToBeAdded;i++)
                {
                    SMGridModuleData *gridModuleObj = [[SMGridModuleData alloc] init];
                    gridModuleObj.moduleName = @"";
                    gridModuleObj.isQuickLink = NO;
                    gridModuleObj.isAlertPresent = NO;
                    [arrayOfSubModulePages addObject:gridModuleObj];
                }
            }
        }

        return arrayOfSubModulePages.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMModuleGridViewCell *moduleCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"SMModuleGridViewCell"
                                              forIndexPath:indexPath];
    
    // to make label in round shape.
    // corner radius = height of the label/2. where height of the label should be an even number.
    
    moduleCell.lblCount.textAlignment = NSTextAlignmentCenter;
    moduleCell.lblCount.textColor = [UIColor whiteColor];
    [moduleCell.lblCount.layer setCornerRadius:moduleCell.lblCount.frame.size.height/2];
    [moduleCell.lblCount.layer setMasksToBounds:YES];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [moduleCell.lblCount setFont:[UIFont fontWithName:FONT_NAME size:10.0]];
        [moduleCell.lblModuleName setFont:[UIFont fontWithName:FONT_NAME_BOLD size:12.0]];
    }
    else
    {
        [moduleCell.lblCount setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
        [moduleCell.lblModuleName setFont:[UIFont fontWithName:FONT_NAME_BOLD size:18.0]];
    }
    
    
    if ([SMGlobalClass sharedInstance].arrayOfModules.count == 0)
    {
        [self.collectionViewModuleList setScrollEnabled:NO];
    }
    else
    {
    
        [self.collectionViewModuleList setScrollEnabled:YES];

    }
    
    // this paert is just the dynamic implementation.
    SMGridModuleData *gridModuleObj;
    if(subModuleNumber == -1)
    {
       gridModuleObj = (SMGridModuleData*)[[self arraySelected:strModuleName] objectAtIndex:indexPath.row];
    }
    else
    {
        gridModuleObj = (SMGridModuleData*)[arrayOfSubModulePages objectAtIndex:indexPath.row];
    }
    
        if ([gridModuleObj.moduleName isEqualToString:@"Photos &amp; Extras"])
        {
            moduleCell.lblModuleName.text = @"Photos & Extras";
        }
        else{
            moduleCell.lblModuleName.text = gridModuleObj.moduleName;
        }
    
    

    if ([gridModuleObj.moduleName isEqualToString:@""] || [gridModuleObj.moduleName rangeOfString:@""].location !=NSNotFound)
    {
        [moduleCell.lblImage setText:@""];
        [moduleCell.imgModuleImage setImage:[UIImage imageNamed:@""]];
    }
    else
    {
        [moduleCell.imgModuleImage setImage:[UIImage imageNamed:@""]];
        [Fontclass AttributeStringMethodwithFontWithLabel:moduleCell.lblImage moduleName:gridModuleObj.moduleName];
    }

    
    
    if ([gridModuleObj.moduleName length] == 0)
        moduleCell.lblCount.hidden = YES;
    else
        moduleCell.lblCount.hidden = YES;
    
    return moduleCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell selected = %ld",(long)indexPath.row);
    
    if(indexPath.row == 3)
        [SMGlobalClass sharedInstance].isListModule = YES;
    else
        [SMGlobalClass sharedInstance].isListModule = NO;
    
    [self.tblViewDropDown removeFromSuperview];
    
    
    SMGridModuleData *gridModuleObj ;
    
    if (selectedModule == home) //if true this displays the second level of grid
    {
        
        isThirdLevelGridNeedToBeDisplayedFromSideMenu = YES;
        isBackToHome = YES;
        gridModuleObj = (SMGridModuleData*)[[self arraySelected:strModuleName] objectAtIndex:indexPath.row];
      
        
        if([gridModuleObj.moduleName length]==0)
            return;
        
        strModuleName = gridModuleObj.moduleName;
        previousModuleName = strModuleName;
        previousSubModuleNumber = [[self arraySelected:strModuleName] count];
        selectedModule = others; /// todayy
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTheSlideMenu" object:[self arrayPassedForSlideMenu:gridModuleObj.moduleName]];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"InitialRefreshMainMenuName" object:strModuleName];
        self.lblHome.text = @"Back";
        [Fontclass AttributeStringMethodwithFontWithButton:self.btnHome iconID:24];
        [self.collectionViewModuleList reloadData];
        self.lblTitle.text = strModuleName;
    }
    else // if we want to dispaly the third level grid or navigation
    {
        isThirdLevelGridNeedToBeDisplayedFromSideMenu = NO;
        

        NSMutableArray *tempArray = [self arraySelected:strModuleName];
        if(tempArray.count > 0) // if true it will display the third level grid or navigation
        {
        
        gridModuleObj = (SMGridModuleData*)[[self arraySelected:strModuleName] objectAtIndex:indexPath.row];
        
        if([gridModuleObj.moduleName length]==0)
            return;
        
        if (gridModuleObj.arrayOfPages.count > 0) // if true it means that arrayOfpages contains submodules so this causes to display the third level grid
        {
            isBackToHome = NO;
            subModuleNumber = gridModuleObj.arrayOfPages.count;
            strModuleName = gridModuleObj.moduleName;
            selectedModule = others;
            arrayOfSubModulePages = [[NSMutableArray alloc]init];
            arrayOfSubModulePages = gridModuleObj.arrayOfPages;
            NSMutableArray *slideMenuArray = [arrayOfSubModulePages mutableCopy];
            SMGridModuleData *slideMenuObj = (SMGridModuleData*)[slideMenuArray objectAtIndex:0];
            
            if(![slideMenuObj.moduleName isEqualToString:@"Home"])
            {
                SMGridModuleData *modulePageObj = [[SMGridModuleData alloc]init];
                modulePageObj.moduleName = @"Home";
                modulePageObj.isQuickLink = YES;
            [slideMenuArray insertObject:modulePageObj atIndex:0];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTheSlideMenu" object:slideMenuArray];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"InitialRefreshMainMenuName" object:strModuleName];
            self.lblHome.text = @"Back";
            [Fontclass AttributeStringMethodwithFontWithButton:self.btnHome iconID:24];
            [self.collectionViewModuleList reloadData];
            self.lblTitle.text = strModuleName;
            
        }
        else // this will dispaly the navigation for second level grid
        {
            isThirdLevelGridNeedToBeDisplayedFromSideMenu = NO;
            [self openGridScreens:gridModuleObj.moduleName]; // navigation to idividual pages
        }
        }
        else// tempArray count is 0 which means we are now in third level grid so now we need to do the navigation
        {
            
            
            SMGridModuleData *obj = (SMGridModuleData*)[arrayOfSubModulePages objectAtIndex:indexPath.row];
            subModulePageName = obj.moduleName;
            
            
           [self openGridScreens:subModulePageName]; // navigation to idividual pages when in third level Grid.
        }
    }
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (screenSize.height == 812)
        {
           return CGSizeMake(124, 124);
            
        }
        else{
          return CGSizeMake(106, 106);
        }
    }
    else
    {
        return CGSizeMake(190, 172);
    }
}


// Layout: Set Edges

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods

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
    //[HUD hide:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
        });
    });
            
}


-(void)openGridScreens:(NSString*)moduleName
{
  
    if([moduleName isEqualToString:@"Blog Post"])
    {
        SMSearchBlogViewController *searchBlogViewController;

        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            searchBlogViewController = [[SMSearchBlogViewController alloc]initWithNibName:@"SMSearchBlogViewController" bundle:nil];
        }
        else
        {
            searchBlogViewController = [[SMSearchBlogViewController alloc]initWithNibName:@"SMSearchBlogViewController_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:searchBlogViewController animated:YES];
        
        //////////////////////////////////////////////////////////////////////////////////////////////
        
        
       /*SMLeadsListViewController *leadsViewController;
        leadsViewController = [[SMLeadsListViewController alloc]initWithNibName:@"SMLeadsListViewController" bundle:nil];
        
        [self.navigationController pushViewController:leadsViewController animated:YES];*/
        
        
        
    }
    
    else if([moduleName isEqualToString:@"Delivery"])
    {
       SMCreateBlogViewController *createBlogViewController ;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            createBlogViewController = [[SMCreateBlogViewController alloc]initWithNibName:@"SMCreateBlogViewController" bundle:nil];
        }
        else
        {
            createBlogViewController = [[SMCreateBlogViewController alloc]initWithNibName:@"SMCreateBlogViewController_iPad" bundle:nil];
        }
        createBlogViewController.isFromCustomerDelivery = YES;
        [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil]];
        
        [self.navigationController pushViewController:createBlogViewController animated:YES];
        
        /*SMVehicleStockListViewController *vehicleStockViewController ;
        
        
            vehicleStockViewController = [[SMVehicleStockListViewController alloc]initWithNibName:@"SMVehicleStockListViewController" bundle:nil];
        
       
        [self.navigationController pushViewController:vehicleStockViewController animated:YES];*/
        
               
    }
    else if([moduleName isEqualToString:@"Stock List"])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            SMStockListViewController *stockAuditViewController;
            stockAuditViewController = [[SMStockListViewController alloc]initWithNibName:@"SMStockListViewController" bundle:nil];
            stockAuditViewController.isFromEBrochure = NO;
            [self.navigationController pushViewController:stockAuditViewController animated:YES];
        }
        else
        {
            SMStockListViewController *stockAuditViewController;
            stockAuditViewController = [[SMStockListViewController alloc]initWithNibName:@"SMStockListViewController~ipad" bundle:nil];
            stockAuditViewController.isFromEBrochure = NO;
            [self.navigationController pushViewController:stockAuditViewController animated:YES];
            
        }
    
    }
    else if([moduleName isEqualToString:@"Scan VIN"])
    {
        SMSynopsisVINScanViewController *synopsisScanViewController;
        
        synopsisScanViewController = [[SMSynopsisVINScanViewController alloc] initWithNibName:@"SMSynopsisVINScanViewController" bundle:nil];
        
        [self.navigationController pushViewController:synopsisScanViewController animated:YES];
        
        
        
    }
   
    else if([moduleName isEqualToString:@"Vehicle Lookup"])
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            SMSynopsisVehicleLookUpViewController *synopsisVehicleLookupViewController;
            
            synopsisVehicleLookupViewController = [[SMSynopsisVehicleLookUpViewController alloc] initWithNibName:@"SMSynopsisVehicleLookUpViewController" bundle:nil];
            
            [self.navigationController pushViewController:synopsisVehicleLookupViewController animated:YES];
        }
        else
        {
            SMSynopsisVehicleLookUpViewController *synopsisVehicleLookupViewController;
            
            synopsisVehicleLookupViewController = [[SMSynopsisVehicleLookUpViewController alloc] initWithNibName:@"SMSynopsisVehicleLookUpViewController_iPad" bundle:nil];
            
            [self.navigationController pushViewController:synopsisVehicleLookupViewController animated:YES];
        }
        
    }
    else if([moduleName isEqualToString:@"Vehicle Code"])
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            SMSynopsisVehicleCodeViewController *synopsisVehicleCodeViewController;
            
            synopsisVehicleCodeViewController = [[SMSynopsisVehicleCodeViewController alloc] initWithNibName:@"SMSynopsisVehicleCodeViewController" bundle:nil];
            
            [self.navigationController pushViewController:synopsisVehicleCodeViewController animated:YES];
        }
        else
        {
            SMSynopsisVehicleCodeViewController *synopsisVehicleCodeViewController;
            
            synopsisVehicleCodeViewController = [[SMSynopsisVehicleCodeViewController alloc] initWithNibName:@"SMSynopsisVehicleCodeViewController_iPad" bundle:nil];
            
            [self.navigationController pushViewController:synopsisVehicleCodeViewController animated:YES];
        }
    }
    else if([moduleName isEqualToString:@"Vehicle in Stock"])
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
        SMSynopsisVehicleInStockViewController *synopsisVehicleInStockViewController;
        
        synopsisVehicleInStockViewController = [[SMSynopsisVehicleInStockViewController alloc] initWithNibName:@"SMSynopsisVehicleInStockViewController" bundle:nil];
        
        [self.navigationController pushViewController:synopsisVehicleInStockViewController animated:YES];
        }
        else
        {
            SMSynopsisVehicleInStockViewController *synopsisVehicleInStockViewController;
            
            synopsisVehicleInStockViewController = [[SMSynopsisVehicleInStockViewController alloc] initWithNibName:@"SMSynopsisVehicleInStockViewController_iPad" bundle:nil];
            
            [self.navigationController pushViewController:synopsisVehicleInStockViewController animated:YES];
        }
        
    }
    else if([moduleName isEqualToString:@"Saved Appraisals"])
    {
        SMSaveAppraisalsViewController *synopsisSavedAppraisalViewController;
        
        synopsisSavedAppraisalViewController = [[SMSaveAppraisalsViewController alloc] initWithNibName:@"SMSaveAppraisalsViewController" bundle:nil];
        
        [self.navigationController pushViewController:synopsisSavedAppraisalViewController animated:YES];
        
    }
    else if([moduleName isEqualToString:@"Log Activity"])
    {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        SMVehicleNewBrochureViewController *newBrochureVC = [storyboard instantiateViewControllerWithIdentifier:@"SMVehicleNewBrochureViewController"];
        [self.navigationController pushViewController:newBrochureVC animated:YES];
        
        
        /*SMAppNotificationsViewController *appNotificationVC;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            appNotificationVC = [[SMAppNotificationsViewController alloc]initWithNibName:@"SMAppNotificationsViewController" bundle:nil];
        }
        else
        {
            appNotificationVC = [[SMAppNotificationsViewController alloc]initWithNibName:@"SMAppNotificationsViewController" bundle:nil];
        }
        
        [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil]];
        
        [self.navigationController pushViewController:appNotificationVC animated:YES];*/
    }
    else if([moduleName isEqualToString:@"Notifications"])
    {
        SMAppNotificationsViewController *appNotificationVC;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            appNotificationVC = [[SMAppNotificationsViewController alloc]initWithNibName:@"SMAppNotificationsViewController" bundle:nil];
        }
        else
        {
            appNotificationVC = [[SMAppNotificationsViewController alloc]initWithNibName:@"SMAppNotificationsViewController" bundle:nil];
        }
        
        [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil]];
        
        [self.navigationController pushViewController:appNotificationVC animated:YES];
    }
    
    else if([moduleName isEqualToString:@"New Task"])
    {
        SMPlannerNewTaskViewController *newTaskViewController;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            newTaskViewController = [[SMPlannerNewTaskViewController alloc]initWithNibName:@"SMPlannerNewTaskViewController" bundle:nil];
        }
        else
        {
            newTaskViewController = [[SMPlannerNewTaskViewController alloc]initWithNibName:@"SMPlannerNewTaskViewController_iPad" bundle:nil];
        }
        
        [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil]];
        
        [self.navigationController pushViewController:newTaskViewController animated:YES];
    }
    
    else if([moduleName isEqualToString:@"To Do's"])
    {
        SMPlannerToDoViewController *toDosViewController;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            toDosViewController = [[SMPlannerToDoViewController alloc]initWithNibName:@"SMPlannerToDoViewController" bundle:nil];
        }
        else
        {
            toDosViewController = [[SMPlannerToDoViewController alloc]initWithNibName:@"SMPlannerToDoViewController_iPad" bundle:nil];
        }
        
        [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil]];
        
        [self.navigationController pushViewController:toDosViewController animated:YES];
    }
    
    else if([moduleName isEqualToString:@"Tasks by Me"])
    {
        SMPlannerTasksByMeViewController *toDosViewController;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            toDosViewController = [[SMPlannerTasksByMeViewController alloc]initWithNibName:@"SMPlannerTasksByMeViewController" bundle:nil];
        }
        else
        {
            toDosViewController = [[SMPlannerTasksByMeViewController alloc]initWithNibName:@"SMPlannerTasksByMeViewController_iPad" bundle:nil];
        }
        
        [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil]];
        
        [self.navigationController pushViewController:toDosViewController animated:YES];
    }
    
    
    // For Trader - Added By Jignesh
    else if ([moduleName isEqualToString:@"Buy"])
    {
        SMTraderViewController *traderViewController;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            traderViewController = [[SMTraderViewController alloc] initWithNibName:@"SMTraderViewController" bundle:nil];
        }
        else
        {
            traderViewController = [[SMTraderViewController alloc] initWithNibName:@"SMTraderViewController_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:traderViewController animated:YES];
    }
    else if([moduleName isEqualToString:@"Trade Vehicles"])
    {
        SMTradeVehicleListingViewController *activeTrade = [[SMTradeVehicleListingViewController alloc] initWithNibName:@"SMTradeVehicleListingViewController" bundle:nil];
        
        [self.navigationController pushViewController:activeTrade animated:YES];
    }
    
    
    else if ([moduleName isEqualToString:@"Bidding Ended"])
    {
        SMBiddingEndedViewController *sellsObj;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            sellsObj = [[SMBiddingEndedViewController alloc] initWithNibName:@"SMBiddingEndedViewController" bundle:nil];
        }
        else
        {
            sellsObj = [[SMBiddingEndedViewController alloc] initWithNibName:@"SMBiddingEndedViewController_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:sellsObj animated:YES];
    }
    
    else if([moduleName isEqualToString:@"Sales"])
    {
        SMSalesViewController *newTaskViewController;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            newTaskViewController = [[SMSalesViewController alloc]initWithNibName:@"SMSalesViewController" bundle:nil];
        }
        else
        {
            newTaskViewController = [[SMSalesViewController alloc]initWithNibName:@"SMSalesViewController_iPad" bundle:nil];
        }
        
        [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil]];
        
        [self.navigationController pushViewController:newTaskViewController animated:YES];
    }
    
    else if ([moduleName isEqualToString:@"Bids Received"])
    {
        
        SMBiddingReceivedViewController *SMBidReceived = [[SMBiddingReceivedViewController alloc] initWithNibName:@"SMBiddingReceivedViewController" bundle:nil];
        [self.navigationController pushViewController:SMBidReceived animated:YES];
    }
    else if ([moduleName isEqualToString:@"Winning Bids"])
    {
        SMTraderPrivateOffersViewController *winningBidsVC;
       winningBidsVC = [[SMTraderPrivateOffersViewController alloc] initWithNibName:@"SMTraderPrivateOffersViewController" bundle:nil];
         winningBidsVC.viewControllerBidType = 0;
       [self.navigationController pushViewController:winningBidsVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"Losing Bids"])
    {
        SMTraderPrivateOffersViewController *winningBidsVC;
        winningBidsVC = [[SMTraderPrivateOffersViewController alloc] initWithNibName:@"SMTraderPrivateOffersViewController" bundle:nil];
        winningBidsVC.viewControllerBidType = 1;
        [self.navigationController pushViewController:winningBidsVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"Auto Bidding"])
    {
        SMTraderPrivateOffersViewController *winningBidsVC;
        winningBidsVC = [[SMTraderPrivateOffersViewController alloc] initWithNibName:@"SMTraderPrivateOffersViewController" bundle:nil];
        winningBidsVC.viewControllerBidType = 2;
        [self.navigationController pushViewController:winningBidsVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"Won"])
    {
        SMTrader_WinningBidsViewController *winningBidsVC;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            winningBidsVC = [[SMTrader_WinningBidsViewController alloc] initWithNibName:@"SMTrader_WinningBidsViewController" bundle:nil];
        }
        else
        {
            winningBidsVC = [[SMTrader_WinningBidsViewController alloc] initWithNibName:@"SMTrader_WinningBidsViewController~iPad" bundle:nil];
        }
        
        winningBidsVC.viewControllerBidType = 0;
        [self.navigationController pushViewController:winningBidsVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"Lost"])
    {
        SMTrader_WinningBidsViewController *winningBidsVC;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            winningBidsVC = [[SMTrader_WinningBidsViewController alloc] initWithNibName:@"SMTrader_WinningBidsViewController" bundle:nil];
        }
        else
        {
            winningBidsVC = [[SMTrader_WinningBidsViewController alloc] initWithNibName:@"SMTrader_WinningBidsViewController~iPad" bundle:nil];
        }
        winningBidsVC.viewControllerBidType = 1;
        [self.navigationController pushViewController:winningBidsVC animated:YES];
    }
    
    else if ([moduleName isEqualToString:@"Cancelled"])
    {
        SMTrader_WinningBidsViewController *winningBidsVC;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            winningBidsVC = [[SMTrader_WinningBidsViewController alloc] initWithNibName:@"SMTrader_WinningBidsViewController" bundle:nil];
        }
        else
        {
            winningBidsVC = [[SMTrader_WinningBidsViewController alloc] initWithNibName:@"SMTrader_WinningBidsViewController~iPad" bundle:nil];
        }
        winningBidsVC.viewControllerBidType = 2;
        [self.navigationController pushViewController:winningBidsVC animated:YES];
    }
    
    else if ([moduleName isEqualToString:@"Withdrawn"])
    {
        SMTrader_WinningBidsViewController *winningBidsVC;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            winningBidsVC = [[SMTrader_WinningBidsViewController alloc] initWithNibName:@"SMTrader_WinningBidsViewController" bundle:nil];
        }
        else
        {
            winningBidsVC = [[SMTrader_WinningBidsViewController alloc] initWithNibName:@"SMTrader_WinningBidsViewController~iPad" bundle:nil];
        }
        winningBidsVC.viewControllerBidType = 3;
        [self.navigationController pushViewController:winningBidsVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"Private Offers"])
    {
        SMTrader_WinningBidsViewController *winningBidsVC;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            winningBidsVC = [[SMTrader_WinningBidsViewController alloc] initWithNibName:@"SMTrader_WinningBidsViewController" bundle:nil];
        }
        else
        {
            winningBidsVC = [[SMTrader_WinningBidsViewController alloc] initWithNibName:@"SMTrader_WinningBidsViewController~iPad" bundle:nil];
        }

        winningBidsVC.viewControllerBidType = 4;
        [self.navigationController pushViewController:winningBidsVC animated:YES];
    }
    
    // Vehicle Alerts Pages
    
    else if ([moduleName isEqualToString:@"Missing Price"])
    {
        SMVehicleAlertsViewController *missingPriceVC;
        missingPriceVC = [[SMVehicleAlertsViewController alloc] initWithNibName:@"SMVehicleAlertsViewController" bundle:nil];
        missingPriceVC.viewControllerVehicleAlertType = 0;
        [self.navigationController pushViewController:missingPriceVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"Activate Retail"])
    {
        SMVehicleAlertsViewController *activateRetailVC;
        activateRetailVC = [[SMVehicleAlertsViewController alloc] initWithNibName:@"SMVehicleAlertsViewController" bundle:nil];
        activateRetailVC.viewControllerVehicleAlertType = 1;
        [self.navigationController pushViewController:activateRetailVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"Missing Info"])
    {
        SMVehicleAlertsViewController *missingInfoVC;
        missingInfoVC = [[SMVehicleAlertsViewController alloc] initWithNibName:@"SMVehicleAlertsViewController" bundle:nil];
        missingInfoVC.viewControllerVehicleAlertType = 2;
        [self.navigationController pushViewController:missingInfoVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"Readiness"])
    {
        SMSettings_ReadinessViewController *readinessVC;
        readinessVC = [[SMSettings_ReadinessViewController alloc] initWithNibName:@"SMSettings_ReadinessViewController" bundle:nil];
        [self.navigationController pushViewController:readinessVC animated:YES];
        
        /*SMReusableHeaderViewController *readinessVC = [[SMReusableHeaderViewController alloc]initWithNibName:UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? @"SMReusableHeaderViewController" : @"SMReusableHeaderViewController_iPad" bundle:nil];*/
        
    }
    else if ([moduleName isEqualToString:@"Auctions"])
    {
        SMSettings_AuctionViewController *auctionVC;
        auctionVC = [[SMSettings_AuctionViewController alloc] initWithNibName:@"SMSettings_AuctionViewController" bundle:nil];
        [self.navigationController pushViewController:auctionVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"Display"])
    {
        SMSettings_DisplayViewController *displayVC;
        displayVC = [[SMSettings_DisplayViewController alloc] initWithNibName:@"SMSettings_DisplayViewController" bundle:nil];
        [self.navigationController pushViewController:displayVC animated:YES];
        
      /*  SMWantedViewController *wantedVC = [[SMWantedViewController alloc]initWithNibName:UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? @"SMWantedViewController" : @"SMWantedViewController_iPad" bundle:nil];
        
        [self.navigationController pushViewController:wantedVC animated:YES];*/
    }
    else if ([moduleName isEqualToString:@"Trade Price"])
    {
        SMSettings_TradePriceViewController *tradePriceVC;
        tradePriceVC = [[SMSettings_TradePriceViewController alloc] initWithNibName:@"SMSettings_TradePriceViewController" bundle:nil];
        [self.navigationController pushViewController:tradePriceVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"Custom Msgs"])
    {
        SMSettings_CustomMsgsViewController *customMsgsVC;
        customMsgsVC = [[SMSettings_CustomMsgsViewController alloc] initWithNibName:@"SMSettings_CustomMsgsViewController" bundle:nil];
        [self.navigationController pushViewController:customMsgsVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"My Buyers"])
    {
        SMMyBuyersSellersViewController *myBuyersSellersVC;
        myBuyersSellersVC = [[SMMyBuyersSellersViewController alloc] initWithNibName:@"SMMyBuyersSellersViewController" bundle:nil];
        myBuyersSellersVC.viewControllerTradePartnerType = 0;
        [self.navigationController pushViewController:myBuyersSellersVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"My Sellers"])
    {
        SMMyBuyersSellersViewController *myBuyersSellersVC;
        myBuyersSellersVC = [[SMMyBuyersSellersViewController alloc] initWithNibName:@"SMMyBuyersSellersViewController" bundle:nil];
        myBuyersSellersVC.viewControllerTradePartnerType = 1;
        [self.navigationController pushViewController:myBuyersSellersVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"Members"])
    {
        SMSettings_MembersViewController *membersVC;
        membersVC = [[SMSettings_MembersViewController alloc] initWithNibName:@"SMSettings_MembersViewController" bundle:nil];
        [self.navigationController pushViewController:membersVC animated:YES];
    }
    else if ([moduleName isEqualToString:@"Trade Partners"])
    {
        SMTradePartnersViewController *tradePartnersVC;
        tradePartnersVC = [[SMTradePartnersViewController alloc] initWithNibName:@"SMTradePartnersViewController" bundle:nil];
        [self.navigationController pushViewController:tradePartnersVC animated:YES];
    }

    
    // For Vehicles - Added By Priya
    else if ([moduleName isEqualToString:@"Load Vehicle"])
    {
        
        
       SMLoadVehiclesViewController *traderViewController;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            traderViewController = [[SMLoadVehiclesViewController alloc] initWithNibName:@"SMLoadVehiclesViewController" bundle:nil];
        }
        else
        {
            traderViewController = [[SMLoadVehiclesViewController alloc] initWithNibName:@"SMLoadVehiclesViewController~ipad" bundle:nil];
        }
        [self.navigationController pushViewController:traderViewController animated:YES];
        
        
//        SMCustomerScanViewController *customerScanViewController;
//        
//        customerScanViewController = [[SMCustomerScanViewController alloc] initWithNibName:@"SMCustomerScanViewController" bundle:nil];
//        
//        
//        [self.navigationController pushViewController:customerScanViewController animated:YES];
        
    }
    else if([moduleName isEqualToString:@"Stock Summary"])
    {
        
        
        SMStockSummaryTableVC *stockSummaryVC;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Vehicles" bundle:nil];
        
       stockSummaryVC = [sb instantiateViewControllerWithIdentifier:@"SMStockSummaryTableVC"];
        [self.navigationController pushViewController:stockSummaryVC animated:YES];
    }
    
    else if([moduleName isEqualToString:@"Customer"])
    {
        SMCustomerScanViewController *customerScanViewController;
        
        customerScanViewController = [[SMCustomerScanViewController alloc] initWithNibName:@"SMCustomerScanViewController" bundle:nil];
        
        
        [self.navigationController pushViewController:customerScanViewController animated:YES];
    }
    
    
    else if ([moduleName isEqualToString:@"Leads"] || [moduleName isEqualToString:@"My Leads"])
    {
        
        SMLeadsListViewController *leadsViewController;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
             leadsViewController = [[SMLeadsListViewController alloc]initWithNibName:@"SMLeadsListViewController" bundle:nil];
        }
        else
        {
            leadsViewController = [[SMLeadsListViewController alloc]initWithNibName:@"SMLeadsListViewController~iPad" bundle:nil];
        }
        
        [self.navigationController pushViewController:leadsViewController animated:YES];
        
    }
    else if ([moduleName isEqualToString:@"Scan License"])
    {
        SMCustomerScanViewController *customerScanViewController;
        
        customerScanViewController = [[SMCustomerScanViewController alloc] initWithNibName:@"SMCustomerScanViewController" bundle:nil];
        
         [self.navigationController pushViewController:customerScanViewController animated:YES];

        
    }
    
   else if ([moduleName isEqualToString:@"E-Brochure"] || [moduleName isEqualToString:@"Send Brochure"] || [moduleName isEqualToString:@"eBrochure"])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            SMStockListViewController *stockAuditViewController;
            stockAuditViewController = [[SMStockListViewController alloc]initWithNibName:@"SMStockListViewController" bundle:nil];
            stockAuditViewController.isFromEBrochure = YES;
            [self.navigationController pushViewController:stockAuditViewController animated:YES];
        }
        else
        {
            SMStockListViewController *stockAuditViewController;
            stockAuditViewController = [[SMStockListViewController alloc]initWithNibName:@"SMStockListViewController~ipad" bundle:nil];
            stockAuditViewController.isFromEBrochure = YES;
            [self.navigationController pushViewController:stockAuditViewController animated:YES];
            
        }

        
    }

    
    else if ([moduleName isEqualToString:@"Stock Audit"])
    {
        SMVehicleStockAuditList *stockAuditViewController;
        stockAuditViewController = [[SMVehicleStockAuditList alloc]initWithNibName:@"SMVehicleStockAuditList" bundle:nil];
        
        [self.navigationController pushViewController:stockAuditViewController animated:YES];
    }
        
    
    // added by Jignesh  --
    else if([moduleName isEqualToString:@"VIN Lookup"])
    {
        SMVINLookUpViewController *VINLookUpView;
          VINLookUpView =[[SMVINLookUpViewController alloc]initWithNibName:@"SMVINLookUpViewController" bundle:nil];

        [self.navigationController pushViewController:VINLookUpView animated:YES];
    }
    
    // For Vehicles - Added By Sandeep
    
    //Photos &amp; Extras
    //Photos & Extras
    else if ([moduleName isEqualToString:@"Photos &amp; Extras"] || [moduleName isEqualToString:@"Edit Stock"] || [moduleName isEqualToString:@"List"])
    {
        if([moduleName isEqualToString:@"Edit Stock"] || [strModuleName isEqualToString:@"List"])
            [SMGlobalClass sharedInstance].isListModule = YES;
        else if([moduleName isEqualToString:@"Photos &amp; Extras"])
            [SMGlobalClass sharedInstance].isListModule = NO;
        
        SMPhotosAndExtrasListViewController *traderViewController;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            traderViewController = [[SMPhotosAndExtrasListViewController alloc] initWithNibName:@"SMPhotosAndExtrasListViewController" bundle:nil];
        }
        else
        {
            traderViewController = [[SMPhotosAndExtrasListViewController alloc] initWithNibName:@"SMPhotosAndExtrasListViewController_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:traderViewController animated:YES];
    }
    // For Vehicles - Added By Sandeep
    else if ([moduleName isEqualToString:@"Specials"])
    {
        SMSpecialsViewController *specialsObj;
        
        specialsObj = [[SMSpecialsViewController alloc] initWithNibName:@"SMSpecialsViewController" bundle:nil];
        
        [self.navigationController pushViewController:specialsObj animated:YES];
    }
    
    // For Vehicles - Added By Ketan
    
    else if ([moduleName isEqualToString:@"Sell"])
    {
        SMSellsViewController *sellsObj;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            sellsObj = [[SMSellsViewController alloc] initWithNibName:@"SMSellsViewController" bundle:nil];
        }
        else
        {
            sellsObj = [[SMSellsViewController alloc] initWithNibName:@"SMSellsViewController_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:sellsObj animated:YES];
    }
    
    else if ([moduleName isEqualToString:@"My Bids"])
    {
        SMMyBidsViewController *mybidsObj;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            mybidsObj = [[SMMyBidsViewController alloc] initWithNibName:@"SMMyBidsViewController" bundle:nil];
        }
        else
        {
            mybidsObj = [[SMMyBidsViewController alloc] initWithNibName:@"SMMyBidsViewController_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:mybidsObj animated:YES];
    }
    
    else if([moduleName isEqualToString:@"Wanted"])
    {
        SMWantedViewController *wantedVC = [[SMWantedViewController alloc]initWithNibName:UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? @"SMWantedViewController" : @"SMWantedViewController_iPad" bundle:nil];
        
        [self.navigationController pushViewController:wantedVC animated:YES];
    }
    /////////////////// Monami
    else if([moduleName isEqualToString:@"Support Request"])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            SMSupportRequestViewController *stockAuditViewController;
            stockAuditViewController = [[SMSupportRequestViewController alloc]initWithNibName:@"SMSupportRequestViewController" bundle:nil];
            [self.navigationController pushViewController:stockAuditViewController animated:YES];
        }
        else
        {
            SMSupportRequestViewController *stockAuditViewController;
            stockAuditViewController = [[SMSupportRequestViewController alloc]initWithNibName:@"SMSupportRequestViewController~ipad" bundle:nil];
            [self.navigationController pushViewController:stockAuditViewController animated:YES];
            
        }
        
    }
    //////////////////////////End///////////////
}

-(NSMutableArray*)arrayPassedForSlideMenu:(NSString*)moduleName
{
    
    switch (selectedModule)
    {
        case home:
        {
            return [SMGlobalClass sharedInstance].arrayOfModules;
        }
            break;
            
        default:
        {
            
            NSPredicate *predicateBlog = [NSPredicate predicateWithFormat:@"moduleName == %@",moduleName];
            NSArray *arrayFiltered = [[SMGlobalClass sharedInstance].arrayOfModules filteredArrayUsingPredicate:predicateBlog];
            if ([arrayFiltered count] > 0)
            {
                SMGridModuleData *gridModuleData = (SMGridModuleData*)[arrayFiltered objectAtIndex:0];
                return gridModuleData.arrayOfPages;
            }
            
            
        }
            break;
            
            
    }
    return [[NSMutableArray alloc] init];
}

-(NSMutableArray*)arraySelected:(NSString*)moduleName
{
   
    
    switch (selectedModule)
    {
        case home:
            return [SMGlobalClass sharedInstance].filteredArrayForDashBoard;
            break;
        default:
        {
            NSPredicate *predicateBlog = [NSPredicate predicateWithFormat:@"moduleName == %@",moduleName];
            NSArray *arrayFiltered = [[SMGlobalClass sharedInstance].arrayOfModules filteredArrayUsingPredicate:predicateBlog];
            if ([arrayFiltered count] > 0)
            {
                SMGridModuleData *gridModuleData = (SMGridModuleData*)[arrayFiltered objectAtIndex:0];
                NSPredicate *predicatePages = [NSPredicate predicateWithFormat:@"isQuickLink == %d",NO];
                NSArray *arrayFilteredPages = [gridModuleData.arrayOfPages filteredArrayUsingPredicate:predicatePages];
                
                NSMutableArray *arrayModulePred = [[NSMutableArray alloc] initWithArray:arrayFilteredPages];
                
                
                float heigthCollectionView = self.collectionViewModuleList.bounds.size.height;
                
                int numberOfRows = 0;
                
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    numberOfRows = (int)heigthCollectionView/106.0;
                }
                else
                {
                    numberOfRows = (int)heigthCollectionView/110.0;
                }
                
                int expectedSections = numberOfRows*3;
                if ([arrayModulePred count] < expectedSections)
                {
                    int numberOfSectionsNeedToBeAdded = expectedSections-(int)[arrayModulePred count];
                    if (numberOfSectionsNeedToBeAdded > 0)
                    {
                        for (int i=0;i<numberOfSectionsNeedToBeAdded;i++)
                        {
                            SMGridModuleData *gridModuleObj = [[SMGridModuleData alloc] init];
                            gridModuleObj.moduleName = @"";
                            gridModuleObj.isQuickLink = NO;
                            gridModuleObj.isAlertPresent = NO;
                            [arrayModulePred addObject:gridModuleObj];
                        }
                    }
                }
                return arrayModulePred;
                
            }
            else
            {
                
                return [[NSMutableArray alloc] init];
            }
        }
            break;
    }
    return nil;
}




-(void)createTableView
{
    
   

    if([arrayDropDown count]==2)
    {
        heightForTheDropDown = 40*2;
        
        
    }
    else
    {
        heightForTheDropDown = 40*[arrayDropDown count];
        
    }
    
    
    if([[SMGlobalClass sharedInstance].arrayOfImpersonateClients count]>2)
    {
        heightForTheDropDown = 40*2;
        
        
    }
    else
    {
        heightForTheDropDown = 40*[[SMGlobalClass sharedInstance].arrayOfImpersonateClients count];
        
    }
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                         {
                             [self.tblViewDropDown setFrame:CGRectMake(52,0,self.tblViewDropDown.frame.size.width,40*[arrayDropDown count])];
                         }
                         else
                         {
                             [self.tblViewDropDown setFrame:CGRectMake(65,0,self.tblViewDropDown.frame.size.width,320.0)];
                         }
                     }
                     completion:^(BOOL finished){
                         // code to run when animation completes
                         // (in this case, another animation:)
                         [UIView animateWithDuration:1.0
                                          animations:^{
                                          }
                                          completion:^(BOOL finished){
                                          }];
                     }];
    
    
    self.tblSearchClients.tableFooterView = self.lblNoRecords;
    self.tblSearchClients.tableFooterView = nil;
    
    //    [self.viewForSearch setFrame:CGRectMake(50,30,self.viewForSearch.frame.size.width,self.viewForSearch.frame.size.height)];
    
    //[self.tblViewDropDown.layer setBorderColor:[UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0].CGColor];
    
    //self.tblViewDropDown.backgroundColor = [UIColor colorWithRed:33.0/255 green:34.0/255 blue:35.0/255 alpha:1.0];
    
    [self.tblViewDropDown.layer setBorderWidth:0.7];
    //self.tblViewDropDown.backgroundColor = [UIColor colorWithRed:33.0/255 green:34.0/255 blue:35.0/255 alpha:1.0];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    [self.viewBottomBar addGestureRecognizer:singleTap];
    //    [self.confirmationView addGestureRecognizer:singleTap];
    
    
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.tblViewDropDown removeFromSuperview];
    //    [self.confirmationView removeFromSuperview];
    
}


-(void)showTheDropdown
{
    
    filteredArray = [SMGlobalClass sharedInstance].arrayOfImpersonateClients;
    
    if(![self.tblViewDropDown isDescendantOfView:self.view])
    {
        //self.tblViewDropDown is not subview of self.view, add it.
        [self.confirmationView removeFromSuperview];
        [self.view addSubview:self.tblViewDropDown];
        
        NSString *strObjectIndex = @"";
        if ([arrayDropDown count] > 0)
        {
            strObjectIndex = [arrayDropDown objectAtIndex:0];
            if ([strObjectIndex isEqualToString:@"Change Profile Photo"])
            {
                strObjectIndex = @"Impersonate";
            }
        }
        
        [arrayDropDown removeAllObjects];
        
        
        if([SMGlobalClass sharedInstance].arrayOfImpersonateClients.count!=0)
        {
            [arrayDropDown addObject:strObjectIndex];
            [arrayDropDown addObject:@"Change Profile Photo"];// Change Required
            [arrayDropDown addObject:@"Logout"];
            
        }
        else
        {
            //////////////////Monami//////////////////////
            ////Add Impersonate option in dropdown everytime from arrayDropDown
            [arrayDropDown addObject:strObjectIndex];
            /////////////// END //////////////////////////
            [arrayDropDown addObject:@"Change Profile Photo"];
            [arrayDropDown addObject:@"Logout"]; // Change Required
            
            
        }
        
        [self createTableView];
        
        [self.tblViewDropDown reloadData];
        
    }
    else
    {
        //self.tblViewDropDown is subview of self.view, remove it.
        [self.tblViewDropDown removeFromSuperview];
    }
    
    
}
-(void)btnLogoLogoutDidClicked
{
    selectedModule = home;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTheSlideMenu" object:[self arrayPassedForSlideMenu:@""]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"InitialRefreshMainMenuName" object:@"Main Menu"];

//    [[NSNotificationCenter defaultCenter]postNotificationName:@"DisableTheBackLogoButton" object:nil];
    
    self.btnPost.selected = NO;
    self.btnHome.selected = YES;
    self.lblTitle.text = @"Smart Manager";
    
    
    [self.collectionViewModuleList reloadData];
    
}

-(void)btnLogoutDidClicked
{
    [self.tblViewDropDown removeFromSuperview];
    [arrayDropDown replaceObjectAtIndex:0 withObject:@"Impersonate"];

    NSLog(@"caught here for logout....");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure you want to logout?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    prefs = [NSUserDefaults standardUserDefaults];
    
    if(buttonIndex==1)
    {
        [prefs setValue:0   forKey:@"Member_ID"];
        [prefs setValue:@"" forKey:@"UserName"];
        [prefs setValue:@"" forKey:@"Password"];
        
        [self btnHomeDidClicked:self.btnHome];
        
        [prefs synchronize];
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            SMLoginViewController *loginViewController = [[SMLoginViewController alloc]initWithNibName:@"SMLoginViewController" bundle:nil];
            
            [self presentViewController:loginViewController animated:NO completion:NULL];
        }
        else
        {
            SMLoginViewController *loginViewController = [[SMLoginViewController alloc]initWithNibName:@"SMLoginViewController~ipad" bundle:nil];
            
            [self presentViewController:loginViewController animated:NO completion:NULL];
        }
    }
    
}

-(void)setTheLabelCountText:(int)lblCount
{
    
    SMModuleGridViewCell *cell = (SMModuleGridViewCell*)[self.collectionViewModuleList cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] ];
    
    if (lblCount<=0)
    {
        [cell.lblCount setText:@""];
    }
    else
    {
        [cell.lblCount setText:(lblCount>100000)?@"100 K+":[NSString stringWithFormat:@"%d",lblCount]];
    }
    [cell.lblCount sizeToFit];
    
    float widthWithPadding = cell.lblCount.frame.size.width + 15.0;
    
    [cell.lblCount setFrame:CGRectMake(self.view.frame.size.width - widthWithPadding - 12.0, cell.lblCount.frame.origin.y, widthWithPadding, cell.lblCount.frame.size.height)];
    
    
}

-(void)showHomeScreenOnClickingProfilePic
{
    isBackToHome = YES;
    [self btnHomeDidClicked:self.btnHome];
}

#pragma mark - custom delegate methods implementation

-(void)authenticationFailed
{
    
    NSLog(@"Error...");
    
    
    
    SMLoginViewController *loginViewController = [[SMLoginViewController alloc]initWithNibName:@"SMLoginViewController" bundle:nil];
    [self presentViewController:loginViewController animated:NO completion:NULL];
    
    
}

-(void)authenticationSucceeded
{
    dispatch_async(dispatch_get_main_queue(), ^{
    {
        
        NSLog(@"hash valueeeeeeeeeeee11111111 = %@",[SMGlobalClass sharedInstance].hashValue);
        
        if([[SMGlobalClass sharedInstance].hashValue length]!=0)
            
        {
            
            SMAppDelegate *appDelegateTemp = (SMAppDelegate*)[[UIApplication sharedApplication] delegate];
            NSString *imageUrl =[[SMGlobalClass sharedInstance].arrayOfMemberImages objectAtIndex:0];
            
            if([imageUrl length] >0)
            {
                // means 80
                    
                
                
                NSLog(@"imageURLL = %@",imageUrl);
                
                [appDeleage.gridNavigationController.headerViewController.btnLogout.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""] success:^(UIImage *image, BOOL cached)
                 {
                     [self saveImage:image :[NSString stringWithFormat:@"memberImage"]];
                     [appDeleage.gridNavigationController.headerViewController.btnLogout setClipsToBounds:YES];
                     
                     //appDeleage.gridNavigationController.headerViewController.btnLogout.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
                     //appDeleage.gridNavigationController.headerViewController.btnLogout.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                     appDeleage.gridNavigationController.headerViewController.btnLogout.imageView.contentMode = UIViewContentModeScaleAspectFill;
                     
                     [appDeleage.gridNavigationController.headerViewController.btnLogout.layer setCornerRadius:appDeleage.gridNavigationController.headerViewController.btnLogout.frame.size.width/2];
                     [appDeleage.gridNavigationController.headerViewController.btnLogout setImage:image forState:UIControlStateNormal];
                     
                 }
                                                                                                       failure:^(NSError *error)
                 {
                     NSLog(@"errorrr = %@",error);
                 }];
                
                
            }
            else
            {
            
                
                NSError *error = nil;
                
                [[NSFileManager defaultManager] removeItemAtPath: fullPathOftheImage error: &error];
                
                
                
                [appDeleage.gridNavigationController.headerViewController.btnLogout setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                
               
                [Fontclass AttributeStringMethodwithFontWithButton:appDeleage.gridNavigationController.headerViewController.btnLogout iconID:573];
                
                
            }
            
            
            
            //////////////////////////////////////////
            
            
            [SMGlobalClassForImpersonation sharedInstance].impersonateDelegate = self;
           
            
            if ([[SMGlobalClass sharedInstance].arrayOfImpersonateClients count]==0)
            {
                [[SMGlobalClassForImpersonation sharedInstance] parseTheImpersonateClients];
            }
            else
            {
                [self sendTheImpersonateClients:[SMGlobalClass sharedInstance].arrayOfImpersonateClients];
            }
            
            /////    END
            
        }
        
        
        
        if([SMGlobalClass sharedInstance].arrayOfClientImages.count > 0)
        {
            
            NSString *clientImgUrl = [[SMGlobalClass sharedInstance].arrayOfClientImages objectAtIndex:5];
            NSLog(@"clientImageURL = %@",clientImgUrl);
            
            self.imgClientImage.hidden = NO;
            [self.imgClientImage setImageWithURL:[NSURL URLWithString:clientImgUrl] placeholderImage:[UIImage imageNamed:@"leftbottomImage"] success:^(UIImage *image, BOOL cached)
             {
                 NSLog(@"Got In here");
                 [self saveImage:image :[NSString stringWithFormat:@"clientImage"]];
             }
                                         failure:^(NSError *error)
             {
                 NSLog(@"errorrr = %@",error);
             }];
            
        }
        else
        {
            
            NSError *error = nil;
            
            [[NSFileManager defaultManager] removeItemAtPath: fullPathOftheImage error: &error];
            
            //[self.imgClientImage setImage:nil];
            
            [self.imgClientImage setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"leftbottomImage"]];
            
        }
        
        
        NSLog(@"strrrrModuleName = %@",strModuleName);
        NSMutableArray *slideMenuArray = [self arrayPassedForSlideMenu:strModuleName];
        if(slideMenuArray.count != 0)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTheSlideMenu" object:[self arrayPassedForSlideMenu:strModuleName]];
        }
        else
        {
            slideMenuArray = [arrayOfSubModulePages mutableCopy];
            if(slideMenuArray.count > 0)
            {
            SMGridModuleData *slideMenuObj = (SMGridModuleData*)[slideMenuArray objectAtIndex:0];

            if(![slideMenuObj.moduleName isEqualToString:@"Home"])
            {
                SMGridModuleData *modulePageObj = [[SMGridModuleData alloc]init];
                modulePageObj.moduleName = @"Home";
                modulePageObj.isQuickLink = YES;
                [slideMenuArray insertObject:modulePageObj atIndex:0];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTheSlideMenu" object:slideMenuArray];
            }
            else
            {
                isBackToHome = YES;
                //selectedModule = 0;
                [self btnHomeDidClicked:self.btnHome];
            }
        }
        
        [self.collectionViewModuleList reloadData];
        
    }
    });
}

- (IBAction)lblHomeDidClicked:(id)sender
{
    
}
- (IBAction)btnHomeDidClicked:(id)sender
{
    // this one causes the go to the Home screen.
    
    NSLog(@"SelectedModule = %d",selectedModule);
    
    if(selectedModule != 0)
    {
        
        if(isBackToHome)
        {
            selectedModule = home;
            subModuleNumber = -1;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTheSlideMenu" object:[self arrayPassedForSlideMenu:@""]];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"InitialRefreshMainMenuName" object:@"Main Menu"];
            
            [self.confirmationView removeFromSuperview];
            [self.tblViewDropDown removeFromSuperview];
            
            self.lblTitle.text = @"Smart Manager";
           // self.lblHome.text = @"Home";
           // [Fontclass AttributeStringMethodwithFontWithButton:self.btnHome iconID:289];
            self.lblHome.text = @"";
            [self.btnHome setTitle:@"" forState:UIControlStateNormal];
           //[Fontclass AttributeStringMethodwithFontWithButton:self.btnHome iconID:0];
            
            self.btnPost.selected = NO;
            self.btnHome.selected = YES;
            
            [self.collectionViewModuleList reloadData];
            isBackToHome = NO;
        }
        else
        {
            selectedModule = others;
            subModuleNumber = -1;
            self.btnHome.hidden = NO;
            self.lblHome.text = @"Back";
            [Fontclass AttributeStringMethodwithFontWithButton:self.btnHome iconID:24];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTheSlideMenu" object:[self arrayPassedForSlideMenu:previousModuleName]];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"InitialRefreshMainMenuName" object:previousModuleName];
            
            [self.confirmationView removeFromSuperview];
            [self.tblViewDropDown removeFromSuperview];
            
            self.lblTitle.text = previousModuleName;
           // self.lblHome.text = @"Back";
           // [Fontclass AttributeStringMethodwithFontWithButton:self.btnHome iconID:24];
            
            isBackToHome = YES;
            [self.collectionViewModuleList reloadData];
            // selectedModule = home;
            
            
        }
        
    }
    
    
}

- (IBAction)btnSynopsisDidClicked:(id)sender
{
}

- (IBAction)btnPostDidClicked:(id)sender
{
    selectedModule = blogPost;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTheSlideMenu" object:[self arrayPassedForSlideMenu:@""]];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"EnableTheBackLogoButton" object:nil];
    
    [self.confirmationView removeFromSuperview];
    [self.tblViewDropDown removeFromSuperview];
    
    self.lblTitle.text = @"Social";
    self.btnPost.selected = YES;
    self.btnHome.selected = NO;
    
    [self.collectionViewModuleList reloadData];
    
    
    
}

- (IBAction)btnDCardDidClicked:(id)sender {
}

- (IBAction)btnContactDidClicked:(id)sender {
}
- (IBAction)btnGoDidClicked:(id)sender
{
    
    
}

- (IBAction)btnBackgroundDidClicked:(id)sender
{
    
    filteredArray = [SMGlobalClass sharedInstance].arrayOfImpersonateClients;
    
    [self.confirmationView removeFromSuperview];
    
}
-(void)reloadTheQuickLinkData:(NSNotification *) notification
{
    moduleObjFromSlideMenu = [notification object];
    if([moduleObjFromSlideMenu.moduleName isEqualToString:@"Home"])
    {
        
        [self btnHomeDidClicked:self.btnHome];
        [self.collectionViewModuleList reloadData];
    }
    else
    {
        if (selectedModule == home)
        {
            strModuleName = moduleObjFromSlideMenu.moduleName;
            selectedModule = others;
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTheSlideMenu" object:[self arrayPassedForSlideMenu:strModuleName]];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"EnableTheBackLogoButton" object:nil];
            
            [self.confirmationView removeFromSuperview];
            [self.tblViewDropDown removeFromSuperview];
            
            self.lblTitle.text = strModuleName;
            self.btnPost.selected = YES;
            self.btnHome.selected = NO;
            isThirdLevelGridNeedToBeDisplayedFromSideMenu = YES;
            [self.collectionViewModuleList reloadData];
        }
        else if(selectedModule == others && isThirdLevelGridNeedToBeDisplayedFromSideMenu)
        {
            subModuleNumber = moduleObjFromSlideMenu.arrayOfPages.count;
            strModuleName = moduleObjFromSlideMenu.moduleName;
            selectedModule = others;
            arrayOfSubModulePages = [[NSMutableArray alloc]init];
            arrayOfSubModulePages = moduleObjFromSlideMenu.arrayOfPages;
            
            NSMutableArray *slideMenuArray;
            SMGridModuleData *slideMenuObj;
            
            if(arrayOfSubModulePages.count > 0)
            {
                slideMenuArray = [arrayOfSubModulePages mutableCopy];
                slideMenuObj = (SMGridModuleData*)[slideMenuArray objectAtIndex:0];
            }
            else
            {
                 [self openGridScreens:moduleObjFromSlideMenu.moduleName];
                return;
            }
            
            if(![slideMenuObj.moduleName isEqualToString:@"Home"])
            {
                SMGridModuleData *modulePageObj = [[SMGridModuleData alloc]init];
                modulePageObj.moduleName = @"Home";
                modulePageObj.isQuickLink = YES;
                [slideMenuArray insertObject:modulePageObj atIndex:0];
                isBackToHome = NO;
                isThirdLevelGridNeedToBeDisplayedFromSideMenu  =NO;
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshTheSlideMenu" object:slideMenuArray];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"InitialRefreshMainMenuName" object:strModuleName];
            
            [self.collectionViewModuleList reloadData];
            self.lblTitle.text = strModuleName;
            
        }
        else
        {
            
            [self openGridScreens:moduleObjFromSlideMenu.moduleName];
        }
    }
    
}

#pragma mark -  Tutorials Method

- (void)saveeImage:(UIImage*)image :(NSString*)imageName
{
    if (documentsDirectory == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        documentsDirectory = [paths objectAtIndex:0];
    }
    
    
    
    imageData = UIImageJPEGRepresentation(image,0.6); //convert image into .jpg format.
    
    fullPathOftheImage = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageName]];
    
    [imageData writeToFile:fullPathOftheImage atomically:NO];
    
    
    imageData = nil;
    
}


- (void)saveImage:(UIImage*)image :(NSString*)imageName
{
    
    if (documentsDirectory == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        documentsDirectory = [paths objectAtIndex:0];
    }
    
    
    
    // imageData = UIImageJPEGRepresentation(image,0.6); //convert image into .jpg format.
    
    imageData = UIImagePNGRepresentation(image);
    
    fullPathOftheImage = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    
    NSLog(@"saved imge path = %@",fullPathOftheImage);
    [imageData writeToFile:fullPathOftheImage atomically:NO];
    
    
    
    imageData = nil;
    
    NSLog(@"image saved");
    
}

-(IBAction)tapGestuteForRemovingImpersonationListing:(id)sender
{
    [UIView transitionWithView:self.confirmationView duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ { [self.confirmationView removeFromSuperview]; }
                    completion:nil];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
     CGPoint touchPoint = [touch locationInView:self.confirmationView];
     return !CGRectContainsPoint(self.viewForSearch.frame, touchPoint);
    
}

#pragma - mark Selecting Image from Camera and Library

- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __block UIImagePickerController *picker2 = picker1;
    
    // Picking Image from Camera/ Library
    [picker2 dismissViewControllerAnimated:NO completion:^{
        picker2.delegate=nil;
        picker2 = nil;
    }];
    
    
    selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    
    
    if (picker1.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        [SMGlobalClass sharedInstance].isFromCamera = YES;
    }
    
    
    if (!selectedImage)
    {
        return;
    }
    
    
    if (selectedImage.imageOrientation == UIImageOrientationUp)
    {
        
    }
    else if (selectedImage.imageOrientation == UIImageOrientationLeft || selectedImage.imageOrientation == UIImageOrientationRight)
    {
        selectedImage = [self scaleAndRotateImage:selectedImage];
    }
    
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"ddHHmmssSSS"];
    
    NSString *dateString=[formatter stringFromDate:[NSDate date]];
    
    NSString *imgName =[NSString stringWithFormat:@"%@_asset",dateString];
    
    [self saveeImage:selectedImage :imgName];
    
    [self.multipleImagePicker addOriginalImages:imgName];
    
    
    BOOL isViewControllerPresent = NO;
    
    for (UINavigationController *view in self.navigationController.viewControllers)
    {
        //when found, do the same thing to find the MasterViewController under the nav controller
        if ([view isKindOfClass:[RPMultipleImagePickerViewController class]])
        {
            isViewControllerPresent = YES;
            
            
        }
        
        
    }
    
    
    if(!isViewControllerPresent)
    {
        self.multipleImagePicker.isFromStockAuditScreen = NO;
        self.multipleImagePicker.isFromGridView = YES;
        [self.navigationController pushViewController:self.multipleImagePicker animated:YES];
    }
    
    
    // Done callback
    self.multipleImagePicker.doneCallback = ^(NSArray *images)
    {
        SMClassOfBlogImages *imageObject;
        if(arrayOfImages.count>0){
            [arrayOfImages removeAllObjects];
        }
        strForProfileImage = @"";
        for(int i=0;i< images.count;i++)
        {
            
            imageObject = [[SMClassOfBlogImages alloc]init];
            imageObject.imageSelected=[images objectAtIndex:i];
            imageObject.isImageFromLocal = YES;
            //imageObject.imagePriorityIndex=imgCount;
            imageObject.imageLink = [self loadImagePath:[images objectAtIndex:i]];
            imageObject.imageOriginIndex = -2;
            imageObject.isImageFromCamera = YES;
            imageObject.thumbImagePath = fullPathOftheImage;
            
            [arrayOfImages addObject:imageObject];
            
            selectedImage = nil;
            
        }
        
        ////////////////////////////Monami///////////////////////////////////////////
        
        //////////////////////////API Call For Update Profile Image Method Call
        
        strForProfileImage = imageObject.imageSelected;
        
        UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imageObject.imageSelected];
        NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
        
        strBase64 = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
  
        
        [self updateProfileImageApiCall:imageObject.imageSelected andBase64:strBase64];
        
        //////////////////////////////////   END    ///////////////////////////////////////
        
//
//            
//            [self.multipleImagePicker.Originalimages removeAllObjects];
//            
//            NSString *str = [NSString stringWithFormat:@"%@.jpg", imageObject.imageSelected];
//            
//            NSString *fullImgName=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
//            
//            [appDeleage.gridNavigationController.headerViewController.btnLogout setImage:[UIImage imageWithContentsOfFile:fullImgName] forState:UIControlStateNormal];
//            
//            
//            
//        });
        
        
        
    };
    
    [self dismissImagePickerControllerForCancel:NO];
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1
{
    if([SMGlobalClass sharedInstance].isFromCamera)
        [SMGlobalClass sharedInstance].photoExistingCount--;
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
}



#pragma mark - Multiple Image selection and Image Editing


#pragma mark - MULTIPLE IMAGE SELECTION

- (void)dismissImagePickerControllerForCancel:(BOOL)cancelled
{
    if (self.presentedViewController)
    {
        
        
        [self dismissViewControllerAnimated:NO completion:
         ^{
             if(!cancelled)
             {
                 
                 RPMultipleImagePickerViewController *selectType;
                 BOOL isViewControllerPresent = NO;
                 for (UINavigationController *view in self.navigationController.viewControllers)
                 {
                     //when found, do the same thing to find the MasterViewController under the nav controller
                     if ([view isKindOfClass:[RPMultipleImagePickerViewController class]])
                     {
                         isViewControllerPresent = YES;
                         selectType = (RPMultipleImagePickerViewController*)view;
                         self.multipleImagePicker = (RPMultipleImagePickerViewController*)view;
                         [self.navigationController popToViewController:selectType animated:YES];
                         
                         
                     }
                     
                     
                 }
                 
                 if(!isViewControllerPresent)
                 {
                     self.multipleImagePicker.isFromStockAuditScreen = NO;
                     self.multipleImagePicker.isFromGridView = YES;
                     [self.navigationController pushViewController:self.multipleImagePicker animated:YES];
                 }
                 
                 
                 
                 
             }
             
             
         }];
    }
    else
    {
        [self.navigationController popToViewController:self animated:YES];
    }
}

-(void)sendTheUpdatedImageArray:(NSMutableArray*)updatedArray
{
    arrayOfImages = updatedArray;
}


#pragma mark - QBImagePickerControllerDelegate


-(void)callPhotoUploadForUserImage
{
    
        if(imagePickerController == nil)
            imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = NO;
    
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];

}

-(void)callToSelectImagesFromCameraWithRemainingCount:(int)remainingCount andFromEditScreen:(BOOL)isFromEditScreen
{
    
    
    
    if(remainingCount>0)
    {
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            [picker setAllowsEditing:NO];
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:^{}];
        }
        else
        {
            
            SMAlert(@"Error",KCameraNotAvailable);
            return;
        }
    }
    
}


- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    [self dismissImagePickerControllerForCancel:NO];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    [self.multipleImagePicker.Originalimages removeAllObjects];// caught here
    
    
    assetsArray = [NSArray arrayWithArray:assets];
    
    
    for(ALAsset *asset in assets)
    {
        @autoreleasepool {
        UIImage *img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        UIImage *imgThumbnail = [UIImage imageWithCGImage:[asset thumbnail]];
        
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"ddHHmmssSSS"];
        
        NSString *dateString=[formatter stringFromDate:[NSDate date]];
        
        NSString *imgName =[NSString stringWithFormat:@"%@_asset",dateString];
        
        [self saveeImage:img :imgName];
        
        [self.multipleImagePicker addOriginalImages:imgName];
        };
    }
    
    NSPredicate *predicateServerImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];// from server
    NSArray *arrayServerFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateServerImages];
    
    NSPredicate *predicateCameraImages = [NSPredicate predicateWithFormat:@"isImageFromCamera == %d",YES];// from server
    NSArray *arrayCameraFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateCameraImages];
    
    NSArray *finalFilteredArray = [arrayServerFiltered arrayByAddingObjectsFromArray:arrayCameraFiltered];
    
    if ([finalFilteredArray count] > 0)
    {
        [arrayOfImages removeAllObjects];
        arrayOfImages = [NSMutableArray arrayWithArray:finalFilteredArray];
    }
    else
        [arrayOfImages removeAllObjects]; // check here.
    
    __weak typeof(self) weakSelf = self;
    // Done callback
    self.multipleImagePicker.doneCallback = ^(NSArray *images)
    {
        
        SMClassOfBlogImages *imageObject;
        strForProfileImage = @"";
        for(int i=0;i< images.count;i++)
        {
            
            imageObject = [[SMClassOfBlogImages alloc]init];
            
            imageObject.imageSelected=[images objectAtIndex:i];
            
            imageObject.isImageFromLocal = YES;
            // imageObject.imagePriorityIndex=imgCount;
            imageObject.imageLink = [weakSelf loadImagePath:[images objectAtIndex:i]];
            imageObject.imageOriginIndex = i;
            imageObject.isImageFromCamera = NO;
           // imageObject.thumbImagePath = fullPathOftheImage;
            
            [arrayOfImages addObject:imageObject];
            
            selectedImage = nil;
            
            
        }
        
        
        ////////////////////////////Monami///////////////////////////////////////////
        
        //////////////////////////API Call For Update Profile Image Method Call
        
        strForProfileImage = imageObject.imageSelected;
        
        UIImage *imageToUpload = [[SMCommonClassMethods shareCommonClassManager]getImageFromPathImage:imageObject.imageSelected];
        NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
        
        strBase64 = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
        
        
        [self updateProfileImageApiCall:imageObject.imageLink andBase64:strBase64];
        
        /////////////////////////////////////  END   ////////////////////////////////////////
        
        
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self.multipleImagePicker.Originalimages removeAllObjects];
//            
//            NSString *str = [NSString stringWithFormat:@"%@.jpg", imageObject.imageSelected];
//            
//            NSString *fullImgName=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
//            
//            [appDeleage.gridNavigationController.headerViewController.btnLogout setImage:[UIImage imageWithContentsOfFile:fullImgName] forState:UIControlStateNormal];
//            
//            
//        });
        
        
        
    };
    
    [self dismissImagePickerControllerForCancel:NO];
    
    
}

- (void)imagePickerControllerDidCancelled:(QBImagePickerController *)imagePickerController
{
    
    [self dismissImagePickerControllerForCancel:YES];
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image  {
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat boundHeight;
    
    boundHeight = bounds.size.height;
    bounds.size.height = bounds.size.width;
    bounds.size.width = boundHeight;
    transform = CGAffineTransformMakeScale(-1.0, 1.0);
    transform = CGAffineTransformRotate(transform, M_PI / 2.0); //use angle/360 *MPI
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
    
}

- (NSString*)loadImagePath:(NSString*)imageName1 {
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    
    return [NSString stringWithFormat:@"%@.jpg",fullPathOfImage];
    
}

-(void)dismissTheLoader
{
    [imagePickerController dismissTheLoaderAction];
    
    
}

-(void)delegateFunctionForDeselectingTheSelectedPhotos
{
    [imagePickerController deSelectAllTheSelectedPhotosWhenCancelAction];
    
}

-(void)delegateFunctionWithOriginIndex:(int)originIndex
{
    if(![SMGlobalClass sharedInstance].isFromCamera)
        [imagePickerController deleteTheImageFromTheFirstLibraryWithIndex:originIndex];
    
}

-(void)delegateFunction:(UIImage*)imageToBeDeleted
{
    [imagePickerController deleteTheImageFromTheFirstLibrary:imageToBeDeleted];
}

#pragma mark webservice integration

//////////////////////////////////////Monami////////////////////////

// API CALL FOR GET PROFILE IMAGE //////////////////////////////////

-(void)GetProfileImage {
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
     HUD.labelText = KLoaderText;
    
    NSMutableURLRequest * requestURL = [SMWebServices GetProfileImage:[SMGlobalClass sharedInstance].hashValue];
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



-(void)updateProfileImageApiCall:(NSString *)imageFileName andBase64:(NSString *) Base64Str{
    
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    NSMutableURLRequest * requestURL = [SMWebServices UpdateProfileImageWith:[SMGlobalClass sharedInstance].hashValue andimageFilename:imageFileName andbase64EncodedString:Base64Str];
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
//////////////////////////////////////  END   ///////////////////////////////////////////////////

/////////////////////Monami XML Parser Delegate//////////////////////////

#pragma mark - NSXMLParser Delegate Methods

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"Update"])
    {
        if([currentNodeContent isEqualToString:@"Succeeded"])
        {
            
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.multipleImagePicker.Originalimages removeAllObjects];
                    
                    ///////////////////Monami////////////////////////////////////////
                    ////////////////////Set The Image which is uploaded//////////////////////
                    
                    NSString *str = [NSString stringWithFormat:@"%@.jpg", strForProfileImage];
                    NSLog(@"IMAGE %@",str);
                    NSString *fullImgName=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
                    
                    [appDeleage.gridNavigationController.headerViewController.btnLogout setClipsToBounds:YES];
                    //[appDelegate.gridNavigationController.headerViewController.btnLogout.imageView setContentMode:UIViewContentModeScaleAspectFill];
                    
                    [appDeleage.gridNavigationController.headerViewController.btnLogout.layer setCornerRadius:appDeleage.gridNavigationController.headerViewController.btnLogout.frame.size.width/2];
                    [appDeleage.gridNavigationController.headerViewController.btnLogout setImage:[UIImage imageWithContentsOfFile:fullImgName] forState:UIControlStateNormal];
                    
                    strForProfileImage = @"";
                    
                    
                });
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Image uploaded successfully." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:@"Failed to upload image. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else if ([elementName isEqualToString:@"Image"])
    {
        strImgName = @"";
        if(![currentNodeContent isEqualToString:@""]){
            strImgName = currentNodeContent;
            

            
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            sleep(2);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //////////////Set the image coming from Get profile Image API ///////////////
                
                [appDeleage.gridNavigationController.headerViewController.btnLogout.imageView setImageWithURL:[NSURL URLWithString:strImgName] placeholderImage:[UIImage imageNamed:@""] success:^(UIImage *image, BOOL cached)
                 {
                     [appDeleage.gridNavigationController.headerViewController.btnLogout setClipsToBounds:YES];
                     //[appDelegate.gridNavigationController.headerViewController.btnLogout.imageView setContentMode:UIViewContentModeScaleAspectFill];
                     
                     [appDeleage.gridNavigationController.headerViewController.btnLogout.layer setCornerRadius:appDeleage.gridNavigationController.headerViewController.btnLogout.frame.size.width/2];
                    [appDeleage.gridNavigationController.headerViewController.btnLogout setImage:image forState:UIControlStateNormal];
                     //appDeleage.gridNavigationController.headerViewController.btnLogout.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
                     //appDeleage.gridNavigationController.headerViewController.btnLogout.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                     appDeleage.gridNavigationController.headerViewController.btnLogout.imageView.contentMode = UIViewContentModeScaleAspectFill;
                     
                     [SMGlobalClass sharedInstance].isFromEbrochure = NO;
                     
                 }
                                                                                                      failure:^(NSError *error)
                 {
                     NSLog(@"errorrr = %@",error);
                 }];
                
               // [appDeleage.gridNavigationController.headerViewController.btnLogout.imageView setImageWithURL:[NSURL URLWithString:strImgName] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageProgressiveDownload];
            });
        }
        
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //SMClassOfBlogImages *imageObject;
    //imageObject = [[SMClassOfBlogImages alloc]init];
    dispatch_async(dispatch_get_main_queue(), ^{
       [self hideProgressHUD];
      });
    
    
}

////////////////////////////////  END ////////////////////////////////////////


@end
