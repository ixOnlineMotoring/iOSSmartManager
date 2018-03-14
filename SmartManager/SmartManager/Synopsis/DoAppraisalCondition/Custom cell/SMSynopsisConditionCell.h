//
//  SMSynopsisConditionCell.h
//  Smart Manager
//
//  Created by Ketan Nandha on 16/01/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSynopsisConditionCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblConditionName;
@property (strong, nonatomic) IBOutlet UIButton *radioBtnYes;

@property (strong, nonatomic) IBOutlet UIButton *radioBtnNo;

@property (strong, nonatomic) IBOutlet UIButton *radioBtnLow;

@property (strong, nonatomic) IBOutlet UIView *viewContainingLow;




@end
