//
//  SMReviewsTitleViewCell.h
//  Smart Manager
//
//  Created by Sandeep on 24/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelAutolayout.h"

@interface SMReviewTitleViewCell : UITableViewCell
@property (weak, nonatomic)IBOutlet SMCustomLabelAutolayout *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lblSeparator;


@end
