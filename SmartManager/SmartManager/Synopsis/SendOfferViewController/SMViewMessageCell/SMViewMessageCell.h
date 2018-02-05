//
//  SMViewMessageCell.h
//  Smart Manager
//
//  Created by Sandeep on 22/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAutolayoutLightLabel.h"
@interface SMViewMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet SMAutolayoutLightLabel *lblSMSContent;

@property (strong, nonatomic) IBOutlet SMAutolayoutLightLabel *lblSubjectContent;

@end
