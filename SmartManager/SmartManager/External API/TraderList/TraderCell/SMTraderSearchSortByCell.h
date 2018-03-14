//
//  SMTraderSearchSortByCell.h
//  SmartManager
//
//  Created by Liji Stephen on 20/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"

@interface SMTraderSearchSortByCell : UITableViewCell

@property (strong, nonatomic) IBOutlet SMCustomLable *lblSortText;

@property (strong, nonatomic) IBOutlet UIImageView *imgAscDesc;

@end
