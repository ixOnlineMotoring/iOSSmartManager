//
//  SMWantedDetailTableViewCell.h
//  SmartManager
//
//  Created by Ketan Nandha on 04/03/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelBold.h"

@interface SMWantedDetailTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView       *imageVehicle;
@property (nonatomic,strong) IBOutlet UIButton          *buttonImageClickable;
@property (nonatomic,strong) IBOutlet UILabel           *lblUnderline;

@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleName;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleMileage;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleColour;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleLocation;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleAmount;

@end
