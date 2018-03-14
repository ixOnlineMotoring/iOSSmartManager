//
//  SMStockListCell.h
//  SmartManager
//
//  Created by Liji Stephen on 29/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMStockListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblVehicleName;
@property (weak, nonatomic) IBOutlet UILabel *lbVehicleDetails1;
@property (weak, nonatomic) IBOutlet UILabel *lbVehicleDetails2;

@property (strong, nonatomic) IBOutlet UIView *viewContainerExtrasComments;

@property (weak, nonatomic) IBOutlet UILabel *lblExtras;
@property (weak, nonatomic) IBOutlet UILabel *lblComments;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotos;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotoCount;
@property (weak, nonatomic) IBOutlet UILabel *lblVideos;

@property (weak, nonatomic) IBOutlet UILabel *lblExtrasImage;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentsImage;
@property (weak, nonatomic) IBOutlet UILabel *lblVideosImage;

@property (strong, nonatomic) IBOutlet UIView *underlineView;

@property (weak, nonatomic) IBOutlet UIView *viewContainingPrice;


@property (weak, nonatomic) IBOutlet UILabel *lblPriceRetail;

@property (weak, nonatomic) IBOutlet UILabel *lblPriceTrade;

@property (weak, nonatomic) IBOutlet UIView *viewContainingTraderPrice;


@property (strong, nonatomic) IBOutlet UILabel *lblNotes;

@property (strong, nonatomic) IBOutlet UILabel *lblVariantName;

@property (strong, nonatomic) IBOutlet UILabel *lblVariantDetails;
@property (strong, nonatomic) IBOutlet UILabel *lblPriceSeparator;

@property (strong, nonatomic) IBOutlet UILabel *lblTrdTitle;



@end
