//
//  SMDetailTableViewCell.h
//  SmartManager
//
//  Created by Jignesh on 16/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"

@interface SMDetailTableViewCell : UITableViewCell

@property(strong, nonatomic) IBOutlet SMCustomLable *labelVehicleKey;
@property(strong, nonatomic) IBOutlet SMCustomLable *labelVehicleValue;

@end
