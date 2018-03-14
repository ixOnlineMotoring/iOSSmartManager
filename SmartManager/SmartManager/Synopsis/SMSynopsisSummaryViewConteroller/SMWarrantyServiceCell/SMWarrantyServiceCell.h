//
//  SMWarrantyServiceCell.h
//  Smart Manager
//
//  Created by Sandeep on 21/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMWarrantyServiceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *warrantyLabel;
@property (weak, nonatomic) IBOutlet UILabel *servicePlanLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceIntervalsLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightC_Warranty;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightC_ServicePlan;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightC_ServiceInterval;





@end
