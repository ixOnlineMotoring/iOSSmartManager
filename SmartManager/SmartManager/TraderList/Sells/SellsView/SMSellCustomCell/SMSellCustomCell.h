//
//  SMSellCustomCell.h
//  SmartManager
//
//  Created by Ketan Nandha on 06/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"
#import "SMCustomLabelBold.h"

@interface SMSellCustomCell : UITableViewCell

@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleName;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleMileage;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleColour;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleLocation;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleAmount;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleTime;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold  *lblUnderline;

@end
