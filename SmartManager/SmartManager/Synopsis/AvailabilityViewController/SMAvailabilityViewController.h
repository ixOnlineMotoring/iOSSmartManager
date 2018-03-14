//
//  SMAvailabilityViewController.h
//  Smart Manager
//
//  Created by Sandeep on 04/01/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAvailabilityViewCell.h"
#import "SMAvailabilityHeaderView.h"
#import "SMAvailabilityFooterView.h"
@interface SMAvailabilityViewController : UIViewController
{
    IBOutlet UITableView *tblAvailabilityTableView;
    SMAvailabilityHeaderView *availabilityHeaderView;
    SMAvailabilityFooterView *availabilityFooterView;
}
@property (strong,nonatomic) NSString *strYear;
@property (strong,nonatomic) NSString *strModelID;
@property (strong,nonatomic) NSString *strModelName;
@end
