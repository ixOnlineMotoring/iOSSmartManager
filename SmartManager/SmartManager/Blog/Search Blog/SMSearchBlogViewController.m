//
//  SMSearchBlogViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 30/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMSearchBlogViewController.h"
#import "SMCreateBlogViewController.h"
#import "SMSearchBlogGalleryImageCell.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMCustomColor.h"

const int Page_Size = 12;

@interface SMSearchBlogViewController ()

@end

@implementation SMSearchBlogViewController

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
    
    [self addingProgressHUD];

    self.navigationItem.titleView = [SMCustomColor setTitle:@"Blog Post"];
    
    arrayOfSearchResult = [[NSMutableArray alloc]init];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 29, 30)];
    view1.backgroundColor = [UIColor redColor];
    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    imgView1.image = [UIImage imageNamed:@"calicons"];
    [view1 addSubview:imgView1];
    
    self.txtFieldStartDate.leftViewMode = UITextFieldViewModeAlways;
    self.txtFieldStartDate.leftView = view1;
    
    
    
    //self.txtFieldStartDate.leftView = view1;
    //self.txtFieldEndDate.rightView  =view1;

    self.dateView.layer.cornerRadius=15.0;
    self.dateView.clipsToBounds      = YES;
    self.dateView.layer.borderWidth=0.8;
    self.dateView.layer.borderColor=[[UIColor blackColor] CGColor];
    
    self.btnNewPost.layer.cornerRadius = 4.0;
    self.btnSearch.layer.cornerRadius = 4.0;
    self.btnEnd.layer.cornerRadius = 7.0;
    self.btnEdit.layer.cornerRadius = 7.0;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        //[self.btnNewPost.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14.0]];
        //[self.btnSearch.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14.0]];
        [self.btnEnd.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14.0]];
        [self.btnEdit.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14.0]];

        self.lblPagesFound.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        
        [self.tblViewSearchBlog registerNib:[UINib nibWithNibName:@"SMSearchBlogGalleryImageCell" bundle:nil] forCellReuseIdentifier:@"SMSearchBlogGalleryImageCell"];
    }
    else
    {
       // [self.btnNewPost.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:25.0]];
       // [self.btnSearch.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:25.0]];
        [self.btnEnd.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:25.0]];
        [self.btnEdit.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:25.0]];

        self.lblPagesFound.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        
        [self.tblViewSearchBlog registerNib:[UINib nibWithNibName:@"SMSearchBlogGalleryImageCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMSearchBlogGalleryImageCell"];
    }
    
    self.tblViewSearchBlog.tableHeaderView = self.viewHeader;
    self.tblViewSearchBlog.tableFooterView =self.viewFooter;
    
    // Method calls
    
    [self createTableViewForSearch];
    
    // array allocations
    
    arrayToSearch = [[NSMutableArray alloc]init];
    startIndexForSearching  = 0;
    isFetchingInProgress    = NO;
    isFlagSearchListing     = NO;
    isPostsFound            = NO;
    NSLog(@"11111111111");
    
    //Tableview cell regitration
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTheNextDataForSearchListing) name:@"LoadTheNextSrarchListingBlogs" object:nil];
    
    // Hide / Unhide views
    
    self.viewFooter.hidden = YES;
    self.lblPagesFound.hidden = YES;
    self.lblSwipe.hidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tblViewSearchBlog.scrollEnabled = NO;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
   
    
}

- (void)updateBlogList
{
    if([arrayOfSearchResult count]>0)
    {
        [self btnSearchDidClicked:nil];
    }
}

#pragma mark - TextField delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    self.tblViewSearchBlog.scrollEnabled = YES;
    
    if(textField == self.txtFieldStartDate || textField == self.txtFieldEndDate )
    {
        [self.view endEditing:YES];
        
        if(textField == self.txtFieldStartDate )
        {
           /* self.tblViewSearchBlog.scrollEnabled = NO;
            if([self.dateView isDescendantOfView:self.view])
            {
                //self.tblViewDropDown is not subview of self.view, add it.
                [self.dateView removeFromSuperview];
            }
            
            self.dateView.hidden=NO;
            
            [self.dateView setFrame:CGRectMake(0.0, self.view.bounds.size.height/2, self.dateView.frame.size.width, self.dateView.frame.size.height)];
            
           
            
           
            //self.datePicker.minimumDate = [NSDate date];
            
            [self.view addSubview:self.dateView];
            [self.view endEditing:YES];*/
            
            
                  self.datePicker.tag = 1;
                [self loadPopup];
           
            
            
            
        }
       
        
        if(textField == self.txtFieldEndDate )
        {
           /* self.tblViewSearchBlog.scrollEnabled = NO;
            if([self.dateView isDescendantOfView:self.view])
            {
                //self.tblViewDropDown is not subview of self.view, add it.
                [self.dateView removeFromSuperview];
            }
            
            
            self.dateView.hidden=NO;
            
            [self.dateView setFrame:CGRectMake(0.0, self.view.bounds.size.height/2, self.dateView.frame.size.width, self.dateView.frame.size.height)];
            
            
           
            
            
            
            [self.view addSubview:self.dateView];
            [self.view endEditing:YES];*/
            
             self.datePicker.tag = 2;
            [self loadPopup];
            
            
        }
        
        return NO;
        
    }
    return  YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   /* if(textField == self.txtFieldSearch)
    {
        [self showTheDropdown];
    
    }
    */
    
    
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




#pragma  mark - TableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([arrayOfSearchResult count]>0)
    {
        self.viewFooter.hidden = NO;
        self.lblPagesFound.hidden = NO;
        self.lblSwipe.hidden = NO;
    }
    else
    {
        self.viewFooter.hidden = YES;
        self.lblSwipe.hidden = YES;
        self.lblPagesFound.text = @"No posts found";
    }
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        return 191.0;
    }
    else
    {
        return 223.0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier= @"SMSearchBlogGalleryImageCell";
    
    SMSearchBlogGalleryImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
   
    cell.arrOfSearchResultObjects = arrayOfSearchResult;
    [cell.tblViewSlider reloadData];
    
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self btnEditDidClicked:self.btnEdit];

}

#pragma mark - IBActions

- (IBAction)btnNewPostDidClicked:(id)sender
{
    SMCreateBlogViewController *createBlogViewController;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        createBlogViewController = [[SMCreateBlogViewController alloc]initWithNibName:@"SMCreateBlogViewController" bundle:nil];
    }
    else
    {
        createBlogViewController = [[SMCreateBlogViewController alloc]initWithNibName:@"SMCreateBlogViewController_iPad" bundle:nil];
    }
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil]];
    
    [self.navigationController pushViewController:createBlogViewController animated:YES];
}

- (IBAction)btnActiveInactivePostsDidClicked:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

- (IBAction)btnSearchDidClicked:(id)sender
{
    self.tblViewSearchBlog.scrollEnabled = NO;
    
    isFetchingInProgress        = NO;
    selectedIndexForEditBlog    = 0;
    startIndexForSearching      = 0;
    
    [self.view endEditing:YES];
    [arrayOfSearchResult removeAllObjects];
    [self.tblViewSearchBlog reloadData];
    
    if(self.btnActiveInactivePosts.selected)
    {
        [self searchForTheInactiveBlogsFromServer];
    }
    else
    {
        [self searchForTheActiveBlogsFromServer];
    }
}

- (IBAction)btnDoneOfDatePickerDidClicked:(id)sender
{
    [self dismissPopup];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:self.datePicker.date]];
    if(self.datePicker.tag==1)
    {
        
        [self.txtFieldStartDate setText:textDate];
    }
    else
    {
        [self.txtFieldEndDate setText:textDate];
    }

}

- (IBAction)btnCancelOfDatePickerDidClicked:(id)sender
{
    [self dismissPopup];
    
}

- (IBAction)btnClearOfDatePickerDidClicked:(id)sender
{
    if(self.datePicker.tag == 1)
    {
        self.txtFieldStartDate.text = @"";
        [self.dateView removeFromSuperview];
    }
    
    else
    {
        self.txtFieldEndDate.text = @"";
        [self.dateView removeFromSuperview];
    }
    
    self.tblViewSearchBlog.scrollEnabled = YES;
    
}

- (IBAction)btnEndDidClicked:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:KblogEndAlert message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 201;
    [alert show];
}

- (IBAction)btnEditDidClicked:(id)sender
{
    
    
    /*SMSearchBlogGalleryImageCell *selectedCell = (SMSearchBlogGalleryImageCell*)[self.tblViewSearchBlog cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    selectedCell.tblViewSlider.scrollEnabled = NO;

 [self performSelector:@selector(enableTheTableViewScroll) withObject:nil afterDelay:3.0];
    
    NSLog(@"arrayCount = %lu",(unsigned long)arrayOfSearchResult.count);
    
    SMSearchBlogObject *searchedBlogObject = (SMSearchBlogObject*)[arrayOfSearchResult objectAtIndex:selectedIndexForEditBlog];
    NSLog(@"selectedIndex = %d",selectedIndexForEditBlog);
    NSLog(@"blogPostTypeID = %d",searchedBlogObject.blogPostTypeID);
    
    blogPostIdForEdit = searchedBlogObject.blogPostTypeID;
     [self getTheBlogForEditingWithPostID:searchedBlogObject.blogPostTypeID];*/
    
//
    
    SMSearchBlogObject *searchedBlogObject = (SMSearchBlogObject*)[arrayOfSearchResult objectAtIndex:selectedIndexForEditBlog];
    
    
    SMCreateBlogViewController *createBlogViewController;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        createBlogViewController = [[SMCreateBlogViewController alloc]initWithNibName:@"SMCreateBlogViewController" bundle:nil];
    }
    else
    {
        createBlogViewController = [[SMCreateBlogViewController alloc]initWithNibName:@"SMCreateBlogViewController_iPad" bundle:nil];
    }
    createBlogViewController.selectedBlogPostTypeID = searchedBlogObject.blogPostTypeID;
     createBlogViewController.isBlogEdited = YES;
      createBlogViewController.blogDelegate = self;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil]];
    [self.navigationController pushViewController:createBlogViewController animated:YES];
    
    
    
    
}



#pragma mark - Custom methods

-(void)enableTheTableViewScroll
{
    SMSearchBlogGalleryImageCell *selectedCell = (SMSearchBlogGalleryImageCell*)[self.tblViewSearchBlog cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    selectedCell.tblViewSlider.scrollEnabled = YES;

}


-(void)showTheDropdown
{
    if(![self.tblViewDropDown isDescendantOfView:self.view])
    {
        //self.tblViewDropDown is not subview of self.view, add it.
       
        // test comment
        
        [self.view addSubview:self.tblViewDropDown];
        [self.tblViewDropDown reloadData];
        
    }
    else
    {
        //self.tblViewDropDown is subview of self.view, remove it.
        [self.tblViewDropDown removeFromSuperview];
    }
    
    
}


-(void)createTableViewForSearch
{
       
    
    if([arrayToSearch count]>=3)
    {
        heightForTheDropDown = 40*3;
        
        
    }
    else
    {
        heightForTheDropDown = 40*[arrayToSearch count];
        
    }
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         [self.tblViewDropDown setFrame:CGRectMake(self.txtFieldSearch.frame.origin.x,self.txtFieldSearch.frame.origin.y+self.txtFieldSearch.frame.size.height+4,self.txtFieldSearch.frame.size.width,120.0)];
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
    
    
    
    [self.tblViewDropDown.layer setBorderColor:[UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0].CGColor];
    
    //self.tblViewDropDown.backgroundColor = [UIColor colorWithRed:33.0/255 green:34.0/255 blue:35.0/255 alpha:1.0];
    
    [self.tblViewDropDown.layer setBorderWidth:0.7];
    self.tblViewDropDown.backgroundColor = [UIColor colorWithRed:33.0/255 green:34.0/255 blue:35.0/255 alpha:1.0];
}

- (void)passTheIndexOfSelectedCell:(int)index
{
    selectedIndexForEditBlog = index;
}

-(void)loadTheNextDataForSearchListing
{
    [self.view endEditing:YES];
    
    if(self.btnActiveInactivePosts.selected)
    {
        [self searchForTheInactiveBlogsFromServer];
    }
    else
    {
        [self searchForTheActiveBlogsFromServer];
    }
}

#pragma mark - AlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==201)
    {
        if(buttonIndex==1)
        {
            SMSearchBlogObject *searchedBlogObject = (SMSearchBlogObject*)[arrayOfSearchResult objectAtIndex:selectedIndexForEditBlog];
            [self endTheBlogWithBlogPostId:searchedBlogObject.blogPostTypeID];
        }
       
    }
    if(alertView.tag==501)
    {
        [self btnSearchDidClicked:nil];
    
    }
}
#pragma mark - Web service implementation


-(void)searchForTheActiveBlogsFromServer
{
    

    if(isFetchingInProgress)
        return;
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    isFetchingInProgress = YES;
    
    /*NSMutableURLRequest *requestURL=[SMWebServices searchForTheActiveBlogWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andSearchText:self.txtFieldSearch.text andStartDate:self.txtFieldStartDate.text andEndDate:self.txtFieldEndDate.text andStartIndex:startIndexForSearching andPageSize:0];*/
    
    NSMutableURLRequest *requestURL=[SMWebServices searchForTheActiveBlogWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andSearchText:self.txtFieldSearch.text andStartDate:self.txtFieldStartDate.text andEndDate:self.txtFieldEndDate.text andStartIndex:0 andPageSize:0];
    
    
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         [self hideProgressHUD];
         
         if (error!=nil)
         {
             
             SMAlert(@"", @"No Records Found");
             [HUD hide:YES];
           
         }
         else
         {
             
             startIndexForSearching+=Page_Size;
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
         }
    
     }];
}

-(void)searchForTheInactiveBlogsFromServer
{
   

    if(isFetchingInProgress)
        return;
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    
    isFetchingInProgress = YES;
    
    NSMutableURLRequest *requestURL=[SMWebServices searchForTheInactiveBlogWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andSearchText:self.txtFieldSearch.text andStartDate:self.txtFieldStartDate.text andEndDate:self.txtFieldEndDate.text andStartIndex:startIndexForSearching];
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         [self hideProgressHUD];

         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             //NSLog(@"Data//////////=%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
             
             
             //NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[data length]);
             
             startIndexForSearching+=Page_Size;
             
             
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}

-(void)getTheBlogForEditingWithPostID:(int)postID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices getTheBlogToEditCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andBlogPostId:postID];
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             //NSLog(@"Error in the conneciton =%@",error);
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             //NSLog(@"Data//////////=%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
             
             
             //NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[data length]);
             
             
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
            
             
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}

-(void)getAllTheImagesForEditingFromTheServer
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices getTheBlogImagesToEditCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andBlogPostId:blogPostIdForEdit];
    
    
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
             //NSLog(@"Data//////////=%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
             
             
             //NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[data length]);
             
             
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             arrayOfEditImages = [[NSMutableArray alloc]init];
             
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
     }];
}


-(void)endTheBlogWithBlogPostId:(int)blogPostID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices endTheBlogCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andBlogPostId:blogPostID];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             //NSLog(@"Error in the conneciton =%@",error);
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             //NSLog(@"Data//////////=%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
             
             
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             
             
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}




#pragma mark - Parsing delegate methods

// The first method to implement is parser:didStartElement:namespaceURI:qualifiedName:attributes:, which is fired when the start tag of an element is found:

//---when the start of an element is found---

-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict
{
    if([elementName isEqualToString:@"GetActiveBlogPostXMLResult"] || [elementName isEqualToString:@"GetInActiveBlogPostXMLResult"])
    {
        NSLog(@"111");
        isFlagSearchListing = YES;
        isPostsFound = YES;
        
    }
    if([elementName isEqualToString:@"NewDataSet"])
    {
        isFlagSearchListing = NO;
        isPostsFound = NO;
        NSLog(@"222");
    }
    if([elementName isEqualToString:@"Post"])
    {
        if(isFlagSearchListing)
        {
             NSLog(@"333");
            self.searchBlogObject = [[SMSearchBlogObject alloc]init];
        }
        else
        {
            self.editImageObject = [[SMClassOfBlogImages alloc]init];
        }
        
    }
    if([elementName isEqualToString:@"GetBlogResult"])
    {
         self.editObject = [[SMEditSearchObject alloc]init];
    }
   
    currentNodeContent = [NSMutableString stringWithString:@""];

    
    
    
}


//The next method to implement is parser:foundCharacters:, which gets fired when the parser finds the text of an element:

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    /*currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //NSLog(@"current value = %@",currentNodeContent);*/
    
    //NSLog(@"Data : %@",string);
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];

    
    
}


//Finally, when the parser encounters the end of an element, it fires the parser:didEndElement:namespaceURI:qualifiedName: method:

//---when the end of element is found---

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"BlogPostID"])
    {
        self.searchBlogObject.blogPostTypeID = [currentNodeContent intValue];
        
    }
    if([elementName isEqualToString:@"Title"])
    {
        self.searchBlogObject.strTitle = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"Details"])
    {
        NSString *strHtml = currentNodeContent;
        
        NSScanner *myScanner;
        NSString *text = nil;
        myScanner = [NSScanner scannerWithString:strHtml];
        
        while ([myScanner isAtEnd] == NO) {
            
            [myScanner scanUpToString:@"<" intoString:NULL] ;
            
            [myScanner scanUpToString:@">" intoString:&text] ;
            
            strHtml = [strHtml stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
        }
        //
        strHtml = [strHtml stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        self.searchBlogObject.strDetails = strHtml;
        
    }
    if([elementName isEqualToString:@"CreatedDate"])
    {
        self.searchBlogObject.strCreatedDate = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"PublishDate"])
    {
        self.searchBlogObject.strPublishDate = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"EndDate"])
    {
        self.searchBlogObject.strEndDate = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"EndStatus"])
    {
        self.searchBlogObject.strRemainingDaysCount = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"TotalCount"])
    {
        self.lblPagesFound.text = [NSString stringWithFormat:@"Posts Found: %@",currentNodeContent];
        
    }
    if([elementName isEqualToString:@"BlogType"])
    {
        self.searchBlogObject.strBlogPostType = currentNodeContent;
    }
    if([elementName isEqualToString:@"Name"])
    {
        self.searchBlogObject.strName = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"ImagePath"])
    {
        self.searchBlogObject.strImageURL = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"ImageCount"])
    {
        self.searchBlogObject.imgCount = currentNodeContent;
        
    }
    
    // response for end blog
    
    if([elementName isEqualToString:@"EndBlogResult"])
    {
        if(currentNodeContent)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Blog ended successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            alert.tag = 501;
            [alert show];
            
            
            
        
        }
        
    }
    
    
   // response for Edit Blog web service
    
    if([elementName isEqualToString:@"a:Active"])
    {
        self.editObject.activeStatus = [currentNodeContent boolValue];
        
    }
    if([elementName isEqualToString:@"a:Author"])
    {
        self.editObject.strAuthor = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"a:BlogPostID"])
    {
        self.editObject.blogPostID = [currentNodeContent intValue];
        //NSLog(@"Blog post id : %d",self.editObject.blogPostID);
        
    }
    if([elementName isEqualToString:@"a:BlogPostTypeID"])
    {
        self.editObject.blogPostTypeID = [currentNodeContent intValue];
        
    }
    if([elementName isEqualToString:@"a:CreatedDate"])
    {
        self.editObject.strCreatedDate = currentNodeContent;
        
    }
    if([elementName isEqualToString:@"a:Details"])
    {
        NSString *strHtml = currentNodeContent;
        
        NSScanner *myScanner;
        NSString *text = nil;
        myScanner = [NSScanner scannerWithString:strHtml];
        
        while ([myScanner isAtEnd] == NO) {
            
            [myScanner scanUpToString:@"<" intoString:NULL] ;
            
            [myScanner scanUpToString:@">" intoString:&text] ;
            
            strHtml = [strHtml stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
        }
        //
        strHtml = [strHtml stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        self.editObject.strDetails = strHtml;
    }
    if([elementName isEqualToString:@"a:EndDate"])
    {
        self.editObject.strEndDate = currentNodeContent;
    }
    if([elementName isEqualToString:@"a:Images"])
    {
        self.editObject.strImageURL = currentNodeContent;
    }
    if([elementName isEqualToString:@"a:IsDeleted"])
    {
        self.editObject.isDeleted = [currentNodeContent boolValue];
    }
    if([elementName isEqualToString:@"a:PublishDate"])
    {
        self.editObject.strPublishDate = currentNodeContent;
    }
    if([elementName isEqualToString:@"a:Title"])
    {
        self.editObject.strTitle = currentNodeContent;
    }
    if([elementName isEqualToString:@"a:cmUserID"])
    {
        self.editObject.userID = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"GetBlogResult"])
    {
        [self getAllTheImagesForEditingFromTheServer];
    }
    
    // response for edit image web service
    
    if([elementName isEqualToString:@"BlogImageID"])
    {
        self.editImageObject.imageID = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"BlogPostID"])
    {
        self.editImageObject.blogPostID = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"Path"])
    {
        self.editImageObject.originalImagePath = currentNodeContent;
    }
    if([elementName isEqualToString:@"OriginalFileName"])
    {
        self.editImageObject.imageOriginalFileName = currentNodeContent ;
    }
    if([elementName isEqualToString:@"thumbpath"])
    {
        self.editImageObject.thumbImagePath = currentNodeContent;
    }
    /*if([elementName isEqualToString:@"TotalCount"])
    {
        
        
    }*/
    if([elementName isEqualToString:@"Post"])
    {
        if(isFlagSearchListing)
        {
             NSLog(@"444");
            [arrayOfSearchResult addObject:self.searchBlogObject];
        }
        else
        {
            self.editImageObject.isImageFromLocal = NO;
            self.editImageObject.imageOriginIndex = -1;
            [arrayOfEditImages addObject:self.editImageObject];
        }
    }
    
    if([elementName isEqualToString:@"Posts"])
    {
        
        NSLog(@"arrayCountt = %lu",(unsigned long)arrayOfSearchResult.count);
        
        //NSLog(@"///search array count = %d", [arrayOfSearchResult count]);
        
//        self.lblPagesFound.text = [NSString stringWithFormat:@"Posts found: %d",self.searchBlogObject.totalSearchedBlogPostCount];
        isFetchingInProgress = NO;
        isFlagSearchListing = NO;
        [self.tblViewSearchBlog reloadData];
        
    }
    if([elementName isEqualToString:@"GetActiveBlogPostXMLResult"])
    {
        //NSLog(@"//isFlagSearchListing = %hhd",isFlagSearchListing);
        if(!isPostsFound)
        {
            self.lblPagesFound.hidden = NO;
            self.lblPagesFound.text = @"No posts found";
        }
    }
    if([elementName isEqualToString:@"GetBlogImagesByBlogPostIDResult"])
    {
        
                    
        
        SMCreateBlogViewController *createBlogViewController;

        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            createBlogViewController = [[SMCreateBlogViewController alloc]initWithNibName:@"SMCreateBlogViewController" bundle:nil];
        }
        else
        {
            createBlogViewController = [[SMCreateBlogViewController alloc]initWithNibName:@"SMCreateBlogViewController_iPad" bundle:nil];
        }
        
        createBlogViewController.arrayOfEditImageObjects = arrayOfEditImages;
        createBlogViewController.searchBlogForEdit = self.editObject;
        createBlogViewController.blogDelegate = self;
        //SMSearchBlogObject *searchedBlogObject = (SMSearchBlogObject*)[arrayOfSearchResult objectAtIndex:selectedIndexForEditBlog];
         createBlogViewController.isBlogEdited = YES;
         [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil]];
         [self.navigationController pushViewController:createBlogViewController animated:YES];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
    
}

#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
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

#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
