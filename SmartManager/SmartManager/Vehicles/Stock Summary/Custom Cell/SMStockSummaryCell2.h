//
//  SMStockSummaryCell2.h
//  Smart Manager
//
//  Created by Ketan Nandha on 06/10/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMStockSummaryCell2 : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblActiveVehs;

@property (strong, nonatomic) IBOutlet UILabel *lblActivePics;

@property (strong, nonatomic) IBOutlet UILabel *lblActiveVideo;

@property (strong, nonatomic) IBOutlet UILabel *lblActiveMan;

@property (strong, nonatomic) IBOutlet UILabel *lblExcludedVehs;

@property (strong, nonatomic) IBOutlet UILabel *lblExcludedPics;

@property (strong, nonatomic) IBOutlet UILabel *lblExcludedVideo;

@property (strong, nonatomic) IBOutlet UILabel *lblExcludedMan;

@property (strong, nonatomic) IBOutlet UILabel *lblInvalidVehs;
@property (strong, nonatomic) IBOutlet UILabel *lblInvalidPics;

@property (strong, nonatomic) IBOutlet UILabel *lblInvalidVideo;
@property (strong, nonatomic) IBOutlet UILabel *lblInvalidMan;

@property (strong, nonatomic) IBOutlet UILabel *lblVehsTotal;

@property (strong, nonatomic) IBOutlet UILabel *lblPicsTotal;

@property (strong, nonatomic) IBOutlet UILabel *lblVideoTotal;

@property (strong, nonatomic) IBOutlet UILabel *lblManTotal;

@property (strong, nonatomic) IBOutlet UILabel *lblVehicleType;




@end
