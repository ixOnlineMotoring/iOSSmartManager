//
//  SMPricing_ValuationHeaderView.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 20/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelAutolayout.h"
#import "SMCustomButtonBlue.h"

@interface SMPricing_ValuationHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet SMCustomLabelAutolayout *lblTrade;
@property (strong, nonatomic) IBOutlet SMCustomLabelAutolayout *lblMarket;
@property (strong, nonatomic) IBOutlet SMCustomLabelAutolayout *lblRetail;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnFetch;
@property (strong, nonatomic) IBOutlet UIButton *btnRefresh;
@property (strong, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UILabel *lblSeparator;

//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConstraintButtonRefresh;



@end
