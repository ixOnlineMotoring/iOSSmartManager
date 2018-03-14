//
//  SMPhotosAndExtrasTableViewCell.h
//  SmartManager
//
//  Created by Sandeep on 03/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMConstants.h"

@interface SMPhotosAndExtrasTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblVehicleName;
@property (weak, nonatomic) IBOutlet UILabel *lblRegistration;

@property (weak, nonatomic) IBOutlet UILabel *lblColour;
@property (weak, nonatomic) IBOutlet UILabel *lblStockCode;

@property (weak, nonatomic) IBOutlet UILabel *lblMileage;
@property (weak, nonatomic) IBOutlet UILabel *lblRemaingDaysCount;
@property (weak, nonatomic) IBOutlet UILabel *lblExtras;
@property (weak, nonatomic) IBOutlet UILabel *lblComments;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotos;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotoCount;
@property (weak, nonatomic) IBOutlet UILabel *lblVideos;
@property (weak, nonatomic) IBOutlet UILabel *lblVehicleType;

@property (weak, nonatomic) IBOutlet UILabel *lblRetailPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblTradePrice;


@property (weak, nonatomic) IBOutlet UILabel *lblExtrasImage;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentsImage;
@property (weak, nonatomic) IBOutlet UILabel *lblVideosImage;

@property (strong, nonatomic) IBOutlet UIView *underlineView;

@end
