//
//  SMCustomPopUpPickerView.m
//  Smart Manager
//
//  Created by Prateek Jain on 19/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomPopUpPickerView.h"
#import "SMDropDownObject.h"

@implementation SMCustomPopUpPickerView

int indexSelected=0;

void(^ getTheSelectedPickerDataResponseCallBack)(NSString *selectedTextValue);

#pragma mark -

#pragma mark - picker datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;// or the number of vertical "columns" the picker will show...
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrOfDropdown.count;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* lbl = (UILabel*)view;
    // Customise Font
    if (lbl == nil)
    {
        //label size
        CGRect frame = CGRectMake(0.0, 0.0, 70, 30);
        lbl = [[UILabel alloc] initWithFrame:frame];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor blackColor]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        //here you can play with fonts
        [lbl setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0]];
        
    }
    //picker view array is the datasource
    [lbl setText:[arrOfDropdown objectAtIndex:row]];
    
    return lbl;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //you can also write code here to descide what data to return depending on the component ("column")
    if (arrOfDropdown!=nil)
    {
        return [arrOfDropdown objectAtIndex:row];
        //assuming the array contains strings..
    }
    return @"";//or nil, depending how protective you are
}
#pragma mark -
#pragma mark - picker delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   /*
    SMDropDownObject *objSelected = (SMDropDownObject*)[arrOfDropdown objectAtIndex:row];
    
    getTheSelectedPickerDataResponseCallBack(objSelected.strSortText);
*/
     // getTheSelectedPickerDataResponseCallBack([arrOfDropdown objectAtIndex:row]);
    indexSelected =(int) row;
    
}

+(void)getTheSelectedPickerDataInfoWithCallBack:(SMCompetionBlockPickerDropDown)callBack
{
    getTheSelectedPickerDataResponseCallBack = callBack;
    
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
         [self setAlpha:0.75];
         [self setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
         
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


- (IBAction)btnDoneDidClicked:(id)sender
{
    [self dismissPopup];
    getTheSelectedPickerDataResponseCallBack([arrOfDropdown objectAtIndex:indexSelected]);
    
}

- (IBAction)btnCancelDidClicked:(id)sender {
    [self dismissPopup];
}


-(void)getThePickerDropDownData:(NSMutableArray*) arrDropDownData withPreviosSelectedYearAs:(NSString*)previosSelctedYear
{
    viewContainingPickerView.layer.masksToBounds = YES;
    pickerView.clipsToBounds = YES;
    [viewContainingPickerView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    viewContainingPickerView.layer.shadowOffset = CGSizeMake(-5, 5);
    
    viewContainingPickerView.layer.cornerRadius = 8;
     viewContainingPicker.layer.cornerRadius = 15;
    pickerView.layer.cornerRadius = 8;
    viewContainingPickerView.layer.shadowRadius = 5;
    viewContainingPickerView.layer.shadowOpacity = 0.5;
    
    arrOfDropdown = [[NSMutableArray alloc]init];
    arrOfDropdown = arrDropDownData;
    pickerView.dataSource = self;
    pickerView.delegate = self;
   NSLog(@"%@",NSStringFromCGRect(pickerView.frame));
    for (int i=0; i<arrDropDownData.count; i++)
    {
        NSString *str=[arrDropDownData objectAtIndex:i];
        
        if ([str isEqualToString:previosSelctedYear])
        {
            [pickerView reloadAllComponents];
            [pickerView selectRow:i inComponent:0 animated:YES];
        }
    }

    
    [self loadPopup];
    
}

@end
