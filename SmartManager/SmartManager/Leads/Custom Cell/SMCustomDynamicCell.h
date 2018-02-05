//
//  SMCustomDynamicCell.h
//  SmartManager
//
//  Created by Liji Stephen on 05/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"
#import "SMCustomButtonBlue.h"

@interface SMCustomDynamicCell : UITableViewCell

@property (strong, nonatomic) IBOutlet SMCustomLable *lblTitle;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblValue;



@end
