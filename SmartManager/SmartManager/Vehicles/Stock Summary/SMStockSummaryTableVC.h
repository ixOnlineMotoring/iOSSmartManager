//
//  SMStockSummaryTableVC.h
//  Smart Manager
//
//  Created by Ketan Nandha on 06/10/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMStockSummaryTableVC : UITableViewController<NSXMLParserDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
{

    IBOutlet UIView *viewWorkTypeSectionHeader;
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    
}


@end
