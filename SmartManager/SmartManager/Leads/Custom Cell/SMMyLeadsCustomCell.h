//
//  SMMyLeadsCustomCell.h
//  SmartManager
//
//  Created by Liji Stephen on 29/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"

@interface SMMyLeadsCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet SMCustomLable *lblID;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblName;


@property (strong, nonatomic) IBOutlet SMCustomLable *lblVehicleName;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblPhoneNum;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblEmailID;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblTime;

@property (strong, nonatomic) IBOutlet UILabel *lblEmailSeparator;

@property (strong, nonatomic) IBOutlet UIView *lblRowSeparator;

@property (strong, nonatomic) IBOutlet UIView *viewNameSeparator;




@end
