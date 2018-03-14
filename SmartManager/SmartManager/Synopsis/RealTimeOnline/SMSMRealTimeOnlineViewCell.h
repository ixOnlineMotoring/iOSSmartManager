//
//  SMSMRealTimeOnlineViewCell.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 21/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelAutolayout.h"

@interface SMSMRealTimeOnlineViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet SMCustomLabelAutolayout *lblTitle;
@property (strong, nonatomic) IBOutlet SMCustomLabelAutolayout *lblRightNow;
@property (strong, nonatomic) IBOutlet SMCustomLabelAutolayout *lbl90Days;

@end
