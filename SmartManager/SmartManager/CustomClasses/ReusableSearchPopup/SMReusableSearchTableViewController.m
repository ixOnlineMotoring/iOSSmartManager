//
//  SMReusableSearchTableViewController.m
//  Smart Manager
//
//  Created by Ketan Nandha on 11/05/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import "SMReusableSearchTableViewController.h"
#import "SMLoadVehiclesObject.h"


@implementation SMReusableSearchTableViewController

//void(^ getTheSelectedSearchDataResponseCallBack)(NSString *selectedTextValue, int selectIDValue);

void(^ getTheSelectedSearchDataResponseCallBack)(NSString *selectedTextValue, int selectIDValue);



#pragma mark - Tableview datasource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
     return filteredArray.count;
    
   /* if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        
        if(arrOfDropdown.count>6)
            return 260;
        
        return 44* arrOfDropdown.count;
    }
    else
    {
        return 65.0f;
    }*/

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
        cell.textLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.accessoryType =UITableViewCellAccessoryNone;
    
    SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *) [filteredArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:objectVehicleListingInCell.strMakeName];

       cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            return 44;
        }
        else
        {
            return 65.0f;
        }
       
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    SMLoadVehiclesObject *objectVehicleListingInCell = (SMLoadVehiclesObject *) [filteredArray objectAtIndex:indexPath.row];

    
    //getTheSelectedSearchDataResponseCallBack(objectVehicleListingInCell.strMakeName,objectVehicleListingInCell.strMakeId.intValue);
    
    getTheSelectedSearchDataResponseCallBack(objectVehicleListingInCell.strMakeName,objectVehicleListingInCell.strMakeId.intValue);

    
   // getTheSelectedSearchDataResponseCallBack(@"hghgfhfgh",1);
    
    NSLog(@"%@,%d",objectVehicleListingInCell.strMakeName,objectVehicleListingInCell.strMakeId.intValue);
    filteredArray = arrOfDropdown;
    [self dynamicRowHeightCode];
    [self dismissPopup];
    
}

#pragma mark - textField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;

}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    [downloadingQueue cancelAllOperations];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"strMakeName contains[cd] %@",resultString];
    
    filteredArray = [arrOfDropdown filteredArrayUsingPredicate:predicate];
    
    
    
    
    if([filteredArray count]==0)
    {
        lblNoRecords.hidden = NO;
        
        
    }
    else
    {
         lblNoRecords.hidden = YES;
        
        
    }
    
    [tblViewReusableSearch reloadData];
    
    if([resultString length]==0)
    {
        tblViewReusableSearch.tableFooterView = nil;
        filteredArray = arrOfDropdown;
        lblNoRecords.hidden = YES;
        [tblViewReusableSearch reloadData];
    }
    [self dynamicRowHeightCode];
    return YES;
    
}

- (IBAction)btnCancelDidClicked:(id)sender
{
    filteredArray = arrOfDropdown;
    [self dynamicRowHeightCode];
    [self dismissPopup];
}

+(void)getTheSelectedSearchDataInfoWithCallBack:(SMCompetionBlockForSearch)callBack
{
    getTheSelectedSearchDataResponseCallBack = callBack;
    
}

#pragma mark- load popup
-(void)loadPopup
{
    
    
    txtFieldSearch.delegate = self;
    txtFieldSearch.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    txtFieldSearch.layer.borderWidth= 0.8f;
    txtFieldSearch.placeholder = @"Search";
    
    // This is to give padding to the text field text
    
    UIView *viewForPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 7, 30)];
    txtFieldSearch.leftView = viewForPadding;
    
    
    [self setFrame:[UIScreen mainScreen].bounds];
    [self setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.50]];
    [self setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self];
    [self setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         
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

-(void)getTheDropDownData:(NSArray*) arrDropDownData
{
    
    viewContainingTableView.layer.masksToBounds = NO;
    [viewContainingTableView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    viewContainingTableView.layer.shadowOffset = CGSizeMake(-5, 5);
    [txtFieldSearch setFont:[UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone]];
    viewForHeader.clipsToBounds = YES;
    viewForHeader.layer.cornerRadius = 8;
    viewContainingTableView.layer.cornerRadius = 8;
    tblViewReusableSearch.layer.cornerRadius = 8;
    tblViewReusableSearch.layer.cornerRadius = 8;
    viewContainingTableView.layer.shadowRadius = 5;
    viewContainingTableView.layer.shadowOpacity = 0.5;

         txtFieldSearch.text = @"";
         lblNoRecords.hidden = YES;
        filteredArray = [[NSArray alloc]init];
        
        filteredArray = arrDropDownData;
         arrOfDropdown = arrDropDownData;
        tblViewReusableSearch.dataSource = self;
        tblViewReusableSearch.delegate = self;
    
        [self dynamicRowHeightCode];
        [self loadPopup];
        [tblViewReusableSearch reloadData];
    
    
}

-(void)dynamicRowHeightCode
{
    float height;
    
    
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            if (filteredArray.count < 4) {
                height = (filteredArray.count+1) * 60;
            }
            else
            {
                height = 5*43;
                height = height + 29;
            }
        }
        else
        {
            if (filteredArray.count < 4) {
                height = (filteredArray.count+1) * 60;
            }
            else
            {
                height = 5*60;
            }
        }
        
    
    [viewContainingTableView setFrame:CGRectMake(viewContainingTableView.frame.origin.x, viewContainingTableView.frame.origin.y, viewContainingTableView.frame.size.width, height)];
}


@end
