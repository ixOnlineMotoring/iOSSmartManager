//
//  SMSaveAppraisalsViewCell.h
//  Smart Manager
//
//  Created by Sandeep on 21/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSaveAppraisalsViewCell : UITableViewCell
@property (weak,nonatomic)IBOutlet UILabel *vehicleName;
@property (weak,nonatomic)IBOutlet UILabel *lblVehicleDetails1;
@property (weak,nonatomic)IBOutlet UILabel *lblVehicleDetails2;
@property (weak,nonatomic)IBOutlet UIButton *deleteButton;
@property (weak,nonatomic)IBOutlet UIButton *viewButton;
@end
