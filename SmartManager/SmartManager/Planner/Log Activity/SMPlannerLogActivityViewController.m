//
//  SMPlannerLogActivityViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 17/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMPlannerLogActivityViewController.h"
#import "SMClassForTimeSpentObject.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"


@interface SMPlannerLogActivityViewController ()

@property (readonly) CLLocationCoordinate2D currentUserCoordinate;



@end

@implementation SMPlannerLogActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addingProgressHUD];
    
    
    // used for setting Navigation Title
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Log Activity"];
    
    selectedRow = -1;
    isClientsDropdownExpanded = NO;
    
    
    self.txtViewDetails.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtViewDetails.layer.borderWidth= 0.8f;
    self.txtViewDetails.textColor = [UIColor whiteColor];
    
   
    self.dateView.layer.cornerRadius=15.0;
    self.dateView.clipsToBounds      = YES;
    self.dateView.layer.borderWidth=0.8;
    self.dateView.layer.borderColor=[[UIColor blackColor] CGColor];
    self.tblViewActivityLog.tableFooterView = self.viewDetails;
    self.tblViewTimeSpent.layer.cornerRadius=15.0;
    self.tblViewTimeSpent.clipsToBounds      = YES;
    self.tblViewTimeSpent.layer.borderWidth=1.5;
    self.tblViewTimeSpent.layer.borderColor=[[UIColor blackColor] CGColor];
    
    [self.viewDetails addSubview:self.viewForClientsDropdown];
   
    self.viewForClientsDropdown.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.viewForClientsDropdown.layer.borderWidth= 0.8f;
   
    
    self.viewForClientsDropdown.layer.masksToBounds = NO;
    [self.viewForClientsDropdown.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    
    self.viewForClientsDropdown.layer.shadowOffset = CGSizeMake(-5, 5);

    self.viewForClientsDropdown.layer.cornerRadius = 8;
    self.tblViewClientsDropdown.layer.cornerRadius = 8;
    self.viewForClientsDropdown.layer.shadowRadius = 5;
    self.viewForClientsDropdown.layer.shadowOpacity = 0.5;

    self.viewForClientsDropdown.hidden = YES;
    arrayOfAvailableClients = [[NSMutableArray alloc]init];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.txtViewDetails.font = [UIFont fontWithName:FONT_NAME size:14.0];
        self.lblLocationAddress.font = [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
        [self.btnCheckIn.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14]];
        [self.btnSave.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14]];
        
        self.viewHeader.frame = CGRectMake(self.viewHeader.frame.origin.x, self.viewHeader.frame.origin.y, self.viewHeader.frame.size.width, 64.0);
        
        [self.cancelButton.titleLabel      setFont:[UIFont fontWithName:FONT_NAME size:14.0]];
    }
    else
    {
        self.txtViewDetails.font = [UIFont fontWithName:FONT_NAME size:20.0];
        self.lblLocationAddress.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        [self.btnCheckIn.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:25.0]];
        [self.btnSave.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:25.0]];
        
        [self.lblInternal setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0]];
        [self.lblToday setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0]];
        [self.lblOr setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0]];
        
        self.viewHeader.frame = CGRectMake(self.viewHeader.frame.origin.x, self.viewHeader.frame.origin.y, self.viewHeader.frame.size.width, 70.0);
        
        [self.cancelButton.titleLabel      setFont:[UIFont fontWithName:FONT_NAME size:20.0]];
    }

    self.tblViewActivityLog.tableHeaderView = self.viewHeader;
    

    self.btnSave.layer.cornerRadius = 4.0;
    self.btnCheckIn.layer.cornerRadius = 4.0;
    self.checkBoxToday.selected = YES;
   
    
    [self populateTheTimeSpentArray];
    
    
    [self getAllTheAvailableClients];
    
    self.tblViewActivityLog.scrollEnabled = YES;
    self.viewForClientsDropdown.frame = CGRectMake(self.txtFieldSelectClient.frame.origin.x, self.txtFieldSelectClient.frame.origin.y+self.txtFieldSelectClient.frame.size.height, self.txtFieldSelectClient.frame.size.width, 1.0);
   

}

-(void)viewWillAppear:(BOOL)animated
{
    [self setTheDirections];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtFieldSelectClient ||  textField == self.txtFieldSelectDate || textField == self.txtFieldTimeSpent || textField == self.txtFieldType )
    {
        [self.view endEditing:YES];
        
        if(textField == self.txtFieldSelectDate )
        {
            self.tblViewTimeSpent.hidden = YES;
             self.dateView.hidden = NO;
            [self loadPopup];
            
        }
        if(textField == self.txtFieldTimeSpent )
        {
            [self populateTheTimeSpentArray];
            self.tblViewTimeSpent.hidden = NO;
            self.tblViewTimeSpent.tag = 1;
            self.dateView.hidden = YES;
            [self loadPopup];
            
        }

        if(textField == self.txtFieldType )
        {
            self.tblViewTimeSpent.hidden = NO;
            self.tblViewTimeSpent.tag = 2;
            self.dateView.hidden = YES;
            
            [self getAllThePlannerTypeListFromServer];

        }
        if(textField == self.txtFieldSelectClient)
        {
             if(isClientsDropdownExpanded)
             {
                 self.tblViewActivityLog.scrollEnabled = YES;
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


-(void)textViewDidBeginEditing:(UITextView *)textView
{
   
    
     self.tblViewActivityLog.scrollEnabled = YES;
    
    svos = self.tblViewActivityLog.contentOffset;
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:self.tblViewActivityLog];
    pt = rc.origin;
    pt.x = 0;
    
    pt.y -= 1;
    [self.tblViewActivityLog setContentOffset:pt animated:YES];
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
     //[[self txtFieldClientFilter] setTintColor:[UIColor blueColor]];
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
            self.tblViewActivityLog.scrollEnabled = YES;
            self.viewForClientsDropdown.frame = CGRectMake(self.txtFieldSelectClient.frame.origin.x, self.txtFieldSelectClient.frame.origin.y+self.txtFieldSelectClient.frame.size.height, self.txtFieldSelectClient.frame.size.width, 1.0);

        }
        
        return YES;
    }
    return YES;

}


#pragma mark - Custom methods

-(void)populateTheTimeSpentArray
{
    
    arrayOfTimeSpent = [[NSMutableArray alloc]init];
    
    NSArray *arrayTime = [[NSArray alloc]initWithObjects:@"5 mins",@"10 mins",@"15 mins",@"20 mins",@"25 mins",@"30 mins",@"35 mins",@"40 mins",@"45 mins",@"50 mins",@"55 mins",@"60 mins",@"90 mins",@"2 hours",@"3 hours",@"4 hours",@"5 hours",@"6 hours",@"7 hours",@"8 hours",@"9 hours",@"10 hours",@"11 hours",@"12 hours", nil];
    
    for(int i=0;i<[arrayTime count];i++)
    {
    
        SMClassForTimeSpentObject *timeObject = [[SMClassForTimeSpentObject alloc]init];
        timeObject.timeSelected = [arrayTime objectAtIndex:i];
        timeObject.isTimeSelected = NO;
        
        [arrayOfTimeSpent addObject:timeObject];
        
    }
    
    [self.tblViewTimeSpent reloadData];
   
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

#pragma mark - Tableview datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView!=self.tblViewClientsDropdown)
    {
        float maxHeigthOfView = [self view].frame.size.height/2+50.0;
        
        float totalFrameOfView = 0.0f;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            totalFrameOfView = 43+([arrayOfTimeSpent count]*43);
        }
        else
        {
            totalFrameOfView = 60+([arrayOfTimeSpent count]*60);
        }
        
        if (totalFrameOfView <= maxHeigthOfView)
        {
            //Make View Size smaller, no scrolling
            
           
                self.tblViewTimeSpent.frame = CGRectMake(self.tblViewTimeSpent.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, self.tblViewTimeSpent.frame.size.width, totalFrameOfView);
           
            
        }
        else
        {
           
                 self.tblViewTimeSpent.frame = CGRectMake(self.tblViewTimeSpent.frame.origin.x, maxHeigthOfView/2-22.0, self.tblViewTimeSpent.frame.size.width, maxHeigthOfView);
            
            
        }
        return [arrayOfTimeSpent count];
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
    else
        return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView!=self.tblViewClientsDropdown)
     return self.cancelButton;
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
        return 60.0;
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
    
    if(tableView==self.tblViewClientsDropdown)
    {
         cell.accessoryType =UITableViewCellAccessoryNone;
       
        SMClassForLocationClients *clientObj = (SMClassForLocationClients*)[filteredArrayForClientDropdown objectAtIndex:indexPath.row];
        
       
        
        if(!clientObj.isClientAlreadyAvailable)
        {
            cell.textLabel.textColor = [UIColor colorWithRed:217.0/255 green:31.0/255 blue:40.0/255 alpha:1.0];
        }
        else
        {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        
        cell.textLabel.text = clientObj.locClientName;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    else
    {
        if(tableView.tag==1)
        {
            SMClassForTimeSpentObject *timeObj = (SMClassForTimeSpentObject*)[arrayOfTimeSpent objectAtIndex:indexPath.row];
            
            cell.textLabel.text = timeObj.timeSelected;
            
            if(selectedRow == [indexPath row])
            {
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
                timeObj.isTimeSelected = YES;
                
            }
            else
            {
                cell.accessoryType =UITableViewCellAccessoryNone;
                timeObj.isTimeSelected = NO;
            }
        }
        else
        {
            if ([[arrayOfTimeSpent objectAtIndex:indexPath.row] isKindOfClass:[SMClassForPlannerTypeList class]])
            {
                SMClassForPlannerTypeList *plannerTypeObj = (SMClassForPlannerTypeList*)[arrayOfTimeSpent objectAtIndex:indexPath.row];
                cell.accessoryType =UITableViewCellAccessoryNone;
                cell.textLabel.text = plannerTypeObj.activityPastName;
            }
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tblViewClientsDropdown)
    {
        SMClassForLocationClients *clientObj = (SMClassForLocationClients*)[filteredArrayForClientDropdown objectAtIndex:indexPath.row];
        self.txtFieldSelectClient.text = clientObj.locClientName;
        selectedClientId = clientObj.locClientID;
        self.viewForClientsDropdown.hidden = YES;
        [self.view endEditing:YES];
        isClientsDropdownExpanded = NO;
        self.viewForClientsDropdown.frame = CGRectMake(self.txtFieldSelectClient.frame.origin.x, self.txtFieldSelectClient.frame.origin.y+self.txtFieldSelectClient.frame.size.height, self.txtFieldSelectClient.frame.size.width, 1.0);
        self.tblViewActivityLog.scrollEnabled = YES;
    }
    else
    {
        if(tableView.tag==1)
        {
            selectedRow = (int)[indexPath row];
            SMClassForTimeSpentObject *timeObj = (SMClassForTimeSpentObject*)[arrayOfTimeSpent objectAtIndex:indexPath.row];
            self.txtFieldTimeSpent.text = timeObj.timeSelected;
           
            [tableView reloadData];
            
            [self dismissPopup];
        }
        else
        {
            SMClassForPlannerTypeList *plannerTypeObj = (SMClassForPlannerTypeList*)[arrayOfTimeSpent objectAtIndex:indexPath.row];
            
            self.txtFieldType.text = plannerTypeObj.activityPastName;
            selectedplannerType = plannerTypeObj.activityID;
            [self dismissPopup];
        }
    }
    
}


#pragma mark - IBActions

- (IBAction)checkBoxBtnInternalDidClicked:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    sender.selected = !sender.selected;
    
}

- (IBAction)checkBoxBtnTodayDidClicked:(UIButton*)sender
{
    
    [self.view endEditing:YES];
    
    sender.selected = !sender.selected;
    
    if(sender.isSelected)
    {
        self.txtFieldSelectDate.text = @"";
    }
    
}
- (IBAction)btnCheckInDidClicked:(id)sender
{
    
    
    [self.view endEditing:YES];
    self.viewForClientsDropdown.hidden = YES;
    ischeckInBtnPressed = YES;
    [self getAllTheClientsAtTheGivenLocation];
    
    
}

- (IBAction)btnCancelDidClicked:(id)sender
{
  
    [self dismissPopup];
    
    
}

- (IBAction)btnCancelFromDatePickerDidClicked:(id)sender
{
     [self dismissPopup];
    
}

- (IBAction)btnClearFromDatePickerDidClicked:(id)sender
{
    self.txtFieldSelectDate.text = @"";
     [self dismissPopup];
    
}

- (IBAction)btnDoneFromDateViewDidClicked:(id)sender
{
    [self dismissPopup];
    self.checkBoxToday.selected = NO;
    
   
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
   
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:self.datePicker.date]];
    
    
   
    
    [self.txtFieldSelectDate setText:textDate];
        
}

- (IBAction)btnSaveDidClicked:(id)sender
{
    
    
    if(selectedClientId == 0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Error"
                                   message:@"Please select the client"
                                  delegate:self cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil, nil]
         show];
        return;
        
        
    }
    
    
    
    if([self.txtFieldType.text length]==0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Error"
                                   message:@"Please select the planner type"
                                  delegate:self cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil, nil]
         show];
        return;
        
        
    }
    
    if([self.txtViewDetails.text length]==0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Error"
                                   message:@"Please select the details"
                                  delegate:self cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil, nil]
         show];
        return;
        
        
    }

    
    
    [self saveTheLogActivityDataToServer];
    
    
    
}

#pragma mark - Custom methods

-(void)filterTheAvailableClientsAsPerSearchText:(NSString*)strText
{
    NSLog(@"ArrayCount = %lu",(unsigned long)arrayOfAvailableClients.count);
    
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
             self.tblViewActivityLog.scrollEnabled = NO;
         }];
    
    
    
}


#pragma mark - Web service implementation


-(void)getAllTheClientsAtTheGivenLocation
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL=[SMWebServices getAllTheClientsAtTheLocationWithUserHashValue:[SMGlobalClass sharedInstance].hashValue andLatitude:currentLatitude andLongitude:currentLongitude];

    
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    

    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

         
         if (error!=nil)
         {
             
            
             
             [[[UIAlertView alloc]initWithTitle:@"Error"
                                        message:[error.localizedDescription capitalizedString]
                                       delegate:self cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil]
              show];
             
         }
         else
         {
             
             
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             arrayOfLocationClients = [[NSMutableArray alloc]init];
             shouldShowErrorMessage = NO;
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}

-(void)getAllTheAvailableClients
{
    
    
    self.txtFieldSelectClient.userInteractionEnabled = NO;
    
    
    NSMutableURLRequest *requestURL=[SMWebServices getAllTheAvailableClientsCorrespondingToUserHash:[SMGlobalClass sharedInstance].hashValue];
    
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    

    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

         
         if (error!=nil)
         {
             
            
             
             [[[UIAlertView alloc]initWithTitle:@"Error"
                                        message:[error.localizedDescription capitalizedString]
                                       delegate:self cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil]
              show];
             
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
//         [SVProgressHUD dismiss];
         
         if (error!=nil)
         {
             
            
             
             [[[UIAlertView alloc]initWithTitle:@"Error"
                                        message:[error.localizedDescription capitalizedString]
                                       delegate:self cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil]
              show];
             
         }
         else
         {
             
             
             
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             arrayOfTimeSpent = [[NSMutableArray alloc]init];
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)saveTheLogActivityDataToServer
{
    
    NSString *dateString;
    
    if(!self.checkBoxToday.selected)
    {
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"dd MMM yyyy"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *dateReceived = [dateFormatter1 dateFromString:self.txtFieldSelectDate.text];
        
        dateString = [dateFormatter stringFromDate:dateReceived];
    }
    else
    {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        dateString = [dateFormatter stringFromDate:[NSDate date]];
        
    }

    
    if(dateString == nil)
    {
        [[[UIAlertView alloc]initWithTitle:@"Error"
                                   message:@"Please select the date"
                                  delegate:self cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil, nil]
         show];
        return;
        
        
    }
    
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
     NSMutableURLRequest *requestURL=[SMWebServices saveTHeLogActivityDataToTheserverWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:selectedClientId andPlannerTypeID:selectedplannerType andDetails:self.txtViewDetails.text andIsInternal:self.checkBoxInternal.isSelected andTimeSpent:[self convertTheGivenTimeInMinutesForTheTime:self.txtFieldTimeSpent.text]  andIsToday:self.checkBoxInternal.isSelected andAlternateDate:dateString andLocationLatitude:currentLatitude andLocationLongitude:currentLongitude andLocationAddress:self.lblLocationAddress.text andClientName:self.txtFieldPersonSeenNone.text];
    
    
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
             
             arrayOfTimeSpent = [[NSMutableArray alloc]init];
             
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}

#pragma mark - AlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== 101)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if(alertView.tag== 501)
    {
        if (buttonIndex == 1)
        {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
        }
    }

}

#pragma mark - Getting Current Location


-(void)setTheDirections
{
    
    if(locationManager==nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    
    
    
    locationManager.delegate = self;
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
    {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        
        
        // If the status is denied or only granted for when in use, display an alert
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied )
        {
            NSString *title;
            title = (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusNotDetermined) ? @"Location services are off" : @"Background location is not enabled";
            NSString *message = @"You can enable access in Settings->Privacy->Location->Location Services";
            isError = YES;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        // The user has not enabled any location services. Request background authorization.
        else if (status == kCLAuthorizationStatusNotDetermined)
        {
            [locationManager requestWhenInUseAuthorization];
        }
       
    }
    
    [locationManager startUpdatingLocation];
    

    
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

    
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
    _currentUserCoordinate = [newLocation coordinate];
    
    currentLatitude =  _currentUserCoordinate.latitude;
    currentLongitude = _currentUserCoordinate.longitude;
    
}



-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location services disabled." message:@"Please enable the location services on your device." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
    
    
  
}






#pragma mark - NsXmlParser delegate methods

#pragma mark - Parsing delegate methods

// The first method to implement is parser:didStartElement:namespaceURI:qualifiedName:attributes:, which is fired when the start tag of an element is found:

//---when the start of an element is found---

-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict
{
    if([elementName isEqualToString:@"a:ClientResult"])
    {
        self.locClientObject = [[SMClassForLocationClients alloc]init];
    }
    if([elementName isEqualToString:@"type"])
    {
        self.plannerTypeListObject = [[SMClassForPlannerTypeList alloc]init];
    }
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
    if([elementName isEqualToString:@"a:ClientID"])
    {
        self.locClientObject.locClientID = [currentNodeContent intValue];
    }
    if([elementName isEqualToString:@"a:ClientName"])
    {
        self.locClientObject.locClientName = currentNodeContent ;
    }
    if([elementName isEqualToString:@"a:GeoError"])
    {
        if([currentNodeContent isEqualToString:@"true"])
        {
            shouldShowErrorMessage = YES;
        }
    }
    if([elementName isEqualToString:@"a:Message"])
    {
        if(shouldShowErrorMessage)
        {
            shouldShowErrorMessage = NO;
            self.lblLocationAddress.text = currentNodeContent;
            [self.lblLocationAddress sizeToFit];
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                self.viewHeader.frame = CGRectMake(self.viewHeader.frame.origin.x, self.viewHeader.frame.origin.y, self.viewHeader.frame.size.width, 64.0 + self.lblLocationAddress.frame.size.height+5.0);
            }
            else
            {
                self.viewHeader.frame = CGRectMake(self.viewHeader.frame.origin.x, self.viewHeader.frame.origin.y, self.viewHeader.frame.size.width, 70.0 + self.lblLocationAddress.frame.size.height+5.0);
            }
            
            self.tblViewActivityLog.tableHeaderView = self.viewHeader;
        }
    
    }
    if([elementName isEqualToString:@"a:LocationAddress"])
    {
        if(!shouldShowErrorMessage)
        {
            self.lblLocationAddress.text = currentNodeContent;
            [self.lblLocationAddress sizeToFit];
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                self.viewHeader.frame = CGRectMake(self.viewHeader.frame.origin.x, self.viewHeader.frame.origin.y, self.viewHeader.frame.size.width, 64.0 + self.lblLocationAddress.frame.size.height+5.0);
            }
            else
            {
                self.viewHeader.frame = CGRectMake(self.viewHeader.frame.origin.x, self.viewHeader.frame.origin.y, self.viewHeader.frame.size.width, 70.0 + self.lblLocationAddress.frame.size.height+5.0);
            }
            
        self.tblViewActivityLog.tableHeaderView = self.viewHeader;
        }
    }

    
    if([elementName isEqualToString:@"a:ClientResult"])
    {
           self.locClientObject.isClientAlreadyAvailable = NO;
          [arrayOfLocationClients addObject:self.locClientObject];
        
          [arrayOfAvailableClients addObject:self.locClientObject];
          [self.tblViewClientsDropdown reloadData];
        
    }

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
        [arrayOfTimeSpent addObject:self.plannerTypeListObject];
    }
    
    
    if([elementName isEqualToString:@"PlannerTypes"])
    {
        
        
        [self.tblViewTimeSpent reloadData];
         arrayOfTimeSpent.count > 0 ? [self loadPopup] : [self showAlrt:@"No record(s) found."];
        
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
    if([elementName isEqualToString:@"Clients"])
    {
        
    }
    
    if([elementName isEqualToString:@"LogActivityResult"])
    {
        if ([currentNodeContent rangeOfString:@"OK"].length > 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Log activity saved successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            alert.tag = 101;
            [alert show];
        }
        else
        {
           
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Could not save the log activity" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
           
        
        }

    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
     self.txtFieldSelectClient.userInteractionEnabled = YES;
    [self hideProgressHUD];
}

-(int)convertTheGivenTimeInMinutesForTheTime:(NSString*)selectedTime
{
    if ([selectedTime rangeOfString:@"hours"].length > 0)
    {
        
        
        
        NSString *stringToRemove = @"hours";
        
        selectedTime = [selectedTime stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",stringToRemove] withString:@""];
        
        selectedTime = [selectedTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
       return  [selectedTime intValue]*60;
        
    }
    else
    {
       
        
        NSString *stringToRemove = @"mins";
        
        selectedTime = [selectedTime stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",stringToRemove] withString:@""];
        
        return [selectedTime intValue];

    }


}
#pragma mark - showAlert

- (void)showAlert
{
    [[[UIAlertView alloc]initWithTitle:KLoaderTitle message:@"No record(s) found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
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
@end
