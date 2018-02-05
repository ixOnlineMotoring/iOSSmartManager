//
//  SMCustomPopUpTableView.h
//  Smart Manager
//
//  Created by Prateek Jain on 19/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMPaginationRequestDelegate <NSObject>

-(void)requestForThePagination;

@end

@interface SMCustomPopUpTableView : UIView <UITableViewDataSource,UITableViewDelegate>
{

     IBOutlet UIView *viewContainingTable;
    
     IBOutlet UITableView *tblViewDropDownData;
    
    
     IBOutlet UIButton *btnCancel;
    
    NSMutableArray *arrOfDropdown;
    BOOL isVariant;
    BOOL isSort;
   BOOL isFirstSort; // this BOOL value is for knowing whether the dropdown is for year values or not so that it could be made center alligned.
   // int selectedRow;
    
    BOOL isOnlinePricingNowDropdown;
    
}

@property (weak, nonatomic)id<SMPaginationRequestDelegate>paginationDelegate;

typedef void (^SMCompetionBlockDropDown)(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear);


+(void)getTheSelectedDataInfoWithCallBack:(SMCompetionBlockDropDown)callBack; // output


-(void)getTheDropDownData:(NSMutableArray*) arrDropDownData withVariant:(BOOL) ifVariant andIsPagination:(BOOL) isPagination ifSort:(BOOL) ifSort andIsFirstTimeSort:(BOOL) isFirstTimeSort; // input
- (IBAction)btnCancelDidClicked:(id)sender;



@end
