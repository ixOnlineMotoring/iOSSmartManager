//
//  SMReusableHeaderViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 05/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMReusableHeaderViewController.h"
#import "SMCustomHeaderView.h"
#import "SMCustomMessageCell.h"
#import "SMMessageHeaderObject.h"
#import "SMVehiclelisting.h"
#import "UIBAlertView.h"
#import "SMGlobalClass.h"
#import "SMWebServices.h"
#import "SMVariantTableViewCell.h"

const int initiallStartYear = 16; // initially Start Year as 2006 and 2006 is at 16 index

@interface SMReusableHeaderViewController ()
{
    IBOutlet UIView *viewForComments;
    
    NSArray *arrayOfFirstLabel;
    NSArray *arrayOfSecondLabel;
    NSArray *arrayOfMessageLabel;
    NSArray *arrayOfUserLabel;
    int selectedindexForMessageHeader;
}

@end

@implementation SMReusableHeaderViewController
/*
- (void)viewDidLayoutSubviews
{
    [tblViewReusableHeaderDemo reloadData];
    //[scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.btnSubmit.frame.origin.y+50)];
    //    [scrollView setContentSize:CGSizeMake(self.txtTime.frame.origin.x, self.btnSubmit.frame.origin.y+50)];
    
}*/


-(void) awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self addingProgressHUD];
     self.navigationItem.titleView = [SMCustomColor setTitle:@"Others Want"];
    
    arrayOfFirstLabel = [NSArray arrayWithObjects:@"2014 to 2015 VolksWagen Golf7 Gti", @"2011 to 2015 Audi ",@"2010 to 2012 Cheverolet CTC testing",@"2013 to 2014 Mercedes",nil];
    
    arrayOfSecondLabel = [NSArray arrayWithObjects:@"Free state | Gary Mackay",@"Free state | Johan Marshall",@"Free state | Jean Marc Laulotte", @"Free state | Kelvin Davis Smith",nil];

    arrayOfMessageLabel = [NSArray arrayWithObjects:@"2015 VolksWagen Audi Chevorelet Mercedes2015 VolksWagen 2015 VolksWagen Audi Chevorelet Mercedes2015 VolksWagen 2015 VolksWagen Audi Chevorelet Mercedes2015 VolksWagen", @"2017 VolksWagen Audi Chevorelet Mercedes", @"2017 V", @"2017 VolksWagen Audi C",nil];
    
    
    
    arrayOfUserLabel = [NSArray arrayWithObjects:@"Gary Mackay\n20 Dec 2015",@"Johan Marshall\n7 Dec 2015",@"Jean Marc Laulotte\n4 Dec 2015", @"Kelvin Davis Smith\n\n9 Dec 2015",nil];
    

    [self addingProgressHUD];
    [tblViewReusableHeaderDemo registerNib:[UINib nibWithNibName:@"SMCustomHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"SMCustomHeaderView"];
    
    [self registerNib];
    tblViewReusableHeaderDemo.estimatedSectionHeaderHeight = 150.0f;
    tblViewReusableHeaderDemo.sectionHeaderHeight = UITableViewAutomaticDimension;
    tblViewReusableHeaderDemo.estimatedRowHeight = 50.0f;
    tblViewReusableHeaderDemo.rowHeight = UITableViewAutomaticDimension;
    
   

    tblViewReusableHeaderDemo.tableFooterView = [[UIView alloc]init];
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        tblViewReusableHeaderDemo.layoutMargins = UIEdgeInsetsZero;
        tblViewReusableHeaderDemo.preservesSuperviewLayoutMargins = NO;
    }
    
    selectedFromYear        = @"2006";
    
    //Get Current Year into Current Year
    formatter       = [[NSDateFormatter alloc] init];
    [formatter         setDateFormat:@"yyyy"];
    currentYear     = [[formatter stringFromDate:[NSDate date]] intValue];
    
    selectedToYear  = [NSString stringWithFormat:@"%d",currentYear];
    
    [txtToYear setText:selectedToYear];
    [txtFromYear setText:selectedFromYear];

    
    [self guiInitializations];
     [self getYearArray];
    
    [self webserviceForRegionList];
    
    selectedMakeIndex = -1;
    selectedModelIndex = -1;
    btnHeaderFilter.selected = YES;
    CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
    
    UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
    [imgViewArrow setImage:rotatedImage];
    tblViewReusableHeaderDemo.tableHeaderView = tblHeaderView;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
}

-(void) hideProgressHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUD hide:YES];
    });
}
#pragma mark - TableView Datasource and Delegate methods

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == tblViewReusableHeaderDemo)
        return arrayOfSections.count;
    else
        return 1;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == tblViewReusableHeaderDemo)
    {
        SMCustomHeaderView *header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SMCustomHeaderView"];
        header.lblFirst.text=[NSString stringWithFormat:@"Section %ld",(long)section];
        
        header.btnMessage.tag= section;
        [header.btnMessage addTarget:self action:@selector(btnMessagesDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        SMMessageHeaderObject *sectionObj = (SMMessageHeaderObject*)[arrayOfSections objectAtIndex:section];
        
        NSString *yearString = [self returnTheExpectedStringForString:sectionObj.strDetails1];
        NSString *NameString = [self returnTheExpectedStringForStringg:sectionObj.strDetails1];
        
        [self setAttributedTextForVehicleDetailsWithFirstText:yearString andWithSecondText:NameString forLabel:header.lblFirst];
        
        header.lblSecond.text = sectionObj.strDetails2;
        
        return header;
    }
    else
        return nil;
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == tblViewReusableHeaderDemo)
    {
     SMMessageHeaderObject *sectionObj = (SMMessageHeaderObject*)[arrayOfSections objectAtIndex:section];
    
    if(sectionObj.isSectionExpanded)
        return  sectionObj.arrayOfInnerMessages.count + 1;
    }
    else if (tableView == tablePopUp)
    {
        float maxHeigthOfView = [self view].frame.size.height/2+50.0;
        float totalFrameOfView = 0.0f;
        
        switch (selectedIndex)
        {
            case 2:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([arrayMake count]*43) : 60+([arrayMake count]*60);
                break;
                
            case 3:
                totalFrameOfView = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 43+([arrayModel count]*43) : 60+([arrayModel count]*60);
                break;
        }
        
        if (totalFrameOfView <= maxHeigthOfView)
        {
            //Make View Size smaller, no scrolling
            viewTablePopUp.frame = CGRectMake(viewTablePopUp.frame.origin.x, [self view].frame.size.height/2-totalFrameOfView/2+22.0,viewTablePopUp.frame.size.width, totalFrameOfView);
        }
        else
        {
            viewTablePopUp.frame = CGRectMake(viewTablePopUp.frame.origin.x, maxHeigthOfView/2-22.0,viewTablePopUp.frame.size.width, maxHeigthOfView);
        }
        switch (selectedIndex)
        {
            case 2:
                return [arrayMake count];
                break;
                
            case 3:
                return [arrayModel count];
                break;
        }
        
    }
    else if (tableView == tableVariant)
    {
        return [arrayVariant count];
    }
    else if (tableView == tableRegion)
    {
        return [arrayRegion count];
    }
   
    return 0;
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tblViewReusableHeaderDemo)
    {

    static NSString *cellIdentifier= @"SMCustomMessageCell";
    
    SMCustomMessageCell *dynamicCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
      dynamicCell.selectionStyle=UITableViewCellSelectionStyleNone;
    SMMessageHeaderObject *sectionObj = (SMMessageHeaderObject*)[arrayOfSections objectAtIndex:indexPath.section];
       if(sectionObj.arrayOfInnerMessages.count == indexPath.row)
    {
        selectedindexForMessageHeader = (int)indexPath.section;
        txtviewComments.text = sectionObj.strComments;
        btnSubmit.layer.cornerRadius = 5.0f;
        txtviewComments.layer.borderColor = [UIColor colorWithRed:52.0f/255.0f green:118.0f/255.0f blue:190.0f/255.0f alpha:1.0f].CGColor;
        txtviewComments.layer.borderWidth = 1.0f;
        [dynamicCell.contentView addSubview:viewForComments];
        NSLog(@"viewForComments=%@",viewForComments);
        
    }
    else
    {
       // [dynamicCell layoutIfNeeded];


        SMVehiclelisting *rowObject  = (SMVehiclelisting*)[sectionObj.arrayOfInnerMessages objectAtIndex:indexPath.row];
        dynamicCell.lblMessage.text = rowObject.strMessage;
        
        NSString *firstSubstring = nil;
        NSString *secondSubstring = nil;
        
        NSRange newlineRange = [rowObject.strClientName rangeOfString:@"\n"];
        
        if(newlineRange.location != NSNotFound) {
            secondSubstring = [rowObject.strClientName substringFromIndex:newlineRange.location];
            firstSubstring = [rowObject.strClientName substringToIndex:newlineRange.location];
        }
        
        [self setAttributedTextForVehicleDetailsWithFirstText:firstSubstring andWithSecondText:secondSubstring forLabel:dynamicCell.lblUserName];
       
           }
 
        return dynamicCell;
    }
    else if (tableView == tablePopUp)
    {
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        switch (selectedIndex)
        {
            case 2:
                objectDropDown = arrayMake[indexPath.row];
                break;
                
            case 3:
                objectDropDown = arrayModel[indexPath.row];
                break;
        }
        
        [cell.textLabel setText:objectDropDown.strDropDownValue];
        
        [cell.textLabel setFont:[UIFont fontWithName:FONT_NAME size:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 15.0f : 20.0f]];
        
        return cell;
    }
    else if (tableView == tableVariant)
    {
        SMVariantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMVariantTableViewCellIdentifier"];
        
        objectDropDown = arrayVariant[indexPath.row];
        
        [cell.lblName setText:objectDropDown.strDropDownValue];
        
        if (objectDropDown.isSelected)
        {
            [cell.btnIcon setSelected:YES];
        }
        else
        {
            [cell.btnIcon setSelected:NO];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        
        return cell;
    }
    else if (tableView == tableRegion)
    {
        SMVariantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMRegionTableViewCellIdentifier"];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"strDropDownValue" ascending:YES];
        
        NSArray *sortdiscriptor=[[NSArray alloc]initWithObjects:sort, nil];
        [arrayRegion sortUsingDescriptors:sortdiscriptor];
        
        objectDropDown = arrayRegion[indexPath.row];
        
        [cell.lblName setText:objectDropDown.strDropDownValue];
        
        if (objectDropDown.isSelected)
        {
            [cell.btnIcon setSelected:YES];
        }
        else
        {
            [cell.btnIcon setSelected:NO];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        
        return cell;
    }
    return nil;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tablePopUp || tableView == tableRegion || tableView == tableVariant)
    {
        return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 40 : 60;
    }
    else
    {
        SMMessageHeaderObject *sectionObj = (SMMessageHeaderObject*)[arrayOfSections objectAtIndex:indexPath.section];
        if(sectionObj.arrayOfInnerMessages.count == indexPath.row)
        {
            return 108.0f;
        }
        return UITableViewAutomaticDimension;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==tableVariant)
    {
        objectDropDown = arrayVariant[indexPath.row];
        
        if ([objectDropDown.strDropDownValue isEqualToString:@"All"])
        {
            if (objectDropDown.isSelected==true)
            {
                for (objectDropDown in arrayVariant)
                {
                    objectDropDown.isSelected = false;
                }
            }
            else
            {
                for (objectDropDown in arrayVariant)
                {
                    objectDropDown.isSelected = true;
                }
            }
        }
        else
        {
            
            if (objectDropDown.isSelected==true)
            {
                SMDropDownObject *objDropDown = arrayVariant[0];
                
                objDropDown.isSelected = false;
                objectDropDown.isSelected = false;
            }
            else
            {
                objectDropDown.isSelected = true;
                
                NSArray *fileteredArr = [arrayVariant filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected == true"]];
                
                if((arrayVariant.count - 1) == fileteredArr.count)
                {
                    SMDropDownObject *objDropDown = arrayVariant[0];
                    
                    objDropDown.isSelected = true;
                }
            }
        }
        
        [tableVariant reloadData];
    }
    else if (tableView==tableRegion)
    {
        objectDropDown = arrayRegion[indexPath.row];
        
        if ([objectDropDown.strDropDownValue isEqualToString:@"All"])
        {
            if (objectDropDown.isSelected)
            {
                for (objectDropDown in arrayRegion)
                {
                    objectDropDown.isSelected = false;
                }
            }
            else
            {
                for (objectDropDown in arrayRegion)
                {
                    objectDropDown.isSelected = true;
                }
            }
        }
        else
        {
            if (objectDropDown.isSelected==true)
            {
                SMDropDownObject *objDropDown = arrayRegion[0];
                
                objDropDown.isSelected = false;
                objectDropDown.isSelected = false;
            }
            else
            {
                objectDropDown.isSelected = true;
                
                NSArray *fileteredArr = [arrayRegion filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSelected == true"]];
                
                if((arrayRegion.count - 1) == fileteredArr.count)
                {
                    SMDropDownObject *objDropDown = arrayRegion[0];
                    
                    objDropDown.isSelected = true;
                }
            }
        }
        
        [tableRegion reloadData];
    }
    else if (tableView==tablePopUp)
    {
        switch (selectedIndex)
        {
            case 2:
            {
                [txtModel setUserInteractionEnabled:YES];
                [txtVariant setUserInteractionEnabled:NO];
                
                makeID = [((SMDropDownObject*) arrayMake[indexPath.row]).dropDownID intValue];
                
                if (selectedMakeIndex!=indexPath.row)
                {
                    selectedMakeIndex = (int)indexPath.row;
                    selectedModelIndex      = -1;
                    [txtMake setText:((SMDropDownObject*) arrayMake[indexPath.row]).strDropDownValue];
                    [txtModel setText:@""];
                    [arrayModel removeAllObjects];
                    [txtVariant setAlpha:1.0f];
                    [tableVariant setAlpha:0.0f];
                }
            }
                break;
                
            case 3:
            {
                [txtVariant setUserInteractionEnabled:YES];
                
                modelID = [((SMDropDownObject*) arrayModel[indexPath.row]).dropDownID intValue];
                
                if (selectedModelIndex!=indexPath.row)
                {
                    selectedModelIndex = (int)indexPath.row;
                    [txtModel setText:((SMDropDownObject*) arrayModel[indexPath.row]).strDropDownValue];
                    [txtVariant setAlpha:1.0f];
                    [tableVariant setAlpha:0.0f];
                    selectedIndex = (int)txtVariant.tag;
                    [self webserviceForWantedVariant];
                }
            }
                break;
        }
        
        [self hidePopUpView];
    }
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


#pragma mark - TextView Delegate  Method


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    txtviewComments.text = @"";
    return YES;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
       {
        SMMessageHeaderObject *sectionObj = (SMMessageHeaderObject*)[arrayOfSections objectAtIndex:selectedindexForMessageHeader];
        sectionObj.strComments =   txtviewComments.text  ;
    }

}


#pragma mark - USER METHODS

- (IBAction)btnactnSubmitDidClicked:(id)sender {
  
    [txtviewComments resignFirstResponder];
    
    if([self validate])
        [self webServiceForAddingMessage];
    

}

- (BOOL)validate
{
    if (txtviewComments.text.length == 0)
    {
        SMAlert(KLoaderTitle, @"Please enter a comment");
        return NO;
    }
    else
        return YES;
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 104.0f;

}*/

-(IBAction)btnMessagesDidClicked:(UIButton*)sender
{
     SMMessageHeaderObject *sectionObject = (SMMessageHeaderObject*)[arrayOfSections objectAtIndex:[sender tag]];
     selectedIndexPath = (int)[sender tag];
    
    
    NSPredicate *predicatePages = [NSPredicate predicateWithFormat:@"isSectionExpanded == %d",YES];
    
    NSArray *arrayFilteredPages = [arrayOfSections filteredArrayUsingPredicate:predicatePages];
    
    if(!sectionObject.isSectionExpanded)
    {
        
        if(arrayFilteredPages.count >0)
        {
            for(SMMessageHeaderObject *expandedSectionObject in arrayOfSections)
            {
                expandedSectionObject.isSectionExpanded = NO;
            }
            
        }
        
    }
    
   
         sectionObject.isSectionExpanded = !sectionObject.isSectionExpanded;

     [tblViewReusableHeaderDemo reloadData];
    

    
    NSLog(@"selected button index = %ld",(long)[sender tag]);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateTheSectionArray
{
    
    arrayOfSections = [[NSMutableArray alloc]init];
    
    for(int i = 0; i<arrayOfFirstLabel.count;i++)
    {
        SMMessageHeaderObject *sectionObject = [[SMMessageHeaderObject alloc]init];
        sectionObject.strDetails1 = [arrayOfFirstLabel objectAtIndex:i];
        sectionObject.strDetails2 = [arrayOfSecondLabel objectAtIndex:i];
       
        
        for(int j=0;j<arrayOfMessageLabel.count;j++)
        {
         SMVehiclelisting *messageObj = [self populateTheRowsArrayForIndex:j];
         [sectionObject.arrayOfInnerMessages addObject:messageObj]; // inner array
        }
        [arrayOfSections addObject:sectionObject]; // main array
      
    
    }

}

-(SMVehiclelisting*)populateTheRowsArrayForIndex:(int)index
{
         arrayOfMessages = [[NSMutableArray alloc]init];
    
        SMVehiclelisting *rowObject = [[SMVehiclelisting alloc]init];
        
        rowObject.strClientName = [arrayOfUserLabel objectAtIndex:index];
        rowObject.strMessage = [arrayOfMessageLabel objectAtIndex:index];
    
        return rowObject;
    
        //[arrayOfMessages addObject:rowObject];
    
    
}


-(void) registerNib
{
    
    
    
     [tblViewReusableHeaderDemo registerNib:[UINib nibWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? @"SMCustomMessageCell" : @"SMCustomMessageCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMCustomMessageCell"];
    
    [tableVariant registerNib:[UINib nibWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? @"SMVariantTableViewCell" : @"SMVariantTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMVariantTableViewCellIdentifier"];
    
    [tableRegion registerNib:[UINib nibWithNibName:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? @"SMVariantTableViewCell" : @"SMVariantTableViewCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMRegionTableViewCellIdentifier"];
   
}

-(IBAction)btnCancelDidClicked:(id)sender
{
    [self hidePopUpView];
}
-(IBAction)btnDoneDidClicked:(id)sender
{
    switch (selectedIndex)
    {
        case 0:
            [txtToYear     setText:@""];
            [txtFromYear   setText:arrayYears[selectedRowFromYear]];
            [txtToYear     setUserInteractionEnabled:YES];
            [txtMake       setUserInteractionEnabled:NO];
            [txtModel      setUserInteractionEnabled:NO];
            [txtVariant    setUserInteractionEnabled:NO];
            
            selectedRowToYear = arrayYears.count-1;
            break;
            
        case 1:
            [txtMake       setUserInteractionEnabled:YES];
            [txtModel      setUserInteractionEnabled:NO];
            [txtVariant    setUserInteractionEnabled:NO];
            
            if (selectedRowToYear>=selectedRowFromYear)
            {
                [txtToYear setText:arrayYears[selectedRowToYear]];
            }
            else
            {
                [txtToYear setText:@""];
                selectedRowToYear = arrayYears.count-1;
                
                SMAlert(KLoaderTitle, KProperYear);
            }
            break;
    }
    
    [txtMake setText:@""];
    [txtModel setText:@""];
    makeID = 0;
    modelID = 0;
    [arrayMake removeAllObjects];
    [arrayModel removeAllObjects];
    [tableVariant setAlpha:0.0f];
    [txtVariant setAlpha:1.0f];
    [self hidePopUpView];
}

- (IBAction)btnListDidClicked:(id)sender
{
    tblHeaderView.frame = CGRectMake(tblHeaderView.frame.origin.x, tblHeaderView.frame.origin.y, tblHeaderView.frame.size.width, 38);
    
    CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
    
    UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
    [imgViewArrow setImage:rotatedImage];
    
    tblViewReusableHeaderDemo.tableHeaderView = tblHeaderView;
    
    
    [self populateTheSectionArray];
    [tblViewReusableHeaderDemo reloadData];

}

- (IBAction)btnClearDidClicked:(id)sender
{
    [txtModel      setText:@""];
    [txtMake       setText:@""];
    [txtVariant   setText:@""];
    [txtFromYear   setText:selectedFromYear];
    [txtToYear     setText:selectedToYear];
    [arrayVariant removeAllObjects];
    //[tableVariant setAlpha:0.0f];
    [tableVariant reloadData];
    
    
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    if (textField == txtFromYear)
    {
        selectedIndex = (int)txtFromYear.tag;
        
        [viewPickerPopUp setHidden:NO];
        [viewTablePopUp setHidden:YES];
        
        [pickerYear selectRow:selectedRowFromYear inComponent:0 animated:YES];
        
        if (arrayYears.count>0)
        {
            [self loadPopUpView];
        }
        
        return NO;
    }
    else if (textField == txtToYear)
    {
        selectedIndex = (int)txtToYear.tag;
        
        [viewPickerPopUp setHidden:NO];
        [viewTablePopUp setHidden:YES];
        
        [pickerYear selectRow:selectedRowToYear inComponent:0 animated:YES];
        
        if (arrayYears.count>0)
        {
            [self loadPopUpView];
        }
        
        return NO;
    }
    else if (textField == txtMake)
    {
        selectedIndex = (int)txtMake.tag;
        
        [viewPickerPopUp setHidden:YES];
        [viewTablePopUp setHidden:NO];
        
        if (arrayMake.count>0)
        {
            [tablePopUp reloadData];
            [self loadPopUpView];
        }
        else
        {
            [self webserviceForWantedMakes];
        }
        
        return NO;
    }
    else if (textField == txtModel)
    {
        selectedIndex = (int)txtModel.tag;
        
        [viewPickerPopUp setHidden:YES];
        [viewTablePopUp setHidden:NO];
        
        if (arrayModel.count>0)
        {
            [tablePopUp reloadData];
            [self loadPopUpView];
        }
        else
        {
            [self webserviceForWantedModel];
        }
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark -  UIPickerView Delegate & Datasource

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrayYears count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrayYears objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (selectedIndex)
    {
        case 0:
            selectedRowFromYear = row;
            break;
            
        case 1:
            selectedRowToYear = row;
            break;
    }
}


#pragma mark - Webservice methods

-(void)webServiceForAddingMessage
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices addMessageToVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockID:48 andMessage:txtviewComments.text];
    
    // NSMutableURLRequest *requestURL = [SMWebServices listMessagesForVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockID:self.selectedVehicleObj.strUsedVehicleStockID.intValue];
    
    
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
          //   NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)webserviceForWantedMakes
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices getMakeWithUserHash:[SMGlobalClass sharedInstance].hashValue withFromYear:[txtFromYear.text intValue] withToYear:[txtToYear.text intValue]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             [self hideProgressHUD];
             SMAlert(@"Error", connectionError.localizedDescription);
             return;
         }
         else
         {
             arrayMake = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)webserviceForWantedModel
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices getModelWithUserHash:[SMGlobalClass sharedInstance].hashValue withMakeID:makeID withFromYear:[txtFromYear.text intValue] withToYear:[txtToYear.text intValue]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             [self hideProgressHUD];
             SMAlert(@"Error", connectionError.localizedDescription);
             return;
         }
         else
         {
             arrayModel = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)webserviceForWantedVariant
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices getVariantWithUserHash:[SMGlobalClass sharedInstance].hashValue withModelID:modelID withFromYear:[txtFromYear.text intValue] withToYear:[txtToYear.text intValue]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             [self hideProgressHUD];
             SMAlert(@"Error", connectionError.localizedDescription);
             return;
         }
         else
         {
             arrayVariant = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

- (void)webserviceForRegionList
{
    //    [HUD show:YES];
    //    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices getRegionListWithUserHash:[SMGlobalClass sharedInstance].hashValue];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             [self hideProgressHUD];
             SMAlert(@"Error", connectionError.localizedDescription);
             return;
         }
         else
         {
             arrayRegion = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}


#pragma mark - XML Parsing DeleGate

-(void) parser:(NSXMLParser *)    parser
didStartElement:(NSString *)   elementName
  namespaceURI:(NSString *)      namespaceURI
 qualifiedName:(NSString *)     qName
    attributes:(NSDictionary *)    attributeDict
{
    if ([elementName isEqualToString:@"Make"] || [elementName isEqualToString:@"model"] || [elementName isEqualToString:@"Variant"] || [elementName isEqualToString:@"Region"] || [elementName isEqualToString:@"Search"])
    {
        objectDropDown  = [[SMDropDownObject alloc] init];
    }
       
    currentNodeContent = [NSMutableString stringWithString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"SUCCESS"])
    {
        
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Message submitted successfully" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel)
            {
                [self hideProgressHUD];
                
                SMVehiclelisting *addedMessageObject = [[SMVehiclelisting alloc]init];
                addedMessageObject.strMessage = txtviewComments.text;
                
                addedMessageObject.strClientName = [NSString stringWithFormat:@"%@\n\nJust Now",[SMGlobalClass sharedInstance].strName];
                
                SMMessageHeaderObject *sectionObject = (SMMessageHeaderObject*)[arrayOfSections objectAtIndex:selectedIndexPath];
                [sectionObject.arrayOfInnerMessages addObject:addedMessageObject];
                [tblViewReusableHeaderDemo reloadData];
                return;
                
            }
            
        }];
        
        
    }
    
    // Table Header filters
    
    if([elementName isEqualToString:@"id"] || [elementName isEqualToString:@"ID"])
    {
        objectDropDown.dropDownID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"name"] || [elementName isEqualToString:@"Name"])
    {
        objectDropDown.strDropDownValue = currentNodeContent;
        objectDropDown.isSelected = false;
    }
    if ([elementName isEqualToString:@"Make"])
    {
        [arrayMake addObject:objectDropDown];
    }
    if ([elementName isEqualToString:@"model"])
    {
        [arrayModel addObject:objectDropDown];
    }
    if ([elementName isEqualToString:@"ListMakesXMLResult"])
    {
        [tablePopUp reloadData];
        
        if (arrayMake.count>0)
        {
            [self loadPopUpView];
        }
        else
        {
            SMAlert(KLoaderTitle, KNorecordsFousnt);
        }
    }
    if ([elementName isEqualToString:@"ListModelsXMLResult"])
    {
        [tablePopUp reloadData];
        
        if (arrayModel.count>0)
        {
            [self loadPopUpView];
        }
        else
        {
            SMAlert(KLoaderTitle, KNorecordsFousnt);
        }
    }
    
    // for getting all regions
    if ([elementName isEqualToString:@"Region"])
    {
        [arrayRegion addObject:objectDropDown];
    }
    
    // for getting all variants
    if ([elementName isEqualToString:@"Variant"])
    {
        [arrayVariant addObject:objectDropDown];
    }
    
    if ([elementName isEqualToString:@"ListVariantsXMLResult"])
    {
        if (arrayVariant.count>0)
        {
            SMDropDownObject *objDrop = [SMDropDownObject new];
            objDrop.isSelected = false;
            objDrop.strDropDownValue = @"All";
            objDrop.dropDownID = 0;
            
            [arrayVariant insertObject:objDrop atIndex:0];
            [tableVariant setAlpha:1.0f];
            [txtVariant setAlpha:0.0f];
        }
        else
        {
            [tableVariant setAlpha:0.0f];
            [txtVariant setAlpha:1.0f];
        }
        
        [tableVariant reloadData];
    }
    if ([elementName isEqualToString:@"RegionListResult"])
    {
        if (arrayRegion.count>0)
        {
            SMDropDownObject *objDrop = [SMDropDownObject new];
            objDrop.isSelected = false;
            objDrop.strDropDownValue = @"All";
            objDrop.dropDownID = 0;
            
            [arrayRegion insertObject:objDrop atIndex:0];
        }
        
        [tableRegion reloadData];
    }

    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self hideProgressHUD];
    NSLog(@"MESSAGES array = %lu",(unsigned long)arrayOfMessages.count);
   
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
    
    
    
    
    
    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",firstText]
                                                                                           attributes:FirstAttribute];
    
    
    
    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];
    
    
    
    
    
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];
    
    
}

-(NSString*)returnTheExpectedStringForString:(NSString*)inputString
{
    inputString = [inputString substringToIndex:4];
    return inputString;
}
-(NSString*)returnTheExpectedStringForStringg:(NSString*)inputString
{
    inputString = [inputString substringFromIndex:5];
    return inputString;
    
}


- (void)guiInitializations
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [btnDone.titleLabel            setFont:[UIFont fontWithName:FONT_NAME      size:15.0f]];
        [btnCancel.titleLabel          setFont:[UIFont fontWithName:FONT_NAME      size:15.0f]];
        txtVariant.placeholder         = @" Select Variant";
    }
    else
    {
        [btnDone.titleLabel            setFont:[UIFont fontWithName:FONT_NAME      size:20.0f]];
        [btnCancel.titleLabel          setFont:[UIFont fontWithName:FONT_NAME      size:20.0f]];
        txtVariant.placeholder         = @" Select Variant";
    }
    
    // NSAttributedString *lostPasswordAttributedString = [[NSAttributedString alloc]initWithString:@"Search All" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithRed:52.0f/255.0f green:118.0f/255.0f blue:190.0f/255.0f alpha:1.0f]}];
    
    
    txtVariant.layer.borderColor   = [[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    txtVariant.layer.borderWidth   = 0.8f;
    txtVariant.placeholderColor    = [UIColor whiteColor];
    
    viewRegion.layer.borderColor    = [[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    viewRegion.layer.borderWidth    = 0.8f;
    
    tableVariant.layer.borderColor   = [[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    tableVariant.layer.borderWidth   = 0.8f;
    
    txtviewComments.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    txtviewComments.layer.borderWidth= 0.8f;
   // txtviewComments.placeholder = @"Write Comments...";
    
    viewTablePopUp.layer.cornerRadius  = 10.0;
    viewTablePopUp.clipsToBounds       = YES;
    
    viewPickerPopUp.layer.cornerRadius  = 10.0;
    viewPickerPopUp.clipsToBounds       = YES;
    
    [tablePopUp  setTableFooterView:[[UIView alloc]init]];
    
    [btnHeaderFilter       setSelected:YES];
    
    
    [tableVariant setAlpha:0.0f];
    [txtVariant setAlpha:1.0f];
    
    /*isClicked = NO;
     
     selectedMakeIndex = -1;
     selectedModelIndex = -1;*/
}
-(IBAction)btnHeaderFilterDidClicked:(id)sender
{
    
    btnHeaderFilter.selected = !btnHeaderFilter.selected;
    
    

    if(btnHeaderFilter.selected)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {

        tblHeaderView.frame = CGRectMake(tblHeaderView.frame.origin.x, tblHeaderView.frame.origin.y, tblHeaderView.frame.size.width, 460);
        }
        else
        {
        tblHeaderView.frame = CGRectMake(tblHeaderView.frame.origin.x, tblHeaderView.frame.origin.y, tblHeaderView.frame.size.width, 770);
        }
        
        CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
        
        UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight];
        [imgViewArrow setImage:rotatedImage];
    }
    else
    {
        tblHeaderView.frame = CGRectMake(tblHeaderView.frame.origin.x, tblHeaderView.frame.origin.y, tblHeaderView.frame.size.width, 38);
        
        CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
        
        UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
        [imgViewArrow setImage:rotatedImage];
    }
    

    tblViewReusableHeaderDemo.tableHeaderView = tblHeaderView;
    
}
- (void)getYearArray
{
    formatter       = [[NSDateFormatter alloc] init];
    [formatter         setDateFormat:@"yyyy"];
    currentYear     = [[formatter stringFromDate:[NSDate date]] intValue];
    
    arrayYears = [[NSMutableArray alloc]init];
    
    for (int fromYear = 1990; fromYear<=currentYear; fromYear++)
    {
        [arrayYears addObject:[NSString stringWithFormat:@"%d",fromYear]];
    }
    
    // initially Start Year as 2006 and 2006 is at 16th index
    
    selectedRowFromYear = initiallStartYear;
    
    // by default selected year will current year
    
    selectedRowToYear = arrayYears.count-1;
    
    [pickerYear reloadAllComponents];
}

#pragma mark - Load/Hide Drop Down For Make, Model And Variants

-(void)loadPopUpView
{
    [popupView setFrame:[UIScreen mainScreen].bounds];
    [popupView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [popupView setAlpha:0.0];
    
    [[[UIApplication sharedApplication]keyWindow]addSubview:popupView];
    [popupView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    
    [UIView animateWithDuration:0.1 animations:^
     {
         [popupView setAlpha:0.75];
         [popupView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [popupView setAlpha:1.0];
              
              [popupView setTransform:CGAffineTransformIdentity];
              
          }
                          completion:^(BOOL finished)
          {
          }];
     }];
}

-(void) hidePopUpView
{
    [popupView setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popupView];
    [UIView animateWithDuration:0.1 animations:^{
        [popupView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [popupView setAlpha:0.3];
              [popupView setTransform:CGAffineTransformMakeScale(0.9,0.9)];
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   
                   [popupView setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [popupView removeFromSuperview];
                   [popupView setTransform:CGAffineTransformIdentity];
               }];
          }];
     }];
}



@end
