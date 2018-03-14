//
//  SMWantedTableViewCell.h
//  SmartManager
//
//  Created by Ketan Nandha on 23/02/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelBold.h"
#import "SWTableViewCell.h"

@interface SMWantedTableViewCell : SWTableViewCell<SWTableViewCellDelegate>

@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleName;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblRegionDetail;
@property (nonatomic,strong) IBOutlet UIButton *btnSearch;
@property (nonatomic,strong) NSIndexPath  *indexPathCell;

@end
