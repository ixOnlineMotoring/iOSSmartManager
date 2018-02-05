//
//  SMCreateBlogTableViewCell.h
//  SmartManager
//
//  Created by Ketan Nandha on 10/03/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"

@interface SMCreateBlogTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet SMCustomLable *lblName;

@property (nonatomic,strong) IBOutlet UILabel *lblUnderline;

@end
