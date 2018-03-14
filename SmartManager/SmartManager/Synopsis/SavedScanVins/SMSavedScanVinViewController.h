//
//  SMSavedScanVinViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 19/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMVINLookupObject.h"

@interface SMSavedScanVinViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>
{
    NSMutableString *currentNodeContent;
    //---web service access---
    NSMutableString *soapResults;
    //---xml parsing---
    NSXMLParser *xmlParser;
    
     MBProgressHUD *HUD;

     NSMutableArray *savedVINScanArray;
    
     SMVINLookupObject* VINLookupObject;
    
}

@end
