//
//  SMForwardATableViewCell.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 25/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelAutolayout.h"

@interface SMForwardATableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet SMCustomLabelAutolayout *lblTitle;
@property (strong, nonatomic) IBOutlet SMCustomLabelAutolayout *lblDetails;

@end
