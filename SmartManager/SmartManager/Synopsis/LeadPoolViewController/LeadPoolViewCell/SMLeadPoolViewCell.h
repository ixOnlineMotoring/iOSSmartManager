//
//  SMLeadPoolViewCell.h
//  Smart Manager
//
//  Created by Sandeep on 23/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMLeadPoolViewCell : UITableViewCell

@property (weak, nonatomic)IBOutlet UILabel *leadToolTitleLabel;
@property (weak, nonatomic)IBOutlet UILabel *activeCountLabel;
@property (weak, nonatomic)IBOutlet UILabel *closedCountLabel;


@property (strong, nonatomic) IBOutlet UIButton *btnActive;

@property (strong, nonatomic) IBOutlet UIButton *btnClose;


@end
