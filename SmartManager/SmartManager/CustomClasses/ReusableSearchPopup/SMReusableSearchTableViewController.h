//
//  SMReusableSearchTableViewController.h
//  Smart Manager
//
//  Created by Ketan Nandha on 11/05/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextFieldSearch.h"

@interface SMReusableSearchTableViewController : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    IBOutlet UITableView *tblViewReusableSearch;

    IBOutlet UIView *viewHeader;

    IBOutlet SMCustomTextFieldSearch *txtFieldSearch;
     NSArray *arrOfDropdown;
    
    IBOutlet UIView *viewForHeader;
    
    IBOutlet UIView *viewContainingTableView;
    
    NSString *resultString;
    NSOperationQueue *downloadingQueue;
    NSArray *filteredArray;

    IBOutlet UILabel *lblNoRecords;
    

}

- (IBAction)btnCancelDidClicked:(id)sender;


typedef void (^SMCompetionBlockForSearch)(NSString *selectedTextValue, int selectIDValue);


+(void)getTheSelectedSearchDataInfoWithCallBack:(SMCompetionBlockForSearch)callBack; // output


-(void)getTheDropDownData:(NSArray*) arrDropDownData;

@end
