//
//  SMSynopsisVehicleExtrasViewCell.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 12/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"

@interface SMSynopsisVehicleExtrasViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet SMCustomTextField *txtDetails;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtPrice;

@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnCheckBox;


@end
