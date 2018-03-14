//
//  SMSearchBlogViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 30/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSearchBlogViewController.h"
#import "SMCustomTextField.h"
#import "SMSearchBlogObject.h"
#import "SMSearchBlogGalleryImageCell.h"
#import "SMEditSearchObject.h"
#import "SMClassOfBlogImages.h"
#import "MBProgressHUD.h"
#import "SMCreateBlogViewController.h"
#import "SMCalenderTextField.h"

@interface SMSearchBlogViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,UIScrollViewDelegate,SMSearchBlogGalleryDelegate,UIAlertViewDelegate,MBProgressHUDDelegate,searchBlogDelegate>
{
    float heightForTheDropDown;
    NSMutableArray *arrayToSearch;
    NSMutableArray *arrayOfSearchResult;
    NSMutableArray *arrayOfEditImages;
    
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    int selectedIndexForEditBlog;
    int blogPostIdForEdit;
    
    BOOL isFlagSearchListing;
    BOOL isFetchingInProgress;
    BOOL isPostsFound;
    
    int startIndexForSearching;
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UITableView *tblViewSearchBlog;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (strong, nonatomic) IBOutlet SMCalenderTextField *txtFieldSearch;
@property (strong, nonatomic) IBOutlet SMCalenderTextField *txtFieldStartDate;
@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldEndDate;
@property (strong, nonatomic) IBOutlet UISwitch *btnSwitch;
@property (strong, nonatomic) IBOutlet UIButton *btnNewPost;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UITableView *tblViewDropDown;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *btnEnd;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UILabel *lblPagesFound;
@property (strong, nonatomic) IBOutlet UILabel *lblSwipe;
@property (strong, nonatomic) IBOutlet UIButton *btnActiveInactivePosts;
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (strong, nonatomic) SMSearchBlogObject *searchBlogObject;
@property (strong, nonatomic) SMEditSearchObject *editObject;
@property (strong, nonatomic) SMClassOfBlogImages *editImageObject;

- (IBAction)btnNewPostDidClicked:(id)sender;

- (IBAction)btnActiveInactivePostsDidClicked:(id)sender;


- (IBAction)btnSearchDidClicked:(id)sender;

- (IBAction)btnDoneOfDatePickerDidClicked:(id)sender;

- (IBAction)btnCancelOfDatePickerDidClicked:(id)sender;

- (IBAction)btnClearOfDatePickerDidClicked:(id)sender;


- (IBAction)btnEndDidClicked:(id)sender;

- (IBAction)btnEditDidClicked:(id)sender;


@end
