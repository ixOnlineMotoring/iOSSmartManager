//
//  SMCustomPopUpSearchTableView.m
//  Smart Manager
//
//  Created by Liji Stephen on 29/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMCustomPopUpSearchTableView.h"
#import "SMDropDownObject.h"
#import "SMLoadVehiclesObject.h"
#import "SMLoadVehicleTableViewCell.h"
#import "SMGlobalClass.h"

@implementation SMCustomPopUpSearchTableView

void(^ getTheSelectedDataResponseCallBack)(NSString *selectedTextValue, int selectIDValue, int selectedYear, NSString *strVehicleStockId);


#pragma mark - TextFilelds Methods


-(BOOL)textField:(SMCustomTextFieldSearch *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
     [downloadingQueue cancelAllOperations];
    
    
   // [SMGlobalClass sharedInstance].strHoldPreviousSearchString = resultString;
    return YES;
    
}


-(BOOL)textFieldShouldBeginEditing:(SMCustomTextFieldSearch *)textField{
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField.text length] != 0)
    {
        
        [textField resignFirstResponder];
        [self.paginationDelegateSearch requestForTheSearchListWithSearchKeyword:txtSearchField.text withIsFirstSearch:YES];
    }
    else
    {
         [self dismissPopup];
        [arrOfDropdown removeAllObjects];
        [tblViewDropDownData reloadData];
        
        [self.paginationDelegateSearch requestForThePaginationSearchWithIsFirstPagination:YES];
    }
    
    return YES;
}

#pragma mark - Tableview datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOfDropdown.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(isVariant)
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            return 65.0f;
        }
        else
        {
            return 65.0f;
        }
        
    }
    
    else{
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            return 43.0;
        }
        else
        {
            return 60.0f;
        }
        
    }
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"RowID = %ld", (long)indexPath.row);
    
    if(isVariant)
    {
        static NSString *cellIdentifier= @"VariantListing";//SMLoadVehicleTableViewCell
        
        SMLoadVehicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            cell.lableVariantName.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
            cell.lableVarinatCodeWithyear.font = [UIFont fontWithName:FONT_NAME_BOLD size:12.0];
            
        }
        else
        {
            cell.lableVariantName.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
            cell.lableVarinatCodeWithyear.font = [UIFont fontWithName:FONT_NAME_BOLD size:16.0];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        
        cell.accessoryType =UITableViewCellAccessoryNone;
        SMDropDownObject *selectTypeObj = (SMDropDownObject*)[arrOfDropdown objectAtIndex:indexPath.row];
        
        
        [cell.lableVariantName      setText:selectTypeObj.strMakeName];
        if(isVehicle)
        {
        [cell.lableVarinatCodeWithyear setText:[NSString stringWithFormat:@"%@|%@|%@",selectTypeObj.strMakeYear,selectTypeObj.strMeanCodeNumber,selectTypeObj.strColor]];
            
            if (arrOfDropdown.count-1 == indexPath.row)
            {
                
                if([txtSearchField.text length]!= 0)
                {
                        if (arrOfDropdown.count != selectTypeObj.strSortText.intValue)
                        {
                            [self.paginationDelegateSearch requestForTheSearchListWithSearchKeyword:txtSearchField.text withIsFirstSearch:NO];
                        }
                }
                else
                {
                     NSLog(@"strSortText = %d",selectTypeObj.strSortText.intValue);
                    NSLog(@"indexPath.row = %ld",(long)indexPath.row);
                    NSLog(@"arrOfDropdown.count = %lu",(unsigned long)arrOfDropdown.count);
                    if (arrOfDropdown.count != selectTypeObj.strSortText.intValue)// the total records count is stored in strSortText bcos we are using the existing NSOBject class instead of creating new one.
                    {
                        
                            
                            NSLog(@"thisGettingCalledd");
                            [self.paginationDelegateSearch requestForThePaginationSearchWithIsFirstPagination:NO];
                        
                    }
                }
            }
            
        }
        else
        {
            if(![cell.lableVariantName.text isEqualToString:@"No record(s) found."])
            {
            [cell.lableVarinatCodeWithyear setText:[NSString stringWithFormat:@"%@ (%@ to %@)",selectTypeObj.strMeanCodeNumber,selectTypeObj.strMinYear,selectTypeObj.strMaxYear]];
            }
            else
            {
                cell.lableVarinatCodeWithyear.text = @"";
            }
        }
        return cell;
    }
    else
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
            cell.textLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
        }
        else
        {
            cell.textLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        cell.accessoryType =UITableViewCellAccessoryNone;
        
        if(!isVariant)
        {
            SMDropDownObject *selectTypeObj = (SMDropDownObject*)[arrOfDropdown objectAtIndex:indexPath.row];
            NSLog(@"strMakeName = %@",selectTypeObj.strMakeName);
            cell.textLabel.text = selectTypeObj.strMakeName;
                        
        }
        else
        {
            SMLoadVehiclesObject *selectTypeObj = (SMLoadVehiclesObject*)[arrOfDropdown objectAtIndex:indexPath.row];
            
            cell.textLabel.text = selectTypeObj.strMakeName;
        }
        cell.textLabel.textColor = [UIColor blackColor];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!isVariant)
    {
        SMDropDownObject *objSelected = (SMDropDownObject*)[arrOfDropdown objectAtIndex:indexPath.row];
        getTheSelectedDataResponseCallBack(objSelected.strMakeName,objSelected.strMakeId.intValue, 0, objSelected.strStockId);
        
    }
    else
    {
        SMDropDownObject *objSelected = (SMDropDownObject*)[arrOfDropdown objectAtIndex:indexPath.row];
        if(![objSelected.strMakeName containsString:@"No record(s)"])
        {
            if(isVehicleFromReviews)
            {
                getTheSelectedDataResponseCallBack(objSelected.strMakeName,objSelected.strMakeId.intValue,objSelected.strMakeYear.intValue,objSelected.strDropDownValue);
            }
            else
            {
                getTheSelectedDataResponseCallBack(objSelected.strMakeName,objSelected.strMakeId.intValue,objSelected.  strMakeYear.intValue,objSelected.strStockId);
            }
        }
        
    }
    
    
    [self dismissPopup];
}

- (IBAction)btnCancelDidClicked:(id)sender
{
    [self dismissPopup];
}

+(void)getTheSelectedDataInfoWithCallBack:(SMCompetionBlockDropDownSearch)callBack
{
    getTheSelectedDataResponseCallBack = callBack;
    
}

#pragma mark- load popup
-(void)loadPopup
{
   
    
    txtSearchField.delegate = self;
    txtSearchField.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    txtSearchField.layer.borderWidth= 0.8f;
    txtSearchField.placeholder = @"Search";
    
    // This is to give padding to the text field text
    
    UIView *viewForPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 7, 30)];
    txtSearchField.leftView = viewForPadding;
    

    [self setFrame:[UIScreen mainScreen].bounds];
    [self setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.50]];
    [self setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [self setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [self dynamicRowHeightCode];
         [self setAlpha:0.75];
         [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [self setAlpha:1.0];
              
              [self setTransform:CGAffineTransformIdentity];
          }
                          completion:^(BOOL finished)
          {
              
          }];
         
     }];
}

#pragma mark - dismiss popup
-(void)dismissPopup
{
    [UIView animateWithDuration:0.1 animations:^
     {
         [self setAlpha:0.3];
         [self setTransform:CGAffineTransformMakeScale(0.9    ,0.9)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.05 animations:^
          {
              
              [self setAlpha:0.0];
          }
                          completion:^(BOOL finished)
          {
              [self removeFromSuperview];
              [self setTransform:CGAffineTransformIdentity];
              
          }];
     }];
}

-(void)getTheDropDownData:(NSMutableArray*) arrDropDownData withVariant:(BOOL) ifVariant withVehicle:(BOOL) ifVehicle isPagination:(BOOL) isPagination
{
    
    if(isPagination)
    {
        [self dynamicRowHeightCode];
        [tblViewDropDownData reloadData];
    }
    else
    {
        
        isVariant = ifVariant;
        isVehicle = ifVehicle;
        viewContainingTable.layer.masksToBounds = NO;
        [viewContainingTable.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
        viewContainingTable.layer.shadowOffset = CGSizeMake(-5, 5);
        [txtSearchField setFont:[UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone]];
        viewForHeader.clipsToBounds = YES;
        viewForHeader.layer.cornerRadius = 8;
        viewContainingTable.layer.cornerRadius = 8;
        tblViewDropDownData.layer.cornerRadius = 8;
        tblViewVariantDropdown.layer.cornerRadius = 8;
        viewContainingTable.layer.shadowRadius = 5;
        viewContainingTable.layer.shadowOpacity = 0.5;
        
        arrOfDropdown = [[NSMutableArray alloc]init];
        
        SMDropDownObject *lastObject = [arrDropDownData lastObject];
        
        
        if([lastObject.strMakeName length] == 0)
        {
            [arrDropDownData removeLastObject];
            isVehicleFromReviews = YES;
        }
        else
        {
            isVehicleFromReviews = NO;
        }
        arrOfDropdown = arrDropDownData;
        tblViewDropDownData.dataSource = self;
        tblViewDropDownData.delegate = self;
        tblViewVariantDropdown.dataSource = self;
        tblViewVariantDropdown.delegate = self;
        
        if (isVariant)
        {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                [tblViewDropDownData registerNib:[UINib nibWithNibName:@"SMVariantCell" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
                [tblViewVariantDropdown registerNib:[UINib nibWithNibName:@"SMVariantCell" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
            }
            else
            {
                
                [tblViewDropDownData registerNib:[UINib nibWithNibName:@"SMVariantCell_iPad" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
                [tblViewVariantDropdown registerNib:[UINib nibWithNibName:@"SMVariantCell_iPad" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
            }
            
        }
        
        
        [self loadPopup];
        [tblViewDropDownData reloadData];
    }
    
}

-(void)dynamicRowHeightCode
{
    float height;
    if(isVariant)
    {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            if (arrOfDropdown.count < 4) {
                height = (arrOfDropdown.count) * 65;
                
                if(tblViewDropDownData != nil)
                    height = height + 80;
                else
                    height = height + 40;
            }
            else
            {
                height = 5*65;
            }
            
        }
        else
        {
            if (arrOfDropdown.count < 4) {
                height = (arrOfDropdown.count+1) * 65;
            }
            else
            {
                height = 5*65;
            }
            
        }
        
    }
    
    else{
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            if (arrOfDropdown.count < 4) {
                height = (arrOfDropdown.count+1) * 43;
            }
            else
            {
                height = 5*43;
            }
        }
        else
        {
            if (arrOfDropdown.count < 4) {
                height = (arrOfDropdown.count+1) * 60;
            }
            else
            {
                height = 5*60;
            }
        }
        
    }
    
    if(height == 145)
    {
        height = 110;
        tblViewDropDownData.contentInset = UIEdgeInsetsMake(-7, 0, 0, 0);
    }
        
    [viewContainingTable setFrame:CGRectMake(viewContainingTable.frame.origin.x, viewContainingTable.frame.origin.y, viewContainingTable.frame.size.width, height)];
}

@end


