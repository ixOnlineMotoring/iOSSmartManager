//
//  SMSynopsisVehicleExtrasViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 12/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMSynopsisXMLResultObject.h"

@interface SMSynopsisVehicleExtrasViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSXMLParserDelegate,MBProgressHUDDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    NSString *resultString;

    
}
@property(nonatomic,strong) SMSynopsisXMLResultObject *objSummary;

@end
