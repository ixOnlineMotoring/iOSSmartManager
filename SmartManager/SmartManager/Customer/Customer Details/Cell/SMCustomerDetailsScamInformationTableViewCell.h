//
//  SMCustomerDetailsScamInformationTableViewCell.h
//  SmartManager
//
//  Created by Jignesh on 03/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"
@interface SMCustomerDetailsScamInformationTableViewCell : UITableViewCell
@property(strong, nonatomic) IBOutlet SMCustomLable *lableKeyInformation;
@property(strong, nonatomic) IBOutlet SMCustomLable *lableValueInformation;
@end
