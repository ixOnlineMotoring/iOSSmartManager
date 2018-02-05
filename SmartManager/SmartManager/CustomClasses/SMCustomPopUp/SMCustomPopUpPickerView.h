//
//  SMCustomPopUpPickerView.h
//  Smart Manager
//
//  Created by Prateek Jain on 19/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCustomPopUpPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

{

    __weak IBOutlet SMCustomPopUpPickerView *viewContainingPickerView;

    
    __weak IBOutlet UIPickerView *pickerView;
    
    IBOutlet UIView *viewContainingPicker;
    
    
    NSMutableArray *arrOfDropdown;
  
}

typedef void (^SMCompetionBlockPickerDropDown)(NSString *selectedTextValue);
+(void)getTheSelectedPickerDataInfoWithCallBack:(SMCompetionBlockPickerDropDown)callBack; // output
-(void)getThePickerDropDownData:(NSMutableArray*) arrDropDownData withPreviosSelectedYearAs:(NSString*)previosSelctedYear; // input
- (IBAction)btnDoneDidClicked:(id)sender;

- (IBAction)btnCancelDidClicked:(id)sender;

@end
