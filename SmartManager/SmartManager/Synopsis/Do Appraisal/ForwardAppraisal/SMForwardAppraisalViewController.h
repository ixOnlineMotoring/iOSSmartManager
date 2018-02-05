//
//  SMForwardAppraisalViewController.h
//  Smart Manager
//
//  Created by Ketan Nandha on 31/05/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSynopsisXMLResultObject.h"
#import "MBProgressHUD.h"


@interface SMForwardAppraisalViewController : UIViewController<MBProgressHUDDelegate,NSXMLParserDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    IBOutlet UIButton *btnVehicleImage;
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;


}

- (IBAction)btnSendDidClicked:(id)sender;
@property(strong,nonatomic) SMSynopsisXMLResultObject *objSMSynopsisResult;


@end
