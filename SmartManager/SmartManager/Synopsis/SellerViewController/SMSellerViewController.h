//
//  SMSellerViewController.h
//  Smart Manager
//
//  Created by Sandeep on 06/01/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomerDLScanViewController.h"
#import "MBProgressHUD.h"
#import "SMSynopsisXMLResultObject.h"

@interface SMSellerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,MBProgressHUDDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    IBOutlet UITableView *tblSellerView;
    
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
}

- (IBAction)btnScanDriverLicenceDidClciked:(id)sender;
@property(nonatomic,strong) SMSynopsisXMLResultObject *objSummary;




@end
