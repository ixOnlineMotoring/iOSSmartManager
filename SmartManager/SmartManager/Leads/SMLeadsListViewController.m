//

//  SMLeadsListViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 29/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMLeadsListViewController.h"
#import "SMMyLeadsCustomCell.h"
#import "SMClassForToDoObjects.h"
#import "SMMyLeadsDetailViewController.h"
#import  "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMClassForToDoInnerObjects.h"
#import "SMCustomColor.h"
@interface SMLeadsListViewController ()

@end

@implementation SMLeadsListViewController

@synthesize popUpView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNib];
    
    isSectionFirstOpened =  NO;
    isSectionSecondOpened = NO;
    isBothSectionsClosed = YES;
    isPaginationForWIPLeads = NO;
    
    tempSearchStringSecondSection = @"";
    tempSearchStringFirstSection = @"";
    
    tempSortStringSecondSection = @"";
    tempSortStringFirstSection = @"";
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
         self.lblSearchKey.font = [UIFont fontWithName:FONT_NAME size:12.0];
    else
         self.lblSearchKey.font = [UIFont fontWithName:FONT_NAME size:15.0];
    
    arrayForSections = [[NSMutableArray alloc]init];
    [self populateTheSectionsArray];
    
    arrayOfWIPLeads=[[NSMutableArray alloc]init];
    arrayOfUnseenLeads = [[NSMutableArray alloc]init];
    
    [self addingProgressHUD];
    pageNumberWIPCount=0;
    pageNumberUnseenCount = 0;
    
    [self.txtFieldSortBy setDelegate:self];
    
    self.arraySortFilter = [[NSMutableArray alloc] init];
    self.txtFieldSortBy.enabled = NO;
   // isSortByOptionDisabled = YES;
    isSeen = NO;
  
    iTotalArrayCountUnseen = 0;
    iTotalArrayCount = 0;
    sortByOptionSelectedWIP = 3;
    sortByOptionSelectedUnseen = 1;
    self.txtFieldSortBy.text = @"";
    self.tblViewMyLeadsList.tableHeaderView = self.headerView;
    self.tblViewMyLeadsList.tableFooterView = [[UIView alloc]init];
    
    [self loadUnseenLeadsListFromServer];
    
   
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    
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
    //[self.view endEditing:YES];
    [self.txtFieldSearch resignFirstResponder];
}


-(void)refreshTheLeadListModule
{
    pageNumberWIPCount=0;
    pageNumberUnseenCount = 0;
    isSeen = NO;
    isSectionFirstOpened =  NO;
    isSectionSecondOpened = NO;
    iTotalArrayCountUnseen = 0;
    iTotalArrayCount = 0;
    [arrayOfUnseenLeads removeAllObjects];
    [arrayOfWIPLeads removeAllObjects];
    
    [self loadUnseenLeadsListFromServer];
   
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textfield text = %@",self.txtFieldSearch.text);
    
    [textField resignFirstResponder];
    if (textField == self.txtFieldSearch)
    {
        
        if([self.txtFieldSearch.text length]!=0)
        {
            
            if(sectionNumberSelected == 0)
            {
                tempSearchStringFirstSection = self.txtFieldSearch.text;
               // tempSearchStringSecondSection = @"";
            }
            else
            {
                tempSearchStringSecondSection = self.txtFieldSearch.text;
                //tempSearchStringFirstSection = @"";
            }
            
            if(isBothSectionsClosed)
            {
                return NO;
            }
            
            if(isSectionFirstOpened)
            {
                 pageNumberUnseenCount = 0;
                iTotalArrayCountUnseen = 0;
                [arrayOfUnseenLeads removeAllObjects];
                [self loadUnseenLeadsListFromServer];

            }
            else
            {
                pageNumberWIPCount=0;
                iTotalArrayCount = 0;
                [arrayOfWIPLeads removeAllObjects];
                [self loadWIPLeadsListFromServer];
                
            }
           
        }
        else
        {
            
            if(sectionNumberSelected == 0)
            {
                tempSearchStringFirstSection = @"";
                [arrayOfUnseenLeads removeAllObjects];
                pageNumberUnseenCount = 0;
                isSeen = NO;
                isSectionFirstOpened =  YES;
                isSectionSecondOpened = NO;
                iTotalArrayCountUnseen = 0;
                [self loadUnseenLeadsListFromServer];


            }
            else
            {
                tempSearchStringSecondSection = @"";
                [arrayOfWIPLeads removeAllObjects];
                pageNumberWIPCount = 0;
                isSeen = NO;
                isSectionFirstOpened =  NO;
                isSectionSecondOpened = YES;
                iTotalArrayCount = 0;
                [self loadWIPLeadsListFromServer];
            }
            
          
            
        }
        
        NSLog(@"firstSectionSearch = %@",tempSearchStringFirstSection);
        NSLog(@"secondSectionSearch = %@",tempSearchStringSecondSection);

        
        return NO;
    }
    return YES;

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if (textField == self.txtFieldSortBy)
    {
       // NSLog(@"isSortByOptionDisabled = %d",isSortByOptionDisabled);
        
        [self.view endEditing:YES];
        if(isSortByOptionDisabled == NO )
          [self loadPopup];
        return NO;

    }
    else
    return YES;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField != self.txtFieldSearch && textField != self.txtFieldSortBy )
    {
    int length = [self getLength:textField.text];
    //NSLog(@"Length  =  %d ",length);
    
    if(length == 10)
    {
        if(range.length == 0)
            return NO;
    }
    
    if(length == 3)
    {
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"%@ ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6)
    {
        NSString *num = [self formatNumber:textField.text];
        //NSLog(@"%@",[num  substringToIndex:3]);
        //NSLog(@"%@",[num substringFromIndex:3]);
        textField.text = [NSString stringWithFormat:@"%@ %@",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@ %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    }
    
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = (int)[mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    
    return mobileNumber;
}


-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    
    return length;
    
    
}





#pragma mark - tableView delegate methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView == self.tblViewMyLeadsList)
        return  [arrayForSections count];
    else
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   /* if(section == 0)
    {
        if([tempSearchStringFirstSection length] == 0)
            self.txtFieldSearch.text = @"";
        else
            self.txtFieldSearch.text = tempSearchStringFirstSection;
    }
    else
    {
        if([tempSearchStringSecondSection length] == 0)
            self.txtFieldSearch.text = @"";
        else
            self.txtFieldSearch.text = tempSearchStringSecondSection;

    }*/
    
    
    if (tableView == self.tblViewMyLeadsList)
    {
        
        SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:section];
        
        if (sectionObject.isExpanded)
        {
             if(section == 0)
                 return arrayOfUnseenLeads.count;
                 
            return arrayOfWIPLeads.count;
           
        }
        else
        {
            return 0;
        }
    }
    else
    {
        
        float maxHeigthOfView = [self view].frame.size.height/2+50.0;
        float totalFrameOfView = 0.0f;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            totalFrameOfView = 32+([self.arraySortFilter count]*43);
        }
        else
        {
            totalFrameOfView = 45+([self.arraySortFilter count]*60);
        }
        
        if (totalFrameOfView <= maxHeigthOfView)
        {
            //Make View Size smaller, no scrolling
            self.innerPopUpView.frame = CGRectMake(self.innerPopUpView.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0, self.innerPopUpView.frame.size.width, totalFrameOfView);
        }
        else
        {
            self.innerPopUpView.frame = CGRectMake(self.innerPopUpView.frame.origin.x, maxHeigthOfView/2-22.0, self.innerPopUpView.frame.size.width, maxHeigthOfView);
        }

        
        
               return self.arraySortFilter.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tblViewMyLeadsList)
    {
        
        CGFloat finalDynamicHeight = 0.0f;
        UILabel *lblVehicleDetails3 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 311, 21)];

        
        SMLeadListObject *rowObject;
        if(indexPath.section == 0)
        {
            rowObject = (SMLeadListObject*)[arrayOfUnseenLeads objectAtIndex:indexPath.row];
        }
        else
        {
            rowObject = (SMLeadListObject*)[arrayOfWIPLeads objectAtIndex:indexPath.row];
        }

        
                
        CGFloat heightName = 0.0f;
        
        NSString *strLeadNameHeight = [NSString stringWithFormat:@"%d | %@",rowObject.leadID,rowObject.leadTitle];
        
        heightName = [self heightForText:strLeadNameHeight];
        
        CGFloat heightDetails1 = 0.0f;
        
        NSString *strVehicleDetails1 = rowObject.leadVehicleName;
        
        heightDetails1 = [self heightForText:strVehicleDetails1];
        
        
        CGFloat heightDetails2 = 0.0f;
        
        NSString *strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@",rowObject.leadMobileNumber,rowObject.leadEmailID];
        
        heightDetails2 = [self heightForText:strVehicleDetails2];
        
        CGFloat heightDetails3 = 0.0f;
        
        NSString *finalTime = [self returnTheRequiredTimeFortheString:rowObject.leadLastUpdateDate];
        
        if(finalTime.length > 0)
        {
            
            if ([finalTime hasPrefix:@"Red"])
            {
                rowObject.isRedColorText = YES;
                
                finalTime = [finalTime stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
                
                if (rowObject.isRedColorText)
                {
                    lblVehicleDetails3.textColor = [UIColor redColor];
                }
                else
                {
                    lblVehicleDetails3.textColor = [UIColor colorWithRed:64.0/255 green:198.0/255 blue:42.0/255 alpha:1.0];
                }
                
                
            }
            else
            {
                rowObject.isRedColorText = NO;
                
                finalTime = [finalTime stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
                
                if (rowObject.isRedColorText)
                {
                    lblVehicleDetails3.textColor = [UIColor redColor];
                }
                else
                {
                    lblVehicleDetails3.textColor = [UIColor colorWithRed:64.0/255 green:198.0/255 blue:42.0/255 alpha:1.0];
                }
                
                
            }
            
            lblVehicleDetails3.text= finalTime;
            lblVehicleDetails3.text = [NSString stringWithFormat:@"Last Update: %@ | %@",finalTime,rowObject.leadLastUpdateAction];
            
        }
        else
        {
            
            NSString *finalTime = [self returnTheRequiredTimeFortheString:[NSString stringWithFormat:@"A%@",rowObject.leadTime]];
            
            
            if ([finalTime hasPrefix:@"Red"])
            {
                rowObject.isRedColorText = YES;
                
                finalTime = [finalTime stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
            }
            lblVehicleDetails3.text = [NSString stringWithFormat:@"No Update: %@",finalTime];
            lblVehicleDetails3.textColor = [UIColor redColor];
            
            rowObject.isRedColorText = YES;
            
            if (rowObject.isRedColorText)
            {
                lblVehicleDetails3.textColor = [UIColor redColor];
            }
            else
            {
                lblVehicleDetails3.textColor = [UIColor colorWithRed:64.0/255 green:198.0/255 blue:42.0/255 alpha:1.0];
            }
            
        }

          heightDetails3 = [self heightForText:lblVehicleDetails3.text];

            finalDynamicHeight = (heightName + heightDetails1 + heightDetails2 + heightDetails3 + 21.0);
        
            return finalDynamicHeight+8;
        
    }
    
    return 40.0f;
    
}


/*- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}*/

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.tblViewMyLeadsList)
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
    
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.tblViewMyLeadsList)
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
        sectionLabelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;

        [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-25,10,20,20)];
    }
    else
    {
        [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
        [headerColorView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 56)];
        sectionLabelBtn.frame = CGRectMake(7, 0, tableView.bounds.size.width,60);
        sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
       // sectionLabelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
       // [sectionLabelBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [sectionLabelBtn setTitleEdgeInsets:UIEdgeInsetsMake(-7.0, 5.0, 0.0, 0.0)];


        [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-25,20,20,20)];
    }
    
    if(sectionObject.isExpanded)
    {
        [UIView animateWithDuration:2 animations:^
         {
             if(section == 0)
             {
             
                 if (arrayOfUnseenLeads.count>0)
                 imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                
             }
             else
             {
                 if (arrayOfWIPLeads.count>0)
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
    countLbl.layer.cornerRadius = countLbl.frame.size.width/2;
    
    if (![sectionObject.strSectionName isEqualToString:@"Unseen"])
    {
            /* if(iTotalArrayCount>0)
                isSortByOptionDisabled = NO;
            else
            {}
                 //isSortByOptionDisabled = YES;*/
        
            [self setTheLabelCountText:iTotalArrayCount];
        NSLog(@"Called 1");
    }
    else
    {
        /*if(iTotalArrayCountUnseen>0)
            isSortByOptionDisabled = NO;
        else
            //isSortByOptionDisabled = YES;*/
    
        [self setTheLabelCountText:iTotalArrayCountUnseen];
        NSLog(@"Called 2");

    }
        

    
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
    
    if(sectionObject.strSectionID == 1)
    {
        headerColorView.backgroundColor= [SMCustomColor setBlueColorThemeButton];
    }
    else
    {
        headerColorView.backgroundColor=[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
    }
    
    [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sectionLabelBtn addTarget:self action:@selector(btnSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sectionLabelBtn setTag:section];// set the tag for each section
    sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
        NSLog(@"sectionLabelBtn.tag %d",(int)sectionLabelBtn.tag);
    [sectionLabelBtn setTitle:sectionObject.strSectionName forState:UIControlStateNormal];
    [headerColorView addSubview:sectionLabelBtn];
    [headerView addSubview:headerColorView];
    headerView.clipsToBounds = YES;
    
    return headerView;
}
    
    return 0;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"RowsCnt = %ld",(long)[self.tblViewMyLeadsList numberOfRowsInSection:1]);
    if(tableView == self.tblSortingOption)
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
        }
        else
        {
            cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
        }

        cell.textLabel.text = [self.arraySortFilter objectAtIndex:indexPath.row];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        return cell;
        
    }
    else
    {
    
        static NSString *cellIdentifier= @"SMMyLeadsCustomCell";
        
        SMMyLeadsCustomCell *dynamicCell;
        
        SMLeadListObject *rowObject;
        if(indexPath.section == 0)
        {
            rowObject = (SMLeadListObject*)[arrayOfUnseenLeads objectAtIndex:indexPath.row];
        }
        else
        {
           rowObject = (SMLeadListObject*)[arrayOfWIPLeads objectAtIndex:indexPath.row];
        }
            
        
        UILabel *leadName;
        UILabel *lblVehicleDetails1;
        UILabel *lblVehicleDetails2;
        UILabel *lblVehicleDetails3;
        UILabel *lblTempVehicleDetails3;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            lblTempVehicleDetails3 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 311, 21)];
        }
        else
        {
            lblTempVehicleDetails3 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 750, 25)];

        }
        
        
        CGFloat heightName = 0.0f;
        
        NSString *strLeadNameHeight = [NSString stringWithFormat:@"%d | %@",rowObject.leadID,rowObject.leadTitle];
        
        heightName = [self heightForText:strLeadNameHeight];
        
        CGFloat heightDetails1 = 0.0f;
        
        NSString *strVehicleDetails1 = rowObject.leadVehicleName;
        
        heightDetails1 = [self heightForText:strVehicleDetails1];
        
        
        CGFloat heightDetails2 = 0.0f;
        
         NSString *strVehicleDetails2 = [NSString stringWithFormat:@"%@ | %@",rowObject.leadMobileNumber,rowObject.leadEmailID];
        
        heightDetails2 = [self heightForText:strVehicleDetails2];
        
        
        CGFloat heightDetails3 = 0.0f;
        
        NSString *finalTime = [self returnTheRequiredTimeFortheString:rowObject.leadLastUpdateDate];
        
        if(finalTime.length > 0)
        {
            
            if ([finalTime hasPrefix:@"Red"])
            {
                rowObject.isRedColorText = YES;
                
                finalTime = [finalTime stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
                
                if (rowObject.isRedColorText)
                {
                    lblTempVehicleDetails3.textColor = [UIColor redColor];
                }
                else
                {
                    lblTempVehicleDetails3.textColor = [UIColor colorWithRed:64.0/255 green:198.0/255 blue:42.0/255 alpha:1.0];
                }
                
                
            }
            else
            {
                rowObject.isRedColorText = NO;
                
                finalTime = [finalTime stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
                
                if (rowObject.isRedColorText)
                {
                    lblTempVehicleDetails3.textColor = [UIColor redColor];
                }
                else
                {
                    lblTempVehicleDetails3.textColor = [UIColor colorWithRed:64.0/255 green:198.0/255 blue:42.0/255 alpha:1.0];
                }
                
                
            }
            
            lblTempVehicleDetails3.text= finalTime;
            lblTempVehicleDetails3.text = [NSString stringWithFormat:@"Last Update: %@ | %@",finalTime,rowObject.leadLastUpdateAction];
            
        }
        else
        {
            
            NSString *finalTime = [self returnTheRequiredTimeFortheString:[NSString stringWithFormat:@"A%@",rowObject.leadTime]];
            
            
            if ([finalTime hasPrefix:@"Red"])
            {
                rowObject.isRedColorText = YES;
                
                finalTime = [finalTime stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
            }
            lblTempVehicleDetails3.text = [NSString stringWithFormat:@"No Update: %@",finalTime];
            lblTempVehicleDetails3.textColor = [UIColor redColor];
            
            rowObject.isRedColorText = YES;
            
            if (rowObject.isRedColorText)
            {
                lblTempVehicleDetails3.textColor = [UIColor redColor];
            }
            else
            {
                lblTempVehicleDetails3.textColor = [UIColor colorWithRed:64.0/255 green:198.0/255 blue:42.0/255 alpha:1.0];
            }
            
        }

        
        heightDetails3 = [self heightForText:lblTempVehicleDetails3.text];
        
        lblTempVehicleDetails3 = nil;
        
        
        if (dynamicCell == nil)
        {
            dynamicCell = [[SMMyLeadsCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            leadName = [[UILabel alloc]init];
            lblVehicleDetails1 = [[UILabel alloc]init];
            lblVehicleDetails2 = [[UILabel alloc]init];
            lblVehicleDetails3 = [[UILabel alloc]init];

            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                
                leadName.frame = CGRectMake(6.0, 6.0, 311.0, heightName);
                lblVehicleDetails1.frame = CGRectMake(6.0, leadName.frame.origin.y + leadName.frame.size.height+4.0, 311.0, heightDetails1);
                lblVehicleDetails2.frame = CGRectMake(6.0, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+4.0, 311.0, heightDetails2);
                lblVehicleDetails3.frame = CGRectMake(6.0, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+4.0, 311.0, heightDetails3);
                
                
                leadName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
                lblVehicleDetails3.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
               
                
                
                
            }
            else
            {
                leadName.frame = CGRectMake(8.0, 8.0, 677.0, heightName);
                lblVehicleDetails1.frame = CGRectMake(8.0, leadName.frame.origin.y + leadName.frame.size.height+4.0, 677.0, heightDetails1);
                lblVehicleDetails2.frame = CGRectMake(8.0, lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height+4.0, 677.0, heightDetails2);
                lblVehicleDetails3.frame = CGRectMake(8.0, lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height+4.0, 677.0, heightDetails3);
                
                
                leadName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                lblVehicleDetails3.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
                
            }
            
            leadName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
            lblVehicleDetails1.textColor = [UIColor whiteColor];
            lblVehicleDetails2.textColor = [UIColor whiteColor];
            lblVehicleDetails3.textColor = [UIColor whiteColor];
            

            
            leadName.tag = 101;
            lblVehicleDetails1.tag = 103;
            lblVehicleDetails2.tag = 104;
            lblVehicleDetails3.tag = 105;
            
            [self setAttributedTextForVehicleDetailsWithFirstText:[NSString stringWithFormat:@"%d",rowObject.leadID] andWithSecondText:rowObject.leadTitle forLabel:leadName];
            
           lblVehicleDetails1.text = rowObject.leadVehicleName;
            lblVehicleDetails2.text = [NSString stringWithFormat:@"%@ | %@",rowObject.leadMobileNumber,rowObject.leadEmailID];
            
            NSString *finalTime = [self returnTheRequiredTimeFortheString:rowObject.leadLastUpdateDate];
            
            if(finalTime.length > 0)
            {
                
                if ([finalTime hasPrefix:@"Red"])
                {
                    rowObject.isRedColorText = YES;
                    
                    finalTime = [finalTime stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
                    
                    if (rowObject.isRedColorText)
                    {
                        lblVehicleDetails3.textColor = [UIColor redColor];
                    }
                    else
                    {
                        lblVehicleDetails3.textColor = [UIColor colorWithRed:64.0/255 green:198.0/255 blue:42.0/255 alpha:1.0];
                    }
                    
                    
                }
                else
                {
                    rowObject.isRedColorText = NO;
                    
                    finalTime = [finalTime stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
                    
                    if (rowObject.isRedColorText)
                    {
                        lblVehicleDetails3.textColor = [UIColor redColor];
                    }
                    else
                    {
                        lblVehicleDetails3.textColor = [UIColor colorWithRed:64.0/255 green:198.0/255 blue:42.0/255 alpha:1.0];
                    }
                    
                    
                }
                
                lblVehicleDetails3.text= finalTime;
                lblVehicleDetails3.text = [NSString stringWithFormat:@"Last Update: %@ | %@",finalTime,rowObject.leadLastUpdateAction];
                
            }
            else
            {
                
                NSString *finalTime = [self returnTheRequiredTimeFortheString:[NSString stringWithFormat:@"A%@",rowObject.leadTime]];
                
                
                if ([finalTime hasPrefix:@"Red"])
                {
                    rowObject.isRedColorText = YES;
                    
                    finalTime = [finalTime stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
                }
                lblVehicleDetails3.text = [NSString stringWithFormat:@"No Update: %@",finalTime];
                lblVehicleDetails3.textColor = [UIColor redColor];
                
                rowObject.isRedColorText = YES;
                
                if (rowObject.isRedColorText)
                {
                    lblVehicleDetails3.textColor = [UIColor redColor];
                }
                else
                {
                    lblVehicleDetails3.textColor = [UIColor colorWithRed:64.0/255 green:198.0/255 blue:42.0/255 alpha:1.0];
                }
                
            }

            
            [dynamicCell.contentView addSubview:leadName];
            [dynamicCell.contentView addSubview:lblVehicleDetails1];
            [dynamicCell.contentView addSubview:lblVehicleDetails2];
            [dynamicCell.contentView addSubview:lblVehicleDetails3];
            
            
        }
        
        
        leadName.numberOfLines = 0;
        [leadName sizeToFit];
        
        lblVehicleDetails1.numberOfLines = 0;
        [lblVehicleDetails1 sizeToFit];
        
        
        lblVehicleDetails2.numberOfLines = 0;
        [lblVehicleDetails2 sizeToFit];
        
        lblVehicleDetails3.numberOfLines = 0;
        [lblVehicleDetails3 sizeToFit];
        
        
        leadName.backgroundColor = [UIColor blackColor];
        lblVehicleDetails1.backgroundColor = [UIColor blackColor];
        lblVehicleDetails2.backgroundColor = [UIColor blackColor];
        lblVehicleDetails3.backgroundColor = [UIColor blackColor];
        
        if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
        {
            dynamicCell.layoutMargins = UIEdgeInsetsZero;
            dynamicCell.preservesSuperviewLayoutMargins = NO;
        }
        dynamicCell.backgroundColor = [UIColor blackColor];
        
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        if(indexPath.section == 1)
        {
            
            if (arrayOfWIPLeads.count-1 == indexPath.row)
            {
                
                if (arrayOfWIPLeads.count !=iTotalArrayCount)
                {
                    ++pageNumberWIPCount;
                    isPaginationForWIPLeads = YES;
                    [self loadWIPLeadsListFromServer];
                    
                }
            }
        }
        else
        {
            if (arrayOfUnseenLeads.count-1 == indexPath.row)
            {
                
                if (arrayOfUnseenLeads.count !=iTotalArrayCountUnseen)
                {
                    
                    NSLog(@"TESTTT %d  %d",isSectionFirstOpened,isSectionSecondOpened);
                    ++pageNumberUnseenCount;
                    [self loadUnseenLeadsListFromServer];
                    NSLog(@"THIS 5");
                }
                
            }
            
        }

        
        return dynamicCell;
        
    }
    
    return 0;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.txtFieldSearch resignFirstResponder];
    
    if(tableView == self.tblSortingOption)
    {
        NSLog(@"indexpath.Section = %d",sectionNumberSelected);
         NSLog(@"indexpath.Row = %ld",(long)indexPath.row);
        
        if(sectionNumberSelected == 1)
        {
            switch (indexPath.row)
            {
                case 0:
                    sortByOptionSelectedWIP = 3;
                    break;
                case 1:
                    sortByOptionSelectedWIP = 2;
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            switch (indexPath.row)
            {
                case 0:
                    sortByOptionSelectedUnseen = 1;
                    break;
                case 1:
                    sortByOptionSelectedUnseen = 2;
                    break;
                    
                default:
                    break;
            }

        }
        
        
        
        [self.txtFieldSortBy setText:[self.arraySortFilter objectAtIndex:indexPath.row]];
        [self dismissPopup];
        if(isSectionFirstOpened)
            tempSortStringFirstSection = self.txtFieldSortBy.text;
        else
            tempSortStringSecondSection = self.txtFieldSortBy.text;

        pageNumberWIPCount=0;
        pageNumberUnseenCount = 0;
        isSeen = NO;
        
        if(isSectionFirstOpened)
        {
             iTotalArrayCountUnseen = 0;
             [arrayOfUnseenLeads removeAllObjects];
            [self loadUnseenLeadsListFromServer];
        }
        else
        {
            NSLog(@"Sort Option selected = %d",sortByOptionSelectedWIP);
            iTotalArrayCount = 0;
            [arrayOfWIPLeads removeAllObjects];
            [self loadWIPLeadsListFromServer];

        }
        
        
        
    }
    else
    {
       /* SMMyLeadsCustomCell * cell = (SMMyLeadsCustomCell*) [tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"didselect frame=%@",NSStringFromCGRect(cell.lblEmailID.frame));
        cell.lblEmailID.frame = cell.lblPhoneNum.frame;*/
        
        
        
        
        SMLeadListObject *rowObjectDidSelect;
        
        if(indexPath.section == 0)
             rowObjectDidSelect = (SMLeadListObject*)[arrayOfUnseenLeads objectAtIndex:indexPath.row];
        else
            rowObjectDidSelect = (SMLeadListObject*)[arrayOfWIPLeads objectAtIndex:indexPath.row];
        
        
        SMMyLeadsDetailViewController *leadDetailVC = [[SMMyLeadsDetailViewController alloc] initWithNibName:@"SMMyLeadsDetailViewController" bundle:nil];
        
        leadDetailVC.leadID =rowObjectDidSelect.leadID;
        leadDetailVC.listRefreshDelegate = self;
        [self.navigationController pushViewController:leadDetailVC animated:YES];

    }
    
    
}


- (CGFloat)heightForText:(NSString *)bodyText
{
    
    UIFont *cellFont;
    float textSize =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
        textSize = 311;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        textSize = 677;
    }
    CGSize constraintSize = CGSizeMake(textSize, MAXFLOAT);
    CGRect textRect = [bodyText boundingRectWithSize:constraintSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:cellFont}
                                             context:nil];
    
    CGSize labelSize = textRect.size;
    CGFloat height = labelSize.height;
    
    return height;

}


- (void)registerNib
{
    
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
    listActiveSpecialsNavigTitle.text = @"My Leads";
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
    
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
         [self.tblViewMyLeadsList registerNib:[UINib nibWithNibName:@"SMMyLeadsCustomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMMyLeadsCustomCell"];
       
    }
    else
    {
        [self.tblViewMyLeadsList registerNib:[UINib nibWithNibName:@"SMMyLeadsCustomCell_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMMyLeadsCustomCell"];
    
    }
    
    self.innerPopUpView.layer.cornerRadius=15.0;
    self.innerPopUpView.clipsToBounds      = YES;
    self.innerPopUpView.layer.borderWidth=1.5;
    self.innerPopUpView.layer.borderColor=[[UIColor blackColor] CGColor];
    
 }

-(void)populateTheSectionsArray
{
    
    NSArray *arrayOfSectionNames = [[NSArray alloc]initWithObjects:@"Unseen",@"Work in progress", nil];
    
    for(int i=0;i<2;i++)
    {
        SMClassForToDoObjects *sectionObject = [[SMClassForToDoObjects alloc]init];
        sectionObject.strSectionID = i+1;
        sectionObject.strSectionName = [arrayOfSectionNames objectAtIndex:i];
        [arrayForSections addObject:sectionObject];
        
    }
    
    
}

-(void)populateTheRowsArray
{
    
     SMClassForToDoObjects *sectionObject1 = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:0];
    [sectionObject1.arrayOfInnerObjects removeAllObjects];
    SMClassForToDoObjects *sectionObject2 = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:1];
    [sectionObject2.arrayOfInnerObjects removeAllObjects];

    
     for(int i=0;i<[arrayOfWIPLeads count];i++)
     {
            
            SMLeadListObject *rowObject = (SMLeadListObject*)[arrayOfWIPLeads objectAtIndex:i];
            
            if(rowObject.isSeen == NO)
            {
                
                sectionObject1 = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:0];
                [sectionObject1.arrayOfInnerObjects addObject:rowObject];
            }
            else
            {
                sectionObject2 = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:1];
                [sectionObject2.arrayOfInnerObjects addObject:rowObject];
            }
     }
            
      [self.tblViewMyLeadsList reloadData];
    
}



#pragma mark - UIKeyboard Notification

- (void)keyboardWasShown:(NSNotification*)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.tblViewMyLeadsList.frame = CGRectMake(self.tblViewMyLeadsList.frame.origin.x, self.tblViewMyLeadsList.frame.origin.y, self.tblViewMyLeadsList.frame.size.width, [self view].bounds.size.height - (keyboardSize.height+2.0));
    
}

- (void)keyboardWasHidden:(NSNotification*)notification
{
    self.tblViewMyLeadsList.frame = CGRectMake(self.tblViewMyLeadsList.frame.origin.x, self.tblViewMyLeadsList.frame.origin.y, self.tblViewMyLeadsList.frame.size.width, [self view].bounds.size.height);
    
}

#pragma mark - Webservice Implementation


-(void)loadWIPLeadsListFromServer
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [HUD show:YES];
       [HUD setLabelText:KLoaderText];
   // NSLog(@"superview = %@ %d", HUD.superview, HUD.hidden);
    });
    
    
    isSeen = YES;
    NSLog(@"this44");
    //NSLog(@"page counter is %d",pageNumberWIPCount);
    
    NSMutableURLRequest *requestURL=[SMWebServices getTheLeadsListWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andKeyword:self.txtFieldSearch.text andOrder:sortByOptionSelectedWIP andPageNum:pageNumberWIPCount andPageSize:10 andSeenStatus:1];
    
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
             [xmlParser parse];
         }
     }];
}

-(void)loadUnseenLeadsListFromServer
{
   
        [HUD show:YES];
        [HUD setLabelText:KLoaderText];
        isSeen = NO;
    NSLog(@"thiss 33");
   // NSLog(@"page counter is %d",pageNumberWIPCount);
    
    NSMutableURLRequest *requestURL=[SMWebServices getTheLeadsListWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[[SMGlobalClass sharedInstance].strClientID intValue] andKeyword:self.txtFieldSearch.text andOrder:sortByOptionSelectedUnseen andPageNum:pageNumberUnseenCount andPageSize:10 andSeenStatus:0];
    
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
             [xmlParser parse];
             
         }
     }];
}







#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    
    if(!HUD)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    
    [self.navigationController.view addSubview:HUD];
    HUD.color = [UIColor blackColor];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}

-(void) hideProgressHUD
{
   
    [HUD hide:YES];
    
}

#pragma mark - xmlParserDelegate
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    
    NSLog(@"elementName = %@", elementName);
    
    if ([elementName isEqualToString:@"Lead"])
    {
       leadObj=[[SMLeadListObject alloc]init];
       leadObj.arrOfVehicleDetails = [[NSMutableArray alloc]init];
        
    }
    if ([elementName isEqualToString:@"Vehicle"])
    {
        leadVehicleObj = [[SMListVehicleDetailsObject alloc]init];
    }
    currentNodeContent = [NSMutableString stringWithString:@""];
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *str = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"CurrentNode = %@",currentNodeContent);
    
    if ([elementName isEqualToString:@"ID"])
    {
       leadObj.leadID = [currentNodeContent intValue];
        
        
    }
    else if ([elementName isEqualToString:@"Vehicle"])
    {
        isVehicleDetailsPresent = NO;
        
            if ([currentNodeContent hasPrefix:@"Unknown"] )
            {
                leadObj.leadVehicleName = currentNodeContent;
            }
            else if (leadVehicleObj.leadVehicleMakeAsked.length > 0)
            {
                leadObj.leadVehicleName = [NSString stringWithFormat:@"%@ %@ %@",leadVehicleObj.leadVehicleYearAsked,leadVehicleObj.leadVehicleMakeAsked,leadVehicleObj.leadVehicleModelAsked];
            }
            else if ([currentNodeContent length] != 0)
            {
                leadObj.leadVehicleName = currentNodeContent;
            }
            else
            {
               leadObj.leadVehicleName=@"Vehicle Info?";
            }
    }
    else if ([elementName isEqualToString:@"MakeAsked"])
    {
        if([currentNodeContent length] > 0 && ![currentNodeContent isEqualToString:@"Unknown"])
        {
            isVehicleDetailsPresent = YES;
            leadVehicleObj.leadVehicleMakeAsked = currentNodeContent;
        }
        else if ([currentNodeContent isEqualToString:@"Unknown"])
        {
            isVehicleDetailsPresent = YES;
            leadVehicleObj.leadVehicleMakeAsked = currentNodeContent;
        }
    }
    else if ([elementName isEqualToString:@"ModelAsked"])
    {
        if([currentNodeContent length] > 0 && ![currentNodeContent isEqualToString:@"Unknown"])
        {
            isVehicleDetailsPresent = YES;
            leadVehicleObj.leadVehicleModelAsked = currentNodeContent;
        }
        else if ([currentNodeContent isEqualToString:@"Unknown"])
        {
            isVehicleDetailsPresent = YES;
            leadVehicleObj.leadVehicleModelAsked = currentNodeContent;
        }
    }
    else if ([elementName isEqualToString:@"YearAsked"])
    {
        if([currentNodeContent length] > 0 && ![currentNodeContent isEqualToString:@"Unknown"])
        {
            isVehicleDetailsPresent = YES;
            leadVehicleObj.leadVehicleYearAsked = currentNodeContent;
        }
        else if ([currentNodeContent isEqualToString:@"Unknown"])
        {
            isVehicleDetailsPresent = YES;
             leadVehicleObj.leadVehicleYearAsked = currentNodeContent;
        }
    }
    
    else if ([elementName isEqualToString:@"Type"])
    {
         leadVehicleObj.leadVehicleType = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Matched"])
        leadVehicleObj.leadVehicleMatched = currentNodeContent.boolValue;
        else if ([elementName isEqualToString:@"MileageAsked"])
        leadVehicleObj.leadVehicleMileageAsked = currentNodeContent;
    else if ([elementName isEqualToString:@"ColourAsked"])
        leadVehicleObj.leadVehicleColorAsked = currentNodeContent;
    else if ([elementName isEqualToString:@"PriceAsked"])
        leadVehicleObj.leadVehiclePriceAsked = currentNodeContent;
    
    else if ([elementName isEqualToString:@"Name"])
    {
        if([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"Not Given Not Given"])
        {
            leadObj.leadTitle =@"Lead name?";

        }
        else
        {
            leadObj.leadTitle =currentNodeContent;

        }
        NSLog(@"LeadTitle = %@",currentNodeContent);
    }
    else if ([elementName isEqualToString:@"Email"])
    {
        if ([currentNodeContent isEqualToString:@""] || [currentNodeContent isEqualToString:@"Not Given"])
        {
            leadObj.leadEmailID =@"Email address?";
        }
        else
        {
            leadObj.leadEmailID =currentNodeContent;
        }
    }
    else if ([elementName isEqualToString:@"Mobile"])
    {
        
        if ([currentNodeContent isEqualToString:@""])
        {
            leadObj.leadMobileNumber=@"Phone number?";
        }
        else
        {
            NSString* formattedNumber = [self formatPhoneNumber:currentNodeContent];
            leadObj.leadMobileNumber=formattedNumber;
        }
    }
    else if ([elementName isEqualToString:@"Age"])
    {
        
        leadObj.leadTime = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"LastUpdateDate"])
    {
        leadObj.leadLastUpdateDate = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"LastUpdate"])
    {
        leadObj.leadLastUpdateAction = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Total"])
    {
        
        if (isSeen == YES)
        {
            iTotalArrayCount = [currentNodeContent intValue];
            
        }
        else
        {
         
            iTotalArrayCountUnseen = [currentNodeContent intValue];
        }
    }
    if ([elementName isEqualToString:@"Lead"])
    {
       
        if (isSeen == NO)
        {
            leadObj.isSeen = NO;
            NSLog(@"thiss 44");
            [arrayOfUnseenLeads addObject:leadObj];
        }
        else
        {
            leadObj.isSeen = YES;
            [arrayOfWIPLeads addObject:leadObj];
        }
        
        
        
    }
    
    if ([elementName isEqualToString:@"ListResult"] )
    {
        NSLog(@"isSectionFirstOpened = %d",isSectionFirstOpened);
        NSLog(@"isSectionSecondOpened = %d",isSectionSecondOpened);
        
       
        if (isSectionFirstOpened == NO && isSectionSecondOpened == NO)
        {
            isSectionFirstOpened = YES;
            isSectionSecondOpened = YES;
           // [self performSelectorOnMainThread:@selector(loadWIPLeadsListFromServer) withObject:nil waitUntilDone:YES];
           // [self performSelector:@selector(loadWIPLeadsListFromServer) withObject:nil afterDelay:0.1];
            
           // dispatch_async(dispatch_get_main_queue(), ^{
                [self loadWIPLeadsListFromServer];
                
           // });
           
        }
       /* else
        {
             [self hideProgressHUD];
        
        }*/
        

    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"isSeennn = %d",isSeen);
    NSLog(@"isSectionFirstOpeneddddd = %d",isSectionFirstOpened);
    
    if(isSectionFirstOpened)
    {
        if(isSeen == NO)
        {
            self.tblViewMyLeadsList.indicatorStyle = UIScrollViewIndicatorStyleWhite;
            [self.tblViewMyLeadsList reloadData];
        }
    }
    
    
    if(isSeen == YES)
    {
        self.tblViewMyLeadsList.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        [self.tblViewMyLeadsList reloadData];
    }
    
    
    [self hideProgressHUD];

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


-(IBAction)btnSectionTitleDidClicked:(id)sender
{
     UIButton *button = (UIButton *)sender;
    
    NSLog(@"firstSectionSearch = %@",tempSearchStringFirstSection);
    NSLog(@"secondSectionSearch = %@",tempSearchStringSecondSection);
    
    
        if(button.tag ==  1)
         {
             if(![self.txtFieldSortBy.text isEqualToString:@"Alphabetical"])
                self.txtFieldSortBy.text = @"Update Urgency";
             
         }
         else
         {
             if(![self.txtFieldSortBy.text isEqualToString:@"Alphabetical"])
             self.txtFieldSortBy.text = @"Date Received";
             
        }
    
    
     sectionNumberSelected = (int)button.tag;
    
    if(sectionNumberSelected == 0)
    {
         if([tempSearchStringFirstSection length] !=0)
             self.txtFieldSearch.text = tempSearchStringFirstSection;
         else
            self.txtFieldSearch.text = @"";
    }
    else
    {
        if([tempSearchStringSecondSection length] !=0)
            self.txtFieldSearch.text = tempSearchStringSecondSection;
        else
            self.txtFieldSearch.text = @"";

    }
    
    
    
    
    NSLog(@"STATUS %d %d",isSectionFirstOpened,isSectionSecondOpened);
    
    
    [self.arraySortFilter removeAllObjects];
    
    NSLog(@"[sender tag] %d",(int)button.tag);
    
   
    
    if (button.tag ==  0)
    {
        SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:button.tag];
        sectionObject.isExpanded = !sectionObject.isExpanded;
        
        SMClassForToDoObjects *sectionObject1 = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:1];
        sectionObject1.isExpanded = NO;
        
        NSLog(@"TempSortfirst = %@",tempSortStringFirstSection);
        NSLog(@"TempSortsecond = %@",tempSortStringSecondSection);

        
        if([tempSortStringFirstSection length] != 0)
            self.txtFieldSortBy.text = tempSortStringFirstSection;
        else
            self.txtFieldSortBy.text = @"Date Received";
        
       [self.tblViewMyLeadsList reloadData];
    }
    else
    {
        SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:button.tag];
        sectionObject.isExpanded = !sectionObject.isExpanded;
        
        SMClassForToDoObjects *sectionObject1 = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:0];
        sectionObject1.isExpanded = NO;
        
        NSLog(@"TempSortfirst = %@",tempSortStringFirstSection);
        NSLog(@"TempSortsecond = %@",tempSortStringSecondSection);
        
        if([tempSortStringSecondSection length] != 0)
            self.txtFieldSortBy.text = tempSortStringSecondSection;
        else
            self.txtFieldSortBy.text = @"Update Urgency";
        
        [self.tblViewMyLeadsList reloadData];

    }
    
     if([sender tag] == 0)
     {
         NSInteger num = [self.tblViewMyLeadsList numberOfRowsInSection:0];
         self.txtFieldSearch.text = @"";
         if(num == 0)
         {
             self.txtFieldSortBy.enabled = NO;
             self.txtFieldSortBy.text = @"";
             isBothSectionsClosed = YES;
             isSortByOptionDisabled = YES;
         }
         else
         {
             self.txtFieldSortBy.enabled = YES;
             isSortByOptionDisabled = NO;
              isBothSectionsClosed = NO;
         }
         isSectionFirstOpened =  YES;
         //isSectionFirstOpened =  !isSectionFirstOpened;
         isSectionSecondOpened = NO;
         
          //[self.arraySortFilter addObject:@"None"];
          [self.arraySortFilter addObject:@"Date Received"];
          [self.arraySortFilter addObject:@"Alphabetical"];
          [self.tblSortingOption reloadData];
         
     }
    else
    {
        NSInteger num = [self.tblViewMyLeadsList numberOfRowsInSection:1];
        self.txtFieldSearch.text = @"";
        if(num == 0)
        {
            self.txtFieldSortBy.enabled = NO;
            self.txtFieldSortBy.text = @"";
            isBothSectionsClosed = YES;
            isSortByOptionDisabled = YES;
        }
        else
        {
            self.txtFieldSortBy.enabled = YES;
            isSortByOptionDisabled = NO;
            isBothSectionsClosed = NO;
        }
        
        isSectionFirstOpened =  NO;
        //isSectionSecondOpened = !isSectionSecondOpened;
        isSectionSecondOpened = YES;
        
        //[self.arraySortFilter addObject:@"None"];
        [self.arraySortFilter addObject:@"Update Urgency"];
        [self.arraySortFilter addObject:@"Alphabetical"];
        [self.tblSortingOption reloadData];
    }
    
    
}

-(NSString*)returnTheRequiredTimeFortheString:(NSString*)inputString
{
    
    if(inputString.length == 0)
        return @"";
    
    else if ([inputString hasPrefix:@"A"])
    {
        inputString = [inputString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        
        NSArray *firstar = [inputString componentsSeparatedByString:@":"];
        
        
        
        if([[firstar objectAtIndex:0] intValue] != 0 )
        {
            
            NSString *properStr;
            
            if([[firstar objectAtIndex:0] intValue] == 1)
                properStr = @"day" ;
            else
                properStr = @"days";
            
            
            return [NSString stringWithFormat:@"%d %@  ago",[[firstar objectAtIndex:0] intValue],properStr];
            
        }
        
        else if ([[firstar objectAtIndex:1] intValue] != 0)
        {
            
            NSString *properStr;
            
            if([[firstar objectAtIndex:1] intValue] == 1)
                properStr = @"hour" ;
            else
                properStr = @"hours";
            
            return [NSString stringWithFormat:@"%d %@  ago",[[firstar objectAtIndex:1] intValue],properStr];
            
            
        }
        else if ([[firstar objectAtIndex:2] intValue] != 0 )
        {
            
            NSString *properStr;
            
            if([[firstar objectAtIndex:2] intValue] == 1)
                properStr = @"min" ;
            else
                properStr = @"mins";
            
            if([[firstar objectAtIndex:2] intValue]>5)
                return [NSString stringWithFormat:@"%d %@  ago",[[firstar objectAtIndex:2] intValue],properStr];
                        
        }

        
              
        return @"";
    }
    else
    {
    
    NSArray *firstar = [inputString componentsSeparatedByString:@":"];
    
    if([[firstar objectAtIndex:0] intValue] != 0 )
    {
       
         NSString *properStr;
        
        if([[firstar objectAtIndex:0] intValue] == 1)
            properStr = @"day" ;
        else
            properStr = @"days";
        
        
        if([[firstar objectAtIndex:0] intValue]>7)
            return [NSString stringWithFormat:@"Red%d %@  ago",[[firstar objectAtIndex:0] intValue],properStr];
        else
            return [NSString stringWithFormat:@"Green%d %@  ago",[[firstar objectAtIndex:0] intValue],properStr];
        

    
    }
    else if ([[firstar objectAtIndex:1] intValue] != 0)
    {
    
        NSString *properStr;
        
        if([[firstar objectAtIndex:1] intValue] == 1)
            properStr = @"hour" ;
        else
            properStr = @"hours";
        
            return [NSString stringWithFormat:@"Green%d %@  ago",[[firstar objectAtIndex:1] intValue],properStr];
        
    
    }
    else if ([[firstar objectAtIndex:2] intValue] != 0 )
    {
    
        NSString *properStr;
        
        if([[firstar objectAtIndex:2] intValue] == 1)
            properStr = @"min" ;
        else
            properStr = @"mins";
        
        if([[firstar objectAtIndex:2] intValue]>5)
            return [NSString stringWithFormat:@"Green%d %@  ago",[[firstar objectAtIndex:2] intValue],properStr];
        else
            return [NSString stringWithFormat:@"Green%d %@  ago",[[firstar objectAtIndex:2] intValue],properStr];
        
    }
    
      return @"Just Now";
    }
}


#pragma mark- load popup
-(void)loadPopup
{
    
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (vc != self)
        return;
    
    
    [popUpView setFrame:[UIScreen mainScreen].bounds];
    [popUpView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [popUpView setAlpha:0.0];
    
    
    [[[UIApplication sharedApplication]keyWindow]addSubview:popUpView];
    
    [popUpView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [popUpView setAlpha:0.75];
         [popUpView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [popUpView setAlpha:1.0];
              [popUpView setTransform:CGAffineTransformIdentity];
              
          }
                          completion:^(BOOL finished)
          {
          
              [self.tblSortingOption reloadData];
              
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

-(IBAction)buttonCancelPopupView:(id)sender
{
    [self dismissPopup];
}



-(NSString*) formatPhoneNumber:(NSString *)phoneNumber
{
    //000 000 0000
    
    NSMutableString *stringts = [NSMutableString stringWithString:phoneNumber];
    if([phoneNumber length] == 10)
    {
        [stringts insertString:@" " atIndex:3];
        [stringts insertString:@" " atIndex:7];
    }
    else if([phoneNumber length] > 10)
    {
        [stringts insertString:@" " atIndex:3];
        [stringts insertString:@" " atIndex:7];
        [stringts insertString:@" " atIndex:11];
    }
    else
    {
    
    }
    
    NSString *formattedString = [NSString stringWithString:stringts];
    return formattedString;
}

#pragma mark - Set Attributed Text


-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    
    // Create the attributes
    
    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];
    
    
    
    
    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];
    
   
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | ",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}

@end
