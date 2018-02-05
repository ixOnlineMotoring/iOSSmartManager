//
//  SMTradePartnersCell.h
//  Smart Manager
//
//  Created by Sandeep on 06/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMTradePartnersCell : UITableViewCell
@property (weak, nonatomic)IBOutlet UILabel *partnerNameLabel;
@property (weak, nonatomic)IBOutlet UILabel *tradeAccessLabel;
@property (weak, nonatomic)IBOutlet UILabel *tenderAccessLabel;
@property (weak, nonatomic)IBOutlet UIButton *editButton;
@end
