//
//  SMSMSynopsisTableHeaderCell.h
//  Smart Manager
//
//  Created by Sandeep on 29/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSMSynopsisTableHeaderCell : UITableViewCell
@property (weak, nonatomic)IBOutlet UILabel *vechicleName;
@property (weak, nonatomic)IBOutlet UILabel *vechicleDesciption;
@property (weak, nonatomic)IBOutlet UIImageView *vechicleImage;

@property (strong, nonatomic) IBOutlet UIButton *btnVehicleImage;


@end
