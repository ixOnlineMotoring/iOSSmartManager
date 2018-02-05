//
//  SMSavedVINScanTableViewCell.h
//  SmartManager
//
//  Created by Priya on 28/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"

@interface SMSavedVINScanTableViewCell : UITableViewCell
@property(strong,nonatomic)IBOutlet SMCustomLable *lblDate;
@property(strong,nonatomic)IBOutlet SMCustomLable *lblMakeName;
@property(strong,nonatomic)IBOutlet SMCustomLable *lblMakeInfo;

@end
