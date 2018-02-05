//
//  SMSendOfferViewController.h
//  Smart Manager
//
//  Created by Sandeep on 22/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSendOfferCell.h"
#import "SMTableSectionView.h"
#import "SMViewMessageCell.h"
#import "SMLeadPoolViewController.h"
#import "MBProgressHUD.h"
#import "SMSynopsisXMLResultObject.h"

@interface SMSendOfferViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    IBOutlet UITableView *tblSMSendOffer;
    SMTableSectionView *section0View;
    
    MBProgressHUD *HUD;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;


    BOOL isExpandViewMessage;
}

@property(strong,nonatomic) SMSynopsisXMLResultObject *objSMSynopsisResult;
@end
