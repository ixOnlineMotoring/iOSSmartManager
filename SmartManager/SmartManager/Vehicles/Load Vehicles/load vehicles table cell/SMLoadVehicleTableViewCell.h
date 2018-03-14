//
//  SMLoadVehicleTableViewCell.h
//  SmartManager
//
//  Created by Priya on 15/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMLoadVehicleTableViewCell : UITableViewCell

@property(strong,nonatomic)IBOutlet UILabel *lblMakeName;


// for variant listing only
@property(strong,nonatomic)IBOutlet UILabel *lableVariantName;
@property(strong,nonatomic)IBOutlet UILabel *lableVarinatCodeWithyear;


@end
