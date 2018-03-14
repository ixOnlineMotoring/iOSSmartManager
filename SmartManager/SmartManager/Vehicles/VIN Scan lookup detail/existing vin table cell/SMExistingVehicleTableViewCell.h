//
//  SMExistingVehicleTableViewCell.h
//  SmartManager
//
//  Created by Priya on 31/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMtextFiledWithoutBorder.h"
@interface SMExistingVehicleTableViewCell : UITableViewCell<UITextFieldDelegate>

@property(strong,nonatomic)IBOutlet UILabel *lblTitle;
@property(strong,nonatomic)IBOutlet UILabel *lblDescription;
@property(strong,nonatomic)IBOutlet SMtextFiledWithoutBorder *txtDescription;



@end
