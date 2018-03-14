//
//  SMNotificationTableViewCell.h
//  SmartManager
//
//  Created by Jignesh on 29/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelBold.h"
#import "SMCustomLable.h"


@interface SMNotificationTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet SMCustomLable *lblUserName;

@property(nonatomic,strong)IBOutlet SMCustomLable *lblUserPhone;

@property(nonatomic,strong)IBOutlet SMCustomLable *lblUserEmail;

@property(nonatomic,strong)IBOutlet SMCustomLable *lblVehicleDetails;



@property(nonatomic,strong)IBOutlet SMCustomLable *lblLeadID;

@property(nonatomic,strong)IBOutlet SMCustomLable *lblTime;

@end
