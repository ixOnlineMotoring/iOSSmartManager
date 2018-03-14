//
//  SMLoadSpecialTableViewCell.h
//  SmartManager
//
//  Created by Ketan Nandha on 25/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"

@interface SMLoadSpecialTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblSelectType;


// for variant listing

@property(strong,nonatomic) IBOutlet UILabel *labelYear;
@property(strong,nonatomic) IBOutlet UILabel *labelMeanCode;
@property(strong,nonatomic) IBOutlet UILabel *labelColor;

@end
