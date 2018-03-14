//
//  SMCustomCellForSelectBlogTableViewCell.h
//  SmartManager
//
//  Created by Liji Stephen on 20/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"


@interface SMCustomCellForSelectBlogTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet SMCustomTextField *lblBlogPostType;

@property (strong, nonatomic) IBOutlet UIImageView *imgRightArrow;

@property (strong, nonatomic) IBOutlet UILabel *labelBlogPostType;

@end
