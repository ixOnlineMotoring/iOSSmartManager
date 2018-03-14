//
//  SMTradeSoldCell.h
//  Smart Manager
//
//  Created by Sandeep on 27/11/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"

@interface SMTradeSoldCell : UITableViewCell

@property (strong, nonatomic)IBOutlet UILabel *lblRateBuyerQuestion;
@property (strong, nonatomic)IBOutlet SMCustomTextField *txtRateBuyerRatting;
@property (strong, nonatomic)IBOutlet UILabel *lblRatingRate;
@property (strong, nonatomic)IBOutlet UIButton *buttonSubmit;
@end
