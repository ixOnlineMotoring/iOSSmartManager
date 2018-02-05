//
//  SMTraderViewTableViewCell.h
//  SmartManager
//
//  Created by Jignesh on 07/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelBold.h"

@interface SMTraderViewTableViewCell : UITableViewCell

@property(weak, nonatomic)  IBOutlet SMCustomLabelBold      *labelVehicleName;
@property(weak, nonatomic)  IBOutlet SMCustomLabelBold      *labelVehicleMileage;
@property(weak, nonatomic)  IBOutlet SMCustomLabelBold      *labelVehicleColor;
@property(weak, nonatomic)  IBOutlet SMCustomLabelBold      *labelVehicleLocation;
@property(weak, nonatomic)  IBOutlet SMCustomLabelBold      *labelVehicleCost;
@property(weak, nonatomic)  IBOutlet SMCustomLabelBold      *labelTradeTimeLeft;
@property (weak, nonatomic) IBOutlet SMCustomLabelBold      *labelMyBidValue;
@property (weak, nonatomic) IBOutlet SMCustomLabelBold      *lblWinningBeaten;

@property(weak, nonatomic)  IBOutlet UIImageView      *imageVehicle;
@property(weak, nonatomic)  IBOutlet UIImageView      *imageViewBuyItNow;
@property(strong, nonatomic)  IBOutlet UIButton        *buttonImageClickable;
@property(weak, nonatomic)  IBOutlet UIView           *viewBaseLine;

@end
