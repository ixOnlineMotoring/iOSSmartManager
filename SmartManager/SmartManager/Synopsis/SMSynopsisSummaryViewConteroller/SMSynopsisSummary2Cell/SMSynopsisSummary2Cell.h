//
//  SMSynopsisSummaryCell.h
//  Smart Manager
//
//  Created by Sandeep on 21/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomButtonBlue.h"

@interface SMSynopsisSummary2Cell : UITableViewCell
@property (strong, nonatomic)IBOutlet UIView *objContentView;
@property (strong, nonatomic)IBOutlet UILabel *titleLabel;;
@property (weak, nonatomic) IBOutlet UILabel *pricingLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketLabel;
@property (weak, nonatomic) IBOutlet UILabel *retailLabel;

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnScanVIN;



@end
