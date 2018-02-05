//
//  SMCustomPopUpTableView.m
//  Smart Manager
//
//  Created by Prateek Jain on 19/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomPopUpTableView.h"
#import "SMDropDownObject.h"
#import "SMLoadVehiclesObject.h"
#import "SMLoadVehicleTableViewCell.h"
#import "SMTraderSearchSortByCell.h"
#import "SMGlobalClass.h"

@implementation SMCustomPopUpTableView

void(^ getTheSelectedDataResponseCallBack)(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear);

#pragma mark - Tableview datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOfDropdown.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        return 43;
    }
    else
    {
        return 50;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return btnCancel;
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
    if(isVariant)
    {
        static NSString *cellIdentifier= @"VariantListing";//SMLoadVehicleTableViewCell
        
        SMLoadVehicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            cell.lableVariantName.font = [UIFont fontWithName:FONT_NAME size:14.0];
            cell.lableVarinatCodeWithyear.font = [UIFont fontWithName:FONT_NAME size:12.0];
            
        }
        else
        {
            cell.lableVariantName.font = [UIFont fontWithName:FONT_NAME size:20.0];
            cell.lableVarinatCodeWithyear.font = [UIFont fontWithName:FONT_NAME size:16.0];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        
        cell.accessoryType =UITableViewCellAccessoryNone;
        SMLoadVehiclesObject *selectTypeObj = (SMLoadVehiclesObject*)[arrOfDropdown objectAtIndex:indexPath.row];
        
        
        [cell.lableVariantName      setText:selectTypeObj.strMakeName];
        if([selectTypeObj.strMinYear hasPrefix:@"-"])
        {
            [cell.lableVarinatCodeWithyear setText:[NSString stringWithFormat:@"%@",selectTypeObj.strMeanCodeNumber]];
            
            if (arrOfDropdown.count-1 == indexPath.row)
            {
                if (arrOfDropdown.count != selectTypeObj.strMakeId.intValue)// the total records count is stored in strMakeId bcos we are using the existing NSOBject class instead of creating new one.
                {
                    if ([self.paginationDelegate respondsToSelector:@selector(requestForThePagination)]) {
                        
                        
                        [self.paginationDelegate requestForThePagination];
                    }
                }
            }
        }
        else
        {
            [cell.lableVarinatCodeWithyear setText:[NSString stringWithFormat:@"%@ (%@ to %@)",selectTypeObj.strMeanCodeNumber,selectTypeObj.strMinYear,selectTypeObj.strMaxYear]];
        }
        
        
        
        
        return cell;
    }
    else
    {
        
        static NSString     *CellIdentifier1 = @"SMTraderSearchSortByCell";
        
        SMDropDownObject *objectCellForRow;
        
        SMTraderSearchSortByCell *cell1 = (SMTraderSearchSortByCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        cell1.selectionStyle=UITableViewCellSelectionStyleNone;
        
        if(!isVariant)
        {
            if(isSort)
            {
                if([SMGlobalClass sharedInstance].selectedRowForCustomPopup == indexPath.row)
                {
                    cell1.imgAscDesc.hidden = NO;
                }
                else
                {
                    cell1.imgAscDesc.hidden = YES;
                }
                
                if([SMGlobalClass sharedInstance].isTheSortFirstAttemptForCustomPopup)
                {
                    [SMGlobalClass sharedInstance].isTheSortFirstAttemptForCustomPopup = NO;
                    cell1.imgAscDesc.hidden = NO;
                }
                if(indexPath.row == 0)
                    cell1.imgAscDesc.hidden = YES;
            }
            else
            {
                cell1.imgAscDesc.hidden = YES;
                if(isFirstSort)
                {
                    cell1.lblSortText.textAlignment = NSTextAlignmentCenter;
                }
            }
           
            objectCellForRow = (SMDropDownObject*)[arrOfDropdown objectAtIndex:indexPath.row];
           // NSLog(@"strMakeName = %@",objectCellForRow.strMakeName);
          //  if(isOnlinePricingNowDropdown)
              //  cell1.lblSortText.font = [UIFont fontWithName:FONT_NAME_BOLD size:9.0];

            [cell1.lblSortText setText:objectCellForRow.strMakeName];
            
            
            if([objectCellForRow.strStockId length] != 0)
            {
                
                if (arrOfDropdown.count-1 == indexPath.row)
                {
                    if (arrOfDropdown.count != objectCellForRow.strStockId.intValue)// the total records count is stored in strStockId bcos we are using the existing NSOBject class instead of creating new one.
                    {
                        if ([self.paginationDelegate respondsToSelector:@selector(requestForThePagination)]) {
                            
                            
                            [self.paginationDelegate requestForThePagination];
                        }
                    }
                }
            }
        }
        else
        {
            SMLoadVehiclesObject *selectTypeObj = (SMLoadVehiclesObject*)[arrOfDropdown objectAtIndex:indexPath.row];
            
            cell1.textLabel.text = selectTypeObj.strMakeName;
        }
        cell1.textLabel.textColor = [UIColor blackColor];
        
        return cell1;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!isVariant)
    {
        [SMGlobalClass sharedInstance].selectedRowForCustomPopup = (int)indexPath.row;
        
        SMDropDownObject *objSelected = (SMDropDownObject*)[arrOfDropdown objectAtIndex:indexPath.row];
        
        if(isSort)
        {
            SMTraderSearchSortByCell *selectedCell = (SMTraderSearchSortByCell*)[tblViewDropDownData cellForRowAtIndexPath:indexPath];
            
            objSelected.isAscending = !objSelected.isAscending;
            selectedCell.imgAscDesc.hidden = NO;
            if(objSelected.isAscending)
            {
                objSelected.strMinYear = @"1";
               //selectedCell.imgAscDesc.transform = CGAffineTransformMakeRotation(M_PI);
                CGImageRef imageRef   = [[UIImage imageNamed:@"arrow_down"]CGImage];
                
                UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationDown];
                [selectedCell.imgAscDesc setImage:rotatedImage];
                
            }
            else
            {
                objSelected.strMinYear = @"0";
                selectedCell.imgAscDesc.transform = CGAffineTransformMakeRotation(0);
            }
            
            getTheSelectedDataResponseCallBack(objSelected.strMakeName,objSelected.strMakeId.intValue, objSelected.strMinYear.intValue, objSelected.strMaxYear.intValue);
            
        }
        else
        {
            if(!isOnlinePricingNowDropdown)
            {
             getTheSelectedDataResponseCallBack(objSelected.strMakeName,objSelected.strMakeId.intValue, objSelected.strMinYear.intValue, objSelected.strMaxYear.intValue);
            }
            else
            {
                getTheSelectedDataResponseCallBack(objSelected.strMakeName,objSelected.strMakeId.intValue, objSelected.strModelId.intValue, (int)indexPath.row);
            }
            
            // getTheSelectedDataResponseCallBack(objSelected.strMakeName,objSelected.strMakeId.intValue, objSelected.strMakeYear.intValue, objSelected.strMaxYear.intValue);
        }
       

    }
    else
    {
        SMLoadVehiclesObject *objSelected = (SMLoadVehiclesObject*)[arrOfDropdown objectAtIndex:indexPath.row];
        
        
        getTheSelectedDataResponseCallBack(objSelected.strMakeName,objSelected.strMakeId.intValue,0,0);
        
    }
    
    
    [self dismissPopup];
}

- (IBAction)btnCancelDidClicked:(id)sender
{
    [self dismissPopup];
}

+(void)getTheSelectedDataInfoWithCallBack:(SMCompetionBlockDropDown)callBack
{
    getTheSelectedDataResponseCallBack = callBack;
    
}

#pragma mark- load popup
-(void)loadPopup
{
    
  
    
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

-(void)getTheDropDownData:(NSMutableArray*) arrDropDownData withVariant:(BOOL) ifVariant andIsPagination:(BOOL) isPagination ifSort:(BOOL) ifSort andIsFirstTimeSort:(BOOL) isFirstTimeSort;
{
    //[self.superview endEditing:YES];
    if(ifSort && isFirstTimeSort)
    {
        [SMGlobalClass sharedInstance].selectedRowForCustomPopup = -1;
        [SMGlobalClass sharedInstance].isTheSortFirstAttemptForCustomPopup = YES;
    }
    if(isPagination)
    {
        [tblViewDropDownData reloadData];
    }
    else
    {
        isVariant = ifVariant;
        isSort = ifSort;
        isFirstSort = isFirstTimeSort;
        viewContainingTable.layer.masksToBounds = NO;
        [viewContainingTable.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
        viewContainingTable.layer.shadowOffset = CGSizeMake(-5, 5);
        
        viewContainingTable.layer.cornerRadius = 8;
        tblViewDropDownData.layer.cornerRadius = 8;
        viewContainingTable.layer.shadowRadius = 5;
        viewContainingTable.layer.shadowOpacity = 0.5;
        
        tblViewDropDownData.layoutMargins = UIEdgeInsetsZero;
        tblViewDropDownData.preservesSuperviewLayoutMargins = NO;
        [tblViewDropDownData flashScrollIndicators];
        
        tblViewDropDownData.tableFooterView = [[UIView alloc]init];
        
        arrOfDropdown = [[NSMutableArray alloc]init];
        
        if(arrDropDownData.count == 7)
        {
            SMDropDownObject *tempObj = (SMDropDownObject*)[arrDropDownData lastObject];
            if([tempObj.strMakeId isEqualToString:@"00"])
            {
                isOnlinePricingNowDropdown = YES;
                [arrDropDownData removeLastObject];
            }
            else
            {
                isOnlinePricingNowDropdown = NO;
            }
        
        }
        
        arrOfDropdown = arrDropDownData;
        tblViewDropDownData.dataSource = self;
        tblViewDropDownData.delegate = self;
                
        if (isVariant)
        {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                [tblViewDropDownData registerNib:[UINib nibWithNibName:@"SMVariantCell" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
            }
            else
            {
                
                [tblViewDropDownData registerNib:[UINib nibWithNibName:@"SMVariantCell_iPad" bundle:nil] forCellReuseIdentifier:@"VariantListing"];
            }
            
        }
        else
        {
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                [tblViewDropDownData registerNib:[UINib nibWithNibName:@"SMTraderSearchSortByCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMTraderSearchSortByCell"];
            }
            else
            {
                
                [tblViewDropDownData registerNib:[UINib nibWithNibName:@"SMTraderSearchSortByCell_iPad" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMTraderSearchSortByCell"];
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
                height = (arrOfDropdown.count+1) * 52;
            }
            else
            {
                height = 5*52;
            }
            
        }
        else
        {
            if (arrOfDropdown.count < 4) {
                height = (arrOfDropdown.count+1) * 57;
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
                height = (arrOfDropdown.count+1) * 55;
            }
            else
            {
                height = 5*60;
            }
        }
        
    }
    
    [viewContainingTable setFrame:CGRectMake(viewContainingTable.frame.origin.x, viewContainingTable.frame.origin.y, viewContainingTable.frame.size.width, height)];
}

@end
