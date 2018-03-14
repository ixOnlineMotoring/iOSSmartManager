//
//  SMRealTimeOnlineViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 21/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelAutolayout.h"
#import "MBProgressHUD.h"

@interface SMRealTimeOnlineViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,MBProgressHUDDelegate>
{
    
    NSMutableString *currentNodeContent;
    //---web service access---
    NSMutableString *soapResults;
    //---xml parsing---
    NSXMLParser *xmlParser;
    
    NSMutableArray *arrayOnlinePrices;
    
    IBOutlet UIView *viewTableFooter;
    
    IBOutlet SMCustomLabelAutolayout *lblHeading1;
    
    IBOutlet UILabel *lblRedNote;

    IBOutlet UILabel *lblNational;
    
    IBOutlet UILabel *lblAdvertRegion;
    
    BOOL isOnlinePricesParsing;
    
}

@property(assign)int screenNumberComingFrom;

@property(assign)int selectedVariantID;
@property(assign)int selectedYear;

@end
