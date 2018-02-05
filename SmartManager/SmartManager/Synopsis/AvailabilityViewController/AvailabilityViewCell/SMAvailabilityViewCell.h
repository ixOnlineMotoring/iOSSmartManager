//
//  SMAvailabilityViewCell.h
//  Smart Manager
//
//  Created by Sandeep on 04/01/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAvailabilityViewCell : UITableViewCell
@property (weak, nonatomic)IBOutlet UILabel *availabilityTitleLabel;
@property (weak, nonatomic)IBOutlet UILabel *retailLabel;
@property (weak, nonatomic)IBOutlet UILabel *tradeLabel;
@property (weak, nonatomic)IBOutlet UILabel *totalLabel;

@property (strong, nonatomic) IBOutlet UILabel *lblColumn1;

@end
