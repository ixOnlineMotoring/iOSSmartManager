//
//  SMSettings_CustomMsgsViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 05/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextView.h"
#import "MBProgressHUD.h"


@interface SMSettings_CustomMsgsViewController : UIViewController<UITextViewDelegate,NSXMLParserDelegate,MBProgressHUDDelegate>
{

    IBOutlet UIScrollView *scrollView;
    MBProgressHUD *HUD;
    
    IBOutlet CustomTextView *txtViewPurchases;
    
    IBOutlet CustomTextView *txtViewOffer;
    

    IBOutlet CustomTextView *txtViewTender;

    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    
    __weak IBOutlet UIButton *btnSaveCustomMsg;
    
    

}
- (IBAction)btnSaveMessagedidClicked:(id)sender;

@end
