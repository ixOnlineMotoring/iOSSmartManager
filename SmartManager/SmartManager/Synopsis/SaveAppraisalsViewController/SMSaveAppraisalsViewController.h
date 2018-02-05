//
//  SMSaveAppraisalsViewController.h
//  Smart Manager
//
//  Created by Sandeep on 21/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSaveAppraisalsViewCell.h"
#import "SMSaveAppraisalsView.h"
#import "SMVehiclelisting.h"
#import "SMSendOfferViewController.h"

@interface SMSaveAppraisalsViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITableView *tblSMSaveAppraisals;
    NSMutableArray *saveAppraisalsArray;
    NSString *selectedYear;
}
@end
