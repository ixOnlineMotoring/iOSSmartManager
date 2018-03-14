//
//  SMSettings_MembersCell.h
//  Smart Manager
//
//  Created by Sandeep on 05/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSettings_MembersCell : UITableViewCell

@property (weak, nonatomic)IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic)IBOutlet UILabel *tradeBuyLabel;
@property (weak, nonatomic)IBOutlet UILabel *tradeSellLabel;
@property (weak, nonatomic)IBOutlet UILabel *tradeAcceptLabel;
@property (weak, nonatomic)IBOutlet UILabel *tradeDeclineLabel;
@property (weak, nonatomic)IBOutlet UILabel *tradeMgrLabel;
@property (weak, nonatomic)IBOutlet UILabel *tradeAuditorLabel;
@property (weak, nonatomic)IBOutlet UIButton *editButton;
@end
