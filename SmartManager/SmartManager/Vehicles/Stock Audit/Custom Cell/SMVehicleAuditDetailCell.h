//
//  SMVehicleAuditDetailCell.h
//  SmartManager
//
//  Created by Liji Stephen on 06/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"

// this is a change

@interface SMVehicleAuditDetailCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet SMCustomLable *lblVinNum;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblVehicleDetails;


@property (strong, nonatomic) IBOutlet SMCustomLable *lblVehicleName;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblStockNum;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblTime;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblStockType;

@property (strong, nonatomic) IBOutlet UICollectionView *sliderCollection;

@end
