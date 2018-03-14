//
//  SMPlannerToDoViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 04/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMPlannerToDoViewController.h"

#import "SMClassForToDoObjects.h"
#import "SMClassForToDoInnerObjects.h"
#import "SMDonePlannerButton.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIImageView+WebCache.h"
#import "FGalleryViewController.h"
#import "SMConstants.h"
#import "SMAppDelegate.h"

@interface SMPlannerToDoViewController ()

@end

@implementation SMPlannerToDoViewController

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
    listActiveSpecialsNavigTitle.text = @"To Do's";
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tblViewToDo registerNib:[UINib nibWithNibName:@"SMCustomCellForTodayTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMCustomCellForTodayTableViewCell"];
        
        [self.tblViewToDo registerNib:[UINib nibWithNibName:@"SMCustomCellForDueDate" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMCustomCellForDueDate"];
        
        [self.tblViewToDo registerNib:[UINib nibWithNibName:@"SMCustomCellForName" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMCustomCellForName"];
    }
    else
    {
        [self.tblViewToDo registerNib:[UINib nibWithNibName:@"SMCustomCellForTodayTableViewCell_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMCustomCellForTodayTableViewCell"];
        
        [self.tblViewToDo registerNib:[UINib nibWithNibName:@"SMCustomCellForDueDate_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMCustomCellForDueDate"];
        
        [self.tblViewToDo registerNib:[UINib nibWithNibName:@"SMCustomCellForName_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMCustomCellForName"];
    }
    
    // custom text view
    
    [self.txtViewReason setPlaceholder:@"Enter your reason for rejection"];
    [self.txtViewReason setPlaceholderColor:[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]];
    self.txtViewReason.font = [UIFont fontWithName:FONT_NAME size:14.0];
    
    self.txtViewReason.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.txtViewReason.layer.borderWidth= 0.4f;
    self.txtViewReason.textColor = [UIColor blackColor];
    self.viewForReason.layer.cornerRadius = 8.0;
    
    self.btnReasonCancel.layer.cornerRadius = 4.0;
    
    self.btnReasonSend.layer.cornerRadius = 4.0;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblTaskDetails.font = [UIFont fontWithName:FONT_NAME size:14.0];
        [self.btnReasonCancel.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14]];
        [self.btnReasonSend.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14]];
    }
    else
    {
        self.lblTaskDetails.font = [UIFont fontWithName:FONT_NAME size:20.0];
        [self.btnReasonCancel.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0]];
        [self.btnReasonSend.titleLabel setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0]];
    }
    
    arrayForSections = [[NSMutableArray alloc]init];
    [self populateTheSectionsArray];
    
    [self setTheDirections];
    
    [self getAllTheMembersByPeriods];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];

        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                       withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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




#pragma mark - tableView delegate methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  [arrayForSections count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:section];
   
    
    if (sectionObject.isExpanded)
    {
        return sectionObject.arrayOfInnerObjects.count;
    }
    
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:indexPath.section];
    
   
    
    
    SMClassForToDoMemberLocationObject *rowObject = (SMClassForToDoMemberLocationObject*)[sectionObject.arrayOfInnerObjects objectAtIndex:indexPath.row];
    
    if(!rowObject.isExpandable)
    {
        return 58.0;
    }
    else
    {
                
        
        {
        
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:indexPath.section];
                SMClassForToDoMemberLocationObject *rowObject = (SMClassForToDoMemberLocationObject*)[sectionObject.arrayOfInnerObjects objectAtIndex:indexPath.row];
                if ([rowObject.arrayImages count] == 0)
                    return 260;
                return 315;
            }
            else
            {
                return 375;
            }
        }
        
        
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:section];
    
    return sectionObject.strSectionName;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        return 40.0f;
    }
    else
    {
        return 60.0f;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    UIView *headerColorView = [[UIView alloc] init];
    UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
    
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:section];
    
    imageViewArrowForsection = [[UIImageView alloc]init];
    
    imageViewArrowForsection.contentMode = UIViewContentModeScaleAspectFit;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
        [headerColorView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 38)];
        sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,40);
        sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
        [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-25,10,20,20)];
    }
    else
    {
        [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
        [headerColorView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 56)];
        sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,60);
        sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-25,20,20,20)];
    }

    if(sectionObject.isExpanded)
    {
        [UIView animateWithDuration:2 animations:^
         {
             if (sectionObject.arrayOfInnerObjects.count>0)
             {
                 imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
             }
         }
                         completion:nil];
    }
    UIImage *image = [UIImage imageNamed:@"side_Arrow.png"];
    [imageViewArrowForsection setImage:image];
    
    countLbl = [[UILabel alloc]initWithFrame:CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-45,8, 20, 20)];
    
    countLbl.textColor = [UIColor whiteColor];
    countLbl.textAlignment = NSTextAlignmentCenter;
    countLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    countLbl.layer.borderWidth = 1.0;
    countLbl.layer.masksToBounds = YES;
    countLbl.font = [UIFont fontWithName:FONT_NAME size:15.0f];

    //countLbl.text = [NSString stringWithFormat:@"%d",sectionObject.arrayOfInnerObjects.count];
    
    countLbl.layer.cornerRadius = countLbl.frame.size.width/2;

    [self setTheLabelCountText:(int)sectionObject.arrayOfInnerObjects.count];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width,9, countLbl.frame.size.width, 20);
    }
    else
    {
        countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width,20, countLbl.frame.size.width, 20);
    }
    
    [headerColorView addSubview:countLbl];
    
    [headerColorView addSubview:imageViewArrowForsection];
    
    headerView.backgroundColor = [UIColor clearColor];
    
    if([sectionObject.strSectionName isEqualToString:@"Overdue / Due Today"])
    {
        headerColorView.backgroundColor=[UIColor colorWithRed:52.0/255 green:118.0/255 blue:190.0/255 alpha:1.0];
    }
    else
    {
        headerColorView.backgroundColor=[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
    }
    
    [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
     [sectionLabelBtn addTarget:self action:@selector(btnSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sectionLabelBtn setTag:section];
    sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    
    [sectionLabelBtn setTitle:sectionObject.strSectionName forState:UIControlStateNormal];
    
    
    
    [headerColorView addSubview:sectionLabelBtn];
    [headerView addSubview:headerColorView];
    headerView.clipsToBounds = YES;
    
    return headerView;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellIdentifier= @"SMCustomCellForName";
    static NSString *cellIdentifierToday= @"SMCustomCellForTodayTableViewCell";
    
    
    SMCustomCellForTodayTableViewCell *cell;
    
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:indexPath.section];
    SMClassForToDoMemberLocationObject *rowObject = (SMClassForToDoMemberLocationObject*)[sectionObject.arrayOfInnerObjects objectAtIndex:indexPath.row];
    
    if(rowObject.isExpandable)
    {
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierToday forIndexPath:indexPath]; // Today cell
            
            cell.enlargePhotoDelegate = self;
            
            [self setAttributedTextForNewOrOverDueForRowTitleFirstText:[NSString stringWithFormat:@"%d",rowObject.strTaskID] andWithSecondText:rowObject.taskTargetClientName andWithThirdText:rowObject.strTaskName andWithNewText: @"" forLabel:cell.lblCellTitleToday];
            
            //-------------------------------------------------------------------------------------------------
            
            cell.btnDone.indexPath = indexPath;
            cell.btnNoCanDo.indexPath = indexPath;
            
            cell.btnNoCanDo.layer.cornerRadius = 4.0;
            cell.btnDone.layer.cornerRadius = 4.0;
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                cell.lblCellTitleToday.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
                cell.lblDesc.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
                cell.lblAuthorName.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
                cell.lblAssigneName.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
                
                cell.lblAuthorNameValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
                cell.lblAssigneeNameValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
                
                cell.lblNoImagesAvailable.font = [UIFont fontWithName:FONT_NAME_BOLD size:17.0];
            }
            else
            {
                cell.lblCellTitleToday.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
                cell.lblDesc.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
                cell.lblAuthorName.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
                cell.lblAssigneName.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
                
                cell.lblAuthorNameValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
                cell.lblAssigneeNameValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
                
                cell.lblNoImagesAvailable.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
            }
            
            cell.btnLoadMore.hidden = YES;
            cell.viewLineReadMore.hidden = YES;
            
            
            
            cell.lblDesc.text = rowObject.taskDetailObject.taskDetails;
            
            [ cell.btnLoadMore addTarget:self action:@selector(btnReadMoreDidClicked) forControlEvents:UIControlEventTouchUpInside];
            
            if([cell.lblDesc.text length]>44)
            {
                cell.btnLoadMore.hidden = NO;
                cell.viewLineReadMore.hidden = NO;
                self.lblTaskDetails.text = cell.lblDesc.text;
                
                [self.lblTaskDetails sizeToFit];
                self.viewForTaskDetails.frame = CGRectMake(self.viewForTaskDetails.frame.origin.x, self.view.bounds.size.height/2.0-(self.viewForTaskDetails.frame.size.height/2), self.viewForTaskDetails.frame.size.width, 40.0 + self.lblTaskDetails.frame.size.height+15.0);
            }
            else
            {
                cell.viewLineReadMore.hidden = YES;
                cell.btnLoadMore.hidden = YES;
            }
            
            cell.lblAuthorNameValue.text = rowObject.taskDetailObject.taskAuthorName;
            cell.lblAssigneeNameValue.text = rowObject.taskDetailObject.taskAssigneeName;
            
            [ cell.btnCellCollapse addTarget:self action:@selector(btnCellColapseDidClickedInSection:) forControlEvents:UIControlEventTouchUpInside];
            
            [ cell.btnDone addTarget:self action:@selector(btnDoneDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [ cell.btnNoCanDo addTarget:self action:@selector(btnNoCanDoDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.doDoMemberLocationObj = rowObject;
            [cell.sliderCollection reloadData];
        }

        
        cell.btnCellCollapse.indexPath = indexPath;
        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath]; // default cell
       

        
        if(indexPath.section!=0)
        {
            
             [self setAttributedTextForNewOrOverDueForRowTitleFirstText:[NSString stringWithFormat:@"%d",rowObject.strTaskID] andWithSecondText:rowObject.taskTargetClientName andWithThirdText:rowObject.strTaskName andWithNewText:(isMemberPeriod==YES)?[NSString stringWithFormat:@""] : @"" forLabel:cell.lblDefaultName];
            
        }
        else
        {
            
             [self setAttributedTextForNewOrOverDueForRowTitleFirstText:[NSString stringWithFormat:@"%d",rowObject.strTaskID] andWithSecondText:rowObject.taskTargetClientName andWithThirdText:rowObject.strTaskName andWithNewText:([SMGlobalClass sharedInstance].isTaskOverDue==YES)?[NSString stringWithFormat:@"(Overdue)"] : @"" forLabel:cell.lblDefaultName];
            
            
            
        }
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        cell.backgroundColor = [UIColor clearColor];
    }

    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [SMGlobalClass sharedInstance].indexpathForTaskDetails = indexPath;
    
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:indexPath.section];
    SMClassForToDoMemberLocationObject *rowObject = (SMClassForToDoMemberLocationObject*)[sectionObject.arrayOfInnerObjects objectAtIndex:indexPath.row];
    
    [SMGlobalClass sharedInstance].selectedTaskId = rowObject.strTaskID;
    if(!rowObject.isExpandable)
    {
        self.taskDetailObject = rowObject.taskDetailObject;
        [self getTheTaskDetailsCorrespondingToTheTaskID:rowObject.strTaskID];
    }
    else
    {
        rowObject.isExpandable = !rowObject.isExpandable;
        [self.tblViewToDo reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    
}

#pragma mark - textField delegate methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    return YES;
    
}

#pragma mark - scrollView Delegate Methods


#pragma mark - Custom methods

-(void)populateTheRowsArray
{
    
    if(!isMemberPeriod)
    {
        for(int i=0;i<[arrayOfMemberLocationObjects count];i++)
        {
            
            SMClassForToDoMemberLocationObject *rowObject = (SMClassForToDoMemberLocationObject*)[arrayOfMemberLocationObjects objectAtIndex:i];
            
            
            if ([self returnNumberOfDaysFromTheGivenDate:rowObject.strTaskDueDate]==1)
            {
                [SMGlobalClass sharedInstance].isTaskOverDue = YES;
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strSectionName == %@",@"Overdue / Due Today"];
                NSArray *arrayFiltered = [arrayForSections filteredArrayUsingPredicate:predicate];
                
                if ([arrayFiltered count] > 0)
                {
                    rowObject.isToday = YES;
                    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:0];
                    [sectionObject.arrayOfInnerObjects addObject:rowObject];
                    
                }
                
            }
            else if ([self returnNumberOfDaysFromTheGivenDate:rowObject.strTaskDueDate]==5)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strSectionName == %@",@"Due Tomorrow"];
                NSArray *arrayFiltered = [arrayForSections filteredArrayUsingPredicate:predicate];
                
                if ([arrayFiltered count] > 0)
                {
                    rowObject.isToday = NO;
                    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:1];
                    [sectionObject.arrayOfInnerObjects addObject:rowObject];
                    
                }
                
            }
            else if ([self returnNumberOfDaysFromTheGivenDate:rowObject.strTaskDueDate]==6)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strSectionName == %@",@"Due Day 3 to 7"];
                NSArray *arrayFiltered = [arrayForSections filteredArrayUsingPredicate:predicate];
                
                if ([arrayFiltered count] > 0)
                {
                    rowObject.isToday = NO;
                    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:2];
                    [sectionObject.arrayOfInnerObjects addObject:rowObject];
                    
                }
                
            }
            else if ([self returnNumberOfDaysFromTheGivenDate:rowObject.strTaskDueDate]==7)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strSectionName == %@",@"Due Day 8+"];
                NSArray *arrayFiltered = [arrayForSections filteredArrayUsingPredicate:predicate];
                
                if ([arrayFiltered count] > 0)
                {
                    rowObject.isToday = NO;
                    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:3];
                    [sectionObject.arrayOfInnerObjects addObject:rowObject];
                    
                }
                
            }
            
            
        }
    }
    else
    {
        for(int i=0;i<[arrayOfMemberPeriodObjects count];i++)
        {
            
            SMClassForToDoMemberLocationObject *rowObject = (SMClassForToDoMemberLocationObject*)[arrayOfMemberPeriodObjects objectAtIndex:i];
            
            
            if([self returnNumberOfDaysFromTheGivenDate:rowObject.strTaskDueDate]==2)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strSectionName == %@",@"Overdue / Due Today"];
                NSArray *arrayFiltered = [arrayForSections filteredArrayUsingPredicate:predicate];
                
                if ([arrayFiltered count] > 0)
                {
                    rowObject.isToday = NO;
                    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:0];
                    [sectionObject.arrayOfInnerObjects addObject:rowObject];
                    
                }
            }
            else if ([self returnNumberOfDaysFromTheGivenDate:rowObject.strTaskDueDate]==1)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strSectionName == %@",@"Overdue / Due Today"];
                NSArray *arrayFiltered = [arrayForSections filteredArrayUsingPredicate:predicate];
                
                if ([arrayFiltered count] > 0)
                {
                    rowObject.isToday = YES;
                    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:0];
                    [sectionObject.arrayOfInnerObjects addObject:rowObject];
                    
                }
                
            }
            else if ([self returnNumberOfDaysFromTheGivenDate:rowObject.strTaskDueDate]==5)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strSectionName == %@",@"Due Tomorrow"];
                NSArray *arrayFiltered = [arrayForSections filteredArrayUsingPredicate:predicate];
                
                if ([arrayFiltered count] > 0)
                {
                    rowObject.isToday = NO;
                    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:1];
                    [sectionObject.arrayOfInnerObjects addObject:rowObject];
                    
                }
                
            }
            else if ([self returnNumberOfDaysFromTheGivenDate:rowObject.strTaskDueDate]==6)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strSectionName == %@",@"Due Day 3 to 7"];
                NSArray *arrayFiltered = [arrayForSections filteredArrayUsingPredicate:predicate];
                
                if ([arrayFiltered count] > 0)
                {
                    rowObject.isToday = NO;
                    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:2];
                    [sectionObject.arrayOfInnerObjects addObject:rowObject];
                    
                }
                
            }
            else if ([self returnNumberOfDaysFromTheGivenDate:rowObject.strTaskDueDate]==7)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strSectionName == %@",@"Due Day 8+"];
                NSArray *arrayFiltered = [arrayForSections filteredArrayUsingPredicate:predicate];
                
                if ([arrayFiltered count] > 0)
                {
                    rowObject.isToday = NO;
                    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:3];
                    [sectionObject.arrayOfInnerObjects addObject:rowObject];
                    
                }
                
            }
            
            
        }
        
    }
    
    [self.tblViewToDo reloadData];
}

-(void)populateTheSectionsArray
{
    
    
    
    NSArray *arrayOfSectionNames = [[NSArray alloc]initWithObjects:@"Overdue / Due Today",@"Due Tomorrow",@"Due Day 3 to 7",@"Due Day 8+", nil];
    
    
    for(int i=0;i<4;i++)
    {
        SMClassForToDoObjects *sectionObject = [[SMClassForToDoObjects alloc]init];
        sectionObject.strSectionID = i+1;
        sectionObject.strSectionName = [arrayOfSectionNames objectAtIndex:i];
        [arrayForSections addObject:sectionObject];
        
    }
    
    
}

-(NSString*)returnTheStatusOfTaskForTheStateID:(int)taskStateID
{
    switch (taskStateID)
    {
        case 8:
            return @"WIP";
            break;
            
        case 11:
            return @"Done";
            break;
            
        case 16:
            return @"Closed";
            break;
            
        default:
            return @"";
            break;
    }
    return nil;
}


-(IBAction)btnCellColapseDidClickedInSection:(id)sender
{
    SMDonePlannerButton *btn = (SMDonePlannerButton*)sender;
    
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:btn.indexPath.section];
    SMClassForToDoInnerObjects *rowObject = (SMClassForToDoInnerObjects*)[sectionObject.arrayOfInnerObjects objectAtIndex:btn.indexPath.row];
    
    rowObject.isExpandable = !rowObject.isExpandable;
    
    [self.tblViewToDo reloadRowsAtIndexPaths:[NSArray arrayWithObject:btn.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    
}

-(IBAction)btnSectionTitleDidClicked:(id)sender
{
    
    NSLog(@"sender tag %ld",(long)[sender tag]);
    
   // if([sender tag] == 0)
       // return;
    
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:[sender tag]];
    sectionObject.isExpanded = !sectionObject.isExpanded;
    
   
    
    [self.tblViewToDo reloadData];
}

-(IBAction)btnDoneDidClicked:(id)sender
{
    
    
    SMDonePlannerButton *btn = (SMDonePlannerButton*)sender;
    
    taskIDForDoneTask = btn.indexPath;
    
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:btn.indexPath.section];
    SMClassForToDoMemberLocationObject *rowObject = (SMClassForToDoMemberLocationObject*)[sectionObject.arrayOfInnerObjects objectAtIndex:btn.indexPath.row];
    
    
    [self AcceptNCloseTheToDosTaskWithTaskID:rowObject.strTaskID];
    
    if([rowObject.taskDetailObject.taskAuthorName isEqualToString:rowObject.taskDetailObject.taskAssigneeName])
    {
        [self closeTheTaskToServerWithTaskID:rowObject.strTaskID];
    }

    
}

-(IBAction)btnNoCanDoDidClicked:(id)sender
{
    
    
    SMDonePlannerButton *btn = (SMDonePlannerButton*)sender;
    
    taskIDForDoneTask = btn.indexPath;
    
    SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:btn.indexPath.section];
    SMClassForToDoMemberLocationObject *rowObject = (SMClassForToDoMemberLocationObject*)[sectionObject.arrayOfInnerObjects objectAtIndex:btn.indexPath.row];
    
    [self NoCanDoTheTaskWithTaskID:rowObject.strTaskID];
    
}




-(IBAction)btnAcceptDidClicked:(id)sender
{
}

-(IBAction)btnRejectDidClicked:(id)sender
{
    [self.txtViewReason becomeFirstResponder];
    self.viewForReason.hidden = NO;
    self.viewForTaskDetails.hidden = YES;
    
    [self loadPopup];
    taskIDForRejectTask = (int)[sender tag];
}

-(void)btnReadMoreDidClicked
{
    self.viewForReason.hidden = YES;
    self.viewForTaskDetails.hidden = NO;
    [self loadPopup];
    
}


#pragma mark - UIKeyboard Notification

- (void)keyboardWasShown:(NSNotification*)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.tblViewToDo.frame = CGRectMake(self.tblViewToDo.frame.origin.x, self.tblViewToDo.frame.origin.y, self.tblViewToDo.frame.size.width, [self view].bounds.size.height - (keyboardSize.height+2.0));
   
}

- (void)keyboardWasHidden:(NSNotification*)notification
{
    self.tblViewToDo.frame = CGRectMake(self.tblViewToDo.frame.origin.x, self.tblViewToDo.frame.origin.y, self.tblViewToDo.frame.size.width, [self view].bounds.size.height);
    
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
    if([elementName isEqualToString:@"ListActivitiesForMemberXMLResult"])
    {
        isMemberPeriod = YES;
    }
    if([elementName isEqualToString:@"GetTaskDetailResult"])
    {
       // self.taskDetailObject = [[SMClassForToDoInnerObjects alloc]init];
    }
    
    if([elementName isEqualToString:@"task"])
    {
        self.locMemberObject = [[SMClassForToDoMemberLocationObject alloc]init];
    }
    
    
    currentNodeContent = [NSMutableString stringWithString:@""];
    
    
    
    
}


//The next method to implement is parser:foundCharacters:, which gets fired when the parser finds the text of an element:

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
      
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *string = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    
    if ([string isEqualToString:@"0"])
    {
        return;
    }
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}




//Finally, when the parser encounters the end of an element, it fires the parser:didEndElement:namespaceURI:qualifiedName: method:

//---when the end of element is found---

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"taskID"])
    {
        self.locMemberObject.strTaskID = [currentNodeContent intValue];
        
    }
    if([elementName isEqualToString:@"taskTitle"])
    {
        self.locMemberObject.strTaskName = currentNodeContent ;
        
    }
    if([elementName isEqualToString:@"taskDue"])
    {
        self.locMemberObject.strTaskDueDate = currentNodeContent ;
        
    }
    if([elementName isEqualToString:@"taskIsNew"])
    {
        self.locMemberObject.isTaskNew = [currentNodeContent boolValue] ;
        
    }
    if([elementName isEqualToString:@"taskTargetClientID"])
    {
        self.locMemberObject.taskTargetClientID = [currentNodeContent intValue] ;
        
    }
    if([elementName isEqualToString:@"taskTargetClientName"])
    {
        self.locMemberObject.taskTargetClientName = currentNodeContent ;
        
    }
    if([elementName isEqualToString:@"task"])
    {
        if(!isMemberPeriod)
        {
            self.locMemberObject.isExpandable = NO;
            [arrayOfMemberLocationObjects addObject:self.locMemberObject];
        }
        else
        {
            self.locMemberObject.isExpandable = NO;
            [arrayOfMemberPeriodObjects addObject:self.locMemberObject];
        }
        
        
    }
    if([elementName isEqualToString:@"ListActivitiesForMemberXMLResult"])
    {
        
        [self populateTheRowsArray];
        isMemberPeriod = NO;
        
    }
    if([elementName isEqualToString:@"ListActivitiesForMemberByLocationXMLResult"])
    {
        [self populateTheRowsArray];
    }
    
    
    
    
    if([elementName isEqualToString:@"AcceptTaskResult"])
    {
        if([currentNodeContent isEqualToString:@"OK"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@" Task accepted successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 101;
            [alert show];
            
            SMCustomCellForTodayTableViewCell *selectedCell = (SMCustomCellForTodayTableViewCell*)[self.tblViewToDo cellForRowAtIndexPath:taskIDForDoneTask];
            selectedCell.txtFieldComments.text = @"";
            
            
        }
        
    }
        
    if([elementName isEqualToString:@"RejectTaskResult"])
    {
        if([currentNodeContent isEqualToString:@"Ok"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@" Task rejected successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 201;
            [alert show];
            
        }
        
    }
    
    
    // response of  Task Details webservice
    
    if([elementName isEqualToString:@"a:Author"])
    {
        self.taskDetailObject.taskAuthorName  = currentNodeContent;
    }
    if([elementName isEqualToString:@"a:Assignee"])
    {
        self.taskDetailObject.taskAssigneeName  = currentNodeContent;
    }
    if([elementName isEqualToString:@"a:Details"])
    {
        self.taskDetailObject.taskDetails  = currentNodeContent;
    }
    if([elementName isEqualToString:@"a:DueDate"])
    {
        self.taskDetailObject.taskDueDate  = currentNodeContent;
    }
    if([elementName isEqualToString:@"a:State"])
    {
        self.taskDetailObject.taskState  = currentNodeContent.intValue;
    }
    if([elementName isEqualToString:@"a:Status"])
    {
        self.taskDetailObject.taskStatus  = currentNodeContent.boolValue;
    }
    if([elementName isEqualToString:@"a:Title"])
    {
        self.taskDetailObject.taskTitle  = currentNodeContent;
    }
    
    if([elementName isEqualToString:@"GetTaskDetailResult"])
    {
        if(self.taskDetailObject.taskStatus)
        {
            
            SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:[SMGlobalClass sharedInstance].indexpathForTaskDetails.section];
            SMClassForToDoMemberLocationObject *rowObject = (SMClassForToDoMemberLocationObject*)[sectionObject.arrayOfInnerObjects objectAtIndex:[SMGlobalClass sharedInstance].indexpathForTaskDetails.row];
            
            rowObject.isExpandable = !rowObject.isExpandable;
            rowObject.isTaskNew = NO;
            
            
            [self.tblViewToDo reloadData];
            
            
            
            SMCustomCellForTodayTableViewCell *cell = (SMCustomCellForTodayTableViewCell*)[self.tblViewToDo cellForRowAtIndexPath:[SMGlobalClass sharedInstance].indexpathForTaskDetails];
            [cell getAllTheImages];
            
        }
        
    }
    
    if([elementName isEqualToString:@"UnableToDoTaskResult"])
    {
        if([currentNodeContent isEqualToString:@"OK"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Thanks." message:@"The author of this task has been informed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            alert.tag = 101;
            [alert show];
            
        }
 
    
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
}

#pragma mark - AlertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== 101)
    {
        arrayForSections = [[NSMutableArray alloc]init];
        [self populateTheSectionsArray];
        
        [self setTheDirections];
        
        [self getAllTheMembersByPeriods];
        
    }
    
    if(alertView.tag==201)
    {
        [self dismissPopup];
        [self.txtViewReason resignFirstResponder];
        
        arrayForSections = [[NSMutableArray alloc]init];
        [self populateTheSectionsArray];
        
        [self setTheDirections];
        
        [self getAllTheMembersByPeriods];
        
        
    }
    
    
}




#pragma mark - Webservice implementation

-(void)getAllTheMembersByPeriods
{
    
    

    NSMutableURLRequest *requestURL=[SMWebServices getAllTheToDoMembersWithUserHash:[SMGlobalClass sharedInstance].hashValue andCoreMemberID:[[SMGlobalClass sharedInstance].strCoreMemberID intValue]];
    
    
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
             
             
             isMemberPeriod = NO;
             arrayOfMemberPeriodObjects = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}

-(void)getAllTheMembersByLocation
{
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices getAllTheToDoMembersForLocationWithUserHash:[SMGlobalClass sharedInstance].hashValue andCoreMemberID:[[SMGlobalClass sharedInstance].strCoreMemberID intValue] andLatitude:currentLatitude andLogitude:currentLongitude];
    
    
    
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
             
             
             isMemberPeriod = NO;
             arrayOfMemberLocationObjects = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}

-(void)closeTheTaskToServerWithTaskID:(int)taskID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    SMCustomCellForTodayTableViewCell *selectedCell = (SMCustomCellForTodayTableViewCell*)[self.tblViewToDo cellForRowAtIndexPath:taskIDForDoneTask];
    
    
    NSMutableURLRequest *requestURL=[SMWebServices closeThePlannerToDoTaskWithUserHash:[SMGlobalClass sharedInstance].hashValue andTaskID:taskID andOptionalReason:selectedCell.txtFieldComments.text];
    
    
    
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


-(void)NoCanDoTheTaskWithTaskID:(int)taskId
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices NoCanDoTaskWithUserHash:[SMGlobalClass sharedInstance].hashValue andPlannerTaskId:taskId andOptionalComment:@""];
    
    
    
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



-(void)getTheTaskDetailsCorrespondingToTheTaskID:(int)taskID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices getTheDetailsOfToDosTaskWithUserHash:[SMGlobalClass sharedInstance].hashValue andTaskID:taskID];
    
    
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

-(void)RejectTheToDosTaskWithTaskID:(int)taskID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices rejectPlannerToDoTaskWithUserHash:[SMGlobalClass sharedInstance].hashValue andTaskID:taskID andOptionalReason:self.txtViewReason.text];
    
    
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
-(void)AcceptNCloseTheToDosTaskWithTaskID:(int)taskID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices acceptPlannerToDoTaskWithUserHash:[SMGlobalClass sharedInstance].hashValue andTaskID:taskID andOptionalComment:@""];
    
    
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


#pragma mark - Getting Current Location


-(void)setTheDirections
{
    if(locationManager==nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
        [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self;
    
    [locationManager startUpdatingLocation];
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
    currentLatitude = newLocation.coordinate.latitude;
    currentLongitude = newLocation.coordinate.longitude;
}


-(int)returnNumberOfDaysFromTheGivenDate:(NSString*)stringDate
{
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *requiredDate2 = [dateFormatter dateFromString:stringDate];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *calendar1 = [NSCalendar currentCalendar];
    calendar1.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateComponents *comps1 = [calendar1 components:unitFlags fromDate:requiredDate2];
    comps1.hour   = 0;
    comps1.minute = 0;
    comps1.second = 0;
    NSDate *requiredDate1 = [calendar1 dateFromComponents:comps1];
    NSDateComponents *comps2 = [calendar1 components:unitFlags fromDate:[NSDate date]];
    comps2.hour   = 0;
    comps2.minute = 0;
    comps2.second = 0;
    NSDate *requiredDate3 = [calendar1 dateFromComponents:comps2];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:(NSDayCalendarUnit | NSHourCalendarUnit) fromDate:requiredDate3 toDate:requiredDate1 options:0];
    
      
    if(comps.day==0)
    {
        return 2;
    }
    else if(comps.day<0)
    {
        
        return 1;
    }
    else if(comps.day>0)
    {
        if(comps.day==1)
        {
            return 5;
        }
        else if(comps.day==3 || comps.day==4 || comps.day==5 || comps.day==6 || comps.day==7)
        {
            return 6;
        }
        else if(comps.day>=8)
        {
            return 7;
        }
    }
    
    return 0;
    
    
    
}


#pragma mark - Set Attributed Text


-(void)setAttributedTextForTodayWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
{
    
    
    UIFont *regularFont = [UIFont fontWithName:FONT_NAME size:13.0];
    UIFont *BoldFont = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    
    
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     BoldFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    BoldFont, NSFontAttributeName,
                                    foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:firstText
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" Author:%@ ",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" Due:%@ ",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    
    
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

-(void)setAttributedTextForDueDateWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText forLabel:(UILabel*)label
{
    
    
    UIFont *regularFont = [UIFont fontWithName:FONT_NAME size:13.0];
    UIFont *BoldFont = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    
    
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     BoldFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    NSDictionary *ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    BoldFont, NSFontAttributeName,
                                    foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:firstText
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@".  %@ ",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" Status: %@ ",thirdText]
                                                                                            attributes:ThirdAttribute];
    
    
    
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

-(void)setAttributedTextForNewOrOverDueForRowTitleFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithNewText:(NSString*)newText forLabel:(UILabel*)label
{    
    UIFont *regularFont;
    UIFont *boldFont;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        boldFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    }
    else
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        boldFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    }
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorRed = [UIColor redColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:52.0/255 green:118.0/255 blue:190.0/255 alpha:1.0];
    
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    boldFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     boldFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *THirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *NewTextAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                      regularFont, NSFontAttributeName,
                                      foregroundColorRed, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | ",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",secondText]
                                                                                             attributes:SecondAttribute];
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" | %@ ",thirdText]attributes:THirdAttribute];
    
    
    NSMutableAttributedString *attributedNewText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",newText] attributes:NewTextAttribute];
    
    
    
    [attributedThirdText appendAttributedString:attributedNewText];
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    
    [label setAttributedText:attributedFirstText];
    
    
}

-(NSMutableAttributedString*)setAttributedTextForRowTitleFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText
{
    
    
    UIFont *regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:11.0];
    UIFont *BoldFont = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor blueColor];
    
    
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    BoldFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     BoldFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
    
    NSDictionary *THirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:firstText
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" | %@ ",secondText]
                                                                                             attributes:SecondAttribute];;
    
    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" | %@ ",thirdText]
                                                                                            attributes:THirdAttribute];
    
    
    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    
    return attributedFirstText;
    
}




- (IBAction)btnCancelForReasonDidClicked:(id)sender
{
    [self dismissPopup];
    
}

- (IBAction)btnSendForReasonDidClicked:(id)sender
{
    [self RejectTheToDosTaskWithTaskID:taskIDForRejectTask];
    
}

- (IBAction)btnCancelForTaskDetailsDidClicked:(id)sender
{
    [self dismissPopup];
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

-(void)setTheLabelCountText:(int)lblCount
{
    if (lblCount<=0)
    {
        [countLbl setText:@"0"];
    }
    else
    {
        [countLbl setText:[NSString stringWithFormat:@"%d",lblCount]];
    }
    [countLbl sizeToFit];
    
    float widthWithPadding = countLbl.frame.size.width + 10.0;
    
    [countLbl setFrame:CGRectMake(countLbl.frame.origin.x, countLbl.frame.origin.y, widthWithPadding, countLbl.frame.size.height)];
}

#pragma mark - Custom Cell For Today TableView Cell Delegate

-(void)pushTheViewControllerForEnlargedImageWithObject:(FGalleryViewController*)galleyPhotoObject
{
    SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
    appdelegate.isPresented =  YES;
    [self.navigationController pushViewController:galleyPhotoObject animated:YES];
}

-(void)reloadTableView
{
    [self.tblViewToDo reloadData];
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

@end
