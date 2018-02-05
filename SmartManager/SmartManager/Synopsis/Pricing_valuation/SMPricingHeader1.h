//
//  SMPricingHeader1.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 22/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAutolayoutLightLabel.h"
#import "SMCustomButtonBlue.h"

@interface SMPricingHeader1 : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet SMAutolayoutLightLabel *lblTrade;
@property (strong, nonatomic) IBOutlet SMAutolayoutLightLabel *lblMarket;
@property (strong, nonatomic) IBOutlet SMAutolayoutLightLabel *lblRetail;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnFetch;
//@property (strong, nonatomic) IBOutlet UIButton *btnRefreshTrade;
//@property (strong, nonatomic) IBOutlet UIButton *btnRefreshMarket;
//@property (strong, nonatomic) IBOutlet UIButton *btnRefreshRetail;
@property (strong, nonatomic) IBOutlet UIButton *btnRefreshRightMost;
@property (strong, nonatomic) IBOutlet UIImageView *imgArrow;

@end
