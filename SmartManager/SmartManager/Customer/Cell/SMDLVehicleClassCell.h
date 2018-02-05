//
//  SMDLVehicleClassCell.h
//  SmartManager
//
//  Created by Liji Stephen on 16/07/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMDLVehicleClassCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIView *viewContainingVehicleClass;


@property (strong, nonatomic) IBOutlet UILabel *lblVehicleClassName;

@property (strong, nonatomic) IBOutlet UILabel *lblRestrictions;

@property (strong, nonatomic) IBOutlet UILabel *lblIssued;

@property (strong, nonatomic) IBOutlet UIImageView *imgViewVehicleClass;


@property (strong, nonatomic) IBOutlet UILabel *lblRestrictionsValue;

@property (strong, nonatomic) IBOutlet UILabel *lblIssuedDateValue;




@end
