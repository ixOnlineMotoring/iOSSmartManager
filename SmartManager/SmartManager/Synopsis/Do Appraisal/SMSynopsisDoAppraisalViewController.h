//
//  SMSynopsisDoAppraisalViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 29/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSynopsisXMLResultObject.h"
#import "MBProgressHUD.h"


@interface SMSynopsisDoAppraisalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;

}

@property(strong,nonatomic) SMSynopsisXMLResultObject *objSMSynopsisResult;




@end
