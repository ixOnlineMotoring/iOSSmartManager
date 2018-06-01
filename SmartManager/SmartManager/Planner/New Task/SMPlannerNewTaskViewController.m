//
//  SMPlannerNewTaskViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 20/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMPlannerNewTaskViewController.h"
#import "SMCellOfPlusImage.h"
#import "SMClassOfBlogImages.h"
#import "UIImage+Resize.h"
#import "UIImageView+WebCache.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIActionSheet+Blocks.h"

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."


@interface SMPlannerNewTaskViewController ()

@end

@implementation SMPlannerNewTaskViewController



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
    
    
    
    UILabel *listActiveSpecialsNavigTitle = [[UILabel alloc] initWithFrame:CGRectZero];
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
    listActiveSpecialsNavigTitle.text = @"New Task";
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImage" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImage"];
        
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImage" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImage"];
    }
    else
    {
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfPlusImage_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfPlusImage"];
        
        [self.collectionViewImages registerNib:[UINib nibWithNibName:@"SMCellOfActualImage_iPad" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"SMCellOfActualImage"];
    }
    
    imgCountPlanner=0;
    isClientsDropdownExpanded = NO;
    // textview design
    
    //[self.txtViewDetails setPlaceholder:@"Details"];
    //[self.txtViewDetails setPlaceholderColor:[UIColor whiteColor]];
    
    self.txtViewDetails.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtViewDetails.layer.borderWidth= 0.8f;
    self.txtViewDetails.textColor = [UIColor whiteColor];
    
    self.dateView.layer.cornerRadius=15.0;
    self.dateView.clipsToBounds      = YES;
    self.dateView.layer.borderWidth=0.8;
    self.dateView.layer.borderColor=[[UIColor blackColor] CGColor];
    
    self.timeView.layer.cornerRadius=15.0;
    self.timeView.clipsToBounds      = YES;
    self.timeView.layer.borderWidth=0.8;
    self.timeView.layer.borderColor=[[UIColor blackColor] CGColor];
    
    self.tblViewType.layer.cornerRadius=15.0;
    self.tblViewType.clipsToBounds      = YES;
    self.tblViewType.layer.borderWidth=1.5;
    self.tblViewType.layer.borderColor=[[UIColor blackColor] CGColor];

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.txtFieldClientFilter      setFont: [UIFont fontWithName:FONT_NAME size:14.0]];
        [self.txtFieldSelectClient      setFont:[UIFont fontWithName:FONT_NAME size:14.0]];
        [self.txtFieldType              setFont: [UIFont fontWithName:FONT_NAME size:14.0]];
        [self.txtFieldSelectRecipient   setFont: [UIFont fontWithName:FONT_NAME size:14.0]];
        [self.txtFieldTitle             setFont:[UIFont fontWithName:FONT_NAME size:14.0]];
        [self.txtViewDetails            setFont:[UIFont fontWithName:FONT_NAME size:14.0]];
        [self.txtFieldSelectDate        setFont: [UIFont fontWithName:FONT_NAME size:14.0]];
        [self.txtFieldSelectTime        setFont: [UIFont fontWithName:FONT_NAME size:14.0]];
        [self.lblCalenderEvent          setFont: [UIFont fontWithName:FONT_NAME size:14.0]];
        [self.btnSave.titleLabel        setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14.0]];
        [self.btnCancel.titleLabel      setFont:[UIFont fontWithName:FONT_NAME size:14.0]];
    }
    else
    {
        [self.txtFieldClientFilter      setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
        [self.txtFieldSelectClient      setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
        [self.txtFieldType              setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
        [self.txtFieldSelectRecipient   setFont: [UIFont fontWithName:FONT_NAME size:20.0]];
        [self.txtFieldTitle             setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
        [self.txtViewDetails            setFont: [UIFont fontWithName:FONT_NAME size:20.0]];
        [self.txtFieldSelectDate        setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
        [self.txtFieldSelectTime        setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
        [self.lblCalenderEvent          setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
        [self.btnSave.titleLabel        setFont:[UIFont fontWithName:FONT_NAME_BOLD size:25.0]];
        [self.btnCancel.titleLabel      setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
    }
   
   /* self.collectionViewImages.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.collectionViewImages.layer.borderWidth= 0.8f;*/
    
    self.outerViewOfImages.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.outerViewOfImages.layer.borderWidth= 0.8f;

    [self.viewDetails addSubview:self.viewForClientsDropdown];
    
    self.viewForClientsDropdown.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.viewForClientsDropdown.layer.borderWidth= 0.8f;
    //self.tblViewClientsDropdown.layer.cornerRadius = 15.0;
    
    self.viewForClientsDropdown.layer.masksToBounds = NO;
    [self.viewForClientsDropdown.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    
    self.viewForClientsDropdown.layer.shadowOffset = CGSizeMake(-5, 5);
    
    self.viewForClientsDropdown.layer.cornerRadius = 8;
    self.tblViewClientsDropdown.layer.cornerRadius = 8;
    self.viewForClientsDropdown.layer.shadowRadius = 5;
    self.viewForClientsDropdown.layer.shadowOpacity = 0.5;
    
    self.viewForClientsDropdown.hidden = YES;
    arrayOfAvailableClients = [[NSMutableArray alloc]init];
    
    self.tblViewNewTask.tableFooterView = self.viewDetails;
    self.btnSave.layer.cornerRadius = 4.0;

    arrayOfImages = [[NSMutableArray alloc]init];
    
//    [self getAllThePlannerTypeListFromServer];
//    [self getAllTheMembersFromTheServer];
    [self getAllTheAvailableClients];
    
    self.tblViewNewTask.scrollEnabled = YES;
    self.viewForClientsDropdown.frame = CGRectMake(self.txtFieldSelectClient.frame.origin.x, self.txtFieldSelectClient.frame.origin.y+self.txtFieldSelectClient.frame.size.height, self.txtFieldSelectClient.frame.size.width, 1.0);
    
    
    self.multipleImagePicker = [[RPMultipleImagePickerViewController alloc] init];
    self.multipleImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.multipleImagePicker.photoSelectionDelegate = self;
    
    [SMGlobalClass sharedInstance].totalImageSelected  = 0;
    [SMGlobalClass sharedInstance].isFromCamera = NO;

    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    NSPredicate *predicateServerImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];// from server
    NSArray *arrayServerFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateServerImages];
    
    NSPredicate *predicateLocalImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",YES];// from server
    NSArray *arrayLocalFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateLocalImages];
    
    
    
    if ([arrayServerFiltered count] > 0)
    {
       
        
        if(arrayLocalFiltered.count == 0)
            [SMGlobalClass sharedInstance].totalImageSelected = 0;
        else
            [SMGlobalClass sharedInstance].totalImageSelected = (int)(arrayOfImages.count - arrayServerFiltered.count);
        
       
    }
    else
    {
        [SMGlobalClass sharedInstance].totalImageSelected = (int)arrayOfImages.count;
       
        
    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield delegate methods

#pragma mark - textField delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtFieldSelectClient || textField == self.txtFieldSelectDate || textField == self.txtFieldSelectRecipient || textField == self.txtFieldSelectTime || textField == self.txtFieldType )
    {
        [self.view endEditing:YES];
        
        if(textField == self.txtFieldClientFilter )
        {
            if(!self.viewForClientsDropdown.hidden)
            {
                self.tblViewNewTask.scrollEnabled = YES;
            }
           
        }
        
        if(textField == self.txtFieldSelectDate )
        {
            self.viewForClientsDropdown.hidden = YES;
            isClientsDropdownExpanded=NO;
            self.timeView.hidden = YES;
            self.tblViewType.hidden = YES;
            self.dateView.hidden = NO;
            [self loadPopup];
        }
        else if(textField == self.txtFieldSelectTime )
        {
            self.viewForClientsDropdown.hidden = YES;
            self.timeView.hidden = NO;
            self.tblViewType.hidden = YES;
            self.dateView.hidden = YES;
            [self loadPopup];
        }
        else if(textField == self.txtFieldType)
        {
            self.viewForClientsDropdown.hidden = YES;
            self.dateView.hidden = YES;
            self.timeView.hidden = YES;
            self.tblViewType.hidden = NO;
            self.tblViewType.tag = 1;
            [self getAllThePlannerTypeListFromServer];

            /*if(arrayOfPlannerType.count==0)
            {
            
             [self getAllThePlannerTypeListFromServer];
             }
            else
            {
                [self.tblViewType reloadData];
                [self loadPopup];
            }*/
        }
        else if(textField == self.txtFieldSelectRecipient)
        {
            self.viewForClientsDropdown.hidden = YES;
            self.dateView.hidden = YES;
            self.timeView.hidden = YES;
            self.tblViewType.hidden = NO;
            self.tblViewType.tag = 2;
            
            [self getAllTheMembersFromTheServer];

           /* if(arrayOfMembers.count==0)
            {
                [self getAllTheMembersFromTheServer];
            }
            else
            {
                [self.tblViewType reloadData];
                [self loadPopup];
            }*/
            
        
        }
        if(textField == self.txtFieldSelectClient)
        {
            if(isClientsDropdownExpanded)
            {
                self.tblViewNewTask.scrollEnabled = YES;
                isClientsDropdownExpanded = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    self.viewForClientsDropdown.frame = CGRectMake(self.txtFieldSelectClient.frame.origin.x, self.txtFieldSelectClient.frame.origin.y+self.txtFieldSelectClient.frame.size.height, self.txtFieldSelectClient.frame.size.width, 0.0);
                } completion:^(BOOL finished)
                 {
                     self.viewForClientsDropdown.hidden = YES;
                 }];
            }
            else
            {
                [self filterTheAvailableClientsAsPerSearchText:@""];
            }
        }

        return NO;
    }
    return YES;
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField==self.txtFieldClientFilter)
    {
        resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
       
        
        [downloadingQueue cancelAllOperations];
        
        //This is done because the list is populated after some delay when the search text is entered. that means the web service will be called after that delay
        
        
        
        
        
        if([resultString length]!=0)
        {
            //            self.tblViewClientsDropdown.hidden = NO;
            
            [self filterTheAvailableClientsAsPerSearchText:resultString];
            
            
        }
        else
        {
            self.viewForClientsDropdown.hidden = YES;
             self.tblViewNewTask.scrollEnabled = YES;
            self.viewForClientsDropdown.frame = CGRectMake(self.txtFieldSelectClient.frame.origin.x, self.txtFieldSelectClient.frame.origin.y+self.txtFieldSelectClient.frame.size.height, self.txtFieldSelectClient.frame.size.width, 1.0);
            
        }
        
        return YES;
    }
    else if(textField == self.txtFieldTitle)
    {
        
        //  limit the users input to only 50 characters
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 50) ? NO : YES;
        
        
    }
    
    return YES;
    
}

#pragma mark - To restrict the input of special characters

-(BOOL)checkWhetherTheGivenStringContainsSpecialCharacters:(NSString*)inputString
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[inputString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [inputString isEqualToString:filtered];
   
}


#pragma mark - Tableview datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(tableView!=self.tblViewClientsDropdown)
    {
        float totalFrameOfView = 0.0f;

    if(self.tblViewType.tag==1)
    {
        float maxHeigthOfView = [self view].frame.size.height/2+50.0;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            totalFrameOfView = 43+([arrayOfPlannerType count]*43);
        }
        else
        {
            totalFrameOfView = 43+([arrayOfPlannerType count]*60);
        }
        if (totalFrameOfView <= maxHeigthOfView)
        {
            //Make View Size smaller, no scrolling
            self.tblViewType.frame = CGRectMake(self.tblViewType.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, self.tblViewType.frame.size.width, totalFrameOfView);
        }
        else
        {
            self.tblViewType.frame = CGRectMake(self.tblViewType.frame.origin.x, maxHeigthOfView/2-22.0, self.tblViewType.frame.size.width, maxHeigthOfView);
            
            
        }
        
        return [arrayOfPlannerType count];
    }
    else
    {
        float maxHeigthOfView = [self view].frame.size.height/2+50.0;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            totalFrameOfView = 43+([arrayOfMembers count]*43);
        }
        else
        {
            totalFrameOfView = 43+([arrayOfMembers count]*60);
        }
        if (totalFrameOfView <= maxHeigthOfView)
        {
            //Make View Size smaller, no scrolling
            self.tblViewType.frame = CGRectMake(self.tblViewType.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, self.tblViewType.frame.size.width, totalFrameOfView);
        }
        else
        {
            self.tblViewType.frame = CGRectMake(self.tblViewType.frame.origin.x, maxHeigthOfView/2-22.0, self.tblViewType.frame.size.width, maxHeigthOfView);
            
            
        }
        
        
        return [arrayOfMembers count];
        
    }
    }
    else
    {
        
        return filteredArrayForClientDropdown.count;
    }

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView!=self.tblViewClientsDropdown)
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            return 43;
        }
        else
        {
            return 50;
        }
    }
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView!=self.tblViewClientsDropdown)
        return self.btnCancel;
    return nil;
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
    
    
    if(tableView==self.tblViewType)
    {
        
        if (tableView.tag==1)
        {
            SMClassForPlannerTypeList *plannerTypeObj = (SMClassForPlannerTypeList*)[arrayOfPlannerType objectAtIndex:indexPath.row];
            cell.accessoryType =UITableViewCellAccessoryNone;
            cell.textLabel.text = plannerTypeObj.activityFutureName;
        }
        else
        {
            SMClassForNewTaskMembers *memberObj = (SMClassForNewTaskMembers*)[arrayOfMembers objectAtIndex:indexPath.row];
            cell.accessoryType =UITableViewCellAccessoryNone;
            cell.textLabel.text = memberObj.memberName;
        
        }
        
    }
   
    
    if(tableView==self.tblViewClientsDropdown)
    {
        cell.accessoryType =UITableViewCellAccessoryNone;
        
        SMClassForLocationClients *clientObj = (SMClassForLocationClients*)[filteredArrayForClientDropdown objectAtIndex:indexPath.row];
        
        cell.textLabel.text = clientObj.locClientName;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblViewType)
    {
        if (tableView.tag==1)
        {
        
            SMClassForPlannerTypeList *plannerTypeObj = (SMClassForPlannerTypeList*)[arrayOfPlannerType objectAtIndex:indexPath.row];
        
            self.txtFieldType.text = plannerTypeObj.activityFutureName;
            plannerTypeID = plannerTypeObj.activityID;
            [self dismissPopup];
        }
        else
        {
            SMClassForNewTaskMembers *memberObj = (SMClassForNewTaskMembers*)[arrayOfMembers objectAtIndex:indexPath.row];
            
            self.txtFieldSelectRecipient.text = memberObj.memberName;
            recipientID = memberObj.memberID;
            
            [self dismissPopup];
        
        }
        
    }
    
    if(tableView == self.tblViewClientsDropdown)
    {
        SMClassForLocationClients *clientObj = (SMClassForLocationClients*)[filteredArrayForClientDropdown objectAtIndex:indexPath.row];
        self.txtFieldSelectClient.text = clientObj.locClientName;
        selectedClientId = clientObj.locClientID;
        self.viewForClientsDropdown.hidden = YES;
        [self.view endEditing:YES];
        self.viewForClientsDropdown.frame = CGRectMake(self.txtFieldSelectClient.frame.origin.x, self.txtFieldSelectClient.frame.origin.y+self.txtFieldSelectClient.frame.size.height, self.txtFieldSelectClient.frame.size.width, 1.0);
        self.tblViewNewTask.scrollEnabled = YES;
        isClientsDropdownExpanded = NO;
    }
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


#pragma mark - Custom methods

-(void)filterTheAvailableClientsAsPerSearchText:(NSString*)strText
{
    
    if([strText length]!=0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locClientName BEGINSWITH[cd] %@",strText];
        
        filteredArrayForClientDropdown = [arrayOfAvailableClients filteredArrayUsingPredicate:predicate];
        
    }
    else
    {
        filteredArrayForClientDropdown = [arrayOfAvailableClients mutableCopy];
        isClientsDropdownExpanded = YES;
    }
   
    
    self.viewForClientsDropdown.hidden = NO;
    
    [self.tblViewClientsDropdown reloadData];
    
    float heightForDropdown;
    
    if([filteredArrayForClientDropdown count]>=4)
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            heightForDropdown = 4*43;
        }
        else
        {
            heightForDropdown = 4*60;
        }
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            heightForDropdown = [filteredArrayForClientDropdown count]*43;
        }
        else
        {
            heightForDropdown = [filteredArrayForClientDropdown count]*60;
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.viewForClientsDropdown.frame = CGRectMake(self.viewForClientsDropdown.frame.origin.x, self.txtFieldSelectClient.frame.origin.y+self.txtFieldSelectClient.frame.size.height, self.txtFieldSelectClient.frame.size.width, heightForDropdown);
    } completion:^(BOOL finished)
     {
         self.tblViewNewTask.scrollEnabled = NO;
     }];
    
    
    
}




#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [arrayOfImages count];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMCellOfPlusImage *cell;
        {
        cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"SMCellOfActualImage" forIndexPath:indexPath];
        
        
        
        [ cell.btnDelete addTarget:self action:@selector(btnDeleteDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnDelete.tag = indexPath.row;
        
        SMClassOfBlogImages *imageObj = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:indexPath.row];
        
        if(imageObj.isImageFromLocal)
        {
            
            NSString *str = [NSString stringWithFormat:@"%@.jpg", imageObj.imageSelected];
            
            NSString *fullImgName=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:str]];
            
           
            
            cell.imgActualImage.image = [UIImage imageWithContentsOfFile:fullImgName];
            
            
        }
            
        
        
    }
    
    
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(94, 74);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
   
    
        
}

#pragma mark - AlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== 101)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if(alertView.tag==201)
    {
        
        if(buttonIndex==0)
        {
            
        }
        else
        {
            
            {
                SMClassOfBlogImages *deleteImageObject = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:deleteButtonTag];
                
                if(deleteImageObject.isImageFromLocal==NO)
                {
                    [[SMGlobalClass sharedInstance].arrayOfImagesToBeDeleted addObject:[arrayOfImages objectAtIndex:deleteButtonTag]];
                }
                else
                {
                    if (deleteImageObject.imageOriginIndex >= 0)
                    {
                        [SMGlobalClass sharedInstance].isFromCamera = NO;
                        
                        //Means image from that picker of multiple image selection
                        [self delegateFunctionWithOriginIndex:deleteImageObject.imageOriginIndex];
                        
                        for (int i=deleteButtonTag+1;i<[arrayOfImages count];i++)
                        {
                            SMClassOfBlogImages *deleteImageObjectTemp = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:i];
                            
                            deleteImageObjectTemp.imageOriginIndex--;
                            
                        }
                    }
                }
                
                
               
                [arrayOfImages removeObjectAtIndex:deleteButtonTag];
                [self.collectionViewImages reloadData];
            }
            
            
        }
        
        
        
    }
    
    
}




#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int i = buttonIndex;
    
    
    switch(i)
    {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
            case 0:
                {
                    //                    if (picker == nil)
                    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    [picker setAllowsEditing:NO];
                    
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:^{}];
                }
                break;
                
            }
            else
            {
                
                
                [[[UIAlertView alloc]initWithTitle:@"Error"
                                           message:@"Camera not available"
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil, nil]
                 show];
                return;
                
                
                
                
            }
            
        case 1:
        {
            //            if (picker == nil)
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{}];
        }
        case 2:
            [self.tblViewNewTask setContentOffset:CGPointZero animated:YES];
            
        default:
            // Do Nothing.........
            break;
    }
    
    
    
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


#pragma - mark Selecting Image from Camera and Library

- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Picking Image from Camera/ Library
    
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
    
    [self saveImage:selectedImage :imgName];
    
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
        self.multipleImagePicker.isFromGridView = NO;
        [self.navigationController pushViewController:self.multipleImagePicker animated:YES];
    }
    

    
    
    
    // Done callback
    self.multipleImagePicker.doneCallback = ^(NSArray *images)
    {
        
        
        
        
        
        for(int i=0;i< images.count;i++)
        {
            
            SMClassOfBlogImages *imageObject = [[SMClassOfBlogImages alloc]init];
            
            imageObject.imageSelected=[images objectAtIndex:i];
            
            imageObject.isImageFromLocal = YES;
           
            imageObject.imageLink = [self loadImagePath:[images objectAtIndex:i]];
            imageObject.imageOriginIndex = -2;
            imageObject.isImageFromCamera = YES;
            imageObject.thumbImagePath = fullPathOftheImage;
            
            [arrayOfImages addObject:imageObject];
            
            
            selectedImage = nil;
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionViewImages reloadData];
            [self.multipleImagePicker.Originalimages removeAllObjects];
            
            
        });
        
        
        
    };
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker1
{
    if([SMGlobalClass sharedInstance].isFromCamera)
        [SMGlobalClass sharedInstance].photoExistingCount--;
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
}



- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



#pragma mark - Multiple Image selection and Image Editing


#pragma mark - MULTIPLE IMAGE SELECTION

- (void)dismissImagePickerControllerForCancel:(BOOL)cancelled
{
    if (self.presentedViewController)
    {
        
        
        [self dismissViewControllerAnimated:YES completion:
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
                     self.multipleImagePicker.isFromGridView = NO;
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


-(void)callTheMultiplePhotoSelectionLibraryWithRemainingCount:(int)remainingCount andFromEditScreen:(BOOL)isFromEditScreen;
{
    
    
    if(isFromEditScreen)
    {
        
        if(imagePickerController == nil)
            imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
    
    else
    {
        //        QBImagePickerController *imagePickerController2 = [[QBImagePickerController alloc] init];
        if(imagePickerController == nil)
            imagePickerController = [[QBImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        
        if(remainingCount>10)
        {
            imagePickerController.maximumNumberOfSelection = 0;
        }
        
        else
        {
            if(isFromAppGallery)
            {
               
                NSPredicate *predicateImages1 = [NSPredicate predicateWithFormat:@"imageOriginIndex >= %d",0];
                NSArray *arrayFiltered1 = [arrayOfImages filteredArrayUsingPredicate:predicateImages1];
                imagePickerController.maximumNumberOfSelection = remainingCount+[arrayFiltered1 count];
                isFromAppGallery = NO;
               
            }
            else
            {
                NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];
                NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
                if ([arrayFiltered count] > 0)
                {
                    imagePickerController.maximumNumberOfSelection = 10;
                }
                else
                {
                    NSPredicate *predicateImages1 = [NSPredicate predicateWithFormat:@"imageOriginIndex >= %d",0];
                    NSArray *arrayFiltered1 = [arrayOfImages filteredArrayUsingPredicate:predicateImages1];
                    
                    
                    imagePickerController.maximumNumberOfSelection = remainingCount+arrayFiltered1.count;
                }
            }
            
            
        }
        
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
        
        
    }
    
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
            [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Camera Not Available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]
             show];
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
        
        [self saveImage:img :imgName];
        
        [self.multipleImagePicker addOriginalImages:imgName];
        };
    }
    
    NSPredicate *predicateServerImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];// from server
    NSArray *arrayServerFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateServerImages];
    
    NSPredicate *predicateCameraImages = [NSPredicate predicateWithFormat:@"isImageFromCamera == %d",YES];
    NSArray *arrayCameraFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateCameraImages];
    
    NSArray *finalFilteredArray = [arrayServerFiltered arrayByAddingObjectsFromArray:arrayCameraFiltered];
    
    if ([finalFilteredArray count] > 0)
    {
        [arrayOfImages removeAllObjects];
        arrayOfImages = [NSMutableArray arrayWithArray:finalFilteredArray];
    }
    else
        [arrayOfImages removeAllObjects]; // check here.
    
    [self.collectionViewImages reloadData];
    
    // Done callback
    self.multipleImagePicker.doneCallback = ^(NSArray *images)
    {
        
       
        
        
        for(int i=0;i< images.count;i++)
        {
            
            
            
            SMClassOfBlogImages *imageObject = [[SMClassOfBlogImages alloc]init];
            
            imageObject.imageSelected=[images objectAtIndex:i];
            
            imageObject.isImageFromLocal = YES;
            //imageObject.imagePriorityIndex=imgCount;
            imageObject.imageLink = [self loadImagePath:[images objectAtIndex:i]];
            imageObject.imageOriginIndex = i;
            imageObject.isImageFromCamera = NO;
            imageObject.thumbImagePath = fullPathOftheImage;
            
            [arrayOfImages addObject:imageObject];
            
            selectedImage = nil;
            
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionViewImages reloadData];
            [self.multipleImagePicker.Originalimages removeAllObjects];
            //[self.multipleImagePicker.ThumbnailImages removeAllObjects];
            
        });
        
        
        
    };
    
    [self dismissImagePickerControllerForCancel:NO];
    
    
}
/////////////// Monami tap on cancel of image gallery, image delete 
- (void)imagePickerControllerDidCancelled:(QBImagePickerController *)imagePickerController
{
    [SMGlobalClass sharedInstance].isTapOnCancel = YES;
    
//    if(arrayOfImages.count>0)
//    {
//        NSPredicate *predicateServerImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];// from server
//        NSArray *arrayServerFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateServerImages];
//
//        NSPredicate *predicateCameraImages = [NSPredicate predicateWithFormat:@"isImageFromCamera == %d",YES];// from server
//        NSArray *arrayCameraFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateCameraImages];
//
//        NSArray *finalFilteredArray = [arrayServerFiltered arrayByAddingObjectsFromArray:arrayCameraFiltered];
//
//        if ([finalFilteredArray count] > 0)
//        {
//            [arrayOfImages removeAllObjects];
//            arrayOfImages = [NSMutableArray arrayWithArray:finalFilteredArray];
//        }
//        else
//        {
//            [arrayOfImages removeAllObjects]; // check here.
//        }
//
//        [self.collectionViewImages reloadData];
//
//
//    }
    
    [self.collectionViewImages reloadData];
    
    [self dismissImagePickerControllerForCancel:YES];
    
    
    
    for (UINavigationController *view in self.navigationController.viewControllers)
    {
        
        if ([view isKindOfClass:[RPMultipleImagePickerViewController class]])
        {
            [self.navigationController popViewControllerAnimated:NO];
            
        }
    }

}


- (void)saveImage:(UIImage*)image :(NSString*)imageName
{
    
    if (documentsDirectory == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        documentsDirectory = [paths objectAtIndex:0];
    }
    
    
    
    imageData = UIImageJPEGRepresentation(image,0.6); //convert image into .jpg format.
    
    fullPathOftheImage = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageName]];
    
    
    
    //    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    [imageData writeToFile:fullPathOftheImage atomically:NO];
    
    
    
    imageData = nil;
    
   
    
    
    
}

//loading an image

- (UIImage*)loadImage:(NSString*)imageName1 {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    
    return [UIImage imageWithContentsOfFile:fullPathOfImage];
    
}


- (NSString*)loadImagePath:(NSString*)imageName1 {
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    
    return [NSString stringWithFormat:@"%@.jpg",fullPathOfImage];
    
}


#pragma mark - code for dragging image



#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    SMClassOfBlogImages *imgObj = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:fromIndexPath.row];
    
    //isPrioritiesChanged = YES;
    
    [arrayOfImages removeObjectAtIndex:fromIndexPath.item];
    [arrayOfImages insertObject:imgObj atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return YES;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    
    
    return YES;
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
   
}




#pragma mark - IBActions

- (IBAction)cancelFromDatePickerDidClicked:(id)sender
{
    [self dismissPopup];
    
}

- (IBAction)clearFromDatePickerDidClicked:(id)sender
{
    self.txtFieldSelectTime.text = @"";
    [self dismissPopup];
    
}

- (IBAction)doneBtnForDatePickerDidClicked:(id)sender
{
    [self dismissPopup];
    
   
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //[dateFormatter setDateFormat:@"MM/dd/yyyy"];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:self.datePicker.date]];
    
    
   
    
    [self.txtFieldSelectDate setText:textDate];
    
}

- (IBAction)doneBtnForTimePickerDidClicked:(id)sender
{
    [self dismissPopup];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
    NSString *dateString = [outputFormatter stringFromDate:self.datePickerForTime.date];
    
    
    
    [self.txtFieldSelectTime setText:dateString];
    
}

- (IBAction)checkBoxCalenderEventDidClicked:(UIButton*)sender
{
    sender.selected = !sender.selected;
    
}

- (IBAction)clearButtonFromTimePickerDidClicked:(id)sender
{
    
    [self dismissPopup];
    
}

- (IBAction)btnSaveDidClicked:(id)sender
{
    
    
    if([self.txtFieldType.text length]==0)
    {
        SMAlert(@"Error",KSelectPlannerType);
        return;
    }
    if([self.txtFieldSelectDate.text length]==0)
    {
        SMAlert(@"Error", KSelectDate);
        return;
    }
    if([self.txtViewDetails.text length]==0)
    {
        SMAlert(@"Error",KEnterDetails);
        return;
    }

    if(![self checkWhetherTheGivenStringContainsSpecialCharacters:self.txtFieldTitle.text])
    {
        SMAlert(@"Error", KSpecialCharcter);
        return;
    }
    if([self.txtFieldSelectClient.text length]==0)
    {
        
        SMAlert(@"Error",KSelectClient);
        return;
        
    }
    [self saveTheNewTaskToTheServer];
    
  
    
}

- (IBAction)btnCancelDidClicked:(id)sender
{
   [self dismissPopup];
    
}

- (IBAction)btnDeleteDidClicked:(id)sender
{
    
    deleteButtonTag = (int)[sender tag];
    
   
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure you want to delete?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    alert.tag = 201;
    [alert show];
    
    // NSLog(@"third delete button clicked");
    
}

#pragma mark - webservice implementation

-(void)getAllThePlannerTypeListFromServer
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices getAllThePlannerTypeCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue]];
    
   
    
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
             
             
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             arrayOfPlannerType = [[NSMutableArray alloc]init];
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}

-(void)getAllTheMembersFromTheServer
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices getAllTheMembersForNewTaskModuleCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue];
    
   
    
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
             
             
             
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             
             arrayOfMembers = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}

-(void)getAllTheAvailableClients
{
     NSMutableURLRequest *requestURL=[SMWebServices getAllTheAvailableClientsCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue];
    
    
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
             
             
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}

-(void)saveTheNewTaskToTheServer
{
    
      if([self.txtFieldSelectTime.text isEqualToString:@""])
      {
          self.txtFieldSelectTime.text = @"23:59";
      }
      
    
     NSString *combinedString = [NSString stringWithFormat:@"%@ %@",self.txtFieldSelectDate.text,self.txtFieldSelectTime.text];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd MMM yyyy HH:mm"];
    
     NSDate *dateReceived = [dateFormatter2 dateFromString:combinedString];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
   
    NSString *dateString = [dateFormatter stringFromDate:dateReceived];
    
    
   
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices saveTheNewTaskDataToTheserverWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:selectedClientId andPlannerTypeID:plannerTypeID andRecepientID:recipientID andTitle:self.txtFieldTitle.text andDetails:self.txtViewDetails.text andDate:dateString andIsCalender:self.checkBoxCalenderEvent.isSelected];
    
   
    
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
        
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];

}

-(void)uploadTheImagesToTheServerWithPriority:(int)priority
{
    SMClassOfBlogImages *imageObj = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:priority];
    
    NSMutableURLRequest *requestURL= [SMWebServices saveAllImagesOfNewTaskWithUserHash:[SMGlobalClass sharedInstance].hashValue andTaskID:taskIDForUploadingImages andImageDescription:@"" andImageFileName:imageObj.imageSelected andImgBase64String:base64Str];
    

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:requestURL delegate:self];
    [connection start];
    
    
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
    if([elementName isEqualToString:@"type"])
    {
        self.plannerTypeListObject = [[SMClassForPlannerTypeList alloc]init];
    }
    
    // code for getting memebers
    
    if([elementName isEqualToString:@"member"])
    {
        self.membersObject = [[SMClassForNewTaskMembers alloc]init];
    }
    
    // code for getting available clients
    
    if([elementName isEqualToString:@"client"])
    {
        self.locClientObject = [[SMClassForLocationClients alloc]init];
    }
    
    currentNodeContent = [NSMutableString stringWithString:@""];
    
    
}

//The next method to implement is parser:foundCharacters:, which gets fired when the parser finds the text of an element:

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
   
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
}


//Finally, when the parser encounters the end of an element, it fires the parser:didEndElement:namespaceURI:qualifiedName: method:

//---when the end of element is found---

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    // This is for getting Planner Type List
    
    if([elementName isEqualToString:@"activityID"])
    {
        self.plannerTypeListObject.activityID = [currentNodeContent intValue];
        
    }
    if([elementName isEqualToString:@"activityPastName"])
    {
        
        self.plannerTypeListObject.activityPastName = currentNodeContent ;
        
        
        
    }
    if([elementName isEqualToString:@"activityFutureName"])
    {
        self.plannerTypeListObject.activityFutureName = currentNodeContent ;
       
        
    }
    if([elementName isEqualToString:@"type"])
    {
        [arrayOfPlannerType addObject:self.plannerTypeListObject];
        
    }
    if([elementName isEqualToString:@"PlannerTypes"])
    {
    
        
        [self.tblViewType reloadData];
        arrayOfPlannerType.count > 0 ? [self loadPopup] : [self showAlrt:@"No record(s) found."];
        
    }

    
    
    // code for getting memebers
    
    if([elementName isEqualToString:@"memberID"])
    {
        self.membersObject.memberID = [currentNodeContent intValue];
        
    }
    if([elementName isEqualToString:@"memberName"])
    {
        self.membersObject.memberName = currentNodeContent ;
        
    }
    if([elementName isEqualToString:@"member"])
    {
        [arrayOfMembers addObject:self.membersObject];
        
    }
    
    if ([elementName isEqualToString:@"Members"])
    {
    
        [self.tblViewType reloadData];
        arrayOfMembers.count > 0 ? [self loadPopup] : [self showAlrt:@"No record(s) found."];
    }
    
    // This is for getting available clients
    
    if([elementName isEqualToString:@"clientID"])
    {
        self.locClientObject.locClientID = [currentNodeContent intValue] ;
        
    }
    if([elementName isEqualToString:@"clientName"])
    {
        self.locClientObject.locClientName = currentNodeContent ;
        
    }
    if([elementName isEqualToString:@"client"])
    {
        self.locClientObject.isClientAlreadyAvailable = YES;
        [arrayOfAvailableClients addObject:self.locClientObject];
       
        
    }

    if([elementName isEqualToString:@"PostNewTaskResult"])
    {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        NSNumber * n = [f numberFromString:@"34jfkjdskj80"];
       
        
        
         if([currentNodeContent intValue]>0)
        {
            
            taskIDForUploadingImages = [currentNodeContent intValue];
            
            for(int i = 0;i<[arrayOfImages count];i++)
            {
                SMClassOfBlogImages *imageObj = (SMClassOfBlogImages*)[arrayOfImages objectAtIndex:i];
                
                UIImage *imageToUpload = [self loadImage:[NSString stringWithFormat:@"%@.jpg",imageObj.imageSelected]];
                
                NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
                
                
                base64Str = [self encodeBase64WithData:imageDataForUpload];
                
                NSLog(@"Base64String = %@",base64Str);
                
                [self uploadTheImagesToTheServerWithPriority:i];
                
                
            }

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"New task saved successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            alert.tag = 101;
            [alert show];
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Could not save the new task" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
}

#pragma mark - Base64 Encoding


#pragma mark - base64 image encoding


static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};


- (NSString *)encodeBase64WithData:(NSData *)objData {
    const unsigned char * objRawData = [objData bytes];
    char * objPointer;
    char * strResult;
    
    // Get the Raw Data length and ensure we actually have data
    int intLength = [objData length];
    if (intLength == 0) return nil;
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    strResult = (char *)calloc((((intLength + 2) / 3) * 4) + 1, sizeof(char));
    objPointer = strResult;
    
    // Iterate through everything
    while (intLength > 2) { // keep going until we have less than 24 bits
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
        *objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        objRawData += 3;
        intLength -= 3;
    }
    
    // now deal with the tail end of things
    if (intLength != 0) {
        *objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
        if (intLength > 1) {
            *objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Terminate the string-based result
    *objPointer = '\0';
    
    // Create result NSString object
    NSString *base64String = [NSString stringWithCString:strResult encoding:NSASCIIStringEncoding];
    
    // Free memory
    free(strResult);
    
    return base64String;
}

#pragma mark - NSURL connection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   
    
    responseData = [[NSMutableData alloc]init];
    
    
    
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   
    
    [responseData appendData:data];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *xml = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    xmlParser = [[NSXMLParser alloc] initWithData:responseData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
    
   
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

- (IBAction)btnPlusImageDidClicked:(id)sender
{
    
    int RemainingCount;
    
    NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];
    NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
    if ([arrayFiltered count] > 0)
    {
        RemainingCount = arrayOfImages.count-arrayFiltered.count;
    }
    else
        RemainingCount = arrayOfImages.count;
    
    
    
    if(RemainingCount<12)
    {
        
        

        
        [UIActionSheet showInView:self.view
                        withTitle:@"Select The Picture"
                cancelButtonTitle:@"Cancel"
           destructiveButtonTitle:nil
                otherButtonTitles:@[@"Camera", @"Select From Library"]
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
                                     
                                     int RemainingCount;
                                     
                                     NSPredicate *predicateImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d",NO];
                                     NSArray *arrayFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateImages];
                                     if ([arrayFiltered count] > 0)
                                     {
                                         
                                         NSPredicate *predicateLocalImages = [NSPredicate predicateWithFormat:@"isImageFromLocal == %d AND isImageFromCamera == %d",YES,NO];// from server
                                         NSArray *arrayLocalFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateLocalImages];
                                         
                                         
                                         NSPredicate *predicateCameraImages = [NSPredicate predicateWithFormat:@"isImageFromCamera == %d",YES];// from server
                                         NSArray *arrayCameraFiltered = [arrayOfImages filteredArrayUsingPredicate:predicateCameraImages];
                                        
                                         
                                         NSArray *finalFilteredArray = [arrayLocalFiltered arrayByAddingObjectsFromArray:arrayCameraFiltered];
                                         
                                         if(finalFilteredArray.count == 0)
                                             RemainingCount = 0;
                                         else
                                             RemainingCount = finalFilteredArray.count;
                                     }
                                     else
                                         RemainingCount = arrayOfImages.count;
                                     
                                     [SMGlobalClass sharedInstance].isFromCamera = NO;
                                     
                                     isFromAppGallery = YES;
                                     
                                     [self callTheMultiplePhotoSelectionLibraryWithRemainingCount:10 - RemainingCount andFromEditScreen:NO];
                                 }
                                     
                                 default:
                                     break;
                             }
                             
                             
                         }];
        
    }
    
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

-(void)delegateFunctionForDeselectingTheSelectedPhotos
{
    [imagePickerController deSelectAllTheSelectedPhotosWhenCancelAction];
    
}


-(void)dismissTheLoader
{
    [imagePickerController dismissTheLoaderAction];
    
    
}

@end
