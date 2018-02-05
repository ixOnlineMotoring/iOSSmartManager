//
//  SMCustomPopUpSearchTableView.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 29/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextFieldSearch.h"

@protocol SMPaginationRequestSearchDelegate <NSObject>

-(void)requestForThePaginationSearchWithIsFirstPagination:(BOOL) isFirstPagination;

-(void)requestForTheSearchListWithSearchKeyword:(NSString*)searchText withIsFirstSearch:(BOOL) isFirstSearch;

@end

@interface SMCustomPopUpSearchTableView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    
    IBOutlet UIView *viewContainingTable;
    
    IBOutlet UIView *viewForHeader;
    
    IBOutlet UITableView *tblViewDropDownData;
    IBOutlet UITableView *tblViewVariantDropdown;
    
    IBOutlet SMCustomTextFieldSearch *txtSearchField;
    IBOutlet UIButton *btnCancel;
    
    NSMutableArray *arrOfDropdown;
    BOOL isVariant;
    BOOL isVehicle;
    BOOL isVehicleFromReviews;
    NSString *resultString;
    NSString *previousSearchString;
    NSOperationQueue *downloadingQueue;
}

@property (weak, nonatomic)id<SMPaginationRequestSearchDelegate>paginationDelegateSearch;


typedef void (^SMCompetionBlockDropDownSearch)(NSString *selectedTextValue, int selectIDValue, int selectedYear, NSString *strVehicleStockId);

+(void)getTheSelectedDataInfoWithCallBack:(SMCompetionBlockDropDownSearch)callBack; // output

-(void)getTheDropDownData:(NSMutableArray*) arrDropDownData withVariant:(BOOL) ifVariant withVehicle:(BOOL) ifVehicle isPagination:(BOOL) isPagination; // input
- (IBAction)btnCancelDidClicked:(id)sender;



@end

