//
//  SMChangeVehicleViewCell.h
//  Smart Manager
//
//  Created by Sandeep on 21/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextFieldForDropDown.h"
#import "SMCustomButtonBlue.h"

@interface SMChangeVehicleViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtYear;
@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtMake;
@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtModel;
@property (strong, nonatomic) IBOutlet SMCustomTextFieldForDropDown *txtVariant;

@property (weak, nonatomic) IBOutlet SMCustomButtonBlue *btnUpdateVehicle;


- (IBAction)btnClearDidClicked:(id)sender;



@end
