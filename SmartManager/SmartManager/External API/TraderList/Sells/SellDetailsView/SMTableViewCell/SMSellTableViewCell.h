//
//  SMSellTableViewCell.h
//  SmartManager
//
//  Created by Ketan Nandha on 11/12/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelBold.h"

@interface SMSellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet SMCustomLabelBold *lblVehiclePrice;
@property (strong, nonatomic) IBOutlet SMCustomLabelBold *lblVehicleSpacing;
@property (strong, nonatomic) IBOutlet SMCustomLabelBold *lblVehicleName;
@property (strong, nonatomic) IBOutlet SMCustomLabelBold *lblVehicleRejected;
@property (strong, nonatomic) IBOutlet SMCustomLabelBold *lblVehicleDetail;
@property (strong, nonatomic) IBOutlet SMCustomLabelBold *lblVehicleDetailSpacing;
@property (strong, nonatomic) IBOutlet SMCustomLabelBold *lblVehicleDate;

@property (strong, nonatomic) IBOutlet UIButton *btnRadio;

@property (strong, nonatomic) IBOutlet UIView *viewUnderline;

@end
