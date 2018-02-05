//
//  SMListExpiredSpecialsViewController.h
//  SmartManager
//
//  Created by Sandeep on 20/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMListActiveSpecialsCell.h"
#import "MBProgressHUD.h"
#import "SMActiveSpecial.h"

@interface SMListExpiredSpecialsViewController : UIViewController<MBProgressHUDDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSXMLParser     *xmlParser;
    NSMutableString *currentNodeContent;
    
    MBProgressHUD   *HUD;
    int             startIndex;
    int             totalRecord;

    NSMutableArray  *arrayExpiredSpecial;
    SMActiveSpecial *specialObject;
    BOOL             isDocument;
    
    SMActiveSpecial *activeObjectOnButtonDetails;
}

@property (strong, nonatomic) IBOutlet UITableView *tblListExpiredSpecials;
@property (assign) BOOL isFromUnPublished;

@end
