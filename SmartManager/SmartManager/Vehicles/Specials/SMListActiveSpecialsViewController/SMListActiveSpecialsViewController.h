//
//  SMListActiveSpecialsViewController.h
//  SmartManager
//
//  Created by Sandeep on 20/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMListActiveSpecialsCell.h"
#import "MBProgressHUD.h"
#import "SMActiveSpecial.h"

@interface SMListActiveSpecialsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,NSXMLParserDelegate>
{
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    
    int             startIndex;
    int             totalRecord;
    BOOL            isDocument;

    SMActiveSpecial *objectActiveSpecial;
    
    NSMutableArray *arrayActiveSpecial;
    
    SMActiveSpecial *activeObjectOnDeleteButton;
}

- (NSString*)getDateToLastMonthDate;

@property (strong, nonatomic) IBOutlet UITableView *tblListActiveSpecials;

@end
