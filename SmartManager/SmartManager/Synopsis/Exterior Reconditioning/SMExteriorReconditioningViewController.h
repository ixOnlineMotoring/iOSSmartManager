//
//  SMExteriorReconditioningViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 11/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMSynopsisXMLResultObject.h"

@interface SMExteriorReconditioningViewController : UIViewController<UITextViewDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;

}

@property(nonatomic,strong) SMSynopsisXMLResultObject *objSummary;


@end
